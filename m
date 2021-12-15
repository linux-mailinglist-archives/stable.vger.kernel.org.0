Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36F6475F4F
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245535AbhLOR3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343512AbhLOR1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:27:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F959C0698C3;
        Wed, 15 Dec 2021 09:26:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18891B82046;
        Wed, 15 Dec 2021 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492AAC36AE2;
        Wed, 15 Dec 2021 17:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589213;
        bh=k0sAWTy0/CNHPEMxlawDonpGRQ5c68ushY7QL0irNPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3/CE+y4rgzeTh2kzfuT2BEFLdnKib1xQPVVRN6EYmG3PkOYb2S3f23KPUNFryIrP
         5W8u0zVXIU3ZxtaQtzxxaUmitXC8Qr583UpEckhvuWFY0DIAHbLPvtD2Vekmo95kt5
         A1XbpH3LYpeystz0MArhAX9pjQISPK4PjIPAkZk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.4 18/18] arm: ioremap: dont abuse pfn_valid() to check if pfn is in RAM
Date:   Wed, 15 Dec 2021 18:21:39 +0100
Message-Id: <20211215172023.433970063@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
References: <20211215172022.795825673@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 024591f9a6e0164ec23301784d1e6d8f6cacbe59 upstream.

The semantics of pfn_valid() is to check presence of the memory map for a
PFN and not whether a PFN is in RAM. The memory map may be present for a
hole in the physical memory and if such hole corresponds to an MMIO range,
__arm_ioremap_pfn_caller() will produce a WARN() and fail:

