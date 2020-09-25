Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F2E278E25
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbgIYQT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729546AbgIYQT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:19:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5CCC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x10so3053168ybj.19
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=+OXochZesudckftf8bTVzttvyRNJip0ves12q+6MEKE=;
        b=uCUG8bHmY2dN1WLG1xvj6FrIp4emhsdf2ChOxyxnc/4EmIM+bM8uEcJzuCFUGPpccT
         +d8dXNzwWcXzIu25J0ahG3Boq+Zq/3HYHBzuoazV+UsjJv29mogeFsHIJVgqCFuIIwyZ
         LQvo5NkLh9d4orhZ0Gd700Y8UuN2KwhJyrFsxxLVdWh0v8WwVA94LmmgygTFTSotLLi7
         pEhGMORSpl3GYZBzkxQt57prSSVXNMounqPmCBOYtbKpC5ED7TlVvwOalSkKudq8lAbG
         QMWERm2561qsFdC7NeUSVc3ldQULOCPMgUE6Dgp8LEj7qijuIVENt1v/V+YgzQ8IjTee
         JRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+OXochZesudckftf8bTVzttvyRNJip0ves12q+6MEKE=;
        b=gtrZhnKOH15V0C6uIzTmBFraHRQ3IB5QIxwA//Jw7SzKO5E/9Om4cX6zGRrjL+58qQ
         3e87N+2AChbHxXuWCJrCtZPtml9yvIxdGKJ/0qTCaMXxKE9WUjd8AekYhQ+BD03TG34J
         Xm/d1hIvKRxJQtCXfTDzmjEN96H1aZVyU7cz0qqyUnDbHYxuTQ4nI4PsCQSY5CxsQ11c
         tva7twMXgIvwd/Ny2K0IDb8/Qt7L1Y6GY7SEM+dHKuui9bRq9UdAFX5nadKm5D1N1fVS
         JJdiGTlXepvhhEjfk9A2EaToVUCRmHD30ARqPkadDxY30QNe8cCWifSQ7RV9307qxyvc
         NmKg==
X-Gm-Message-State: AOAM533/+b/TyWrUF60MycqXtXP8Pcc5UEedZLrscoqLTfezB+4wzWl5
        ogkwkc3i7GpaKtJgy/WAcdSCqopdde2qb5kxIB8KWpXYf0PmS+iKpfpq7JwXgaJylPUovz/MVaO
        0fkUt/MNvuD70PxkQ5xyEPfW1MfsEkJzC95mPhiLKPlRHCZsCcKiXRhwyUT0xsA==
X-Google-Smtp-Source: ABdhPJxtNEVb3zFdOj0DcWP7J07EBn1FAGpUVaFi70IV7yb5c8QnO3WZDe71NIJ3OQxniFDvlI89A3KbgqI=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a25:bb01:: with SMTP id z1mr6751491ybg.387.1601050795253;
 Fri, 25 Sep 2020 09:19:55 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:49 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-4-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 03/30 for 5.4] dma-direct: provide mmap and get_sgtable method overrides
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

upstream 34dc0ea6bc960f1f57b2148f01a3f4da23f87013 commit.

For dma-direct we know that the DMA address is an encoding of the
physical address that we can trivially decode.  Use that fact to
provide implementations that do not need the arch_dma_coherent_to_pfn
architecture hook.  Note that we still can only support mmap of
non-coherent memory only if the architecture provides a way to set an
uncached bit in the page tables.  This must be true for architectures
that use the generic remap helpers, but other architectures can also
manually select it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 arch/arc/Kconfig                       |  1 -
 arch/arm/Kconfig                       |  1 -
 arch/arm/mm/dma-mapping.c              |  6 ---
 arch/arm64/Kconfig                     |  1 -
 arch/ia64/Kconfig                      |  2 +-
 arch/ia64/kernel/dma-mapping.c         |  6 ---
 arch/microblaze/Kconfig                |  1 -
 arch/mips/Kconfig                      |  4 +-
 arch/mips/mm/dma-noncoherent.c         |  6 ---
 arch/powerpc/platforms/Kconfig.cputype |  1 -
 include/linux/dma-direct.h             |  7 +++
 include/linux/dma-noncoherent.h        |  2 -
 kernel/dma/Kconfig                     | 12 ++++--
 kernel/dma/direct.c                    | 59 ++++++++++++++++++++++++++
 kernel/dma/mapping.c                   | 45 +++-----------------
 kernel/dma/remap.c                     |  6 ---
 16 files changed, 85 insertions(+), 75 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 8383155c8c82..4d7b671c8ff4 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -6,7 +6,6 @@
 config ARC
 	def_bool y
 	select ARC_TIMERS
