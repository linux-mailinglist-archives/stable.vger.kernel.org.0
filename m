Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD4B3180968
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgCJUoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:44:12 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35849 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgCJUoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:44:12 -0400
Received: by mail-pl1-f194.google.com with SMTP id g12so5919338plo.3
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 13:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=099TGIbMGOF3GLWL/lcf16vXSWx45mM4eXf6iexqK48=;
        b=eHf9WnjYVqdE3DUP7usldr/Zn8V1+Arq8UsrYtew5+29RS2x609pIGI1hnVIsnD1a7
         Xw7DIDoceUaWSr8wHASF9JD5ass2A0tQ6Fz8HXxuf2yNUsJvmiWSpk2Sp3FUBjBm7vzs
         U0PMba7d6qyGRdRQBOV5q7h2Qx2RgU6AzQn3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=099TGIbMGOF3GLWL/lcf16vXSWx45mM4eXf6iexqK48=;
        b=bxoHmfZ8xV88yEsKXHfBQEsJGC+WLG83yIbtrVVfkZ6JIGQBu/0tEKMNA2k+2OAc49
         vV1hid/idllZV/IrToGWjVNQKMGeH6B0Aq4i0A5uhgyCGf1525ZUCLbqEC6oAwssTI7Z
         Y6CjlxZzVEJkklPi39DQ4DkK8yDwEsKXKPSzjivFexlohBdsFJPaBb+1d8hmjiomrSou
         Pbv2iWotHjqE5J9lL3LNHkONn/aDeaNXfx50V/r5wD4LeA9SygmZh9+qWBdB4gatc2iA
         Eptb76L+mx+WjQCz7dpA0/zLg+nEvGqJDFCw16PS91N1RIqUmyDWyYHjy2fXTpr0NZO3
         KyrA==
X-Gm-Message-State: ANhLgQ0nBfhmbMxq97WVZFQQOmeWO6VKKmmPvt5pLyQl3G5qmViAZjLv
        ERXLUu+f9ySIVtKnnduy53ObdA==
X-Google-Smtp-Source: ADFU+vueXlCI7IpLmS/tzrctbYyGFJWCavdSXGaTgdpbGe7iJ4PA/I36iG3t3Co2w1uOjvrwaTysEw==
X-Received: by 2002:a17:902:ac83:: with SMTP id h3mr22299518plr.86.1583873050871;
        Tue, 10 Mar 2020 13:44:10 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w206sm6074394pfc.54.2020.03.10.13.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 13:44:10 -0700 (PDT)
Date:   Tue, 10 Mar 2020 13:44:09 -0700
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
Subject: Re: [PATCH v2 4/5] exec: Move exec_mmap right after de_thread in
 flush_old_exec
Message-ID: <202003101337.AC1A30576@keescook>
References: <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <875zfe5xzb.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zfe5xzb.fsf_-_@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 08, 2020 at 04:38:00PM -0500, Eric W. Biederman wrote:
> 
> I have read through the code in exec_mmap and I do not see anything
> that depends on sighand or the sighand lock, or on signals in anyway
> so this should be safe.
> 
> This rearrangement of code has two siginficant benefits.  It makes
> the determination of passing the point of no return by testing bprm->mm
> accurate.  All failures prior to that point in flush_old_exec are
> either truly recoverable or they are fatal.

Agreed. Though I see a use of "current", which maybe you want to
parameterize to a "me" argument in acct_arg_size(). (Though looking at
the callers, perhaps there is no benefit?)

> 
> Futher this consolidates all of the possible indefinite waits for
> userspace together at the top of flush_old_exec.  The possible wait
> for a ptracer on PTRACE_EVENT_EXIT, the possible wait for a page fault
> to be resolved in clear_child_tid, and the possible wait for a page
> fault in exit_robust_list.
> 
> This consolidation allows the creation of a mutex to replace
> cred_guard_mutex that is not held of possible indefinite userspace
> waits.  Which will allow removing deadlock scenarios from the kernel.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/exec.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 215d86f77b63..d820a7272a76 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1272,18 +1272,6 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	if (retval)
>  		goto out;
>  
> -#ifdef CONFIG_POSIX_TIMERS
> -	exit_itimers(me->signal);
> -	flush_itimer_signals();
> -#endif

I think this comment:

/*
 * This is called by do_exit or de_thread, only when there are no more
 * references to the shared signal_struct.
 */
void exit_itimers(struct signal_struct *sig)

Refers to there being other threads, yes? Not that the signal table is
private yet?

> -
> -	/*
> -	 * Make the signal table private.
> -	 */
> -	retval = unshare_sighand(me);
> -	if (retval)
> -		goto out;
> -
>  	/*
>  	 * Must be called _before_ exec_mmap() as bprm->mm is
>  	 * not visibile until then. This also enables the update
> @@ -1307,6 +1295,18 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	 */
>  	bprm->mm = NULL;
>  
> +#ifdef CONFIG_POSIX_TIMERS
> +	exit_itimers(me->signal);
> +	flush_itimer_signals();
> +#endif

I've mostly convinced myself that there are no "side-effects" from having
these timers expire as the mm is going away. I think some kind of comment
of that intent should be explicitly stated here above the timer work.

Beyond that:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> +
> +	/*
> +	 * Make the signal table private.
> +	 */
> +	retval = unshare_sighand(me);
> +	if (retval)
> +		goto out;
> +
>  	set_fs(USER_DS);
>  	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>  					PF_NOFREEZE | PF_NO_SETAFFINITY);
> -- 
> 2.25.0
> 

-- 
Kees Cook
