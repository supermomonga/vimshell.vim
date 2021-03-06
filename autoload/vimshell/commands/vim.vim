"=============================================================================
" FILE: vim.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 16 Sep 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:command_vim = {
      \ 'name' : 'vim',
      \ 'kind' : 'internal',
      \ 'description' : 'vim [{filename}]',
      \}
function! s:command_vim.execute(args, context) "{{{
  let [args, options] = vimshell#parser#getopt(a:args, {
        \ 'arg=' : ['--split'],
        \ }, {
        \ '--split' : g:vimshell_split_command,
        \ })

  " Save current directiory.
  let cwd = getcwd()

  let [new_pos, old_pos] = vimshell#helpers#split(options['--split'])

  for filename in empty(args) ?
        \ [a:context.fd.stdin] : args
    try
      if filename == ''
        silent enew
      else
        silent edit `=filename`
      endif
    catch
      echohl Error | echomsg v:errmsg | echohl None
    endtry
  endfor

  let [new_pos[2], new_pos[3]] = [bufnr('%'), getpos('.')]

  call vimshell#cd(cwd)

  call vimshell#helpers#restore_pos(old_pos)

  if has_key(a:context, 'is_single_command')
        \ && a:context.is_single_command
    call vimshell#next_prompt(a:context, 0)
    call vimshell#helpers#restore_pos(new_pos)
    stopinsert
  endif
endfunction"}}}

function! vimshell#commands#vim#define()
  let s:command_vi = deepcopy(s:command_vim)
  let s:command_vi.name = 'vi'
  let s:command_vi.description = 'vi [{filename}]'

  return [s:command_vim, s:command_vi]
endfunction
