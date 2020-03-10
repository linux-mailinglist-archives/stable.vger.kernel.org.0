Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026A4180934
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgCJUbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:31:23 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37073 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgCJUbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:31:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id z12so6834772pgl.4
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 13:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SXv613ohwLZhXYr9jit6ve5UEm0jQz5ZLBUY3A1Qh/4=;
        b=XK1ouSvIn1SrXrpE2jB7fPZ97wuSynEPpj4HhSXMNSXZWl5ShAjfCYXT5irwpY6R5K
         GhTb4r+GBtdXtwQ7AqZpQT4zG1MOZvavI8l7jKs0+HzwzxDheOxB6TKArYWjMCD7s5Ob
         TsIYA2DD/9E+2ADf9dPVRUDESK4sdz6wOBd0k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SXv613ohwLZhXYr9jit6ve5UEm0jQz5ZLBUY3A1Qh/4=;
        b=rR/sooBAOblRvRR2Prex/xumED95Z/f3IcxhxVs94ez6L1GmUfkmYKgAaJQhyLwY7R
         cvyfPUZ+pA873VWvPqOkcYqwh9bEp/bzpa4j2G2aJTGo7vI3UA1zcMKYfTiTO7wR90TH
         5pfYo6Lvdi1pU1e3BXBZbZpWd5+3MB1GIBJ98d3qy9FErQ4scLHzd+Px3sYJmf8oJdea
         aUzL7vmYknovSq/rHOn2n0jbSaMFo8qXqq+wbozZObjDJec4ubk4MBhiXrgTBOMMwR52
         WwNJO/e0VDfQzuYKO7PYIvc8itXkfW+aaBm9utkCpiD1WLn3Am5igkJhZyHVljm6Ox4o
         AnnQ==
X-Gm-Message-State: ANhLgQ3VVjwPBurjwBs8woBc+q1EOQMLxotc8yUXz8FyM/EPJQ9gkEa2
        8/cZYIZQjAI5zcLwtboCysXNrg==
X-Google-Smtp-Source: ADFU+vui/SI7xY/RL6zB2m7oqlqxvwNncXDyzP64Ny/XUIARUXO4zMninrFbDKhmtcjQIv0QBej9OQ==
X-Received: by 2002:a63:fc18:: with SMTP id j24mr21853810pgi.16.1583872279279;
        Tue, 10 Mar 2020 13:31:19 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d3sm2205705pfq.126.2020.03.10.13.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 13:31:18 -0700 (PDT)
Date:   Tue, 10 Mar 2020 13:31:17 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] exec: Move cleanup of posix timers on exec out of
 de_thread
Message-ID: <202003101329.08B332F@keescook>
References: <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 08, 2020 at 04:36:55PM -0500, Eric W. Biederman wrote:
> 
> These functions have very little to do with de_thread move them out
> of de_thread an into flush_old_exec proper so it can be more clearly
> seen what flush_old_exec is doing.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/exec.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index ff74b9a74d34..215d86f77b63 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1189,11 +1189,6 @@ static int de_thread(struct task_struct *tsk)
>  	/* we have changed execution domain */
>  	tsk->exit_signal = SIGCHLD;
>  
> -#ifdef CONFIG_POSIX_TIMERS
> -	exit_itimers(sig);
> -	flush_itimer_signals();
> -#endif
> -
>  	BUG_ON(!thread_group_leader(tsk));
>  	return 0;
>  
> @@ -1277,6 +1272,11 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	if (retval)
>  		goto out;
>  
> +#ifdef CONFIG_POSIX_TIMERS
> +	exit_itimers(me->signal);
> +	flush_itimer_signals();
> +#endif
> +

I twitch at seeing #ifdefs in .c instead of hidden in the .h declarations
of these two functions, but as this is a copy/paste, I'll live. ;)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

>  	/*
>  	 * Make the signal table private.
>  	 */
> -- 
> 2.25.0
> 

-- 
Kees Cook
