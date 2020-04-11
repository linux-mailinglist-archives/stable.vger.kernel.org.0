Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC731A51D7
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgDKMMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727327AbgDKMMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:12:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B15421655;
        Sat, 11 Apr 2020 12:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607160;
        bh=diEr7A/c7XyOdFew0NybRDLs5jmL2IXikHJnlUi9OuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckh2yYNz7v6E1q4Fu0SOqvQE9WhS9k6JfKBtBpg0GwdvRVfFRDGg8wnzJM2MBEXep
         aXD/2CCLbXNbGGC961GuOk+Ud6ZGQih64BnbLLpMCiC/7thurFZHJQdE0OpqXisdC/
         jT1WOQSYDaIbki0uxoPkfg5X2ICvSXZAHrAu6ipE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Robert Beckett <bob.beckett@collabora.com>
Subject: [PATCH 4.9 08/32] drm/etnaviv: replace MMU flush marker with flush sequence
Date:   Sat, 11 Apr 2020 14:08:47 +0200
Message-Id: <20200411115419.616038972@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115418.455500023@linuxfoundation.org>
References: <20200411115418.455500023@linuxfoundation.org>
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
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c    |    6 +++---
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h    |    2 +-
 5 files changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -257,6 +257,8 @@ void etnaviv_buffer_queue(struct etnaviv
 	unsigned int waitlink_offset = buffer->user_size - 16;
 	u32 return_target, return_dwords;
 	u32 link_target, link_dwords;
+	unsigned int new_flush_seq = READ_ONCE(gpu->mmu->flush_seq);
+	bool need_flush = gpu->flush_seq != new_flush_seq;
 
 	if (drm_debug & DRM_UT_DRIVER)
 		etnaviv_buffer_dump(gpu, buffer, 0, 0x50);
@@ -269,14 +271,14 @@ void etnaviv_buffer_queue(struct etnaviv
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
@@ -289,7 +291,7 @@ void etnaviv_buffer_queue(struct etnaviv
 
 		target = etnaviv_buffer_reserve(gpu, buffer, extra_dwords);
 
-		if (gpu->mmu->need_flush) {
+		if (need_flush) {
 			/* Add the MMU flush */
 			if (gpu->mmu->version == ETNAVIV_IOMMU_V1) {
 				CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_MMU,
@@ -309,7 +311,7 @@ void etnaviv_buffer_queue(struct etnaviv
 					SYNC_RECIPIENT_PE);
 			}
 
-			gpu->mmu->need_flush = false;
+			gpu->flush_seq = new_flush_seq;
 		}
 
 		if (gpu->switch_context) {
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1313,7 +1313,7 @@ int etnaviv_gpu_submit(struct etnaviv_gp
 	gpu->active_fence = submit->fence;
 
 	if (gpu->lastctx != cmdbuf->ctx) {
-		gpu->mmu->need_flush = true;
+		gpu->mmu->flush_seq++;
 		gpu->switch_context = true;
 		gpu->lastctx = cmdbuf->ctx;
 	}
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -135,6 +135,7 @@ struct etnaviv_gpu {
 	int irq;
 
 	struct etnaviv_iommu *mmu;
+	unsigned int flush_seq;
 
 	/* Power Control: */
 	struct clk *clk_bus;
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -134,7 +134,7 @@ static int etnaviv_iommu_find_iova(struc
 		 */
 		if (mmu->last_iova) {
 			mmu->last_iova = 0;
-			mmu->need_flush = true;
+			mmu->flush_seq++;
 			continue;
 		}
 
@@ -197,7 +197,7 @@ static int etnaviv_iommu_find_iova(struc
 		 * associated commit requesting this mapping, and retry the
 		 * allocation one more time.
 		 */
-		mmu->need_flush = true;
+		mmu->flush_seq++;
 	}
 
 	return ret;
@@ -354,7 +354,7 @@ u32 etnaviv_iommu_get_cmdbuf_va(struct e
 		 * that the FE MMU prefetch won't load invalid entries.
 		 */
 		mmu->last_iova = buf->vram_node.start + buf->size + SZ_64K;
-		gpu->mmu->need_flush = true;
+		mmu->flush_seq++;
 		mutex_unlock(&mmu->lock);
 
 		return (u32)buf->vram_node.start;
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


