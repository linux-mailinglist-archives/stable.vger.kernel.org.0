Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188BC64337B
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiLETgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbiLETgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B351ADB8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:33:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38606B811E3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0E5C433D7;
        Mon,  5 Dec 2022 19:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268789;
        bh=DgJJ3VgvVa04odX1meZTG8fpp6gQcwAyAMEiE7yKhE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F686O+LaylGdxOwcfs7/6HF9BhpZhj2QG4izDfcpmh9pDqlvyrjV4wcdEYM+mMUgK
         ouxXjjJslOOPhkmr6R9z5yzShpyzDJ8k/2ixB3sbxbVd8o2Q5XFW0L4VcMcF6FI87h
         J1i0Qx3HzU69XjByaWyMjnPlB3c9p/niY7dysi+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/120] drm/i915: Create a dummy object for gen6 ppgtt
Date:   Mon,  5 Dec 2022 20:09:02 +0100
Message-Id: <20221205190806.609296078@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

[ Upstream commit b0b0f2d225da6fe58417fae37e3f797e2db27b62 ]

We currently have to special case vma->obj being NULL because
of gen6 ppgtt and mock_engine. Fix gen6 ppgtt, so we may soon
be able to remove a few checks. As the object only exists as
a fake object pointing to ggtt, we have no backing storage,
so no real object is created. It just has to look real enough.

Also kill pin_mutex, it's not compatible with ww locking,
and we can use the vm lock instead.

v2:
  - Drop IS_SHRINKABLE and shorten overly long line
