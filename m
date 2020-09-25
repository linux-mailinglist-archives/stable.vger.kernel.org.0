Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18E5278E28
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgIYQUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729556AbgIYQUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:04 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC9BC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:03 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id u6so2358950qte.8
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6BYT7TOwiFd3r1FHsuYqLLsEnaJltT8MOhfwia7b0Oc=;
        b=tiRwq42bbPhwbbz5z9f1wtIvFOiTtfY8M5oRU6hIyfrRVO9XolLAJt3PoBqRbo45D0
         hdahtWKaqwf1XdhPL3UgAxEh0NlDlpY/ueelqkK3/H+DyPy83jFKhT6Qm7Tin/6viZyM
         c01McR6a1uPO8GAt4ENd7g3tF4VUtj2gxTXDhuzpioB5bW0h927QYFUcjVkRtJxdkgDn
         xlTZNU2Lwme24APZsR1yqJDmnOosGJ6QdiE/3fClYtojJ1pMoQqsYDnURfvm/Ykc6gGv
         YTYCBpYuR2EDJ0Qzuqa2UQ3wdxm7xsZRrIjmYdXRHH/VRz8T29obJKHhNccC66w1jjKe
         mYEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6BYT7TOwiFd3r1FHsuYqLLsEnaJltT8MOhfwia7b0Oc=;
        b=N6v7chJb7N/ftMIGePMNqejFdGNMtcgf4ePsITX37t8BJ6z0/mHHef3jskOoTQ3O3j
         XErUpPhddWcA53Q7D/vF/ymVIwpo3qXc4hhFFVi+22DjcMVRzBtHm2OwbzTo3Q0vwxzn
         LvzcsVvEbXsb67ciYTvEVXKN5aHyqqYMrbkWIk6svfFN9WkqshZY7S8tjmQVJgzuXYt1
         BRKfzyryXZKsuMwvOQf3v/3gYrgI6b0EsHfqQJX7dsiN3QuTLsdUtRuha5VLvXjl16KP
         tP/WRHD2ftRiw7XiBEJ+EoLVUfGcKpwNrfKguj+0xYadZfKNcDUGjzk/tGvSMR+ED7PB
         AY2A==
X-Gm-Message-State: AOAM530n+lXmHAAYKSUyVdOnJ8KOey0OtXNYh7y4LA3JoTQMZiAu1Avc
        qD1tcoFX8vQNFhkJcgHAhNIsQBfvYm5meaC5d8VJCiFt2a/BL97arCMzdiOGO4ujzH2r3qvH6rC
        rT3stA6+i73ndam8tjQaQvDlqJKARnpQwHcLhITzB3KugIBYEiw6pc1biF7q/0A==
X-Google-Smtp-Source: ABdhPJxWMkAws6dOAlYIOcJsTLIdusI8HO5dhzNWm75Wt38jRMYjCe9vSq5byAbuSCrNSfHJ3v3hiFIspeU=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a0c:b308:: with SMTP id s8mr168010qve.31.1601050802973;
 Fri, 25 Sep 2020 09:20:02 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:53 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-8-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 07/30 for 5.4] dma-pool: add additional coherent pools to map
 to gfp mask
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

upstream c84dc6e68a1d2464e050d9694be4e4ff49e32bfd commit.

The single atomic pool is allocated from the lowest zone possible since
it is guaranteed to be applicable for any DMA allocation.

Devices may allocate through the DMA API but not have a strict reliance
on GFP_DMA memory.  Since the atomic pool will be used for all
non-blockable allocations, returning all memory from ZONE_DMA may
unnecessarily deplete the zone.

Provision for multiple atomic pools that will map to the optimal gfp
mask of the device.

When allocating non-blockable memory, determine the optimal gfp mask of
the device and use the appropriate atomic pool.

The coherent DMA mask will remain the same between allocation and free
and, thus, memory will be freed to the same atomic pool it was allocated
from.

