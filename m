Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFE0657C86
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiL1Pde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiL1PdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:33:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDB615FF2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:33:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3381B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6391DC433D2;
        Wed, 28 Dec 2022 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241599;
        bh=4emUHXg+LQPCZGQcOikOvvBJYuFbgBXlACcVXZAmD2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ml1joQloCojCw3SoRllhBgPuSV/+yhVOGhvvf5bXK13ZwXWCci98L8g1qfZl/ZHpy
         I+iYoF/lLfK8PdPD6Zyu0UxuDRCq9b0MCJejbfHFofpWoacDMcI2EMoN5hxoYvqfGZ
         yMXpn+d37C5igyMPeZ1o7GNl3oJmh+r2Z6lLV9mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Auld <matthew.auld@intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0265/1146] drm/i915/dgfx: Grab wakeref at i915_ttm_unmap_virtual
Date:   Wed, 28 Dec 2022 15:30:04 +0100
Message-Id: <20221228144337.334310818@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Gupta <anshuman.gupta@intel.com>

[ Upstream commit 1cacd6894d5f4084f1581435e92d8a18d6721b25 ]

We had already grabbed the rpm wakeref at obj destruction path,
but it also required to grab the wakeref when object moves.
When i915_gem_object_release_mmap_offset() gets called by
i915_ttm_move_notify(), it will release the mmap offset without
grabbing the wakeref. We want to avoid that therefore,
grab the wakeref at i915_ttm_unmap_virtual() accordingly.

While doing that also changed the lmem_userfault_lock from
mutex to spinlock, as spinlock widely used for list.

Also changed if (obj->userfault_count) to
GEM_BUG_ON(!obj->userfault_count).

v2:
- Removed lmem_userfault_{list,lock} from intel_gt. [Matt Auld]

Fixes: ad74457a6b5a ("drm/i915/dgfx: Release mmap on rpm suspend")
Suggested-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221027092242.1476080-3-anshuman.gupta@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 19 +++++-------
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c  | 38 ++++++++++++++++--------
 drivers/gpu/drm/i915/intel_runtime_pm.c  |  2 +-
 drivers/gpu/drm/i915/intel_runtime_pm.h  |  2 +-
 4 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index fd29a9053582..e63329bc8065 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -557,11 +557,13 @@ void i915_gem_object_runtime_pm_release_mmap_offset(struct drm_i915_gem_object *
 
 	drm_vma_node_unmap(&bo->base.vma_node, bdev->dev_mapping);
 
-	if (obj->userfault_count) {
-		/* rpm wakeref provide exclusive access */
-		list_del(&obj->userfault_link);
-		obj->userfault_count = 0;
-	}
+	/*
+	 * We have exclusive access here via runtime suspend. All other callers
+	 * must first grab the rpm wakeref.
+	 */
+	GEM_BUG_ON(!obj->userfault_count);
+	list_del(&obj->userfault_link);
+	obj->userfault_count = 0;
 }
 
 void i915_gem_object_release_mmap_offset(struct drm_i915_gem_object *obj)
@@ -587,13 +589,6 @@ void i915_gem_object_release_mmap_offset(struct drm_i915_gem_object *obj)
 		spin_lock(&obj->mmo.lock);
 	}
 	spin_unlock(&obj->mmo.lock);
-
-	if (obj->userfault_count) {
-		mutex_lock(&to_i915(obj->base.dev)->runtime_pm.lmem_userfault_lock);
-		list_del(&obj->userfault_link);
-		mutex_unlock(&to_i915(obj->base.dev)->runtime_pm.lmem_userfault_lock);
-		obj->userfault_count = 0;
-	}
 }
 
 static struct i915_mmap_offset *
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
index d6b447ae0a16..be4c081e7e13 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -509,18 +509,9 @@ static int i915_ttm_shrink(struct drm_i915_gem_object *obj, unsigned int flags)
 static void i915_ttm_delete_mem_notify(struct ttm_buffer_object *bo)
 {
 	struct drm_i915_gem_object *obj = i915_ttm_to_gem(bo);
-	intel_wakeref_t wakeref = 0;
 
 	if (bo->resource && !i915_ttm_is_ghost_object(bo)) {
-		/* ttm_bo_release() already has dma_resv_lock */
-		if (i915_ttm_cpu_maps_iomem(bo->resource))
-			wakeref = intel_runtime_pm_get(&to_i915(obj->base.dev)->runtime_pm);
-
 		__i915_gem_object_pages_fini(obj);
-
-		if (wakeref)
-			intel_runtime_pm_put(&to_i915(obj->base.dev)->runtime_pm, wakeref);
-
 		i915_ttm_free_cached_io_rsgt(obj);
 	}
 }
