Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE097E0082
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 11:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbfJVJRN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 22 Oct 2019 05:17:13 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:50863 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388006AbfJVJRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 05:17:13 -0400
Received: from xps13 (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id A20A320001B;
        Tue, 22 Oct 2019 09:17:08 +0000 (UTC)
Date:   Tue, 22 Oct 2019 11:17:07 +0200
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
Message-ID: <20191022111707.4b117b99@xps13>
In-Reply-To: <20191022082643.GO25745@shell.armlinux.org.uk>
References: <20191018143643.29676-1-miquel.raynal@bootlin.com>
        <20191022082643.GO25745@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Russell,

Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote on Tue, 22
Oct 2019 09:26:43 +0100:

> On Fri, Oct 18, 2019 at 04:36:43PM +0200, Miquel Raynal wrote:
> > Any write with either dd or flashcp to a device driven by the
> > spear_smi.c driver will pass through the spear_smi_cpy_toio()
> > function. This function will get called for chunks of up to 256 bytes.
> > If the amount of data is smaller, we may have a problem if the data
> > length is not 4-byte aligned. In this situation, the kernel panics
> > during the memcpy:
> > 
> >     # dd if=/dev/urandom bs=1001 count=1 of=/dev/mtd6
> >     spear_smi_cpy_toio [620] dest c9070000, src c7be8800, len 256
> >     spear_smi_cpy_toio [620] dest c9070100, src c7be8900, len 256
> >     spear_smi_cpy_toio [620] dest c9070200, src c7be8a00, len 256
> >     spear_smi_cpy_toio [620] dest c9070300, src c7be8b00, len 233
> >     Unhandled fault: external abort on non-linefetch (0x808) at 0xc90703e8
> >     [...]
> >     PC is at memcpy+0xcc/0x330  
> 
> I need the full oops if you want me to comment on this.

FYI, I ran the dd command within a for loop, incrementing the block size
(bs) by one byte, if failed with bs=6.

Disabling WB_MODE (burst mode) does not change anything.

Adding a wmb() right after the memcpy_toio() prevents the fault.

Here is the full trace when writing 1001 bytes:

# dd if=/dev/urandom bs=1001 count=1 of=/dev/mtd6
Unhandled fault: external abort on non-linefetch (0x808) at 0xc90703e8
pgd = c7be8000
[c90703e8] *pgd=f8000452(bad)
Internal error: : 808 [#1] ARM
Modules linked in:
CPU: 0 PID: 660 Comm: dd Not tainted 4.14.0-00045-gf5d08192704f-dirty #6
Hardware name: ST SPEAr600 (Flattened Device Tree)
task: c7a05080 task.stack: c7bd2000
PC is at memcpy+0xcc/0x330
LR is at 0x13f0ec28
pc : [<c044344c>]    lr : [<13f0ec28>]    psr: 80000013
sp : c7bd3e44  ip : 00000018  fp : 000003e9
r10: 00000000  r9 : c7a9959c  r8 : c7bd3eac
r7 : c7a99590  r6 : c7afb438  r5 : 00000300  r4 : 5171436c
r3 : 00000058  r2 : 80000000  r1 : c7be4be9  r0 : c90703e8
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 0005317f  Table: 07be8000  DAC: 00000051
Process dd (pid: 660, stack limit = 0xc7bd2190)
Stack: (0xc7bd3e44 to 0xc7bd4000)
3e40:          c9070300 000000e9 c0290d14 c9070300 c7be4b00 0001046f c9070000
3e60: c7afb418 00000000 c7bd3e98 000003e9 c7bd3f88 000003e9 00000000 000c0008
3e80: 00000051 c7bd2000 c7be4800 c028e57c 000003e9 c7bd3eac c7be4800 00000000
3ea0: c7bf73c0 c7addc00 000003e9 00000300 00000000 00000000 00000000 00000000
3ec0: 00000000 00000000 00000000 00000000 00000000 000003e9 c028e4bc c7962a80
3ee0: c7bd3f88 00000000 c7bd2000 00000000 000bf990 c00bdb0c 000bf990 c00bd878
3f00: 00000000 00000000 00000000 c7bd3f10 c7a688c0 c009eedc c7becb58 000c0000
3f20: 00000003 c7962460 c7962484 00000000 00000000 c045c2f8 00000003 c00d9e58
3f40: 000003e9 000c0008 c7962a80 c7bd3f88 00000000 c7bd2000 00000000 c00bddb4
3f60: 000bf990 c00bda6c 00000000 c7962a80 c7962a80 000c0008 000003e9 c000a804
3f80: c7bd2000 c00bdfa4 00000000 00000000 00000000 000bfd94 00000001 000c0008
3fa0: 00000004 c000a640 000bfd94 00000001 00000001 000c0008 000003e9 be8e8f53
3fc0: 000bfd94 00000001 000c0008 00000004 000c0008 000c0008 000003e9 000bf990
3fe0: 00000000 be8e8ba4 0000ea3c b6eba7ec 60000010 00000001 00000000 00000000
[<c044344c>] (memcpy) from [<c0290d14>] (spear_mtd_write+0x240/0x294)
[<c0290d14>] (spear_mtd_write) from [<c028e57c>] (mtdchar_write+0xc0/0x230)
[<c028e57c>] (mtdchar_write) from [<c00bdb0c>] (__vfs_write+0x1c/0x128)
[<c00bdb0c>] (__vfs_write) from [<c00bddb4>] (vfs_write+0xa0/0x168)
[<c00bddb4>] (vfs_write) from [<c00bdfa4>] (SyS_write+0x3c/0x90)
[<c00bdfa4>] (SyS_write) from [<c000a640>] (ret_fast_syscall+0x0/0x44)
Code: e1b02f82 14d13001 24d14001 24d1c001 (14c03001) 
---[ end trace f9a736cc2841cf14 ]---
Segmentation fault


Thanks,
Miquèl
