Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2503B0745
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 16:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhFVOXw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 22 Jun 2021 10:23:52 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:31035 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231489AbhFVOXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 10:23:50 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-60-ZAfcHqbRPfSLTlwrCStpTA-1; Tue, 22 Jun 2021 15:21:28 +0100
X-MC-Unique: ZAfcHqbRPfSLTlwrCStpTA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Jun
 2021 15:21:27 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Tue, 22 Jun 2021 15:21:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alan Stern' <stern@rowland.harvard.edu>
CC:     'Mauro Carvalho Chehab' <mchehab+huawei@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "mauro.chehab@huawei.com" <mauro.chehab@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3] media: uvc: don't do DMA on stack
Thread-Topic: [PATCH v3] media: uvc: don't do DMA on stack
Thread-Index: AQHXZqL+Rr1YUDB8sUS3jMuLXE5TdKsfq6kggABLhgCAAB2gMA==
Date:   Tue, 22 Jun 2021 14:21:27 +0000
Message-ID: <c5dd6d33cb844025bc8451b46980d96b@AcuMS.aculab.com>
References: <6832dffafd54a6a95b287c4a1ef30250d6b9237a.1624282817.git.mchehab+huawei@kernel.org>
 <d33c39aa824044ad8cacc93234f1e1cd@AcuMS.aculab.com>
 <20210622132922.GB452785@rowland.harvard.edu>
In-Reply-To: <20210622132922.GB452785@rowland.harvard.edu>
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

From: Alan Stern
> Sent: 22 June 2021 14:29
...
> > Thought...
> >
> > Is kmalloc(1, GFP_KERNEL) guaranteed to return a pointer into
> > a cache line that will not be accessed by any other code?
> > (This is slightly weaker than requiring a cache-line aligned
> > pointer - but very similar.)
> 
> As I understand it, on architectures that do not have cache-coherent
> I/O, kmalloc is guaranteed to return a buffer that is
> cacheline-aligned and whose length is a multiple of the cacheline
> size.
> 
> Now, whether that buffer ends up being accessed by any other code
> depends on what your driver does with the pointer it gets from
> kmalloc.  :-)

Thanks for the clarification.

Most of the small allocates in the usb stack are for transmits
where it is only necessary to ensure a cache write-back.

I know there has been some confusion because one of the
allocators can add a small header to every allocation.
This can lead to unexpectedly inadequately aligned pointers.
If it is updated when the preceding block is freed (as some
user-space mallocs do) then it would need to be in a
completely separate cache line.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

