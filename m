Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BFD180955
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgCJUlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:41:24 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:61525 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727311AbgCJUlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:41:23 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20514556-1500050 
        for multiple; Tue, 10 Mar 2020 20:40:48 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>
Subject: [PATCH 4/5] drm/i915: Introduce a vma.kref
Date:   Tue, 10 Mar 2020 20:40:45 +0000
Message-Id: <20200310204046.3995087-4-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310204046.3995087-1-chris@chris-wilson.co.uk>
References: <20200310204046.3995087-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Start introducing a kref on i915_vma in order to protect the vma unbind
(i915_gem_object_unbind) from a parallel destruction (i915_vma_parked).
Later, we will use the refcount to manage all access and turn i915_vma
into a first class container.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Imre Deak <imre.deak@intel.com>
Acked-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191222210256.2066451-2-chris@chris-wilson.co.uk
(cherry picked from commit 76f9764cc3d538435262dea885bf69fac2415402)
---
 drivers/gpu/drm/i915/gem/i915_gem_object.c    |  2 +-
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |  3 +--
 .../drm/i915/gem/selftests/i915_gem_mman.c    |  4 +--
 drivers/gpu/drm/i915/i915_gem.c               | 26 +++++++------------
 drivers/gpu/drm/i915/i915_gem_gtt.c           |  5 ++--
 drivers/gpu/drm/i915/i915_vma.c               |  9 ++++---
 drivers/gpu/drm/i915/i915_vma.h               | 25 +++++++++++++++---
 7 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index a596548c07bf..b6937469ffd3 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -174,7 +174,7 @@ static void __i915_gem_free_objects(struct drm_i915_private *i915,
 				GEM_BUG_ON(vma->obj != obj);
 				spin_unlock(&obj->vma.lock);
 
-				i915_vma_destroy(vma);
+				__i915_vma_put(vma);
 
 				spin_lock(&obj->vma.lock);
 			}
diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index 688c49a24f32..bd1e2c12de63 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1110,8 +1110,7 @@ static int __igt_write_huge(struct intel_context *ce,
 out_vma_unpin:
 	i915_vma_unpin(vma);
 out_vma_close:
-	i915_vma_destroy(vma);
-
+	__i915_vma_put(vma);
 	return err;
 }
 
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
index 29b2077b73d2..d226e55df8b2 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -161,7 +161,7 @@ static int check_partial_mapping(struct drm_i915_gem_object *obj,
 	kunmap(p);
 
 out:
-	i915_vma_destroy(vma);
+	__i915_vma_put(vma);
 	return err;
 }
 
