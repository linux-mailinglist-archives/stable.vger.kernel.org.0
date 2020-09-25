Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AA5278E3B
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgIYQUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729286AbgIYQUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:21 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1765DC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:21 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id f4so1997352qvw.15
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=7STjK9+TpwPFw0qxRDj2vZ4hmRtmYuob5ieMgtRjCx0=;
        b=sasmhY96/XbKRVYBY5MtAFtnXPtLJFTnt0XF7tn1dOVfJzWV7YRJ9ghf7y0LXhVvIq
         mxFWRz1yAM3xEAVnKpM0fOCXUjVmuaFSMT8G4xACgbU0g1txGzKqJdlLXaWJW1aDQ2+y
         MYahJgD5scdt8gmji9f9spX7dGicyVk+L7u+Z736M2XoDQ84M5wEOBEPSUaqp8cYCpBY
         HZ00/rAPjaaxaokcNpjhdFfu4V//CsGrw1SQ+TRho+bJlcVVjn75ZgFouFmWV/kZDQ+8
         XHNF/inqx1GUy0qqLiPaO1C9JvyAQcOwX/GDRD7nsVAW70+I/f0YYNkIB3qkfaH0GC97
         sVtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7STjK9+TpwPFw0qxRDj2vZ4hmRtmYuob5ieMgtRjCx0=;
        b=KGP8NG2Sue9DV3kPt/xkUcDd2FjvEYoJwutvXtazBy+k1xge9zVpKcv2/6taW6n4iK
         e3EGVlDsyjPLvMP3xf3NpNIvDieOgS33JqFQ0OqyVG1WgeywMWQjiAkK5vmDHVe03/rq
         1ugl5NwIKL1QJtGytmBEwbGF5BeK5WjUvrYleHk/zLYgyeq1nvOaJ6LzXWZWpyecyfMk
         tghsELj6F63p4fXlcFLXUab3CUhhsPhe4ij9DlK9vLAXugk5Tue/XFvZ//rpMhMghqBI
         SBQnoBTlYj1H+3oIF3x++kwcJRgGX5UqoAaBkgz3J2TDHhAchW08c1OGD18cy9qI+beq
         6exA==
X-Gm-Message-State: AOAM530ZZBZXxaST8ivxgOUi81wrVwd2HP56Qv08PW4eIsVhrx20pDYV
        Pd8W6VlYLDsZbw3GDFBSqzr93Z7WNE+yqOnZm62UYa718MjEsBXngZ21gP/Puufwtj3XdeF6qGe
        clsfNNndaohPCBPqOnUqyHUX6INrkaoEFyxaVob4n3c+HtzunSXW7Koh8I/UOXg==
X-Google-Smtp-Source: ABdhPJzVsvxEgTykAFcPVeDgcH77LAJXa8Tray6HYRPELQXCvlC7vy9yT0YHimJMULgvQeWVXFkCF/zembE=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a05:6214:1225:: with SMTP id
 p5mr163771qvv.29.1601050820103; Fri, 25 Sep 2020 09:20:20 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:03 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-18-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 17/30 for 5.4] dma-direct: make uncached_kernel_address more general
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

upstream fa7e2247c5729f990c7456fe09f3af99c8f2571b commit.

Rename the symbol to arch_dma_set_uncached, and pass a size to it as
well as allow an error return.  That will allow reusing this hook for
in-place pagetable remapping.

As the in-place remap doesn't always require an explicit cache flush,
also detangle ARCH_HAS_DMA_PREP_COHERENT from ARCH_HAS_DMA_SET_UNCACHED.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Change-Id: I69aaa5ee5f73547aaf4de8fb0a57494709fa5eb5
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 arch/Kconfig                    |  8 ++++----
 arch/microblaze/Kconfig         |  2 +-
 arch/microblaze/mm/consistent.c |  2 +-
 arch/mips/Kconfig               |  3 ++-
 arch/mips/mm/dma-noncoherent.c  |  2 +-
 arch/nios2/Kconfig              |  3 ++-
 arch/nios2/mm/dma-mapping.c     |  2 +-
 arch/xtensa/Kconfig             |  2 +-
 arch/xtensa/kernel/pci-dma.c    |  2 +-
 include/linux/dma-noncoherent.h |  2 +-
 kernel/dma/direct.c             | 10 ++++++----
 11 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 238dccfa7691..38b6e74750fc 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -248,11 +248,11 @@ config ARCH_HAS_SET_DIRECT_MAP
 	bool
 
 #
-# Select if arch has an uncached kernel segment and provides the
-# uncached_kernel_address / cached_kernel_address symbols to use it
+# Select if the architecture provides the arch_dma_set_uncached symbol to
+# either provide an uncached segement alias for a DMA allocation, or
+# to remap the page tables in place.
 #
-config ARCH_HAS_UNCACHED_SEGMENT
-	select ARCH_HAS_DMA_PREP_COHERENT
+config ARCH_HAS_DMA_SET_UNCACHED
 	bool
 
 # Select if arch init_task must go in the __init_task_data section
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 261c26df1c9f..2bdb3ceb525d 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -8,7 +8,7 @@ config MICROBLAZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-	select ARCH_HAS_UNCACHED_SEGMENT if !MMU
+	select ARCH_HAS_DMA_SET_UNCACHED if !MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT
diff --git a/arch/microblaze/mm/consistent.c b/arch/microblaze/mm/consistent.c
index 8c5f0c332d8b..457581fb74cc 100644
--- a/arch/microblaze/mm/consistent.c
+++ b/arch/microblaze/mm/consistent.c
@@ -40,7 +40,7 @@ void arch_dma_prep_coherent(struct page *page, size_t size)
 #define UNCACHED_SHADOW_MASK 0
 #endif /* CONFIG_XILINX_UNCACHED_SHADOW */
 