-	select ARCH_HAS_DMA_COHERENT_TO_PFN
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SETUP_DMA_OPS
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 05c9bbfe444d..fac9999d6ef5 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -7,7 +7,6 @@ config ARM
 	select ARCH_HAS_BINFMT_FLAT
 	select ARCH_HAS_DEBUG_VIRTUAL if MMU
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
-	select ARCH_HAS_DMA_COHERENT_TO_PFN if SWIOTLB
 	select ARCH_HAS_DMA_WRITE_COMBINE if !ARM_DMA_MEM_BUFFERABLE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FORTIFY_SOURCE
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 27576c7b836e..58d5765fb129 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -2346,12 +2346,6 @@ void arch_sync_dma_for_cpu(struct device *dev, phys_addr_t paddr,
 			      size, dir);
 }
 
-long arch_dma_coherent_to_pfn(struct device *dev, void *cpu_addr,
-		dma_addr_t dma_addr)
-{
-	return dma_to_pfn(dev, dma_addr);
-}
-
 void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs)
 {
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a0bc9bbb92f3..bc45a704987f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -12,7 +12,6 @@ config ARM64
 	select ARCH_CLOCKSOURCE_DATA
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
-	select ARCH_HAS_DMA_COHERENT_TO_PFN
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_ACPI_TABLE_UPGRADE if ACPI
 	select ARCH_HAS_FAST_MULTIPLIER
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 16714477eef4..bab7cd878464 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -33,7 +33,7 @@ config IA64
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select ARCH_HAS_DMA_COHERENT_TO_PFN
+	select DMA_NONCOHERENT_MMAP
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
diff --git a/arch/ia64/kernel/dma-mapping.c b/arch/ia64/kernel/dma-mapping.c
index 4a3262795890..09ef9ce9988d 100644
--- a/arch/ia64/kernel/dma-mapping.c
+++ b/arch/ia64/kernel/dma-mapping.c
@@ -19,9 +19,3 @@ void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
 {
 	dma_direct_free_pages(dev, size, cpu_addr, dma_addr, attrs);
 }
-
-long arch_dma_coherent_to_pfn(struct device *dev, void *cpu_addr,
-		dma_addr_t dma_addr)
-{
-	return page_to_pfn(virt_to_page(cpu_addr));
-}
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index c9c4be822456..261c26df1c9f 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -4,7 +4,6 @@ config MICROBLAZE
 	select ARCH_32BIT_OFF_T
 	select ARCH_NO_SWAP
 	select ARCH_HAS_BINFMT_FLAT if !MMU
-	select ARCH_HAS_DMA_COHERENT_TO_PFN if MMU
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index e5c2d47608fe..c1c3da4fc667 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1134,9 +1134,9 @@ config DMA_NONCOHERENT
 	select ARCH_HAS_DMA_WRITE_COMBINE
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_HAS_UNCACHED_SEGMENT
-	select NEED_DMA_MAP_STATE
-	select ARCH_HAS_DMA_COHERENT_TO_PFN
+	select DMA_NONCOHERENT_MMAP
 	select DMA_NONCOHERENT_CACHE_SYNC
+	select NEED_DMA_MAP_STATE
 
 config SYS_HAS_EARLY_PRINTK
 	bool
diff --git a/arch/mips/mm/dma-noncoherent.c b/arch/mips/mm/dma-noncoherent.c
index 1d4d57dd9acf..fcf6d3eaac66 100644
--- a/arch/mips/mm/dma-noncoherent.c
+++ b/arch/mips/mm/dma-noncoherent.c
@@ -59,12 +59,6 @@ void *cached_kernel_address(void *addr)
 	return __va(addr) - UNCAC_BASE;
 }
 
-long arch_dma_coherent_to_pfn(struct device *dev, void *cpu_addr,
-		dma_addr_t dma_addr)
-{
-	return page_to_pfn(virt_to_page(cached_kernel_address(cpu_addr)));
-}
-
 static inline void dma_sync_virt(void *addr, size_t size,
 		enum dma_data_direction dir)
 {
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index f0330ce498d1..97af19141aed 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -459,7 +459,6 @@ config NOT_COHERENT_CACHE
 	bool
 	depends on 4xx || PPC_8xx || E200 || PPC_MPC512x || \
 		GAMECUBE_COMMON || AMIGAONE
-	select ARCH_HAS_DMA_COHERENT_TO_PFN
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index 3238177e65ad..6db863c3eb93 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -76,5 +76,12 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs);
 struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 		gfp_t gfp, unsigned long attrs);
