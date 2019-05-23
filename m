Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C2127FCB
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 16:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfEWOdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 10:33:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730710AbfEWOdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 10:33:49 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD6DE307DA31;
        Thu, 23 May 2019 14:33:48 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7691E620DF;
        Thu, 23 May 2019 14:33:44 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 23 May 2019 16:33:46 +0200 (CEST)
Date:   Thu, 23 May 2019 16:33:41 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, dbueso@suse.de, axboe@kernel.dk,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Message-ID: <20190523143340.GA23070@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com>
 <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 23 May 2019 14:33:49 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/22, Deepa Dinamani wrote:
>
> > > > --- a/include/linux/sched/signal.h
> > > > +++ b/include/linux/sched/signal.h
> > > > @@ -416,7 +416,6 @@ void task_join_group_stop(struct task_struct *task);
> > > > static inline void set_restore_sigmask(void)
> > > > {
> > > >    set_thread_flag(TIF_RESTORE_SIGMASK);
> > > > -    WARN_ON(!test_thread_flag(TIF_SIGPENDING));
> > >
> > > So you always want do_signal() to be called?
> >
> > Why do you think so? No. This is just to avoid the warning, because with the
> > patch I sent set_restore_sigmask() is called "in advance".
> >
> > > You will have to check each architecture's implementation of
> > > do_signal() to check if that has any side effects.
> >
> > I don't think so.
>
> Why not?

Why yes?

it seems that we have some communication problems. OK, please look at the code
I proposed, I only added a couple of TODO comments

	static inline void set_restore_sigmask(void)
	{
		// WARN_ON(!TIF_SIGPENDING) was removed by this patch
		current->restore_sigmask = true;
	}

	int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize)
	{
		sigset_t *kmask;

		if (!umask)
			return 0;

		if (sigsetsize != sizeof(sigset_t))
			return -EINVAL;
		if (copy_from_user(kmask, umask, sizeof(sigset_t)))
			return -EFAULT;

		set_restore_sigmask();
		current->saved_sigmask = current->blocked;
		set_current_blocked(kmask);

		return 0;
	}

	SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
			int, maxevents, int, timeout, const sigset_t __user *, sigmask,
			size_t, sigsetsize)
	{
		int error;

		/*
		 * If the caller wants a certain signal mask to be set during the wait,
		 * we apply it here.
		 */
		error = set_user_sigmask(sigmask, sigsetsize);
		if (error)
			return error;

		error = do_epoll_wait(epfd, events, maxevents, timeout);

		// TODO. Add another helper to restore WARN_ON(!TIF_SIGPENDING)
		// in case restore_saved_sigmask() is NOT called.

		if (error != -EINTR)
			restore_saved_sigmask();

		return error;
	}

Note that it looks much simpler. Now, could you please explain

	- why do you think this code is not correct ?

	- why do you think we need to audit do_signal() ???



> > > Although this is not what the patch is solving.
> >
> > Sure. But you know, after I tried to read the changelog, I am not sure
> > I understand what exactly you are trying to fix. Could you please explain
> > this part
> >
> >         The behavior
> >         before 854a6ed56839a was that the signals were dropped after the error
> >         code was decided. This resulted in lost signals but the userspace did not
> >         notice it
> >
> > ? I fail to understand it, sorry. It looks as if the code was already buggy before
> > that commit and it could miss a signal or something like this, but I do not see how.
>
> Did you read the explanation pointed to in the commit text? :
>
> https://lore.kernel.org/linux-fsdevel/20190427093319.sgicqik2oqkez3wk@dcvr/

this link points to the lengthy and confusing discussion... after a quick glance
I didn't find an answer to my question, so let me repeat it again: why do you think
the kernel was buggy even before 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal:
Add restore_user_sigmask()") ?

Just in case...
https://lore.kernel.org/linux-fsdevel/CABeXuvq7gCV2qPOo+Q8jvNyRaTvhkRLRbnL_oJ-AuK7Sp=P3QQ@mail.gmail.com/
doesn't look right to me... let me quite some parts of your email:


	-       /*
	-        * If we changed the signal mask, we need to restore the original one.
	-        * In case we've got a signal while waiting, we do not restore the
	-        * signal mask yet, and we allow do_signal() to deliver the signal on
	-        * the way back to userspace, before the signal mask is restored.
	-        */
	-       if (sigmask) {
	-               if (error == -EINTR) {
	-                       memcpy(&current->saved_sigmask, &sigsaved,
	-                              sizeof(sigsaved));
	-                       set_restore_sigmask();
	-               } else

	**** Execution reaches this else statement and the sigmask is restored
	directly, ignoring the newly generated signal.

I see nothing wrong. This is what we want.

	The signal is never
	handled.

Well, "never" is not right. It won't be handled now, because it is blocked, but
for example think of another pselect/whatever call with the same sigmask.

> It would be better to understand the isssue before we start discussing the fix.

Agreed. And that is why I am asking for your explanations, quite possibly I missed
something, but so far I fail to understand you.

Oleg.

