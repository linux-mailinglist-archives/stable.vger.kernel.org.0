Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D5224835A
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 12:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgHRKvP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 18 Aug 2020 06:51:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:49317 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgHRKvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 06:51:14 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-260-G5r0pcOFMbyYB4RLBkBNvw-1; Tue, 18 Aug 2020 11:51:10 +0100
X-MC-Unique: G5r0pcOFMbyYB4RLBkBNvw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 18 Aug 2020 11:51:10 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 18 Aug 2020 11:51:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Machek' <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jbaron@akamai.com" <jbaron@akamai.com>,
        Jim Cromie <jim.cromie@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 4.19 051/168] dyndbg: fix a BUG_ON in
 ddebug_describe_flags
Thread-Topic: [PATCH 4.19 051/168] dyndbg: fix a BUG_ON in
 ddebug_describe_flags
Thread-Index: AQHWdUUneEPvJNItSUSCIe9vwuCkwak9r22g
Date:   Tue, 18 Aug 2020 10:51:10 +0000
Message-ID: <ddf46b3266034a1e987c8725f8042e34@AcuMS.aculab.com>
References: <20200817143733.692105228@linuxfoundation.org>
 <20200817143736.291298404@linuxfoundation.org> <20200818095124.GD10974@amd>
In-Reply-To: <20200818095124.GD10974@amd>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek
> Sent: 18 August 2020 10:51
> 
> On Mon 2020-08-17 17:16:22, Greg Kroah-Hartman wrote:
> > From: Jim Cromie <jim.cromie@gmail.com>
> >
> > [ Upstream commit f678ce8cc3cb2ad29df75d8824c74f36398ba871 ]
> >
> > ddebug_describe_flags() currently fills a caller provided string buffer,
> > after testing its size (also passed) in a BUG_ON.  Fix this by
> > replacing them with a known-big-enough string buffer wrapped in a
> > struct, and passing that instead.
> >
> > Also simplify ddebug_describe_flags() flags parameter from a struct to
> > a member in that struct, and hoist the member deref up to the caller.
> > This makes the function reusable (soon) where flags are unpacked.
> 
> Original code was correct, passing explicit size, this passes strange
> structure. BUG_ON can never trigger in the origianl code, so this is
> not a bugfix.

Embedding the char[] in a struct can be used to ensure that
an incorrect size isn't passed.

But it still doesn't make it any more correct to not
check the actual buffer won't be overrun.

In this case the code is still assuming that the buffer
is large enough.

Odd code changes could (probably) still break it.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