@@ -1056,12 +1047,15 @@ static vm_fault_t vm_fault_ttm(struct vm_fault *vmf)
 	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
 		goto out_rpm;
 
-	/* ttm_bo_vm_reserve() already has dma_resv_lock */
+	/*
+	 * ttm_bo_vm_reserve() already has dma_resv_lock.
+	 * userfault_count is protected by dma_resv lock and rpm wakeref.
+	 */
 	if (ret == VM_FAULT_NOPAGE && wakeref && !obj->userfault_count) {
 		obj->userfault_count = 1;
-		mutex_lock(&to_i915(obj->base.dev)->runtime_pm.lmem_userfault_lock);
+		spin_lock(&to_i915(obj->base.dev)->runtime_pm.lmem_userfault_lock);
 		list_add(&obj->userfault_link, &to_i915(obj->base.dev)->runtime_pm.lmem_userfault_list);
-		mutex_unlock(&to_i915(obj->base.dev)->runtime_pm.lmem_userfault_lock);
+		spin_unlock(&to_i915(obj->base.dev)->runtime_pm.lmem_userfault_lock);
 	}
 
 	if (wakeref & CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND)
@@ -1127,7 +1121,27 @@ static u64 i915_ttm_mmap_offset(struct drm_i915_gem_object *obj)
 
 static void i915_ttm_unmap_virtual(struct drm_i915_gem_object *obj)
 {
+	struct ttm_buffer_object *bo = i915_gem_to_ttm(obj);
+	intel_wakeref_t wakeref = 0;
+
+	assert_object_held_shared(obj);
+
+	if (i915_ttm_cpu_maps_iomem(bo->resource)) {
+		wakeref = intel_runtime_pm_get(&to_i915(obj->base.dev)->runtime_pm);
+
+		/* userfault_count is protected by obj lock and rpm wakeref. */
+		if (obj->userfault_count) {
+			spin_lock(&to_i915(obj->base.dev)->runtime_pm.lmem_userfault_lock);
+			list_del(&obj->userfault_link);
+			spin_unlock(&to_i915(obj->base.dev)->runtime_pm.lmem_userfault_lock);
+			obj->userfault_count = 0;
+		}
+	}
+
 	ttm_bo_unmap_virtual(i915_gem_to_ttm(obj));
+
+	if (wakeref)
+		intel_runtime_pm_put(&to_i915(obj->base.dev)->runtime_pm, wakeref);
 }
 
 static const struct drm_i915_gem_object_ops i915_gem_ttm_obj_ops = {
diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.c b/drivers/gpu/drm/i915/intel_runtime_pm.c
index bb74d4975cc8..129746713d07 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -655,6 +655,6 @@ void intel_runtime_pm_init_early(struct intel_runtime_pm *rpm)
 
 	init_intel_runtime_pm_wakeref(rpm);
 	INIT_LIST_HEAD(&rpm->lmem_userfault_list);
-	mutex_init(&rpm->lmem_userfault_lock);
+	spin_lock_init(&rpm->lmem_userfault_lock);
 	intel_wakeref_auto_init(&rpm->userfault_wakeref, rpm);
 }
diff --git a/drivers/gpu/drm/i915/intel_runtime_pm.h b/drivers/gpu/drm/i915/intel_runtime_pm.h
index 9f50f109aa11..98b8b28baaa1 100644
--- a/drivers/gpu/drm/i915/intel_runtime_pm.h
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.h
@@ -64,7 +64,7 @@ struct intel_runtime_pm {
 	 *  but instead has exclusive access by virtue of all other accesses requiring
 	 *  holding the runtime pm wakeref.
 	 */
-	struct mutex lmem_userfault_lock;
+	spinlock_t lmem_userfault_lock;
 
 	/*
 	 *  Keep list of userfaulted gem obj, which require to release their
-- 
2.35.1



