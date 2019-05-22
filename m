Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6943267CF
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 18:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbfEVQOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 12:14:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729603AbfEVQOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 12:14:21 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2197985539;
        Wed, 22 May 2019 16:14:15 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2FCAF5DE68;
        Wed, 22 May 2019 16:14:10 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed, 22 May 2019 18:14:13 +0200 (CEST)
Date:   Wed, 22 May 2019 18:14:07 +0200
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
Message-ID: <20190522161407.GB4915@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com>
 <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 22 May 2019 16:14:20 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/22, Deepa Dinamani wrote:
>
> -Deepa
>
> > On May 22, 2019, at 8:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >> On 05/21, Deepa Dinamani wrote:
> >>
> >> Note that this patch returns interrupted errors (EINTR, ERESTARTNOHAND,
> >> etc) only when there is no other error. If there is a signal and an error
> >> like EINVAL, the syscalls return -EINVAL rather than the interrupted
> >> error codes.
> >
> > Ugh. I need to re-check, but at first glance I really dislike this change.
> >
> > I think we can fix the problem _and_ simplify the code. Something like below.
> > The patch is obviously incomplete, it changes only only one caller of
> > set_user_sigmask(), epoll_pwait() to explain what I mean.
> > restore_user_sigmask() should simply die. Although perhaps another helper
> > makes sense to add WARN_ON(test_tsk_restore_sigmask() && !signal_pending).
>
> restore_user_sigmask() was added because of all the variants of these
> syscalls we added because of y2038 as noted in commit message:
>
>   signal: Add restore_user_sigmask()
>
>     Refactor the logic to restore the sigmask before the syscall
>     returns into an api.
>     This is useful for versions of syscalls that pass in the
>     sigmask and expect the current->sigmask to be changed during
>     the execution and restored after the execution of the syscall.
>
>     With the advent of new y2038 syscalls in the subsequent patches,
>     we add two more new versions of the syscalls (for pselect, ppoll
>     and io_pgetevents) in addition to the existing native and compat
>     versions. Adding such an api reduces the logic that would need to
>     be replicated otherwise.

Again, I need to re-check, will continue tomorrow. But so far I am not sure
this helper can actually help.

> > --- a/fs/eventpoll.c
> > +++ b/fs/eventpoll.c
> > @@ -2318,19 +2318,19 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
> >        size_t, sigsetsize)
> > {
> >    int error;
> > -    sigset_t ksigmask, sigsaved;
> >
> >    /*
> >     * If the caller wants a certain signal mask to be set during the wait,
> >     * we apply it here.
> >     */
> > -    error = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
> > +    error = set_user_sigmask(sigmask, sigsetsize);
> >    if (error)
> >        return error;
> >
> >    error = do_epoll_wait(epfd, events, maxevents, timeout);
> >
> > -    restore_user_sigmask(sigmask, &sigsaved);
> > +    if (error != -EINTR)
>
> As you address all the other syscalls this condition becomes more and
> more complicated.

May be.

> > --- a/include/linux/sched/signal.h
> > +++ b/include/linux/sched/signal.h
> > @@ -416,7 +416,6 @@ void task_join_group_stop(struct task_struct *task);
> > static inline void set_restore_sigmask(void)
> > {
> >    set_thread_flag(TIF_RESTORE_SIGMASK);
> > -    WARN_ON(!test_thread_flag(TIF_SIGPENDING));
>
> So you always want do_signal() to be called?

Why do you think so? No. This is just to avoid the warning, because with the
patch I sent set_restore_sigmask() is called "in advance".

> You will have to check each architecture's implementation of
> do_signal() to check if that has any side effects.

I don't think so.

> Although this is not what the patch is solving.

Sure. But you know, after I tried to read the changelog, I am not sure
I understand what exactly you are trying to fix. Could you please explain
this part

	The behavior
	before 854a6ed56839a was that the signals were dropped after the error
	code was decided. This resulted in lost signals but the userspace did not
	notice it

? I fail to understand it, sorry. It looks as if the code was already buggy before
that commit and it could miss a signal or something like this, but I do not see how.

Oleg.

