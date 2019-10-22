Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75C85E0109
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 11:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731437AbfJVJrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 05:47:42 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:53627 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730619AbfJVJrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 05:47:41 -0400
Received: from xps13 (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 295AD24000B;
        Tue, 22 Oct 2019 09:47:36 +0000 (UTC)
Date:   Tue, 22 Oct 2019 11:47:35 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        linux-mtd@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: spear_smi: Fix nonalignment not handled in
 memcpy_toio
Message-ID: <20191022114735.0321864e@xps13>
In-Reply-To: <20191022092619.GQ25745@shell.armlinux.org.uk>
References: <20191018143643.29676-1-miquel.raynal@bootlin.com>
        <20191022082643.GO25745@shell.armlinux.org.uk>
        <20191022111707.4b117b99@xps13>
        <20191022092619.GQ25745@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Russell,

Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote on Tue, 22
Oct 2019 10:26:19 +0100:

> On Tue, Oct 22, 2019 at 11:17:07AM +0200, Miquel Raynal wrote:
> > Hi Russell,
> > 
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote on Tue, 22
> > Oct 2019 09:26:43 +0100:
> >   
> > > On Fri, Oct 18, 2019 at 04:36:43PM +0200, Miquel Raynal wrote:  
> > > > Any write with either dd or flashcp to a device driven by the
> > > > spear_smi.c driver will pass through the spear_smi_cpy_toio()
> > > > function. This function will get called for chunks of up to 256 bytes.
> > > > If the amount of data is smaller, we may have a problem if the data
> > > > length is not 4-byte aligned. In this situation, the kernel panics
> > > > during the memcpy:
> > > > 
> > > >     # dd if=/dev/urandom bs=1001 count=1 of=/dev/mtd6
> > > >     spear_smi_cpy_toio [620] dest c9070000, src c7be8800, len 256
> > > >     spear_smi_cpy_toio [620] dest c9070100, src c7be8900, len 256
> > > >     spear_smi_cpy_toio [620] dest c9070200, src c7be8a00, len 256
> > > >     spear_smi_cpy_toio [620] dest c9070300, src c7be8b00, len 233
> > > >     Unhandled fault: external abort on non-linefetch (0x808) at 0xc90703e8
> > > >     [...]
> > > >     PC is at memcpy+0xcc/0x330    
> > > 
> > > I need the full oops if you want me to comment on this.  
> > 
> > FYI, I ran the dd command within a for loop, incrementing the block size
> > (bs) by one byte, if failed with bs=6.
> > 
> > Disabling WB_MODE (burst mode) does not change anything.
> > 
> > Adding a wmb() right after the memcpy_toio() prevents the fault.  
> 
> Thanks.  Can you check what the result of the write buffer test earlier
> in the kernel boot is?
> 
> CPU: Testing write buffer coherency: ...
> 
> ?

CPU: Testing write buffer coherency: ok

