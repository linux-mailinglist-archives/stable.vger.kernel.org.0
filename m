Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0B0157582
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbgBJMl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:41:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728843AbgBJMl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:27 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 032CC20873;
        Mon, 10 Feb 2020 12:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338487;
        bh=CnqpQwOXnWCec6Ot3O9kXReHUIegihnXYJWXbnOkBzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYyFDI7vT29E6W9ngM3HbGsgrZs6a6ws7LHp1g3KvWmQADbcSzzZPI4fdZKDRzFhs
         ADGTgS+9HOKsxDxedSRzdFD+2PhhiR+/gN7ALYKNz7poOJe3VnV5KJJPpzZ+exMk/1
         9NKke8Q0MOgaeLED8CGGXsqNLqSDYVJ88Q3erzjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.5 268/367] drm/tegra: Reuse IOVA mapping where possible
Date:   Mon, 10 Feb 2020 04:33:01 -0800
Message-Id: <20200210122449.118749849@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit 273da5a046965ccf0ec79eb63f2d5173467e20fa upstream.

This partially reverts the DMA API support that was recently merged
because it was causing performance regressions on older Tegra devices.
Unfortunately, the cache maintenance performed by dma_map_sg() and
dma_unmap_sg() causes performance to drop by a factor of 10.

The right solution for this would be to cache mappings for buffers per
consumer device, but that's a bit involved. Instead, we simply revert to
the old behaviour of sharing IOVA mappings when we know that devices can
do so (i.e. they share the same IOMMU domain).

