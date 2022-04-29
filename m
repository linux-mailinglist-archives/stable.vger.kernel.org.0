Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5468D514F43
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 17:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378354AbiD2P2M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 29 Apr 2022 11:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377960AbiD2P2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 11:28:11 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDCA5D4C55
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 08:24:52 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-148-H2iRa9rHN0SC6_3kj-vIRQ-1; Fri, 29 Apr 2022 16:24:49 +0100
X-MC-Unique: H2iRa9rHN0SC6_3kj-vIRQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 29 Apr 2022 16:24:48 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.033; Fri, 29 Apr 2022 16:24:48 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Maciej W. Rozycki'" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
CC:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] MIPS: Fix CP0 counter erratum detection for R4k CPUs
Thread-Topic: [PATCH] MIPS: Fix CP0 counter erratum detection for R4k CPUs
Thread-Index: AQHYW7e8izRkWzTXwESA/9rrqnvRW60HAA6w
Date:   Fri, 29 Apr 2022 15:24:48 +0000
Message-ID: <3582358fb8ae47d7b88f85aa895a7109@AcuMS.aculab.com>
References: <alpine.DEB.2.21.2204240214430.9383@angie.orcam.me.uk>
 <20220429100128.GB11365@alpha.franken.de>
 <alpine.DEB.2.21.2204291119040.9383@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2204291119040.9383@angie.orcam.me.uk>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>  That said reading from the 8254 is messy too and you may need a spinlock
> (you need to write the Counter Latch or Read-Back command to the control
> register and then issue consecutive two reads to the requested timer's
> data register[2]).  Which is I guess why support for it has been removed
> from x86 code.  For non-SMP it might be good enough.

It is important to 'latch' the counter before reading it.
I tried to optimise some code to avoid the extra accesses.
In principle it ought to have worked, but reading the
unlatched values gave garbage - not just messed up 16bit values.
It was probably returning a value that was being ripple-counted.

The sheer number of IO cycles you need to read the counters
just beggars belief.
So while they can be used to get an accurate timestamp it
really takes too long to be useful.
Even in a modern x86 chipset I think they are still ISA
speed cycles.
(Mind you, we've an fpga based PCIe boards where reads
are ISA speed....)

OTOH I'd have though that for a real 486 (one without a TSC)
that is the only way to get a high res timer count.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

