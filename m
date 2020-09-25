Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6CF278E4B
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgIYQUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgIYQUo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF93FC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e190so3102402ybf.18
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=w5IfzMwmfSTccrzN4OS/3MjEGRPmdpKn9ghsuNYWS/0=;
        b=lFSqrKjbI/BO3hvEsGVshNiGQXtTtvEklFe0U5faNm48RVtuHce6xpnCZeSiR6yNUq
         uaA4KLExcj15/6IrdTn13wxWppakg84uIc8tZZqAffCUzAekthFiJ+9/KnwHqjXsbRnA
         idj5UCoUIesxi5OLSYBmjW7VWNdGoWFwiQ3EKBjiyYtw2TMgDXTnQB7+Sw1DlBVkGnH+
         7s3ET9vePn08i7lp2eCVDmYGtkHRP+ctr7PPFX+Z5zyjhu6v7/8XQNE8ao31HXPIEb+q
         ltj7koPGsTk4erk8eVR/g7RJ+5URhe9k6V0Tocp0clzboEASvJtvBR40W3KRJt0xI3h/
         OVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=w5IfzMwmfSTccrzN4OS/3MjEGRPmdpKn9ghsuNYWS/0=;
        b=dksw9eMB0Ogc3iR1kYf4rvoiqZ5KDAdKy00l782eCt9vRgeysWR7IEoJhw+x9ammEU
         jtIWpKB+NCSRsf8CeMLtouN20q/GV87BJ2oNgJUUGKluByR+r2vWVE5dxcrJ54Nb/LkB
         mlMxF8otuEY4hCSMAEvS5Ez3QEOehOBgQBXfZc0SDrXTUz1ekf54ZIAi+45H+eBQXMry
         IyTIdTv6xD7lhkdAOYIsC+MCTnJ/C+Y9vmaM+l3Z16oCj87VK550zfTWMw1mJ8M0bTma
         tyungZXJqwWYOBt6VbvUONaFPSnHHIAiQewiiubUP+nE0VMgWg4witFDSdMQwXXAA8AO
         sKig==
X-Gm-Message-State: AOAM533tfosItFPhJnCejm9hpch0bRyYd64J0ht/5fiVq5U4YBytvB2l
        Ov4SS2gFiqh9m32wVdJMTX8C3/O6lW7y7Fhtqwy1DcL7wcTn2PK4jh+Euk+8PDH59oASqZfB1KC
        PZrTWcaJR8Cn2rU76E9WSWiQqzw3oCYkf85eD+z6dd8l1BxYamIq2byXy+mIQMw==
X-Google-Smtp-Source: ABdhPJyPsjxUNhWpG/tKD5vhQWx1DWnpABR/kdvO2jMWZg5aJlXgp6G9UmeuLdRlQkgKJCPmo1buxLSDKDc=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a25:ca17:: with SMTP id a23mr6734956ybg.176.1601050842818;
 Fri, 25 Sep 2020 09:20:42 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:16 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-31-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 30/30 for 5.4] dma/direct: turn ARCH_ZONE_DMA_BITS into a variable
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

upstream 8b5369ea580964dbc982781bfb9fb93459fc5e8d commit.

Some architectures, notably ARM, are interested in tweaking this
depending on their runtime DMA addressing limitations.

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Change-Id: I890f2bfbbf5758e3868acddd7bba6f655ec2b357
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 arch/arm64/mm/init.c            |  9 ++++++++-
 arch/powerpc/include/asm/page.h |  9 ---------
 arch/powerpc/mm/mem.c           | 20 +++++++++++++++-----
 arch/s390/include/asm/page.h    |  2 --
 arch/s390/mm/init.c             |  1 +
 include/linux/dma-direct.h      |  2 ++
 kernel/dma/direct.c             | 13 ++++++-------
 7 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 45c00a54909c..214cedc9271c 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -20,6 +20,7 @@
 #include <linux/sort.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/dma-direct.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-contiguous.h>
 #include <linux/efi.h>
@@ -41,6 +42,8 @@
 #include <asm/tlb.h>
 #include <asm/alternative.h>
 
+#define ARM64_ZONE_DMA_BITS	30
+
 /*
  * We need to be able to catch inadvertent references to memstart_addr
  * that occur (potentially in generic code) before arm64_memblock_init()
@@ -418,7 +421,11 @@ void __init arm64_memblock_init(void)
 
 	early_init_fdt_scan_reserved_mem();
 
-	/* 4GB maximum for 32-bit only capable devices */
+	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
+		zone_dma_bits = ARM64_ZONE_DMA_BITS;
+		arm64_dma_phys_limit = max_zone_phys(ARM64_ZONE_DMA_BITS);
+	}
+
 	if (IS_ENABLED(CONFIG_ZONE_DMA32))
 		arm64_dma_phys_limit = max_zone_dma_phys();
 	else
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index 6ba5adb96a3b..d568ce08e3b2 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -334,13 +334,4 @@ struct vm_area_struct;
 #endif /* __ASSEMBLY__ */
 #include <asm/slice.h>
 
