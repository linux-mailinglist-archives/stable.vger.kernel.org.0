Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087816D78C9
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbjDEJsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237772AbjDEJr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:47:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FE05FD8;
        Wed,  5 Apr 2023 02:47:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A604862320;
        Wed,  5 Apr 2023 09:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AC0C433D2;
        Wed,  5 Apr 2023 09:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680688032;
        bh=L7XSxAHu9LAevCzCGN+G7DtIK8npbkxgo7Dj2gez9AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyKUodDJXlZCkbkQrtaI8XQ2aoGmfsckEziE9XgembQib4veCh4BJA81PZbCeFYk0
         jE5geCCRoqk4lPCU0hEBWITlIiizpZuTAgZGBf9dcswOtoggwJD+9lNzL4x9YzuP2f
         kuMXL7Qddixu0/iQum6zlTOhWkPj35Pq7PO/AV+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.240
Date:   Wed,  5 Apr 2023 11:47:03 +0200
Message-Id: <2023040502-echo-rocky-9f66@gregkh>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <2023040502-untimely-condition-cbad@gregkh>
References: <2023040502-untimely-condition-cbad@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index f966eeb6b9bc..ff3e24e55f56 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 239
+SUBLEVEL = 240
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/arch/arc/mm/dma.c b/arch/arc/mm/dma.c
index 73a7e88a1e92..e947572a521e 100644
--- a/arch/arc/mm/dma.c
+++ b/arch/arc/mm/dma.c
@@ -48,8 +48,8 @@ void arch_dma_prep_coherent(struct page *page, size_t size)
  * upper layer functions (in include/linux/dma-mapping.h)
  */
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_TO_DEVICE:
@@ -69,8 +69,8 @@ void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
 	}
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_TO_DEVICE:
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 27576c7b836e..fbfb9250e743 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -2332,15 +2332,15 @@ void arch_teardown_dma_ops(struct device *dev)
 }
 
 #ifdef CONFIG_SWIOTLB
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	__dma_page_cpu_to_dev(phys_to_page(paddr), paddr & (PAGE_SIZE - 1),
 			      size, dir);
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	__dma_page_dev_to_cpu(phys_to_page(paddr), paddr & (PAGE_SIZE - 1),
 			      size, dir);
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index 38fa917c8585..a6a2514e5fe8 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -70,20 +70,20 @@ static void dma_cache_maint(dma_addr_t handle, size_t size, u32 op)
  * pfn_valid returns true the pages is local and we can use the native
  * dma-direct functions, otherwise we call the Xen specific version.
  */
-void xen_dma_sync_for_cpu(struct device *dev, dma_addr_t handle,
-		phys_addr_t paddr, size_t size, enum dma_data_direction dir)
+void xen_dma_sync_for_cpu(dma_addr_t handle, phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	if (pfn_valid(PFN_DOWN(handle)))
-		arch_sync_dma_for_cpu(dev, paddr, size, dir);
+		arch_sync_dma_for_cpu(paddr, size, dir);
 	else if (dir != DMA_TO_DEVICE)
 		dma_cache_maint(handle, size, GNTTAB_CACHE_INVAL);
 }
 
-void xen_dma_sync_for_device(struct device *dev, dma_addr_t handle,
-		phys_addr_t paddr, size_t size, enum dma_data_direction dir)
+void xen_dma_sync_for_device(dma_addr_t handle, phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	if (pfn_valid(PFN_DOWN(handle)))
-		arch_sync_dma_for_device(dev, paddr, size, dir);
+		arch_sync_dma_for_device(paddr, size, dir);
 	else if (dir == DMA_FROM_DEVICE)
 		dma_cache_maint(handle, size, GNTTAB_CACHE_INVAL);
 	else
diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index 9239416e93d4..6c45350e33aa 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -13,14 +13,14 @@
 
 #include <asm/cacheflush.h>
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	__dma_map_area(phys_to_virt(paddr), size, dir);
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	__dma_unmap_area(phys_to_virt(paddr), size, dir);
 }
diff --git a/arch/c6x/mm/dma-coherent.c b/arch/c6x/mm/dma-coherent.c
index b319808e8f6b..a5909091cb14 100644
--- a/arch/c6x/mm/dma-coherent.c
+++ b/arch/c6x/mm/dma-coherent.c
@@ -140,7 +140,7 @@ void __init coherent_mem_init(phys_addr_t start, u32 size)
 		      sizeof(long));
 }
 
-static void c6x_dma_sync(struct device *dev, phys_addr_t paddr, size_t size,
+static void c6x_dma_sync(phys_addr_t paddr, size_t size,
 		enum dma_data_direction dir)
 {
 	BUG_ON(!valid_dma_direction(dir));
@@ -160,14 +160,14 @@ static void c6x_dma_sync(struct device *dev, phys_addr_t paddr, size_t size,
 	}
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
-	return c6x_dma_sync(dev, paddr, size, dir);
+	return c6x_dma_sync(paddr, size, dir);
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
-	return c6x_dma_sync(dev, paddr, size, dir);
+	return c6x_dma_sync(paddr, size, dir);
 }
diff --git a/arch/csky/mm/dma-mapping.c b/arch/csky/mm/dma-mapping.c
index 06e85b565454..8f6571ae27c8 100644
--- a/arch/csky/mm/dma-mapping.c
+++ b/arch/csky/mm/dma-mapping.c
@@ -58,8 +58,8 @@ void arch_dma_prep_coherent(struct page *page, size_t size)
 	cache_op(page_to_phys(page), size, dma_wbinv_set_zero_range);
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-			      size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_TO_DEVICE:
@@ -74,8 +74,8 @@ void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
 	}
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-			   size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_TO_DEVICE:
diff --git a/arch/hexagon/kernel/dma.c b/arch/hexagon/kernel/dma.c
index f561b127c4b4..25f388d9cfcc 100644
--- a/arch/hexagon/kernel/dma.c
+++ b/arch/hexagon/kernel/dma.c
@@ -55,8 +55,8 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 	gen_pool_free(coherent_pool, (unsigned long) vaddr, size);
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	void *addr = phys_to_virt(paddr);
 
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index ee50506d86f4..df6d3dfa9d82 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -73,8 +73,8 @@ __ia64_sync_icache_dcache (pte_t pte)
  * DMA can be marked as "clean" so that lazy_mmu_prot_update() doesn't have to
  * flush them when they get mapped into an executable vm-area.
  */
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	unsigned long pfn = PHYS_PFN(paddr);
 
diff --git a/arch/m68k/kernel/dma.c b/arch/m68k/kernel/dma.c
index 3fab684cc0db..871a0e11da34 100644
--- a/arch/m68k/kernel/dma.c
+++ b/arch/m68k/kernel/dma.c
@@ -61,8 +61,8 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 
 #endif /* CONFIG_MMU && !CONFIG_COLDFIRE */
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t handle,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t handle, size_t size,
+		enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_BIDIRECTIONAL:
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index a245c1933d41..5bf314871e9f 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/ptrace.h>
 #include <linux/kallsyms.h>
+#include <linux/extable.h>
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
@@ -550,7 +551,8 @@ static inline void bus_error030 (struct frame *fp)
 			errorcode |= 2;
 
 		if (mmusr & (MMU_I | MMU_WP)) {
-			if (ssw & 4) {
+			/* We might have an exception table for this PC */
+			if (ssw & 4 && !search_exception_tables(fp->ptregs.pc)) {
 				pr_err("Data %s fault at %#010lx in %s (pc=%#lx)\n",
 				       ssw & RW ? "read" : "write",
 				       fp->un.fmtb.daddr,
diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index a89c2d4ed5ff..d7bebd04247b 100644
--- a/arch/microblaze/kernel/dma.c
+++ b/arch/microblaze/kernel/dma.c
@@ -15,7 +15,7 @@
 #include <linux/bug.h>
 #include <asm/cacheflush.h>
 
-static void __dma_sync(struct device *dev, phys_addr_t paddr, size_t size,
+static void __dma_sync(phys_addr_t paddr, size_t size,
 		enum dma_data_direction direction)
 {
 	switch (direction) {
@@ -31,14 +31,14 @@ static void __dma_sync(struct device *dev, phys_addr_t paddr, size_t size,
 	}
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
-	__dma_sync(dev, paddr, size, dir);
+	__dma_sync(paddr, size, dir);
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
-	__dma_sync(dev, paddr, size, dir);
+	__dma_sync(paddr, size, dir);
 }
diff --git a/arch/mips/bmips/dma.c b/arch/mips/bmips/dma.c
index 3d13c77c125f..98d39585c80f 100644
--- a/arch/mips/bmips/dma.c
+++ b/arch/mips/bmips/dma.c
@@ -64,7 +64,9 @@ phys_addr_t __dma_to_phys(struct device *dev, dma_addr_t dma_addr)
 	return dma_addr;
 }
 
-void arch_sync_dma_for_cpu_all(struct device *dev)
+bool bmips_rac_flush_disable;
+
+void arch_sync_dma_for_cpu_all(void)
 {
 	void __iomem *cbr = BMIPS_GET_CBR();
 	u32 cfg;
@@ -74,6 +76,9 @@ void arch_sync_dma_for_cpu_all(struct device *dev)
 	    boot_cpu_type() != CPU_BMIPS4380)
 		return;
 
+	if (unlikely(bmips_rac_flush_disable))
+		return;
+
 	/* Flush stale data out of the readahead cache */
 	cfg = __raw_readl(cbr + BMIPS_RAC_CONFIG);
 	__raw_writel(cfg | 0x100, cbr + BMIPS_RAC_CONFIG);
diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
index 7aee9ff19c1a..36fbedcbd518 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -34,6 +34,8 @@
 #define REG_BCM6328_OTP		((void __iomem *)CKSEG1ADDR(0x1000062c))
 #define BCM6328_TP1_DISABLED	BIT(9)
 
+extern bool bmips_rac_flush_disable;
+
 static const unsigned long kbase = VMLINUX_LOAD_ADDRESS & 0xfff00000;
 
 struct bmips_quirk {
@@ -103,6 +105,12 @@ static void bcm6358_quirks(void)
 	 * disable SMP for now
 	 */
 	bmips_smp_enabled = 0;
+
+	/*
+	 * RAC flush causes kernel panics on BCM6358 when booting from TP1
+	 * because the bootloader is not initializing it properly.
+	 */
+	bmips_rac_flush_disable = !!(read_c0_brcm_cmt_local() & (1 << 31));
 }
 
 static void bcm6368_quirks(void)
diff --git a/arch/mips/jazz/jazzdma.c b/arch/mips/jazz/jazzdma.c
index a01e14955187..c64a297e82b3 100644
--- a/arch/mips/jazz/jazzdma.c
+++ b/arch/mips/jazz/jazzdma.c
@@ -592,7 +592,7 @@ static dma_addr_t jazz_dma_map_page(struct device *dev, struct page *page,
 	phys_addr_t phys = page_to_phys(page) + offset;
 
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-		arch_sync_dma_for_device(dev, phys, size, dir);
+		arch_sync_dma_for_device(phys, size, dir);
 	return vdma_alloc(phys, size);
 }
 
@@ -600,7 +600,7 @@ static void jazz_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-		arch_sync_dma_for_cpu(dev, vdma_log2phys(dma_addr), size, dir);
+		arch_sync_dma_for_cpu(vdma_log2phys(dma_addr), size, dir);
 	vdma_free(dma_addr);
 }
 
@@ -612,7 +612,7 @@ static int jazz_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 
 	for_each_sg(sglist, sg, nents, i) {
 		if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-			arch_sync_dma_for_device(dev, sg_phys(sg), sg->length,
+			arch_sync_dma_for_device(sg_phys(sg), sg->length,
 				dir);
 		sg->dma_address = vdma_alloc(sg_phys(sg), sg->length);
 		if (sg->dma_address == DMA_MAPPING_ERROR)
@@ -631,8 +631,7 @@ static void jazz_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 
 	for_each_sg(sglist, sg, nents, i) {
 		if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-			arch_sync_dma_for_cpu(dev, sg_phys(sg), sg->length,
-				dir);
+			arch_sync_dma_for_cpu(sg_phys(sg), sg->length, dir);
 		vdma_free(sg->dma_address);
 	}
 }
@@ -640,13 +639,13 @@ static void jazz_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 static void jazz_dma_sync_single_for_device(struct device *dev,
 		dma_addr_t addr, size_t size, enum dma_data_direction dir)
 {
-	arch_sync_dma_for_device(dev, vdma_log2phys(addr), size, dir);
+	arch_sync_dma_for_device(vdma_log2phys(addr), size, dir);
 }
 
 static void jazz_dma_sync_single_for_cpu(struct device *dev,
 		dma_addr_t addr, size_t size, enum dma_data_direction dir)
 {
-	arch_sync_dma_for_cpu(dev, vdma_log2phys(addr), size, dir);
+	arch_sync_dma_for_cpu(vdma_log2phys(addr), size, dir);
 }
 
 static void jazz_dma_sync_sg_for_device(struct device *dev,
@@ -656,7 +655,7 @@ static void jazz_dma_sync_sg_for_device(struct device *dev,
 	int i;
 
 	for_each_sg(sgl, sg, nents, i)
-		arch_sync_dma_for_device(dev, sg_phys(sg), sg->length, dir);
+		arch_sync_dma_for_device(sg_phys(sg), sg->length, dir);
 }
 
 static void jazz_dma_sync_sg_for_cpu(struct device *dev,
@@ -666,7 +665,7 @@ static void jazz_dma_sync_sg_for_cpu(struct device *dev,
 	int i;
 
 	for_each_sg(sgl, sg, nents, i)
-		arch_sync_dma_for_cpu(dev, sg_phys(sg), sg->length, dir);
+		arch_sync_dma_for_cpu(sg_phys(sg), sg->length, dir);
 }
 
 const struct dma_map_ops jazz_dma_ops = {
diff --git a/arch/mips/mm/dma-noncoherent.c b/arch/mips/mm/dma-noncoherent.c
index 1d4d57dd9acf..6cfacb04865f 100644
--- a/arch/mips/mm/dma-noncoherent.c
+++ b/arch/mips/mm/dma-noncoherent.c
@@ -27,7 +27,7 @@
  * R10000 and R12000 are used in such systems, the SGI IP28 Indigo² rsp.
  * SGI IP32 aka O2.
  */
-static inline bool cpu_needs_post_dma_flush(struct device *dev)
+static inline bool cpu_needs_post_dma_flush(void)
 {
 	switch (boot_cpu_type()) {
 	case CPU_R10000:
@@ -118,17 +118,17 @@ static inline void dma_sync_phys(phys_addr_t paddr, size_t size,
 	} while (left);
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	dma_sync_phys(paddr, size, dir);
 }
 
 #ifdef CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
-	if (cpu_needs_post_dma_flush(dev))
+	if (cpu_needs_post_dma_flush())
 		dma_sync_phys(paddr, size, dir);
 }
 #endif
diff --git a/arch/nds32/kernel/dma.c b/arch/nds32/kernel/dma.c
index 4206d4b6c8ce..69d762182d49 100644
--- a/arch/nds32/kernel/dma.c
+++ b/arch/nds32/kernel/dma.c
@@ -46,8 +46,8 @@ static inline void cache_op(phys_addr_t paddr, size_t size,
 	} while (left);
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_FROM_DEVICE:
@@ -61,8 +61,8 @@ void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
 	}
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_TO_DEVICE:
diff --git a/arch/nios2/mm/dma-mapping.c b/arch/nios2/mm/dma-mapping.c
index 9cb238664584..0ed711e37902 100644
--- a/arch/nios2/mm/dma-mapping.c
+++ b/arch/nios2/mm/dma-mapping.c
@@ -18,8 +18,8 @@
 #include <linux/cache.h>
 #include <asm/cacheflush.h>
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	void *vaddr = phys_to_virt(paddr);
 
@@ -42,8 +42,8 @@ void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
 	}
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	void *vaddr = phys_to_virt(paddr);
 
diff --git a/arch/openrisc/kernel/dma.c b/arch/openrisc/kernel/dma.c
index 4d5b8bd1d795..adec711ad39d 100644
--- a/arch/openrisc/kernel/dma.c
+++ b/arch/openrisc/kernel/dma.c
@@ -125,7 +125,7 @@ arch_dma_free(struct device *dev, size_t size, void *vaddr,
 	free_pages_exact(vaddr, size);
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t addr, size_t size,
+void arch_sync_dma_for_device(phys_addr_t addr, size_t size,
 		enum dma_data_direction dir)
 {
 	unsigned long cl;
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index ca35d9a76e50..a60d47fd4d55 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -439,14 +439,14 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)__va(dma_handle), order);
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	flush_kernel_dcache_range((unsigned long)phys_to_virt(paddr), size);
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	flush_kernel_dcache_range((unsigned long)phys_to_virt(paddr), size);
 }
diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoherent.c
index 2a82984356f8..5ab4f868e919 100644
--- a/arch/powerpc/mm/dma-noncoherent.c
+++ b/arch/powerpc/mm/dma-noncoherent.c
@@ -104,14 +104,14 @@ static void __dma_sync_page(phys_addr_t paddr, size_t size, int dir)
 #endif
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	__dma_sync_page(paddr, size, dir);
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	__dma_sync_page(paddr, size, dir);
 }
diff --git a/arch/riscv/include/uapi/asm/setup.h b/arch/riscv/include/uapi/asm/setup.h
new file mode 100644
index 000000000000..66b13a522880
--- /dev/null
+++ b/arch/riscv/include/uapi/asm/setup.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+
+#ifndef _UAPI_ASM_RISCV_SETUP_H
+#define _UAPI_ASM_RISCV_SETUP_H
+
+#define COMMAND_LINE_SIZE	1024
+
+#endif /* _UAPI_ASM_RISCV_SETUP_H */
diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index 0267405ab7c6..fcfd78f99cb4 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -339,7 +339,7 @@ static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size
 		"4: slgr  %0,%0\n"
 		"5:\n"
 		EX_TABLE(0b,2b) EX_TABLE(3b,5b)
-		: "+a" (size), "+a" (to), "+a" (tmp1), "=a" (tmp2)
+		: "+&a" (size), "+&a" (to), "+a" (tmp1), "=&a" (tmp2)
 		: "a" (empty_zero_page), "d" (reg0) : "cc", "memory");
 	return size;
 }
diff --git a/arch/sh/include/asm/processor_32.h b/arch/sh/include/asm/processor_32.h
index 0e0ecc0132e3..58ae979798fa 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -51,6 +51,7 @@
 #define SR_FD		0x00008000
 #define SR_MD		0x40000000
 
+#define SR_USER_MASK	0x00000303	// M, Q, S, T bits
 /*
  * DSP structure and data
  */
diff --git a/arch/sh/kernel/dma-coherent.c b/arch/sh/kernel/dma-coherent.c
index b17514619b7e..eeb25a4fa55f 100644
--- a/arch/sh/kernel/dma-coherent.c
+++ b/arch/sh/kernel/dma-coherent.c
@@ -25,7 +25,7 @@ void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	 * Pages from the page allocator may have data present in
 	 * cache. So flush the cache before using uncached memory.
 	 */
-	arch_sync_dma_for_device(dev, virt_to_phys(ret), size,
+	arch_sync_dma_for_device(virt_to_phys(ret), size,
 			DMA_BIDIRECTIONAL);
 
 	ret_nocache = (void __force *)ioremap_nocache(virt_to_phys(ret), size);
@@ -59,8 +59,8 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 	iounmap(vaddr);
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	void *addr = sh_cacheop_vaddr(phys_to_virt(paddr));
 
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 24473fa6c3b6..f6e1a47ad7ca 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -116,6 +116,7 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p)
 {
 	unsigned int err = 0;
+	unsigned int sr = regs->sr & ~SR_USER_MASK;
 
 #define COPY(x)		err |= __get_user(regs->x, &sc->sc_##x)
 			COPY(regs[1]);
@@ -131,6 +132,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p
 	COPY(sr);	COPY(pc);
 #undef COPY
 
+	regs->sr = (regs->sr & SR_USER_MASK) | sr;
+
 #ifdef CONFIG_SH_FPU
 	if (boot_cpu_data.flags & CPU_HAS_FPU) {
 		int owned_fp;
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index b87e0002131d..9d723c58557b 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -368,8 +368,8 @@ void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
 
 /* IIep is write-through, not flushing on cpu to device transfer. */
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	if (dir != PCI_DMA_TODEVICE)
 		dma_make_coherent(paddr, PAGE_ALIGN(size));
diff --git a/arch/xtensa/kernel/pci-dma.c b/arch/xtensa/kernel/pci-dma.c
index 154979d62b73..2b86a2a04236 100644
--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -44,8 +44,8 @@ static void do_cache_op(phys_addr_t paddr, size_t size,
 		}
 }
 
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_BIDIRECTIONAL:
@@ -62,8 +62,8 @@ void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
 	}
 }
 
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir)
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 	switch (dir) {
 	case DMA_BIDIRECTIONAL:
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index a95a9448984f..c60611196786 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2914,6 +2914,7 @@ close_card_oam(struct idt77252_dev *card)
 
 				recycle_rx_pool_skb(card, &vc->rcv.rx_pool);
 			}