__dma_atomic_pool_init() will be changed to return struct gen_pool *
later once dynamic expansion is added.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 drivers/iommu/dma-iommu.c   |   5 +-
 include/linux/dma-direct.h  |   2 +
 include/linux/dma-mapping.h |   6 +-
 kernel/dma/direct.c         |  10 +--
 kernel/dma/pool.c           | 120 +++++++++++++++++++++++-------------
 5 files changed, 90 insertions(+), 53 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 76bd2309e023..b642c1123a29 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -927,7 +927,7 @@ static void __iommu_dma_free(struct device *dev, size_t size, void *cpu_addr)
 
 	/* Non-coherent atomic allocation? Easy */
 	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-	    dma_free_from_pool(cpu_addr, alloc_size))
+	    dma_free_from_pool(dev, cpu_addr, alloc_size))
 		return;
 
 	if (IS_ENABLED(CONFIG_DMA_REMAP) && is_vmalloc_addr(cpu_addr)) {
@@ -1010,7 +1010,8 @@ static void *iommu_dma_alloc(struct device *dev, size_t size,
 
 	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
 	    !gfpflags_allow_blocking(gfp) && !coherent)
-		cpu_addr = dma_alloc_from_pool(PAGE_ALIGN(size), &page, gfp);
+		cpu_addr = dma_alloc_from_pool(dev, PAGE_ALIGN(size), &page,
+					       gfp);
 	else
 		cpu_addr = iommu_dma_alloc_pages(dev, size, &page, gfp, attrs);
 	if (!cpu_addr)
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index 6db863c3eb93..fb5ec847ddf3 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -66,6 +66,8 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 }
 
 u64 dma_direct_get_required_mask(struct device *dev);
+gfp_t dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
+				  u64 *phys_mask);
 void *dma_direct_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void dma_direct_free(struct device *dev, size_t size, void *cpu_addr,
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 4d450672b7d6..e4be706d8f5e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -633,9 +633,9 @@ void *dma_common_pages_remap(struct page **pages, size_t size,
 			pgprot_t prot, const void *caller);
 void dma_common_free_remap(void *cpu_addr, size_t size);
 
-bool dma_in_atomic_pool(void *start, size_t size);
-void *dma_alloc_from_pool(size_t size, struct page **ret_page, gfp_t flags);
-bool dma_free_from_pool(void *start, size_t size);
+void *dma_alloc_from_pool(struct device *dev, size_t size,
+			  struct page **ret_page, gfp_t flags);
+bool dma_free_from_pool(struct device *dev, void *start, size_t size);
 
 int
 dma_common_get_sgtable(struct device *dev, struct sg_table *sgt, void *cpu_addr,
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index d30c5468a91a..38266fb2797d 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -58,8 +58,8 @@ u64 dma_direct_get_required_mask(struct device *dev)
 	return (1ULL << (fls64(max_dma) - 1)) * 2 - 1;
 }
 
-static gfp_t __dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
-		u64 *phys_mask)
+gfp_t dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
+				  u64 *phys_mask)
 {
 	if (dev->bus_dma_mask && dev->bus_dma_mask < dma_mask)
 		dma_mask = dev->bus_dma_mask;
@@ -103,7 +103,7 @@ struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 
 	/* we always manually zero the memory once we are done: */
 	gfp &= ~__GFP_ZERO;
-	gfp |= __dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
+	gfp |= dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
 			&phys_mask);
 	page = dma_alloc_contiguous(dev, alloc_size, gfp);
 	if (page && !dma_coherent_ok(dev, page_to_phys(page), size)) {
@@ -142,7 +142,7 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
 	    dma_alloc_need_uncached(dev, attrs) &&
 	    !gfpflags_allow_blocking(gfp)) {
-		ret = dma_alloc_from_pool(PAGE_ALIGN(size), &page, gfp);
+		ret = dma_alloc_from_pool(dev, PAGE_ALIGN(size), &page, gfp);
 		if (!ret)
 			return NULL;
 		goto done;
@@ -225,7 +225,7 @@ void dma_direct_free_pages(struct device *dev, size_t size, void *cpu_addr,
 	}
 
 	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
-	    dma_free_from_pool(cpu_addr, PAGE_ALIGN(size)))
+	    dma_free_from_pool(dev, cpu_addr, PAGE_ALIGN(size)))
 		return;
 
 	if (force_dma_unencrypted(dev))
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 3df5d9d39922..db4f89ac5f5f 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -10,7 +10,9 @@
 #include <linux/genalloc.h>
 #include <linux/slab.h>
 
