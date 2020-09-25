Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2B4278E24
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgIYQT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729554AbgIYQT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:19:57 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EE7C0613D3
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:57 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 82so2666584pgf.16
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6xRrIbPx9uiGFJtbKQdD72ZI9i388/g7ufwhJBnfD8A=;
        b=DUGofUZVkCZixpIdZU+OLDNxDc7WWNxuk4zq0J8MbXh8EV7DAIAPogHy+H7ew3xreM
         hJADDakJtZpulOlyGgSvlj8Qg0Pbue9Yea9VUltJZBAW+4HD+qMN6VM4tn1zl1aeXlCN
         n2O+ENo7ROFZIw3JEN35ONFD8H+9ErpRKHbk9N7mBU7zkQSpmBUoEzJ2vqgCwb0UCGL5
         bcGKl6oiiXYPw40DGlehRQacEZ2TJdyWs50pF8JeGy52CQk0jyqBdYIEAiaZkZHg2tkP
         i6lh29UWxnrl9bBfSKFg0nJCdUK0WjMCY0vys7FwlGq67Z7a/M9W9Z4Hj6E8Cj3LnLBe
         NVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6xRrIbPx9uiGFJtbKQdD72ZI9i388/g7ufwhJBnfD8A=;
        b=sI2TI+7qQQtPaJcvvKhP0zpYmqlChjILwKnAPrz31yL9lKkEvAEuC2UCW8wqYEMi/J
         Zd38a9PJpknfJYxWgVhNhYPuGaYldejD+1HdU8EJNGf0bBznNy/c5mTK2mnWyiWWkO83
         8WsC9VQEcbanxjso7Ovtd0F1L97kOiy7QwXAaMYO3+eBLo+8BRxRGmxeqVUPGcDyr5WG
         RBEb6RyWUDe7CJSu0u7xDWAwVRB7+13y2QRMemAV0gPHoe6QfGFdg4zcoQQqDobND6jm
         MQkBdboxJhGZll0KLJPttC5jIzI45dMf6fnwKhE4dr8L9mEfoGctDpoZJ2o24ZkhJv07
         psbA==
X-Gm-Message-State: AOAM530sKA5EPFc0tu4tAXwwqdJH8AFY6lw2XM9MwBofzSvcers8z9qG
        +Ditj3tw9dP65JkVMToIvWqP1bsao1vpc7S5y4mJE9AIBkst/c0DwpPuZ7A4NDQmvXdI7eFd4T9
        qKB5FKscWZkIPQGayhahOjdPt1diekzUNgokR5454zgmd9LgaPNveA4waZXE8lA==
X-Google-Smtp-Source: ABdhPJzc1x0JvoJK/KU8BOxOHn35GmA89Gkvx94QL85vYxPUdq41sKCSKx8+2CUHIxISM03MTNMnBrBtL0A=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:aa7:9f99:0:b029:13e:d13d:a134 with SMTP id
 z25-20020aa79f990000b029013ed13da134mr73921pfr.28.1601050797134; Fri, 25 Sep
 2020 09:19:57 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:50 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-5-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 04/30 for 5.4] dma-mapping: merge the generic remapping
 helpers into dma-direct
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

upstream 3acac065508f6cc60ac9d3e4b7c6cc37fd91d531 commit.

Integrate the generic dma remapping implementation into the main flow.
This prepares for architectures like xtensa that use an uncached
segment for pages in the kernel mapping, but can also remap highmem
from CMA.  To simplify that implementation we now always deduct the
page from the physical address via the DMA address instead of the
virtual address.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/direct.c | 60 ++++++++++++++++++++++++++++++++++++---------
 kernel/dma/remap.c  | 49 ------------------------------------
 2 files changed, 48 insertions(+), 61 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 76c722bc9e0c..d30c5468a91a 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -12,6 +12,7 @@
 #include <linux/dma-contiguous.h>
 #include <linux/dma-noncoherent.h>
 #include <linux/pfn.h>
+#include <linux/vmalloc.h>
 #include <linux/set_memory.h>
 #include <linux/swiotlb.h>
 
@@ -138,6 +139,15 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	struct page *page;
 	void *ret;
 
+	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
+	    dma_alloc_need_uncached(dev, attrs) &&
+	    !gfpflags_allow_blocking(gfp)) {
+		ret = dma_alloc_from_pool(PAGE_ALIGN(size), &page, gfp);
+		if (!ret)
+			return NULL;
+		goto done;
+	}
+
 	page = __dma_direct_alloc_pages(dev, size, gfp, attrs);
 	if (!page)
 		return NULL;
@@ -147,9 +157,28 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 		/* remove any dirty cache lines on the kernel alias */
 		if (!PageHighMem(page))
 			arch_dma_prep_coherent(page, size);
-		*dma_handle = phys_to_dma(dev, page_to_phys(page));
 		/* return the page pointer as the opaque cookie */
