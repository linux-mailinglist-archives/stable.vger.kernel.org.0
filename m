Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80450278E2B
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgIYQUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbgIYQUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CC3C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l67so3120563ybb.7
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=3A+/kwzGbO/TAxL8eCr39Bh+YR+CW2CNiJ25hfgv7AM=;
        b=E4CpmiObQbaVWXASFuBIEhScN4cOn3u2FQYr3TsoOZmgpYJlEJD163aKvgLei0jnsp
         ncVtNYkHgCdqHDncNIZVGmSKpmXGDRID0UwFs7Nh7Qxb1c292gsaExZt/+rhPVk3kEyj
         svgq+DFHAtw6FVZs1BaD0JdNO6Yj885SmmKUTrOkwvyGk5IjH1t1AL493qE+noc9QoWm
         r04ZNggsCxVWxY1cn9+pitLsfl4JYDhstciI5ozex9fYsRFjFIIf+7CcqmJcv0p4r4EF
         zmgCtP05pzWOW/VR4eFRIDP4tLGyrfTTdhC7FoJeSOnwt9AnfM8nMfdB8ggGJY65R7U7
         ybIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3A+/kwzGbO/TAxL8eCr39Bh+YR+CW2CNiJ25hfgv7AM=;
        b=riWr3jSbla01xtbpacYnSIsjxDMszVHA7AYuLuWF3MQ8H6T69GqOhoYH/xPw6g8Bc/
         qCyOiK18ILLvLt85SO59EUp34v4IBumlWB9ePkX5QHyS1qlf9zQHkB9Fhgyb0psXVSTp
         ZY7Oqu6LEuM54UirpAvnfSlOsVnTqrdYeLu8VCMO/FC/0nAdoYn1pFXMw9dpRUrRk7et
         17yWk3wUGyz0PfNe+xmmuEb/30a+8yHHr8YkVJ9EapRD5LJAJwvVI8j9b2WI837npsT4
         RB7kd+j0Dn2Bwyhx/vsY5hm99eudV+8WKLVRcFky2ZpCA2kM2qJc6XZY10CCvAxqnUGR
         tt8g==
X-Gm-Message-State: AOAM531+q34/o0QAnZZ9KfLJjssM3ASLXKOoWAd4TFXyUPqY09Ia2zMm
        N/Cq0sjrPl3xmp0IbqQiJ3kANy0BfH92mdXoAAR0PuPvBcTtfADFrzV5GOyNPlZiljXas4rPlaJ
        WS1pX1ts5wuRora0+98oc8Ss3rmDGKa9U4wEug7Hz+3YkrB6EywMpqKfho+Veqw==
X-Google-Smtp-Source: ABdhPJxEpju4oPLchgTv+HVrE4kvlkFAhgXU0A37m071Y61Nbj2s0khlV8u53RrwAdoFG+f1K9WeiihAe0M=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:a25:ab8e:: with SMTP id v14mr6541576ybi.465.1601050804635;
 Fri, 25 Sep 2020 09:20:04 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:18:54 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-9-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 08/30 for 5.4] dma-pool: dynamically expanding atomic pools
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

upstream 54adadf9b08571fb8b11dc9d0d3a2ddd39825efd commit.

When an atomic pool becomes fully depleted because it is now relied upon
for all non-blocking allocations through the DMA API, allow background
expansion of each pool by a kworker.

When an atomic pool has less than the default size of memory left, kick
off a kworker to dynamically expand the pool in the background.  The pool
is doubled in size, up to MAX_ORDER-1.  If memory cannot be allocated at
the requested order, smaller allocation(s) are attempted.

This allows the default size to be kept quite low when one or more of the
atomic pools is not used.

Allocations for lowmem should also use GFP_KERNEL for the benefits of
reclaim, so use GFP_KERNEL | GFP_DMA and GFP_KERNEL | GFP_DMA32 for
lowmem allocations.

This also allows __dma_atomic_pool_init() to return a pointer to the pool
to make initialization cleaner.

Also switch over some node ids to the more appropriate NUMA_NO_NODE.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/pool.c | 122 +++++++++++++++++++++++++++++++---------------
 1 file changed, 84 insertions(+), 38 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index db4f89ac5f5f..ffe866c2c034 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -9,13 +9,17 @@
 #include <linux/init.h>
 #include <linux/genalloc.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 static struct gen_pool *atomic_pool_dma __ro_after_init;
 static struct gen_pool *atomic_pool_dma32 __ro_after_init;
 static struct gen_pool *atomic_pool_kernel __ro_after_init;
 
 #define DEFAULT_DMA_COHERENT_POOL_SIZE  SZ_256K
-static size_t atomic_pool_size __initdata = DEFAULT_DMA_COHERENT_POOL_SIZE;
+static size_t atomic_pool_size = DEFAULT_DMA_COHERENT_POOL_SIZE;
+
+/* Dynamic background expansion when the atomic pool is near capacity */
+static struct work_struct atomic_pool_work;
 
 static int __init early_coherent_pool(char *p)
 {
@@ -24,76 +28,116 @@ static int __init early_coherent_pool(char *p)
 }
 early_param("coherent_pool", early_coherent_pool);
 
