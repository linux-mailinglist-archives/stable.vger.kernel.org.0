Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77924278E3A
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgIYQUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729286AbgIYQUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:19 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753A3C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:19 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id m13so2354615qtu.10
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=+dNbpiQ5L14ez4XVhQTrLcCCsLvYad4nTbVsU0C8cik=;
        b=Q8jszLV7WEYsNMuVG7Dp6Xz3MqO3DuwPulgj4OvuJtRlXBflDnK46wBuYytXqT/ylc
         CFfXnZ2GH7tXNpB6sV0kiT3iR7enYP/AqKxRXVnC5jE/x5x7yK3zhE+PG26iHdVBpaqI
         1n8i3ztrhzvkd736RKyq1e1Won37ErUVqr5s1OokBTFe/32MnPhhLAn6S0lQ5uYzxheO
         c3+eNG8YgcTxR74TPNLcL+KQGhHM7ya49PGDQ5ep0mOaJOrWycSgbZ3FNcHOjIAtx1by
         giXTEO7Q7Dc15JmlpWcs/Jeh5Hsm9eUdSIX3b7zWMCa9Q1oAB1yVGt8QG2ELTKV3RnUU
         uAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+dNbpiQ5L14ez4XVhQTrLcCCsLvYad4nTbVsU0C8cik=;
        b=Ry1WlfqWjNqX71l0pD0klXn3WUJLLPRwhbyK0FXGT3UPn3a0/lGNdOEJn2SayvFXsx
         FG0fXrE1+zQcuGX0/L5PnbFBK5k+fSD6D0xCGd2NaSGUfL0e/VsH3X8gy7wghep26XhP
         lsbirEHJEEZBnsqz/arFd8g5ZsoViQtcDMyu0tm7fpTAoiS/zc/WCwYzRi2OXZ4jqqOI
         ivzkw5a4TtnnvHtC41U905yAPVVxrxK98Nfw/cxXO7K7I+q/lq/azfcdtHyAs4V/gRiJ
         8IGihoee9Pnjo6kD4+bL0ZLw+Sn33cZRb7T7QIylrHaVYn+FluyWpMpac0umAkYFivpZ
         RoyA==
X-Gm-Message-State: AOAM531km7PB7wAKdDSijOveC7hZneLsjqjbV59HdP4kkyBVplisO3kW
        R576ekrjwW3AJF6gejNpi7Ly6m2+ezzMwqMG0XhOpXlPRrfO+SQMbw9dMLRi477JTQYo6GaGETZ
        7gU55Jl13dNyf+sjv3Q3EDq0YawuflCJLFLh4swQAOltkuejA798wWBheERnAWA==
X-Google-Smtp-Source: ABdhPJxPKp4bvCTLxPp/uPhj7VHWXXmJk3HBehT1iQ+3ZqU29Rh0iuvG4MOTMi3GoaMdz1OhIDE7c1Xzeuk=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a0c:8c4c:: with SMTP id o12mr98400qvb.46.1601050818500;
 Fri, 25 Sep 2020 09:20:18 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:02 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-17-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 16/30 for 5.4] xtensa: use the generic uncached segment support
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

upstream 0f665b9e2a6d4cc963e6cd349d40320ed5281f95 commit.

Switch xtensa over to use the generic uncached support, and thus the
generic implementations of dma_alloc_* and dma_alloc_*, which also
gains support for mmaping DMA memory.  The non-working nommu DMA
support has been disabled, but could be re-enabled easily if platforms
that actually have an uncached segment show up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Tested-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 arch/xtensa/Kconfig                |   6 +-
 arch/xtensa/include/asm/platform.h |  27 -------
 arch/xtensa/kernel/Makefile        |   3 +-
 arch/xtensa/kernel/pci-dma.c       | 121 +++--------------------------
 4 files changed, 18 insertions(+), 139 deletions(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 8352037322df..d3a5891eff2e 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -3,8 +3,10 @@ config XTENSA
 	def_bool y
 	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_BINFMT_FLAT if !MMU
-	select ARCH_HAS_SYNC_DMA_FOR_CPU
-	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
+	select ARCH_HAS_DMA_PREP_COHERENT if MMU
+	select ARCH_HAS_SYNC_DMA_FOR_CPU if MMU
+	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if MMU
+	select ARCH_HAS_UNCACHED_SEGMENT if MMU
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/xtensa/include/asm/platform.h b/arch/xtensa/include/asm/platform.h
index 913826dfa838..f2c48522c5a1 100644
--- a/arch/xtensa/include/asm/platform.h
+++ b/arch/xtensa/include/asm/platform.h
@@ -65,31 +65,4 @@ extern void platform_calibrate_ccount (void);
  */
 void cpu_reset(void) __attribute__((noreturn));
 
-/*
- * Memory caching is platform-dependent in noMMU xtensa configurations.
- * The following set of functions should be implemented in platform code
- * in order to enable coherent DMA memory operations when CONFIG_MMU is not
- * enabled. Default implementations do nothing and issue a warning.
- */
-
-/*
- * Check whether p points to a cached memory.
- */
-bool platform_vaddr_cached(const void *p);
-
-/*
- * Check whether p points to an uncached memory.
- */
-bool platform_vaddr_uncached(const void *p);
-
-/*
- * Return pointer to an uncached view of the cached sddress p.
- */
-void *platform_vaddr_to_uncached(void *p);
-
-/*
- * Return pointer to a cached view of the uncached sddress p.
- */
-void *platform_vaddr_to_cached(void *p);
-
 #endif	/* _XTENSA_PLATFORM_H */
diff --git a/arch/xtensa/kernel/Makefile b/arch/xtensa/kernel/Makefile
index 6f629027ac7d..d4082c6a121b 100644
--- a/arch/xtensa/kernel/Makefile
+++ b/arch/xtensa/kernel/Makefile
@@ -5,10 +5,11 @@
 
 extra-y := head.o vmlinux.lds
 
-obj-y := align.o coprocessor.o entry.o irq.o pci-dma.o platform.o process.o \
+obj-y := align.o coprocessor.o entry.o irq.o platform.o process.o \
 	 ptrace.o setup.o signal.o stacktrace.o syscall.o time.o traps.o \
 	 vectors.o
 
+obj-$(CONFIG_MMU) += pci-dma.o
 obj-$(CONFIG_PCI) += pci.o
 obj-$(CONFIG_MODULES) += xtensa_ksyms.o module.o
 obj-$(CONFIG_FUNCTION_TRACER) += mcount.o
diff --git a/arch/xtensa/kernel/pci-dma.c b/arch/xtensa/kernel/pci-dma.c
index 154979d62b73..1c82e21de4f6 100644
--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -81,122 +81,25 @@ void arch_sync_dma_for_device(struct device *dev, phys_addr_t paddr,
 	}
 }
 