v3:
  - Checkpatch fix for alignment

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211117142024.1043017-2-matthew.auld@intel.com
Stable-dep-of: 20e377e7b2e7 ("drm/i915/gt: Use i915_vm_put on ppgtt_create error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_internal.c |  44 ++++---
 drivers/gpu/drm/i915/gt/gen6_ppgtt.c         | 123 +++++++++++--------
 drivers/gpu/drm/i915/gt/gen6_ppgtt.h         |   1 -
 drivers/gpu/drm/i915/i915_drv.h              |   4 +
 4 files changed, 100 insertions(+), 72 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_internal.c b/drivers/gpu/drm/i915/gem/i915_gem_internal.c
index e5ae9c06510c..3c8de65bfb39 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_internal.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_internal.c
@@ -143,24 +143,10 @@ static const struct drm_i915_gem_object_ops i915_gem_object_internal_ops = {
 	.put_pages = i915_gem_object_put_pages_internal,
 };
 
-/**
- * i915_gem_object_create_internal: create an object with volatile pages
- * @i915: the i915 device
- * @size: the size in bytes of backing storage to allocate for the object
- *
- * Creates a new object that wraps some internal memory for private use.
- * This object is not backed by swappable storage, and as such its contents
- * are volatile and only valid whilst pinned. If the object is reaped by the
- * shrinker, its pages and data will be discarded. Equally, it is not a full
- * GEM object and so not valid for access from userspace. This makes it useful
- * for hardware interfaces like ringbuffers (which are pinned from the time
- * the request is written to the time the hardware stops accessing it), but
- * not for contexts (which need to be preserved when not active for later
- * reuse). Note that it is not cleared upon allocation.
- */
 struct drm_i915_gem_object *
-i915_gem_object_create_internal(struct drm_i915_private *i915,
-				phys_addr_t size)
+__i915_gem_object_create_internal(struct drm_i915_private *i915,
+				  const struct drm_i915_gem_object_ops *ops,
+				  phys_addr_t size)
 {
 	static struct lock_class_key lock_class;
 	struct drm_i915_gem_object *obj;
@@ -177,7 +163,7 @@ i915_gem_object_create_internal(struct drm_i915_private *i915,
 		return ERR_PTR(-ENOMEM);
 
 	drm_gem_private_object_init(&i915->drm, &obj->base, size);
-	i915_gem_object_init(obj, &i915_gem_object_internal_ops, &lock_class, 0);
+	i915_gem_object_init(obj, ops, &lock_class, 0);
 	obj->mem_flags |= I915_BO_FLAG_STRUCT_PAGE;
 
 	/*
@@ -197,3 +183,25 @@ i915_gem_object_create_internal(struct drm_i915_private *i915,
 
 	return obj;
 }
+
+/**
+ * i915_gem_object_create_internal: create an object with volatile pages
+ * @i915: the i915 device
+ * @size: the size in bytes of backing storage to allocate for the object
+ *
+ * Creates a new object that wraps some internal memory for private use.
+ * This object is not backed by swappable storage, and as such its contents
+ * are volatile and only valid whilst pinned. If the object is reaped by the
+ * shrinker, its pages and data will be discarded. Equally, it is not a full
+ * GEM object and so not valid for access from userspace. This makes it useful
+ * for hardware interfaces like ringbuffers (which are pinned from the time
+ * the request is written to the time the hardware stops accessing it), but
+ * not for contexts (which need to be preserved when not active for later
+ * reuse). Note that it is not cleared upon allocation.
+ */
+struct drm_i915_gem_object *
+i915_gem_object_create_internal(struct drm_i915_private *i915,
+				phys_addr_t size)
+{
+	return __i915_gem_object_create_internal(i915, &i915_gem_object_internal_ops, size);
+}
diff --git a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c b/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
index 1aee5e6b1b23..557ef25be057 100644
--- a/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen6_ppgtt.c
@@ -262,13 +262,10 @@ static void gen6_ppgtt_cleanup(struct i915_address_space *vm)
 {
 	struct gen6_ppgtt *ppgtt = to_gen6_ppgtt(i915_vm_to_ppgtt(vm));
 
-	__i915_vma_put(ppgtt->vma);
-
 	gen6_ppgtt_free_pd(ppgtt);
 	free_scratch(vm);
 
 	mutex_destroy(&ppgtt->flush);
-	mutex_destroy(&ppgtt->pin_mutex);
 
 	free_pd(&ppgtt->base.vm, ppgtt->base.pd);
 }
@@ -331,37 +328,6 @@ static const struct i915_vma_ops pd_vma_ops = {
 	.unbind_vma = pd_vma_unbind,
 };
 
-static struct i915_vma *pd_vma_create(struct gen6_ppgtt *ppgtt, int size)
-{
-	struct i915_ggtt *ggtt = ppgtt->base.vm.gt->ggtt;
-	struct i915_vma *vma;
-
-	GEM_BUG_ON(!IS_ALIGNED(size, I915_GTT_PAGE_SIZE));
-	GEM_BUG_ON(size > ggtt->vm.total);
-
-	vma = i915_vma_alloc();
-	if (!vma)
-		return ERR_PTR(-ENOMEM);
-
-	i915_active_init(&vma->active, NULL, NULL, 0);
-
-	kref_init(&vma->ref);
-	mutex_init(&vma->pages_mutex);
-	vma->vm = i915_vm_get(&ggtt->vm);
-	vma->ops = &pd_vma_ops;
-	vma->private = ppgtt;
-
-	vma->size = size;
-	vma->fence_size = size;
-	atomic_set(&vma->flags, I915_VMA_GGTT);
-	vma->ggtt_view.type = I915_GGTT_VIEW_ROTATED; /* prevent fencing */
-
-	INIT_LIST_HEAD(&vma->obj_link);
-	INIT_LIST_HEAD(&vma->closed_link);
-
-	return vma;
-}
-
 int gen6_ppgtt_pin(struct i915_ppgtt *base, struct i915_gem_ww_ctx *ww)
 {
 	struct gen6_ppgtt *ppgtt = to_gen6_ppgtt(base);
@@ -378,24 +344,85 @@ int gen6_ppgtt_pin(struct i915_ppgtt *base, struct i915_gem_ww_ctx *ww)
 	if (atomic_add_unless(&ppgtt->pin_count, 1, 0))
 		return 0;
 
-	if (mutex_lock_interruptible(&ppgtt->pin_mutex))
-		return -EINTR;
+	/* grab the ppgtt resv to pin the object */
+	err = i915_vm_lock_objects(&ppgtt->base.vm, ww);
+	if (err)
+		return err;
 
 	/*
 	 * PPGTT PDEs reside in the GGTT and consists of 512 entries. The
 	 * allocator works in address space sizes, so it's multiplied by page
 	 * size. We allocate at the top of the GTT to avoid fragmentation.
 	 */
-	err = 0;
-	if (!atomic_read(&ppgtt->pin_count))
+	if (!atomic_read(&ppgtt->pin_count)) {
 		err = i915_ggtt_pin(ppgtt->vma, ww, GEN6_PD_ALIGN, PIN_HIGH);
+
+		GEM_BUG_ON(ppgtt->vma->fence);
+		clear_bit(I915_VMA_CAN_FENCE_BIT, __i915_vma_flags(ppgtt->vma));
+	}
 	if (!err)
 		atomic_inc(&ppgtt->pin_count);
-	mutex_unlock(&ppgtt->pin_mutex);
 
 	return err;
 }
 
+static int pd_dummy_obj_get_pages(struct drm_i915_gem_object *obj)
+{
+	obj->mm.pages = ZERO_SIZE_PTR;
+	return 0;
+}
+
+static void pd_dummy_obj_put_pages(struct drm_i915_gem_object *obj,
+				   struct sg_table *pages)
+{
+}
+
+static const struct drm_i915_gem_object_ops pd_dummy_obj_ops = {
+	.name = "pd_dummy_obj",
+	.get_pages = pd_dummy_obj_get_pages,
+	.put_pages = pd_dummy_obj_put_pages,
+};
+
+static struct i915_page_directory *
+gen6_alloc_top_pd(struct gen6_ppgtt *ppgtt)
+{
+	struct i915_ggtt * const ggtt = ppgtt->base.vm.gt->ggtt;
+	struct i915_page_directory *pd;
+	int err;
+
+	pd = __alloc_pd(I915_PDES);
+	if (unlikely(!pd))
+		return ERR_PTR(-ENOMEM);
+
+	pd->pt.base = __i915_gem_object_create_internal(ppgtt->base.vm.gt->i915,
+							&pd_dummy_obj_ops,
+							I915_PDES * SZ_4K);
+	if (IS_ERR(pd->pt.base)) {
+		err = PTR_ERR(pd->pt.base);
+		pd->pt.base = NULL;
+		goto err_pd;
+	}
+
+	pd->pt.base->base.resv = i915_vm_resv_get(&ppgtt->base.vm);
+	pd->pt.base->shares_resv_from = &ppgtt->base.vm;
+
+	ppgtt->vma = i915_vma_instance(pd->pt.base, &ggtt->vm, NULL);
+	if (IS_ERR(ppgtt->vma)) {
+		err = PTR_ERR(ppgtt->vma);
+		ppgtt->vma = NULL;
+		goto err_pd;
+	}
+
+	/* The dummy object we create is special, override ops.. */
+	ppgtt->vma->ops = &pd_vma_ops;
+	ppgtt->vma->private = ppgtt;
+	return pd;
+
+err_pd:
+	free_pd(&ppgtt->base.vm, pd);
+	return ERR_PTR(err);
+}
+
 void gen6_ppgtt_unpin(struct i915_ppgtt *base)
 {
 	struct gen6_ppgtt *ppgtt = to_gen6_ppgtt(base);
@@ -427,7 +454,6 @@ struct i915_ppgtt *gen6_ppgtt_create(struct intel_gt *gt)
 		return ERR_PTR(-ENOMEM);
 
 	mutex_init(&ppgtt->flush);
-	mutex_init(&ppgtt->pin_mutex);
 
 	ppgtt_init(&ppgtt->base, gt);
 	ppgtt->base.vm.pd_shift = ilog2(SZ_4K * SZ_4K / sizeof(gen6_pte_t));
@@ -442,19 +468,13 @@ struct i915_ppgtt *gen6_ppgtt_create(struct intel_gt *gt)
 	ppgtt->base.vm.alloc_pt_dma = alloc_pt_dma;
 	ppgtt->base.vm.pte_encode = ggtt->vm.pte_encode;
 
-	ppgtt->base.pd = __alloc_pd(I915_PDES);
-	if (!ppgtt->base.pd) {
-		err = -ENOMEM;
-		goto err_free;
-	}
-
 	err = gen6_ppgtt_init_scratch(ppgtt);
 	if (err)
-		goto err_pd;
+		goto err_free;
 
-	ppgtt->vma = pd_vma_create(ppgtt, GEN6_PD_SIZE);
-	if (IS_ERR(ppgtt->vma)) {
-		err = PTR_ERR(ppgtt->vma);
+	ppgtt->base.pd = gen6_alloc_top_pd(ppgtt);
+	if (IS_ERR(ppgtt->base.pd)) {
+		err = PTR_ERR(ppgtt->base.pd);
 		goto err_scratch;
 	}
 
@@ -462,10 +482,7 @@ struct i915_ppgtt *gen6_ppgtt_create(struct intel_gt *gt)
 
 err_scratch:
 	free_scratch(&ppgtt->base.vm);
-err_pd:
-	free_pd(&ppgtt->base.vm, ppgtt->base.pd);
 err_free:
-	mutex_destroy(&ppgtt->pin_mutex);
 	kfree(ppgtt);
 	return ERR_PTR(err);
 }
diff --git a/drivers/gpu/drm/i915/gt/gen6_ppgtt.h b/drivers/gpu/drm/i915/gt/gen6_ppgtt.h
index 6a61a5c3a85a..9b498ca76ac6 100644
--- a/drivers/gpu/drm/i915/gt/gen6_ppgtt.h
+++ b/drivers/gpu/drm/i915/gt/gen6_ppgtt.h
@@ -19,7 +19,6 @@ struct gen6_ppgtt {
 	u32 pp_dir;
 
 	atomic_t pin_count;
-	struct mutex pin_mutex;
 
 	bool scan_for_unused_pt;
 };
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 005b1cec7007..236cfee1cbf0 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1905,6 +1905,10 @@ int i915_gem_evict_vm(struct i915_address_space *vm);
 struct drm_i915_gem_object *
 i915_gem_object_create_internal(struct drm_i915_private *dev_priv,
 				phys_addr_t size);
+struct drm_i915_gem_object *
+__i915_gem_object_create_internal(struct drm_i915_private *dev_priv,
+				  const struct drm_i915_gem_object_ops *ops,
+				  phys_addr_t size);
 
 /* i915_gem_tiling.c */
 static inline bool i915_gem_object_needs_bit17_swizzle(struct drm_i915_gem_object *obj)
-- 
2.35.1



