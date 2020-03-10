Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1FD5180A44
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgCJVWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:22:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58083 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbgCJVWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:22:02 -0400
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jBmJc-0000N4-9H; Tue, 10 Mar 2020 21:21:28 +0000
Date:   Tue, 10 Mar 2020 22:21:24 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Kees Cook <keescook@chromium.org>,
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
Message-ID: <20200310212124.l6rajcjkitt65fxr@wittgenstein>
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
Content-Type: text/plain; charset=utf-8
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
>  
> +	BUG_ON(!thread_group_leader(tsk));
> +	return 0;
> +
> +killed:
> +	/* protects against exit_notify() and __exit_signal() */
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

This is fine for now but we share an aweful lot of code with
copy_sighand(). We should earmark this to look into consolidating the
core operations into a common helper called from both copy_sighand() and
unshare_sighand() maybe even dumbing it down to one helper. But not
needed for now.

Otherwise:
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