+int dma_direct_get_sgtable(struct device *dev, struct sg_table *sgt,
+		void *cpu_addr, dma_addr_t dma_addr, size_t size,
+		unsigned long attrs);
+bool dma_direct_can_mmap(struct device *dev);
+int dma_direct_mmap(struct device *dev, struct vm_area_struct *vma,
+		void *cpu_addr, dma_addr_t dma_addr, size_t size,
+		unsigned long attrs);
 int dma_direct_supported(struct device *dev, u64 mask);
 #endif /* _LINUX_DMA_DIRECT_H */
diff --git a/include/linux/dma-noncoherent.h b/include/linux/dma-noncoherent.h
index dd3de6d88fc0..e30fca1f1b12 100644
--- a/include/linux/dma-noncoherent.h
+++ b/include/linux/dma-noncoherent.h
@@ -41,8 +41,6 @@ void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_addr, unsigned long attrs);
-long arch_dma_coherent_to_pfn(struct device *dev, void *cpu_addr,
-		dma_addr_t dma_addr);
 
 #ifdef CONFIG_MMU
 /*
diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index 73c5c2b8e824..4c103a24e380 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -51,9 +51,6 @@ config ARCH_HAS_SYNC_DMA_FOR_CPU_ALL
 config ARCH_HAS_DMA_PREP_COHERENT
 	bool
 
-config ARCH_HAS_DMA_COHERENT_TO_PFN
-	bool
-
 config ARCH_HAS_FORCE_DMA_UNENCRYPTED
 	bool
 
@@ -68,9 +65,18 @@ config SWIOTLB
 	bool
 	select NEED_DMA_MAP_STATE
 
+#
+# Should be selected if we can mmap non-coherent mappings to userspace.
+# The only thing that is really required is a way to set an uncached bit
+# in the pagetables
+#
+config DMA_NONCOHERENT_MMAP
+	bool
+
 config DMA_REMAP
 	depends on MMU
 	select GENERIC_ALLOCATOR
+	select DMA_NONCOHERENT_MMAP
 	bool
 
 config DMA_DIRECT_REMAP
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 9621993bf2bb..76c722bc9e0c 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -43,6 +43,12 @@ static inline dma_addr_t phys_to_dma_direct(struct device *dev,
 	return phys_to_dma(dev, phys);
 }
 
+static inline struct page *dma_direct_to_page(struct device *dev,
+		dma_addr_t dma_addr)
+{
+	return pfn_to_page(PHYS_PFN(dma_to_phys(dev, dma_addr)));
+}
+
 u64 dma_direct_get_required_mask(struct device *dev)
 {
 	phys_addr_t phys = (phys_addr_t)(max_pfn - 1) << PAGE_SHIFT;
@@ -380,6 +386,59 @@ dma_addr_t dma_direct_map_resource(struct device *dev, phys_addr_t paddr,
 }
 EXPORT_SYMBOL(dma_direct_map_resource);
 
+int dma_direct_get_sgtable(struct device *dev, struct sg_table *sgt,
+		void *cpu_addr, dma_addr_t dma_addr, size_t size,
+		unsigned long attrs)
+{
+	struct page *page = dma_direct_to_page(dev, dma_addr);
+	int ret;
+
+	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
+	if (!ret)
+		sg_set_page(sgt->sgl, page, PAGE_ALIGN(size), 0);
+	return ret;
+}
+
+#ifdef CONFIG_MMU
+bool dma_direct_can_mmap(struct device *dev)
+{
+	return dev_is_dma_coherent(dev) ||
+		IS_ENABLED(CONFIG_DMA_NONCOHERENT_MMAP);
+}
+
+int dma_direct_mmap(struct device *dev, struct vm_area_struct *vma,
+		void *cpu_addr, dma_addr_t dma_addr, size_t size,
+		unsigned long attrs)
+{
+	unsigned long user_count = vma_pages(vma);
+	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	unsigned long pfn = PHYS_PFN(dma_to_phys(dev, dma_addr));
+	int ret = -ENXIO;
+
+	vma->vm_page_prot = dma_pgprot(dev, vma->vm_page_prot, attrs);
+
+	if (dma_mmap_from_dev_coherent(dev, vma, cpu_addr, size, &ret))
+		return ret;
+
+	if (vma->vm_pgoff >= count || user_count > count - vma->vm_pgoff)
+		return -ENXIO;
+	return remap_pfn_range(vma, vma->vm_start, pfn + vma->vm_pgoff,
+			user_count << PAGE_SHIFT, vma->vm_page_prot);
+}
+#else /* CONFIG_MMU */
+bool dma_direct_can_mmap(struct device *dev)
+{
+	return false;
+}
+
+int dma_direct_mmap(struct device *dev, struct vm_area_struct *vma,
+		void *cpu_addr, dma_addr_t dma_addr, size_t size,
+		unsigned long attrs)
+{
+	return -ENXIO;
+}
+#endif /* CONFIG_MMU */
+
 /*
  * Because 32-bit DMA masks are so common we expect every architecture to be
  * able to satisfy them - either by not supporting more physical memory, or by
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 8682a5305cb3..98e3d873792e 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -112,24 +112,9 @@ int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		 unsigned long attrs)
 {
-	struct page *page;
+	struct page *page = virt_to_page(cpu_addr);
 	int ret;
 
-	if (!dev_is_dma_coherent(dev)) {
-		unsigned long pfn;
-
-		if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_COHERENT_TO_PFN))
-			return -ENXIO;
-
-		/* If the PFN is not valid, we do not have a struct page */
-		pfn = arch_dma_coherent_to_pfn(dev, cpu_addr, dma_addr);
-		if (!pfn_valid(pfn))
-			return -ENXIO;
-		page = pfn_to_page(pfn);
-	} else {
-		page = virt_to_page(cpu_addr);
-	}
-
 	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
 	if (!ret)
 		sg_set_page(sgt->sgl, page, PAGE_ALIGN(size), 0);
