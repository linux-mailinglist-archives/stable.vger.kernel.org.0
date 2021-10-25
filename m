Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E6C4396A0
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhJYMup convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 25 Oct 2021 08:50:45 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:30728 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233057AbhJYMuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 08:50:44 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-136-D3V1KxIfN62o-yY3VJKvvg-1; Mon, 25 Oct 2021 13:48:20 +0100
X-MC-Unique: D3V1KxIfN62o-yY3VJKvvg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.24; Mon, 25 Oct 2021 13:48:19 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.024; Mon, 25 Oct 2021 13:48:19 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willy Tarreau' <w@1wt.eu>
CC:     "Paul E . McKenney" <paulmck@kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        "Ammar Faizi" <ammar.faizi@students.amikom.ac.id>,
        Peter Cordes <peter@cordes.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 2/3] tools/nolibc: i386: fix initial stack alignment
Thread-Topic: [PATCH 2/3] tools/nolibc: i386: fix initial stack alignment
Thread-Index: AQHXyPyt3VRk2GYnN02WzGUPe2wuUqvjVOSw///2wgCAAF8XkA==
Date:   Mon, 25 Oct 2021 12:48:19 +0000
Message-ID: <e1090244c6324f6fbaaf04ecb7a7cac5@AcuMS.aculab.com>
References: <20211024172816.17993-1-w@1wt.eu>
 <20211024172816.17993-3-w@1wt.eu>
 <7e5ed287476042388779ca3c84483a92@AcuMS.aculab.com>
 <20211025080620.GA23398@1wt.eu>
In-Reply-To: <20211025080620.GA23398@1wt.eu>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau
> Sent: 25 October 2021 09:06
> 
> On Mon, Oct 25, 2021 at 07:46:11AM +0000, David Laight wrote:
> > From: Willy Tarreau
> > > Sent: 24 October 2021 18:28
> > >
> > > After re-checking in the spec and comparing stack offsets with glibc,
> > > The last pushed argument must be 16-byte aligned (i.e. aligned before the
> > > call) so that in the callee esp+4 is multiple of 16, so the principle is
> > > the 32-bit equivalent to what Ammar fixed for x86_64. It's possible that
> > > 32-bit code using SSE2 or MMX could have been affected. In addition the
> > > frame pointer ought to be zero at the deepest level.
> > >
> > ...
> > >  /* startup code */
> > > +/*
> > > + * i386 System V ABI mandates:
> > > + * 1) last pushed argument must be 16-byte aligned.
> > > + * 2) The deepest stack frame should be set to zero
> >
> > I'm pretty sure that the historic SYSV i386 ABI only every required
> > 4-byte alignment for the stack.
> >
> > At some point it got 'randomly' changed to 16-byte.
> > I don't think this happened until after compiler support for SSE2
> > intrinsics was added.
> 
> It's very possible because I've done a number of tests and noticed
> that in some cases the called functions' stack doesn't seem to be
> more than 4-aligned. However the deepest function in the stack starts
> with an aligned stack so I prefer to follow this same rule.

Any call through asm is unlikely to maintain the 16 byte alignment.
But yes, starting off on the required (by gcc) alignment does no harm.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

