Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 872B389F4D
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 15:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfHLNMV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 12 Aug 2019 09:12:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:21918 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbfHLNMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Aug 2019 09:12:21 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-52-S7sEaJ5SOkKbQAdahhCycg-1; Mon, 12 Aug 2019 14:12:17 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 12 Aug 2019 14:12:16 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 12 Aug 2019 14:12:16 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Philipp Reisner' <philipp.reisner@linbit.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     =?iso-8859-1?Q?=27Christoph_B=F6hmwalder=27?= 
        <christoph.boehmwalder@linbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: RE: [PATCH] drbd: do not ignore signals in threads
Thread-Topic: [PATCH] drbd: do not ignore signals in threads
Thread-Index: AQHVRehdZ3MFgEc+dUGpXqE3QyW7xKbhRpmwgAr+X4CAABFvoIALFfUAgAAg40A=
Date:   Mon, 12 Aug 2019 13:12:16 +0000
Message-ID: <1fcbb94c5f264c17af3394807438ad50@AcuMS.aculab.com>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
 <ad16d006-4382-3f77-8968-6f840e58b8df@linbit.com>
 <6f8c0d1e51c242a288fbf9b32240e4c1@AcuMS.aculab.com>
 <1761552.9xIroHqhk7@fat-tyre>
In-Reply-To: <1761552.9xIroHqhk7@fat-tyre>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: S7sEaJ5SOkKbQAdahhCycg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Reisner
> Sent: 12 August 2019 12:53
> Hi Jens,
> 
> Please have a look.
> 
> With fee109901f392 Eric W. Biederman changed drbd to use send_sig()
> instead of force_sig(). That was part of a series that did this change
> in multiple call sites tree wide. Which, by accident broke drbd, since
> the signals are _not_ allowed by default. That got released with v5.2.
> 
> On July 29 Christoph 	Böhmwalder sent a patch that adds two
> allow_signal()s to fix drbd.
> 
> Then David Laight points out that he has code that can not deal
> with the send_sig() instead of force_sig() because allowed signals
> can be sent from user-space as well.
> I assume that David is referring to out of tree code, so I fear it
> is up to him to fix that to work with upstream, or initiate a
> revert of Eric's change.

While our code is 'out of tree' (you really don't want it - and since
it still uses force_sig() is fine) I suspect that the 'drdb' code
(with Christoph's allow_signal() patch) now loops in kernel if a user
sends it a signal.

If the driver (eg drdb) is using (say) SIGINT to break a thread out of
(say) a blocking kernel_accept() call then it can detect the unexpected
signal (maybe double-checking with signal_pending()) but I don't think
it can clear down the pending signal so that kernel_accept() blocks
again.

> Jens, please consider sending Christoph's path to Linus for merge in
> this cycle, or let us know how you think we should proceed.

I'm not sure what the 'correct' solution is.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

