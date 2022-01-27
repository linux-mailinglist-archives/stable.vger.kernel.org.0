Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C85F49DA2B
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 06:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbiA0F3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 00:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbiA0F3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 00:29:04 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B897C06173B
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 21:29:04 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c3so1559738pls.5
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 21:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=beUbO3aZF/2kD/fftJXd1EMY7Ug/jw5Wb5BLQxmuCc0=;
        b=Mkb0P6sWcL3VkVCy3yV8rbOVXIel3FZSZaHpdJ8N0lcjYq6zyx4hUi4mBTLMFaZHeJ
         lQOR0wGzTYdQ3uC9REhaHrWW8kVj+HKmE2/bLDMmx/G+cO0ZRzYvQBxl7fh/1edZVY++
         1c90ytUDBbGfHOe4ubEL896FjJreV4KMOheIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=beUbO3aZF/2kD/fftJXd1EMY7Ug/jw5Wb5BLQxmuCc0=;
        b=zm8J1SkJUQcKqqnDUsFlwMt4FCkEYEru/jetG+M5J7TPSWkgQys0/9HDMxk06+lbw8
         PYUcPf0Y4LetzfYmblc6S5sNBlNjTsoML3Au31GzydAzg4uygwJuhKwEQ9+tlK/fUtf3
         zgnkuaOC2wrbPyxKbmPpUS+8G2rPrvykRK4fgwaB/Gp3WeitC3zveVUnsuNrd0Bd3ooJ
         iJ1px24yn/fNWBDUchTDFwm4L8kmPr3ZJySmYgnDdkElTo0v3E/UXw1P5XkVqZ3V3G+O
         ivNCVdpKUDBz2YTRHlYen7g5Q1ToMdN1xuQd+uxM24j8MoMf3AkERWU2wcKTMw3UQNBO
         1Iew==
X-Gm-Message-State: AOAM531rKnTct4h3oLtnJ9T5HLsIYdhzQuk5Sa72nyX0Ph9YuwnmqOqU
        Wml9fur9RRsnzbexLwZhHP6CxA==
X-Google-Smtp-Source: ABdhPJwXGj2Q6bkytWK59hvGMzK64mkTpY3dYCfOP2HGl0XbWy3r/zGyfAjqVAai7Y4ZsX1k9UxMgw==
X-Received: by 2002:a17:903:2309:: with SMTP id d9mr1768705plh.149.1643261344044;
        Wed, 26 Jan 2022 21:29:04 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n4sm6545740pjf.0.2022.01.26.21.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 21:29:03 -0800 (PST)
Date:   Wed, 26 Jan 2022 21:29:02 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Ariadne Conill <ariadne@dereferenced.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] fs/exec: require argv[0] presence in
 do_execveat_common()
Message-ID: <202201262119.105FA8BCA9@keescook>
References: <20220127000724.15106-1-ariadne@dereferenced.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127000724.15106-1-ariadne@dereferenced.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 12:07:24AM +0000, Ariadne Conill wrote:
> In several other operating systems, it is a hard requirement that the
> second argument to execve(2) be the name of a program, thus prohibiting
> a scenario where argc < 1.  POSIX 2017 also recommends this behaviour,
> but it is not an explicit requirement[0]:
> 
>     The argument arg0 should point to a filename string that is
>     associated with the process being started by one of the exec
>     functions.
> 
> To ensure that execve(2) with argc < 1 is not a useful tool for
> shellcode to use, we can validate this in do_execveat_common() and
> fail for this scenario, effectively blocking successful exploitation
> of CVE-2021-4034 and similar bugs which depend on execve(2) working
> with argc < 1.
> 
> We use -EINVAL for this case, mirroring recent changes to FreeBSD and
> OpenBSD.  -EINVAL is also used by QNX for this, while Solaris uses
> -EFAULT.
> 
> In earlier versions of the patch, it was proposed that we create a
> fake argv for applications to use when argc < 1, but it was concluded
> that it would be better to just fail the execve(2) in these cases, as
> launching a process with an empty or NULL argv[0] was likely to just
> cause more problems.

Let's do it and see what breaks. :)

I do see at least tools/testing/selftests/exec/recursion-depth.c will
need a fix. And maybe testcases/kernel/syscalls/execveat/execveat.h
in LTP.

Acked-by: Kees Cook <keescook@chromium.org>

> 
> Interestingly, Michael Kerrisk opened an issue about this in 2008[1],
> but there was no consensus to support fixing this issue then.
> Hopefully now that CVE-2021-4034 shows practical exploitative use[2]
> of this bug in a shellcode, we can reconsider.
> 
> This issue is being tracked in the KSPP issue tracker[3].
> 
> There are a few[4][5] minor edge cases (primarily in test suites) that
> are caught by this, but we plan to work with the projects to fix those
> edge cases.
> 
> [0]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=8408
> [2]: https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
> [3]: https://github.com/KSPP/linux/issues/176
> [4]: https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
> [5]: https://codesearch.debian.net/search?q=execlp%3F%5Cs*%5C%28%5B%5E%2C%5D%2B%2C%5Cs*NULL&literal=0
> 
> Changes from v2:
> - Switch to using -EINVAL as the error code for this.
> - Use pr_warn_once() to warn when an execve(2) is rejected due to NULL
>   argv.
> 
> Changes from v1:
> - Rework commit message significantly.
> - Make the argv[0] check explicit rather than hijacking the error-check
>   for count().
> 
> Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Rich Felker <dalias@libc.org>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Ariadne Conill <ariadne@dereferenced.org>
> ---
>  fs/exec.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 79f2c9483302..982730cfe3b8 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1897,6 +1897,10 @@ static int do_execveat_common(int fd, struct filename *filename,
>  	}
>  
>  	retval = count(argv, MAX_ARG_STRINGS);
> +	if (retval == 0) {
> +		pr_warn_once("Attempted to run process '%s' with NULL argv\n", bprm->filename);
> +		retval = -EINVAL;
> +	}
>  	if (retval < 0)
>  		goto out_free;
>  	bprm->argc = retval;
> -- 
> 2.34.1
> 

-- 
Kees Cook
