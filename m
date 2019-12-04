Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9085A112DC7
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 15:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfLDOwP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 4 Dec 2019 09:52:15 -0500
Received: from 7.mo68.mail-out.ovh.net ([46.105.63.230]:33713 "EHLO
        7.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbfLDOwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 09:52:15 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2019 09:52:13 EST
Received: from player770.ha.ovh.net (unknown [10.108.57.72])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 49C061471BD
        for <stable@vger.kernel.org>; Wed,  4 Dec 2019 15:42:35 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player770.ha.ovh.net (Postfix) with ESMTPSA id 90CCFCE77CBA;
        Wed,  4 Dec 2019 14:42:24 +0000 (UTC)
Date:   Wed, 4 Dec 2019 15:42:20 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>,
        lvivier@redhat.com, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] powerpc/xive: skip ioremap() of ESB pages for LSI
 interrupts
Message-ID: <20191204154220.7affb01f@bahia.w3ibm.bluemix.net>
In-Reply-To: <47Sfr1448xz9sR1@ozlabs.org>
References: <20191203163642.2428-1-clg@kaod.org>
        <47Sfr1448xz9sR1@ozlabs.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 14256989045691881862
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudejledgieeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdqfffguegfifdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkpheptddrtddrtddrtddpkedvrddvheefrddvtdekrddvgeeknecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejjedtrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  5 Dec 2019 00:30:56 +1100 (AEDT)
Michael Ellerman <patch-notifications@ellerman.id.au> wrote:

> On Tue, 2019-12-03 at 16:36:42 UTC, =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= wrote:
> > The PCI INTx interrupts and other LSI interrupts are handled differently
> > under a sPAPR platform. When the interrupt source characteristics are
> > queried, the hypervisor returns an H_INT_ESB flag to inform the OS
> > that it should be using the H_INT_ESB hcall for interrupt management
> > and not loads and stores on the interrupt ESB pages.
> > 
> > A default -1 value is returned for the addresses of the ESB pages. The
> > driver ignores this condition today and performs a bogus IO mapping.
> > Recent changes and the DEBUG_VM configuration option make the bug
> > visible with :
> > 
> > [    0.015518] kernel BUG at arch/powerpc/include/asm/book3s/64/pgtable.h:612!
> > [    0.015578] Oops: Exception in kernel mode, sig: 5 [#1]
> > [    0.015627] LE PAGE_SIZE=64K MMU=Radix MMU=Hash SMP NR_CPUS=1024 NUMA pSeries
> > [    0.015697] Modules linked in:
> > [    0.015739] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.0-0.rc6.git0.1.fc32.ppc64le #1
> > [    0.015812] NIP:  c000000000f63294 LR: c000000000f62e44 CTR: 0000000000000000
> > [    0.015889] REGS: c0000000fa45f0d0 TRAP: 0700   Not tainted  (5.4.0-0.rc6.git0.1.fc32.ppc64le)
> > [    0.015971] MSR:  8000000002029033 <SF,VEC,EE,ME,IR,DR,RI,LE>  CR: 44000424  XER: 00000000
> > [    0.016050] CFAR: c000000000f63128 IRQMASK: 0
> > [    0.016050] GPR00: c000000000f62e44 c0000000fa45f360 c000000001be5400 0000000000000000
> > [    0.016050] GPR04: c0000000019c7d38 c0000000fa340030 00000000fa330009 c000000001c15e18
> > [    0.016050] GPR08: 0000000000000040 ffe0000000000000 0000000000000000 8418dd352dbd190f
> > [    0.016050] GPR12: 0000000000000000 c000000001e00000 c00a000080060000 c00a000080060000
> > [    0.016050] GPR16: 0000ffffffffffff 80000000000001ae c000000001c24d98 ffffffffffff0000
> > [    0.016050] GPR20: c00a00008007ffff c000000001cafca0 c00a00008007ffff ffffffffffff0000
> > [    0.016050] GPR24: c00a000080080000 c00a000080080000 c000000001cafca8 c00a000080080000
> > [    0.016050] GPR28: c0000000fa32e010 c00a000080060000 ffffffffffff0000 c0000000fa330000
> > [    0.016711] NIP [c000000000f63294] ioremap_page_range+0x4c4/0x6e0
> > [    0.016778] LR [c000000000f62e44] ioremap_page_range+0x74/0x6e0
> > [    0.016846] Call Trace:
> > [    0.016876] [c0000000fa45f360] [c000000000f62e44] ioremap_page_range+0x74/0x6e0 (unreliable)
> > [    0.016969] [c0000000fa45f460] [c0000000000934bc] do_ioremap+0x8c/0x120
> > [    0.017037] [c0000000fa45f4b0] [c0000000000938e8] __ioremap_caller+0x128/0x140
> > [    0.017116] [c0000000fa45f500] [c0000000000931a0] ioremap+0x30/0x50
> > [    0.017184] [c0000000fa45f520] [c0000000000d1380] xive_spapr_populate_irq_data+0x170/0x260
> > [    0.017263] [c0000000fa45f5c0] [c0000000000cc90c] xive_irq_domain_map+0x8c/0x170
> > [    0.017344] [c0000000fa45f600] [c000000000219124] irq_domain_associate+0xb4/0x2d0
> > [    0.017424] [c0000000fa45f690] [c000000000219fe0] irq_create_mapping+0x1e0/0x3b0
> > [    0.017506] [c0000000fa45f730] [c00000000021ad6c] irq_create_fwspec_mapping+0x27c/0x3e0
> > [    0.017586] [c0000000fa45f7c0] [c00000000021af68] irq_create_of_mapping+0x98/0xb0
> > [    0.017666] [c0000000fa45f830] [c0000000008d4e48] of_irq_parse_and_map_pci+0x168/0x230
> > [    0.017746] [c0000000fa45f910] [c000000000075428] pcibios_setup_device+0x88/0x250
> > [    0.017826] [c0000000fa45f9a0] [c000000000077b84] pcibios_setup_bus_devices+0x54/0x100
> > [    0.017906] [c0000000fa45fa10] [c0000000000793f0] __of_scan_bus+0x160/0x310
> > [    0.017973] [c0000000fa45faf0] [c000000000075fc0] pcibios_scan_phb+0x330/0x390
> > [    0.018054] [c0000000fa45fba0] [c00000000139217c] pcibios_init+0x8c/0x128
> > [    0.018121] [c0000000fa45fc20] [c0000000000107b0] do_one_initcall+0x60/0x2c0
> > [    0.018201] [c0000000fa45fcf0] [c000000001384624] kernel_init_freeable+0x290/0x378
> > [    0.018280] [c0000000fa45fdb0] [c000000000010d24] kernel_init+0x2c/0x148
> > [    0.018348] [c0000000fa45fe20] [c00000000000bdbc] ret_from_kernel_thread+0x5c/0x80
> > [    0.018427] Instruction dump:
> > [    0.018468] 41820014 3920fe7f 7d494838 7d290074 7929d182 f8e10038 69290001 0b090000
> > [    0.018552] 7a098420 0b090000 7bc95960 7929a802 <0b090000> 7fc68b78 e8610048 7dc47378
> > 
> > Cc: stable@vger.kernel.org # v4.14+
> > Fixes: bed81ee181dd ("powerpc/xive: introduce H_INT_ESB hcall")
> > Signed-off-by: Cédric Le Goater <clg@kaod.org>
> 
> Applied to powerpc fixes, thanks.
> 
> https://git.kernel.org/powerpc/c/b67a95f2abff0c34e5667c15ab8900de73d8d087
> 

My R-b tag is missing... I guess I didn't review it quick enough :)

> cheers