+			kfree(vc);
 		}
 	}
 }
@@ -2957,6 +2958,15 @@ open_card_ubr0(struct idt77252_dev *card)
 	return 0;
 }
 
+static void
+close_card_ubr0(struct idt77252_dev *card)
+{
+	struct vc_map *vc = card->vcs[0];
+
+	free_scq(card, vc->scq);
+	kfree(vc);
+}
+
 static int
 idt77252_dev_open(struct idt77252_dev *card)
 {
@@ -3006,6 +3016,7 @@ static void idt77252_dev_close(struct atm_dev *dev)
 	struct idt77252_dev *card = dev->dev_data;
 	u32 conf;
 
+	close_card_ubr0(card);
 	close_card_oam(card);
 
 	conf = SAR_CFG_RXPTH |	/* enable receive path           */
diff --git a/drivers/bluetooth/btqcomsmd.c b/drivers/bluetooth/btqcomsmd.c
index 2acb719e596f..11c7e04bf394 100644
--- a/drivers/bluetooth/btqcomsmd.c
+++ b/drivers/bluetooth/btqcomsmd.c
@@ -122,6 +122,21 @@ static int btqcomsmd_setup(struct hci_dev *hdev)
 	return 0;
 }
 
+static int btqcomsmd_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr)
+{
+	int ret;
+
+	ret = qca_set_bdaddr_rome(hdev, bdaddr);
+	if (ret)
+		return ret;
+
+	/* The firmware stops responding for a while after setting the bdaddr,
+	 * causing timeouts for subsequent commands. Sleep a bit to avoid this.
+	 */
+	usleep_range(1000, 10000);
+	return 0;
+}
+
 static int btqcomsmd_probe(struct platform_device *pdev)
 {
 	struct btqcomsmd *btq;
@@ -162,7 +177,7 @@ static int btqcomsmd_probe(struct platform_device *pdev)
 	hdev->close = btqcomsmd_close;
 	hdev->send = btqcomsmd_send;
 	hdev->setup = btqcomsmd_setup;
-	hdev->set_bdaddr = qca_set_bdaddr_rome;
+	hdev->set_bdaddr = btqcomsmd_set_bdaddr;
 
 	ret = hci_register_dev(hdev);
 	if (ret < 0)
diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
index fd9571d5fdac..81125fb18035 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -343,6 +343,7 @@ static void btsdio_remove(struct sdio_func *func)
 
 	BT_DBG("func %p", func);
 
+	cancel_work_sync(&data->work);
 	if (!data)
 		return;
 
diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index 28bb65a5613f..201767823edb 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -192,8 +192,8 @@ static int weim_parse_dt(struct platform_device *pdev, void __iomem *base)
 	const struct of_device_id *of_id = of_match_device(weim_id_table,
 							   &pdev->dev);
 	const struct imx_weim_devtype *devtype = of_id->data;
+	int ret = 0, have_child = 0;
 	struct device_node *child;
-	int ret, have_child = 0;
 	struct cs_timing_state ts = {};
 	u32 reg;
 
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f0b055bc027c..9dae841b6167 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -737,6 +737,39 @@ static int scmi_mailbox_check(struct device_node *np, int idx)
 					  idx, NULL);
 }
 
