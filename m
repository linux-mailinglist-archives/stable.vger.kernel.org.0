Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0A31B0477
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 10:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDTIcP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 20 Apr 2020 04:32:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:41623 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726024AbgDTIcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 04:32:15 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-144-ytu68FhSP0OyuLwZ_F5FAA-1; Mon, 20 Apr 2020 09:32:11 +0100
X-MC-Unique: ytu68FhSP0OyuLwZ_F5FAA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 20 Apr 2020 09:32:10 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 20 Apr 2020 09:32:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "ardb@kernel.org" <ardb@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to
 PAGE_SIZE chunks
Thread-Topic: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to
 PAGE_SIZE chunks
Thread-Index: AQHWFulYDH0V5tv/A0qK2BVsZYhuYaiBq3xQ
Date:   Mon, 20 Apr 2020 08:32:10 +0000
Message-ID: <2cdb57f2cdbd49e9bb1034d01d054bb7@AcuMS.aculab.com>
References: <20200420075711.2385190-1-Jason@zx2c4.com>
In-Reply-To: <20200420075711.2385190-1-Jason@zx2c4.com>
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

From: Jason A. Donenfeld
> Sent: 20 April 2020 08:57
> 
> The initial Zinc patchset, after some mailing list discussion, contained
> code to ensure that kernel_fpu_enable would not be kept on for more than
> a PAGE_SIZE chunk, since it disables preemption. The choice of PAGE_SIZE
> isn't totally scientific, but it's not a bad guess either, and it's
> what's used in both the x86 poly1305 and blake2s library code already.
> Unfortunately it appears to have been left out of the final patchset
> that actually added the glue code. So, this commit adds back the
> PAGE_SIZE chunking.
> 
...
> ---
> Eric, Ard - I'm wondering if this was in fact just an oversight in Ard's
> patches, or if there was actually some later discussion in which we
> concluded that the PAGE_SIZE chunking wasn't required, perhaps because
> of FPU changes. If that's the case, please do let me know, in which case
> I'll submit a _different_ patch that removes the chunking from x86 poly
> and blake. I can't find any emails that would indicate that, but I might
> be mistaken.

Maybe kernel_fp_begin() should be passed the address of somewhere
the address of an fpu save area buffer can be written to.
Then the pre-emption code can allocate the buffer and save the
state into it.

However that doesn't solve the problem for non-preemptive kernels.
The may need a cond_resched() in the loop if it might take 1ms (or so).

kernel_fpu_begin() ought also be passed a parameter saying which
fpu features are required, and return which are allocated.
On x86 this could be used to check for AVX512 (etc) which may be
available in an ISR unless it interrupted inside a kernel_fpu_begin()
section (etc).
It would also allow optimisations if only 1 or 2 fpu registers are
needed (eg for some of the crypto functions) rather than the whole
fpu register set.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

