Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBBB1E42D0
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 14:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgE0M7j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 27 May 2020 08:59:39 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:45166 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730055AbgE0M7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 08:59:39 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-198-qX9oc7T4N0KznTx0LSTJKg-1; Wed, 27 May 2020 13:59:35 +0100
X-MC-Unique: qX9oc7T4N0KznTx0LSTJKg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 27 May 2020 13:59:35 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 27 May 2020 13:59:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'kan.liang@linux.intel.com'" <kan.liang@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "ak@linux.intel.com" <ak@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] perf/x86/intel/uncore: Fix oops when counting IMC uncore
 events on some TGL
Thread-Topic: [PATCH] perf/x86/intel/uncore: Fix oops when counting IMC uncore
 events on some TGL
Thread-Index: AQHWNCLukMKeXYb1T0G/ZA+cFsVVx6i75DXQ
Date:   Wed, 27 May 2020 12:59:35 +0000
Message-ID: <869fafc80da84d188678c1cbb0267a0b@AcuMS.aculab.com>
References: <1590582647-90675-1-git-send-email-kan.liang@linux.intel.com>
In-Reply-To: <1590582647-90675-1-git-send-email-kan.liang@linux.intel.com>
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

From: kan.liang@linux.intel.com
> Sent: 27 May 2020 13:31
> 
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> When counting IMC uncore events on some TGL machines, an oops will be
> triggered.
>   [ 393.101262] BUG: unable to handle page fault for address:
>   ffffb45200e15858
>   [ 393.101269] #PF: supervisor read access in kernel mode
>   [ 393.101271] #PF: error_code(0x0000) - not-present page
> 
> Current perf uncore driver still use the IMC MAP SIZE inherited from
> SNB, which is 0x6000.
> However, the offset of IMC uncore counters for some TGL machines is
> larger than 0x6000, e.g. 0xd8a0.
> 
> Enlarge the IMC MAP SIZE for TGL to 0xe000.

Replacing one 'random' constant with a different one
doesn't seem like a proper fix.

Surely the actual bounds of the 'memory' area are properly
defined somewhere.
Or at least should come from a table.

You also need to verify that the offsets are within the mapped area.
An unexpected offset shouldn't try to access an invalid address.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