-/*
- * Allow 30-bit DMA for very limited Broadcom wifi chips on many powerbooks.
- */
-#ifdef CONFIG_PPC32
-#define ARCH_ZONE_DMA_BITS 30
-#else
-#define ARCH_ZONE_DMA_BITS 31
-#endif
-
 #endif /* _ASM_POWERPC_PAGE_H */
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 96ca90ce0264..3b99b6b67fb5 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/memremap.h>
+#include <linux/dma-direct.h>
 
 #include <asm/pgalloc.h>
 #include <asm/prom.h>
@@ -223,10 +224,10 @@ static int __init mark_nonram_nosave(void)
  * everything else. GFP_DMA32 page allocations automatically fall back to
  * ZONE_DMA.
  *
- * By using 31-bit unconditionally, we can exploit ARCH_ZONE_DMA_BITS to
- * inform the generic DMA mapping code.  32-bit only devices (if not handled
- * by an IOMMU anyway) will take a first dip into ZONE_NORMAL and get
- * otherwise served by ZONE_DMA.
+ * By using 31-bit unconditionally, we can exploit zone_dma_bits to inform the
+ * generic DMA mapping code.  32-bit only devices (if not handled by an IOMMU
+ * anyway) will take a first dip into ZONE_NORMAL and get otherwise served by
+ * ZONE_DMA.
  */
 static unsigned long max_zone_pfns[MAX_NR_ZONES];
 
@@ -259,9 +260,18 @@ void __init paging_init(void)
 	printk(KERN_DEBUG "Memory hole size: %ldMB\n",
 	       (long int)((top_of_ram - total_ram) >> 20));
 
+	/*
+	 * Allow 30-bit DMA for very limited Broadcom wifi chips on many
+	 * powerbooks.
+	 */
+	if (IS_ENABLED(CONFIG_PPC32))
+		zone_dma_bits = 30;
+	else
+		zone_dma_bits = 31;
+
 #ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA]	= min(max_low_pfn,
-				      1UL << (ARCH_ZONE_DMA_BITS - PAGE_SHIFT));
+				      1UL << (zone_dma_bits - PAGE_SHIFT));
 #endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index e399102367af..1019efd85b9d 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -179,8 +179,6 @@ static inline int devmem_is_allowed(unsigned long pfn)
 #define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
-#define ARCH_ZONE_DMA_BITS	31
-
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index c1d96e588152..ac44bd76db4b 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -118,6 +118,7 @@ void __init paging_init(void)
 
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
+	zone_dma_bits = 31;
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA] = PFN_DOWN(MAX_DMA_ADDRESS);
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index 6db863c3eb93..f3b276242f2d 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -6,6 +6,8 @@
 #include <linux/memblock.h> /* for min_low_pfn */
 #include <linux/mem_encrypt.h>
 
+extern unsigned int zone_dma_bits;
+
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr);
 
 #ifdef CONFIG_ARCH_HAS_PHYS_TO_DMA
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 71be82b07743..2af418b4b6f9 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -17,12 +17,11 @@
 #include <linux/swiotlb.h>
 
 /*
- * Most architectures use ZONE_DMA for the first 16 Megabytes, but
- * some use it for entirely different regions:
+ * Most architectures use ZONE_DMA for the first 16 Megabytes, but some use it
+ * it for entirely different regions. In that case the arch code needs to
+ * override the variable below for dma-direct to work properly.
  */
-#ifndef ARCH_ZONE_DMA_BITS
-#define ARCH_ZONE_DMA_BITS 24
-#endif
+unsigned int zone_dma_bits __ro_after_init = 24;
 
 static void report_addr(struct device *dev, dma_addr_t dma_addr, size_t size)
 {
@@ -77,7 +76,7 @@ gfp_t dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
 	 * Note that GFP_DMA32 and GFP_DMA are no ops without the corresponding
 	 * zones.
 	 */
-	if (*phys_mask <= DMA_BIT_MASK(ARCH_ZONE_DMA_BITS))
+	if (*phys_mask <= DMA_BIT_MASK(zone_dma_bits))
 		return GFP_DMA;
 	if (*phys_mask <= DMA_BIT_MASK(32))
 		return GFP_DMA32;
@@ -547,7 +546,7 @@ int dma_direct_supported(struct device *dev, u64 mask)
 	u64 min_mask;
 
 	if (IS_ENABLED(CONFIG_ZONE_DMA))
-		min_mask = DMA_BIT_MASK(ARCH_ZONE_DMA_BITS);
+		min_mask = DMA_BIT_MASK(zone_dma_bits);
 	else
 		min_mask = DMA_BIT_MASK(32);
 
-- 
2.28.0.618.gf4bc123cb7-goog