+static int scmi_mailbox_chan_validate(struct device *cdev)
+{
+	int num_mb, num_sh, ret = 0;
+	struct device_node *np = cdev->of_node;
+
+	num_mb = of_count_phandle_with_args(np, "mboxes", "#mbox-cells");
+	num_sh = of_count_phandle_with_args(np, "shmem", NULL);
+	/* Bail out if mboxes and shmem descriptors are inconsistent */
+	if (num_mb <= 0 || num_sh > 2 || num_mb != num_sh) {
+		dev_warn(cdev, "Invalid channel descriptor for '%s'\n",
+			 of_node_full_name(np));
+		return -EINVAL;
+	}
+
+	if (num_sh > 1) {
+		struct device_node *np_tx, *np_rx;
+
+		np_tx = of_parse_phandle(np, "shmem", 0);
+		np_rx = of_parse_phandle(np, "shmem", 1);
+		/* SCMI Tx and Rx shared mem areas have to be distinct */
+		if (!np_tx || !np_rx || np_tx == np_rx) {
+			dev_warn(cdev, "Invalid shmem descriptor for '%s'\n",
+				 of_node_full_name(np));
+			ret = -EINVAL;
+		}
+
+		of_node_put(np_tx);
+		of_node_put(np_rx);
+	}
+
+	return ret;
+}
+
 static int scmi_mbox_chan_setup(struct scmi_info *info, struct device *dev,
 				int prot_id, bool tx)
 {
@@ -760,6 +793,10 @@ static int scmi_mbox_chan_setup(struct scmi_info *info, struct device *dev,
 		goto idr_alloc;
 	}
 
+	ret = scmi_mailbox_chan_validate(dev);
+	if (ret)
+		return ret;
+
 	cinfo = devm_kzalloc(info->dev, sizeof(*cinfo), GFP_KERNEL);
 	if (!cinfo)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
index f24dd21c2363..fe7817e4c0d1 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
@@ -93,7 +93,15 @@ static void *etnaviv_gem_prime_vmap_impl(struct etnaviv_gem_object *etnaviv_obj)
 static int etnaviv_gem_prime_mmap_obj(struct etnaviv_gem_object *etnaviv_obj,
 		struct vm_area_struct *vma)
 {
-	return dma_buf_mmap(etnaviv_obj->base.dma_buf, vma, 0);
+	int ret;
+
+	ret = dma_buf_mmap(etnaviv_obj->base.dma_buf, vma, 0);
+	if (!ret) {
+		/* Drop the reference acquired by drm_gem_mmap_obj(). */
+		drm_gem_object_put(&etnaviv_obj->base);
+	}
+
+	return ret;
 }
 
 static const struct etnaviv_gem_ops etnaviv_gem_prime_ops = {
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index fac9b5c68a6a..85413d3dc394 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -486,6 +486,8 @@ static const struct it87_devices it87_devices[] = {
 #define has_pwm_freq2(data)	((data)->features & FEAT_PWM_FREQ2)
 #define has_six_temp(data)	((data)->features & FEAT_SIX_TEMP)
 #define has_vin3_5v(data)	((data)->features & FEAT_VIN3_5V)
+#define has_scaling(data)	((data)->features & (FEAT_12MV_ADC | \
+						     FEAT_10_9MV_ADC))
 
 struct it87_sio_data {
 	int sioaddr;
@@ -3098,7 +3100,7 @@ static int it87_probe(struct platform_device *pdev)
 			 "Detected broken BIOS defaults, disabling PWM interface\n");
 
 	/* Starting with IT8721F, we handle scaling of internal voltages */
-	if (has_12mv_adc(data)) {
+	if (has_scaling(data)) {
 		if (sio_data->internal & BIT(0))
 			data->in_scaled |= BIT(3);	/* in3 is AVCC */
 		if (sio_data->internal & BIT(1))
diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index a0d045c1bc9e..13c17afe7102 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -508,10 +508,14 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 static irqreturn_t lpi2c_imx_isr(int irq, void *dev_id)
 {
 	struct lpi2c_imx_struct *lpi2c_imx = dev_id;
+	unsigned int enabled;
 	unsigned int temp;
 
+	enabled = readl(lpi2c_imx->base + LPI2C_MIER);
+
 	lpi2c_imx_intctrl(lpi2c_imx, 0);
 	temp = readl(lpi2c_imx->base + LPI2C_MSR);
+	temp &= enabled;
 
 	if (temp & MSR_RDF)
 		lpi2c_imx_read_rxfifo(lpi2c_imx);
diff --git a/drivers/i2c/busses/i2c-xgene-slimpro.c b/drivers/i2c/busses/i2c-xgene-slimpro.c
index 63cbb9c7c1b0..76e9dcd63856 100644
--- a/drivers/i2c/busses/i2c-xgene-slimpro.c
+++ b/drivers/i2c/busses/i2c-xgene-slimpro.c
@@ -308,6 +308,9 @@ static int slimpro_i2c_blkwr(struct slimpro_i2c_dev *ctx, u32 chip,
 	u32 msg[3];
 	int rc;
 
+	if (writelen > I2C_SMBUS_BLOCK_MAX)
+		return -EINVAL;
+
 	memcpy(ctx->dma_buffer, data, writelen);
 	paddr = dma_map_single(ctx->dev, ctx->dma_buffer, writelen,
 			       DMA_TO_DEVICE);
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 34700eda0429..3aaebadb2e13 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -852,8 +852,8 @@ static void alps_process_packet_v6(struct psmouse *psmouse)
 			x = y = z = 0;
 
 		/* Divide 4 since trackpoint's speed is too fast */
-		input_report_rel(dev2, REL_X, (char)x / 4);
-		input_report_rel(dev2, REL_Y, -((char)y / 4));
+		input_report_rel(dev2, REL_X, (s8)x / 4);
+		input_report_rel(dev2, REL_Y, -((s8)y / 4));
 
 		psmouse_report_standard_buttons(dev2, packet[3]);
 
@@ -1104,8 +1104,8 @@ static void alps_process_trackstick_packet_v7(struct psmouse *psmouse)
 	    ((packet[3] & 0x20) << 1);
 	z = (packet[5] & 0x3f) | ((packet[3] & 0x80) >> 1);
 
-	input_report_rel(dev2, REL_X, (char)x);
-	input_report_rel(dev2, REL_Y, -((char)y));
+	input_report_rel(dev2, REL_X, (s8)x);
+	input_report_rel(dev2, REL_Y, -((s8)y));
 	input_report_abs(dev2, ABS_PRESSURE, z);
 
 	psmouse_report_standard_buttons(dev2, packet[1]);
@@ -2294,20 +2294,20 @@ static int alps_get_v3_v7_resolution(struct psmouse *psmouse, int reg_pitch)
 	if (reg < 0)
 		return reg;
 
-	x_pitch = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_pitch = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_pitch = 50 + 2 * x_pitch; /* In 0.1 mm units */
 
-	y_pitch = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_pitch = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_pitch = 36 + 2 * y_pitch; /* In 0.1 mm units */
 
 	reg = alps_command_mode_read_reg(psmouse, reg_pitch + 1);
 	if (reg < 0)
 		return reg;
 
-	x_electrode = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_electrode = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_electrode = 17 + x_electrode;
 
-	y_electrode = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_electrode = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_electrode = 13 + y_electrode;
 
 	x_phys = x_pitch * (x_electrode - 1); /* In 0.1 mm units */
diff --git a/drivers/input/mouse/focaltech.c b/drivers/input/mouse/focaltech.c
index 6fd5fff0cbff..c74b99077d16 100644
--- a/drivers/input/mouse/focaltech.c
+++ b/drivers/input/mouse/focaltech.c
@@ -202,8 +202,8 @@ static void focaltech_process_rel_packet(struct psmouse *psmouse,
 	state->pressed = packet[0] >> 7;
 	finger1 = ((packet[0] >> 4) & 0x7) - 1;
 	if (finger1 < FOC_MAX_FINGERS) {
-		state->fingers[finger1].x += (char)packet[1];
-		state->fingers[finger1].y += (char)packet[2];
+		state->fingers[finger1].x += (s8)packet[1];
+		state->fingers[finger1].y += (s8)packet[2];
 	} else {
 		psmouse_err(psmouse, "First finger in rel packet invalid: %d\n",
 			    finger1);
@@ -218,8 +218,8 @@ static void focaltech_process_rel_packet(struct psmouse *psmouse,
 	 */
 	finger2 = ((packet[3] >> 4) & 0x7) - 1;
 	if (finger2 < FOC_MAX_FINGERS) {
-		state->fingers[finger2].x += (char)packet[4];
-		state->fingers[finger2].y += (char)packet[5];
+		state->fingers[finger2].x += (s8)packet[4];
+		state->fingers[finger2].y += (s8)packet[5];
 	}
 }
 
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 3c9cdb87770f..f60466c27099 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -170,10 +170,18 @@ static const struct dmi_system_id rotated_screen[] = {
 static const struct dmi_system_id nine_bytes_report[] = {
 #if defined(CONFIG_DMI) && defined(CONFIG_X86)
 	{
-		.ident = "Lenovo YogaBook",
-		/* YB1-X91L/F and YB1-X90L/F */
+		/* Lenovo Yoga Book X90F / X90L */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9")
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+		}
+	},
+	{
+		/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+			/* Non exact match to match F + L versions */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
 		}
 	},
 #endif
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 4fc8fb92d45e..651054aa8710 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -660,7 +660,7 @@ static void iommu_dma_sync_single_for_cpu(struct device *dev,
 		return;
 
 	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
-	arch_sync_dma_for_cpu(dev, phys, size, dir);
+	arch_sync_dma_for_cpu(phys, size, dir);
 }
 
 static void iommu_dma_sync_single_for_device(struct device *dev,
@@ -672,7 +672,7 @@ static void iommu_dma_sync_single_for_device(struct device *dev,
 		return;
 
 	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
-	arch_sync_dma_for_device(dev, phys, size, dir);
+	arch_sync_dma_for_device(phys, size, dir);
 }
 
 static void iommu_dma_sync_sg_for_cpu(struct device *dev,
@@ -686,7 +686,7 @@ static void iommu_dma_sync_sg_for_cpu(struct device *dev,
 		return;
 
 	for_each_sg(sgl, sg, nelems, i)
-		arch_sync_dma_for_cpu(dev, sg_phys(sg), sg->length, dir);
+		arch_sync_dma_for_cpu(sg_phys(sg), sg->length, dir);
 }
 
 static void iommu_dma_sync_sg_for_device(struct device *dev,
@@ -700,7 +700,7 @@ static void iommu_dma_sync_sg_for_device(struct device *dev,
 		return;
 
 	for_each_sg(sgl, sg, nelems, i)
-		arch_sync_dma_for_device(dev, sg_phys(sg), sg->length, dir);
+		arch_sync_dma_for_device(sg_phys(sg), sg->length, dir);
 }
 
 static dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
@@ -715,7 +715,7 @@ static dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
 	dma_handle =__iommu_dma_map(dev, phys, size, prot);
 	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
 	    dma_handle != DMA_MAPPING_ERROR)
-		arch_sync_dma_for_device(dev, phys, size, dir);
+		arch_sync_dma_for_device(phys, size, dir);
 	return dma_handle;
 }
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index fa674e9b6f23..4301f22bbfa6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1554,6 +1554,7 @@ static int dmcrypt_write(void *data)
 			io = crypt_io_from_node(rb_first(&write_tree));
 			rb_erase(&io->rb_node, &write_tree);
 			kcryptd_io_write(io);
+			cond_resched();
 		} while (!RB_EMPTY_ROOT(&write_tree));
 		blk_finish_plug(&plug);
 	}
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index ce6d3bce1b7b..0f42f4a7f382 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -188,7 +188,7 @@ static int dm_stat_in_flight(struct dm_stat_shared *shared)
 	       atomic_read(&shared->in_flight[WRITE]);
 }
 
-void dm_stats_init(struct dm_stats *stats)
+int dm_stats_init(struct dm_stats *stats)
 {
 	int cpu;
 	struct dm_stats_last_position *last;
@@ -196,11 +196,16 @@ void dm_stats_init(struct dm_stats *stats)
 	mutex_init(&stats->mutex);
 	INIT_LIST_HEAD(&stats->list);
 	stats->last = alloc_percpu(struct dm_stats_last_position);
+	if (!stats->last)
+		return -ENOMEM;
+
 	for_each_possible_cpu(cpu) {
 		last = per_cpu_ptr(stats->last, cpu);
 		last->last_sector = (sector_t)ULLONG_MAX;
 		last->last_rw = UINT_MAX;
 	}
+
+	return 0;
 }
 
 void dm_stats_cleanup(struct dm_stats *stats)
diff --git a/drivers/md/dm-stats.h b/drivers/md/dm-stats.h
index 2ddfae678f32..dcac11fce03b 100644
--- a/drivers/md/dm-stats.h
+++ b/drivers/md/dm-stats.h
@@ -22,7 +22,7 @@ struct dm_stats_aux {
 	unsigned long long duration_ns;
 };
 
-void dm_stats_init(struct dm_stats *st);
+int dm_stats_init(struct dm_stats *st);
 void dm_stats_cleanup(struct dm_stats *st);
 
 struct mapped_device;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 999447bde820..a1abdb3467a9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3407,6 +3407,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	pt->adjusted_pf = pt->requested_pf = pf;
 	bio_init(&pt->flush_bio, NULL, 0);
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4292,6 +4293,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 	ti->flush_supported = true;
 	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b58ff1a0fda7..771167ee552c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1994,7 +1994,9 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->bdev)
 		goto bad;
 
-	dm_stats_init(&md->stats);
+	r = dm_stats_init(&md->stats);
+	if (r < 0)
+		goto bad;
 
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index aa2993d5d5d3..64558991ce0a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3082,6 +3082,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = kstrtouint(buf, 10, (unsigned int *)&slot);
 		if (err < 0)
 			return err;
+		if (slot < 0)
+			/* overflow */
+			return -ENOSPC;
 	}
 	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index a65aadb54af6..240b493abb86 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -172,6 +172,7 @@ struct meson_nfc {
 
 	dma_addr_t daddr;
 	dma_addr_t iaddr;
+	u32 info_bytes;
 
 	unsigned long assigned_cs;
 };
@@ -499,6 +500,7 @@ static int meson_nfc_dma_buffer_setup(struct nand_chip *nand, void *databuf,
 					 nfc->daddr, datalen, dir);
 			return ret;
 		}
+		nfc->info_bytes = infolen;
 		cmd = GENCMDIADDRL(NFC_CMD_AIL, nfc->iaddr);
 		writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
@@ -516,8 +518,10 @@ static void meson_nfc_dma_buffer_release(struct nand_chip *nand,
 	struct meson_nfc *nfc = nand_get_controller_data(nand);
 
 	dma_unmap_single(nfc->dev, nfc->daddr, datalen, dir);
-	if (infolen)
+	if (infolen) {
 		dma_unmap_single(nfc->dev, nfc->iaddr, infolen, dir);
+		nfc->info_bytes = 0;
+	}
 }
 
 static int meson_nfc_read_buf(struct nand_chip *nand, u8 *buf, int len)
@@ -706,6 +710,8 @@ static void meson_nfc_check_ecc_pages_valid(struct meson_nfc *nfc,
 		usleep_range(10, 15);
 		/* info is updated by nfc dma engine*/
 		smp_rmb();
+		dma_sync_single_for_cpu(nfc->dev, nfc->iaddr, nfc->info_bytes,
+					DMA_FROM_DEVICE);
 		ret = *info & ECC_COMPLETE;
 	} while (!ret);
 }
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b336ed071fa8..ea32be579e7b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2433,9 +2433,14 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * If this is the upstream port for this switch, enable
 	 * forwarding of unknown unicasts and multicasts.
 	 */
-	reg = MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP |
-		MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
+	reg = MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
 		MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
+	/* Forward any IPv4 IGMP or IPv6 MLD frames received
+	 * by a USER port to the CPU port to allow snooping.
+	 */
+	if (dsa_is_user_port(ds, port))
+		reg |= MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP;
+
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 9fb1da36e9eb..2c71e838fa3d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -221,12 +221,12 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x1750), .driver_data = BCM57508 },
 	{ PCI_VDEVICE(BROADCOM, 0x1751), .driver_data = BCM57504 },
 	{ PCI_VDEVICE(BROADCOM, 0x1752), .driver_data = BCM57502 },
-	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57502_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0x1801), .driver_data = BCM57504_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57502_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57502_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0x1804), .driver_data = BCM57504_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57502_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57508_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0xd802), .driver_data = BCM58802 },
 	{ PCI_VDEVICE(BROADCOM, 0xd804), .driver_data = BCM58804 },
 #ifdef CONFIG_BNXT_SRIOV
diff --git a/drivers/net/ethernet/intel/i40e/i40e_diag.c b/drivers/net/ethernet/intel/i40e/i40e_diag.c
index ef4d3762bf37..ca229b0efeb6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_diag.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_diag.c
@@ -44,7 +44,7 @@ static i40e_status i40e_diag_reg_pattern_test(struct i40e_hw *hw,
 	return 0;
 }
 
