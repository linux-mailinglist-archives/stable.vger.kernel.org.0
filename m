Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8A6DFEB6
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 09:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbfJVHwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 03:52:04 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:46129 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387938AbfJVHwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 03:52:04 -0400
Received: from windsurf (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: thomas.petazzoni@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 18CB020000F;
        Tue, 22 Oct 2019 07:52:00 +0000 (UTC)
Date:   Tue, 22 Oct 2019 09:52:00 +0200
From:   Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        Richard Weinberger <richard@nod.at>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, stable@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH] mtd: spear_smi: Fix nonalignment not handled in
 memcpy_toio
Message-ID: <20191022095200.54585032@windsurf>
In-Reply-To: <20191022094451.14d39206@xps13>
References: <20191018143643.29676-1-miquel.raynal@bootlin.com>
        <20191021100105.0f06b212@collabora.com>
        <20191022094451.14d39206@xps13>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4git49 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

+Russell in Cc.

On Tue, 22 Oct 2019 09:44:51 +0200
Miquel Raynal <miquel.raynal@bootlin.com> wrote:

> Boris Brezillon <boris.brezillon@collabora.com> wrote on Mon, 21 Oct
> 2019 10:01:05 +0200:
> 
> > On Fri, 18 Oct 2019 16:36:43 +0200
> > Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >   
> > > Any write with either dd or flashcp to a device driven by the
> > > spear_smi.c driver will pass through the spear_smi_cpy_toio()
> > > function. This function will get called for chunks of up to 256 bytes.
> > > If the amount of data is smaller, we may have a problem if the data
> > > length is not 4-byte aligned. In this situation, the kernel panics
> > > during the memcpy:
> > > 
> > >     # dd if=/dev/urandom bs=1001 count=1 of=/dev/mtd6
> > >     spear_smi_cpy_toio [620] dest c9070000, src c7be8800, len 256
> > >     spear_smi_cpy_toio [620] dest c9070100, src c7be8900, len 256
> > >     spear_smi_cpy_toio [620] dest c9070200, src c7be8a00, len 256
> > >     spear_smi_cpy_toio [620] dest c9070300, src c7be8b00, len 233
> > >     Unhandled fault: external abort on non-linefetch (0x808) at 0xc90703e8
> > >     [...]
> > >     PC is at memcpy+0xcc/0x330    
> > 
> > Can you find out which instruction is at memcpy+0xcc/0x330? For the
> > record, the assembly is here [1].  
> 
> The full disassembled file is attached, here is the failing part:
> 
> 7:			ldmfd	sp!, {r5 - r8}
>   b8:	e8bd01e0 	pop	{r5, r6, r7, r8}
> 	UNWIND(		.fnend				) @ end of second stmfd block
> 
> 	UNWIND(		.fnstart			)
> 			usave	r4, lr			  @ still in first stmdb block
> 8:			movs	r2, r2, lsl #31
>   bc:	e1b02f82 	lsls	r2, r2, #31
> 			ldr1b	r1, r3, ne, abort=21f
>   c0:	14d13001 	ldrbne	r3, [r1], #1
> 			ldr1b	r1, r4, cs, abort=21f
>   c4:	24d14001 	ldrbcs	r4, [r1], #1
> 			ldr1b	r1, ip, cs, abort=21f
>   c8:	24d1c001 	ldrbcs	ip, [r1], #1
> 			str1b	r0, r3, ne, abort=21f
>   cc:	14c03001 	strbne	r3, [r0], #1
> 			str1b	r0, r4, cs, abort=21f
>   d0:	24c04001 	strbcs	r4, [r0], #1
> 			str1b	r0, ip, cs, abort=21f
>   d4:	24c0c001 	strbcs	ip, [r0], #1
> 
> 			exit	r4, pc
>   d8:	e8bd8011 	pop	{r0, r4, pc}
> 
> 
> So the fault is triggered on a strbne instruction.

What I find odd is:

 (1) Failing on a 1-byte store instruction, which means it should have
     no alignment constraints.

 (2) Failing on a 1-byte store instruction, while switching to
     _memcpy_toio(), which does *only* 1-byte stores, works around the
     problem.

_memcpy_toio() looks like this:

void _memcpy_toio(volatile void __iomem *to, const void *from, size_t count)
{
	const unsigned char *f = from;
	while (count) {
  6c:	e3520000 	cmp	r2, #0
  70:	012fff1e 	bxeq	lr
  74:	e0802002 	add	r2, r0, r2
		count--;
		writeb(*f, to);
  78:	e4d13001 	ldrb	r3, [r1], #1
	asm volatile("strb %1, %0"
  7c:	e5c03000 	strb	r3, [r0]
		f++;
		to++;
  80:	e2800001 	add	r0, r0, #1
	while (count) {
  84:	e1500002 	cmp	r0, r2
  88:	1afffffa 	bne	78 <_memcpy_toio+0xc>
  8c:	e12fff1e 	bx	lr

So it's also doing a strb, nothing different.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
