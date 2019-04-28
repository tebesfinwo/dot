call plug#begin(expand('~/.config/nvim/plugged'))
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'sheerun/vim-polyglot'

    Plug 'junegunn/fzf'
    Plug 'tpope/vim-commentary'
    Plug 'vim-airline/vim-airline'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
    Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }

    Plug 'Shougo/echodoc.vim'
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}

    Plug 'rizzatti/dash.vim'
call plug#end()

filetype plugin indent on

let mapleader = ','
let g:mapleader = ','

" Ignore compiled files
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn

if has('win16') || has('win32')
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

set autoindent
set autoread
set backspace=indent,eol,start
set backup
set backupcopy=yes " Not to interfere the recompilation.
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set encoding=utf8
set expandtab
set history=700
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set magic
set mat=2
set matchpairs+=<:>
set matchtime=2
set noerrorbells
set novisualbell
set number
set ruler
set shiftround
set shiftwidth=4
set showcmd
set showmatch
set showmode
set si
set smartcase
set softtabstop=4
set splitbelow
set splitright
set tabstop=4
set textwidth=79
set tm=500
set wrap
set writebackup
set t_ut=

" Neovim 0.4.x
set wildoptions=pum

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

syntax on " enable syntax processing
colorscheme dracula

let python_highlight_all = 1

augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType c,cpp,haskell,python,php autocmd BufWritePre <buffer> %s/\s\+$//e

    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4

    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4

    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal commentstring=#\ %s

    autocmd FileType python setlocal commentstring=#\ %s
    autocmd FileType python setlocal completeopt-=preview
    autocmd FileType python setlocal textwidth=119

    autocmd BufEnter *.cls setlocal filetype=java

    autocmd BufEnter *.zsh-theme setlocal filetype=zsh

    autocmd BufEnter Makefile setlocal noexpandtab

    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2

    autocmd BufEnter *.hy setlocal tabstop=2
    autocmd BufEnter *.hy setlocal shiftwidth=2
    autocmd BufEnter *.hy setlocal softtabstop=2

    autocmd BufEnter *.js setlocal tabstop=2
    autocmd BufEnter *.js setlocal shiftwidth=2
    autocmd BufEnter *.js setlocal softtabstop=2

    autocmd BufEnter *.ml setlocal tabstop=2
    autocmd BufEnter *.ml setlocal shiftwidth=2
    autocmd BufEnter *.ml setlocal softtabstop=2

    autocmd BufEnter *.yaml setlocal tabstop=2
    autocmd BufEnter *.yaml setlocal shiftwidth=2
    autocmd BufEnter *.yaml setlocal softtabstop=2

    autocmd FileType haskell setlocal tabstop=2
    autocmd FileType haskell setlocal shiftwidth=2
    autocmd FileType haskell setlocal softtabstop=2

    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd FileType markdown setlocal spell
    autocmd FileType markdown setlocal tabstop=2
    autocmd FileType markdown setlocal shiftwidth=2
    autocmd FileType markdown setlocal softtabstop=2
    autocmd BufRead,BufNewFile *.md setlocal textwidth=80

    autocmd FileType python,haskell call SetLSPShortcuts()
augroup END


nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Nerd Tree
let g:NERDTreeWinPos = 'left'
let NERDTreeIgnore = ['\.pyc$']
let g:NERDTreeWinSize=35
map <C-n> :NERDTreeToggle<CR>

" Deoplete for NeoVim
let g:deoplete#enable_at_startup = 1
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.ocaml = '[.\w]+'
let g:deoplete#omni#input_patterns.reason = '[.\w]+'
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Language client server

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
\   'sh': ['bash-language-server', 'start'],
\   'haskell': ['hie-wrapper'],
\   'python': ['pyls']
\}

function SetLSPShortcuts()
  nnoremap <Leader>le :call LanguageClient#explainErrorAtPoint()<CR>
  nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
  nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
endfunction()

" echodoc
set cmdheight=2
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'signature'

" Airline
let g:airline_theme = 'dracula'

" fzf
let g:fzf_action = {
\   'ctrl-t': 'tab split',
\   'ctrl-x': 'split',
\   'ctrl-v': 'vsplit' }

let g:python_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Navigating of terminal panel
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