@@ -154,7 +139,7 @@ int dma_get_sgtable_attrs(struct device *dev, struct sg_table *sgt,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	if (dma_is_direct(ops))
-		return dma_common_get_sgtable(dev, sgt, cpu_addr, dma_addr,
+		return dma_direct_get_sgtable(dev, sgt, cpu_addr, dma_addr,
 				size, attrs);
 	if (!ops->get_sgtable)
 		return -ENXIO;
@@ -194,7 +179,6 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 	unsigned long user_count = vma_pages(vma);
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	unsigned long off = vma->vm_pgoff;
-	unsigned long pfn;
 	int ret = -ENXIO;
 
 	vma->vm_page_prot = dma_pgprot(dev, vma->vm_page_prot, attrs);
@@ -205,19 +189,8 @@ int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 	if (off >= count || user_count > count - off)
 		return -ENXIO;
 
-	if (!dev_is_dma_coherent(dev)) {
-		if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_COHERENT_TO_PFN))
-			return -ENXIO;
-
-		/* If the PFN is not valid, we do not have a struct page */
-		pfn = arch_dma_coherent_to_pfn(dev, cpu_addr, dma_addr);
-		if (!pfn_valid(pfn))
-			return -ENXIO;
-	} else {
-		pfn = page_to_pfn(virt_to_page(cpu_addr));
-	}
-
-	return remap_pfn_range(vma, vma->vm_start, pfn + vma->vm_pgoff,
+	return remap_pfn_range(vma, vma->vm_start,
+			page_to_pfn(virt_to_page(cpu_addr)) + vma->vm_pgoff,
 			user_count << PAGE_SHIFT, vma->vm_page_prot);
 #else
 	return -ENXIO;
@@ -235,12 +208,8 @@ bool dma_can_mmap(struct device *dev)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
-	if (dma_is_direct(ops)) {
-		return IS_ENABLED(CONFIG_MMU) &&
-		       (dev_is_dma_coherent(dev) ||
-			IS_ENABLED(CONFIG_ARCH_HAS_DMA_COHERENT_TO_PFN));
-	}
-
+	if (dma_is_direct(ops))
+		return dma_direct_can_mmap(dev);
 	return ops->mmap != NULL;
 }
 EXPORT_SYMBOL_GPL(dma_can_mmap);
@@ -265,7 +234,7 @@ int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	if (dma_is_direct(ops))
-		return dma_common_mmap(dev, vma, cpu_addr, dma_addr, size,
+		return dma_direct_mmap(dev, vma, cpu_addr, dma_addr, size,
 				attrs);
 	if (!ops->mmap)
 		return -ENXIO;
diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index 90d5ce77c189..3c49499ee6b0 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -259,10 +259,4 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 		dma_free_contiguous(dev, page, size);
 	}
 }
-
-long arch_dma_coherent_to_pfn(struct device *dev, void *cpu_addr,
-		dma_addr_t dma_addr)
-{
-	return __phys_to_pfn(dma_to_phys(dev, dma_addr));
-}
 #endif /* CONFIG_DMA_DIRECT_REMAP */
-- 
2.28.0.618.gf4bc123cb7-goog

