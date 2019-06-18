Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B225F49BCC
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 10:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfFRINt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 04:13:49 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59560 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfFRINt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 04:13:49 -0400
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 045802813A9;
        Tue, 18 Jun 2019 09:13:47 +0100 (BST)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc:     dri-devel@lists.freedesktop.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] drm/panfrost: Make sure a BO is only unmapped when appropriate
Date:   Tue, 18 Jun 2019 10:13:43 +0200
Message-Id: <20190618081343.16927-1-boris.brezillon@collabora.com>
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
Changes in v2:
* Check is_mapped val in the caller and add WARN_ON() in the mmu code
  (suggested by Tomeu)
---
 drivers/gpu/drm/panfrost/panfrost_gem.c | 3 ++-
 drivers/gpu/drm/panfrost/panfrost_gem.h | 1 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c | 8 ++++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 886875ae31d3..b46416be5a54 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -19,7 +19,8 @@ static void panfrost_gem_free_object(struct drm_gem_object *obj)
 	struct panfrost_gem_object *bo = to_panfrost_bo(obj);
 	struct panfrost_device *pfdev = obj->dev->dev_private;
 
-	panfrost_mmu_unmap(bo);
+	if (bo->is_mapped)
+		panfrost_mmu_unmap(bo);
 
 	spin_lock(&pfdev->mm_lock);
 	drm_mm_remove_node(&bo->node);
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
index 762b1bd2a8c2..92ac995dd9c6 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -156,6 +156,9 @@ int panfrost_mmu_map(struct panfrost_gem_object *bo)
 	struct sg_table *sgt;
 	int ret;
 
+	if (WARN_ON(bo->is_mapped))
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
 
+	if (WARN_ON(!bo->is_mapped))
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