-static struct gen_pool *atomic_pool __ro_after_init;
+static struct gen_pool *atomic_pool_dma __ro_after_init;
+static struct gen_pool *atomic_pool_dma32 __ro_after_init;
+static struct gen_pool *atomic_pool_kernel __ro_after_init;
 
 #define DEFAULT_DMA_COHERENT_POOL_SIZE  SZ_256K
 static size_t atomic_pool_size __initdata = DEFAULT_DMA_COHERENT_POOL_SIZE;
@@ -22,89 +24,119 @@ static int __init early_coherent_pool(char *p)
 }
 early_param("coherent_pool", early_coherent_pool);
 
-static gfp_t dma_atomic_pool_gfp(void)
+static int __init __dma_atomic_pool_init(struct gen_pool **pool,
+					 size_t pool_size, gfp_t gfp)
 {
-	if (IS_ENABLED(CONFIG_ZONE_DMA))
-		return GFP_DMA;
-	if (IS_ENABLED(CONFIG_ZONE_DMA32))
-		return GFP_DMA32;
-	return GFP_KERNEL;
-}
-
-static int __init dma_atomic_pool_init(void)
-{
-	unsigned int pool_size_order = get_order(atomic_pool_size);
-	unsigned long nr_pages = atomic_pool_size >> PAGE_SHIFT;
+	const unsigned int order = get_order(pool_size);
+	const unsigned long nr_pages = pool_size >> PAGE_SHIFT;
 	struct page *page;
 	void *addr;
 	int ret;
 
 	if (dev_get_cma_area(NULL))
-		page = dma_alloc_from_contiguous(NULL, nr_pages,
-						 pool_size_order, false);
+		page = dma_alloc_from_contiguous(NULL, nr_pages, order, false);
 	else
-		page = alloc_pages(dma_atomic_pool_gfp(), pool_size_order);
+		page = alloc_pages(gfp, order);
 	if (!page)
 		goto out;
 
-	arch_dma_prep_coherent(page, atomic_pool_size);
+	arch_dma_prep_coherent(page, pool_size);
 
-	atomic_pool = gen_pool_create(PAGE_SHIFT, -1);
-	if (!atomic_pool)
+	*pool = gen_pool_create(PAGE_SHIFT, -1);
+	if (!*pool)
 		goto free_page;
 
-	addr = dma_common_contiguous_remap(page, atomic_pool_size,
+	addr = dma_common_contiguous_remap(page, pool_size,
 					   pgprot_dmacoherent(PAGE_KERNEL),
 					   __builtin_return_address(0));
 	if (!addr)
 		goto destroy_genpool;
 
-	ret = gen_pool_add_virt(atomic_pool, (unsigned long)addr,
-				page_to_phys(page), atomic_pool_size, -1);
+	ret = gen_pool_add_virt(*pool, (unsigned long)addr, page_to_phys(page),
+				pool_size, -1);
 	if (ret)
 		goto remove_mapping;
-	gen_pool_set_algo(atomic_pool, gen_pool_first_fit_order_align, NULL);
+	gen_pool_set_algo(*pool, gen_pool_first_fit_order_align, NULL);
 
-	pr_info("DMA: preallocated %zu KiB pool for atomic allocations\n",
-		atomic_pool_size / 1024);
+	pr_info("DMA: preallocated %zu KiB %pGg pool for atomic allocations\n",
+		pool_size >> 10, &gfp);
 	return 0;
 
 remove_mapping:
-	dma_common_free_remap(addr, atomic_pool_size);
+	dma_common_free_remap(addr, pool_size);
 destroy_genpool:
-	gen_pool_destroy(atomic_pool);
-	atomic_pool = NULL;
+	gen_pool_destroy(*pool);
+	*pool = NULL;
 free_page:
 	if (!dma_release_from_contiguous(NULL, page, nr_pages))
-		__free_pages(page, pool_size_order);
+		__free_pages(page, order);
 out:
-	pr_err("DMA: failed to allocate %zu KiB pool for atomic coherent allocation\n",
-		atomic_pool_size / 1024);
+	pr_err("DMA: failed to allocate %zu KiB %pGg pool for atomic allocation\n",
+	       pool_size >> 10, &gfp);
 	return -ENOMEM;
 }
+
+static int __init dma_atomic_pool_init(void)
+{
+	int ret = 0;
+	int err;
+
+	ret = __dma_atomic_pool_init(&atomic_pool_kernel, atomic_pool_size,
+				     GFP_KERNEL);
+	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
+		err = __dma_atomic_pool_init(&atomic_pool_dma,
+					     atomic_pool_size, GFP_DMA);
+		if (!ret && err)
+			ret = err;
+	}
+	if (IS_ENABLED(CONFIG_ZONE_DMA32)) {
+		err = __dma_atomic_pool_init(&atomic_pool_dma32,
+					     atomic_pool_size, GFP_DMA32);
+		if (!ret && err)
+			ret = err;
+	}
+	return ret;
+}
 postcore_initcall(dma_atomic_pool_init);
 
