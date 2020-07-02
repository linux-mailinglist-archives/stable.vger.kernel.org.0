Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3914A212E86
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 23:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGBVKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 17:10:19 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:55419 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725954AbgGBVKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 17:10:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 21695553-1500050 
        for multiple; Thu, 02 Jul 2020 22:10:13 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: Also drop vm.ref along error paths for vma construction
Date:   Thu,  2 Jul 2020 22:10:15 +0100
Message-Id: <20200702211015.29604-1-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Not only do we need to release the vm.ref we acquired for the vma on the
duplicate insert branch, but also for the normal error paths, so roll
them all into one.

Reported-by: Andi Shyti <andi.shyti@intel.com>
Suggested-by: Andi Shyti <andi.shyti@intel.com>
Fixes: 2850748ef876 ("drm/i915: Pull i915_vma_pin under the vm->mutex")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andi Shyti <andi.shyti@intel.com>
Cc: <stable@vger.kernel.org> # v5.5+
---
 drivers/gpu/drm/i915/i915_vma.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 7fe1f317cd2b..f4e22e256ac6 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -104,6 +104,7 @@ vma_create(struct drm_i915_gem_object *obj,
 	   struct i915_address_space *vm,
 	   const struct i915_ggtt_view *view)
 {
+	struct i915_vma *pos = ERR_PTR(-E2BIG);
 	struct i915_vma *vma;
 	struct rb_node *rb, **p;
 
@@ -184,7 +185,6 @@ vma_create(struct drm_i915_gem_object *obj,
 	rb = NULL;
 	p = &obj->vma.tree.rb_node;
 	while (*p) {
-		struct i915_vma *pos;
 		long cmp;
 
 		rb = *p;
@@ -196,17 +196,12 @@ vma_create(struct drm_i915_gem_object *obj,
 		 * and dispose of ours.
 		 */
 		cmp = i915_vma_compare(pos, vm, view);
-		if (cmp == 0) {
-			spin_unlock(&obj->vma.lock);
-			i915_vm_put(vm);
-			i915_vma_free(vma);
-			return pos;
-		}
-
 		if (cmp < 0)
 			p = &rb->rb_right;
-		else
+		else if (cmp > 0)
 			p = &rb->rb_left;
+		else
+			goto err_unlock;
 	}
 	rb_link_node(&vma->obj_node, rb, p);
 	rb_insert_color(&vma->obj_node, &obj->vma.tree);
@@ -229,8 +224,9 @@ vma_create(struct drm_i915_gem_object *obj,
 err_unlock:
 	spin_unlock(&obj->vma.lock);
 err_vma:
+	i915_vm_put(vm);
 	i915_vma_free(vma);
-	return ERR_PTR(-E2BIG);
+	return pos;
 }
 
 static struct i915_vma *
-- 
2.20.1

