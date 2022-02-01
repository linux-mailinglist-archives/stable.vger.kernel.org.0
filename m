Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CAA4A54F7
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 03:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiBACBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 21:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbiBACAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 21:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC931C06177A;
        Mon, 31 Jan 2022 18:00:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57F606126B;
        Tue,  1 Feb 2022 02:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B874AC3410F;
        Tue,  1 Feb 2022 02:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643680803;
        bh=3PdNMUFDL2c1SaDDgYYpUoeisb94BFr3OOxDIdhXXC0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=P3hFMTo6e331awHrxQmjo08WyXCAMcYy6uoJONB3oRzw+Cta+lFj5utaQOeElGZL4
         nWMl+08Ia3mHljCGJCNLNzXR3ohGkxK6tfQBxWuV3lBr4uUEmRnD5AdJThagnF/gsk
         62B2XJAW/mT9Tlp5tHxgAmXOCkJGOt9QvRyUotZJ4EiaMaelFIN6uZDuyOnQCvBm2J
         D7Aq7kuP2c8Aa618tkQNIgyO/TVux4kFia6T+x5omkuhZj94Yyh70q5z4CNJibFRM4
         dgrRSA0Ebi7amcF3/d3Z5g7X5rsKn8t5G9wRW3ord76iZgoXddkoxIRTs0KjobvN9D
         /yMEk9KeajqVA==
Message-ID: <234f8cb0-8f9c-0caf-c169-cf9355b33075@kernel.org>
Date:   Mon, 31 Jan 2022 18:00:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] exec: Force single empty string when argv is empty
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>
References: <20220201000947.2453721-1-keescook@chromium.org>
From:   Andy Lutomirski <luto@kernel.org>
In-Reply-To: <20220201000947.2453721-1-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/31/22 16:09, Kees Cook wrote:
> Quoting[1] Ariadne Conill:
> 
> "In several other operating systems, it is a hard requirement that the
> second argument to execve(2) be the name of a program, thus prohibiting
> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
> but it is not an explicit requirement[2]:
> 
>      The argument arg0 should point to a filename string that is
>      associated with the process being started by one of the exec
>      functions.
> ...
> Interestingly, Michael Kerrisk opened an issue about this in 2008[3],
> but there was no consensus to support fixing this issue then.
> Hopefully now that CVE-2021-4034 shows practical exploitative use[4]
> of this bug in a shellcode, we can reconsider.
> 
> This issue is being tracked in the KSPP issue tracker[5]."
> 
> While the initial code searches[6][7] turned up what appeared to be
> mostly corner case tests, trying to that just reject argv == NULL
> (or an immediately terminated pointer list) quickly started tripping[8]
> existing userspace programs.
> 
> The next best approach is forcing a single empty string into argv and
> adjusting argc to match. The number of programs depending on argc == 0
> seems a smaller set than those calling execve with a NULL argv.
> 
> Account for the additional stack space in bprm_stack_limits(). Inject an
> empty string when argc == 0 (and set argc = 1). Warn about the case so
> userspace has some notice about the change:
> 
>      process './argc0' launched './argc0' with NULL argv: empty string added
> 
> Additionally WARN() and reject NULL argv usage for kernel threads.
> 
> [1] https://lore.kernel.org/lkml/20220127000724.15106-1-ariadne@dereferenced.org/
> [2] https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=8408
> [4] https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
> [5] https://github.com/KSPP/linux/issues/176
> [6] https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
> [7] https://codesearch.debian.net/search?q=execlp%3F%5Cs*%5C%28%5B%5E%2C%5D%2B%2C%5Cs*NULL&literal=0
> [8] https://lore.kernel.org/lkml/20220131144352.GE16385@xsang-OptiPlex-9020/

Acked-by: Andy Lutomirski <luto@kernel.org>

and cc-ing linux-api.

I agree that this should be done regardless of any security context change.

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
>   fs/exec.c | 26 +++++++++++++++++++++++++-
>   1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 79f2c9483302..bbf3aadf7ce1 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -495,8 +495,14 @@ static int bprm_stack_limits(struct linux_binprm *bprm)
>   	 * the stack. They aren't stored until much later when we can't
>   	 * signal to the parent that the child has run out of stack space.
>   	 * Instead, calculate it here so it's possible to fail gracefully.
> +	 *
> +	 * In the case of argc = 0, make sure there is space for adding a
> +	 * empty string (which will bump argc to 1), to ensure confused
> +	 * userspace programs don't start processing from argv[1], thinking
> +	 * argc can never be 0, to keep them from walking envp by accident.
> +	 * See do_execveat_common().
>   	 */
> -	ptr_size = (bprm->argc + bprm->envc) * sizeof(void *);
> +	ptr_size = (min(bprm->argc, 1) + bprm->envc) * sizeof(void *);
>   	if (limit <= ptr_size)
>   		return -E2BIG;
>   	limit -= ptr_size;
> @@ -1897,6 +1903,9 @@ static int do_execveat_common(int fd, struct filename *filename,
>   	}
>   
>   	retval = count(argv, MAX_ARG_STRINGS);
> +	if (retval == 0)
> +		pr_warn_once("process '%s' launched '%s' with NULL argv: empty string added\n",
> +			     current->comm, bprm->filename);
>   	if (retval < 0)
>   		goto out_free;
>   	bprm->argc = retval;
> @@ -1923,6 +1932,19 @@ static int do_execveat_common(int fd, struct filename *filename,
>   	if (retval < 0)
>   		goto out_free;
>   
> +	/*
> +	 * When argv is empty, add an empty string ("") as argv[0] to
> +	 * ensure confused userspace programs that start processing
> +	 * from argv[1] won't end up walking envp. See also
> +	 * bprm_stack_limits().
> +	 */
> +	if (bprm->argc == 0) {
> +		retval = copy_string_kernel("", bprm);
> +		if (retval < 0)
> +			goto out_free;
> +		bprm->argc = 1;
> +	}
> +
>   	retval = bprm_execve(bprm, fd, filename, flags);
>   out_free:
>   	free_bprm(bprm);
> @@ -1951,6 +1973,8 @@ int kernel_execve(const char *kernel_filename,
>   	}
>   
>   	retval = count_strings_kernel(argv);
> +	if (WARN_ON_ONCE(retval == 0))
> +		retval = -EINVAL;
>   	if (retval < 0)
>   		goto out_free;
>   	bprm->argc = retval;

