Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237E719C7A8
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388465AbgDBRJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:09:46 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45144 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388785AbgDBRJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 13:09:46 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id B26FC297E46
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Lucas Stach <l.stach@pengutronix.de>,
        Russell King <linux+etnaviv@armlinux.org.uk>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        David Airlie <airlied@linux.ie>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Robert Beckett <bob.beckett@collabora.com>
Subject: [PATCH v4.19.y] drm/etnaviv: replace MMU flush marker with flush sequence
Date:   Thu,  2 Apr 2020 18:07:58 +0100
Message-Id: <20200402170758.8315-3-bob.beckett@collabora.com>
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
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h    |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c    |  6 +++---
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h    |  2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
index 7fea74861a87..c83655b008b9 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -311,6 +311,8 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, u32 exec_state,
 	u32 return_target, return_dwords;
 	u32 link_target, link_dwords;
 	bool switch_context = gpu->exec_state != exec_state;
+	unsigned int new_flush_seq = READ_ONCE(gpu->mmu->flush_seq);
+	bool need_flush = gpu->flush_seq != new_flush_seq;
 
 	lockdep_assert_held(&gpu->lock);
 
@@ -325,14 +327,14 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, u32 exec_state,
 	 * need to append a mmu flush load state, followed by a new
 	 * link to this buffer - a total of four additional words.
 	 */
-	if (gpu->mmu->need_flush || switch_context) {
+	if (need_flush || switch_context) {
 		u32 target, extra_dwords;
 
 		/* link command */
 		extra_dwords = 1;
 
 		/* flush command */
-		if (gpu->mmu->need_flush) {
+		if (need_flush) {
 			if (gpu->mmu->version == ETNAVIV_IOMMU_V1)
 				extra_dwords += 1;
 			else
@@ -345,7 +347,7 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, u32 exec_state,
 
 		target = etnaviv_buffer_reserve(gpu, buffer, extra_dwords);
 
-		if (gpu->mmu->need_flush) {
+		if (need_flush) {
 			/* Add the MMU flush */
 			if (gpu->mmu->version == ETNAVIV_IOMMU_V1) {
 				CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_MMU,
@@ -365,7 +367,7 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, u32 exec_state,
 					SYNC_RECIPIENT_PE);
 			}
 
-			gpu->mmu->need_flush = false;
+			gpu->flush_seq = new_flush_seq;
 		}
 
 		if (switch_context) {
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
index 90f17ff7888e..4efc45304dce 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -139,6 +139,7 @@ struct etnaviv_gpu {
 
 	struct etnaviv_iommu *mmu;
 	struct etnaviv_cmdbuf_suballoc *cmdbuf_suballoc;
+	unsigned int flush_seq;
 
 	/* Power Control: */
 	struct clk *clk_bus;
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
index 8069f9f36a2e..e132dccedf88 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -261,7 +261,7 @@ int etnaviv_iommu_map_gem(struct etnaviv_iommu *mmu,
 	}
 
 	list_add_tail(&mapping->mmu_node, &mmu->mappings);
-	mmu->need_flush = true;
+	mmu->flush_seq++;
 unlock:
 	mutex_unlock(&mmu->lock);
 
@@ -280,7 +280,7 @@ void etnaviv_iommu_unmap_gem(struct etnaviv_iommu *mmu,
 		etnaviv_iommu_remove_mapping(mmu, mapping);
 
 	list_del(&mapping->mmu_node);
-	mmu->need_flush = true;
+	mmu->flush_seq++;
 	mutex_unlock(&mmu->lock);
 }
 
@@ -357,7 +357,7 @@ int etnaviv_iommu_get_suballoc_va(struct etnaviv_gpu *gpu, dma_addr_t paddr,
 			mutex_unlock(&mmu->lock);
 			return ret;
 		}
-		gpu->mmu->need_flush = true;
+		mmu->flush_seq++;
 		mutex_unlock(&mmu->lock);
 
 		*iova = (u32)vram_node->start;
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
index a0db17ffb686..348a94d9695b 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
@@ -48,7 +48,7 @@ struct etnaviv_iommu {
 	struct mutex lock;
 	struct list_head mappings;
 	struct drm_mm mm;
-	bool need_flush;
+	unsigned int flush_seq;
 };
 
 struct etnaviv_gem_object;
-- 
2.20.1

