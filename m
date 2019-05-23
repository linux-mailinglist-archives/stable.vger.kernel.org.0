Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BC1282B2
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 18:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbfEWQS5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 May 2019 12:18:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:28792 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731273AbfEWQS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 12:18:57 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-206-NxgE-QeqMLGOVa7vAw4lcw-1; Thu, 23 May 2019 17:18:52 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 23 May 2019 17:18:52 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 23 May 2019 17:18:52 +0100
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
Thread-Index: AQHVELwtsgR+BAQFXk2JV68Wk/7LjKZ4aINAgABVkoCAAB2x0A==
Date:   Thu, 23 May 2019 16:18:52 +0000
Message-ID: <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
References: <20190522032144.10995-1-deepa.kernel@gmail.com>
 <20190522150505.GA4915@redhat.com>
 <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
In-Reply-To: <20190523145944.GB23070@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: NxgE-QeqMLGOVa7vAw4lcw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov
> On 05/23, David Laight wrote:
> >
> > I'm confused...
> 
> Me too. To clarify, the current code is obviously buggy, pselect/whatever
> shouldn't return 0 (or anything else) if it was interrupted and we are going
> to deliver the signal.

If it was interrupted the return value has to be EINTR.
Whether any signal handlers are called is a separate matter.

> But it seems that Deepa has other concerns which I do not understand at all.
> 
> In any case, the signal_pending() check _inside_ restore_user_sigmask() can't
> be right, with or without this patch. If nothing else, a signal can come right
> after the check.
> 
> > So epoll() can return 'success' or 'timeout' (etc) and the handler for SIG_URG
> > should still be called.
> 
> Not sure I understand... OK, suppose that you do
> 
> 	block-all-signals;
> 	ret = pselect(..., sigmask(SIG_URG));
> 
> if it returns success/timeout then the handler for SIG_URG should not be called?

Ugg...
Posix probably allows the signal handler be called at the point the event
happens rather than being deferred until the system call completes.
Queueing up the signal handler to be run at a later time (syscall exit)
certainly makes sense.
Definitely safest to call the signal handler even if success/timeout
is returned.
pselect() exists to stop the entry race, not the exit one.


> or I am totally confused...

The pselect(2) man page says that the signal handler for a signal that is
enabled for the duration should run.
Clearly it is also valid to call the signal handlers for any signals that
are allowed on entry/exit (they could happen just after the return).
Also remember that pselect() can also be used to disable signals.

So ISTM that signal handlers allowed by either signal mask
should be called during syscall exit.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

