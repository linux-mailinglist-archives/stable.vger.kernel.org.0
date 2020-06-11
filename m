Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739E21F62EE
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 09:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgFKHvI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 11 Jun 2020 03:51:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:20601 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726646AbgFKHvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 03:51:08 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-9-srxEkIQVNHCvyywSxzAvSQ-1;
 Thu, 11 Jun 2020 08:51:03 +0100
X-MC-Unique: srxEkIQVNHCvyywSxzAvSQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 11 Jun 2020 08:51:03 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 11 Jun 2020 08:51:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>
CC:     'Sargun Dhillon' <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Denton <mpdenton@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Topic: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Index: AQHWPv7tCi14oegu0U6J73sUpcDiU6jRh/3wgAEizQCAAFtkYA==
Date:   Thu, 11 Jun 2020 07:51:02 +0000
Message-ID: <5cb49301f8d8432eacdd0e9d914c14a3@AcuMS.aculab.com>
References: <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <40d76a9a4525414a8c9809cd29a7ba8e@AcuMS.aculab.com>
 <202006102001.E9779DFA5B@keescook>
In-Reply-To: <202006102001.E9779DFA5B@keescook>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook
> Sent: 11 June 2020 04:03
...
> > IIRC other kernels (eg NetBSD) do the copies for ioctl() requests
> > in the ioctl syscall wrapper.
> > The IOW/IOR/IOWR flags have to be right.
> 
> Yeah, this seems like it'd make a lot more sense (and would have easily
> caught the IOR/IOW issue pointed out later in the thread). I wonder how
> insane it would be to try to fix that globally in the kernel...

Seems like a good idea to me.
(Even though I'll need to fix our 'out of tree' modules.)

Unlike [sg]etsockopt() at least the buffer is bounded to 1k.

But you'd really need to add new kernel_ioctl() entry points
before deprecating the existing ones a release or two later.

With a bit of luck there aren't any drivers ported from SYSV that
just treat the ioctl command as a 32bit transparent value and
the argument as an integer.

I actually suspect that BSD added IOW (etc) in the 16bit to 32bit port.
The kernel copies being moved to the syscall stub at the same time.
Since Linux has only ever been 32bit and uses IOW is it actually odd
that Linus didn't do the copies in the stub.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

