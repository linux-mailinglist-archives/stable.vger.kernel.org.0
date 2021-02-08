Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEC73137CF
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhBHPbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:31:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233417AbhBHP1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:27:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52B5364F21;
        Mon,  8 Feb 2021 15:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797355;
        bh=vygRLVYR/FifQrVPdGIYFlKyYMnE2PgzcMRhS16570w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGwJiWJTmjM55NkESh5Atyz9RneUkjMD4pfucAbgREVSW8wjpeEmHEhaI/F05p/oQ
         IXNUN1R4BYqPeM369fv4b9Ea2189jvUs1WzOvOP+ate42/zULVz6evr7DrEJyl+N1u
         kXuIkdx/opUImAoFeL1lelW/g+A3yRwPLgaTyiRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Matti=20H=C3=A4m=C3=A4l=C3=A4inen?= <ccr@tnsp.org>
Subject: [PATCH 5.10 080/120] drm/i915/gem: Drop lru bumping on display unpinning
Date:   Mon,  8 Feb 2021 16:01:07 +0100
Message-Id: <20210208145821.592143918@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 761c70a52586a9214b29026d384d2c01b73661a8 upstream.

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
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    7 +---
 drivers/gpu/drm/i915/display/intel_overlay.c |    4 +-
 drivers/gpu/drm/i915/gem/i915_gem_domain.c   |   45 ---------------------------
 drivers/gpu/drm/i915/gem/i915_gem_object.h   |    1 
 4 files changed, 4 insertions(+), 53 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -2294,7 +2294,7 @@ intel_pin_and_fence_fb_obj(struct drm_fr
 		 */
 		ret = i915_vma_pin_fence(vma);
 		if (ret != 0 && INTEL_GEN(dev_priv) < 4) {
-			i915_gem_object_unpin_from_display_plane(vma);
+			i915_vma_unpin(vma);
 			vma = ERR_PTR(ret);
 			goto err;
 		}
@@ -2312,12 +2312,9 @@ err:
 
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
 
--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -359,7 +359,7 @@ static void intel_overlay_release_old_vm
 	intel_frontbuffer_flip_complete(overlay->i915,
 					INTEL_FRONTBUFFER_OVERLAY(overlay->crtc->pipe));
 
-	i915_gem_object_unpin_from_display_plane(vma);
+	i915_vma_unpin(vma);
 	i915_vma_put(vma);
 }
 
@@ -860,7 +860,7 @@ static int intel_overlay_do_put_image(st
 	return 0;
 
 out_unpin:
-	i915_gem_object_unpin_from_display_plane(vma);
+	i915_vma_unpin(vma);
 out_pin_section:
 	atomic_dec(&dev_priv->gpu_error.pending_fb_pin);
 
--- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
@@ -387,48 +387,6 @@ err:
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
@@ -569,9 +527,6 @@ i915_gem_set_domain_ioctl(struct drm_dev
 	else
 		err = i915_gem_object_set_to_cpu_domain(obj, write_domain);
 
-	/* And bump the LRU for this access */
-	i915_gem_object_bump_inactive_ggtt(obj);
-
 	i915_gem_object_unlock(obj);
 
 	if (write_domain)
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
@@ -471,7 +471,6 @@ i915_gem_object_pin_to_display_plane(str
 				     u32 alignment,
 				     const struct i915_ggtt_view *view,
 				     unsigned int flags);
-void i915_gem_object_unpin_from_display_plane(struct i915_vma *vma);
 
 void i915_gem_object_make_unshrinkable(struct drm_i915_gem_object *obj);
 void i915_gem_object_make_shrinkable(struct drm_i915_gem_object *obj);


