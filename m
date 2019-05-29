Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805FF2D8DA
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 11:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfE2JSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 05:18:41 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51222 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfE2JSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 05:18:41 -0400
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 679FD2849FA;
        Wed, 29 May 2019 10:18:39 +0100 (BST)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/panfrost: Make sure a BO is only unmapped when appropriate
Date:   Wed, 29 May 2019 11:18:36 +0200
Message-Id: <20190529091836.22060-1-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mmu_ops->unmap() will fail when called on a BO that has not been
previously mapped, and the error path in panfrost_ioctl_create_bo()
can call drm_gem_object_put_unlocked() (which in turn calls
panfrost_mmu_unmap()) on a BO that has not been mapped yet.

Keep track of the mapped/unmapped state to avoid such issues.

Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_gem.h | 1 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
index 045000eb5fcf..6dbcaba020fc 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -11,6 +11,7 @@ struct panfrost_gem_object {
 	struct drm_gem_shmem_object base;
 
 	struct drm_mm_node node;
+	bool is_mapped;
 };
 
 static inline
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 762b1bd2a8c2..fb556aa89203 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -156,6 +156,9 @@ int panfrost_mmu_map(struct panfrost_gem_object *bo)
 	struct sg_table *sgt;
 	int ret;
 
+	if (bo->is_mapped)
+		return 0;
+
 	sgt = drm_gem_shmem_get_pages_sgt(obj);
 	if (WARN_ON(IS_ERR(sgt)))
 		return PTR_ERR(sgt);
@@ -189,6 +192,7 @@ int panfrost_mmu_map(struct panfrost_gem_object *bo)
 
 	pm_runtime_mark_last_busy(pfdev->dev);
 	pm_runtime_put_autosuspend(pfdev->dev);
+	bo->is_mapped = true;
 
 	return 0;
 }
@@ -203,6 +207,9 @@ void panfrost_mmu_unmap(struct panfrost_gem_object *bo)
 	size_t unmapped_len = 0;
 	int ret;
 
+	if (!bo->is_mapped)
+		return;
+
 	dev_dbg(pfdev->dev, "unmap: iova=%llx, len=%zx", iova, len);
 
 	ret = pm_runtime_get_sync(pfdev->dev);
@@ -230,6 +237,7 @@ void panfrost_mmu_unmap(struct panfrost_gem_object *bo)
 
 	pm_runtime_mark_last_busy(pfdev->dev);
 	pm_runtime_put_autosuspend(pfdev->dev);
+	bo->is_mapped = false;
 }
 
 static void mmu_tlb_inv_context_s1(void *cookie)
-- 
2.20.1