-#ifdef CONFIG_MMU
-bool platform_vaddr_cached(const void *p)
-{
-	unsigned long addr = (unsigned long)p;
-
-	return addr >= XCHAL_KSEG_CACHED_VADDR &&
-	       addr - XCHAL_KSEG_CACHED_VADDR < XCHAL_KSEG_SIZE;
-}
-
-bool platform_vaddr_uncached(const void *p)
-{
-	unsigned long addr = (unsigned long)p;
-
-	return addr >= XCHAL_KSEG_BYPASS_VADDR &&
-	       addr - XCHAL_KSEG_BYPASS_VADDR < XCHAL_KSEG_SIZE;
-}
-
-void *platform_vaddr_to_uncached(void *p)
-{
-	return p + XCHAL_KSEG_BYPASS_VADDR - XCHAL_KSEG_CACHED_VADDR;
-}
-
-void *platform_vaddr_to_cached(void *p)
-{
-	return p + XCHAL_KSEG_CACHED_VADDR - XCHAL_KSEG_BYPASS_VADDR;
-}
-#else
-bool __attribute__((weak)) platform_vaddr_cached(const void *p)
-{
-	WARN_ONCE(1, "Default %s implementation is used\n", __func__);
-	return true;
-}
-
-bool __attribute__((weak)) platform_vaddr_uncached(const void *p)
-{
-	WARN_ONCE(1, "Default %s implementation is used\n", __func__);
-	return false;
-}
-
-void __attribute__((weak)) *platform_vaddr_to_uncached(void *p)
+void arch_dma_prep_coherent(struct page *page, size_t size)
 {
-	WARN_ONCE(1, "Default %s implementation is used\n", __func__);
-	return p;
-}
-
-void __attribute__((weak)) *platform_vaddr_to_cached(void *p)
-{
-	WARN_ONCE(1, "Default %s implementation is used\n", __func__);
-	return p;
+	__invalidate_dcache_range((unsigned long)page_address(page), size);
 }
-#endif
 
 /*
- * Note: We assume that the full memory space is always mapped to 'kseg'
- *	 Otherwise we have to use page attributes (not implemented).
+ * Memory caching is platform-dependent in noMMU xtensa configurations.
+ * The following two functions should be implemented in platform code
+ * in order to enable coherent DMA memory operations when CONFIG_MMU is not
+ * enabled.
  */
-
-void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-		gfp_t flag, unsigned long attrs)
-{
-	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	struct page *page = NULL;
-
-	/* ignore region speicifiers */
-
-	flag &= ~(__GFP_DMA | __GFP_HIGHMEM);
-
-	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
-		flag |= GFP_DMA;
-
-	if (gfpflags_allow_blocking(flag))
-		page = dma_alloc_from_contiguous(dev, count, get_order(size),
-						 flag & __GFP_NOWARN);
-
-	if (!page)
-		page = alloc_pages(flag | __GFP_ZERO, get_order(size));
-
-	if (!page)
-		return NULL;
-
-	*handle = phys_to_dma(dev, page_to_phys(page));
-
 #ifdef CONFIG_MMU
-	if (PageHighMem(page)) {
-		void *p;
-
-		p = dma_common_contiguous_remap(page, size,
-						pgprot_noncached(PAGE_KERNEL),
-						__builtin_return_address(0));
-		if (!p) {
-			if (!dma_release_from_contiguous(dev, page, count))
-				__free_pages(page, get_order(size));
-		}
-		return p;
-	}
-#endif
-	BUG_ON(!platform_vaddr_cached(page_address(page)));
-	__invalidate_dcache_range((unsigned long)page_address(page), size);
-	return platform_vaddr_to_uncached(page_address(page));
+void *uncached_kernel_address(void *p)
+{
+	return p + XCHAL_KSEG_BYPASS_VADDR - XCHAL_KSEG_CACHED_VADDR;
 }
 
-void arch_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, unsigned long attrs)
+void *cached_kernel_address(void *p)
 {
-	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	struct page *page;
-
-	if (platform_vaddr_uncached(vaddr)) {
-		page = virt_to_page(platform_vaddr_to_cached(vaddr));
-	} else {
-#ifdef CONFIG_MMU
-		dma_common_free_remap(vaddr, size);
-#endif
-		page = pfn_to_page(PHYS_PFN(dma_to_phys(dev, dma_handle)));
-	}
-
-	if (!dma_release_from_contiguous(dev, page, count))
-		__free_pages(page, get_order(size));
+	return p + XCHAL_KSEG_CACHED_VADDR - XCHAL_KSEG_BYPASS_VADDR;
 }
+#endif /* CONFIG_MMU */
-- 
2.28.0.618.gf4bc123cb7-goog

