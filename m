Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF82180953
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCJUlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:41:22 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:61526 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727313AbgCJUlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:41:21 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from haswell.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 20514554-1500050 
        for multiple; Tue, 10 Mar 2020 20:40:47 +0000
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>
Subject: [PATCH 2/5] drm/i915/gem: Avoid parking the vma as we unbind
Date:   Tue, 10 Mar 2020 20:40:43 +0000
Message-Id: <20200310204046.3995087-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310204046.3995087-1-chris@chris-wilson.co.uk>
References: <20200310204046.3995087-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In order to avoid keeping a reference on the i915_vma (which is long
overdue!) we have to coordinate all the possible lifetimes and only use
the vma while we know it is alive. In this episode, we are reminded that
while idle, the closed vma are destroyed. So if the GT idles while we are
working with the vma, the vma itself becomes invalid.

First class i915_vma here we come, but in the meantime keep piling on
the straw.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191203155032.3137263-1-chris@chris-wilson.co.uk
(cherry picked from commit cb6c3d45f948f8f184687a23fea30017d01e892f)
---
 drivers/gpu/drm/i915/i915_gem.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 3f07948ea4da..f7c52b437f6a 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -128,18 +128,33 @@ int i915_gem_object_unbind(struct drm_i915_gem_object *obj,
 						       struct i915_vma,
 						       obj_link))) {
 		struct i915_address_space *vm = vma->vm;
+		bool awake = false;
 
-		ret = -EBUSY;
+		ret = -EAGAIN;
 		if (!i915_vm_tryopen(vm))
 			break;
 
+		/* Prevent vma being freed by i915_vma_parked as we unbind */
+		if (intel_gt_pm_get_if_awake(vm->gt)) {
+			awake = true;
+		} else {
+			if (i915_vma_is_closed(vma)) {
+				spin_unlock(&obj->vma.lock);
+				goto err_vm;
+			}
+		}
+
 		list_move_tail(&vma->obj_link, &still_in_list);
 		spin_unlock(&obj->vma.lock);
 
+		ret = -EBUSY;
 		if (flags & I915_GEM_OBJECT_UNBIND_ACTIVE ||
 		    !i915_vma_is_active(vma))
 			ret = i915_vma_unbind(vma);
 
+		if (awake)
+			intel_gt_pm_put(vm->gt);
+err_vm:
 		i915_vm_close(vm);
 		spin_lock(&obj->vma.lock);
 	}
-- 
2.25.1

