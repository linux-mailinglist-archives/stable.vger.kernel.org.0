Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E647C298F0
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 15:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403801AbfEXN3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 09:29:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403799AbfEXN3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 09:29:32 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7482930ADC75;
        Fri, 24 May 2019 13:29:21 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.159])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2A8382E024;
        Fri, 24 May 2019 13:29:12 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri, 24 May 2019 15:29:21 +0200 (CEST)
Date:   Fri, 24 May 2019 15:29:12 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Deepa Dinamani' <deepa.kernel@gmail.com>,
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
Message-ID: <20190524132911.GA2655@redhat.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com>
 <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 24 May 2019 13:29:31 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It seems that we all are just trying to confuse each other. I got lost.

On 05/23, David Laight wrote:
>
> From: Oleg Nesterov
> > Sent: 23 May 2019 17:36
> > On 05/23, David Laight wrote:
> > >
> > > From: Oleg Nesterov
> > > > On 05/23, David Laight wrote:
> ...
> > > > Not sure I understand... OK, suppose that you do
> > > >
> > > > 	block-all-signals;
> > > > 	ret = pselect(..., sigmask(SIG_URG));
> > > >
> > > > if it returns success/timeout then the handler for SIG_URG should not be called?
> > >
> > > Ugg...
> > > Posix probably allows the signal handler be called at the point the event
> > > happens rather than being deferred until the system call completes.
> > > Queueing up the signal handler to be run at a later time (syscall exit)
> > > certainly makes sense.
> > > Definitely safest to call the signal handler even if success/timeout
> > > is returned.
> >
> > Why?
> >
> > > pselect() exists to stop the entry race, not the exit one.
> >
> > pselect() has to block SIG_URG again before it returns to user-mode, right?
>
> Yep.
> So the signal handler can't be called for a signal that happens after
> pselect() returns.

Yes. And "after pselect() returns" actually means "after pselect() restores
the old sigmask while it returns to user mode".

> > Suppose pselect() finds a ready fd, and this races with SIG_URG.
>
> You mean if SIG_URG is raised after a ready fd is found (or even timeout)?
> So the return value isn't EINTR.

Yes.

> (If an fd is readable on entry, the SIG_URG could have happened much earlier.)

Why not? See the pseudo code above. It was blocked before pselect() was called.
So SIG_URG can be already pending when pselect() is called but since an fd is
already ready on entry pselect() restores the old sigmask (and thus blocks SIG_URG
again) and returns success. The handler is not called.

However, if there is no a ready fd, pselect won't block. It will notice SIG_URG,
deliver this signal, and return -EINTR.


> > Why do you think the handler should run?
>
> Think of the application code loop.
> Consider what happens if the signal is SIG_INT - to request the program
> stop.

SIG_INT or SIG_URG ? Again, please look at the pseudo code above. SIG_INT is
blocked and never unblocked.

> After every pselect() call the application looks to see if the handler
> has been called.
> If one of the fds is always readable pselect() will never return EINTR
> but you want the SIG_INT handler run so that the loop gets terminated.
> If you only call the signal handler when EINTR is returned the process
> will never stop.
> So you need to call the handler even when pselect() succeeds/time out.

Then do not block SIG_INT ?

	block-all-signals-except-SIG_INT;
	ret = pselect(..., sigmask{SIG_URG, SIG_INT});


> > What if SIG_URG comes right after pselect() blocks SIG_URG again? I mean,
> > how this differs the case when it comes before, but a ready fd was already
> > found?
>
> I suspect you need to defer the re-instatement of the original mask
> to the code that calls the signal handlers (which probably should
> be called with the programs signal mask).

This is what the kernel does when the signal is delivered, the original mask
is restored after the signal handler runs.

> So that particular window doesn't exist.

Which window???

Oleg.

