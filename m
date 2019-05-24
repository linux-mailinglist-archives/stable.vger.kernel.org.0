Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8097629A70
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 16:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404055AbfEXO7u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 24 May 2019 10:59:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20043 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404046AbfEXO7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 10:59:49 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-4-IqGpfYYFOqCYiNehhRN8dg-1;
 Fri, 24 May 2019 15:59:43 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 24 May 2019 15:59:42 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 24 May 2019 15:59:42 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Oleg Nesterov' <oleg@redhat.com>
CC:     'Deepa Dinamani' <deepa.kernel@gmail.com>,
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
Subject: RE: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Thread-Topic: [PATCH v2] signal: Adjust error codes according to
 restore_user_sigmask()
Thread-Index: AQHVELwtsgR+BAQFXk2JV68Wk/7LjKZ4aINAgABVkoCAAB2x0P///TgAgAARdkCAAUypAIAAGykA
Date:   Fri, 24 May 2019 14:59:42 +0000
Message-ID: <766510cbbec640b18fd99f3946b37475@AcuMS.aculab.com>
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
 <20190524132911.GA2655@redhat.com>
In-Reply-To: <20190524132911.GA2655@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: IqGpfYYFOqCYiNehhRN8dg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov
> Sent: 24 May 2019 14:29
> It seems that we all are just trying to confuse each other. I got lost.

I'm always lost :-)

> On 05/23, David Laight wrote:
> >
> > From: Oleg Nesterov
> > > Sent: 23 May 2019 17:36
> > > On 05/23, David Laight wrote:
> > > >
> > > > From: Oleg Nesterov
> > > > > On 05/23, David Laight wrote:
> > ...
> > > > > Not sure I understand... OK, suppose that you do
> > > > >
> > > > > 	block-all-signals;
> > > > > 	ret = pselect(..., sigmask(SIG_URG));
> > > > >
> > > > > if it returns success/timeout then the handler for SIG_URG should not be called?
> > > >
> > > > Ugg...
> > > > Posix probably allows the signal handler be called at the point the event
> > > > happens rather than being deferred until the system call completes.
> > > > Queueing up the signal handler to be run at a later time (syscall exit)
> > > > certainly makes sense.
> > > > Definitely safest to call the signal handler even if success/timeout
> > > > is returned.
> > >
> > > Why?
> > >
> > > > pselect() exists to stop the entry race, not the exit one.
> > >
> > > pselect() has to block SIG_URG again before it returns to user-mode, right?
> >
> > Yep.
> > So the signal handler can't be called for a signal that happens after
> > pselect() returns.
> 
> Yes. And "after pselect() returns" actually means "after pselect() restores
> the old sigmask while it returns to user mode".
> 
> > > Suppose pselect() finds a ready fd, and this races with SIG_URG.
> >
> > You mean if SIG_URG is raised after a ready fd is found (or even timeout)?
> > So the return value isn't EINTR.
> 
> Yes.
> 
> > (If an fd is readable on entry, the SIG_URG could have happened much earlier.)
> 
> Why not? See the pseudo code above. It was blocked before pselect() was called.
> So SIG_URG can be already pending when pselect() is called but since an fd is
> already ready on entry pselect() restores the old sigmask (and thus blocks SIG_URG
> again) and returns success. The handler is not called.
> 
> However, if there is no a ready fd, pselect won't block. It will notice SIG_URG,
> deliver this signal, and return -EINTR.

To my mind changing the signal mask should be enough to get a masked
signal handler called - even if the mask is reset before the syscall exits.
There shouldn't be any need for an interruptible wait to be interrupted.

I suspect that if you send a signal to a process that is looping
in userspace (on a different) the signal handler is called on the next
exit to userspace regardless as to whether the kernel blocks.

epoll and pselect shouldn't be any different.
Having the signal unmasked at any time should be enough to get it called.

...
> > > What if SIG_URG comes right after pselect() blocks SIG_URG again? I mean,
> > > how this differs the case when it comes before, but a ready fd was already
> > > found?
> >
> > I suspect you need to defer the re-instatement of the original mask
> > to the code that calls the signal handlers (which probably should
> > be called with the programs signal mask).
> 
> This is what the kernel does when the signal is delivered, the original mask
> is restored after the signal handler runs.

I'd have thought that the original signal mask (all blocked in the examples)
should be restored before the signal handler is called.
After all the signal handler is allowed to modify the processes signal mask.
I've had horrid thoughts about SIG_SUSPEND :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

