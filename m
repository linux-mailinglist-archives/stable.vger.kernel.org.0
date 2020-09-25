Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B8C278E4A
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgIYQUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgIYQUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:42 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4201C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:41 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id r128so2315241qkc.9
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=AUpfkt2xojASMSGKeOD+2WcTVbK452VwDmDVXXefo+U=;
        b=IwKMVy/BGjREy+F3yRAk3UIyrS8muqOxdhWNx2GVP2lE2BZfE0Q/EDh7f3rACttR2m
         4FVllaQIx0IKwTgtm719jOp2lI9Fhdw2HJtJ1lf6Kz9tz7Wl49lvAtKmQZ9z529tXxS8
         +yyLNbKVSnPItmbrX/ncfoMA1Ud4cDuOh77TnmScrvAOgOX2Rle/XIZMr/u9+4NQfTUM
         y0e8JjvI8/AtiIa19O2aeS30uRGJpGHUU963tTtqh2GKehFiaklb2+kFY7lUfYoPEmR/
         nmaoOmruQjFEK8XycGzsuUeLxIok4CiGZ5V3R8HMXchzT25Nk/sTmDXHpMzh27GUSEfK
         HWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AUpfkt2xojASMSGKeOD+2WcTVbK452VwDmDVXXefo+U=;
        b=rmSE41LwVsCVNTD87+wQqQX3HnyYf3lp3NOm55w5OmQRiwG4Z7Bd+X6AMxkCvhEHGY
         1LgY5NHU1t7TxJm12cEZh/bqScyL8xjIMwNH5l9i9xpDZYDEFwdCU7cN1fAmMGHTZchG
         OodOtrV2SmImNIfTDqXq5PAljINIpC/Po2P34gldt22xhmtIHUp+J0IRGxxIwbFSIguA
         uAZGQ3teOEY126QOdwHzYSkB0+EtFGmDwpjmrc8ttPnJi9uEapWqf2uQukD24na5yCUn
         uQmgkuornacGMU9HHfdUisJcDbJ6Q88Bfw+AvO+seGVdzJYSLK45k5DNElsr+RXfdU6V
         Lp1A==
X-Gm-Message-State: AOAM532XOE9ofcEgWMU3DY7eEt1NkLfP99R5VrP9JYFPD5vxvkB6k60Z
        zZwYq9KguG+fe1W85jD+wfL1JY0dLe80ZCG2e5J3rHBMOwTa6vXta4VTo5Gw154sRwAQK0ky2RB
        RgQVLDUeIX9iV8eWiennazvqPbJNA1iTz7h1qI8KdmCbMaVQij7jjb8lH34x8Aw==
X-Google-Smtp-Source: ABdhPJz1zmGA0xDHdI4rLCTY3152xAMoNPwZiz60hcSACf7n+3rXEnoshGcBvDgSARTU4ylT8/E9c8mDF6o=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a0c:8f02:: with SMTP id z2mr166804qvd.21.1601050840933;
 Fri, 25 Sep 2020 09:20:40 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:15 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-30-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 29/30 for 5.4] dma-pool: fix coherent pool allocations for
 IOMMU mappings
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Christoph Hellwig <hch@lst.de>,
        Amit Pundir <amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

upstream 9420139f516d7fbc248ce17f35275cb005ed98ea commit.

