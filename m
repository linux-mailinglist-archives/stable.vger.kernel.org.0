Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD2129C70
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390448AbfEXQkT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 24 May 2019 12:40:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:50238 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390210AbfEXQkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 12:40:19 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-12-a1PWNyhNM0qf5VNOe2DpTg-1; Fri, 24 May 2019 17:40:16 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri,
 24 May 2019 17:40:15 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 24 May 2019 17:40:15 +0100
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
Thread-Index: AQHVELwtsgR+BAQFXk2JV68Wk/7LjKZ4aINAgABVkoCAAB2x0P///TgAgAARdkCAAUypAIAAGykAgAAKnoCAAB1BUA==
Date:   Fri, 24 May 2019 16:40:15 +0000
Message-ID: <658d30b3606f40159570c0e83bb69e37@AcuMS.aculab.com>
References: <CABeXuvrPM5xvzqUydbREapvwgy6deYreHp0aaMoSHyLB6+HGRg@mail.gmail.com>
 <20190522161407.GB4915@redhat.com>
 <CABeXuvpjrW5Gt95JC-_rYkOA=6RCD5OtkEQdwZVVqGCE3GkQOQ@mail.gmail.com>
 <4f7b6dbeab1d424baaebd7a5df116349@AcuMS.aculab.com>
 <20190523145944.GB23070@redhat.com>
 <345cfba5edde470f9a68d913f44fa342@AcuMS.aculab.com>
 <20190523163604.GE23070@redhat.com>
 <f0eced5677c144debfc5a69d0d327bc1@AcuMS.aculab.com>
 <20190524132911.GA2655@redhat.com>
 <766510cbbec640b18fd99f3946b37475@AcuMS.aculab.com>
 <20190524154425.GE2655@redhat.com>
In-Reply-To: <20190524154425.GE2655@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: a1PWNyhNM0qf5VNOe2DpTg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov
> Sent: 24 May 2019 16:44
> > To my mind changing the signal mask should be enough to get a masked
> > signal handler called - even if the mask is reset before the syscall exits.
> 
> well, the kernel doesn't do this, and on purpose.
> 
> > There shouldn't be any need for an interruptible wait to be interrupted.
> 
> can't parse ;)
> 
> > I suspect that if you send a signal to a process that is looping
> > in userspace (on a different) the signal handler is called on the next
> > exit to userspace regardless as to whether the kernel blocks.
> >
> > epoll and pselect shouldn't be any different.
> 
> They differ exactly because they manipulate the blocked mask,
> 
> > Having the signal unmasked at any time should be enough to get it called.
> 
> No. The sigmask passed to pselect() tells the kernel which signals should
> interrupt the syscall if it blocks. The fact that pselect() actually unblocks
> a signal is just the internal implementation detail.

If you take that line of reasoning the signal handler shouldn't be called
at all.

For pselect() (which ought to work the same way as epoll_pwait()) the
man page states that the current signal mask is replaced by the specified
one for the duration of the call - so you'd expect signal handlers to run
even if pselect() returns >= 0.

Consider a program that disables all signals at the top of main()
then has a processing loop with epoll_pwait() (or pselect()) at the
top) that enables a variety of signals.

It would be reasonable to expect that a signal handler would run
even if one of the fds was always 'ready'.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