-bool dma_in_atomic_pool(void *start, size_t size)
+static inline struct gen_pool *dev_to_pool(struct device *dev)
 {
-	if (unlikely(!atomic_pool))
-		return false;
+	u64 phys_mask;
+	gfp_t gfp;
+
+	gfp = dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
+					  &phys_mask);
+	if (IS_ENABLED(CONFIG_ZONE_DMA) && gfp == GFP_DMA)
+		return atomic_pool_dma;
+	if (IS_ENABLED(CONFIG_ZONE_DMA32) && gfp == GFP_DMA32)
+		return atomic_pool_dma32;
+	return atomic_pool_kernel;
+}
 
-	return gen_pool_has_addr(atomic_pool, (unsigned long)start, size);
+static bool dma_in_atomic_pool(struct device *dev, void *start, size_t size)
+{
+	struct gen_pool *pool = dev_to_pool(dev);
+
+	if (unlikely(!pool))
+		return false;
+	return gen_pool_has_addr(pool, (unsigned long)start, size);
 }
 
-void *dma_alloc_from_pool(size_t size, struct page **ret_page, gfp_t flags)
+void *dma_alloc_from_pool(struct device *dev, size_t size,
+			  struct page **ret_page, gfp_t flags)
 {
+	struct gen_pool *pool = dev_to_pool(dev);
 	unsigned long val;
 	void *ptr = NULL;
 
-	if (!atomic_pool) {
-		WARN(1, "coherent pool not initialised!\n");
+	if (!pool) {
+		WARN(1, "%pGg atomic pool not initialised!\n", &flags);
 		return NULL;
 	}
 
-	val = gen_pool_alloc(atomic_pool, size);
+	val = gen_pool_alloc(pool, size);
 	if (val) {
-		phys_addr_t phys = gen_pool_virt_to_phys(atomic_pool, val);
+		phys_addr_t phys = gen_pool_virt_to_phys(pool, val);
 
 		*ret_page = pfn_to_page(__phys_to_pfn(phys));
 		ptr = (void *)val;
@@ -114,10 +146,12 @@ void *dma_alloc_from_pool(size_t size, struct page **ret_page, gfp_t flags)
 	return ptr;
 }
 
-bool dma_free_from_pool(void *start, size_t size)
+bool dma_free_from_pool(struct device *dev, void *start, size_t size)
 {
-	if (!dma_in_atomic_pool(start, size))
+	struct gen_pool *pool = dev_to_pool(dev);
+
+	if (!dma_in_atomic_pool(dev, start, size))
 		return false;
-	gen_pool_free(atomic_pool, (unsigned long)start, size);
+	gen_pool_free(pool, (unsigned long)start, size);
 	return true;
 }
-- 
2.28.0.618.gf4bc123cb7-goog

