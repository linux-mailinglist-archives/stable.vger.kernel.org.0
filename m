Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963D01B44AD
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 14:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgDVMUt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 22 Apr 2020 08:20:49 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:44041 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728610AbgDVMRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 08:17:35 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-79-5MfM8B80PPye_1nD6TvtNw-1; Wed, 22 Apr 2020 13:17:31 +0100
X-MC-Unique: 5MfM8B80PPye_1nD6TvtNw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 22 Apr 2020 13:17:30 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 22 Apr 2020 13:17:30 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Lee Jones' <lee.jones@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Alexey Brodkin <alexey.brodkin@synopsys.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will.deacon@arm.com>, Greg KH <greg@kroah.com>
Subject: RE: [PATCH 4.9 04/21] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Thread-Topic: [PATCH 4.9 04/21] devres: Align data[] to ARCH_KMALLOC_MINALIGN
Thread-Index: AQHWGJf9PDUNqXE/N0CW3HgU1q+Ys6iFDMFA
Date:   Wed, 22 Apr 2020 12:17:30 +0000
Message-ID: <d4b3dc8228014f29b9449bcff6e61315@AcuMS.aculab.com>
References: <20200422111957.569589-1-lee.jones@linaro.org>
 <20200422111957.569589-5-lee.jones@linaro.org>
In-Reply-To: <20200422111957.569589-5-lee.jones@linaro.org>
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

From: Lee Jones <lee.jones@linaro.org>
> Sent: 22 April 2020 12:20
> From: Alexey Brodkin <alexey.brodkin@synopsys.com>
> 
> [ Upstream commit a66d972465d15b1d89281258805eb8b47d66bd36 ]
> 
> Initially we bumped into problem with 32-bit aligned atomic64_t
> on ARC, see [1]. And then during quite lengthly discussion Peter Z.
> mentioned ARCH_KMALLOC_MINALIGN which IMHO makes perfect sense.
> If allocation is done by plain kmalloc() obtained buffer will be
> ARCH_KMALLOC_MINALIGN aligned and then why buffer obtained via
> devm_kmalloc() should have any other alignment?
> 
> This way we at least get the same behavior for both types of
> allocation.

Anyone any idea how much difference it would actually make
to align all architectures to at least 32-bits (or even 64-bits)?

I think the only times it would make a difference would be for
allocations that (for example, 62 bytes on m68k) just
fit in a 64 byte block - so suddenly grow to 128 bytes.
(Or whatever granularity the allocator uses).

I suspect they are rarer than allocations of an arbitrary 2^n
bytes that get a lot of bloat padding if the allocator adds
a header.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

