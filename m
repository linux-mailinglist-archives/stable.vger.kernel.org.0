Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1068C1C3F9C
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 18:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgEDQRE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 4 May 2020 12:17:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:48392 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729581AbgEDQRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 12:17:04 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-39-uzlKmwNAOK6q6QlcHfY66Q-1; Mon, 04 May 2020 17:15:42 +0100
X-MC-Unique: uzlKmwNAOK6q6QlcHfY66Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 4 May 2020 17:15:41 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 4 May 2020 17:15:41 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Hellwig' <hch@infradead.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
CC:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/i915: check to see if SIMD registers are available
 before using SIMD
Thread-Topic: [PATCH] drm/i915: check to see if SIMD registers are available
 before using SIMD
Thread-Index: AQHWIi2IJD6S33S1cEGYb8jR4+2/zKiYGMQA
Date:   Mon, 4 May 2020 16:15:41 +0000
Message-ID: <cb9e8125a94e4efc8733967a5b47be88@AcuMS.aculab.com>
References: <20200430221016.3866-1-Jason@zx2c4.com>
 <20200501180731.GA2485@infradead.org>
 <158853721918.8377.18286963845226122104@build.alporthouse.com>
 <20200504160314.GA26373@infradead.org>
In-Reply-To: <20200504160314.GA26373@infradead.org>
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

From: Christoph Hellwig
> Sent: 04 May 2020 17:03
> 
> On Sun, May 03, 2020 at 09:20:19PM +0100, Chris Wilson wrote:
> > > Err, why does i915 implements its own uncached memcpy instead of relying
> > > on core functionality to start with?
> >
> > What is this core functionality that provides movntqda?
> 
> A sensible name might be memcpy_uncached or mempcy_nontemporal.
> But the important point is that this should be arch code with a common
> fallback rather than hacking it up in drivers.

More the point, you are trying to do a copy where:
1) The kernel isn't expected to read the data - so can bypass the cache.
and maybe:
2) The data needs flushing from the cache to actual memory.
and maybe:
3) The cache lines need invalidating.

The fallbacks depend on the required behaviour.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

