Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3939264EAB1
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 12:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiLPLfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 06:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiLPLfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 06:35:07 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE06AED
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 03:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671190505; x=1702726505;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JWyFRpoxFtrWeZVUvl/geXVU377OBFhVdIFttIn0XLk=;
  b=J8qXG09AZSVkBOoR/nbsJ5pu/pmhE5gnCz5qnkM4RN0x293Gs+sqxPgf
   3dKYFPnvBINaLRXLaSPBgCFX7TgQILjdChQ448ttePOuXyCuLDRZxKqbn
   cKOXNxYC8Xrf86XiCKfctReCjrxY7XIVgJA0IHqWxootejQpmeENogvrQ
   NwEyJdvezFVsbNRBnw7+z5kcnU2q62qcQX7Ss6EK8WxnPcdFNMwcHk5Au
   j2wIvuV1P/TydyKvks0p7fk7GFJRicW7HtGVsWUmtWphmRxIeXaSWPzdw
   mamGFwjlkbViFfiUscswG7sSPFO/Aa5XZWJU3SiImHiBWqrNfTMiylOdU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="346032347"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="346032347"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 03:35:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="895211443"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="895211443"
Received: from psobol-mobl1.ger.corp.intel.com (HELO mwauld-desk1.intel.com) ([10.252.6.76])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 03:35:03 -0800
From:   Matthew Auld <matthew.auld@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Mani Milani <mani@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2] drm/i915: improve the catch-all evict to handle lock contention
Date:   Fri, 16 Dec 2022 11:34:56 +0000
Message-Id: <20221216113456.414183-1-matthew.auld@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The catch-all evict can fail due to object lock contention, since it
only goes as far as trylocking the object, due to us already holding the
vm->mutex. Doing a full object lock here can deadlock, since the
vm->mutex is always our inner lock. Add another execbuf pass which drops
the vm->mutex and then tries to grab the object will the full lock,
before then retrying the eviction. This should be good enough for now to
fix the immediate regression with userspace seeing -ENOSPC from execbuf
due to contended object locks during GTT eviction.

v2 (Mani)
  - Also revamp the docs for the different passes.

Testcase: igt@gem_ppgtt@shrink-vs-evict-*
Fixes: 7e00897be8bf ("drm/i915: Add object locking to i915_gem_evict_for_node and i915_gem_evict_something, v2.")
References: https://gitlab.freedesktop.org/drm/intel/-/issues/7627
References: https://gitlab.freedesktop.org/drm/intel/-/issues/7570
References: https://bugzilla.mozilla.org/show_bug.cgi?id=1779558
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Mani Milani <mani@chromium.org>
Cc: <stable@vger.kernel.org> # v5.18+
Reviewed-by: Mani Milani <mani@chromium.org>
Tested-by: Mani Milani <mani@chromium.org>
---
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 59 +++++++++++++++----
 drivers/gpu/drm/i915/gem/i915_gem_mman.c      |  2 +-
 drivers/gpu/drm/i915/i915_gem_evict.c         | 37 ++++++++----
 drivers/gpu/drm/i915/i915_gem_evict.h         |  4 +-
 drivers/gpu/drm/i915/i915_vma.c               |  2 +-
 .../gpu/drm/i915/selftests/i915_gem_evict.c   |  4 +-
 6 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 192bb3f10733..f98600ca7557 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -733,32 +733,69 @@ static int eb_reserve(struct i915_execbuffer *eb)
 	bool unpinned;
 
 	/*
-	 * Attempt to pin all of the buffers into the GTT.
-	 * This is done in 2 phases:
+	 * We have one more buffers that we couldn't bind, which could be due to
+	 * various reasons. To resolve this we have 4 passes, with every next
+	 * level turning the screws tighter:
 	 *
-	 * 1. Unbind all objects that do not match the GTT constraints for
-	 *    the execbuffer (fenceable, mappable, alignment etc).
-	 * 2. Bind new objects.
+	 * 0. Unbind all objects that do not match the GTT constraints for the
+	 * execbuffer (fenceable, mappable, alignment etc). Bind all new
+	 * objects.  This avoids unnecessary unbinding of later objects in order
+	 * to make room for the earlier objects *unless* we need to defragment.
 	 *
-	 * This avoid unnecessary unbinding of later objects in order to make
-	 * room for the earlier objects *unless* we need to defragment.
+	 * 1. Reorder the buffers, where objects with the most restrictive
+	 * placement requirements go first (ignoring fixed location buffers for
+	 * now).  For example, objects needing the mappable aperture (the first
+	 * 256M of GTT), should go first vs objects that can be placed just
+	 * about anywhere. Repeat the previous pass.
 	 *
-	 * Defragmenting is skipped if all objects are pinned at a fixed location.
+	 * 2. Consider buffers that are pinned at a fixed location. Also try to
+	 * evict the entire VM this time, leaving only objects that we were
+	 * unable to lock. Try again to bind the buffers. (still using the new
+	 * buffer order).
+	 *
+	 * 3. We likely have object lock contention for one or more stubborn
+	 * objects in the VM, for which we need to evict to make forward
+	 * progress (perhaps we are fighting the shrinker?). When evicting the
+	 * VM this time around, anything that we can't lock we now track using
+	 * the busy_bo, using the full lock (after dropping the vm->mutex to
+	 * prevent deadlocks), instead of trylock. We then continue to evict the
+	 * VM, this time with the stubborn object locked, which we can now
+	 * hopefully unbind (if still bound in the VM). Repeat until the VM is
+	 * evicted. Finally we should be able bind everything.
 	 */
