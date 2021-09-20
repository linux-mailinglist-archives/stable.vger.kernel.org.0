Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013064123B2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352576AbhITS0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378273AbhITSYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60CAD632C9;
        Mon, 20 Sep 2021 17:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158699;
        bh=uID3M5NY/ZyLo6OReHmpO9w0K2LGnDWO4UgHwhHzyYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZZMtikjp7pTQk+XtHhIitCzG8RGMzJM1mnvmu9qz49im11SnW10Ow7oo8QGyf1Cb
         sL8ibIGC+vVLAdCrbrFc7fii93s5pXj4JgK/cGiMh+mtRnoACFIO3uTB96wzofUPr5
         trML0EfEzbsk+jjrn/UncVLWVzgLZ5YDC1GhluQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Michael Walle <michael@walle.cc>, Marek Vasut <marex@denx.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: [PATCH 5.10 016/122] drm/etnaviv: reference MMU context when setting up hardware state
Date:   Mon, 20 Sep 2021 18:43:08 +0200
Message-Id: <20210920163916.307614368@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit d6408538f091fb22d47f792d4efa58143d56c3fb upstream.

Move the refcount manipulation of the MMU context to the point where the
hardware state is programmed. At that point it is also known if a previous
MMU state is still there, or the state needs to be reprogrammed with a
potentially different context.

Cc: stable@vger.kernel.org # 5.4
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marek Vasut <marex@denx.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c      |   24 ++++++++++++------------
 drivers/gpu/drm/etnaviv/etnaviv_iommu.c    |    4 ++++
 drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c |    8 ++++++++
 3 files changed, 24 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -633,17 +633,19 @@ void etnaviv_gpu_start_fe(struct etnaviv
 	gpu->fe_running = true;
 }
 
-static void etnaviv_gpu_start_fe_idleloop(struct etnaviv_gpu *gpu)
+static void etnaviv_gpu_start_fe_idleloop(struct etnaviv_gpu *gpu,
+					  struct etnaviv_iommu_context *context)
 {
-	u32 address = etnaviv_cmdbuf_get_va(&gpu->buffer,
-				&gpu->mmu_context->cmdbuf_mapping);
 	u16 prefetch;
+	u32 address;
 
 	/* setup the MMU */
-	etnaviv_iommu_restore(gpu, gpu->mmu_context);
+	etnaviv_iommu_restore(gpu, context);
 
 	/* Start command processor */
 	prefetch = etnaviv_buffer_init(gpu);
+	address = etnaviv_cmdbuf_get_va(&gpu->buffer,
+					&gpu->mmu_context->cmdbuf_mapping);
 
 	etnaviv_gpu_start_fe(gpu, address, prefetch);
 }
@@ -1357,14 +1359,12 @@ struct dma_fence *etnaviv_gpu_submit(str
 		goto out_unlock;
 	}
 
-	if (!gpu->fe_running) {
-		gpu->mmu_context = etnaviv_iommu_context_get(submit->mmu_context);
-		etnaviv_gpu_start_fe_idleloop(gpu);
-	} else {
-		if (submit->prev_mmu_context)
-			etnaviv_iommu_context_put(submit->prev_mmu_context);
-		submit->prev_mmu_context = etnaviv_iommu_context_get(gpu->mmu_context);
-	}
+	if (!gpu->fe_running)
+		etnaviv_gpu_start_fe_idleloop(gpu, submit->mmu_context);
+
+	if (submit->prev_mmu_context)
+		etnaviv_iommu_context_put(submit->prev_mmu_context);
+	submit->prev_mmu_context = etnaviv_iommu_context_get(gpu->mmu_context);
 
 	if (submit->nr_pmrs) {
 		gpu->event[event[1]].sync_point = &sync_point_perfmon_sample_pre;
--- a/drivers/gpu/drm/etnaviv/etnaviv_iommu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_iommu.c
@@ -92,6 +92,10 @@ static void etnaviv_iommuv1_restore(stru
 	struct etnaviv_iommuv1_context *v1_context = to_v1_context(context);
 	u32 pgtable;
 
+	if (gpu->mmu_context)
+		etnaviv_iommu_context_put(gpu->mmu_context);
+	gpu->mmu_context = etnaviv_iommu_context_get(context);
+
 	/* set base addresses */
 	gpu_write(gpu, VIVS_MC_MEMORY_BASE_ADDR_RA, context->global->memory_base);
 	gpu_write(gpu, VIVS_MC_MEMORY_BASE_ADDR_FE, context->global->memory_base);
--- a/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_iommu_v2.c
@@ -172,6 +172,10 @@ static void etnaviv_iommuv2_restore_nons
 	if (gpu_read(gpu, VIVS_MMUv2_CONTROL) & VIVS_MMUv2_CONTROL_ENABLE)
 		return;
 
+	if (gpu->mmu_context)
+		etnaviv_iommu_context_put(gpu->mmu_context);
+	gpu->mmu_context = etnaviv_iommu_context_get(context);
+
 	prefetch = etnaviv_buffer_config_mmuv2(gpu,
 				(u32)v2_context->mtlb_dma,
 				(u32)context->global->bad_page_dma);
@@ -192,6 +196,10 @@ static void etnaviv_iommuv2_restore_sec(
 	if (gpu_read(gpu, VIVS_MMUv2_SEC_CONTROL) & VIVS_MMUv2_SEC_CONTROL_ENABLE)
 		return;
 
+	if (gpu->mmu_context)
+		etnaviv_iommu_context_put(gpu->mmu_context);
+	gpu->mmu_context = etnaviv_iommu_context_get(context);
+
 	gpu_write(gpu, VIVS_MMUv2_PTA_ADDRESS_LOW,
 		  lower_32_bits(context->global->v2.pta_dma));
 	gpu_write(gpu, VIVS_MMUv2_PTA_ADDRESS_HIGH,