-void *uncached_kernel_address(void *ptr)
+void *arch_dma_set_uncached(void *ptr, size_t size)
 {
 	unsigned long addr = (unsigned long)ptr;
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index c1c3da4fc667..ab98d8bad08e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1132,8 +1132,9 @@ config DMA_NONCOHERENT
 	# significant advantages.
 	#
 	select ARCH_HAS_DMA_WRITE_COMBINE
+	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-	select ARCH_HAS_UNCACHED_SEGMENT
+	select ARCH_HAS_DMA_SET_UNCACHED
 	select DMA_NONCOHERENT_MMAP
 	select DMA_NONCOHERENT_CACHE_SYNC
 	select NEED_DMA_MAP_STATE
diff --git a/arch/mips/mm/dma-noncoherent.c b/arch/mips/mm/dma-noncoherent.c
index fcf6d3eaac66..d71b947a2121 100644
--- a/arch/mips/mm/dma-noncoherent.c
+++ b/arch/mips/mm/dma-noncoherent.c
@@ -49,7 +49,7 @@ void arch_dma_prep_coherent(struct page *page, size_t size)
 	dma_cache_wback_inv((unsigned long)page_address(page), size);
 }
 
-void *uncached_kernel_address(void *addr)
+void *arch_dma_set_uncached(void *addr, size_t size)
 {
 	return (void *)(__pa(addr) + UNCAC_BASE);
 }
diff --git a/arch/nios2/Kconfig b/arch/nios2/Kconfig
index 44b5da37e8bd..2fc4ed210b5f 100644
--- a/arch/nios2/Kconfig
+++ b/arch/nios2/Kconfig
@@ -2,9 +2,10 @@
 config NIOS2
 	def_bool y
 	select ARCH_32BIT_OFF_T
+	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-	select ARCH_HAS_UNCACHED_SEGMENT
+	select ARCH_HAS_DMA_SET_UNCACHED
 	select ARCH_NO_SWAP
 	select TIMER_OF
 	select GENERIC_ATOMIC64
diff --git a/arch/nios2/mm/dma-mapping.c b/arch/nios2/mm/dma-mapping.c
index 9cb238664584..19f6d6b394e6 100644
--- a/arch/nios2/mm/dma-mapping.c
+++ b/arch/nios2/mm/dma-mapping.c
@@ -67,7 +67,7 @@ void arch_dma_prep_coherent(struct page *page, size_t size)
 	flush_dcache_range(start, start + size);
 }
 
-void *uncached_kernel_address(void *ptr)
+void *arch_dma_set_uncached(void *ptr, size_t size)
 {
 	unsigned long addr = (unsigned long)ptr;
 
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index d3a5891eff2e..75bc567c5c10 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -6,7 +6,7 @@ config XTENSA
 	select ARCH_HAS_DMA_PREP_COHERENT if MMU
 	select ARCH_HAS_SYNC_DMA_FOR_CPU if MMU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if MMU
-	select ARCH_HAS_UNCACHED_SEGMENT if MMU
+	select ARCH_HAS_DMA_SET_UNCACHED if MMU
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/xtensa/kernel/pci-dma.c b/arch/xtensa/kernel/pci-dma.c
index 1c82e21de4f6..d704eb67867c 100644
--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -93,7 +93,7 @@ void arch_dma_prep_coherent(struct page *page, size_t size)
  * enabled.
  */
 #ifdef CONFIG_MMU
-void *uncached_kernel_address(void *p)
+void *arch_dma_set_uncached(void *p, size_t size)
 {
 	return p + XCHAL_KSEG_BYPASS_VADDR - XCHAL_KSEG_CACHED_VADDR;
 }
diff --git a/include/linux/dma-noncoherent.h b/include/linux/dma-noncoherent.h
index e30fca1f1b12..dc6ddbb26846 100644
--- a/include/linux/dma-noncoherent.h
+++ b/include/linux/dma-noncoherent.h
@@ -108,7 +108,7 @@ static inline void arch_dma_prep_coherent(struct page *page, size_t size)
 }
 #endif /* CONFIG_ARCH_HAS_DMA_PREP_COHERENT */
 
-void *uncached_kernel_address(void *addr);
+void *arch_dma_set_uncached(void *addr, size_t size);
 void *cached_kernel_address(void *addr);
 
 #endif /* _LINUX_DMA_NONCOHERENT_H */
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 5343afbb8af3..bb5cb5af9f7d 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -226,10 +226,12 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 
 	memset(ret, 0, size);
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_UNCACHED_SEGMENT) &&
+	if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
 	    dma_alloc_need_uncached(dev, attrs)) {
 		arch_dma_prep_coherent(page, size);
-		ret = uncached_kernel_address(ret);
+		ret = arch_dma_set_uncached(ret, size);
+		if (IS_ERR(ret))
+			goto out_free_pages;
 	}
 done:
 	if (force_dma_unencrypted(dev))
@@ -271,7 +273,7 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 void *dma_direct_alloc(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_UNCACHED_SEGMENT) &&
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
 	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
 	    dma_alloc_need_uncached(dev, attrs))
 		return arch_dma_alloc(dev, size, dma_handle, gfp, attrs);
@@ -281,7 +283,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 void dma_direct_free(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
 {
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_UNCACHED_SEGMENT) &&
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_DMA_SET_UNCACHED) &&
 	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
 	    dma_alloc_need_uncached(dev, attrs))
 		arch_dma_free(dev, size, cpu_addr, dma_addr, attrs);
-- 
2.28.0.618.gf4bc123cb7-goog

