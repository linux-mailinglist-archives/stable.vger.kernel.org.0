Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AD61D1672
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 15:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgEMNut convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 13 May 2020 09:50:49 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:54055 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727792AbgEMNut (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 09:50:49 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-207-7QlvMga7Ot6aVhvjyH0N6g-1; Wed, 13 May 2020 14:50:45 +0100
X-MC-Unique: 7QlvMga7Ot6aVhvjyH0N6g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 13 May 2020 14:50:44 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 13 May 2020 14:50:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Zijlstra' <peterz@infradead.org>
CC:     'Geert Uytterhoeven' <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        stable <stable@vger.kernel.org>,
        Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>
Subject: RE: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Thread-Topic: [PATCH 4.4 03/16] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Thread-Index: AQHWKQu4HYgJHBu5S0KOdh+8IRi0tqilymPggAAprYCAABK8AA==
Date:   Wed, 13 May 2020 13:50:44 +0000
Message-ID: <94541c2ec85e4b2589dc8902ef2c4f41@AcuMS.aculab.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-4-lee.jones@linaro.org>
 <20200513093536.GB830571@kroah.com>
 <CAMuHMdVZHodDXGOMuOpVLbgiy9_WeHHKKq4kG7Cz9u9pm8UZuw@mail.gmail.com>
 <335fbcc7d9ad4d429ec11e9ac2caf118@AcuMS.aculab.com>
 <20200513133609.GO2978@hirez.programming.kicks-ass.net>
In-Reply-To: <20200513133609.GO2978@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra
> Sent: 13 May 2020 14:36
> 
> On Wed, May 13, 2020 at 10:10:03AM +0000, David Laight wrote:
> > From: Geert Uytterhoeven
> > > Sent: 13 May 2020 10:49
> > ...
> > > > I don't want to apply this to older kernels as it could cause extra
> > > > memory usage for no good reason.  I have no idea why a non ARC system
> > > > would want it :(
> > >
> > > I think the reference to ARC is a red herring.
> > > The real issue is that buffers used for DMA may not have the required
> > > alignment, which is not limited to ARC systems.
> > >
> > > Note that I'm also not super happy with the extra memory usage.
> > > But devm_*() conveniences come with their penalties...
> >
> > Interesting thought.
> > Could the devm 'header' be put right at the end of the kmalloc()
> > buffer?
> 
> https://lkml.kernel.org/r/20191220140655.GN2827@hirez.programming.kicks-ass.net

All the way around the loop.....

ISTR there have also been issues with one of the kmalloc() implementations
adding a header to the memory block.
Didn't it generate 4n+2 aligned buffers on m68k - breaking code that
tried to use the two lower bits of an address.

If one of the kmalloc()s behaves like that it ought to be possible
for devm_alloc() to use the spare space in the same cache line??

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