-struct i40e_diag_reg_test_info i40e_reg_list[] = {
+const struct i40e_diag_reg_test_info i40e_reg_list[] = {
 	/* offset               mask         elements   stride */
 	{I40E_QTX_CTL(0),       0x0000FFBF, 1,
 		I40E_QTX_CTL(1) - I40E_QTX_CTL(0)},
@@ -78,27 +78,28 @@ i40e_status i40e_diag_reg_test(struct i40e_hw *hw)
 {
 	i40e_status ret_code = 0;
 	u32 reg, mask;
+	u32 elements;
 	u32 i, j;
 
 	for (i = 0; i40e_reg_list[i].offset != 0 &&
 					     !ret_code; i++) {
 
+		elements = i40e_reg_list[i].elements;
 		/* set actual reg range for dynamically allocated resources */
 		if (i40e_reg_list[i].offset == I40E_QTX_CTL(0) &&
 		    hw->func_caps.num_tx_qp != 0)
-			i40e_reg_list[i].elements = hw->func_caps.num_tx_qp;
+			elements = hw->func_caps.num_tx_qp;
 		if ((i40e_reg_list[i].offset == I40E_PFINT_ITRN(0, 0) ||
 		     i40e_reg_list[i].offset == I40E_PFINT_ITRN(1, 0) ||
 		     i40e_reg_list[i].offset == I40E_PFINT_ITRN(2, 0) ||
 		     i40e_reg_list[i].offset == I40E_QINT_TQCTL(0) ||
 		     i40e_reg_list[i].offset == I40E_QINT_RQCTL(0)) &&
 		    hw->func_caps.num_msix_vectors != 0)
-			i40e_reg_list[i].elements =
-				hw->func_caps.num_msix_vectors - 1;
+			elements = hw->func_caps.num_msix_vectors - 1;
 
 		/* test register access */
 		mask = i40e_reg_list[i].mask;
-		for (j = 0; j < i40e_reg_list[i].elements && !ret_code; j++) {
+		for (j = 0; j < elements && !ret_code; j++) {
 			reg = i40e_reg_list[i].offset +
 			      (j * i40e_reg_list[i].stride);
 			ret_code = i40e_diag_reg_pattern_test(hw, reg, mask);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_diag.h b/drivers/net/ethernet/intel/i40e/i40e_diag.h
index c3340f320a18..1db7c6d57231 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_diag.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_diag.h
@@ -20,7 +20,7 @@ struct i40e_diag_reg_test_info {
 	u32 stride;	/* bytes between each element */
 };
 
-extern struct i40e_diag_reg_test_info i40e_reg_list[];
+extern const struct i40e_diag_reg_test_info i40e_reg_list[];
 
 i40e_status i40e_diag_reg_test(struct i40e_hw *hw);
 i40e_status i40e_diag_eeprom_test(struct i40e_hw *hw);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 8547fc8fdfd6..78423ca401b2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -662,7 +662,7 @@ struct iavf_rx_ptype_decoded iavf_ptype_lookup[] = {
 	/* Non Tunneled IPv6 */
 	IAVF_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
 	IAVF_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY3),
+	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
 	IAVF_PTT_UNUSED_ENTRY(91),
 	IAVF_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
 	IAVF_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 1f7b842c6763..7a1812912d6c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1061,7 +1061,7 @@ static inline void iavf_rx_hash(struct iavf_ring *ring,
 		cpu_to_le64((u64)IAVF_RX_DESC_FLTSTAT_RSS_HASH <<
 			    IAVF_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (!(ring->netdev->features & NETIF_F_RXHASH))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 10b16c292541..00d66a6e5c6e 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3674,9 +3674,7 @@ static void igb_remove(struct pci_dev *pdev)
 	igb_release_hw_control(adapter);
 
 #ifdef CONFIG_PCI_IOV
-	rtnl_lock();
 	igb_disable_sriov(pdev);
-	rtnl_unlock();
 #endif
 
 	unregister_netdev(netdev);
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 1082e49ea056..5bf1c9d84727 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1070,7 +1070,7 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 			  igbvf_intr_msix_rx, 0, adapter->rx_ring->name,
 			  netdev);
 	if (err)
-		goto out;
+		goto free_irq_tx;
 
 	adapter->rx_ring->itr_register = E1000_EITR(vector);
 	adapter->rx_ring->itr_val = adapter->current_itr;
@@ -1079,10 +1079,14 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 	err = request_irq(adapter->msix_entries[vector].vector,
 			  igbvf_msix_other, 0, netdev->name, netdev);
 	if (err)
-		goto out;
+		goto free_irq_rx;
 
 	igbvf_configure_msix(adapter);
 	return 0;
+free_irq_rx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
+free_irq_tx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
 out:
 	return err;
 }
diff --git a/drivers/net/ethernet/intel/igbvf/vf.c b/drivers/net/ethernet/intel/igbvf/vf.c
index b8ba3f94c363..a47a2e3e548c 100644
--- a/drivers/net/ethernet/intel/igbvf/vf.c
+++ b/drivers/net/ethernet/intel/igbvf/vf.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2009 - 2018 Intel Corporation. */
 
+#include <linux/etherdevice.h>
+
 #include "vf.h"
 
 static s32 e1000_check_for_link_vf(struct e1000_hw *hw);
@@ -131,11 +133,16 @@ static s32 e1000_reset_hw_vf(struct e1000_hw *hw)
 		/* set our "perm_addr" based on info provided by PF */
 		ret_val = mbx->ops.read_posted(hw, msgbuf, 3);
 		if (!ret_val) {
-			if (msgbuf[0] == (E1000_VF_RESET |
-					  E1000_VT_MSGTYPE_ACK))
+			switch (msgbuf[0]) {
+			case E1000_VF_RESET | E1000_VT_MSGTYPE_ACK:
 				memcpy(hw->mac.perm_addr, addr, ETH_ALEN);
-			else
+				break;
+			case E1000_VF_RESET | E1000_VT_MSGTYPE_NACK:
+				eth_zero_addr(hw->mac.perm_addr);
+				break;
+			default:
 				ret_val = -E1000_ERR_MAC_INIT;
+			}
 		}
 	}
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 2c1ee3268498..977c2961aa2c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -549,6 +549,20 @@ struct mvneta_rx_desc {
 };
 #endif
 
+enum mvneta_tx_buf_type {
+	MVNETA_TYPE_SKB,
+	MVNETA_TYPE_XDP_TX,
+	MVNETA_TYPE_XDP_NDO,
+};
+
+struct mvneta_tx_buf {
+	enum mvneta_tx_buf_type type;
+	union {
+		struct xdp_frame *xdpf;
+		struct sk_buff *skb;
+	};
+};
+
 struct mvneta_tx_queue {
 	/* Number of this TX queue, in the range 0-7 */
 	u8 id;
@@ -564,8 +578,8 @@ struct mvneta_tx_queue {
 	int tx_stop_threshold;
 	int tx_wake_threshold;
 
-	/* Array of transmitted skb */
-	struct sk_buff **tx_skb;
+	/* Array of transmitted buffers */
+	struct mvneta_tx_buf *buf;
 
 	/* Index of last TX DMA descriptor that was inserted */
 	int txq_put_index;
@@ -1774,14 +1788,9 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 	int i;
 
 	for (i = 0; i < num; i++) {
+		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_get_index];
 		struct mvneta_tx_desc *tx_desc = txq->descs +
 			txq->txq_get_index;
-		struct sk_buff *skb = txq->tx_skb[txq->txq_get_index];
-
-		if (skb) {
-			bytes_compl += skb->len;
-			pkts_compl++;
-		}
 
 		mvneta_txq_inc_get(txq);
 
@@ -1789,9 +1798,12 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
 			dma_unmap_single(pp->dev->dev.parent,
 					 tx_desc->buf_phys_addr,
 					 tx_desc->data_size, DMA_TO_DEVICE);
-		if (!skb)
+		if (!buf->skb)
 			continue;
-		dev_kfree_skb_any(skb);
+
+		bytes_compl += buf->skb->len;
+		pkts_compl++;
+		dev_kfree_skb_any(buf->skb);
 	}
 
 	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
@@ -2242,16 +2254,19 @@ static inline void
 mvneta_tso_put_hdr(struct sk_buff *skb,
 		   struct mvneta_port *pp, struct mvneta_tx_queue *txq)
 {
-	struct mvneta_tx_desc *tx_desc;
 	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
+	struct mvneta_tx_desc *tx_desc;
 
-	txq->tx_skb[txq->txq_put_index] = NULL;
 	tx_desc = mvneta_txq_next_desc_get(txq);
 	tx_desc->data_size = hdr_len;
 	tx_desc->command = mvneta_skb_tx_csum(pp, skb);
 	tx_desc->command |= MVNETA_TXD_F_DESC;
 	tx_desc->buf_phys_addr = txq->tso_hdrs_phys +
 				 txq->txq_put_index * TSO_HEADER_SIZE;
+	buf->type = MVNETA_TYPE_SKB;
+	buf->skb = NULL;
+
 	mvneta_txq_inc_put(txq);
 }
 
@@ -2260,6 +2275,7 @@ mvneta_tso_put_data(struct net_device *dev, struct mvneta_tx_queue *txq,
 		    struct sk_buff *skb, char *data, int size,
 		    bool last_tcp, bool is_last)
 {
+	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
 	struct mvneta_tx_desc *tx_desc;
 
 	tx_desc = mvneta_txq_next_desc_get(txq);
@@ -2273,7 +2289,8 @@ mvneta_tso_put_data(struct net_device *dev, struct mvneta_tx_queue *txq,
 	}
 
 	tx_desc->command = 0;
-	txq->tx_skb[txq->txq_put_index] = NULL;
+	buf->type = MVNETA_TYPE_SKB;
+	buf->skb = NULL;
 
 	if (last_tcp) {
 		/* last descriptor in the TCP packet */
@@ -2281,7 +2298,7 @@ mvneta_tso_put_data(struct net_device *dev, struct mvneta_tx_queue *txq,
 
 		/* last descriptor in SKB */
 		if (is_last)
-			txq->tx_skb[txq->txq_put_index] = skb;
+			buf->skb = skb;
 	}
 	mvneta_txq_inc_put(txq);
 	return 0;
@@ -2366,6 +2383,7 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 	int i, nr_frags = skb_shinfo(skb)->nr_frags;
 
 	for (i = 0; i < nr_frags; i++) {
+		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		void *addr = skb_frag_address(frag);
 
@@ -2385,12 +2403,13 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 		if (i == nr_frags - 1) {
 			/* Last descriptor */
 			tx_desc->command = MVNETA_TXD_L_DESC | MVNETA_TXD_Z_PAD;
-			txq->tx_skb[txq->txq_put_index] = skb;
+			buf->skb = skb;
 		} else {
 			/* Descriptor in the middle: Not First, Not Last */
 			tx_desc->command = 0;
-			txq->tx_skb[txq->txq_put_index] = NULL;
+			buf->skb = NULL;
 		}
+		buf->type = MVNETA_TYPE_SKB;
 		mvneta_txq_inc_put(txq);
 	}
 
@@ -2418,6 +2437,7 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 	struct mvneta_port *pp = netdev_priv(dev);
 	u16 txq_id = skb_get_queue_mapping(skb);
 	struct mvneta_tx_queue *txq = &pp->txqs[txq_id];
+	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
 	struct mvneta_tx_desc *tx_desc;
 	int len = skb->len;
 	int frags = 0;
@@ -2450,16 +2470,17 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 		goto out;
 	}
 
+	buf->type = MVNETA_TYPE_SKB;
 	if (frags == 1) {
 		/* First and Last descriptor */
 		tx_cmd |= MVNETA_TXD_FLZ_DESC;
 		tx_desc->command = tx_cmd;
-		txq->tx_skb[txq->txq_put_index] = skb;
+		buf->skb = skb;
 		mvneta_txq_inc_put(txq);
 	} else {
 		/* First but not Last */
 		tx_cmd |= MVNETA_TXD_F_DESC;
-		txq->tx_skb[txq->txq_put_index] = NULL;
+		buf->skb = NULL;
 		mvneta_txq_inc_put(txq);
 		tx_desc->command = tx_cmd;
 		/* Continue with other skb fragments */
@@ -3005,9 +3026,8 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 
 	txq->last_desc = txq->size - 1;
 
-	txq->tx_skb = kmalloc_array(txq->size, sizeof(*txq->tx_skb),
-				    GFP_KERNEL);
-	if (!txq->tx_skb) {
+	txq->buf = kmalloc_array(txq->size, sizeof(*txq->buf), GFP_KERNEL);
+	if (!txq->buf) {
 		dma_free_coherent(pp->dev->dev.parent,
 				  txq->size * MVNETA_DESC_ALIGNED_SIZE,
 				  txq->descs, txq->descs_phys);
@@ -3019,7 +3039,7 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 					   txq->size * TSO_HEADER_SIZE,
 					   &txq->tso_hdrs_phys, GFP_KERNEL);
 	if (!txq->tso_hdrs) {
-		kfree(txq->tx_skb);
+		kfree(txq->buf);
 		dma_free_coherent(pp->dev->dev.parent,
 				  txq->size * MVNETA_DESC_ALIGNED_SIZE,
 				  txq->descs, txq->descs_phys);
@@ -3074,7 +3094,7 @@ static void mvneta_txq_sw_deinit(struct mvneta_port *pp,
 {
 	struct netdev_queue *nq = netdev_get_tx_queue(pp->dev, txq->id);
 
-	kfree(txq->tx_skb);
+	kfree(txq->buf);
 
 	if (txq->tso_hdrs)
 		dma_free_coherent(pp->dev->dev.parent,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 01f2918063af..f1952e14c804 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -109,12 +109,14 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 	if (!MLX5_CAP_GEN(priv->mdev, ets))
 		return -EOPNOTSUPP;
 
-	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
-	for (i = 0; i < ets->ets_cap; i++) {
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err = mlx5_query_port_prio_tc(mdev, i, &ets->prio_tc[i]);
 		if (err)
 			return err;
+	}
 
+	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
+	for (i = 0; i < ets->ets_cap; i++) {
 		err = mlx5_query_port_tc_group(mdev, i, &tc_group[i]);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 05e760444a92..953708e2ab4b 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -256,7 +256,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
-	if (!laddr) {
+	if (dma_mapping_error(lp->device, laddr)) {
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
@@ -474,7 +474,7 @@ static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
 
 	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
 				   SONIC_RBSIZE, DMA_FROM_DEVICE);
-	if (!*new_addr) {
+	if (dma_mapping_error(lp->device, *new_addr)) {
 		dev_kfree_skb(*new_skb);
 		*new_skb = NULL;
 		return false;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 20f840ea0503..caa0468df4b5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4404,6 +4404,9 @@ qed_iov_configure_min_tx_rate(struct qed_dev *cdev, int vfid, u32 rate)
 	}
 
 	vf = qed_iov_get_vf_info(QED_LEADING_HWFN(cdev), (u16)vfid, true);
+	if (!vf)
+		return -EINVAL;
+
 	vport_id = vf->vport_id;
 
 	return qed_configure_vport_wfq(cdev, vport_id, rate);
@@ -5150,7 +5153,7 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 
 		/* Validate that the VF has a configured vport */
 		vf = qed_iov_get_vf_info(hwfn, i, true);
-		if (!vf->vport_instance)
+		if (!vf || !vf->vport_instance)
 			continue;
 
 		memset(&params, 0, sizeof(params));
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 5c199d2516d4..5fe28dec60c1 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -738,9 +738,15 @@ static int emac_remove(struct platform_device *pdev)
 	struct net_device *netdev = dev_get_drvdata(&pdev->dev);
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
 	unregister_netdev(netdev);
 	netif_napi_del(&adpt->rx_q.napi);
 
+	free_irq(adpt->irq.irq, &adpt->irq);
+	cancel_work_sync(&adpt->work_thread);
+
 	emac_clks_teardown(adpt);
 
 	put_device(&adpt->phydev->mdio.dev);
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 9d9f8acb7ee3..4e6c71da9f21 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -317,15 +317,17 @@ static int gelic_card_init_chain(struct gelic_card *card,
 
 	/* set up the hardware pointers in each descriptor */
 	for (i = 0; i < no; i++, descr++) {
+		dma_addr_t cpu_addr;
+
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
-		descr->bus_addr =
-			dma_map_single(ctodev(card), descr,
-				       GELIC_DESCR_SIZE,
-				       DMA_BIDIRECTIONAL);
 
-		if (!descr->bus_addr)
+		cpu_addr = dma_map_single(ctodev(card), descr,
+					  GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
+
+		if (dma_mapping_error(ctodev(card), cpu_addr))
 			goto iommu_error;
 
+		descr->bus_addr = cpu_to_be32(cpu_addr);
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 	}
@@ -365,28 +367,30 @@ static int gelic_card_init_chain(struct gelic_card *card,
  *
  * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
  * Activate the descriptor state-wise
+ *
+ * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the length
+ * must be a multiple of GELIC_NET_RXBUF_ALIGN.
  */
 static int gelic_descr_prepare_rx(struct gelic_card *card,
 				  struct gelic_descr *descr)
 {
+	static const unsigned int rx_skb_size =
+		ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
+		GELIC_NET_RXBUF_ALIGN - 1;
+	dma_addr_t cpu_addr;
 	int offset;
-	unsigned int bufsize;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
 		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
-	/* we need to round up the buffer size to a multiple of 128 */
-	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
 
-	/* and we need to have it 128 byte aligned, therefore we allocate a
-	 * bit more */
-	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
+	descr->skb = netdev_alloc_skb(*card->netdev, rx_skb_size);
 	if (!descr->skb) {
 		descr->buf_addr = 0; /* tell DMAC don't touch memory */
 		dev_info(ctodev(card),
 			 "%s:allocate skb failed !!\n", __func__);
 		return -ENOMEM;
 	}
-	descr->buf_size = cpu_to_be32(bufsize);
+	descr->buf_size = cpu_to_be32(rx_skb_size);
 	descr->dmac_cmd_status = 0;
 	descr->result_size = 0;
 	descr->valid_size = 0;
@@ -397,11 +401,10 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	if (offset)
 		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
 	/* io-mmu-map the skb */
-	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
-						     descr->skb->data,
-						     GELIC_NET_MAX_MTU,
-						     DMA_FROM_DEVICE));
-	if (!descr->buf_addr) {
+	cpu_addr = dma_map_single(ctodev(card), descr->skb->data,
+				  GELIC_NET_MAX_FRAME, DMA_FROM_DEVICE);
+	descr->buf_addr = cpu_to_be32(cpu_addr);
+	if (dma_mapping_error(ctodev(card), cpu_addr)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		dev_info(ctodev(card),
@@ -781,7 +784,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 
 	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
 
-	if (!buf) {
+	if (dma_mapping_error(ctodev(card), buf)) {
 		dev_err(ctodev(card),
 			"dma map 2 failed (%p, %i). Dropping packet\n",
 			skb->data, skb->len);
@@ -917,7 +920,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr *descr,
 	data_error = be32_to_cpu(descr->data_error);
 	/* unmap skb buffer */
 	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
-			 GELIC_NET_MAX_MTU,
+			 GELIC_NET_MAX_FRAME,
 			 DMA_FROM_DEVICE);
 
 	skb_put(skb, be32_to_cpu(descr->valid_size)?
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index 051033580f0a..7624c68c95cb 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -19,8 +19,9 @@
 #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
 #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
 
-#define GELIC_NET_MAX_MTU               VLAN_ETH_FRAME_LEN
-#define GELIC_NET_MIN_MTU               VLAN_ETH_ZLEN
+#define GELIC_NET_MAX_FRAME             2312
+#define GELIC_NET_MAX_MTU               2294
+#define GELIC_NET_MIN_MTU               64
 #define GELIC_NET_RXBUF_ALIGN           128
 #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */
 #define GELIC_NET_WATCHDOG_TIMEOUT      5*HZ
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index fd5288ff53b5..e3438cef5f9c 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -503,6 +503,11 @@ static void
 xirc2ps_detach(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+    struct local_info *local = netdev_priv(dev);
+
+    netif_carrier_off(dev);
+    netif_tx_disable(dev);
+    cancel_work_sync(&local->tx_timeout_task);
 
     dev_dbg(&link->dev, "detach\n");
 
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 66cf09e637e4..fb57e561d3e6 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1944,10 +1944,9 @@ static int ca8210_skb_tx(
 	struct ca8210_priv  *priv
 )
 {
-	int status;
 	struct ieee802154_hdr header = { };
 	struct secspec secspec;
-	unsigned int mac_len;
+	int mac_len, status;
 
 	dev_dbg(&priv->spi->dev, "%s called\n", __func__);
 
@@ -1955,6 +1954,8 @@ static int ca8210_skb_tx(
 	 * packet
 	 */
 	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
+	if (mac_len < 0)
+		return mac_len;
 
 	secspec.security_level = header.sec.level;
 	secspec.key_id_mode = header.sec.key_id_mode;
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index fb182bec8f06..6b7bba720d8c 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -130,14 +130,10 @@ static u16 net_failover_select_queue(struct net_device *dev,
 			txq = ops->ndo_select_queue(primary_dev, skb, sb_dev);
 		else
 			txq = netdev_pick_tx(primary_dev, skb, NULL);
-
-		qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
-
-		return txq;
+	} else {
+		txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
 	}
 
-	txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
-
 	/* Save the original txq to restore before passing to the driver */
 	qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
 
diff --git a/drivers/net/phy/mdio-thunder.c b/drivers/net/phy/mdio-thunder.c
index 1e2f57ed1ef7..31ca0361a11e 100644
--- a/drivers/net/phy/mdio-thunder.c
+++ b/drivers/net/phy/mdio-thunder.c
@@ -104,6 +104,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		if (i >= ARRAY_SIZE(nexus->buses))
 			break;
 	}
+	fwnode_handle_put(fwn);
 	return 0;
 
 err_release_regions:
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 5d94ac0250ec..a4e44f98fbc3 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -250,6 +250,9 @@ struct tun_struct {
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
 	struct ethtool_link_ksettings link_ksettings;
+	/* init args */
+	struct file *file;
+	struct ifreq *ifr;
 };
 
 struct veth {
@@ -275,6 +278,9 @@ void *tun_ptr_to_xdp(void *ptr)
 }
 EXPORT_SYMBOL(tun_ptr_to_xdp);
 
+static void tun_flow_init(struct tun_struct *tun);
+static void tun_flow_uninit(struct tun_struct *tun);
+
 static int tun_napi_receive(struct napi_struct *napi, int budget)
 {
 	struct tun_file *tfile = container_of(napi, struct tun_file, napi);
@@ -1027,6 +1033,49 @@ static int check_filter(struct tap_filter *filter, const struct sk_buff *skb)
 
 static const struct ethtool_ops tun_ethtool_ops;
 
+static int tun_net_init(struct net_device *dev)
+{
+	struct tun_struct *tun = netdev_priv(dev);
+	struct ifreq *ifr = tun->ifr;
+	int err;
+
+	tun->pcpu_stats = netdev_alloc_pcpu_stats(struct tun_pcpu_stats);
+	if (!tun->pcpu_stats)
+		return -ENOMEM;
+
+	spin_lock_init(&tun->lock);
+
+	err = security_tun_dev_alloc_security(&tun->security);
+	if (err < 0) {
+		free_percpu(tun->pcpu_stats);
+		return err;
+	}
+
+	tun_flow_init(tun);
+
+	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
+			   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
+			   NETIF_F_HW_VLAN_STAG_TX;
+	dev->features = dev->hw_features | NETIF_F_LLTX;
+	dev->vlan_features = dev->features &
+			     ~(NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_HW_VLAN_STAG_TX);
+
+	tun->flags = (tun->flags & ~TUN_FEATURES) |
+		      (ifr->ifr_flags & TUN_FEATURES);
+
+	INIT_LIST_HEAD(&tun->disabled);
+	err = tun_attach(tun, tun->file, false, ifr->ifr_flags & IFF_NAPI,
+			 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
+	if (err < 0) {
+		tun_flow_uninit(tun);
+		security_tun_dev_free_security(tun->security);
+		free_percpu(tun->pcpu_stats);
+		return err;
+	}
+	return 0;
+}
+
 /* Net device detach from fd. */
 static void tun_net_uninit(struct net_device *dev)
 {
@@ -1285,6 +1334,7 @@ static int tun_net_change_carrier(struct net_device *dev, bool new_carrier)
 }
 
 static const struct net_device_ops tun_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1365,6 +1415,7 @@ static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
 }
 
 static const struct net_device_ops tap_netdev_ops = {
+	.ndo_init		= tun_net_init,
 	.ndo_uninit		= tun_net_uninit,
 	.ndo_open		= tun_net_open,
 	.ndo_stop		= tun_net_close,
@@ -1405,7 +1456,7 @@ static void tun_flow_uninit(struct tun_struct *tun)
 #define MAX_MTU 65535
 
 /* Initialize net device. */
-static void tun_net_init(struct net_device *dev)
+static void tun_net_initialize(struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
@@ -2839,9 +2890,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		if (!dev)
 			return -ENOMEM;
-		err = dev_get_valid_name(net, dev, name);
-		if (err < 0)
-			goto err_free_dev;
 
 		dev_net_set(dev, net);
 		dev->rtnl_link_ops = &tun_link_ops;
@@ -2860,41 +2908,16 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		tun->rx_batched = 0;
 		RCU_INIT_POINTER(tun->steering_prog, NULL);
 
-		tun->pcpu_stats = netdev_alloc_pcpu_stats(struct tun_pcpu_stats);
-		if (!tun->pcpu_stats) {
-			err = -ENOMEM;
-			goto err_free_dev;
-		}
-
-		spin_lock_init(&tun->lock);
-
-		err = security_tun_dev_alloc_security(&tun->security);
-		if (err < 0)
-			goto err_free_stat;
-
-		tun_net_init(dev);
-		tun_flow_init(tun);
-
-		dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
-				   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_STAG_TX;
-		dev->features = dev->hw_features | NETIF_F_LLTX;
-		dev->vlan_features = dev->features &
-				     ~(NETIF_F_HW_VLAN_CTAG_TX |
-				       NETIF_F_HW_VLAN_STAG_TX);
+		tun->ifr = ifr;
+		tun->file = file;
 
-		tun->flags = (tun->flags & ~TUN_FEATURES) |
-			      (ifr->ifr_flags & TUN_FEATURES);
-
-		INIT_LIST_HEAD(&tun->disabled);
-		err = tun_attach(tun, file, false, ifr->ifr_flags & IFF_NAPI,
-				 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
-		if (err < 0)
-			goto err_free_flow;
+		tun_net_initialize(dev);
 
 		err = register_netdevice(tun->dev);
-		if (err < 0)
-			goto err_detach;
+		if (err < 0) {
+			free_netdev(dev);
+			return err;
+		}
 		/* free_netdev() won't check refcnt, to aovid race
 		 * with dev_put() we need publish tun after registration.
 		 */
@@ -2913,20 +2936,6 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 	strcpy(ifr->ifr_name, tun->dev->name);
 	return 0;
-
-err_detach:
-	tun_detach_all(dev);
-	/* register_netdevice() already called tun_free_netdev() */
-	goto err_free_dev;
-
-err_free_flow:
-	tun_flow_uninit(tun);
-	security_tun_dev_free_security(tun->security);
-err_free_stat:
-	free_percpu(tun->pcpu_stats);
-err_free_dev:
-	free_netdev(dev);
-	return err;
 }
 
 static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 414341c9cf5a..6ad1fb00a35c 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -663,6 +663,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FE990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1081, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index c310cdbfd583..c2307cfaf400 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1319,6 +1319,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1080, 2)}, /* Telit FE990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bb4ccbda031a..9a770f7fa5b0 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1935,6 +1935,12 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (u16)((header & RX_STS_FL_) >> 16);
 		align_count = (4 - ((size + NET_IP_ALIGN) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err header=0x%08x\n", header);
+			return 0;
+		}
+
 		if (unlikely(header & RX_STS_ES_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error header=0x%08x\n", header);
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index ced413d394cd..56ab292cacc5 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -166,7 +166,7 @@ struct xenvif_queue { /* Per-queue data for xenvif */
 	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
 	grant_handle_t grant_tx_handle[MAX_PENDING_REQS];
 
-	struct gnttab_copy tx_copy_ops[MAX_PENDING_REQS];
+	struct gnttab_copy tx_copy_ops[2 * MAX_PENDING_REQS];
 	struct gnttab_map_grant_ref tx_map_ops[MAX_PENDING_REQS];
 	struct gnttab_unmap_grant_ref tx_unmap_ops[MAX_PENDING_REQS];
 	/* passed to gnttab_[un]map_refs with pages under (un)mapping */
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 036459670fc3..3dfc5c66f140 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -327,6 +327,7 @@ static int xenvif_count_requests(struct xenvif_queue *queue,
 struct xenvif_tx_cb {
 	u16 copy_pending_idx[XEN_NETBK_LEGACY_SLOTS_MAX + 1];
 	u8 copy_count;
+	u32 split_mask;
 };
 
 #define XENVIF_TX_CB(skb) ((struct xenvif_tx_cb *)(skb)->cb)
@@ -354,6 +355,8 @@ static inline struct sk_buff *xenvif_alloc_skb(unsigned int size)
 	struct sk_buff *skb =
 		alloc_skb(size + NET_SKB_PAD + NET_IP_ALIGN,
 			  GFP_ATOMIC | __GFP_NOWARN);
+
+	BUILD_BUG_ON(sizeof(*XENVIF_TX_CB(skb)) > sizeof(skb->cb));
 	if (unlikely(skb == NULL))
 		return NULL;
 
@@ -389,11 +392,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 	nr_slots = shinfo->nr_frags + 1;
 
 	copy_count(skb) = 0;
+	XENVIF_TX_CB(skb)->split_mask = 0;
 
 	/* Create copy ops for exactly data_len bytes into the skb head. */
 	__skb_put(skb, data_len);
 	while (data_len > 0) {
 		int amount = data_len > txp->size ? txp->size : data_len;
+		bool split = false;
 
 		cop->source.u.ref = txp->gref;
 		cop->source.domid = queue->vif->domid;
@@ -406,6 +411,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
 				               - data_len);
 
+		/* Don't cross local page boundary! */
+		if (cop->dest.offset + amount > XEN_PAGE_SIZE) {
+			amount = XEN_PAGE_SIZE - cop->dest.offset;
+			XENVIF_TX_CB(skb)->split_mask |= 1U << copy_count(skb);
+			split = true;
+		}
+
 		cop->len = amount;
 		cop->flags = GNTCOPY_source_gref;
 
@@ -413,7 +425,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 		pending_idx = queue->pending_ring[index];
 		callback_param(queue, pending_idx).ctx = NULL;
 		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
-		copy_count(skb)++;
+		if (!split)
+			copy_count(skb)++;
 
 		cop++;
 		data_len -= amount;
@@ -434,7 +447,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 			nr_slots--;
 		} else {
 			/* The copy op partially covered the tx_request.
-			 * The remainder will be mapped.
+			 * The remainder will be mapped or copied in the next
+			 * iteration.
 			 */
 			txp->offset += amount;
 			txp->size -= amount;
@@ -532,6 +546,13 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 		pending_idx = copy_pending_idx(skb, i);
 
 		newerr = (*gopp_copy)->status;
+
+		/* Split copies need to be handled together. */
+		if (XENVIF_TX_CB(skb)->split_mask & (1U << i)) {
+			(*gopp_copy)++;
+			if (!newerr)
+				newerr = (*gopp_copy)->status;
+		}
 		if (likely(!newerr)) {
 			/* The first frag might still have this slot mapped */
 			if (i < copy_count(skb) - 1 || !sharedslot)
diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index 4ee3fcc6c91f..064b7c3c942a 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1069,7 +1069,6 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 		dev_err(dev, "can't add the irq domain\n");
 		return -ENODEV;
 	}
-	atmel_pioctrl->irq_domain->name = "atmel gpio";
 
 	for (i = 0; i < atmel_pioctrl->npins; i++) {
 		int irq = irq_create_mapping(atmel_pioctrl->irq_domain, i);
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 0a951a75c82b..cccf1cc8736c 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -420,7 +420,7 @@ static int ocelot_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	regmap_update_bits(info->map, REG_ALT(0, info, pin->pin),
 			   BIT(p), f << p);
 	regmap_update_bits(info->map, REG_ALT(1, info, pin->pin),
-			   BIT(p), f << (p - 1));
+			   BIT(p), (f >> 1) << p);
 
 	return 0;
 }
diff --git a/drivers/platform/chrome/cros_ec_chardev.c b/drivers/platform/chrome/cros_ec_chardev.c
index 1f5f4a46ab74..4791b62c2923 100644
--- a/drivers/platform/chrome/cros_ec_chardev.c
+++ b/drivers/platform/chrome/cros_ec_chardev.c
@@ -285,7 +285,7 @@ static long cros_ec_chardev_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
 	    u_cmd.insize > EC_MAX_MSG_BYTES)
 		return -EINVAL;
 
-	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
+	s_cmd = kzalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
 			GFP_KERNEL);
 	if (!s_cmd)
 		return -ENOMEM;
diff --git a/drivers/power/supply/da9150-charger.c b/drivers/power/supply/da9150-charger.c
index f9314cc0cd75..6b987da58655 100644
--- a/drivers/power/supply/da9150-charger.c
+++ b/drivers/power/supply/da9150-charger.c
@@ -662,6 +662,7 @@ static int da9150_charger_remove(struct platform_device *pdev)
 
 	if (!IS_ERR_OR_NULL(charger->usb_phy))
 		usb_unregister_notifier(charger->usb_phy, &charger->otg_nb);
+	cancel_work_sync(&charger->otg_work);
 
 	power_supply_unregister(charger->battery);
 	power_supply_unregister(charger->usb);
diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index a577218d1ab7..ca211feadb38 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -604,7 +604,7 @@ static int ptp_qoriq_probe(struct platform_device *dev)
 	return 0;
 
 no_clock:
-	iounmap(ptp_qoriq->base);
+	iounmap(base);
 no_ioremap:
 	release_resource(ptp_qoriq->rsrc);
 no_resource:
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index f81533070058..2f0bed86467f 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -181,8 +181,8 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 
 		drvdata->enable_clock = devm_clk_get(dev, NULL);
 		if (IS_ERR(drvdata->enable_clock)) {
-			dev_err(dev, "Cant get enable-clock from devicetree\n");
-			return -ENOENT;
+			dev_err(dev, "Can't get enable-clock from devicetree\n");
+			return PTR_ERR(drvdata->enable_clock);
 		}
 	} else {
 		drvdata->desc.ops = &fixed_voltage_ops;
diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 7dc72cb718b0..22128eb44f7f 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -82,8 +82,9 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 
 static void vfio_ap_matrix_dev_release(struct device *dev)
 {
-	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
+	struct ap_matrix_dev *matrix_dev;
 
+	matrix_dev = container_of(dev, struct ap_matrix_dev, device);
 	kfree(matrix_dev);
 }
 
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index fe8a5e5c0df8..bf0b3178f84d 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1036,10 +1036,12 @@ static int alua_activate(struct scsi_device *sdev,
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	if (alua_rtpg_queue(pg, sdev, qdata, true))
+	if (alua_rtpg_queue(pg, sdev, qdata, true)) {
 		fn = NULL;
-	else
+	} else {
+		kfree(qdata);
 		err = SCSI_DH_DEV_OFFLINED;
+	}
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bd908dd27307..e489c68cfb63 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20407,20 +20407,20 @@ lpfc_get_io_buf_from_private_pool(struct lpfc_hba *phba,
 static struct lpfc_io_buf *
 lpfc_get_io_buf_from_expedite_pool(struct lpfc_hba *phba)
 {
-	struct lpfc_io_buf *lpfc_ncmd;
+	struct lpfc_io_buf *lpfc_ncmd = NULL, *iter;
 	struct lpfc_io_buf *lpfc_ncmd_next;
 	unsigned long iflag;
 	struct lpfc_epd_pool *epd_pool;
 
 	epd_pool = &phba->epd_pool;
-	lpfc_ncmd = NULL;
 
 	spin_lock_irqsave(&epd_pool->lock, iflag);
 	if (epd_pool->count > 0) {
-		list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+		list_for_each_entry_safe(iter, lpfc_ncmd_next,
 					 &epd_pool->list, list) {
-			list_del(&lpfc_ncmd->list);
+			list_del(&iter->list);
 			epd_pool->count--;
+			lpfc_ncmd = iter;
 			break;
 		}
 	}
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 944273f60d22..890002688bd4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4659,7 +4659,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"task abort issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
@@ -4729,7 +4729,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 636571d3e820..30a5ca9c5a8d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1738,6 +1738,17 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
 		if (sp) {
+			/*
+			 * perform lockless completion during driver unload
+			 */
+			if (qla2x00_chip_is_down(vha)) {
+				req->outstanding_cmds[cnt] = NULL;
+				spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
+				sp->done(sp, res);
+				spin_lock_irqsave(qp->qp_lock_ptr, flags);
+				continue;
+			}
+
 			switch (sp->cmd_type) {
 			case TYPE_SRB:
 				qla2x00_abort_srb(qp, sp, res, &flags);
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 7f76bf5cc8a8..e920a6a79594 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -232,6 +232,7 @@ static struct {
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
 	{"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"SKhynix", "H28U74301AMR", NULL, BLIST_SKIP_VPD_PAGES},
 	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 670f4c7934f8..9d13226d2324 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8530,5 +8530,6 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 7a461fbb1566..31cd3c02e517 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1262,18 +1262,20 @@ static struct iscsi_param *iscsi_check_key(
 		return param;
 
 	if (!(param->phase & phase)) {
-		pr_err("Key \"%s\" may not be negotiated during ",
-				param->name);
+		char *phase_name;
+
 		switch (phase) {
 		case PHASE_SECURITY:
-			pr_debug("Security phase.\n");
+			phase_name = "Security";
 			break;
 		case PHASE_OPERATIONAL:
-			pr_debug("Operational phase.\n");
+			phase_name = "Operational";
 			break;
 		default:
-			pr_debug("Unknown phase.\n");
+			phase_name = "Unknown";
 		}
+		pr_err("Key \"%s\" may not be negotiated during %s phase.\n",
+				param->name, phase_name);
 		return NULL;
 	}
 
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 73a698eec743..8a117d1c8888 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -40,7 +40,7 @@
 
 #define NHI_MAILBOX_TIMEOUT	500 /* ms */
 
-static int ring_interrupt_index(struct tb_ring *ring)
+static int ring_interrupt_index(const struct tb_ring *ring)
 {
 	int bit = ring->hop;
 	if (!ring->is_tx)
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 7dd11b62a196..bf8bb9ce4fab 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -43,6 +43,7 @@ struct xencons_info {
 	int irq;
 	int vtermno;
 	grant_ref_t gntref;
+	spinlock_t ring_lock;
 };
 
 static LIST_HEAD(xenconsoles);
@@ -89,12 +90,15 @@ static int __write_console(struct xencons_info *xencons,
 	XENCONS_RING_IDX cons, prod;
 	struct xencons_interface *intf = xencons->intf;
 	int sent = 0;
+	unsigned long flags;
 
+	spin_lock_irqsave(&xencons->ring_lock, flags);
 	cons = intf->out_cons;
 	prod = intf->out_prod;
 	mb();			/* update queue values before going on */
 
 	if ((prod - cons) > sizeof(intf->out)) {
+		spin_unlock_irqrestore(&xencons->ring_lock, flags);
 		pr_err_once("xencons: Illegal ring page indices");
 		return -EINVAL;
 	}
@@ -104,6 +108,7 @@ static int __write_console(struct xencons_info *xencons,
 
 	wmb();			/* write ring before updating pointer */
 	intf->out_prod = prod;
+	spin_unlock_irqrestore(&xencons->ring_lock, flags);
 
 	if (sent)
 		notify_daemon(xencons);
@@ -146,16 +151,19 @@ static int domU_read_console(uint32_t vtermno, char *buf, int len)
 	int recv = 0;
 	struct xencons_info *xencons = vtermno_to_xencons(vtermno);
 	unsigned int eoiflag = 0;
+	unsigned long flags;
 
 	if (xencons == NULL)
 		return -EINVAL;
 	intf = xencons->intf;
 
+	spin_lock_irqsave(&xencons->ring_lock, flags);
 	cons = intf->in_cons;
 	prod = intf->in_prod;
 	mb();			/* get pointers before reading ring */
 
 	if ((prod - cons) > sizeof(intf->in)) {
+		spin_unlock_irqrestore(&xencons->ring_lock, flags);
 		pr_err_once("xencons: Illegal ring page indices");
 		return -EINVAL;
 	}
@@ -179,10 +187,13 @@ static int domU_read_console(uint32_t vtermno, char *buf, int len)
 		xencons->out_cons = intf->out_cons;
 		xencons->out_cons_same = 0;
 	}
+	if (!recv && xencons->out_cons_same++ > 1) {
+		eoiflag = XEN_EOI_FLAG_SPURIOUS;
+	}
+	spin_unlock_irqrestore(&xencons->ring_lock, flags);
+
 	if (recv) {
 		notify_daemon(xencons);
-	} else if (xencons->out_cons_same++ > 1) {
-		eoiflag = XEN_EOI_FLAG_SPURIOUS;
 	}
 
 	xen_irq_lateeoi(xencons->irq, eoiflag);
@@ -239,6 +250,7 @@ static int xen_hvm_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
+		spin_lock_init(&info->ring_lock);
 	} else if (info->intf != NULL) {
 		/* already configured */
 		return 0;
@@ -275,6 +287,7 @@ static int xen_hvm_console_init(void)
 
 static int xencons_info_pv_init(struct xencons_info *info, int vtermno)
 {
+	spin_lock_init(&info->ring_lock);
 	info->evtchn = xen_start_info->console.domU.evtchn;
 	/* GFN == MFN for PV guest */
 	info->intf = gfn_to_virt(xen_start_info->console.domU.mfn);
@@ -325,6 +338,7 @@ static int xen_initial_domain_console_init(void)
 		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 		if (!info)
 			return -ENOMEM;
+		spin_lock_init(&info->ring_lock);
 	}
 
 	info->irq = bind_virq_to_irq(VIRQ_CONSOLE, 0, false);
@@ -482,6 +496,7 @@ static int xencons_probe(struct xenbus_device *dev,
 	info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
+	spin_lock_init(&info->ring_lock);
 	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->vtermno = xenbus_devid_to_vtermno(devid);
diff --git a/drivers/usb/cdns3/cdns3-pci-wrap.c b/drivers/usb/cdns3/cdns3-pci-wrap.c
index b0a29efe7d31..14878e3f8fbf 100644
--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -60,6 +60,11 @@ static struct pci_dev *cdns3_get_second_fun(struct pci_dev *pdev)
 			return NULL;
 	}
 
+	if (func->devfn != PCI_DEV_FN_HOST_DEVICE &&
+	    func->devfn != PCI_DEV_FN_OTG) {
+		return NULL;
+	}
+
 	return func;
 }
 
diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 6911aef500e9..ff61f88fc867 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -203,6 +203,7 @@ struct hw_bank {
  * @in_lpm: if the core in low power mode
  * @wakeup_int: if wakeup interrupt occur
  * @rev: The revision number for controller
+ * @mutex: protect code from concorrent running when doing role switch
  */
 struct ci_hdrc {
 	struct device			*dev;
@@ -256,6 +257,7 @@ struct ci_hdrc {
 	bool				in_lpm;
 	bool				wakeup_int;
 	enum ci_revision		rev;
+	struct mutex                    mutex;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 74cdc7ef476a..7a86979cf140 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -960,9 +960,16 @@ static ssize_t role_store(struct device *dev,
 			     strlen(ci->roles[role]->name)))
 			break;
 
-	if (role == CI_ROLE_END || role == ci->role)
+	if (role == CI_ROLE_END)
 		return -EINVAL;
 
+	mutex_lock(&ci->mutex);
+
+	if (role == ci->role) {
+		mutex_unlock(&ci->mutex);
+		return n;
+	}
+
 	pm_runtime_get_sync(dev);
 	disable_irq(ci->irq);
 	ci_role_stop(ci);
@@ -971,6 +978,7 @@ static ssize_t role_store(struct device *dev,
 		ci_handle_vbus_change(ci);
 	enable_irq(ci->irq);
 	pm_runtime_put_sync(dev);
+	mutex_unlock(&ci->mutex);
 
 	return (ret == 0) ? n : ret;
 }
@@ -1006,6 +1014,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	spin_lock_init(&ci->lock);
+	mutex_init(&ci->mutex);
 	ci->dev = dev;
 	ci->platdata = dev_get_platdata(dev);
 	ci->imx28_write_fix = !!(ci->platdata->flags &
diff --git a/drivers/usb/chipidea/otg.c b/drivers/usb/chipidea/otg.c
index fbfb02e05c97..0fcb8d8776cc 100644
--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -164,8 +164,10 @@ static int hw_wait_vbus_lower_bsv(struct ci_hdrc *ci)
 
 static void ci_handle_id_switch(struct ci_hdrc *ci)
 {
-	enum ci_role role = ci_otg_role(ci);
+	enum ci_role role;
 
+	mutex_lock(&ci->mutex);
+	role = ci_otg_role(ci);
 	if (role != ci->role) {
 		dev_dbg(ci->dev, "switching from %s to %s\n",
 			ci_role(ci)->name, ci->roles[role]->name);
@@ -188,6 +190,7 @@ static void ci_handle_id_switch(struct ci_hdrc *ci)
 		if (role == CI_ROLE_GADGET)
 			ci_handle_vbus_change(ci);
 	}
+	mutex_unlock(&ci->mutex);
 }
 /**
  * ci_otg_work - perform otg (vbus/id) event handle
diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 4e01ba0ab8ec..53b30de16a89 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -626,7 +626,7 @@ void g_audio_cleanup(struct g_audio *g_audio)
 	uac = g_audio->uac;
 	card = uac->card;
 	if (card)
-		snd_card_free(card);
+		snd_card_free_when_closed(card);
 
 	kfree(uac->p_prm.ureq);
 	kfree(uac->c_prm.ureq);
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index d4fa29b623ff..a4513dd931b2 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -111,6 +111,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BROKEN_FUA),
 
+/* Reported by: Yaroslav Furman <yaro330@gmail.com> */
+UNUSUAL_DEV(0x152d, 0x0583, 0x0000, 0x9999,
+		"JMicron",
+		"JMS583Gen 2",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
 UNUSUAL_DEV(0x154b, 0xf00b, 0x0000, 0x9999,
 		"PNY",
diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index 265d3b45efd0..43a4dddaafd5 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1040,6 +1040,9 @@ static int au1200fb_fb_check_var(struct fb_var_screeninfo *var,
 	u32 pixclock;
 	int screen_size, plane;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	plane = fbdev->plane;
 
 	/* Make sure that the mode respect all LCD controller and
diff --git a/drivers/video/fbdev/geode/lxfb_core.c b/drivers/video/fbdev/geode/lxfb_core.c
index b0f07d676eb3..ffda25089e2c 100644
--- a/drivers/video/fbdev/geode/lxfb_core.c
+++ b/drivers/video/fbdev/geode/lxfb_core.c
@@ -234,6 +234,9 @@ static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
 
 static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->xres > 1920 || var->yres > 1440)
 		return -EINVAL;
 
diff --git a/drivers/video/fbdev/intelfb/intelfbdrv.c b/drivers/video/fbdev/intelfb/intelfbdrv.c
index a76c61512c60..274e6bb4a961 100644
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c
+++ b/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -1214,6 +1214,9 @@ static int intelfb_check_var(struct fb_var_screeninfo *var,
 
 	dinfo = GET_DINFO(info);
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* update the pitch */
 	if (intelfbhw_validate_mode(dinfo, var) != 0)
 		return -EINVAL;
diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index fbeeed5afe35..aa502b3ba25a 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -766,6 +766,8 @@ static int nvidiafb_check_var(struct fb_var_screeninfo *var,
 	int pitch, err = 0;
 
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
diff --git a/drivers/video/fbdev/tgafb.c b/drivers/video/fbdev/tgafb.c
index 286b2371c7dd..eab2b4f87d68 100644
--- a/drivers/video/fbdev/tgafb.c
+++ b/drivers/video/fbdev/tgafb.c
@@ -166,6 +166,9 @@ tgafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct tga_par *par = (struct tga_par *)info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (par->tga_type == TGA_TYPE_8PLANE) {
 		if (var->bits_per_pixel != 8)
 			return -EINVAL;
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 06346422f743..486d7978ea97 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -411,7 +411,7 @@ static dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 
 done:
 	if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-		xen_dma_sync_for_device(dev, dev_addr, phys, size, dir);
+		xen_dma_sync_for_device(dev_addr, phys, size, dir);
 	return dev_addr;
 }
 
@@ -431,7 +431,7 @@ static void xen_swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (!dev_is_dma_coherent(hwdev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-		xen_dma_sync_for_cpu(hwdev, dev_addr, paddr, size, dir);
+		xen_dma_sync_for_cpu(dev_addr, paddr, size, dir);
 
 	/* NOTE: We use dev_addr here, not paddr! */
 	if (is_xen_swiotlb_buffer(dev_addr))
@@ -445,7 +445,7 @@ xen_swiotlb_sync_single_for_cpu(struct device *dev, dma_addr_t dma_addr,
 	phys_addr_t paddr = xen_bus_to_phys(dma_addr);
 
 	if (!dev_is_dma_coherent(dev))
-		xen_dma_sync_for_cpu(dev, dma_addr, paddr, size, dir);
+		xen_dma_sync_for_cpu(dma_addr, paddr, size, dir);
 
 	if (is_xen_swiotlb_buffer(dma_addr))
 		swiotlb_tbl_sync_single(dev, paddr, size, dir, SYNC_FOR_CPU);
@@ -461,7 +461,7 @@ xen_swiotlb_sync_single_for_device(struct device *dev, dma_addr_t dma_addr,
 		swiotlb_tbl_sync_single(dev, paddr, size, dir, SYNC_FOR_DEVICE);
 
 	if (!dev_is_dma_coherent(dev))
-		xen_dma_sync_for_device(dev, dma_addr, paddr, size, dir);
+		xen_dma_sync_for_device(dma_addr, paddr, size, dir);
 }
 
 /*
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3fa972a43b5e..c5944c61317f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1579,8 +1579,17 @@ struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
 	bytenr = btrfs_sb_offset(0);
-	flags |= FMODE_EXCL;
 
+	/*
+	 * Avoid using flag |= FMODE_EXCL here, as the systemd-udev may
+	 * initiate the device scan which may race with the user's mount
+	 * or mkfs command, resulting in failure.
+	 * Since the device scan is solely for reading purposes, there is
+	 * no need for FMODE_EXCL. Additionally, the devices are read again
+	 * during the mount process. It is ok to get some inconsistent
+	 * values temporarily, as the device paths of the fsid are the only
+	 * required information for assembling the volume.
+	 */
 	bdev = blkdev_get_by_path(path, flags, holder);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index bc4ca94137f2..7b155e19df4e 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -125,7 +125,10 @@ extern const struct dentry_operations cifs_ci_dentry_ops;
 #ifdef CONFIG_CIFS_DFS_UPCALL
 extern struct vfsmount *cifs_dfs_d_automount(struct path *path);
 #else
-#define cifs_dfs_d_automount NULL
+static inline struct vfsmount *cifs_dfs_d_automount(struct path *path)
+{
+	return ERR_PTR(-EREMOTE);
+}
 #endif
 
 /* Functions related to symlinks */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4b8632eda2bd..f924f05b1829 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4933,8 +4933,13 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 		return -ENODEV;
 
 getDFSRetry:
-	rc = smb_init(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc, (void **) &pSMB,
-		      (void **) &pSMBr);
+	/*
+	 * Use smb_init_no_reconnect() instead of smb_init() as
+	 * CIFSGetDFSRefer() may be called from cifs_reconnect_tcon() and thus
+	 * causing an infinite recursion.
+	 */
+	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc,
+				   (void **)&pSMB, (void **)&pSMBr);
 	if (rc)
 		return rc;
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 4cb0ebe7330e..68e783272c62 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -587,7 +587,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc == -EOPNOTSUPP) {
 		cifs_dbg(FYI,
 			 "server does not support query network interfaces\n");
-		goto out;
+		ret_data_len = 0;
 	} else if (rc != 0) {
 		cifs_tcon_dbg(VFS, "error %d on ioctl to get interface list\n", rc);
 		goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 57b40308b32b..c078a8cc0c73 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1439,7 +1439,8 @@ static int ext4_write_end(struct file *file,
 	bool verity = ext4_verity_in_progress(inode);
 
 	trace_ext4_write_end(inode, pos, len, copied);
-	if (inline_data) {
+	if (inline_data &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
 		ret = ext4_write_inline_data_end(inode, pos, len,
 						 copied, page);
 		if (ret < 0) {
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index c21383fab33b..9dbe94c7d8e8 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -456,8 +456,6 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 		return error;
 
 	kaddr = kmap_atomic(page);
-	if (dsize > gfs2_max_stuffed_size(ip))
-		dsize = gfs2_max_stuffed_size(ip);
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 	memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 	kunmap_atomic(kaddr);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 77a497a4b236..b349ba328a0b 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -70,9 +70,6 @@ static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 		void *kaddr = kmap(page);
 		u64 dsize = i_size_read(inode);
  
-		if (dsize > gfs2_max_stuffed_size(ip))
-			dsize = gfs2_max_stuffed_size(ip);
-
 		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 		memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 		kunmap(page);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index d5b9274662db..69106a1545fa 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -411,6 +411,9 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
+	if (gfs2_is_stuffed(ip) && ip->i_inode.i_size > gfs2_max_stuffed_size(ip))
+		goto corrupt;
+
 	if (S_ISREG(ip->i_inode.i_mode))
 		gfs2_set_aops(&ip->i_inode);
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index a76550d927e7..c54dd49c993c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1934,8 +1934,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 	if (!data->rpc_done) {
 		if (data->rpc_status)
 			return ERR_PTR(data->rpc_status);
-		/* cached opens have already been processed */
-		goto update;
+		return nfs4_try_open_cached(data);
 	}
 
 	ret = nfs_refresh_inode(inode, &data->f_attr);
@@ -1944,7 +1943,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
-update:
+
 	if (!update_open_stateid(state, &data->o_res.stateid,
 				NULL, data->o_arg.fmode))
 		return ERR_PTR(-EAGAIN);
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 262783cd79cc..83926b9ab4b5 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -70,7 +70,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
 		return -EINVAL;
 
-	buf = (void *)__get_free_pages(GFP_NOFS, 0);
+	buf = (void *)get_zeroed_page(GFP_NOFS);
 	if (unlikely(!buf))
 		return -ENOMEM;
 	maxmembs = PAGE_SIZE / argv->v_size;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7f66e3342475..91702ebffe84 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1990,11 +1990,25 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 	}
 
 	if (unlikely(copied < len) && wc->w_target_page) {
+		loff_t new_isize;
+
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
 
-		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
-				       start+len);
+		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
+		if (new_isize > page_offset(wc->w_target_page))
+			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
+					       start+len);
+		else {
+			/*
+			 * When page is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the page. Invalidate
+			 * it instead so that writeback does not get confused
+			 * put page & buffer dirty bits into inconsistent
+			 * state.
+			 */
+			block_invalidatepage(wc->w_target_page, 0, PAGE_SIZE);
+		}
 	}
 	if (wc->w_target_page)
 		flush_dcache_page(wc->w_target_page);
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 1370bfd17e87..39459b1eff75 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -350,25 +350,27 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 		goto out_drop_write;
 
 	err = enable_verity(filp, &arg);
-	if (err)
-		goto out_allow_write_access;
 
 	/*
-	 * Some pages of the file may have been evicted from pagecache after
-	 * being used in the Merkle tree construction, then read into pagecache
-	 * again by another process reading from the file concurrently.  Since
-	 * these pages didn't undergo verification against the file measurement
-	 * which fs-verity now claims to be enforcing, we have to wipe the
-	 * pagecache to ensure that all future reads are verified.
+	 * We no longer drop the inode's pagecache after enabling verity.  This
+	 * used to be done to try to avoid a race condition where pages could be
+	 * evicted after being used in the Merkle tree construction, then
+	 * re-instantiated by a concurrent read.  Such pages are unverified, and
+	 * the backing storage could have filled them with different content, so
+	 * they shouldn't be used to fulfill reads once verity is enabled.
+	 *
+	 * But, dropping the pagecache has a big performance impact, and it
+	 * doesn't fully solve the race condition anyway.  So for those reasons,
+	 * and also because this race condition isn't very important relatively
+	 * speaking (especially for small-ish files, where the chance of a page
+	 * being used, evicted, *and* re-instantiated all while enabling verity
+	 * is quite small), we no longer drop the inode's pagecache.
 	 */
-	filemap_write_and_wait(inode->i_mapping);
-	invalidate_inode_pages2(inode->i_mapping);
 
 	/*
 	 * allow_write_access() is needed to pair with deny_write_access().
 	 * Regardless, the filesystem won't allow writing to verity files.
 	 */
-out_allow_write_access:
 	allow_write_access(filp);
 out_drop_write:
 	mnt_drop_write_file(filp);
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 3e8f2de44667..a7e24f949e3d 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -259,15 +259,15 @@ EXPORT_SYMBOL_GPL(fsverity_enqueue_verify_work);
 int __init fsverity_init_workqueue(void)
 {
 	/*
-	 * Use an unbound workqueue to allow bios to be verified in parallel
-	 * even when they happen to complete on the same CPU.  This sacrifices
-	 * locality, but it's worthwhile since hashing is CPU-intensive.
+	 * Use a high-priority workqueue to prioritize verification work, which
+	 * blocks reads from completing, over regular application tasks.
 	 *
-	 * Also use a high-priority workqueue to prioritize verification work,
-	 * which blocks reads from completing, over regular application tasks.
+	 * For performance reasons, don't use an unbound workqueue.  Using an
+	 * unbound workqueue for crypto operations causes excessive scheduler
+	 * latency on ARM64.
 	 */
 	fsverity_read_workqueue = alloc_workqueue("fsverity_read_queue",
-						  WQ_UNBOUND | WQ_HIGHPRI,
+						  WQ_HIGHPRI,
 						  num_online_cpus());
 	if (!fsverity_read_workqueue)
 		return -ENOMEM;
diff --git a/include/linux/dma-noncoherent.h b/include/linux/dma-noncoherent.h
index dd3de6d88fc0..47d483063662 100644
--- a/include/linux/dma-noncoherent.h
+++ b/include/linux/dma-noncoherent.h
@@ -75,29 +75,29 @@ static inline void arch_dma_cache_sync(struct device *dev, void *vaddr,
 #endif /* CONFIG_DMA_NONCOHERENT_CACHE_SYNC */
 
 #ifdef CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE
-void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir);
+void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir);
 #else
-static inline void arch_sync_dma_for_device(struct device *dev,
-		phys_addr_t paddr, size_t size, enum dma_data_direction dir)
+static inline void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 }
 #endif /* ARCH_HAS_SYNC_DMA_FOR_DEVICE */
 
 #ifdef CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU
-void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
-		size_t size, enum dma_data_direction dir);
+void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir);
 #else
-static inline void arch_sync_dma_for_cpu(struct device *dev,
-		phys_addr_t paddr, size_t size, enum dma_data_direction dir)
+static inline void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir)
 {
 }
 #endif /* ARCH_HAS_SYNC_DMA_FOR_CPU */
 
 #ifdef CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL
-void arch_sync_dma_for_cpu_all(struct device *dev);
+void arch_sync_dma_for_cpu_all(void);
 #else
-static inline void arch_sync_dma_for_cpu_all(struct device *dev)
+static inline void arch_sync_dma_for_cpu_all(void)
 {
 }
 #endif /* CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 14183cbf0f0d..125542f305fa 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1986,7 +1986,7 @@ struct net_device {
 	struct netdev_queue	*_tx ____cacheline_aligned_in_smp;
 	unsigned int		num_tx_queues;
 	unsigned int		real_num_tx_queues;
-	struct Qdisc		*qdisc;
+	struct Qdisc __rcu	*qdisc;
 #ifdef CONFIG_NET_SCHED
 	DECLARE_HASHTABLE	(qdisc_hash, 4);
 #endif
diff --git a/include/linux/nvme-tcp.h b/include/linux/nvme-tcp.h
index 959e0bd9a913..73364ae91689 100644
--- a/include/linux/nvme-tcp.h
+++ b/include/linux/nvme-tcp.h
@@ -114,8 +114,9 @@ struct nvme_tcp_icresp_pdu {
 struct nvme_tcp_term_pdu {
 	struct nvme_tcp_hdr	hdr;
 	__le16			fes;
-	__le32			fei;
-	__u8			rsvd[8];
+	__le16			feil;
+	__le16			feiu;
+	__u8			rsvd[10];
 };
 
 /**
diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
index d71380f6ed0b..ffc0d3902b71 100644
--- a/include/xen/swiotlb-xen.h
+++ b/include/xen/swiotlb-xen.h
@@ -4,10 +4,10 @@
 
 #include <linux/swiotlb.h>
 
-void xen_dma_sync_for_cpu(struct device *dev, dma_addr_t handle,
-		phys_addr_t paddr, size_t size, enum dma_data_direction dir);
-void xen_dma_sync_for_device(struct device *dev, dma_addr_t handle,
-		phys_addr_t paddr, size_t size, enum dma_data_direction dir);
+void xen_dma_sync_for_cpu(dma_addr_t handle, phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir);
+void xen_dma_sync_for_device(dma_addr_t handle, phys_addr_t paddr, size_t size,
+		enum dma_data_direction dir);
 
 extern int xen_swiotlb_init(int verbose, bool early);
 extern const struct dma_map_ops xen_swiotlb_dma_ops;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 11f24421ad3a..dde21d23f220 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -764,7 +764,7 @@ static int __init bpf_jit_charge_init(void)
 {
 	/* Only used as heuristic here to derive limit. */
 	bpf_jit_limit_max = bpf_jit_alloc_exec_limit();
-	bpf_jit_limit = min_t(u64, round_up(bpf_jit_limit_max >> 2,
+	bpf_jit_limit = min_t(u64, round_up(bpf_jit_limit_max >> 1,
 					    PAGE_SIZE), LONG_MAX);
 	return 0;
 }
diff --git a/kernel/compat.c b/kernel/compat.c
index a2bc1d6ceb57..241516f326c0 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -240,7 +240,7 @@ COMPAT_SYSCALL_DEFINE3(sched_getaffinity, compat_pid_t,  pid, unsigned int, len,
 	if (len & (sizeof(compat_ulong_t)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index f04cfc2e9e01..4c21cdc15d1b 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -232,7 +232,7 @@ void dma_direct_sync_single_for_device(struct device *dev,
 		swiotlb_tbl_sync_single(dev, paddr, size, dir, SYNC_FOR_DEVICE);
 
 	if (!dev_is_dma_coherent(dev))
-		arch_sync_dma_for_device(dev, paddr, size, dir);
+		arch_sync_dma_for_device(paddr, size, dir);
 }
 EXPORT_SYMBOL(dma_direct_sync_single_for_device);
 
@@ -250,7 +250,7 @@ void dma_direct_sync_sg_for_device(struct device *dev,
 					dir, SYNC_FOR_DEVICE);
 
 		if (!dev_is_dma_coherent(dev))
-			arch_sync_dma_for_device(dev, paddr, sg->length,
+			arch_sync_dma_for_device(paddr, sg->length,
 					dir);
 	}
 }
@@ -266,8 +266,8 @@ void dma_direct_sync_single_for_cpu(struct device *dev,
 	phys_addr_t paddr = dma_to_phys(dev, addr);
 
 	if (!dev_is_dma_coherent(dev)) {
-		arch_sync_dma_for_cpu(dev, paddr, size, dir);
-		arch_sync_dma_for_cpu_all(dev);
+		arch_sync_dma_for_cpu(paddr, size, dir);
+		arch_sync_dma_for_cpu_all();
 	}
 
 	if (unlikely(is_swiotlb_buffer(paddr)))
@@ -285,7 +285,7 @@ void dma_direct_sync_sg_for_cpu(struct device *dev,
 		phys_addr_t paddr = dma_to_phys(dev, sg_dma_address(sg));
 
 		if (!dev_is_dma_coherent(dev))
-			arch_sync_dma_for_cpu(dev, paddr, sg->length, dir);
+			arch_sync_dma_for_cpu(paddr, sg->length, dir);
 
 		if (unlikely(is_swiotlb_buffer(paddr)))
 			swiotlb_tbl_sync_single(dev, paddr, sg->length, dir,
@@ -293,7 +293,7 @@ void dma_direct_sync_sg_for_cpu(struct device *dev,
 	}
 
 	if (!dev_is_dma_coherent(dev))
-		arch_sync_dma_for_cpu_all(dev);
+		arch_sync_dma_for_cpu_all();
 }
 EXPORT_SYMBOL(dma_direct_sync_sg_for_cpu);
 
@@ -345,7 +345,7 @@ dma_addr_t dma_direct_map_page(struct device *dev, struct page *page,
 	}
 
 	if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
-		arch_sync_dma_for_device(dev, phys, size, dir);
+		arch_sync_dma_for_device(phys, size, dir);
 	return dma_addr;
 }
 EXPORT_SYMBOL(dma_direct_map_page);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8ab239fd1c8d..51ac62637e4e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1411,6 +1411,9 @@ static inline void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 
 void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
+	if (task_on_rq_migrating(p))
+		flags |= ENQUEUE_MIGRATED;
+
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
@@ -5658,14 +5661,14 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
 		unsigned int retlen = min(len, cpumask_size());
 
-		if (copy_to_user(user_mask_ptr, mask, retlen))
+		if (copy_to_user(user_mask_ptr, cpumask_bits(mask), retlen))
 			ret = -EFAULT;
 		else
 			ret = retlen;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d2a68ae7596e..9fcba0d2ab19 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3877,6 +3877,29 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 #endif
 }
 
+static inline bool entity_is_long_sleeper(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq;
+	u64 sleep_time;
+
+	if (se->exec_start == 0)
+		return false;
+
+	cfs_rq = cfs_rq_of(se);
+
+	sleep_time = rq_clock_task(rq_of(cfs_rq));
+
+	/* Happen while migrating because of clock task divergence */
+	if (sleep_time <= se->exec_start)
+		return false;
+
+	sleep_time -= se->exec_start;
+	if (sleep_time > ((1ULL << 63) / scale_load_down(NICE_0_LOAD)))
+		return true;
+
+	return false;
+}
+
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
@@ -3905,8 +3928,29 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		vruntime -= thresh;
 	}
 
-	/* ensure we never gain time by being placed backwards. */
-	se->vruntime = max_vruntime(se->vruntime, vruntime);
+	/*
+	 * Pull vruntime of the entity being placed to the base level of
+	 * cfs_rq, to prevent boosting it if placed backwards.
+	 * However, min_vruntime can advance much faster than real time, with
+	 * the extreme being when an entity with the minimal weight always runs
+	 * on the cfs_rq. If the waking entity slept for a long time, its
+	 * vruntime difference from min_vruntime may overflow s64 and their
+	 * comparison may get inversed, so ignore the entity's original
+	 * vruntime in that case.
+	 * The maximal vruntime speedup is given by the ratio of normal to
+	 * minimal weight: scale_load_down(NICE_0_LOAD) / MIN_SHARES.
+	 * When placing a migrated waking entity, its exec_start has been set
+	 * from a different rq. In order to take into account a possible
+	 * divergence between new and prev rq's clocks task because of irq and
+	 * stolen time, we take an additional margin.
+	 * So, cutting off on the sleep time of
+	 *     2^63 / scale_load_down(NICE_0_LOAD) ~ 104 days
+	 * should be safe.
+	 */
+	if (entity_is_long_sleeper(se))
+		se->vruntime = vruntime;
+	else
+		se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
@@ -4002,6 +4046,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	if (flags & ENQUEUE_WAKEUP)
 		place_entity(cfs_rq, se, 0);
+	/* Entity has migrated, no longer consider this task hot */
+	if (flags & ENQUEUE_MIGRATED)
+		se->exec_start = 0;
 
 	check_schedstat_required();
 	update_stats_enqueue(cfs_rq, se, flags);
@@ -6627,9 +6674,6 @@ static void migrate_task_rq_fair(struct task_struct *p, int new_cpu)
 	/* Tell new CPU we are migrated */
 	p->se.avg.last_update_time = 0;
 
-	/* We have migrated, no longer consider this task hot */
-	p->se.exec_start = 0;
-
 	update_scan_period(p, new_cpu);
 }
 
diff --git a/net/can/bcm.c b/net/can/bcm.c
index fbf1143a56e1..23c7d5f896bd 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -938,6 +938,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 
 			cf = op->frames + op->cfsiz * i;
 			err = memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
+			if (err < 0)
+				goto free_op;
 
 			if (op->flags & CAN_FD_FRAME) {
 				if (cf->len > 64)
@@ -947,12 +949,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 					err = -EINVAL;
 			}
 
-			if (err < 0) {
-				if (op->frames != &op->sframe)
-					kfree(op->frames);
-				kfree(op);
-				return err;
-			}
+			if (err < 0)
+				goto free_op;
 
 			if (msg_head->flags & TX_CP_CAN_ID) {
 				/* copy can_id into frame */
@@ -1023,6 +1021,12 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		bcm_tx_start_timer(op);
 
 	return msg_head->nframes * op->cfsiz + MHSIZ;
+
+free_op:
+	if (op->frames != &op->sframe)
+		kfree(op->frames);
+	kfree(op);
+	return err;
 }
 
 /*
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index dbc9b2f53649..da1ef00fc9cc 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1593,6 +1593,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
+	struct Qdisc *qdisc;
 
 	ASSERT_RTNL();
 	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*ifm), flags);
@@ -1610,6 +1611,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (tgt_netnsid >= 0 && nla_put_s32(skb, IFLA_TARGET_NETNSID, tgt_netnsid))
 		goto nla_put_failure;
 
+	qdisc = rtnl_dereference(dev->qdisc);
 	if (nla_put_string(skb, IFLA_IFNAME, dev->name) ||
 	    nla_put_u32(skb, IFLA_TXQLEN, dev->tx_queue_len) ||
 	    nla_put_u8(skb, IFLA_OPERSTATE,
@@ -1628,8 +1630,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 #endif
 	    put_master_ifindex(skb, dev) ||
 	    nla_put_u8(skb, IFLA_CARRIER, netif_carrier_ok(dev)) ||
-	    (dev->qdisc &&
-	     nla_put_string(skb, IFLA_QDISC, dev->qdisc->ops->id)) ||
+	    (qdisc &&
+	     nla_put_string(skb, IFLA_QDISC, qdisc->ops->id)) ||
 	    nla_put_ifalias(skb, dev) ||
 	    nla_put_u32(skb, IFLA_CARRIER_CHANGES,
 			atomic_read(&dev->carrier_up_count) +
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 52dbffb7bc2f..317fdb9f47e8 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -525,7 +525,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -534,7 +534,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index fd4da1019e44..85ec466b5735 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -942,7 +942,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -951,7 +951,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index ace44ff96635..d6e58506136b 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -141,12 +141,14 @@ u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 u16 __ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta, struct sk_buff *skb)
 {
+	const struct ethhdr *eth = (void *)skb->data;
 	struct mac80211_qos_map *qos_map;
 	bool qos;
 
 	/* all mesh/ocb stations are required to support WME */
-	if (sta && (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-		    sdata->vif.type == NL80211_IFTYPE_OCB))
+	if ((sdata->vif.type == NL80211_IFTYPE_MESH_POINT &&
+	    !is_multicast_ether_addr(eth->h_dest)) ||
+	    (sdata->vif.type == NL80211_IFTYPE_OCB && sta))
 		qos = true;
 	else if (sta)
 		qos = sta->sta.wme;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 48a8c7daa635..77a1988d5ddc 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1079,7 +1079,7 @@ static int __tcf_qdisc_find(struct net *net, struct Qdisc **q,
 
 	/* Find qdisc */
 	if (!*parent) {
-		*q = dev->qdisc;
+		*q = rcu_dereference(dev->qdisc);
 		*parent = (*q)->handle;
 	} else {
 		*q = qdisc_lookup_rcu(dev, TC_H_MAJ(*parent));
@@ -2552,7 +2552,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 
 		parent = tcm->tcm_parent;
 		if (!parent)
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		else
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
 		if (!q)
@@ -2938,7 +2938,7 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
 
 		parent = tcm->tcm_parent;
 		if (!parent) {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 			parent = q->handle;
 		} else {
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 154d62d8ac16..67d6bc97e5fe 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -298,7 +298,7 @@ struct Qdisc *qdisc_lookup(struct net_device *dev, u32 handle)
 
 	if (!handle)
 		return NULL;
-	q = qdisc_match_from_root(dev->qdisc, handle);
+	q = qdisc_match_from_root(rtnl_dereference(dev->qdisc), handle);
 	if (q)
 		goto out;
 
@@ -317,7 +317,7 @@ struct Qdisc *qdisc_lookup_rcu(struct net_device *dev, u32 handle)
 
 	if (!handle)
 		return NULL;
-	q = qdisc_match_from_root(dev->qdisc, handle);
+	q = qdisc_match_from_root(rcu_dereference(dev->qdisc), handle);
 	if (q)
 		goto out;
 
@@ -1071,11 +1071,12 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 skip:
 		if (!ingress) {
-			notify_and_destroy(net, skb, n, classid,
-					   dev->qdisc, new);
+			old = rtnl_dereference(dev->qdisc);
 			if (new && !new->ops->attach)
 				qdisc_refcount_inc(new);
-			dev->qdisc = new ? : &noop_qdisc;
+			rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
+
+			notify_and_destroy(net, skb, n, classid, old, new);
 
 			if (new && new->ops->attach)
 				new->ops->attach(new);
@@ -1455,7 +1456,7 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
 		} else {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		}
 		if (!q) {
 			NL_SET_ERR_MSG(extack, "Cannot find specified qdisc on specified device");
@@ -1544,7 +1545,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 				q = dev_ingress_queue(dev)->qdisc_sleeping;
 			}
 		} else {
-			q = dev->qdisc;
+			q = rtnl_dereference(dev->qdisc);
 		}
 
 		/* It may be default qdisc, ignore it */
@@ -1766,7 +1767,8 @@ static int tc_dump_qdisc(struct sk_buff *skb, struct netlink_callback *cb)
 			s_q_idx = 0;
 		q_idx = 0;
 
-		if (tc_dump_qdisc_root(dev->qdisc, skb, cb, &q_idx, s_q_idx,
+		if (tc_dump_qdisc_root(rtnl_dereference(dev->qdisc),
+				       skb, cb, &q_idx, s_q_idx,
 				       true, tca[TCA_DUMP_INVISIBLE]) < 0)
 			goto done;
 
@@ -2042,7 +2044,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 		} else if (qid1) {
 			qid = qid1;
 		} else if (qid == 0)
-			qid = dev->qdisc->handle;
+			qid = rtnl_dereference(dev->qdisc)->handle;
 
 		/* Now qid is genuine qdisc handle consistent
 		 * both with parent and child.
@@ -2053,7 +2055,7 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n,
 			portid = TC_H_MAKE(qid, portid);
 	} else {
 		if (qid == 0)
-			qid = dev->qdisc->handle;
+			qid = rtnl_dereference(dev->qdisc)->handle;
 	}
 
 	/* OK. Locate qdisc */
@@ -2214,7 +2216,8 @@ static int tc_dump_tclass(struct sk_buff *skb, struct netlink_callback *cb)
 	s_t = cb->args[0];
 	t = 0;
 
-	if (tc_dump_tclass_root(dev->qdisc, skb, tcm, cb, &t, s_t, true) < 0)
+	if (tc_dump_tclass_root(rtnl_dereference(dev->qdisc),
+				skb, tcm, cb, &t, s_t, true) < 0)
 		goto done;
 
 	dev_queue = dev_ingress_queue(dev);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 81fcf6c5bde9..1f055c21be4c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1106,18 +1106,20 @@ static void attach_default_qdiscs(struct net_device *dev)
 	if (!netif_is_multiqueue(dev) ||
 	    dev->priv_flags & IFF_NO_QUEUE) {
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
-		dev->qdisc = txq->qdisc_sleeping;
-		qdisc_refcount_inc(dev->qdisc);
+		qdisc = txq->qdisc_sleeping;
+		rcu_assign_pointer(dev->qdisc, qdisc);
+		qdisc_refcount_inc(qdisc);
 	} else {
 		qdisc = qdisc_create_dflt(txq, &mq_qdisc_ops, TC_H_ROOT, NULL);
 		if (qdisc) {
-			dev->qdisc = qdisc;
+			rcu_assign_pointer(dev->qdisc, qdisc);
 			qdisc->ops->attach(qdisc);
 		}
 	}
+
 #ifdef CONFIG_NET_SCHED
-	if (dev->qdisc != &noop_qdisc)
-		qdisc_hash_add(dev->qdisc, false);
+	if (qdisc != &noop_qdisc)
+		qdisc_hash_add(qdisc, false);
 #endif
 }
 
@@ -1147,7 +1149,7 @@ void dev_activate(struct net_device *dev)
 	 * and noqueue_qdisc for virtual interfaces
 	 */
 
-	if (dev->qdisc == &noop_qdisc)
+	if (rtnl_dereference(dev->qdisc) == &noop_qdisc)
 		attach_default_qdiscs(dev);
 
 	if (!netif_carrier_ok(dev))
@@ -1316,7 +1318,7 @@ static int qdisc_change_tx_queue_len(struct net_device *dev,
 void dev_qdisc_change_real_num_tx(struct net_device *dev,
 				  unsigned int new_real_tx)
 {
-	struct Qdisc *qdisc = dev->qdisc;
+	struct Qdisc *qdisc = rtnl_dereference(dev->qdisc);
 
 	if (qdisc->ops->change_real_num_tx)
 		qdisc->ops->change_real_num_tx(qdisc, new_real_tx);
@@ -1356,7 +1358,7 @@ static void dev_init_scheduler_queue(struct net_device *dev,
 
 void dev_init_scheduler(struct net_device *dev)
 {
-	dev->qdisc = &noop_qdisc;
+	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 	netdev_for_each_tx_queue(dev, dev_init_scheduler_queue, &noop_qdisc);
 	if (dev_ingress_queue(dev))
 		dev_init_scheduler_queue(dev, dev_ingress_queue(dev), &noop_qdisc);
@@ -1384,8 +1386,8 @@ void dev_shutdown(struct net_device *dev)
 	netdev_for_each_tx_queue(dev, shutdown_scheduler_queue, &noop_qdisc);
 	if (dev_ingress_queue(dev))
 		shutdown_scheduler_queue(dev, dev_ingress_queue(dev), &noop_qdisc);
-	qdisc_put(dev->qdisc);
-	dev->qdisc = &noop_qdisc;
+	qdisc_put(rtnl_dereference(dev->qdisc));
+	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 
 	WARN_ON(timer_pending(&dev->watchdog_timer));
 }
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7aba4ee77aba..cb51a2f46b11 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -371,13 +371,11 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
 		       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_128,
 				 sizeof(*crypto_info_aes_gcm_128)))
@@ -395,13 +393,11 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
 		       ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_256,
 				 sizeof(*crypto_info_aes_gcm_256)))
@@ -421,6 +417,8 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 {
 	int rc = 0;
 
+	lock_sock(sk);
+
 	switch (optname) {
 	case TLS_TX:
 		rc = do_tls_getsockopt_tx(sk, optval, optlen);
@@ -429,6 +427,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = -ENOPROTOOPT;
 		break;
 	}
+
+	release_sock(sk);
+
 	return rc;
 }
 
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 957b9e3e1492..17c9c0cfb6f5 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -38,9 +38,12 @@ static void cache_requested_key(struct key *key)
 #ifdef CONFIG_KEYS_REQUEST_CACHE
 	struct task_struct *t = current;
 
-	key_put(t->cached_requested_key);
-	t->cached_requested_key = key_get(key);
-	set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+	/* Do not cache key if it is a kernel thread */
+	if (!(t->flags & PF_KTHREAD)) {
+		key_put(t->cached_requested_key);
+		t->cached_requested_key = key_get(key);
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+	}
 #endif
 }
 
diff --git a/sound/pci/asihpi/hpi6205.c b/sound/pci/asihpi/hpi6205.c
index 3d6914c64c4a..4cdaeefeb688 100644
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -430,7 +430,7 @@ void HPI_6205(struct hpi_message *phm, struct hpi_response *phr)
 		pao = hpi_find_adapter(phm->adapter_index);
 	} else {
 		/* subsys messages don't address an adapter */
-		_HPI_6205(NULL, phm, phr);
+		phr->error = HPI_ERROR_INVALID_OBJ_INDEX;
 		return;
 	}
 
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 574c39120df8..f9582053878d 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -3843,8 +3843,10 @@ static int tuning_ctl_set(struct hda_codec *codec, hda_nid_t nid,
 
 	for (i = 0; i < TUNING_CTLS_COUNT; i++)
 		if (nid == ca0132_tuning_ctls[i].nid)
-			break;
+			goto found;
 
+	return -EINVAL;
+found:
 	snd_hda_power_up(codec);
 	dspio_set_param(codec, ca0132_tuning_ctls[i].mid, 0x20,
 			ca0132_tuning_ctls[i].req,
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 51f65d634a15..767872f7ec64 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -939,7 +939,10 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3905, "Lenovo G50-30", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x390b, "Lenovo G50-80", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
-	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_PINCFG_LENOVO_NOTEBOOK),
+	/* NOTE: we'd need to extend the quirk for 17aa:3977 as the same
+	 * PCI SSID is used on multiple Lenovo models
+	 */
+	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo G50-70", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", CXT_FIXUP_THINKPAD_ACPI),
@@ -961,6 +964,7 @@ static const struct hda_model_fixup cxt5066_fixup_models[] = {
 	{ .id = CXT_FIXUP_HP_DOCK, .name = "hp-dock" },
 	{ .id = CXT_FIXUP_MUTE_LED_GPIO, .name = "mute-led-gpio" },
 	{ .id = CXT_FIXUP_HP_MIC_NO_PRESENCE, .name = "hp-mic-fix" },
+	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
 	{}
 };
 
diff --git a/sound/usb/format.c b/sound/usb/format.c
index 84b66f7c627c..11a4454c6f64 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -40,8 +40,12 @@ static u64 parse_audio_format_i_type(struct snd_usb_audio *chip,
 	case UAC_VERSION_1:
 	default: {
 		struct uac_format_type_i_discrete_descriptor *fmt = _fmt;
-		if (format >= 64)
-			return 0; /* invalid format */
+		if (format >= 64) {
+			usb_audio_info(chip,
+				       "%u:%d: invalid format type 0x%llx is detected, processed as PCM\n",
+				       fp->iface, fp->altsetting, format);
+			format = UAC_FORMAT_TYPE_I_PCM;
+		}
 		sample_width = fmt->bBitResolution;
 		sample_bytes = fmt->bSubframeSize;
 		format = 1ULL << format;
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index 996eca57bc97..f641eb292a88 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -920,6 +920,34 @@ static struct btf_raw_test raw_tests[] = {
 	.btf_load_err = true,
 	.err_str = "Invalid elem",
 },
+{
+	.descr = "var after datasec, ptr followed by modifier",
+	.raw_types = {
+		/* .bss section */				/* [1] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 2),
+			sizeof(void*)+4),
+		BTF_VAR_SECINFO_ENC(4, 0, sizeof(void*)),
+		BTF_VAR_SECINFO_ENC(6, sizeof(void*), 4),
+		/* int */					/* [2] */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),
+		/* int* */					/* [3] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_PTR, 0, 0), 2),
+		BTF_VAR_ENC(NAME_TBD, 3, 0),			/* [4] */
+		/* const int */					/* [5] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_CONST, 0, 0), 2),
+		BTF_VAR_ENC(NAME_TBD, 5, 0),			/* [6] */
+		BTF_END_RAW,
+	},
+	.str_sec = "\0a\0b\0c\0",
+	.str_sec_size = sizeof("\0a\0b\0c\0"),
+	.map_type = BPF_MAP_TYPE_ARRAY,
+	.map_name = ".bss",
+	.key_size = sizeof(int),
+	.value_size = sizeof(void*)+4,
+	.key_type_id = 0,
+	.value_type_id = 1,
+	.max_entries = 1,
+},
 /* Test member exceeds the size of struct.
  *
  * struct A {
