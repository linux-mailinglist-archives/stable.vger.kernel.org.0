Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DBE1A501B
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgDKMOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727923AbgDKMOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D1EE20644;
        Sat, 11 Apr 2020 12:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607264;
        bh=ClpNK7YaIusq5vXPWRiHoqLn7u4LMOODQtE2gj3vpCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1FC+rkMI/vDLrhWsdESUYJUhpkgyY+vbGP/UFsXj6sSKzaRh2KAEBSxOK/++vHZ3
         35zC7rK8PaidnrhZ5mrmVYmdCY1Z+DponJBaPmH3vkmWS2YP/ahGpMX4D2VX/eyIu2
         Hs6I+kd1hDbYYlbco4MlcAk6DA+RLviZgAAwPZxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Robert Beckett <bob.beckett@collabora.com>
Subject: [PATCH 4.14 08/38] drm/etnaviv: replace MMU flush marker with flush sequence
Date:   Sat, 11 Apr 2020 14:08:52 +0200
Message-Id: <20200411115438.750099499@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 4900dda90af2cb13bc1d4c12ce94b98acc8fe64e upstream.

If a MMU is shared between multiple GPUs, all of them need to flush their
TLBs, so a single marker that gets reset on the first flush won't do.
Replace the flush marker with a sequence number, so that it's possible to
check if the TLB is in sync with the current page table state for each GPU.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c |   10 ++++++----
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c    |    2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h    |    1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c    |    8 ++++----
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h    |    2 +-
 5 files changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -258,6 +258,8 @@ void etnaviv_buffer_queue(struct etnaviv
 	unsigned int waitlink_offset = buffer->user_size - 16;
 	u32 return_target, return_dwords;
 	u32 link_target, link_dwords;
+	unsigned int new_flush_seq = READ_ONCE(gpu->mmu->flush_seq);
+	bool need_flush = gpu->flush_seq != new_flush_seq;
 
 	if (drm_debug & DRM_UT_DRIVER)
 		etnaviv_buffer_dump(gpu, buffer, 0, 0x50);
@@ -270,14 +272,14 @@ void etnaviv_buffer_queue(struct etnaviv
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
@@ -290,7 +292,7 @@ void etnaviv_buffer_queue(struct etnaviv
 
 		target = etnaviv_buffer_reserve(gpu, buffer, extra_dwords);
 
-		if (gpu->mmu->need_flush) {
+		if (need_flush) {
 			/* Add the MMU flush */
 			if (gpu->mmu->version == ETNAVIV_IOMMU_V1) {
 				CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_MMU,
@@ -310,7 +312,7 @@ void etnaviv_buffer_queue(struct etnaviv
 					SYNC_RECIPIENT_PE);
 			}
 
-			gpu->mmu->need_flush = false;
+			gpu->flush_seq = new_flush_seq;
 		}
 
 		if (gpu->switch_context) {
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1353,7 +1353,7 @@ int etnaviv_gpu_submit(struct etnaviv_gp
 	gpu->active_fence = submit->fence->seqno;
 
 	if (gpu->lastctx != cmdbuf->ctx) {
-		gpu->mmu->need_flush = true;
+		gpu->mmu->flush_seq++;
 		gpu->switch_context = true;
 		gpu->lastctx = cmdbuf->ctx;
 	}
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -138,6 +138,7 @@ struct etnaviv_gpu {
 
 	struct etnaviv_iommu *mmu;
 	struct etnaviv_cmdbuf_suballoc *cmdbuf_suballoc;
+	unsigned int flush_seq;
 
 	/* Power Control: */
 	struct clk *clk_bus;
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -132,7 +132,7 @@ static int etnaviv_iommu_find_iova(struc
 		 */
 		if (mmu->last_iova) {
 			mmu->last_iova = 0;
-			mmu->need_flush = true;
+			mmu->flush_seq++;
 			continue;
 		}
 
@@ -246,7 +246,7 @@ int etnaviv_iommu_map_gem(struct etnaviv
 	}
 
 	list_add_tail(&mapping->mmu_node, &mmu->mappings);
-	mmu->need_flush = true;
+	mmu->flush_seq++;
 	mutex_unlock(&mmu->lock);
 
 	return ret;
@@ -264,7 +264,7 @@ void etnaviv_iommu_unmap_gem(struct etna
 		etnaviv_iommu_remove_mapping(mmu, mapping);
 
 	list_del(&mapping->mmu_node);
-	mmu->need_flush = true;
+	mmu->flush_seq++;
 	mutex_unlock(&mmu->lock);
 }
 
@@ -346,7 +346,7 @@ int etnaviv_iommu_get_suballoc_va(struct
 			return ret;
 		}
 		mmu->last_iova = vram_node->start + size;
-		gpu->mmu->need_flush = true;
+		mmu->flush_seq++;
 		mutex_unlock(&mmu->lock);
 
 		*iova = (u32)vram_node->start;
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


