Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F46278E48
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 18:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgIYQUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 12:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgIYQUi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 12:20:38 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F42C0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:38 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id x191so2326157qkb.3
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 09:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=QGrTf3r0PMi2PqL3YGN6cH3ZNN+zA8nvEnO7ohBFfOE=;
        b=D6LsD0wXBAz1bkgAIMbMCR2M1876YiLlbRyl6jhcZT/nFhKXEFVX349o6BH7Up3RxE
         8o8gq0xUoEdsUlxM1OMsVDryqh7rFG5/ocVzrOt1h6jaTmpBVjbX7xh9Xja/t4ILkrI3
         c+Z3FCWDGQkBBL+Eo6N0G+llgdTHaM1QXoh4yQSiue1rHCXyuhWTzsEXN1F/dU0AfcJI
         VmvedGa8608MVbgpHuJa500VGJTbHgvg0cUG46Dpmx3WhX1t+XPMFAz912XDJtxJfJdI
         RP8zTXot7QeyLHNrUR+m+7uUOxQw9cP6bmF6qzh2A8hYf7Q/BEGi78z+l1K2gZ5l7rfY
         9VwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QGrTf3r0PMi2PqL3YGN6cH3ZNN+zA8nvEnO7ohBFfOE=;
        b=V0DPyjHFXhABjAFVFHkH3Bw3qX4+ndeeb30Q9edEjSq8M6kib2LwcMKszl99jcP79Q
         +UWIfjpt18z4w1fXHcM3QYSOzXBxXhBf4dFkTKZkAQgufINwShGMM3abnYPQ0Wt/gHpI
         PJUul7TQqZACnzyCYdWxKLa3PzDY8Sc5xFqshebgQvJ0xYMGw4GCS3MjqeZnk4uGUEu9
         vdC3zEOrVtxnUz0DvkmzHu59Yxe40co0xHbpFv78IPZx/cFHU+8FMW4LJeanYduKh83s
         FL/1Bmsb9PrWJBE+WzshhSYpBFWDQQh/5pM6+NTbEnTYoFetR6bnMEIi4f9fRkrPpYYn
         w3Nw==
X-Gm-Message-State: AOAM530g2nrWPVv/TCDI7mvVhDSxe1l45zOnJuRgXqdKiCr8nHT89PHD
        HORyr+cwdZtDQeYYryXnJe6j+SbtLyftiWOtKvdFMaHDx3HWYTEokDdmz4wcZ7nLxKEqeDvcwAH
        kDED3b8MerRDnfDrls/2kYqJAW7oNpGABpi0e1bxMtRiWCo1s5qa/fZ7BbeWFnQ==
X-Google-Smtp-Source: ABdhPJzYn4jXNM+hltx74NrVe4/4wZg6C8NXZ27vZGAeljYsYaRh3AjiBwFrR+MLFRJ0SBu7b4/q3Vm2U9A=
Sender: "pgonda via sendgmr" <pgonda@pgonda1.kir.corp.google.com>
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:1101:f693:9fff:fef4:e3a2])
 (user=pgonda job=sendgmr) by 2002:ad4:4891:: with SMTP id bv17mr61751qvb.27.1601050837620;
 Fri, 25 Sep 2020 09:20:37 -0700 (PDT)
Date:   Fri, 25 Sep 2020 09:19:13 -0700
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Message-Id: <20200925161916.204667-28-pgonda@google.com>
Mime-Version: 1.0
References: <20200925161916.204667-1-pgonda@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 27/30 for 5.4] dma-pool: make sure atomic pool suits device
From:   Peter Gonda <pgonda@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

upstream 81e9d894e03f9a279102c7aac62ea7cbf9949f4b commit.

When allocating DMA memory from a pool, the core can only guess which
atomic pool will fit a device's constraints. If it doesn't, get a safer
atomic pool and try again.

Fixes: c84dc6e68a1d ("dma-pool: add additional coherent pools to map to gfp mask")
Reported-by: Jeremy Linton <jeremy.linton@arm.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 kernel/dma/pool.c | 57 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 5b9eaa2b498d..d48d9acb585f 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -240,39 +240,56 @@ static inline struct gen_pool *dma_guess_pool(struct device *dev,
 void *dma_alloc_from_pool(struct device *dev, size_t size,
 			  struct page **ret_page, gfp_t flags)
 {
-	struct gen_pool *pool = dma_guess_pool(dev, NULL);
-	unsigned long val;
+	struct gen_pool *pool = NULL;
+	unsigned long val = 0;
 	void *ptr = NULL;
-
-	if (!pool) {
-		WARN(1, "%pGg atomic pool not initialised!\n", &flags);
-		return NULL;
+	phys_addr_t phys;
+
+	while (1) {
+		pool = dma_guess_pool(dev, pool);
+		if (!pool) {
+			WARN(1, "Failed to get suitable pool for %s\n",
+			     dev_name(dev));
+			break;
+		}
+
+		val = gen_pool_alloc(pool, size);
+		if (!val)
+			continue;
+
+		phys = gen_pool_virt_to_phys(pool, val);
+		if (dma_coherent_ok(dev, phys, size))
+			break;
+
+		gen_pool_free(pool, val, size);
+		val = 0;
 	}
 
-	val = gen_pool_alloc(pool, size);
-	if (likely(val)) {
-		phys_addr_t phys = gen_pool_virt_to_phys(pool, val);
 
+	if (val) {
 		*ret_page = pfn_to_page(__phys_to_pfn(phys));
 		ptr = (void *)val;
 		memset(ptr, 0, size);
-	} else {
-		WARN_ONCE(1, "DMA coherent pool depleted, increase size "
-			     "(recommended min coherent_pool=%zuK)\n",
-			  gen_pool_size(pool) >> 9);
+
+		if (gen_pool_avail(pool) < atomic_pool_size)
+			schedule_work(&atomic_pool_work);
 	}
-	if (gen_pool_avail(pool) < atomic_pool_size)
-		schedule_work(&atomic_pool_work);
 
 	return ptr;
 }
 
 bool dma_free_from_pool(struct device *dev, void *start, size_t size)
 {
-	struct gen_pool *pool = dma_guess_pool(dev, NULL);
+	struct gen_pool *pool = NULL;
 
-	if (!pool || !gen_pool_has_addr(pool, (unsigned long)start, size))
-		return false;
-	gen_pool_free(pool, (unsigned long)start, size);
-	return true;
+	while (1) {
+		pool = dma_guess_pool(dev, pool);
+		if (!pool)
+			return false;
+
+		if (gen_pool_has_addr(pool, (unsigned long)start, size)) {
+			gen_pool_free(pool, (unsigned long)start, size);
+			return true;
+		}
+	}
 }
-- 
2.28.0.618.gf4bc123cb7-goog

