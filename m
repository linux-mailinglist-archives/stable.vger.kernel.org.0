Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B683807BA
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 12:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhENKw0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 14 May 2021 06:52:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:50728 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231127AbhENKwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 06:52:22 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-286-JaXSeoXeOtaNMmDXEJjY6Q-1; Fri, 14 May 2021 11:51:08 +0100
X-MC-Unique: JaXSeoXeOtaNMmDXEJjY6Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 14 May 2021 11:51:06 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 14 May 2021 11:51:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sachi King' <nakato@nakato.io>,
        'Maximilian Luz' <luzmaximilian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
CC:     "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Topic: [PATCH] x86/i8259: Work around buggy legacy PIC
Thread-Index: AQHXR3+B5Hf0DG1T80+Lb/Y+9zG7TarhDftggAATCoCAABWukIACG7SA//96KTA=
Date:   Fri, 14 May 2021 10:51:06 +0000
Message-ID: <f2c7f43df1e74a449bc3573addf91468@AcuMS.aculab.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
 <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com> <3034083.sOBWI1P7ec@yuki>
In-Reply-To: <3034083.sOBWI1P7ec@yuki>
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

From: Sachi King
> Sent: 14 May 2021 20:41
> 
> On Thursday, May 13, 2021 8:36:27 PM AEST David Laight wrote:
> > > -----Original Message-----
> > > From: Maximilian Luz <luzmaximilian@gmail.com>
> > > Sent: 13 May 2021 11:12
> > > To: David Laight <David.Laight@ACULAB.COM>; Thomas Gleixner
> > > <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; Borislav Petkov
> > > <bp@alien8.de>
> > > Cc: H. Peter Anvin <hpa@zytor.com>; Sachi King <nakato@nakato.io>;
> > > x86@kernel.org; linux-kernel@vger.kernel.org; stable@vger.kernel.org
> > > Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
> > >
> > > On 5/13/21 10:10 AM, David Laight wrote:
> > >
> > > > From: Maximilian Luz
> > > >
> > > >> Sent: 12 May 2021 22:05
> > > >>
> > > >>
> > > >>
> > > >> The legacy PIC on the AMD variant of the Microsoft Surface Laptop 4
> > > >> has
> > > >> some problems on boot. For some reason it consistently does not
> > > >> respond
> > > >> on the first try, requiring a couple more tries before it finally
> > > >> responds.
> > > >
> > > >
> > > >
> > > > That seems very strange, something else must be going on that causes the
> > > > grief.
> > > > The 8259 will be built into to the one of the cpu support
> > > > chips.
> > > > I can't imagine that requires anything special.
> > >
> > >
> > > Right, it's definitely strange. Both Sachi (I imagine) and I don't know
> > > much about these devices, so we're open for suggestions.
> >
> >
> > I found a copy of the datasheet (I don't seem to have the black book):
> >
> > https://pdos.csail.mit.edu/6.828/2010/readings/hardware/8259A.pdf
> >
> > The PC hardware has two 8259 in cascade mode.
> > (Cascaded using an interrupt that wasn't really using in the original
> > 8088 PC which only had one 8259.)
> >
> > I wonder if the bios has actually initialised is properly.
> > Some initialisation writes have to be done to set everything up.
> 
> I suspect by the displayed behaviour you are correct and that it has
> not.  I'm struggling to figure out who to talk to to see that is
> something that can be fixed in the firmware.
> 
> > It is also worth noting that the probe code is spectacularly crap.
> > It writes 0xff and then checks that 0xff is read back.
> > Almost anything (including a failed PCIe read to the ISA bridge)
> > will return 0xff and make the test pass.
> 
> I was under the impression that it wrote 0xfb, and 0xff would be
> considered a failure.

I probably misread it.
For anything like a probe you really need to write one value
and read back something different - that is hopefully reasonably unique.
OTOH just the write can trash the wrong hardware - many old PC
hardware probes were very dubious.

Although unlikely here (since the logic is all inside chip)
on a real IO bus with tristate drivers a write followed by
a read to an unknown address could easily return the written
value due to capacitance of the data bus.

> > It's about 35 years since I last wrote the code to initialise an 8259.
> > The memory cells are foggy.
> 
> I'm not sure the i8259 is needed on the device, as the interrupts
> appear to function on the device if I bypass the nr_legacy_irqs() check
> while the legacy_pic is set to the null_legacy_pic.
> 
> The null_legacy_pic however specifies having 0 irqs, and the io_apic
> does not allow us to set the pin attributes unless the pin we are
> attempting to set is less than nr_legacy_irqs.
> 
> The IOAPIC seems to take responsibility for the 0-15 interrupts on this
> specific hardware, should we maybe be ignoring the i8259 and looking
> into allowing interrupts 0-15 to be setup even when the legacy_pic is
> not available?

That woke up some memory cells.
IIRC on an SMP kernel the IOAPIC is always used in preference to the 8259.
So maybe the initialisation code is just plain wrong!

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

