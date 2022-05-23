Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A4C531337
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbiEWQJ0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 23 May 2022 12:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238387AbiEWQJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 12:09:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F194186F8
        for <stable@vger.kernel.org>; Mon, 23 May 2022 09:09:24 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-312-qy4YyiMNMmOP33diHOjiWA-1; Mon, 23 May 2022 17:09:21 +0100
X-MC-Unique: qy4YyiMNMmOP33diHOjiWA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 23 May 2022 17:09:20 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 23 May 2022 17:09:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Petr Malat' <oss@malat.biz>
CC:     "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Joern Engel" <joern@lazybastard.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] mtd: phram: Map RAM using memremap instead of ioremap
Thread-Topic: [PATCH] mtd: phram: Map RAM using memremap instead of ioremap
Thread-Index: AQHYbrHUf5tSa7gm6kqFegI33HIF660si3RA///5tQCAABqkgA==
Date:   Mon, 23 May 2022 16:09:20 +0000
Message-ID: <e33f91a3eacc4aa3a08e6465fef9265c@AcuMS.aculab.com>
References: <20220523142825.3144904-1-oss@malat.biz>
 <3cab9a7f4ed34ca0b742a62c2bdc3bce@AcuMS.aculab.com>
 <Youn9AmqY6/EExDw@ntb.petris.klfree.czf>
In-Reply-To: <Youn9AmqY6/EExDw@ntb.petris.klfree.czf>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Malat
> Sent: 23 May 2022 16:28
> 
> Hi!
> 
> On Mon, May 23, 2022 at 02:51:41PM +0000, David Laight wrote:
> > From: Petr Malat
> > > Sent: 23 May 2022 15:28
> > >
> > > One can't use memcpy on memory obtained by ioremap, because IO memory
> > > may have different alignment and size access restriction than the system
> > > memory. Use memremap as phram driver operates on RAM.
> >
> > Does that actually help?
> > The memcpy() is still likely to issue unaligned accesses
> > that the hardware can't handle.
> 
> Yes, it solves the issue. Memcpy can cause unaligned access only on
> platforms, which can handle it. And on ARM64 it's handled only for
> RAM and not for a device memory (__pgprot(PROT_DEVICE_*)).

Does mapping it as memory cause it to be cached?
So the hardware only sees cache line reads (which are aligned)
and the cpu support for misaligned memory accesses then
stop the faults?

On x86 (which I know a lot more about) memcpy() has a nasty
habit of getting implemented as 'rep movsb' relying on the
cpu to speed it up.
But that doesn't happen for uncached addresses - so you get
very slow byte copies.
OTOH misaligned PCIe transfers generate TLP that have the
correct byte enables for the end words.
Provided the PCIe target isn't broken they are fine.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

