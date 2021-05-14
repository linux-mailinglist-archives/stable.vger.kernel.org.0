Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B71B380A38
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 15:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhENNOg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 14 May 2021 09:14:36 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:30411 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231756AbhENNOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 09:14:35 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-76-GxO-xKM-MNOH8CDoNhHeWQ-1; Fri, 14 May 2021 14:13:21 +0100
X-MC-Unique: GxO-xKM-MNOH8CDoNhHeWQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 14 May 2021 14:13:19 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 14 May 2021 14:13:19 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Thomas Gleixner' <tglx@linutronix.de>,
        'Maximilian Luz' <luzmaximilian@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
CC:     "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Topic: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Index: AQHXR3+B5Hf0DG1T80+Lb/Y+9zG7TarhDftggAATCoCAABWukIABrCMAgAATcQA=
Date:   Fri, 14 May 2021 13:13:19 +0000
Message-ID: <bbf5d417ee0d4edbbed31f19ef40fad0@AcuMS.aculab.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com>
 <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
 <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com>
 <87tun54gg3.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87tun54gg3.ffs@nanos.tec.linutronix.de>
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

From: Thomas Gleixner
> Sent: 14 May 2021 14:02
> 
> David,
> 
> On Thu, May 13 2021 at 10:36, David Laight wrote:
> 
> >> -----Original Message-----
> >> From: Maximilian Luz <luzmaximilian@gmail.com>
> 
> can you please fix your mail client and spare us the useless header
> duplication in the reply?

I have to delete them by hand - must have forgotten, I can't fix outlook :-)

> > It is also worth noting that the probe code is spectacularly crap.
> > It writes 0xff and then checks that 0xff is read back.
> > Almost anything (including a failed PCIe read to the ISA bridge)
> > will return 0xff and make the test pass.
> 
>         unsigned char probe_val = ~(1 << PIC_CASCADE_IR);
> 
> 	outb(probe_val, PIC_MASTER_IMR);
> 	new_val = inb(PIC_MASTER_IMR);
> 
> How is that writing 0xFF?

Sorry I misread the code and diagnostic output.

In any case writing a value and expecting the same value back
isn't exactly a high-quality probe.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