-	for (pass = 0; pass <= 2; pass++) {
+	for (pass = 0; pass <= 3; pass++) {
 		int pin_flags = PIN_USER | PIN_VALIDATE;
 
 		if (pass == 0)
 			pin_flags |= PIN_NONBLOCK;
 
 		if (pass >= 1)
-			unpinned = eb_unbind(eb, pass == 2);
+			unpinned = eb_unbind(eb, pass >= 2);
 
 		if (pass == 2) {
 			err = mutex_lock_interruptible(&eb->context->vm->mutex);
 			if (!err) {
-				err = i915_gem_evict_vm(eb->context->vm, &eb->ww);
+				err = i915_gem_evict_vm(eb->context->vm, &eb->ww, NULL);
+				mutex_unlock(&eb->context->vm->mutex);
+			}
+			if (err)
+				return err;
+		}
+
+		if (pass == 3) {
+retry:
+			err = mutex_lock_interruptible(&eb->context->vm->mutex);
+			if (!err) {
+				struct drm_i915_gem_object *busy_bo = NULL;
+
+				err = i915_gem_evict_vm(eb->context->vm, &eb->ww, &busy_bo);
 				mutex_unlock(&eb->context->vm->mutex);
+				if (err && busy_bo) {
+					err = i915_gem_object_lock(busy_bo, &eb->ww);
+					i915_gem_object_put(busy_bo);
+					if (!err)
+						goto retry;
+				}
 			}
 			if (err)
 				return err;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index d73ba0f5c4c5..4f69bff63068 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -369,7 +369,7 @@ static vm_fault_t vm_fault_gtt(struct vm_fault *vmf)
 		if (vma == ERR_PTR(-ENOSPC)) {
 			ret = mutex_lock_interruptible(&ggtt->vm.mutex);
 			if (!ret) {
-				ret = i915_gem_evict_vm(&ggtt->vm, &ww);
+				ret = i915_gem_evict_vm(&ggtt->vm, &ww, NULL);
 				mutex_unlock(&ggtt->vm.mutex);
 			}
 			if (ret)
diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index 4cfe36b0366b..c02ebd6900ae 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -441,6 +441,11 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
  * @vm: Address space to cleanse
  * @ww: An optional struct i915_gem_ww_ctx. If not NULL, i915_gem_evict_vm
  * will be able to evict vma's locked by the ww as well.
+ * @busy_bo: Optional pointer to struct drm_i915_gem_object. If not NULL, then
+ * in the event i915_gem_evict_vm() is unable to trylock an object for eviction,
+ * then @busy_bo will point to it. -EBUSY is also returned. The caller must drop
+ * the vm->mutex, before trying again to acquire the contended lock. The caller
+ * also owns a reference to the object.
  *
  * This function evicts all vmas from a vm.
  *
@@ -450,7 +455,8 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
  * To clarify: This is for freeing up virtual address space, not for freeing
  * memory in e.g. the shrinker.
  */
-int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
+int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww,
+		      struct drm_i915_gem_object **busy_bo)
 {
 	int ret = 0;
 
@@ -482,15 +488,22 @@ int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
 			 * the resv is shared among multiple objects, we still
 			 * need the object ref.
 			 */
-			if (dying_vma(vma) ||
+			if (!i915_gem_object_get_rcu(vma->obj) ||
 			    (ww && (dma_resv_locking_ctx(vma->obj->base.resv) == &ww->ctx))) {
 				__i915_vma_pin(vma);
 				list_add(&vma->evict_link, &locked_eviction_list);
 				continue;
 			}
 
-			if (!i915_gem_object_trylock(vma->obj, ww))
+			if (!i915_gem_object_trylock(vma->obj, ww)) {
+				if (busy_bo) {
+					*busy_bo = vma->obj; /* holds ref */
+					ret = -EBUSY;
+					break;
+				}
+				i915_gem_object_put(vma->obj);
 				continue;
+			}
 
 			__i915_vma_pin(vma);
 			list_add(&vma->evict_link, &eviction_list);
@@ -498,25 +511,29 @@ int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
 		if (list_empty(&eviction_list) && list_empty(&locked_eviction_list))
 			break;
 
-		ret = 0;
 		/* Unbind locked objects first, before unlocking the eviction_list */
 		list_for_each_entry_safe(vma, vn, &locked_eviction_list, evict_link) {
 			__i915_vma_unpin(vma);
 
-			if (ret == 0)
+			if (ret == 0) {
 				ret = __i915_vma_unbind(vma);
-			if (ret != -EINTR) /* "Get me out of here!" */
-				ret = 0;
+				if (ret != -EINTR) /* "Get me out of here!" */
+					ret = 0;
+			}
+			if (!dying_vma(vma))
+				i915_gem_object_put(vma->obj);
 		}
 
 		list_for_each_entry_safe(vma, vn, &eviction_list, evict_link) {
 			__i915_vma_unpin(vma);
-			if (ret == 0)
+			if (ret == 0) {
 				ret = __i915_vma_unbind(vma);
-			if (ret != -EINTR) /* "Get me out of here!" */
-				ret = 0;
+				if (ret != -EINTR) /* "Get me out of here!" */
+					ret = 0;
+			}
 
 			i915_gem_object_unlock(vma->obj);
+			i915_gem_object_put(vma->obj);
 		}
 	} while (ret == 0);
 
diff --git a/drivers/gpu/drm/i915/i915_gem_evict.h b/drivers/gpu/drm/i915/i915_gem_evict.h
index e593c530f9bd..bf0ee0e4fe60 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.h
+++ b/drivers/gpu/drm/i915/i915_gem_evict.h
@@ -11,6 +11,7 @@
 struct drm_mm_node;
 struct i915_address_space;
 struct i915_gem_ww_ctx;
+struct drm_i915_gem_object;
 
 int __must_check i915_gem_evict_something(struct i915_address_space *vm,
 					  struct i915_gem_ww_ctx *ww,
@@ -23,6 +24,7 @@ int __must_check i915_gem_evict_for_node(struct i915_address_space *vm,
 					 struct drm_mm_node *node,
 					 unsigned int flags);
 int i915_gem_evict_vm(struct i915_address_space *vm,
-		      struct i915_gem_ww_ctx *ww);
+		      struct i915_gem_ww_ctx *ww,
+		      struct drm_i915_gem_object **busy_bo);
 
 #endif /* __I915_GEM_EVICT_H__ */
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 34f0e6c923c2..7d044888ac33 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1599,7 +1599,7 @@ static int __i915_ggtt_pin(struct i915_vma *vma, struct i915_gem_ww_ctx *ww,
 			 * locked objects when called from execbuf when pinning
 			 * is removed. This would probably regress badly.
 			 */
-			i915_gem_evict_vm(vm, NULL);
+			i915_gem_evict_vm(vm, NULL, NULL);
 			mutex_unlock(&vm->mutex);
 		}
 	} while (1);
diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c b/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
index 8c6517d29b8e..37068542aafe 100644
--- a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
@@ -344,7 +344,7 @@ static int igt_evict_vm(void *arg)
 
 	/* Everything is pinned, nothing should happen */
 	mutex_lock(&ggtt->vm.mutex);
-	err = i915_gem_evict_vm(&ggtt->vm, NULL);
+	err = i915_gem_evict_vm(&ggtt->vm, NULL, NULL);
 	mutex_unlock(&ggtt->vm.mutex);
 	if (err) {
 		pr_err("i915_gem_evict_vm on a full GGTT returned err=%d]\n",
@@ -356,7 +356,7 @@ static int igt_evict_vm(void *arg)
 
 	for_i915_gem_ww(&ww, err, false) {
 		mutex_lock(&ggtt->vm.mutex);
-		err = i915_gem_evict_vm(&ggtt->vm, &ww);
+		err = i915_gem_evict_vm(&ggtt->vm, &ww, NULL);
 		mutex_unlock(&ggtt->vm.mutex);
 	}
 
-- 
2.38.1