When allocating coherent pool memory for an IOMMU mapping we don't care
about the DMA mask.  Move the guess for the initial GFP mask into the
dma_direct_alloc_pages and pass dma_coherent_ok as a function pointer
argument so that it doesn't get applied to the IOMMU case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Amit Pundir <amit.pundir@linaro.org>
Change-Id: I343ae38a73135948f8f8bb9ae9a12034c7d4c405
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 drivers/iommu/dma-iommu.c   |   4 +-
 include/linux/dma-direct.h  |   3 -
 include/linux/dma-mapping.h |   5 +-
 kernel/dma/direct.c         |  11 +++-
 kernel/dma/pool.c           | 114 +++++++++++++++---------------------
 5 files changed, 61 insertions(+), 76 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index b642c1123a29..f917bd10f47c 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1010,8 +1010,8 @@ static void *iommu_dma_alloc(struct device *dev, size_t size,
 
 	if (IS_ENABLED(CONFIG_DMA_DIRECT_REMAP) &&
 	    !gfpflags_allow_blocking(gfp) && !coherent)
-		cpu_addr = dma_alloc_from_pool(dev, PAGE_ALIGN(size), &page,
-					       gfp);
+		page = dma_alloc_from_pool(dev, PAGE_ALIGN(size), &cpu_addr,
+					       gfp, NULL);
 	else
 		cpu_addr = iommu_dma_alloc_pages(dev, size, &page, gfp, attrs);
 	if (!cpu_addr)
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index 8ccddee1f78a..6db863c3eb93 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -66,9 +66,6 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 }
 
 u64 dma_direct_get_required_mask(struct device *dev);
-gfp_t dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
-				  u64 *phys_mask);
-bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size);
 void *dma_direct_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void dma_direct_free(struct device *dev, size_t size, void *cpu_addr,
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index e4be706d8f5e..246a4b429612 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -633,8 +633,9 @@ void *dma_common_pages_remap(struct page **pages, size_t size,
 			pgprot_t prot, const void *caller);
 void dma_common_free_remap(void *cpu_addr, size_t size);
 
-void *dma_alloc_from_pool(struct device *dev, size_t size,
-			  struct page **ret_page, gfp_t flags);
+struct page *dma_alloc_from_pool(struct device *dev, size_t size,
+		void **cpu_addr, gfp_t flags,
+		bool (*phys_addr_ok)(struct device *, phys_addr_t, size_t));
 bool dma_free_from_pool(struct device *dev, void *start, size_t size);
 
 int
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 54c1c3a20c09..71be82b07743 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -84,7 +84,7 @@ gfp_t dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
 	return 0;
 }
 
-bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size)
+static bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size)
 {
 	return phys_to_dma_direct(dev, phys) + size - 1 <=
 			min_not_zero(dev->coherent_dma_mask, dev->bus_dma_mask);
@@ -177,8 +177,13 @@ void *dma_direct_alloc_pages(struct device *dev, size_t size,
 	size = PAGE_ALIGN(size);
 
 	if (dma_should_alloc_from_pool(dev, gfp, attrs)) {
-		ret = dma_alloc_from_pool(dev, size, &page, gfp);
-		if (!ret)
+		u64 phys_mask;
+
+		gfp |= dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
+				&phys_mask);
+		page = dma_alloc_from_pool(dev, size, &ret, gfp,
+				dma_coherent_ok);
+		if (!page)
 			return NULL;
 		goto done;
 	}
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 6bc74a2d5127..5d071d4a3cba 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -196,93 +196,75 @@ static int __init dma_atomic_pool_init(void)
 }
 postcore_initcall(dma_atomic_pool_init);
 
-static inline struct gen_pool *dma_guess_pool_from_device(struct device *dev)
+static inline struct gen_pool *dma_guess_pool(struct gen_pool *prev, gfp_t gfp)
 {
-	u64 phys_mask;
-	gfp_t gfp;
-
-	gfp = dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
-					  &phys_mask);
-	if (IS_ENABLED(CONFIG_ZONE_DMA) && gfp == GFP_DMA)
+	if (prev == NULL) {
+		if (IS_ENABLED(CONFIG_ZONE_DMA32) && (gfp & GFP_DMA32))
+			return atomic_pool_dma32;
+		if (IS_ENABLED(CONFIG_ZONE_DMA) && (gfp & GFP_DMA))
+			return atomic_pool_dma;
+		return atomic_pool_kernel;
+	}
+	if (prev == atomic_pool_kernel)
+		return atomic_pool_dma32 ? atomic_pool_dma32 : atomic_pool_dma;
+	if (prev == atomic_pool_dma32)
 		return atomic_pool_dma;
-	if (IS_ENABLED(CONFIG_ZONE_DMA32) && gfp == GFP_DMA32)
-		return atomic_pool_dma32;
-	return atomic_pool_kernel;
+	return NULL;
 }
 
