Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6295CC4994
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 10:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfJBIeM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 2 Oct 2019 04:34:12 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:26890 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725919AbfJBIeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 04:34:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-106-A4o3tKQ9OZitIOq_xjIfUQ-1; Wed, 02 Oct 2019 09:34:09 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 2 Oct 2019 09:34:08 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 2 Oct 2019 09:34:08 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sasha Levin' <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Austin Kim <austindh.kim@gmail.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        "Hedi Berriche" <hedi.berriche@hpe.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Travis <mike.travis@hpe.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Russ Anderson <russ.anderson@hpe.com>,
        "Steve Wahl" <steve.wahl@hpe.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andy@infradead.org" <andy@infradead.org>,
        "armijn@tjaldur.nl" <armijn@tjaldur.nl>,
        "bp@alien8.de" <bp@alien8.de>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "kjlu@umn.edu" <kjlu@umn.edu>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: RE: [PATCH AUTOSEL 5.3 169/203] x86/platform/uv: Fix kmalloc() NULL
 check routine
Thread-Topic: [PATCH AUTOSEL 5.3 169/203] x86/platform/uv: Fix kmalloc() NULL
 check routine
Thread-Index: AQHVeHIkSedJbnEQTUevg+MgQTj4iqdHBdUw
Date:   Wed, 2 Oct 2019 08:34:08 +0000
Message-ID: <ea163ee8ba4446978732c2c6607bd6da@AcuMS.aculab.com>
References: <20190922184350.30563-1-sashal@kernel.org>
 <20190922184350.30563-169-sashal@kernel.org>
 <20190922202544.GA2719513@kroah.com> <20191001160601.GX8171@sasha-vm>
In-Reply-To: <20191001160601.GX8171@sasha-vm>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: A4o3tKQ9OZitIOq_xjIfUQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin
> Sent: 01 October 2019 17:06
> Subject: Re: [PATCH AUTOSEL 5.3 169/203] x86/platform/uv: Fix kmalloc() NULL check routine
> 
> On Sun, Sep 22, 2019 at 10:25:44PM +0200, Greg KH wrote:
> >On Sun, Sep 22, 2019 at 02:43:15PM -0400, Sasha Levin wrote:
> >> From: Austin Kim <austindh.kim@gmail.com>
> >>
> >> [ Upstream commit 864b23f0169d5bff677e8443a7a90dfd6b090afc ]
> >>
> >> The result of kmalloc() should have been checked ahead of below statement:
> >>
> >> 	pqp = (struct bau_pq_entry *)vp;
> >>
> >> Move BUG_ON(!vp) before above statement.
> >>
> >> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
...
> >> ---
> >>  arch/x86/platform/uv/tlb_uv.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
> >> index 20c389a91b803..5f0a96bf27a1f 100644
> >> --- a/arch/x86/platform/uv/tlb_uv.c
> >> +++ b/arch/x86/platform/uv/tlb_uv.c
> >> @@ -1804,9 +1804,9 @@ static void pq_init(int node, int pnode)
> >>
> >>  	plsize = (DEST_Q_SIZE + 1) * sizeof(struct bau_pq_entry);
> >>  	vp = kmalloc_node(plsize, GFP_KERNEL, node);
> >> -	pqp = (struct bau_pq_entry *)vp;
> >> -	BUG_ON(!pqp);
> >> +	BUG_ON(!vp);
> >>
> >> +	pqp = (struct bau_pq_entry *)vp;
> >>  	cp = (char *)pqp + 31;
> >>  	pqp = (struct bau_pq_entry *)(((unsigned long)cp >> 5) << 5);
> >>
> >
> >How did this even get merged in the first place?  I thought a number of
> >us complained about it.
> >
> >This isn't any change in code, and the original is just fine, the author
> >didn't realize how C works :(

Mind you, the code itself if pretty horrid.
Looks like it is aligning to 32 bytes, easier done by:
	pqp = (void *)((unsigned long)vp + 31 & ~31);
(and there's a roundup macro to obfuscate it somewhere.)
But I'd also expect to see a matching '+ 31' in the size passed to kmalloc().
Not to mention a comment!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

