Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9953C180924
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgCJU32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:29:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33140 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgCJU32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:29:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id m5so6846085pgg.0
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 13:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dsBrIU5gUV1pckyA8GSxROnnJLAsyLmC/ypr4CZES9w=;
        b=aVfJW5cxRWyiGAhHyjizHuTpIP1CVGeiD5PpVOAX8E13XOV2zio+KZuEB352+Nm2aP
         Llx5rft1lxfSQ6IyZMXJ54Wa89MxWC2kb8lpY1CeaItXOQO8e4J60iuFcsOvf/0Lj9YI
         lmf6stuUg2ygsiOeBvjwo8agJiJGT80VmqQCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dsBrIU5gUV1pckyA8GSxROnnJLAsyLmC/ypr4CZES9w=;
        b=f3m4jYdz5kUOIkyslrPbzuCRTPcbkShPuu7GcQx8PDd7DIvI8Frrku4VKWg/Jn5Z0u
         TDVcFtXQnYHNnAZYP6KB24eNAk9xQKKT0vdFXX2jOCyH2VlQVtvzYdw8ft5UYq+BnD/T
         gcMa1hLZNNYMWL22KpUTKbk+i6/4w6s+N0xM2ImiMfEFuTdjGg9f3rqP2e2WK4xb1iaX
         lY0+9Mw5aeOLwIJ9GTPf9kUauulijeNwOY0NkDvF9qVV5gRPV/jwIZ5+7rChcOaVq12V
         +BBhnN1ng4QSfyjCrhYWyHD1mlQSaT8JPKrWyasYZapIltmisoRy8PlfADSzquqfRK4e
         UZKA==
X-Gm-Message-State: ANhLgQ0caowqNfzA5oRIGRaGEYtstB3dlDHrz87RxwpyIdvyrkKDzlq5
        663F/P9eMX0SKB0K8QpDPRs3IQ==
X-Google-Smtp-Source: ADFU+vtvXImBX+SYYOzRy21wWe3GqfJUMiYo6Vi8Qk8uuP81efgz5a4jBX0nQr4DVT8wDqrCYZcPwg==
X-Received: by 2002:a63:7f05:: with SMTP id a5mr22593983pgd.327.1583872166829;
        Tue, 10 Mar 2020 13:29:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f4sm13279103pfn.116.2020.03.10.13.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 13:29:25 -0700 (PDT)
Date:   Tue, 10 Mar 2020 13:29:25 -0700
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
Subject: Re: [PATCH v2 2/5] exec: Factor unshare_sighand out of de_thread and
 call it separately
Message-ID: <202003101319.BAE7B535A@keescook>
References: <87v9nlii0b.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74xi4kz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87k13u5y26.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k13u5y26.fsf_-_@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 08, 2020 at 04:36:17PM -0500, Eric W. Biederman wrote:
> 
> This makes the code clearer and makes it easier to implement a mutex
> that is not taken over any locations that may block indefinitely waiting
> for userspace.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/exec.c | 39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index c3f34791f2f0..ff74b9a74d34 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1194,6 +1194,23 @@ static int de_thread(struct task_struct *tsk)
>  	flush_itimer_signals();
>  #endif

Semi-related (existing behavior): in de_thread(), what keeps the thread
group from changing? i.e.:

        if (thread_group_empty(tsk))
                goto no_thread_group;

        /*
         * Kill all other threads in the thread group.
         */
        spin_lock_irq(lock);
	... kill other threads under lock ...

Why is the thread_group_emtpy() test not under lock?

>  
> +	BUG_ON(!thread_group_leader(tsk));
> +	return 0;
> +
> +killed:
> +	/* protects against exit_notify() and __exit_signal() */

I wonder if include/linux/sched/task.h's definition of tasklist_lock
should explicitly gain note about group_exit_task and notify_count,
or, alternatively, signal.h's section on these fields should gain a
comment? tasklist_lock is unmentioned in signal.h... :(

> +	read_lock(&tasklist_lock);
> +	sig->group_exit_task = NULL;
> +	sig->notify_count = 0;
> +	read_unlock(&tasklist_lock);
> +	return -EAGAIN;
> +}
> +
> +
> +static int unshare_sighand(struct task_struct *me)
> +{
> +	struct sighand_struct *oldsighand = me->sighand;
> +
>  	if (refcount_read(&oldsighand->count) != 1) {
>  		struct sighand_struct *newsighand;
>  		/*
> @@ -1210,23 +1227,13 @@ static int de_thread(struct task_struct *tsk)
>  
>  		write_lock_irq(&tasklist_lock);
>  		spin_lock(&oldsighand->siglock);
> -		rcu_assign_pointer(tsk->sighand, newsighand);
> +		rcu_assign_pointer(me->sighand, newsighand);
>  		spin_unlock(&oldsighand->siglock);
>  		write_unlock_irq(&tasklist_lock);
>  
>  		__cleanup_sighand(oldsighand);
>  	}
> -
> -	BUG_ON(!thread_group_leader(tsk));
>  	return 0;
> -
> -killed:
> -	/* protects against exit_notify() and __exit_signal() */
> -	read_lock(&tasklist_lock);
> -	sig->group_exit_task = NULL;
> -	sig->notify_count = 0;
> -	read_unlock(&tasklist_lock);
> -	return -EAGAIN;
>  }
>  
>  char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
> @@ -1264,13 +1271,19 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	int retval;
>  
>  	/*
> -	 * Make sure we have a private signal table and that
> -	 * we are unassociated from the previous thread group.
> +	 * Make this the only thread in the thread group.
>  	 */
>  	retval = de_thread(me);
>  	if (retval)
>  		goto out;
>  
> +	/*
> +	 * Make the signal table private.
> +	 */
> +	retval = unshare_sighand(me);
> +	if (retval)
> +		goto out;
> +
>  	/*
>  	 * Must be called _before_ exec_mmap() as bprm->mm is
>  	 * not visibile until then. This also enables the update
> -- 
> 2.25.0

Otherwise, yes, sensible separation.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
