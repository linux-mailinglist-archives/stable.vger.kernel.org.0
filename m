Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B0B380DCE
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 18:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhENQNT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 14 May 2021 12:13:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:55942 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232438AbhENQNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 12:13:18 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-42-RnSQRdgJN7GtQvKTp4FKEQ-1; Fri, 14 May 2021 17:12:04 +0100
X-MC-Unique: RnSQRdgJN7GtQvKTp4FKEQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 14 May 2021 17:12:01 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 14 May 2021 17:12:01 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Thomas Gleixner' <tglx@linutronix.de>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
CC:     "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Topic: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Index: AQHXR3+B5Hf0DG1T80+Lb/Y+9zG7TarhDftggAHxr5WAACbXIA==
Date:   Fri, 14 May 2021 16:12:01 +0000
Message-ID: <f0f52e319c06462ea0b5fbba827df9e0@AcuMS.aculab.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com>
 <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
 <87r1i94eg6.ffs@nanos.tec.linutronix.de>
In-Reply-To: <87r1i94eg6.ffs@nanos.tec.linutronix.de>
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
> Sent: 14 May 2021 14:45
> 
> Max,
> 
> On Thu, May 13 2021 at 12:11, Maximilian Luz wrote:
> > And lastly, if that's any help at all: The PIC device is described in
> > ACPI in [3]. The Surface Laptop 3 also has an AMD CPU (although a prior
> > generation) and has the PIC described in the exact same way (can also be
> > found in that repository), but doesn't exhibit that behavior (and
> > doesn't show the "Using NULL legacy PIC" line). I expect there's not
> > much you can change to that definition so that's probably irrelevant
> > here.
> >
> > Again, I don't really know anything about these devices, so my guess
> > would be bad hardware revision or bad firmware revision. All I know is
> > that retrying seems to "fix" it.
> 
> That might be a a power optimization thing.
> 
> Except for older systems the PIC is not really required for IOAPiC to
> work. But there is some historical code which makes assumptions. We can
> change that, but that needs some careful thoughts.

A more interesting probe would be:
- Write some value to register 1 - the mask.
- Write 9 to register zero (selects interrupt in service register).
- Read register 0 - should be zero since we aren't in as ISR.
- Read register 1 - should get the mask back.
You can also write 8 to register 0, reads then return the pending interrupts.
Their might be pending interrupts - so that value can't be checked.

But if reads start returning the last written value you might only
have capacitors on the data bus.

The required initialisation registers are pretty fixed for the PC hardware.
But finding the values requires a bit of work.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

