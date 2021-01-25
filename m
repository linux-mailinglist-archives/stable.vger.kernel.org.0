Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA58302572
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 14:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbhAYNYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 08:24:19 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:59299 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728774AbhAYNWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 08:22:53 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 23693268-1500050 
        for multiple; Mon, 25 Jan 2021 13:21:57 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Matti=20H=C3=A4m=C3=A4l=C3=A4inen?= <ccr@tnsp.org>,
        Matthew Auld <matthew.auld@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/gem: Drop lru bumping on display unpinning
Date:   Mon, 25 Jan 2021 13:21:58 +0000
Message-Id: <20210125132158.2402159-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Simplify the frontbuffer unpin by removing the lock requirement. The LRU
bumping was primarily to protect the GTT from being evicted and from
frontbuffers being eagerly shrunk. Now we protect frontbuffers from the
shrinker, and we avoid accidentally evicting from the GTT, so the
benefit from bumping LRU is no more, and we can save more time by not.

Reported-and-tested-by: Matti Hämäläinen <ccr@tnsp.org>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2905
Fixes: c1793ba86a41 ("drm/i915: Add ww locking to pin_to_display_plane, v2.")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210119214336.1463-6-chris@chris-wilson.co.uk
(cherry picked from commit 14ca83eece9565a2d2177291ceb122982dc38420)
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: <stable@vger.kernel.org> # v5.10+
---
 drivers/gpu/drm/i915/display/intel_display.c |  7 +--
 drivers/gpu/drm/i915/display/intel_overlay.c |  4 +-
 drivers/gpu/drm/i915/gem/i915_gem_domain.c   | 45 --------------------
 drivers/gpu/drm/i915/gem/i915_gem_object.h   |  1 -
 4 files changed, 4 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index aabf09f89cad..b6566a992069 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -2294,7 +2294,7 @@ intel_pin_and_fence_fb_obj(struct drm_framebuffer *fb,
 		 */
 		ret = i915_vma_pin_fence(vma);
 		if (ret != 0 && INTEL_GEN(dev_priv) < 4) {
-			i915_gem_object_unpin_from_display_plane(vma);
+			i915_vma_unpin(vma);
 			vma = ERR_PTR(ret);
 			goto err;
 		}
@@ -2312,12 +2312,9 @@ intel_pin_and_fence_fb_obj(struct drm_framebuffer *fb,
 
 void intel_unpin_fb_vma(struct i915_vma *vma, unsigned long flags)
 {
-	i915_gem_object_lock(vma->obj, NULL);
 	if (flags & PLANE_HAS_FENCE)
 		i915_vma_unpin_fence(vma);
-	i915_gem_object_unpin_from_display_plane(vma);
-	i915_gem_object_unlock(vma->obj);
-
+	i915_vma_unpin(vma);
 	i915_vma_put(vma);
 }
 
diff --git a/drivers/gpu/drm/i915/display/intel_overlay.c b/drivers/gpu/drm/i915/display/intel_overlay.c
index 52b4f6193b4c..0095c8cac9b4 100644
--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -359,7 +359,7 @@ static void intel_overlay_release_old_vma(struct intel_overlay *overlay)
 	intel_frontbuffer_flip_complete(overlay->i915,
 					INTEL_FRONTBUFFER_OVERLAY(overlay->crtc->pipe));
 
-	i915_gem_object_unpin_from_display_plane(vma);
+	i915_vma_unpin(vma);
 	i915_vma_put(vma);
 }
 
@@ -860,7 +860,7 @@ static int intel_overlay_do_put_image(struct intel_overlay *overlay,
 	return 0;
 
 out_unpin:
-	i915_gem_object_unpin_from_display_plane(vma);
+	i915_vma_unpin(vma);
 out_pin_section:
 	atomic_dec(&dev_priv->gpu_error.pending_fb_pin);
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
index fcce6909f201..3d435bfff764 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
@@ -387,48 +387,6 @@ i915_gem_object_pin_to_display_plane(struct drm_i915_gem_object *obj,
 	return vma;
 }
 
-static void i915_gem_object_bump_inactive_ggtt(struct drm_i915_gem_object *obj)
-{
-	struct drm_i915_private *i915 = to_i915(obj->base.dev);
-	struct i915_vma *vma;
-
-	if (list_empty(&obj->vma.list))
-		return;
-
-	mutex_lock(&i915->ggtt.vm.mutex);
-	spin_lock(&obj->vma.lock);
-	for_each_ggtt_vma(vma, obj) {
-		if (!drm_mm_node_allocated(&vma->node))
-			continue;
-
-		GEM_BUG_ON(vma->vm != &i915->ggtt.vm);
-		list_move_tail(&vma->vm_link, &vma->vm->bound_list);
-	}
-	spin_unlock(&obj->vma.lock);
-	mutex_unlock(&i915->ggtt.vm.mutex);
-
-	if (i915_gem_object_is_shrinkable(obj)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&i915->mm.obj_lock, flags);
-
-		if (obj->mm.madv == I915_MADV_WILLNEED &&
-		    !atomic_read(&obj->mm.shrink_pin))
-			list_move_tail(&obj->mm.link, &i915->mm.shrink_list);
-
-		spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
-	}
-}
-
-void
-i915_gem_object_unpin_from_display_plane(struct i915_vma *vma)
-{
-	/* Bump the LRU to try and avoid premature eviction whilst flipping  */
-	i915_gem_object_bump_inactive_ggtt(vma->obj);
-
-	i915_vma_unpin(vma);
-}
-
 /**
  * Moves a single object to the CPU read, and possibly write domain.
  * @obj: object to act on
@@ -569,9 +527,6 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 	else
 		err = i915_gem_object_set_to_cpu_domain(obj, write_domain);
 
-	/* And bump the LRU for this access */
-	i915_gem_object_bump_inactive_ggtt(obj);
-
 	i915_gem_object_unlock(obj);
 
 	if (write_domain)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.h b/drivers/gpu/drm/i915/gem/i915_gem_object.h
index d46db8d8f38e..bc4871797120 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
@@ -471,7 +471,6 @@ i915_gem_object_pin_to_display_plane(struct drm_i915_gem_object *obj,
 				     u32 alignment,
 				     const struct i915_ggtt_view *view,
 				     unsigned int flags);
-void i915_gem_object_unpin_from_display_plane(struct i915_vma *vma);
 
 void i915_gem_object_make_unshrinkable(struct drm_i915_gem_object *obj);
 void i915_gem_object_make_shrinkable(struct drm_i915_gem_object *obj);
-- 
2.30.0

