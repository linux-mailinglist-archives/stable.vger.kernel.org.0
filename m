Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D2967702C
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjAVPen convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 22 Jan 2023 10:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjAVPem (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:34:42 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5050522016
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:34:40 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-119-RGTkmPo5N8SxIyIu6i-JoQ-1; Sun, 22 Jan 2023 15:34:37 +0000
X-MC-Unique: RGTkmPo5N8SxIyIu6i-JoQ-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sun, 22 Jan
 2023 15:34:35 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Sun, 22 Jan 2023 15:34:35 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marc Zyngier' <maz@kernel.org>, Leon Romanovsky <leon@kernel.org>
CC:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "elena.reshetova@intel.com" <elena.reshetova@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Thread-Topic: [PATCH 1/2] PCI/MSI: Cache the MSIX table size
Thread-Index: AQHZLlBNW/hs6U8HNk6tbQqnXl3oAq6qh0bQ
Date:   Sun, 22 Jan 2023 15:34:34 +0000
Message-ID: <70d987962acf454f8db4dd131a858b55@AcuMS.aculab.com>
References: <20230119170633.40944-1-alexander.shishkin@linux.intel.com>
        <20230119170633.40944-2-alexander.shishkin@linux.intel.com>
        <Y8z7FPcuDXDBi+1U@unreal> <86fsc2n8fp.wl-maz@kernel.org>
In-Reply-To: <86fsc2n8fp.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier
> Sent: 22 January 2023 10:57
> 
> On Sun, 22 Jan 2023 09:00:04 +0000,
> Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Thu, Jan 19, 2023 at 07:06:32PM +0200, Alexander Shishkin wrote:
> > > A malicious device can change its MSIX table size between the table
> > > ioremap() and subsequent accesses, resulting in a kernel page fault in
> > > pci_write_msg_msix().
> > >
> > > To avoid this, cache the table size observed at the moment of table
> > > ioremap() and use the cached value. This, however, does not help drivers
> > > that peek at the PCIE_MSIX_FLAGS register directly.
> > >
> > > Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/pci/msi/api.c | 7 ++++++-
> > >  drivers/pci/msi/msi.c | 2 +-
> > >  include/linux/pci.h   | 1 +
> > >  3 files changed, 8 insertions(+), 2 deletions(-)
> >
> > I'm not security expert here, but not sure that this protects from anything.
> > 1. Kernel relies on working and not-malicious HW. There are gazillion ways
> > to cause crashes other than changing MSI-X.
> > 2. Device can report large table size, kernel will cache it and
> > malicious device will reduce it back. It is not handled and will cause
> > to kernel crash too.
> >
> 
> Indeed, this was my exact reaction reading this patch. This only makes
> sure the same (potentially wrong) value is used at all times. So while
> this results in a consistent use, this doesn't give much guarantee.

Yep, the device can 'choose' to error any PCIe read.

> The only way to deal with this is to actually handle the resulting
> fault, similar to what the kernel does when accessing userspace. Not
> sure how possible this is with something like PCIe.

I don't think you get a fault, the PCIe read completes with value ~0.
You might get an AER indication, that may not be helpful at all.
We've some x86 systems where that ends up as an NMI and panic!

A more valid reason for caching the MSIX table size is to avoid
doing a slow PCIe read.
I'm not sure how fast they are on 'normal' hardware, but the Altera
fpga we use is particularly pedestrian.
I just measured back-to-back reads at 126 clocks of the internal
125MHz clock so almost exactly 1us - or 3000 clocks of a 3GHz cpu.
(I added PCIe trace to the fpga so we can see what goes on.)

There is actually a much more 'interesting' issue with MSIX.
There are 16 bytes of data for each interrupt.

The kernel doesn't even try to ensure they are written as
a single PCIe TLP, and even if it did there is no real
guarantee the writes aren't split before the logic that
raises interrupts reads the values.

It is also quite likely that the interrupt raising logic
doesn't to an atomic read of all 16 bytes, so a cpu write
could split the reads.

This doesn't normally matter - the interrupt is enabled long
after the address/data fields are initialised.
But if the interrupt affinity is changed both the address and
data fields are likely to be changed on an interrupt that is
(nominally) enabled.

It is pretty easy to imagine the new address being used with
the old data (or v.v.) or even a 'torn read' of the 64bit
address field.

I don't remember seeing anything in the MSIX spec about
requirements on the hardware - which puts the onus on
the software to ensure the MSIX data is always valid.
This means that changing the vector needs to:
	Disable the interrupt.
	Delay (a read from the MSIX block is probably enough).
	Update the address and data.
	Delay.
	Enable the interrupt.
But I don't remember seeing the kernel to any of that.

	David.

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

