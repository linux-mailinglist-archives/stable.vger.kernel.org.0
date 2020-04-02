Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD42419C7B1
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388561AbgDBRLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:11:44 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45130 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731608AbgDBRJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 13:09:44 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 3EC89297E43
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        David Airlie <airlied@linux.ie>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Robert Beckett <bob.beckett@collabora.com>
Subject: [PATCH v4.14.y] drm/etnaviv: replace MMU flush marker with flush sequence
Date:   Thu,  2 Apr 2020 18:07:57 +0100
Message-Id: <20200402170758.8315-2-bob.beckett@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200402170758.8315-1-bob.beckett@collabora.com>
References: <20200402170758.8315-1-bob.beckett@collabora.com>
Reply-To: <bob.beckett@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 4900dda90af2cb13bc1d4c12ce94b98acc8fe64e upstream

If a MMU is shared between multiple GPUs, all of them need to flush their
TLBs, so a single marker that gets reset on the first flush won't do.
Replace the flush marker with a sequence number, so that it's possible to
check if the TLB is in sync with the current page table state for each GPU.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
---
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c | 10 ++++++----
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c    |  2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h    |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c    |  8 ++++----
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h    |  2 +-
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
index ed9588f36bc9..5fc1b41cb6c5 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -258,6 +258,8 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, unsigned int event,
 	unsigned int waitlink_offset = buffer->user_size - 16;
 	u32 return_target, return_dwords;
 	u32 link_target, link_dwords;
+	unsigned int new_flush_seq = READ_ONCE(gpu->mmu->flush_seq);
+	bool need_flush = gpu->flush_seq != new_flush_seq;
 
 	if (drm_debug & DRM_UT_DRIVER)
 		etnaviv_buffer_dump(gpu, buffer, 0, 0x50);
@@ -270,14 +272,14 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, unsigned int event,
 	 * need to append a mmu flush load state, followed by a new
 	 * link to this buffer - a total of four additional words.
 	 */
-	if (gpu->mmu->need_flush || gpu->switch_context) {
+	if (need_flush || gpu->switch_context) {
 		u32 target, extra_dwords;
 
 		/* link command */
 		extra_dwords = 1;
 
 		/* flush command */
-		if (gpu->mmu->need_flush) {
+		if (need_flush) {
 			if (gpu->mmu->version == ETNAVIV_IOMMU_V1)
 				extra_dwords += 1;
 			else
@@ -290,7 +292,7 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, unsigned int event,
 
 		target = etnaviv_buffer_reserve(gpu, buffer, extra_dwords);
 
-		if (gpu->mmu->need_flush) {
+		if (need_flush) {
 			/* Add the MMU flush */
 			if (gpu->mmu->version == ETNAVIV_IOMMU_V1) {
 				CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_MMU,
@@ -310,7 +312,7 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, unsigned int event,
 					SYNC_RECIPIENT_PE);
 			}
 
-			gpu->mmu->need_flush = false;
+			gpu->flush_seq = new_flush_seq;
 		}
 
 		if (gpu->switch_context) {
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index a1562f89c3d7..1f8c8e4328e4 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1353,7 +1353,7 @@ int etnaviv_gpu_submit(struct etnaviv_gpu *gpu,
 	gpu->active_fence = submit->fence->seqno;
 
 	if (gpu->lastctx != cmdbuf->ctx) {
-		gpu->mmu->need_flush = true;
+		gpu->mmu->flush_seq++;
 		gpu->switch_context = true;
 		gpu->lastctx = cmdbuf->ctx;
 	}
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
index 689cb8f3680c..62b2877d090b 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -138,6 +138,7 @@ struct etnaviv_gpu {
 
 	struct etnaviv_iommu *mmu;
 	struct etnaviv_cmdbuf_suballoc *cmdbuf_suballoc;
+	unsigned int flush_seq;
 
 	/* Power Control: */
 	struct clk *clk_bus;
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
index f103e787de94..0e23a0542f0a 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -132,7 +132,7 @@ static int etnaviv_iommu_find_iova(struct etnaviv_iommu *mmu,
 		 */
 		if (mmu->last_iova) {
 			mmu->last_iova = 0;
-			mmu->need_flush = true;
+			mmu->flush_seq++;
 			continue;
 		}
 
@@ -246,7 +246,7 @@ int etnaviv_iommu_map_gem(struct etnaviv_iommu *mmu,
 	}
 
 	list_add_tail(&mapping->mmu_node, &mmu->mappings);
-	mmu->need_flush = true;
+	mmu->flush_seq++;
 	mutex_unlock(&mmu->lock);
 
 	return ret;
@@ -264,7 +264,7 @@ void etnaviv_iommu_unmap_gem(struct etnaviv_iommu *mmu,
 		etnaviv_iommu_remove_mapping(mmu, mapping);
 
 	list_del(&mapping->mmu_node);
-	mmu->need_flush = true;
+	mmu->flush_seq++;
 	mutex_unlock(&mmu->lock);
 }
 
@@ -346,7 +346,7 @@ int etnaviv_iommu_get_suballoc_va(struct etnaviv_gpu *gpu, dma_addr_t paddr,
 			return ret;
 		}
 		mmu->last_iova = vram_node->start + size;
-		gpu->mmu->need_flush = true;
+		mmu->flush_seq++;
 		mutex_unlock(&mmu->lock);
 
 		*iova = (u32)vram_node->start;
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
index 54be289e5981..ccb6ad3582b8 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
@@ -44,7 +44,7 @@ struct etnaviv_iommu {
 	struct list_head mappings;
 	struct drm_mm mm;
 	u32 last_iova;
-	bool need_flush;
+	unsigned int flush_seq;
 };
 
 struct etnaviv_gem_object;
-- 
2.20.1

