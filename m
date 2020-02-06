Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766D91545D0
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 15:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgBFONe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 09:13:34 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40454 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgBFONe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 09:13:34 -0500
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 2A2F8295281;
        Thu,  6 Feb 2020 14:13:32 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org,
        Antonio Caggiano <antonio.caggiano@collabora.com>,
        Icecream95 <ixn@keemail.me>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/panfrost: perfcnt: Reserve/use the AS attached to the perfcnt MMU context
Date:   Thu,  6 Feb 2020 15:13:27 +0100
Message-Id: <20200206141327.446127-1-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We need to use the AS attached to the opened FD when dumping counters.

Reported-by: Antonio Caggiano <antonio.caggiano@collabora.com>
Fixes: 7282f7645d06 ("drm/panfrost: Implement per FD address spaces")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c     |  7 ++++++-
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c | 11 ++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 763cfca886a7..3107b0738e40 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -151,7 +151,12 @@ u32 panfrost_mmu_as_get(struct panfrost_device *pfdev, struct panfrost_mmu *mmu)
 	as = mmu->as;
 	if (as >= 0) {
 		int en = atomic_inc_return(&mmu->as_count);
-		WARN_ON(en >= NUM_JOB_SLOTS);
+
+		/*
+		 * AS can be retained by active jobs or a perfcnt context,
+		 * hence the '+ 1' here.
+		 */
+		WARN_ON(en >= (NUM_JOB_SLOTS + 1));
 
 		list_move(&mmu->list, &pfdev->as_lru_list);
 		goto out;
diff --git a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
index 684820448be3..6913578d5aa7 100644
--- a/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
+++ b/drivers/gpu/drm/panfrost/panfrost_perfcnt.c
@@ -73,7 +73,7 @@ static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
 	struct panfrost_file_priv *user = file_priv->driver_priv;
 	struct panfrost_perfcnt *perfcnt = pfdev->perfcnt;
 	struct drm_gem_shmem_object *bo;
-	u32 cfg;
+	u32 cfg, as;
 	int ret;
 
 	if (user == perfcnt->user)
@@ -126,12 +126,8 @@ static int panfrost_perfcnt_enable_locked(struct panfrost_device *pfdev,
 
 	perfcnt->user = user;
 
-	/*
-	 * Always use address space 0 for now.
-	 * FIXME: this needs to be updated when we start using different
-	 * address space.
-	 */
-	cfg = GPU_PERFCNT_CFG_AS(0) |
+	as = panfrost_mmu_as_get(pfdev, perfcnt->mapping->mmu);
+	cfg = GPU_PERFCNT_CFG_AS(as) |
 	      GPU_PERFCNT_CFG_MODE(GPU_PERFCNT_CFG_MODE_MANUAL);
 
 	/*
@@ -195,6 +191,7 @@ static int panfrost_perfcnt_disable_locked(struct panfrost_device *pfdev,
 	drm_gem_shmem_vunmap(&perfcnt->mapping->obj->base.base, perfcnt->buf);
 	perfcnt->buf = NULL;
 	panfrost_gem_close(&perfcnt->mapping->obj->base.base, file_priv);
+	panfrost_mmu_as_put(pfdev, perfcnt->mapping->mmu);
 	panfrost_gem_mapping_put(perfcnt->mapping);
 	perfcnt->mapping = NULL;
 	pm_runtime_mark_last_busy(pfdev->dev);
-- 
2.24.1