@@ -255,7 +255,7 @@ static int check_partial_mappings(struct drm_i915_gem_object *obj,
 		if (err)
 			return err;
 
-		i915_vma_destroy(vma);
+		__i915_vma_put(vma);
 
 		if (igt_timeout(end_time,
 				"%s: timed out after tiling=%d stride=%d\n",
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 998b67e3466e..67a8e7408e67 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -128,7 +128,6 @@ int i915_gem_object_unbind(struct drm_i915_gem_object *obj,
 						       struct i915_vma,
 						       obj_link))) {
 		struct i915_address_space *vm = vma->vm;
-		bool awake = false;
 
 		list_move_tail(&vma->obj_link, &still_in_list);
 		if (!i915_vma_is_bound(vma, I915_VMA_BIND_MASK))
@@ -139,25 +138,18 @@ int i915_gem_object_unbind(struct drm_i915_gem_object *obj,
 			break;
 
 		/* Prevent vma being freed by i915_vma_parked as we unbind */
-		if (intel_gt_pm_get_if_awake(vm->gt)) {
-			awake = true;
-		} else {
-			if (i915_vma_is_closed(vma)) {
-				spin_unlock(&obj->vma.lock);
-				goto err_vm;
-			}
-		}
-
+		vma = __i915_vma_get(vma);
 		spin_unlock(&obj->vma.lock);
 
-		ret = -EBUSY;
-		if (flags & I915_GEM_OBJECT_UNBIND_ACTIVE ||
-		    !i915_vma_is_active(vma))
-			ret = i915_vma_unbind(vma);
+		if (vma) {
+			ret = -EBUSY;
+			if (flags & I915_GEM_OBJECT_UNBIND_ACTIVE ||
+			    !i915_vma_is_active(vma))
+				ret = i915_vma_unbind(vma);
+
+			__i915_vma_put(vma);
+		}
 
-		if (awake)
-			intel_gt_pm_put(vm->gt);
-err_vm:
 		i915_vm_close(vm);
 		spin_lock(&obj->vma.lock);
 	}
diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 44727806dfd7..dd2c20f7d4d2 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -522,7 +522,7 @@ void __i915_vm_close(struct i915_address_space *vm)
 
 		atomic_and(~I915_VMA_PIN_MASK, &vma->flags);
 		WARN_ON(__i915_vma_unbind(vma));
-		i915_vma_destroy(vma);
+		__i915_vma_put(vma);
 
 		i915_gem_object_put(obj);
 	}
@@ -1790,7 +1790,7 @@ static void gen6_ppgtt_cleanup(struct i915_address_space *vm)
 {
 	struct gen6_ppgtt *ppgtt = to_gen6_ppgtt(i915_vm_to_ppgtt(vm));
 
-	i915_vma_destroy(ppgtt->vma);
+	__i915_vma_put(ppgtt->vma);
 
 	gen6_ppgtt_free_pd(ppgtt);
 	free_scratch(vm);
@@ -1878,6 +1878,7 @@ static struct i915_vma *pd_vma_create(struct gen6_ppgtt *ppgtt, int size)
 
 	i915_active_init(&vma->active, NULL, NULL);
 
+	kref_init(&vma->ref);
 	mutex_init(&vma->pages_mutex);
 	vma->vm = i915_vm_get(&ggtt->vm);
 	vma->ops = &pd_vma_ops;
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 7c7e152cc5ff..5309872442bc 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -112,6 +112,7 @@ vma_create(struct drm_i915_gem_object *obj,
 	if (vma == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	kref_init(&vma->ref);
 	mutex_init(&vma->pages_mutex);
 	vma->vm = i915_vm_get(vm);
 	vma->ops = &vm->vma_ops;
@@ -978,8 +979,10 @@ void i915_vma_reopen(struct i915_vma *vma)
 		__i915_vma_remove_closed(vma);
 }
 
-void i915_vma_destroy(struct i915_vma *vma)
+void i915_vma_release(struct kref *ref)
 {
+	struct i915_vma *vma = container_of(ref, typeof(*vma), ref);
+
 	if (drm_mm_node_allocated(&vma->node)) {
 		mutex_lock(&vma->vm->mutex);
 		atomic_and(~I915_VMA_PIN_MASK, &vma->flags);
@@ -1027,7 +1030,7 @@ void i915_vma_parked(struct intel_gt *gt)
 		spin_unlock_irq(&gt->closed_lock);
 
 		if (obj) {
-			i915_vma_destroy(vma);
+			__i915_vma_put(vma);
 			i915_gem_object_put(obj);
 		}
 
@@ -1202,7 +1205,7 @@ int __i915_vma_unbind(struct i915_vma *vma)
 	i915_vma_detach(vma);
 	vma_unbind_pages(vma);
 
-	drm_mm_remove_node(&vma->node); /* pairs with i915_vma_destroy() */
+	drm_mm_remove_node(&vma->node); /* pairs with i915_vma_release() */
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/i915/i915_vma.h b/drivers/gpu/drm/i915/i915_vma.h
index 465932813bc5..ce1db908ad69 100644
--- a/drivers/gpu/drm/i915/i915_vma.h
+++ b/drivers/gpu/drm/i915/i915_vma.h
@@ -51,14 +51,19 @@ enum i915_cache_level;
  */
 struct i915_vma {
 	struct drm_mm_node node;
-	struct drm_i915_gem_object *obj;
+
 	struct i915_address_space *vm;
 	const struct i915_vma_ops *ops;
-	struct i915_fence_reg *fence;
+
+	struct drm_i915_gem_object *obj;
 	struct dma_resv *resv; /** Alias of obj->resv */
+
 	struct sg_table *pages;
 	void __iomem *iomap;
 	void *private; /* owned by creator */
+
+	struct i915_fence_reg *fence;
+
 	u64 size;
 	u64 display_alignment;
 	struct i915_page_sizes page_sizes;
@@ -71,6 +76,7 @@ struct i915_vma {
 	 * handles (but same file) for execbuf, i.e. the number of aliases
 	 * that exist in the ctx->handle_vmas LUT for this vma.
 	 */
+	struct kref ref;
 	atomic_t open_count;
 	atomic_t flags;
 	/**
@@ -333,7 +339,20 @@ int __must_check i915_vma_unbind(struct i915_vma *vma);
 void i915_vma_unlink_ctx(struct i915_vma *vma);
 void i915_vma_close(struct i915_vma *vma);
 void i915_vma_reopen(struct i915_vma *vma);
-void i915_vma_destroy(struct i915_vma *vma);
+
+static inline struct i915_vma *__i915_vma_get(struct i915_vma *vma)
+{
+	if (kref_get_unless_zero(&vma->ref))
+		return vma;
+
+	return NULL;
+}
+
+void i915_vma_release(struct kref *ref);
+static inline void __i915_vma_put(struct i915_vma *vma)
+{
+	kref_put(&vma->ref, i915_vma_release);
+}
 
 #define assert_vma_held(vma) dma_resv_assert_held((vma)->resv)
 
-- 
2.25.1