[    2.863406] WARNING: CPU: 0 PID: 1 at arch/arm/mm/ioremap.c:287 __arm_ioremap_pfn_caller+0xf0/0x1dc
[    2.864812] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.13.0-09882-ga180bd1d7e16 #1
[    2.865263] Hardware name: Generic DT based system
[    2.865711] Backtrace:
[    2.866063] [<80b07e58>] (dump_backtrace) from [<80b080ac>] (show_stack+0x20/0x24)
[    2.866633]  r7:00000009 r6:0000011f r5:60000153 r4:80ddd1c0
[    2.866922] [<80b0808c>] (show_stack) from [<80b18df0>] (dump_stack_lvl+0x58/0x74)
[    2.867117] [<80b18d98>] (dump_stack_lvl) from [<80b18e20>] (dump_stack+0x14/0x1c)
[    2.867309]  r5:80118cac r4:80dc6774
[    2.867404] [<80b18e0c>] (dump_stack) from [<80122fcc>] (__warn+0xe4/0x150)
[    2.867583] [<80122ee8>] (__warn) from [<80b08850>] (warn_slowpath_fmt+0x88/0xc0)
[    2.867774]  r7:0000011f r6:80dc6774 r5:00000000 r4:814c4000
[    2.867917] [<80b087cc>] (warn_slowpath_fmt) from [<80118cac>] (__arm_ioremap_pfn_caller+0xf0/0x1dc)
[    2.868158]  r9:00000001 r8:9ef00000 r7:80e8b0d4 r6:0009ef00 r5:00000000 r4:00100000
[    2.868346] [<80118bbc>] (__arm_ioremap_pfn_caller) from [<80118df8>] (__arm_ioremap_caller+0x60/0x68)
[    2.868581]  r9:9ef00000 r8:821b6dc0 r7:00100000 r6:00000000 r5:815d1010 r4:80118d98
[    2.868761] [<80118d98>] (__arm_ioremap_caller) from [<80118fcc>] (ioremap+0x28/0x30)
[    2.868958] [<80118fa4>] (ioremap) from [<8062871c>] (__devm_ioremap_resource+0x154/0x1c8)
[    2.869169]  r5:815d1010 r4:814c5d2c
[    2.869263] [<806285c8>] (__devm_ioremap_resource) from [<8062899c>] (devm_ioremap_resource+0x14/0x18)
[    2.869495]  r9:9e9f57a0 r8:814c4000 r7:815d1000 r6:815d1010 r5:8177c078 r4:815cf400
[    2.869676] [<80628988>] (devm_ioremap_resource) from [<8091c6e4>] (fsi_master_acf_probe+0x1a8/0x5d8)
[    2.869909] [<8091c53c>] (fsi_master_acf_probe) from [<80723dbc>] (platform_probe+0x68/0xc8)
[    2.870124]  r9:80e9dadc r8:00000000 r7:815d1010 r6:810c1000 r5:815d1010 r4:00000000
[    2.870306] [<80723d54>] (platform_probe) from [<80721208>] (really_probe+0x1cc/0x470)
[    2.870512]  r7:815d1010 r6:810c1000 r5:00000000 r4:815d1010
[    2.870651] [<8072103c>] (really_probe) from [<807215cc>] (__driver_probe_device+0x120/0x1fc)
[    2.870872]  r7:815d1010 r6:810c1000 r5:810c1000 r4:815d1010
[    2.871013] [<807214ac>] (__driver_probe_device) from [<807216e8>] (driver_probe_device+0x40/0xd8)
[    2.871244]  r9:80e9dadc r8:00000000 r7:815d1010 r6:810c1000 r5:812feaa0 r4:812fe994
[    2.871428] [<807216a8>] (driver_probe_device) from [<80721a58>] (__driver_attach+0xa8/0x1d4)
[    2.871647]  r9:80e9dadc r8:00000000 r7:00000000 r6:810c1000 r5:815d1054 r4:815d1010
[    2.871830] [<807219b0>] (__driver_attach) from [<8071ee8c>] (bus_for_each_dev+0x88/0xc8)
[    2.872040]  r7:00000000 r6:814c4000 r5:807219b0 r4:810c1000
[    2.872194] [<8071ee04>] (bus_for_each_dev) from [<80722208>] (driver_attach+0x28/0x30)
[    2.872418]  r7:810a2aa0 r6:00000000 r5:821b6000 r4:810c1000
[    2.872570] [<807221e0>] (driver_attach) from [<8071f80c>] (bus_add_driver+0x114/0x200)
[    2.872788] [<8071f6f8>] (bus_add_driver) from [<80722ec4>] (driver_register+0x98/0x128)
[    2.873011]  r7:81011d0c r6:814c4000 r5:00000000 r4:810c1000
[    2.873167] [<80722e2c>] (driver_register) from [<80725240>] (__platform_driver_register+0x2c/0x34)
[    2.873408]  r5:814dcb80 r4:80f2a764
[    2.873513] [<80725214>] (__platform_driver_register) from [<80f2a784>] (fsi_master_acf_init+0x20/0x28)
[    2.873766] [<80f2a764>] (fsi_master_acf_init) from [<80f014a8>] (do_one_initcall+0x108/0x290)
[    2.874007] [<80f013a0>] (do_one_initcall) from [<80f01840>] (kernel_init_freeable+0x1ac/0x230)
[    2.874248]  r9:80e9dadc r8:80f3987c r7:80f3985c r6:00000007 r5:814dcb80 r4:80f627a4
[    2.874456] [<80f01694>] (kernel_init_freeable) from [<80b19f44>] (kernel_init+0x20/0x138)
[    2.874691]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:80b19f24
[    2.874894]  r4:00000000
[    2.874977] [<80b19f24>] (kernel_init) from [<80100170>] (ret_from_fork+0x14/0x24)
[    2.875231] Exception stack(0x814c5fb0 to 0x814c5ff8)
[    2.875535] 5fa0:                                     00000000 00000000 00000000 00000000
[    2.875849] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.876133] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    2.876363]  r5:80b19f24 r4:00000000
[    2.876683] ---[ end trace b2f74b8536829970 ]---
[    2.876911] fsi-master-acf gpio-fsi: ioremap failed for resource [mem 0x9ef00000-0x9effffff]
[    2.877492] fsi-master-acf gpio-fsi: Error -12 mapping coldfire memory
[    2.877689] fsi-master-acf: probe of gpio-fsi failed with error -12

Use memblock_is_map_memory() instead of pfn_valid() to check if a PFN is in
RAM or not.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: a4d5613c4dc6 ("arm: extend pfn_valid to take into account freed memory map alignment")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/lkml/20210630071211.21011-1-rppt@kernel.org/
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/ioremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -27,6 +27,7 @@
 #include <linux/vmalloc.h>
 #include <linux/io.h>
 #include <linux/sizes.h>
+#include <linux/memblock.h>
 
 #include <asm/cp15.h>
 #include <asm/cputype.h>
@@ -301,7 +302,8 @@ static void __iomem * __arm_ioremap_pfn_
 	 * Don't allow RAM to be mapped with mismatched attributes - this
 	 * causes problems with ARMv6+
 	 */
-	if (WARN_ON(pfn_valid(pfn) && mtype != MT_MEMORY_RW))
+	if (WARN_ON(memblock_is_map_memory(PFN_PHYS(pfn)) &&
+		    mtype != MT_MEMORY_RW))
 		return NULL;
 
 	area = get_vm_area_caller(size, VM_IOREMAP, caller);


