Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620B638C471
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 12:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhEUKRJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 21 May 2021 06:17:09 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:60247 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232690AbhEUKRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 06:17:08 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-60-mPtdTae_O0O4mr9Plldzpg-1; Fri, 21 May 2021 11:15:43 +0100
X-MC-Unique: mPtdTae_O0O4mr9Plldzpg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 21 May 2021 11:15:41 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 21 May 2021 11:15:41 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marco Elver' <elver@google.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "glider@google.com" <glider@google.com>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        Mel Gorman <mgorman@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] kfence: use TASK_IDLE when awaiting allocation
Thread-Topic: [PATCH] kfence: use TASK_IDLE when awaiting allocation
Thread-Index: AQHXThvT1D7AluRty02nSL8F2LU+eKrtrQGA///ysoCAABhIIA==
Date:   Fri, 21 May 2021 10:15:41 +0000
Message-ID: <4a93b6d6c82049fc83004104f3e76fd7@AcuMS.aculab.com>
References: <20210521083209.3740269-1-elver@google.com>
 <bc14f4f1a3874e55bef033246768a775@AcuMS.aculab.com>
 <YKeBvR0sZGTqX4fG@elver.google.com>
In-Reply-To: <YKeBvR0sZGTqX4fG@elver.google.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver
> Sent: 21 May 2021 10:48
> 
> On Fri, May 21, 2021 at 09:39AM +0000, David Laight wrote:
> > From: Marco Elver
> > > Sent: 21 May 2021 09:32
> > >
> > > Since wait_event() uses TASK_UNINTERRUPTIBLE by default, waiting for an
> > > allocation counts towards load. However, for KFENCE, this does not make
> > > any sense, since there is no busy work we're awaiting.
> > >
> > > Instead, use TASK_IDLE via wait_event_idle() to not count towards load.
> >
> > Doesn't that let the process be interruptible by a signal.
> > Which is probably not desirable.
> >
> > There really ought to be a way of sleeping with TASK_UNINTERRUPTIBLE
> > without changing the load-average.
> 
> That's what TASK_IDLE is:
> 
> 	include/linux/sched.h:#define TASK_IDLE                 (TASK_UNINTERRUPTIBLE | TASK_NOLOAD)

That's been added since I last tried to stop tasks updating
the load-average :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

