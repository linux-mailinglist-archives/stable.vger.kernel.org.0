Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB16512280B
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 10:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfLQJ4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 04:56:53 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:53913 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725870AbfLQJ4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 04:56:52 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 19605947-1500050 
        for multiple; Tue, 17 Dec 2019 09:56:44 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     tvrtko.ursulin@intel.com, matthew.william.auld@gmail.com,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/8] drm/i915: Hold reference to intel_frontbuffer as we track activity
Date:   Tue, 17 Dec 2019 09:56:36 +0000
Message-Id: <20191217095642.3124521-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217095642.3124521-1-chris@chris-wilson.co.uk>
References: <20191217095642.3124521-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since obj->frontbuffer is no longer protected by the struct_mutex, as we
are processing the execbuf, it may be removed. Mark the
intel_frontbuffer as rcu protected, and so acquire a reference to
the struct as we track activity upon it.

Closes: https://gitlab.freedesktop.org/drm/intel/issues/827
Fixes: 8e7cb1799b4f ("drm/i915: Extract intel_frontbuffer active tracking")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v5.4+
---
 drivers/gpu/drm/i915/display/intel_display.c  |  2 +-
 .../gpu/drm/i915/display/intel_frontbuffer.c  | 16 ++++-----
 .../gpu/drm/i915/display/intel_frontbuffer.h  | 34 +++++++++++++++++--
 drivers/gpu/drm/i915/display/intel_overlay.c  | 17 +++++++---
 drivers/gpu/drm/i915/gem/i915_gem_clflush.c   |  3 +-
 drivers/gpu/drm/i915/gem/i915_gem_domain.c    |  4 +--
 drivers/gpu/drm/i915/gem/i915_gem_object.c    | 26 +++++++++++++-
 drivers/gpu/drm/i915/gem/i915_gem_object.h    | 23 ++++++++++++-
 .../gpu/drm/i915/gem/i915_gem_object_types.h  |  2 +-
 drivers/gpu/drm/i915/i915_gem.c               | 10 +++---
 drivers/gpu/drm/i915/i915_vma.c               | 10 ++++--
 11 files changed, 116 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 64e4bfb0dfc9..e18ee1f17d6e 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -15186,7 +15186,7 @@ intel_prepare_plane_fb(struct drm_plane *plane,
 		return ret;
 
 	fb_obj_bump_render_priority(obj);
-	intel_frontbuffer_flush(obj->frontbuffer, ORIGIN_DIRTYFB);
+	i915_gem_object_flush_frontbuffer(obj, ORIGIN_DIRTYFB);
 
 	if (!new_plane_state->uapi.fence) { /* implicit fencing */
 		struct dma_fence *fence;
diff --git a/drivers/gpu/drm/i915/display/intel_frontbuffer.c b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
index 84b164f31895..6cb02c912acc 100644
--- a/drivers/gpu/drm/i915/display/intel_frontbuffer.c
+++ b/drivers/gpu/drm/i915/display/intel_frontbuffer.c
@@ -229,11 +229,11 @@ static void frontbuffer_release(struct kref *ref)
 		vma->display_alignment = I915_GTT_MIN_ALIGNMENT;
 	spin_unlock(&obj->vma.lock);
 
-	obj->frontbuffer = NULL;
+	RCU_INIT_POINTER(obj->frontbuffer, NULL);
 	spin_unlock(&to_i915(obj->base.dev)->fb_tracking.lock);
 
 	i915_gem_object_put(obj);
-	kfree(front);
+	kfree_rcu(front, rcu);
 }
 
 struct intel_frontbuffer *
@@ -242,11 +242,7 @@ intel_frontbuffer_get(struct drm_i915_gem_object *obj)
 	struct drm_i915_private *i915 = to_i915(obj->base.dev);
 	struct intel_frontbuffer *front;
 
-	spin_lock(&i915->fb_tracking.lock);
-	front = obj->frontbuffer;
-	if (front)
-		kref_get(&front->ref);
-	spin_unlock(&i915->fb_tracking.lock);
+	front = __intel_frontbuffer_get(obj);
 	if (front)
 		return front;
 
@@ -262,13 +258,13 @@ intel_frontbuffer_get(struct drm_i915_gem_object *obj)
 			 i915_active_may_sleep(frontbuffer_retire));
 
 	spin_lock(&i915->fb_tracking.lock);
