Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2315128456
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 18:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbfEWQ4q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 May 2019 12:56:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:28113 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730790AbfEWQ4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 12:56:46 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-195-dCvv3IMGOWGiL--uJpCpLw-1; Thu, 23 May 2019 17:56:43 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu,
 23 May 2019 17:56:43 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 23 May 2019 17:56:43 +0100
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
Thread-Index: AQHVELwtsgR+BAQFXk2JV68Wk/7LjKZ4aINAgABVkoCAAB2x0P///TgAgAARdkA=
Date:   Thu, 23 May 2019 16:56:43 +0000
Message-ID: <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com>
 <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
In-Reply-To: <20190523163604.GE23070@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: dCvv3IMGOWGiL--uJpCpLw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov
> Sent: 23 May 2019 17:36
> On 05/23, David Laight wrote:
> >
> > From: Oleg Nesterov
> > > On 05/23, David Laight wrote:
...
> > > Not sure I understand... OK, suppose that you do
> > >
> > > 	block-all-signals;
> > > 	ret = pselect(..., sigmask(SIG_URG));
> > >
> > > if it returns success/timeout then the handler for SIG_URG should not be called?
> >
> > Ugg...
> > Posix probably allows the signal handler be called at the point the event
> > happens rather than being deferred until the system call completes.
> > Queueing up the signal handler to be run at a later time (syscall exit)
> > certainly makes sense.
> > Definitely safest to call the signal handler even if success/timeout
> > is returned.
> 
> Why?
> 
> > pselect() exists to stop the entry race, not the exit one.
> 
> pselect() has to block SIG_URG again before it returns to user-mode, right?

Yep.
So the signal handler can't be called for a signal that happens after
pselect() returns.

> Suppose pselect() finds a ready fd, and this races with SIG_URG.

You mean if SIG_URG is raised after a ready fd is found (or even timeout)?
So the return value isn't EINTR.
(If an fd is readable on entry, the SIG_URG could have happened much earlier.)

> Why do you think the handler should run?

Think of the application code loop.
Consider what happens if the signal is SIG_INT - to request the program
stop.
After every pselect() call the application looks to see if the handler
has been called.
If one of the fds is always readable pselect() will never return EINTR
but you want the SIG_INT handler run so that the loop gets terminated.
If you only call the signal handler when EINTR is returned the process
will never stop.
So you need to call the handler even when pselect() succeeds/time out.

> What if SIG_URG comes right after pselect() blocks SIG_URG again? I mean,
> how this differs the case when it comes before, but a ready fd was already
> found?

I suspect you need to defer the re-instatement of the original mask
to the code that calls the signal handlers (which probably should
be called with the programs signal mask).
So that particular window doesn't exist.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

