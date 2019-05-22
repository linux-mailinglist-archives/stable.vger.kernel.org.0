Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005FE2685B
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 18:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfEVQeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 12:34:04 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:55158 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbfEVQeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 12:34:04 -0400
Received: by mail-it1-f194.google.com with SMTP id h20so4590956itk.4;
        Wed, 22 May 2019 09:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYqk2Fyyr6LmcYSZXyKPZozb0V8mVmcU+MqGFmXtesU=;
        b=EnejOOKTBmL2BlIj1iVCbUs6tCYpLWz1FqnAYz4QlaNH/CDgDAPV+0zb/QKkBWKYA5
         A8tpKMtc1p4D4ap4xptHACvXOT6yQMgiHBHTg5KNBo+bnZ5v91g2IS2iBJS/p2NWQjMX
         zPepruQ5lfMaHoCVGh3yX1YZK3aoZbvK0FJ92RxaYXMdDiL3xy8gPA3XfcwnknKglvaY
         QYkk0pwRy4og5PeLb/5Vct0Fhq8Qiehy6BQdrbpKE05/LlmCo+kH96Thksw+VrOPMqJc
         FrG0sbHtNBw0H8sQFl0HsVFPohKBaArN8F8LjaMvYfwVz5l11De5EQqoDoRsmTG0+Pu4
         Sd7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYqk2Fyyr6LmcYSZXyKPZozb0V8mVmcU+MqGFmXtesU=;
        b=G3W/c474JxcWVSn9HqzK95xKBoj1IuW1AlLul0RxofRJcSJ91yFwktSsWmzgrULYbB
         4ajhWIJrO8OymcnfcaIFEkatFI5TSnUmxspo848ihGGyebhpaPvcN4OA7l3HOih4FxeR
         Si7BF54cKx5idXjaK/qFl9gk2PGN6/OXe57M3WYZHzDywidhrBpKYoS3vY0CuiTnsYKf
         3gwOAUDPcmfzZ9L3AR2bS1SBMMVqPrjX9ww2NnVfkRIR/J/hyiwoP73H9cu1qM/quOWh
         IKOJzLOmm/WvUvqbg0nRC3un/HhilNlQfqYB/8ZYTeHYPV4dJy6jA87rOx8XsSj8Dyh/
         uvxw==
X-Gm-Message-State: APjAAAVHZkAwNA35zaQekc60SeG3/pljUorovua8YN89XH21YMA7rcTy
        VD1fqUcAsgaLrlU8wFMBukfKdnwz35okb9O2y8Y=
X-Google-Smtp-Source: APXvYqzx1GpMAk7cc3ITinEA5P2E12bTc1XlVEEYUciPFZl4sgsaeYO+0z3aVfQA2t/M3DEgJww4EDZQ4gRIG/tkhPQ=
X-Received: by 2002:a24:e084:: with SMTP id c126mr8884976ith.124.1558542842726;
 Wed, 22 May 2019 09:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com> <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
In-Reply-To: <20190522161407.GB4915@redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Wed, 22 May 2019 09:33:50 -0700
Message-ID: <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
Subject: Re: [PATCH v2] signal: Adjust error codes according to restore_user_sigmask()
To:     Oleg Nesterov <oleg@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 9:14 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 05/22, Deepa Dinamani wrote:
> >
> > -Deepa
> >
> > > On May 22, 2019, at 8:05 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > >> On 05/21, Deepa Dinamani wrote:
> > >>
> > >> Note that this patch returns interrupted errors (EINTR, ERESTARTNOHAND,
> > >> etc) only when there is no other error. If there is a signal and an error
> > >> like EINVAL, the syscalls return -EINVAL rather than the interrupted
> > >> error codes.
> > >
> > > Ugh. I need to re-check, but at first glance I really dislike this change.
> > >
> > > I think we can fix the problem _and_ simplify the code. Something like below.
> > > The patch is obviously incomplete, it changes only only one caller of
> > > set_user_sigmask(), epoll_pwait() to explain what I mean.
> > > restore_user_sigmask() should simply die. Although perhaps another helper
> > > makes sense to add WARN_ON(test_tsk_restore_sigmask() && !signal_pending).
> >
> > restore_user_sigmask() was added because of all the variants of these
> > syscalls we added because of y2038 as noted in commit message:
> >
> >   signal: Add restore_user_sigmask()
> >
> >     Refactor the logic to restore the sigmask before the syscall
> >     returns into an api.
> >     This is useful for versions of syscalls that pass in the
> >     sigmask and expect the current->sigmask to be changed during
> >     the execution and restored after the execution of the syscall.
> >
> >     With the advent of new y2038 syscalls in the subsequent patches,
> >     we add two more new versions of the syscalls (for pselect, ppoll
> >     and io_pgetevents) in addition to the existing native and compat
> >     versions. Adding such an api reduces the logic that would need to
> >     be replicated otherwise.
>
> Again, I need to re-check, will continue tomorrow. But so far I am not sure
> this helper can actually help.
>
> > > --- a/fs/eventpoll.c
> > > +++ b/fs/eventpoll.c
> > > @@ -2318,19 +2318,19 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
> > >        size_t, sigsetsize)
> > > {
> > >    int error;
> > > -    sigset_t ksigmask, sigsaved;
> > >
> > >    /*
> > >     * If the caller wants a certain signal mask to be set during the wait,
> > >     * we apply it here.
> > >     */
> > > -    error = set_user_sigmask(sigmask, &ksigmask, &sigsaved, sigsetsize);
> > > +    error = set_user_sigmask(sigmask, sigsetsize);
> > >    if (error)
> > >        return error;
> > >
> > >    error = do_epoll_wait(epfd, events, maxevents, timeout);
> > >
> > > -    restore_user_sigmask(sigmask, &sigsaved);
> > > +    if (error != -EINTR)
> >
> > As you address all the other syscalls this condition becomes more and
> > more complicated.
>
> May be.
>
> > > --- a/include/linux/sched/signal.h
> > > +++ b/include/linux/sched/signal.h
> > > @@ -416,7 +416,6 @@ void task_join_group_stop(struct task_struct *task);
> > > static inline void set_restore_sigmask(void)
> > > {
> > >    set_thread_flag(TIF_RESTORE_SIGMASK);
> > > -    WARN_ON(!test_thread_flag(TIF_SIGPENDING));
> >
> > So you always want do_signal() to be called?
>
> Why do you think so? No. This is just to avoid the warning, because with the
> patch I sent set_restore_sigmask() is called "in advance".
>
> > You will have to check each architecture's implementation of
> > do_signal() to check if that has any side effects.
>
> I don't think so.

Why not?

> > Although this is not what the patch is solving.
>
> Sure. But you know, after I tried to read the changelog, I am not sure
> I understand what exactly you are trying to fix. Could you please explain
> this part
>
>         The behavior
>         before 854a6ed56839a was that the signals were dropped after the error
>         code was decided. This resulted in lost signals but the userspace did not
>         notice it
>
> ? I fail to understand it, sorry. It looks as if the code was already buggy before
> that commit and it could miss a signal or something like this, but I do not see how.

Did you read the explanation pointed to in the commit text? :

https://lore.kernel.org/linux-fsdevel/20190427093319.sgicqik2oqkez3wk@dcvr/

Let me know what part you don't understand and I can explain more.

It would be better to understand the isssue before we start discussing the fix.

-Deepa