-		return page;
+		ret = page;
+		goto done;
+	}
+
+	if ((IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
+	     dma_alloc_need_uncached(dev, attrs)) ||
+	    (IS_ENABLED(CONFIG_DMA_REMAP) && PageHighMem(page))) {
+		/* remove any dirty cache lines on the kernel alias */
+		arch_dma_prep_coherent(page, PAGE_ALIGN(size));
+
+		/* create a coherent mapping */
+		ret = dma_common_contiguous_remap(page, PAGE_ALIGN(size),
+				dma_pgprot(dev, PAGE_KERNEL, attrs),
+				__builtin_return_address(0));
+		if (!ret) {
+			dma_free_contiguous(dev, page, size);
+			return ret;
+		}
+
+		memset(ret, 0, size);
+		goto done;
 	}
 
 	if (PageHighMem(page)) {
@@ -165,12 +194,9 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	}
 
 	ret = page_address(page);
-	if (force_dma_unencrypted(dev)) {
+	if (force_dma_unencrypted(dev))
 		set_memory_decrypted((unsigned long)ret, 1 << get_order(size));
-		*dma_handle = __phys_to_dma(dev, page_to_phys(page));
-	} else {
-		*dma_handle = phys_to_dma(dev, page_to_phys(page));
-	}
+
 	memset(ret, 0, size);
 
 	if (IS_ENABLED(CONFIG_ARCH_HAS_UNCACHED_SEGMENT) &&
@@ -178,7 +204,11 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 		arch_dma_prep_coherent(page, size);
 		ret = uncached_kernel_address(ret);
 	}
-
+done:
+	if (force_dma_unencrypted(dev))
+		*dma_handle = __phys_to_dma(dev, page_to_phys(page));
+	else
+		*dma_handle = phys_to_dma(dev, page_to_phys(page));
 	return ret;
 }
 
@@ -194,19 +224,24 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 		return;
 	}
 
+	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
+	    dma_free_from_pool(cpu_addr, PAGE_ALIGN(size)))
+		return;
+
 	if (force_dma_unencrypted(dev))
 		set_memory_encrypted((unsigned long)cpu_addr, 1 << page_order);
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_UNCACHED_SEGMENT) &&
-	    dma_alloc_need_uncached(dev, attrs))
-		cpu_addr = cached_kernel_address(cpu_addr);
-	dma_free_contiguous(dev, virt_to_page(cpu_addr), size);
+	if (IS_ENABLED(CONFIG_DMA_REMAP) && is_vmalloc_addr(cpu_addr))
+		vunmap(cpu_addr);
+
+	dma_free_contiguous(dev, dma_direct_to_page(dev, dma_addr), size);
 }
 
 void *dma_direct_alloc(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	if (!IS_ENABLED(CONFIG_ARCH_HAS_UNCACHED_SEGMENT) &&
+	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
 	    dma_alloc_need_uncached(dev, attrs))
 		return arch_dma_alloc(dev, size, dma_handle, gfp, attrs);
 	return dma_direct_alloc_pages(dev, size, dma_handle, gfp, attrs);
@@ -216,6 +251,7 @@ void dma_direct_free(struct device *dev, size_t size,
 		void *cpu_addr, dma_addr_t dma_addr, unsigned long attrs)
 {
 	if (!IS_ENABLED(CONFIG_ARCH_HAS_UNCACHED_SEGMENT) &&
+	    !IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
 	    dma_alloc_need_uncached(dev, attrs))
 		arch_dma_free(dev, size, cpu_addr, dma_addr, attrs);
 	else
diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index 3c49499ee6b0..d47bd40fc0f5 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -210,53 +210,4 @@ bool dma_free_from_pool(void *start, size_t size)
 	gen_pool_free(atomic_pool, (unsigned long)start, size);
 	return true;
 }
-
-void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
-		gfp_t flags, unsigned long attrs)
-{
-	struct page *page = NULL;
-	void *ret;
-
-	size = PAGE_ALIGN(size);
-
-	if (!gfpflags_allow_blocking(flags)) {
-		ret = dma_alloc_from_pool(size, &page, flags);
-		if (!ret)
-			return NULL;
-		goto done;
-	}
-
-	page = __dma_direct_alloc_pages(dev, size, flags, attrs);
-	if (!page)
-		return NULL;
-
-	/* remove any dirty cache lines on the kernel alias */
-	arch_dma_prep_coherent(page, size);
-
-	/* create a coherent mapping */
-	ret = dma_common_contiguous_remap(page, size,
-			dma_pgprot(dev, PAGE_KERNEL, attrs),
-			__builtin_return_address(0));
-	if (!ret) {
-		dma_free_contiguous(dev, page, size);
-		return ret;
-	}
-
-	memset(ret, 0, size);
-done:
-	*dma_handle = phys_to_dma(dev, page_to_phys(page));
-	return ret;
-}
-
-void arch_dma_free(struct device *dev, size_t size, void *vaddr,
-		dma_addr_t dma_handle, unsigned long attrs)
-{
-	if (!dma_free_from_pool(vaddr, PAGE_ALIGN(size))) {
-		phys_addr_t phys = dma_to_phys(dev, dma_handle);
-		struct page *page = pfn_to_page(__phys_to_pfn(phys));
-
-		vunmap(vaddr);
-		dma_free_contiguous(dev, page, size);
-	}
-}
 #endif /* CONFIG_DMA_DIRECT_REMAP */
-- 
2.28.0.618.gf4bc123cb7-goog

