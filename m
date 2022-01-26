Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CB149D420
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 22:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiAZVIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 16:08:41 -0500
Received: from brightrain.aerifal.cx ([216.12.86.13]:54226 "EHLO
        brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbiAZVIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 16:08:40 -0500
Date:   Wed, 26 Jan 2022 15:52:48 -0500
From:   Rich Felker <dalias@libc.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] fs/binfmt_elf: Add padding NULL when argc == 0
Message-ID: <20220126205247.GA9263@brightrain.aerifal.cx>
References: <20220126175747.3270945-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126175747.3270945-1-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 09:57:47AM -0800, Kees Cook wrote:
> Quoting Ariadne Conill:
> 
> "In several other operating systems, it is a hard requirement that the
> first argument to execve(2) be the name of a program, thus prohibiting
> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
> but it is not an explicit requirement[1]:
> 
>     The argument arg0 should point to a filename string that is
>     associated with the process being started by one of the exec
>     functions.
> ...
> Interestingly, Michael Kerrisk opened an issue about this in 2008[2],
> but there was no consensus to support fixing this issue then.
> Hopefully now that CVE-2021-4034 shows practical exploitative use[3]
> of this bug in a shellcode, we can reconsider."
> 
> An examination of existing[4] users of execve(..., NULL, NULL) shows
> mostly test code, or example rootkit code. While rejecting a NULL argv
> would be preferred, it looks like the main cause of userspace confusion
> is an assumption that argc >= 1, and buggy programs may skip argv[0]
> when iterating. To protect against userspace bugs of this nature, insert
> an extra NULL pointer in argv when argc == 0, so that argv[1] != envp[0].
> 
> Note that this is only done in the argc == 0 case because some userspace
> programs expect to find envp at exactly argv[argc]. The overlap of these
> two misguided assumptions is believed to be zero.
> 
> [1] https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=8408
> [3] https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
> [4] https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
> 
> Reported-by: Ariadne Conill <ariadne@dereferenced.org>
> Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/binfmt_elf.c | 10 +++++++++-
>  fs/exec.c       |  7 ++++++-
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 605017eb9349..e456c48658ad 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -297,7 +297,8 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  	ei_index = elf_info - (elf_addr_t *)mm->saved_auxv;
>  	sp = STACK_ADD(p, ei_index);
>  
> -	items = (argc + 1) + (envc + 1) + 1;
> +	/* Make room for extra pointer when argc == 0. See below. */
> +	items = (min(argc, 1) + 1) + (envc + 1) + 1;
>  	bprm->p = STACK_ROUND(sp, items);
>  
>  	/* Point sp at the lowest address on the stack */
> @@ -326,6 +327,13 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>  
>  	/* Populate list of argv pointers back to argv strings. */
>  	p = mm->arg_end = mm->arg_start;
> +	/*
> +	 * Include an extra NULL pointer in argv when argc == 0 so
> +	 * that argv[1] != envp[0] to help userspace programs from
> +	 * mishandling argc == 0. See fs/exec.c bprm_stack_limits().
> +	 */
> +	if (argc == 0 && put_user(0, sp++))
> +		return -EFAULT;
>  	while (argc-- > 0) {
>  		size_t len;
>  		if (put_user((elf_addr_t)p, sp++))
> diff --git a/fs/exec.c b/fs/exec.c
> index 79f2c9483302..0b36384e55b1 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -495,8 +495,13 @@ static int bprm_stack_limits(struct linux_binprm *bprm)
>  	 * the stack. They aren't stored until much later when we can't
>  	 * signal to the parent that the child has run out of stack space.
>  	 * Instead, calculate it here so it's possible to fail gracefully.
> +	 *
> +	 * In the case of argc < 1, make sure there is a NULL pointer gap
> +	 * between argv and envp to ensure confused userspace programs don't
> +	 * start processing from argv[1], thinking argc can never be 0,
> +	 * to block them from walking envp by accident. See fs/binfmt_elf.c.
>  	 */
> -	ptr_size = (bprm->argc + bprm->envc) * sizeof(void *);
> +	ptr_size = (min(bprm->argc, 1) + bprm->envc) * sizeof(void *);
>  	if (limit <= ptr_size)
>  		return -E2BIG;
>  	limit -= ptr_size;
> -- 
> 2.30.2
> 

This patch is not just wrong, but extremely dangerously wrong, to the
point that it may make all suid-root binaries exploitable (at least
dynamic linked ones).

The ELF entry point contract is that argv+argc+1==envp, and in fact
this is the "preferred" way of computing envp so as to avoid linear
search over argv. In musl's dynamic linker we do exactly that; I'm not
sure about glibc's. See:

https://git.musl-libc.org/cgit/musl/tree/ldso/dynlink.c?id=v1.2.2#n1740

If argv[argc+1] wrongly contains a null pointer, semantically, that
means the environment is empty and auxv starts at the next stack slot.
It's an exercise for the reader to populate the environment in a way
that this memory wrongly gets interpreted as a meaningful auxv. I'm
not sure this is possible, but I wouldn't automatically rule it out.

In short: YOU CANNOT CHANGE/BREAK CONTRACTS TO MITIGATE A VULN. Doing
so just makes new vulns in the programs that were correct before.

Silently replacing argc==0 with argc==1 and argv[0]=="" would be a
safe variant of this, but I'm really in favor of just erroring out,
but *only doing it when the exec is a privilege boundary* (suid/etc.)
to minimize the chance of breaking software dependent on allowing
argc==0.

Rich