Cc: <stable@vger.kernel.org> # v5.5
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/tegra/gem.c   |   10 ++++++++-
 drivers/gpu/drm/tegra/plane.c |   46 +++++++++++++++++++++++-------------------
 drivers/gpu/host1x/job.c      |   32 ++++++++++++++++++++++++++---
 3 files changed, 64 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -60,8 +60,16 @@ static struct sg_table *tegra_bo_pin(str
 	/*
 	 * If we've manually mapped the buffer object through the IOMMU, make
 	 * sure to return the IOVA address of our mapping.
+	 *
+	 * Similarly, for buffers that have been allocated by the DMA API the
+	 * physical address can be used for devices that are not attached to
+	 * an IOMMU. For these devices, callers must pass a valid pointer via
+	 * the @phys argument.
+	 *
+	 * Imported buffers were also already mapped at import time, so the
+	 * existing mapping can be reused.
 	 */
-	if (phys && obj->mm) {
+	if (phys) {
 		*phys = obj->iova;
 		return NULL;
 	}
--- a/drivers/gpu/drm/tegra/plane.c
+++ b/drivers/gpu/drm/tegra/plane.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2017 NVIDIA CORPORATION.  All rights reserved.
  */
 
+#include <linux/iommu.h>
+
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_fourcc.h>
@@ -107,21 +109,27 @@ const struct drm_plane_funcs tegra_plane
 
 static int tegra_dc_pin(struct tegra_dc *dc, struct tegra_plane_state *state)
 {
+	struct iommu_domain *domain = iommu_get_domain_for_dev(dc->dev);
 	unsigned int i;
 	int err;
 
 	for (i = 0; i < state->base.fb->format->num_planes; i++) {
 		struct tegra_bo *bo = tegra_fb_get_plane(state->base.fb, i);
+		dma_addr_t phys_addr, *phys;
+		struct sg_table *sgt;
 
-		if (!dc->client.group) {
-			struct sg_table *sgt;
-
-			sgt = host1x_bo_pin(dc->dev, &bo->base, NULL);
-			if (IS_ERR(sgt)) {
-				err = PTR_ERR(sgt);
-				goto unpin;
-			}
+		if (!domain || dc->client.group)
+			phys = &phys_addr;
+		else
+			phys = NULL;
+
+		sgt = host1x_bo_pin(dc->dev, &bo->base, phys);
+		if (IS_ERR(sgt)) {
+			err = PTR_ERR(sgt);
+			goto unpin;
+		}
 
+		if (sgt) {
 			err = dma_map_sg(dc->dev, sgt->sgl, sgt->nents,
 					 DMA_TO_DEVICE);
 			if (err == 0) {
@@ -143,7 +151,7 @@ static int tegra_dc_pin(struct tegra_dc
 			state->iova[i] = sg_dma_address(sgt->sgl);
 			state->sgt[i] = sgt;
 		} else {
-			state->iova[i] = bo->iova;
+			state->iova[i] = phys_addr;
 		}
 	}
 
@@ -156,9 +164,11 @@ unpin:
 		struct tegra_bo *bo = tegra_fb_get_plane(state->base.fb, i);
 		struct sg_table *sgt = state->sgt[i];
 
-		dma_unmap_sg(dc->dev, sgt->sgl, sgt->nents, DMA_TO_DEVICE);
-		host1x_bo_unpin(dc->dev, &bo->base, sgt);
+		if (sgt)
+			dma_unmap_sg(dc->dev, sgt->sgl, sgt->nents,
+				     DMA_TO_DEVICE);
 
+		host1x_bo_unpin(dc->dev, &bo->base, sgt);
 		state->iova[i] = DMA_MAPPING_ERROR;
 		state->sgt[i] = NULL;
 	}
@@ -172,17 +182,13 @@ static void tegra_dc_unpin(struct tegra_
 
 	for (i = 0; i < state->base.fb->format->num_planes; i++) {
 		struct tegra_bo *bo = tegra_fb_get_plane(state->base.fb, i);
+		struct sg_table *sgt = state->sgt[i];
 
-		if (!dc->client.group) {
-			struct sg_table *sgt = state->sgt[i];
-
-			if (sgt) {
-				dma_unmap_sg(dc->dev, sgt->sgl, sgt->nents,
-					     DMA_TO_DEVICE);
-				host1x_bo_unpin(dc->dev, &bo->base, sgt);
-			}
-		}
+		if (sgt)
+			dma_unmap_sg(dc->dev, sgt->sgl, sgt->nents,
+				     DMA_TO_DEVICE);
 
+		host1x_bo_unpin(dc->dev, &bo->base, sgt);
 		state->iova[i] = DMA_MAPPING_ERROR;
 		state->sgt[i] = NULL;
 	}
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -8,6 +8,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/host1x.h>
+#include <linux/iommu.h>
 #include <linux/kref.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
@@ -101,9 +102,11 @@ static unsigned int pin_job(struct host1
 {
 	struct host1x_client *client = job->client;
 	struct device *dev = client->dev;
+	struct iommu_domain *domain;
 	unsigned int i;
 	int err;
 
+	domain = iommu_get_domain_for_dev(dev);
 	job->num_unpins = 0;
 
 	for (i = 0; i < job->num_relocs; i++) {
@@ -117,7 +120,19 @@ static unsigned int pin_job(struct host1
 			goto unpin;
 		}
 
-		if (client->group)
+		/*
+		 * If the client device is not attached to an IOMMU, the
+		 * physical address of the buffer object can be used.
+		 *
+		 * Similarly, when an IOMMU domain is shared between all
+		 * host1x clients, the IOVA is already available, so no
+		 * need to map the buffer object again.
+		 *
+		 * XXX Note that this isn't always safe to do because it
+		 * relies on an assumption that no cache maintenance is
+		 * needed on the buffer objects.
+		 */
+		if (!domain || client->group)
 			phys = &phys_addr;
 		else
 			phys = NULL;
@@ -176,6 +191,7 @@ static unsigned int pin_job(struct host1
 		dma_addr_t phys_addr;
 		unsigned long shift;
 		struct iova *alloc;
+		dma_addr_t *phys;
 		unsigned int j;
 
 		g->bo = host1x_bo_get(g->bo);
@@ -184,7 +200,17 @@ static unsigned int pin_job(struct host1
 			goto unpin;
 		}
 
-		sgt = host1x_bo_pin(host->dev, g->bo, NULL);
+		/**
+		 * If the host1x is not attached to an IOMMU, there is no need
+		 * to map the buffer object for the host1x, since the physical
+		 * address can simply be used.
+		 */
+		if (!iommu_get_domain_for_dev(host->dev))
+			phys = &phys_addr;
+		else
+			phys = NULL;
+
+		sgt = host1x_bo_pin(host->dev, g->bo, phys);
 		if (IS_ERR(sgt)) {
 			err = PTR_ERR(sgt);
 			goto unpin;
@@ -214,7 +240,7 @@ static unsigned int pin_job(struct host1
 
 			job->unpins[job->num_unpins].size = gather_size;
 			phys_addr = iova_dma_addr(&host->iova, alloc);
-		} else {
+		} else if (sgt) {
 			err = dma_map_sg(host->dev, sgt->sgl, sgt->nents,
 					 DMA_TO_DEVICE);
 			if (!err) {