-static inline struct gen_pool *dma_get_safer_pool(struct gen_pool *bad_pool)
+static struct page *__dma_alloc_from_pool(struct device *dev, size_t size,
+		struct gen_pool *pool, void **cpu_addr,
+		bool (*phys_addr_ok)(struct device *, phys_addr_t, size_t))
 {
-	if (bad_pool == atomic_pool_kernel)
-		return atomic_pool_dma32 ? : atomic_pool_dma;
+	unsigned long addr;
+	phys_addr_t phys;
 
-	if (bad_pool == atomic_pool_dma32)
-		return atomic_pool_dma;
+	addr = gen_pool_alloc(pool, size);
+	if (!addr)
+		return NULL;
 
-	return NULL;
-}
+	phys = gen_pool_virt_to_phys(pool, addr);
+	if (phys_addr_ok && !phys_addr_ok(dev, phys, size)) {
+		gen_pool_free(pool, addr, size);
+		return NULL;
+	}
 
-static inline struct gen_pool *dma_guess_pool(struct device *dev,
-					      struct gen_pool *bad_pool)
-{
-	if (bad_pool)
-		return dma_get_safer_pool(bad_pool);
+	if (gen_pool_avail(pool) < atomic_pool_size)
+		schedule_work(&atomic_pool_work);
 
-	return dma_guess_pool_from_device(dev);
+	*cpu_addr = (void *)addr;
+	memset(*cpu_addr, 0, size);
+	return pfn_to_page(__phys_to_pfn(phys));
 }
 
-void *dma_alloc_from_pool(struct device *dev, size_t size,
-			  struct page **ret_page, gfp_t flags)
+struct page *dma_alloc_from_pool(struct device *dev, size_t size,
+		void **cpu_addr, gfp_t gfp,
+		bool (*phys_addr_ok)(struct device *, phys_addr_t, size_t))
 {
 	struct gen_pool *pool = NULL;
-	unsigned long val = 0;
-	void *ptr = NULL;
-	phys_addr_t phys;
-
-	while (1) {
-		pool = dma_guess_pool(dev, pool);
-		if (!pool) {
-			WARN(1, "Failed to get suitable pool for %s\n",
-			     dev_name(dev));
-			break;
-		}
-
-		val = gen_pool_alloc(pool, size);
-		if (!val)
-			continue;
-
-		phys = gen_pool_virt_to_phys(pool, val);
-		if (dma_coherent_ok(dev, phys, size))
-			break;
-
-		gen_pool_free(pool, val, size);
-		val = 0;
-	}
-
-
-	if (val) {
-		*ret_page = pfn_to_page(__phys_to_pfn(phys));
-		ptr = (void *)val;
-		memset(ptr, 0, size);
+	struct page *page;
 
-		if (gen_pool_avail(pool) < atomic_pool_size)
-			schedule_work(&atomic_pool_work);
+	while ((pool = dma_guess_pool(pool, gfp))) {
+		page = __dma_alloc_from_pool(dev, size, pool, cpu_addr,
+					     phys_addr_ok);
+		if (page)
+			return page;
 	}
 
-	return ptr;
+	WARN(1, "Failed to get suitable pool for %s\n", dev_name(dev));
+	return NULL;
 }
 
 bool dma_free_from_pool(struct device *dev, void *start, size_t size)
 {
 	struct gen_pool *pool = NULL;
 
-	while (1) {
-		pool = dma_guess_pool(dev, pool);
-		if (!pool)
-			return false;
-
-		if (gen_pool_has_addr(pool, (unsigned long)start, size)) {
-			gen_pool_free(pool, (unsigned long)start, size);
-			return true;
-		}
+	while ((pool = dma_guess_pool(pool, 0))) {
+		if (!gen_pool_has_addr(pool, (unsigned long)start, size))
+			continue;
+		gen_pool_free(pool, (unsigned long)start, size);
+		return true;
 	}
+
+	return false;
 }
-- 
2.28.0.618.gf4bc123cb7-goog