-static int __init __dma_atomic_pool_init(struct gen_pool **pool,
-					 size_t pool_size, gfp_t gfp)
+static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
+			      gfp_t gfp)
 {
-	const unsigned int order = get_order(pool_size);
-	const unsigned long nr_pages = pool_size >> PAGE_SHIFT;
+	unsigned int order;
 	struct page *page;
 	void *addr;
-	int ret;
+	int ret = -ENOMEM;
+
+	/* Cannot allocate larger than MAX_ORDER-1 */
+	order = min(get_order(pool_size), MAX_ORDER-1);
+
+	do {
+		pool_size = 1 << (PAGE_SHIFT + order);
 
-	if (dev_get_cma_area(NULL))
-		page = dma_alloc_from_contiguous(NULL, nr_pages, order, false);
-	else
-		page = alloc_pages(gfp, order);
+		if (dev_get_cma_area(NULL))
+			page = dma_alloc_from_contiguous(NULL, 1 << order,
+							 order, false);
+		else
+			page = alloc_pages(gfp, order);
+	} while (!page && order-- > 0);
 	if (!page)
 		goto out;
 
 	arch_dma_prep_coherent(page, pool_size);
 
-	*pool = gen_pool_create(PAGE_SHIFT, -1);
-	if (!*pool)
-		goto free_page;
-
 	addr = dma_common_contiguous_remap(page, pool_size,
 					   pgprot_dmacoherent(PAGE_KERNEL),
 					   __builtin_return_address(0));
 	if (!addr)
-		goto destroy_genpool;
+		goto free_page;
 
-	ret = gen_pool_add_virt(*pool, (unsigned long)addr, page_to_phys(page),
-				pool_size, -1);
+	ret = gen_pool_add_virt(pool, (unsigned long)addr, page_to_phys(page),
+				pool_size, NUMA_NO_NODE);
 	if (ret)
 		goto remove_mapping;
-	gen_pool_set_algo(*pool, gen_pool_first_fit_order_align, NULL);
 
-	pr_info("DMA: preallocated %zu KiB %pGg pool for atomic allocations\n",
-		pool_size >> 10, &gfp);
 	return 0;
 
 remove_mapping:
 	dma_common_free_remap(addr, pool_size);
-destroy_genpool:
-	gen_pool_destroy(*pool);
-	*pool = NULL;
 free_page:
-	if (!dma_release_from_contiguous(NULL, page, nr_pages))
+	if (!dma_release_from_contiguous(NULL, page, 1 << order))
 		__free_pages(page, order);
 out:
-	pr_err("DMA: failed to allocate %zu KiB %pGg pool for atomic allocation\n",
-	       pool_size >> 10, &gfp);
-	return -ENOMEM;
+	return ret;
+}
+
+static void atomic_pool_resize(struct gen_pool *pool, gfp_t gfp)
+{
+	if (pool && gen_pool_avail(pool) < atomic_pool_size)
+		atomic_pool_expand(pool, gen_pool_size(pool), gfp);
+}
+
+static void atomic_pool_work_fn(struct work_struct *work)
+{
+	if (IS_ENABLED(CONFIG_ZONE_DMA))
+		atomic_pool_resize(atomic_pool_dma,
+				   GFP_KERNEL | GFP_DMA);
+	if (IS_ENABLED(CONFIG_ZONE_DMA32))
+		atomic_pool_resize(atomic_pool_dma32,
+				   GFP_KERNEL | GFP_DMA32);
+	atomic_pool_resize(atomic_pool_kernel, GFP_KERNEL);
+}
+
+static __init struct gen_pool *__dma_atomic_pool_init(size_t pool_size,
+						      gfp_t gfp)
+{
+	struct gen_pool *pool;
+	int ret;
+
+	pool = gen_pool_create(PAGE_SHIFT, NUMA_NO_NODE);
+	if (!pool)
+		return NULL;
+
+	gen_pool_set_algo(pool, gen_pool_first_fit_order_align, NULL);
+
+	ret = atomic_pool_expand(pool, pool_size, gfp);
+	if (ret) {
+		gen_pool_destroy(pool);
+		pr_err("DMA: failed to allocate %zu KiB %pGg pool for atomic allocation\n",
+		       pool_size >> 10, &gfp);
+		return NULL;
+	}
+
+	pr_info("DMA: preallocated %zu KiB %pGg pool for atomic allocations\n",
+		gen_pool_size(pool) >> 10, &gfp);
+	return pool;
 }
 
 static int __init dma_atomic_pool_init(void)
 {
 	int ret = 0;
-	int err;
 
-	ret = __dma_atomic_pool_init(&atomic_pool_kernel, atomic_pool_size,
-				     GFP_KERNEL);
+	INIT_WORK(&atomic_pool_work, atomic_pool_work_fn);
+
+	atomic_pool_kernel = __dma_atomic_pool_init(atomic_pool_size,
+						    GFP_KERNEL);
+	if (!atomic_pool_kernel)
+		ret = -ENOMEM;
 	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
-		err = __dma_atomic_pool_init(&atomic_pool_dma,
-					     atomic_pool_size, GFP_DMA);
-		if (!ret && err)
-			ret = err;
+		atomic_pool_dma = __dma_atomic_pool_init(atomic_pool_size,
+						GFP_KERNEL | GFP_DMA);
+		if (!atomic_pool_dma)
+			ret = -ENOMEM;
 	}
 	if (IS_ENABLED(CONFIG_ZONE_DMA32)) {
-		err = __dma_atomic_pool_init(&atomic_pool_dma32,
-					     atomic_pool_size, GFP_DMA32);
-		if (!ret && err)
-			ret = err;
+		atomic_pool_dma32 = __dma_atomic_pool_init(atomic_pool_size,
+						GFP_KERNEL | GFP_DMA32);
+		if (!atomic_pool_dma32)
+			ret = -ENOMEM;
 	}
 	return ret;
 }
@@ -142,6 +186,8 @@ void *dma_alloc_from_pool(struct device *dev, size_t size,
 		ptr = (void *)val;
 		memset(ptr, 0, size);
 	}
+	if (gen_pool_avail(pool) < atomic_pool_size)
+		schedule_work(&atomic_pool_work);
 
 	return ptr;
 }
-- 
2.28.0.618.gf4bc123cb7-goog

