Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88ABA53CBC3
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 16:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiFCOvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 10:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiFCOvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 10:51:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CAA13F9D;
        Fri,  3 Jun 2022 07:50:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7DFDB82345;
        Fri,  3 Jun 2022 14:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03442C385B8;
        Fri,  3 Jun 2022 14:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654267856;
        bh=Loo+eR1jL+X8O8VaZAHx+/ptX+/WuXg0POlWL1UADwg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CNNCKNvbxbyvV1+wAUK9F/ptTxn1IfR3hq5aQSXNSNiCdiqitF6/puKn2rrp0z4e7
         Biuy6ld2FcY2YXE9eKa4P64gFPKb6qzwtYMLQ8UaNvHWX35KZZuX52XctZ3JlI1aXK
         qZloZzJpEjlj26pcw+gEap255RLSIXIy63hM8HnY=
Date:   Fri, 3 Jun 2022 16:50:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 4.9.y] exec: Force single empty string when argv is empty
Message-ID: <YpofzcMaOWneccCp@kroah.com>
References: <164890338266171@kroah.com>
 <20220601101226.1498-1-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601101226.1498-1-vegard.nossum@oracle.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 01, 2022 at 12:12:26PM +0200, Vegard Nossum wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> commit dcd46d897adb70d63e025f175a00a89797d31a43 upstream.
> 
> Quoting[1] Ariadne Conill:
> 
> "In several other operating systems, it is a hard requirement that the
> second argument to execve(2) be the name of a program, thus prohibiting
> a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
> but it is not an explicit requirement[2]:
> 
>     The argument arg0 should point to a filename string that is
>     associated with the process being started by one of the exec
>     functions.
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
>     process './argc0' launched './argc0' with NULL argv: empty string added
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
> Acked-by: Christian Brauner <brauner@kernel.org>
> Acked-by: Ariadne Conill <ariadne@dereferenced.org>
> Acked-by: Andy Lutomirski <luto@kernel.org>
> Link: https://lore.kernel.org/r/20220201000947.2453721-1-keescook@chromium.org
> [vegard: fixed conflicts due to missing
>  886d7de631da71e30909980fdbf318f7caade262^- and
>  3950e975431bc914f7e81b8f2a2dbdf2064acb0f^- and
>  655c16a8ce9c15842547f40ce23fd148aeccc074]
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  fs/exec.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> This has been tested in both argc == 0 and argc >= 1 cases, but I would
> still appreciate a review given the differences with mainline. If it's
> considered too risky I'm also fine with dropping it -- just wanted to
> make sure this didn't fall through the cracks, as it does block a real
> (albeit old by now) exploit.
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 482a8b4f41a5b..19f8b075d3b6b 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1758,6 +1758,9 @@ static int do_execveat_common(int fd, struct filename *filename,
>  		goto out_unmark;
>  
>  	bprm->argc = count(argv, MAX_ARG_STRINGS);
> +	if (bprm->argc == 0)
> +		pr_warn_once("process '%s' launched '%s' with NULL argv: empty string added\n",
> +			     current->comm, bprm->filename);
>  	if ((retval = bprm->argc) < 0)
>  		goto out;
>  
> @@ -1782,6 +1785,20 @@ static int do_execveat_common(int fd, struct filename *filename,
>  	if (retval < 0)
>  		goto out;
>  
> +	/*
> +	 * When argv is empty, add an empty string ("") as argv[0] to
> +	 * ensure confused userspace programs that start processing
> +	 * from argv[1] won't end up walking envp. See also
> +	 * bprm_stack_limits().
> +	 */
> +	if (bprm->argc == 0) {
> +		const char *argv[] = { "", NULL };
> +		retval = copy_strings_kernel(1, argv, bprm);
> +		if (retval < 0)
> +			goto out;
> +		bprm->argc = 1;
> +	}
> +
>  	retval = exec_binprm(bprm);
>  	if (retval < 0)
>  		goto out;
> -- 
> 2.35.1.46.g38062e73e0
> 

All now queued up, thanks.

greg k-h
