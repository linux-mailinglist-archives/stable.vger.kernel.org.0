Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF9029C61
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 18:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390733AbfEXQdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 12:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390021AbfEXQdc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 12:33:32 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B100D309704F;
        Fri, 24 May 2019 16:33:16 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id A78C8608CD;
        Fri, 24 May 2019 16:33:11 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 24 May 2019 18:33:16 +0200 (CEST)
Date:   Fri, 24 May 2019 18:33:10 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "dbueso@suse.de" <dbueso@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Message-ID: <20190524163310.GG2655@redhat.com>
References: <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <CABeXuvo-wey+NHWb4gi=FSRrjJOKkVcLPQ-J+dchJeHEbhGQ6g@mail.gmail.com>
 <20190524141054.GB2655@redhat.com>
 <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeXuvqSzy+v=3Y5NnMmfob7bvuNkafmdDqoex8BVENN3atqZA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 24 May 2019 16:33:32 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/24, Deepa Dinamani wrote:
>
> On Fri, May 24, 2019 at 7:11 AM Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > On 05/23, Deepa Dinamani wrote:
> > >
> > > Ok, since there has been quite a bit of argument here, I will
> > > backtrack a little bit and maybe it will help us understand what's
> > > happening here.
> > > There are many scenarios being discussed on this thread:
> > > a. State of code before 854a6ed56839a
> >
> > I think everything was correct,
>
> There were 2 things that were wrong:
>
> 1. If an unblocked signal was received, after the ep_poll(), then the
> return status did not indicate that.

Yes,

> This is expected behavior
> according to man page. If this is indeed what is expected then the man
> page should note that signal will be delivered in this case and return
> code will still be 0.
>
> "EINTR
> The call was interrupted by a signal handler before either any of the
> requested events occurred or the timeout expired; see signal(7)."

and what do you think the man page could say?

This is obviously possible for any syscall, and we can't avoid this. A signal
can come right after syscall insn completes. The signal handler will be called
but this won't change $rax, user-space can see return code == 0 or anything else.

And this doesn't differ from the case when the signal comes before syscall returns.

> 2. The restoring of the sigmask is done right in the syscall part and
> not while exiting the syscall and if you get a blocked signal here,
> you will deliver this to userspace.

So I assume that this time you are talking about epoll_pwait() and not epoll_wait()...

And I simply can't understand you. But yes, if the original mask doesn't include
the pending signal it will be delivered while the syscall can return success/timout
or -EFAULT or anything.

This is correct, see above.

> > > b. State after 854a6ed56839a
> >
> > obviously buggy,
>
> Ok, then can you point out what specifically was wrong with
> 854a6ed56839a?

Cough. If nothing else the lost -EINTR?

> And, not how it could be more simple?

Well, I already sent the patch and after that I even showed you the code with the
patch applied. See https://lore.kernel.org/lkml/20190523143340.GA23070@redhat.com/

> > What you are saying looks very confusing to me, I will assume that you
> > meant something like
> >
> >         - a signal SIG_XXX was blocked before sys_epoll_pwait() was called
> >
> >         - sys_epoll_pwait(sigmask) unblocks SIG_XXX according to sigmask
> >
> >         - sys_epoll_pwait() calls do_epoll_wait() which returns success
> >
> >         - SIG_XXX comes after that and it is "never noticed"
> >
> > Yes. Everything is correct. And see my reply to David, SIG_XXX can even
> > come _before_ sys_epoll_pwait() was called.
>
> No, I'm talking about a signal that was not blocked.

OK, see above.

> > > So the question is does the userspace have to know about this signal
> > > or not.
> >
> > If userspace needs to know about SIG_XXX it should not block it, that is all.
>
> What should be the return value if a signal is detected after a fd completed?

Did you mean "if a signal is detected after a ready fd was already found" ?

In this case the return value should report success. But I have already lost,
this all looks irrelevant wrt to fix we need.

> > > What [b] does is to move the signal check closer to the restoration of
> > > the signal.
> >
> > FOR NO REASON, afaics (to simplify, lets forget the problem with the wrong
> > return value you are trying to fix).
>
> As I already pointed out, the restoring of the sigmask is done during
> the syscall and not while exiting the syscall and if you get a blocked
> signal here, you will deliver this to userspace.
>
> > And even if there were ANY reason to do this, note that (with or without this
> > fix) the signal_pending() check inside restore_user_sigmask() can NOT help,
> > simply because SIG_XXX can come right after this check.
>
> This I pointed out already that we should probably make this sequence atomic.

See above.

Oleg.

