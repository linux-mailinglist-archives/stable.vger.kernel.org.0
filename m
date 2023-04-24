Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4736D479A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbjDCOVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjDCOVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:21:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA2A31294
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:21:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8D2961D4C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC42C433EF;
        Mon,  3 Apr 2023 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531683;
        bh=tDVjkk7tNSUI4wkZt5x9Vemx4iTnUnmZpx3IprLN3wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJ1+qRvAHF8uYD9gFHg2LQVGJHgBIVuSjzNC2izzY5274eS8c/7BsZxPKotJoYMj7
         vsYrBlSzOowVmAeKgtYefKpPipgKr93GmyN9NOYcERzcU3N5axhCFU31R6LSr1Hk3v
         qin4/Apz4xxaDSJs8FgJ0TUABOycTqYIN3iqmapw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/104] dma-mapping: drop the dev argument to arch_sync_dma_for_*
Date:   Mon,  3 Apr 2023 16:09:04 +0200
Message-Id: <20230403140406.984852975@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 56e35f9c5b87ec1ae93e483284e189c84388de16 ]

These are pure cache maintainance routines, so drop the unused
struct device argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Stable-dep-of: ab327f8acdf8 ("mips: bmips: BCM6358: disable RAC flush for TP1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/mm/dma.c                 |  8 ++++----
 arch/arm/mm/dma-mapping.c         |  8 ++++----
 arch/arm/xen/mm.c                 | 12 ++++++------
 arch/arm64/mm/dma-mapping.c       |  8 ++++----
 arch/c6x/mm/dma-coherent.c        | 14 +++++++-------
 arch/csky/mm/dma-mapping.c        |  8 ++++----
 arch/hexagon/kernel/dma.c         |  4 ++--
 arch/ia64/mm/init.c               |  4 ++--
 arch/m68k/kernel/dma.c            |  4 ++--
 arch/microblaze/kernel/dma.c      | 14 +++++++-------
 arch/mips/bmips/dma.c             |  2 +-
 arch/mips/jazz/jazzdma.c          | 17 ++++++++---------
 arch/mips/mm/dma-noncoherent.c    | 12 ++++++------
 arch/nds32/kernel/dma.c           |  8 ++++----
 arch/nios2/mm/dma-mapping.c       |  8 ++++----
 arch/openrisc/kernel/dma.c        |  2 +-
 arch/parisc/kernel/pci-dma.c      |  8 ++++----
 arch/powerpc/mm/dma-noncoherent.c |  8 ++++----
 arch/sh/kernel/dma-coherent.c     |  6 +++---
 arch/sparc/kernel/ioport.c        |  4 ++--
 arch/xtensa/kernel/pci-dma.c      |  8 ++++----
 drivers/iommu/dma-iommu.c         | 10 +++++-----
 drivers/xen/swiotlb-xen.c         |  8 ++++----
 include/linux/dma-noncoherent.h   | 20 ++++++++++----------
 include/xen/swiotlb-xen.h         |  8 ++++----
 kernel/dma/direct.c               | 14 +++++++-------
 26 files changed, 113 insertions(+), 114 deletions(-)

diff --git a/arch/arc/mm/dma.c b/arch/arc/mm/dma.c
index 73a7e88a1e926..e947572a521ec 100644
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
index 27576c7b836ee..fbfb9250e743a 100644
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
index 38fa917c8585c..a6a2514e5fe8f 100644
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
index 9239416e93d4e..6c45350e33aa5 100644
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
index b319808e8f6bd..a5909091cb142 100644
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
index 06e85b5654542..8f6571ae27c86 100644
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
index f561b127c4b43..25f388d9cfcc3 100644
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
index ee50506d86f42..df6d3dfa9d820 100644
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
index 3fab684cc0db0..871a0e11da341 100644
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
diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index a89c2d4ed5ffc..d7bebd04247b7 100644
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
index 3d13c77c125f4..df56bf4179e34 100644
--- a/arch/mips/bmips/dma.c
+++ b/arch/mips/bmips/dma.c
@@ -64,7 +64,7 @@ phys_addr_t __dma_to_phys(struct device *dev, dma_addr_t dma_addr)
 	return dma_addr;
 }
 
-void arch_sync_dma_for_cpu_all(struct device *dev)
+void arch_sync_dma_for_cpu_all(void)
 {
 	void __iomem *cbr = BMIPS_GET_CBR();
 	u32 cfg;
diff --git a/arch/mips/jazz/jazzdma.c b/arch/mips/jazz/jazzdma.c
index a01e14955187e..c64a297e82b3c 100644
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
index 1d4d57dd9acf8..6cfacb04865fd 100644
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
index 4206d4b6c8cef..69d762182d49b 100644
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
index 9cb238664584c..0ed711e379020 100644
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
index 4d5b8bd1d7956..adec711ad39d5 100644
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
index ca35d9a76e506..a60d47fd4d55f 100644
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
index 2a82984356f81..5ab4f868e919b 100644
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
diff --git a/arch/sh/kernel/dma-coherent.c b/arch/sh/kernel/dma-coherent.c
index b17514619b7e1..eeb25a4fa55f2 100644
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
 
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index b87e0002131dd..9d723c58557b2 100644
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
index 154979d62b73c..2b86a2a042368 100644
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
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 4fc8fb92d45ef..651054aa87103 100644
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
 
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 06346422f7432..486d7978ea970 100644
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
diff --git a/include/linux/dma-noncoherent.h b/include/linux/dma-noncoherent.h
index dd3de6d88fc08..47d4830636627 100644
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
diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
index d71380f6ed0b2..ffc0d3902b717 100644
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
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index f04cfc2e9e01a..4c21cdc15d1b8 100644
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
-- 
2.39.2



