Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85ED14EDBA
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 14:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgAaNpu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 31 Jan 2020 08:45:50 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:20084 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728696AbgAaNpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 08:45:44 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-227-V3iOMSX-MNqGoZYj_aXz5g-1; Fri, 31 Jan 2020 13:45:41 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 31 Jan 2020 13:45:40 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 31 Jan 2020 13:45:40 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Machek' <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 4.19 36/55] drivers/net/b44: Change to non-atomic bit
 operations on pwol_mask
Thread-Topic: [PATCH 4.19 36/55] drivers/net/b44: Change to non-atomic bit
 operations on pwol_mask
Thread-Index: AQHV2DYMVY2qrJP3VEav5dxVBo5ZUKgExoPA
Date:   Fri, 31 Jan 2020 13:45:40 +0000
Message-ID: <6c9a600f3ec14bbcb4877a89fa7d205a@AcuMS.aculab.com>
References: <20200130183608.563083888@linuxfoundation.org>
 <20200130183615.120752961@linuxfoundation.org>
 <20200131125730.GA20888@duo.ucw.cz>
In-Reply-To: <20200131125730.GA20888@duo.ucw.cz>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: V3iOMSX-MNqGoZYj_aXz5g-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek
> Sent: 31 January 2020 12:58
> 
> On Thu 2020-01-30 19:39:17, Greg Kroah-Hartman wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > [ Upstream commit f11421ba4af706cb4f5703de34fa77fba8472776 ]
> 
> This is not suitable for stable. It does not fix anything. It prepares
> for theoretical bug that author claims might be introduced to BIOS in
> future... I doubt it, even BIOS authors boot their machines from time
> to time.
> 
> > Atomic operations that span cache lines are super-expensive on x86
> > (not just to the current processor, but also to other processes as all
> > memory operations are blocked until the operation completes). Upcoming
> > x86 processors have a switch to cause such operations to generate a #AC
> > trap. It is expected that some real time systems will enable this mode
> > in BIOS.
> 
> And I wonder if this is even good idea for mainline. x86 architecture
> is here for long time, and I doubt Intel is going to break it like
> this. Do you have documentation pointer?

The fact that locked operations that cross cache line boundaries work
at all is because of compatibility with very old processors (which
always locked the bus).

> > In preparation for this, it is necessary to fix code that may execute
> > atomic instructions with operands that cross cachelines because the #AC
> > trap will crash the kernel.
> 
> How does single bit operation "cross cacheline"? How is this going to
> impact non-x86 architectures?

The cpu 'bit' instructions used always access a full 'word' of memory
at a 'word' offset from the specified base address'
With a 64bit bit offset the 'word' is 64 bits, so if the base address
of the array isn't 8 byte aligned the cpu does a misaligned RMW cycle.

Non-x86 architectures probably either:
1) Fault on the mis-aligned transfer.
2) Ignore the 'lock'.
3) Use a software 'array of mutex' to emulate locked bit updates.
4) Any random combination of the above.

> > Since "pwol_mask" is local and never exposed to concurrency, there is
> > no need to set bits in pwol_mask using atomic operations.
> >
> > Directly operate on the byte which contains the bit instead of using
> > __set_bit() to avoid any big endian concern due to type cast to
> > unsigned long in __set_bit().
> 
> What concerns? Is __set_bit() now useless and are we going to open-code
> it everywhere? Is set_bit() now unusable on x86?

Both set_bit() and __set_bit() are defined to work on bitmaps
that are defined as 'long[]'.
They are not there because people are too lazy to write foo |= 1 << n.

...
> >  	memset(ppattern + offset, 0xff, magicsync);
> > -	for (j = 0; j < magicsync; j++)
> > -		set_bit(len++, (unsigned long *) pmask);
> > +	for (j = 0; j < magicsync; j++) {
> > +		pmask[len >> 3] |= BIT(len & 7);
> > +		len++;
> > +	}
> >
> >  	for (j = 0; j < B44_MAX_PATTERNS; j++) {
> >  		if ((B44_PATTERN_SIZE - len) >= ETH_ALEN)
> > @@ -1532,7 +1534,8 @@ static int b44_magic_pattern(u8 *macaddr, u8 *ppattern, u8 *pmask, int offset)
> >  		for (k = 0; k< ethaddr_bytes; k++) {
> >  			ppattern[offset + magicsync +
> >  				(j * ETH_ALEN) + k] = macaddr[k];
> > -			set_bit(len++, (unsigned long *) pmask);
> > +			pmask[len >> 3] |= BIT(len & 7);

In this case I believe the pmask[] is passed to hardware.
It is very much an array of bytes initialised in a specific way.

set_bit() (and __set_bit()) would do completely the wrong thing
on BE systems.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

