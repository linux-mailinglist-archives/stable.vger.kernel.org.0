Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4596213C728
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgAOPQp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 Jan 2020 10:16:45 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:24412 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726165AbgAOPQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:16:45 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-195-rdpLZj8NNcWC7e3ovf19mw-1; Wed, 15 Jan 2020 15:16:41 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 15 Jan 2020 15:16:41 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 15 Jan 2020 15:16:41 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Waiman Long' <longman@redhat.com>, Christoph Hellwig <hch@lst.de>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] locking/rwsem: Fix kernel crash when spinning on
 RWSEM_OWNER_UNKNOWN
Thread-Topic: [PATCH] locking/rwsem: Fix kernel crash when spinning on
 RWSEM_OWNER_UNKNOWN
Thread-Index: AQHVy6/pULnrp2X9K02rMSrf0oH55Kfr1QMw
Date:   Wed, 15 Jan 2020 15:16:41 +0000
Message-ID: <45b976af3cf74555af7214993e7d614b@AcuMS.aculab.com>
References: <20200114190303.5778-1-longman@redhat.com>
 <20200115065055.GA21219@lst.de>
 <021830af-fd89-50e5-ad26-6061e5abdce1@redhat.com>
In-Reply-To: <021830af-fd89-50e5-ad26-6061e5abdce1@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: rdpLZj8NNcWC7e3ovf19mw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.org> On Behalf Of Waiman Long
> Sent: 15 January 2020 14:27
...
> >>  		if ((wstate == WRITER_HANDOFF) &&
> >> -		    (rwsem_spin_on_owner(sem, 0) == OWNER_NULL))
> >> +		    rwsem_spin_on_owner(sem, RWSEM_NONSPINNABLE) == OWNER_NULL)
> > Nit: the inner braces in the first half of the conditional aren't required
> > either.
> 
> I typically over-parenthesize the code to make it easier to read as we
> don't need to think too much about operator precedence to see if it is
> doing the right thing.

The problem is it actually makes it harder to read.
It is difficult for the 'mark 1 eyeball' to follow lots of sets of brackets.
Since == (etc) are the lowest priority operators (apart from ?:) they
never need ().

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