-	if (obj->frontbuffer) {
+	if (rcu_access_pointer(obj->frontbuffer)) {
 		kfree(front);
-		front = obj->frontbuffer;
+		front = rcu_dereference_protected(obj->frontbuffer, true);
 		kref_get(&front->ref);
 	} else {
 		i915_gem_object_get(obj);
-		obj->frontbuffer = front;
+		rcu_assign_pointer(obj->frontbuffer, front);
 	}
 	spin_unlock(&i915->fb_tracking.lock);
 
diff --git a/drivers/gpu/drm/i915/display/intel_frontbuffer.h b/drivers/gpu/drm/i915/display/intel_frontbuffer.h
index adc64d61a4a5..ae4a1fff9f41 100644
--- a/drivers/gpu/drm/i915/display/intel_frontbuffer.h
+++ b/drivers/gpu/drm/i915/display/intel_frontbuffer.h
@@ -27,10 +27,10 @@
 #include <linux/atomic.h>
 #include <linux/kref.h>
 
+#include "gem/i915_gem_object_types.h"
 #include "i915_active.h"
 
 struct drm_i915_private;
-struct drm_i915_gem_object;
 
 enum fb_op_origin {
 	ORIGIN_GTT,
@@ -45,6 +45,7 @@ struct intel_frontbuffer {
 	atomic_t bits;
 	struct i915_active write;
 	struct drm_i915_gem_object *obj;
+	struct rcu_head rcu;
 };
 
 void intel_frontbuffer_flip_prepare(struct drm_i915_private *i915,
@@ -54,6 +55,35 @@ void intel_frontbuffer_flip_complete(struct drm_i915_private *i915,
 void intel_frontbuffer_flip(struct drm_i915_private *i915,
 			    unsigned frontbuffer_bits);
 
+void intel_frontbuffer_put(struct intel_frontbuffer *front);
+
+static inline struct intel_frontbuffer *
+__intel_frontbuffer_get(const struct drm_i915_gem_object *obj)
+{
+	struct intel_frontbuffer *front;
+
+	if (likely(!rcu_access_pointer(obj->frontbuffer)))
+		return NULL;
+
+	rcu_read_lock();
+	do {
+		front = rcu_dereference(obj->frontbuffer);
+		if (!front)
+			break;
+
+		if (!kref_get_unless_zero(&front->ref))
+			continue;
+
+		if (front == rcu_access_pointer(obj->frontbuffer))
+			break;
+
+		intel_frontbuffer_put(front);
+	} while (1);
+	rcu_read_unlock();
+
+	return front;
+}
+
 struct intel_frontbuffer *
 intel_frontbuffer_get(struct drm_i915_gem_object *obj);
 
@@ -119,6 +149,4 @@ void intel_frontbuffer_track(struct intel_frontbuffer *old,
 			     struct intel_frontbuffer *new,
 			     unsigned int frontbuffer_bits);
 
-void intel_frontbuffer_put(struct intel_frontbuffer *front);
-
 #endif /* __INTEL_FRONTBUFFER_H__ */
diff --git a/drivers/gpu/drm/i915/display/intel_overlay.c b/drivers/gpu/drm/i915/display/intel_overlay.c
index 2a44b3be2600..6097594468a9 100644
--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -279,12 +279,21 @@ static void intel_overlay_flip_prepare(struct intel_overlay *overlay,
 				       struct i915_vma *vma)
 {
 	enum pipe pipe = overlay->crtc->pipe;
+	struct intel_frontbuffer *from, *to;
 
 	WARN_ON(overlay->old_vma);
 
-	intel_frontbuffer_track(overlay->vma ? overlay->vma->obj->frontbuffer : NULL,
-				vma ? vma->obj->frontbuffer : NULL,
-				INTEL_FRONTBUFFER_OVERLAY(pipe));
+	if (overlay->vma)
+		from = intel_frontbuffer_get(overlay->vma->obj);
+	if (vma)
+		to = intel_frontbuffer_get(vma->obj);
+
+	intel_frontbuffer_track(from, to, INTEL_FRONTBUFFER_OVERLAY(pipe));
+
+	if (to)
+		intel_frontbuffer_put(to);
+	if (from)
+		intel_frontbuffer_put(from);
 
 	intel_frontbuffer_flip_prepare(overlay->i915,
 				       INTEL_FRONTBUFFER_OVERLAY(pipe));
@@ -764,7 +773,7 @@ static int intel_overlay_do_put_image(struct intel_overlay *overlay,
 		ret = PTR_ERR(vma);
 		goto out_pin_section;
 	}
-	intel_frontbuffer_flush(new_bo->frontbuffer, ORIGIN_DIRTYFB);
+	i915_gem_object_flush_frontbuffer(new_bo, ORIGIN_DIRTYFB);
 
 	if (!overlay->active) {
 		u32 oconfig;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_clflush.c b/drivers/gpu/drm/i915/gem/i915_gem_clflush.c
index 5448efa77710..34be4c0ee7c5 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_clflush.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_clflush.c
@@ -20,7 +20,8 @@ static void __do_clflush(struct drm_i915_gem_object *obj)
 {
 	GEM_BUG_ON(!i915_gem_object_has_pages(obj));
 	drm_clflush_sg(obj->mm.pages);
-	intel_frontbuffer_flush(obj->frontbuffer, ORIGIN_CPU);
+
+	i915_gem_object_flush_frontbuffer(obj, ORIGIN_CPU);
 }
 
 static int clflush_work(struct dma_fence_work *base)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
index 65f1851e2863..0cc40e77bbd2 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
@@ -558,7 +558,7 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 	i915_gem_object_unlock(obj);
 
 	if (write_domain)
-		intel_frontbuffer_invalidate(obj->frontbuffer, ORIGIN_CPU);
+		i915_gem_object_invalidate_frontbuffer(obj, ORIGIN_CPU);
 
 out_unpin:
 	i915_gem_object_unpin_pages(obj);
@@ -678,7 +678,7 @@ int i915_gem_object_prepare_write(struct drm_i915_gem_object *obj,
 	}
 
 out:
-	intel_frontbuffer_invalidate(obj->frontbuffer, ORIGIN_CPU);
+	i915_gem_object_invalidate_frontbuffer(obj, ORIGIN_CPU);
 	obj->mm.dirty = true;
 	/* return with the pages pinned */
 	return 0;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 16d611db9ca6..ddc82a7a34ff 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -313,7 +313,7 @@ i915_gem_object_flush_write_domain(struct drm_i915_gem_object *obj,
 		}
 		spin_unlock(&obj->vma.lock);
 
-		intel_frontbuffer_flush(obj->frontbuffer, ORIGIN_CPU);
+		i915_gem_object_flush_frontbuffer(obj, ORIGIN_CPU);
 		break;
 
 	case I915_GEM_DOMAIN_WC:
@@ -333,6 +333,30 @@ i915_gem_object_flush_write_domain(struct drm_i915_gem_object *obj,
 	obj->write_domain = 0;
 }
 
+void __i915_gem_object_flush_frontbuffer(struct drm_i915_gem_object *obj,
+					 enum fb_op_origin origin)
+{
+	struct intel_frontbuffer *front;
+
+	front = __intel_frontbuffer_get(obj);
+	if (front) {
+		intel_frontbuffer_flush(front, origin);
+		intel_frontbuffer_put(front);
+	}
+}
+
+void __i915_gem_object_invalidate_frontbuffer(struct drm_i915_gem_object *obj,
+					      enum fb_op_origin origin)
+{
+	struct intel_frontbuffer *front;
+
+	front = __intel_frontbuffer_get(obj);
+	if (front) {
+		intel_frontbuffer_invalidate(front, origin);
+		intel_frontbuffer_put(front);
+	}
+}
+
 void i915_gem_init__objects(struct drm_i915_private *i915)
 {
 	INIT_WORK(&i915->mm.free_work, __i915_gem_free_work);
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.h b/drivers/gpu/drm/i915/gem/i915_gem_object.h
index a1eb7c0b23ac..858f8bf49a04 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
@@ -13,8 +13,8 @@
 
 #include <drm/i915_drm.h>
 
+#include "display/intel_frontbuffer.h"
 #include "i915_gem_object_types.h"
-
 #include "i915_gem_gtt.h"
 
 void i915_gem_init__objects(struct drm_i915_private *i915);
@@ -471,4 +471,25 @@ int i915_gem_object_wait_priority(struct drm_i915_gem_object *obj,
 				  unsigned int flags,
 				  const struct i915_sched_attr *attr);
 
+void __i915_gem_object_flush_frontbuffer(struct drm_i915_gem_object *obj,
+					 enum fb_op_origin origin);
+void __i915_gem_object_invalidate_frontbuffer(struct drm_i915_gem_object *obj,
+					      enum fb_op_origin origin);
+
+static inline void
+i915_gem_object_flush_frontbuffer(struct drm_i915_gem_object *obj,
+				  enum fb_op_origin origin)
+{
+	if (unlikely(rcu_access_pointer(obj->frontbuffer)))
+		__i915_gem_object_flush_frontbuffer(obj, origin);
+}
+
+static inline void
+i915_gem_object_invalidate_frontbuffer(struct drm_i915_gem_object *obj,
+				       enum fb_op_origin origin)
+{
+	if (unlikely(rcu_access_pointer(obj->frontbuffer)))
+		__i915_gem_object_invalidate_frontbuffer(obj, origin);
+}
+
 #endif
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
index 2d404e6f63df..88e268633fdc 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -173,7 +173,7 @@ struct drm_i915_gem_object {
 	 */
 	u16 write_domain;
 
-	struct intel_frontbuffer *frontbuffer;
+	struct intel_frontbuffer __rcu *frontbuffer;
 
 	/** Current tiling stride for the object, if it's tiled. */
 	unsigned int tiling_and_stride;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 5eeef1ef7448..f19c678ebefc 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -200,7 +200,7 @@ i915_gem_phys_pwrite(struct drm_i915_gem_object *obj,
 	 * We manually control the domain here and pretend that it
 	 * remains coherent i.e. in the GTT domain, like shmem_pwrite.
 	 */
-	intel_frontbuffer_invalidate(obj->frontbuffer, ORIGIN_CPU);
+	i915_gem_object_invalidate_frontbuffer(obj, ORIGIN_CPU);
 
 	if (copy_from_user(vaddr, user_data, args->size))
 		return -EFAULT;
@@ -208,7 +208,7 @@ i915_gem_phys_pwrite(struct drm_i915_gem_object *obj,
 	drm_clflush_virt_range(vaddr, args->size);
 	intel_gt_chipset_flush(&to_i915(obj->base.dev)->gt);
 
-	intel_frontbuffer_flush(obj->frontbuffer, ORIGIN_CPU);
+	i915_gem_object_flush_frontbuffer(obj, ORIGIN_CPU);
 	return 0;
 }
 
@@ -628,7 +628,7 @@ i915_gem_gtt_pwrite_fast(struct drm_i915_gem_object *obj,
 		goto out_unpin;
 	}
 
-	intel_frontbuffer_invalidate(obj->frontbuffer, ORIGIN_CPU);
+	i915_gem_object_invalidate_frontbuffer(obj, ORIGIN_CPU);
 
 	user_data = u64_to_user_ptr(args->data_ptr);
 	offset = args->offset;
@@ -672,7 +672,7 @@ i915_gem_gtt_pwrite_fast(struct drm_i915_gem_object *obj,
 	}
 
 	intel_gt_flush_ggtt_writes(ggtt->vm.gt);
-	intel_frontbuffer_flush(obj->frontbuffer, ORIGIN_CPU);
+	i915_gem_object_flush_frontbuffer(obj, ORIGIN_CPU);
 
 	i915_gem_object_unlock_fence(obj, fence);
 out_unpin:
@@ -761,7 +761,7 @@ i915_gem_shmem_pwrite(struct drm_i915_gem_object *obj,
 		offset = 0;
 	}
 
-	intel_frontbuffer_flush(obj->frontbuffer, ORIGIN_CPU);
+	i915_gem_object_flush_frontbuffer(obj, ORIGIN_CPU);
 	i915_gem_object_unlock_fence(obj, fence);
 
 	return ret;
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 878975b37a45..8df0bf85f800 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1148,8 +1148,14 @@ int i915_vma_move_to_active(struct i915_vma *vma,
 		return err;
 
 	if (flags & EXEC_OBJECT_WRITE) {
-		if (intel_frontbuffer_invalidate(obj->frontbuffer, ORIGIN_CS))
-			i915_active_add_request(&obj->frontbuffer->write, rq);
+		struct intel_frontbuffer *front;
+
+		front = __intel_frontbuffer_get(obj);
+		if (unlikely(front)) {
+			if (intel_frontbuffer_invalidate(front, ORIGIN_CS))
+				i915_active_add_request(&front->write, rq);
+			intel_frontbuffer_put(front);
+		}
 
 		dma_resv_add_excl_fence(vma->resv, &rq->fence);
 		obj->write_domain = I915_GEM_DOMAIN_RENDER;
-- 
2.24.1

