Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3886E1A51A9
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgDKMOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgDKMOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEC0620692;
        Sat, 11 Apr 2020 12:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607286;
        bh=OhKMepbltkwnbMW3Ulpy8K75ap6qNdgFKnn2ttYTemQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrzC91qEl7cLL/a2YzQfqJ4mFWSu7MjpM0aizBVkFE19II1Ey46BqqO30GMS8Ujc5
         Cravxr+z3YHDdy/FklMQruCfdVhNDOjVb/PsMSjieMR4AwZSWyfk0ELsujDNZ8biZC
         EK8ygUUlbUg64Fo/K52358GMH/8ZR23mBe15JBlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Robert Beckett <bob.beckett@collabora.com>
Subject: [PATCH 4.19 12/54] drm/etnaviv: replace MMU flush marker with flush sequence
Date:   Sat, 11 Apr 2020 14:08:54 +0200
Message-Id: <20200411115509.463222109@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
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
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h    |    1 +
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c    |    6 +++---
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h    |    2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -311,6 +311,8 @@ void etnaviv_buffer_queue(struct etnaviv
 	u32 return_target, return_dwords;
 	u32 link_target, link_dwords;
 	bool switch_context = gpu->exec_state != exec_state;
+	unsigned int new_flush_seq = READ_ONCE(gpu->mmu->flush_seq);
+	bool need_flush = gpu->flush_seq != new_flush_seq;
 
 	lockdep_assert_held(&gpu->lock);
 
@@ -325,14 +327,14 @@ void etnaviv_buffer_queue(struct etnaviv
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
@@ -345,7 +347,7 @@ void etnaviv_buffer_queue(struct etnaviv
 
 		target = etnaviv_buffer_reserve(gpu, buffer, extra_dwords);
 
-		if (gpu->mmu->need_flush) {
+		if (need_flush) {
 			/* Add the MMU flush */
 			if (gpu->mmu->version == ETNAVIV_IOMMU_V1) {
 				CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_MMU,
@@ -365,7 +367,7 @@ void etnaviv_buffer_queue(struct etnaviv
 					SYNC_RECIPIENT_PE);
 			}
 
-			gpu->mmu->need_flush = false;
+			gpu->flush_seq = new_flush_seq;
 		}
 
 		if (switch_context) {
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -139,6 +139,7 @@ struct etnaviv_gpu {
 
 	struct etnaviv_iommu *mmu;
 	struct etnaviv_cmdbuf_suballoc *cmdbuf_suballoc;
+	unsigned int flush_seq;
 
 	/* Power Control: */
 	struct clk *clk_bus;
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -261,7 +261,7 @@ int etnaviv_iommu_map_gem(struct etnaviv
 	}
 
 	list_add_tail(&mapping->mmu_node, &mmu->mappings);
-	mmu->need_flush = true;
+	mmu->flush_seq++;
 unlock:
 	mutex_unlock(&mmu->lock);
 
@@ -280,7 +280,7 @@ void etnaviv_iommu_unmap_gem(struct etna
 		etnaviv_iommu_remove_mapping(mmu, mapping);
 
 	list_del(&mapping->mmu_node);
-	mmu->need_flush = true;
+	mmu->flush_seq++;
 	mutex_unlock(&mmu->lock);
 }
 
@@ -357,7 +357,7 @@ int etnaviv_iommu_get_suballoc_va(struct
 			mutex_unlock(&mmu->lock);
 			return ret;
 		}
-		gpu->mmu->need_flush = true;
+		mmu->flush_seq++;
 		mutex_unlock(&mmu->lock);
 
 		*iova = (u32)vram_node->start;
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


