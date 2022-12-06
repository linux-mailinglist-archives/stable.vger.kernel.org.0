Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264F76448FD
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 17:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbiLFQQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 11:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbiLFQQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 11:16:29 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D5F3D91D
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 08:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670343117; x=1701879117;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1KukL7uqBN7y7df/4lq8AnWib/CZRuPR4zpKfrW3L1Q=;
  b=UTm66wgiS4AUuJCJ2E993EZfQsbrT9CWweg+gQU8qThb5fKMkNvqt8AZ
   Xn9P5pahMBMe+tuhsf4P/bL13j5DvNx9xE3uoRFNRPmnY9SrrZinUhQ4S
   fhex/+ejH1AEtp4b8XUd9x/Szz6F3K/sY88AdOUqSWyQS8uY7Mh0peFpp
   1ogCEMRdrcpPoW7nLBeV1R9SbBNpmsfN3J4b4ln/2srDQjOs1V2DFTDSo
   RhFOJdVZljWeOXSHdv3SAFO113wEE4SCE1tN9njHmCU9Y6mUyJIFEWw9a
   mKaXgzWw/qk2EGcBqN5LxGmOWU8HomzEeVvjv6kCSmiO4jer6WnVHP3eU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="316684717"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="316684717"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 08:11:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="820630292"
X-IronPort-AV: E=Sophos;i="5.96,222,1665471600"; 
   d="scan'208";a="820630292"
Received: from yk-book.ger.corp.intel.com (HELO mwauld-desk1.intel.com) ([10.252.19.83])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 08:11:54 -0800
From:   Matthew Auld <matthew.auld@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Mani Milani <mani@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: improve the catch-all evict to handle lock contention
Date:   Tue,  6 Dec 2022 16:11:41 +0000
Message-Id: <20221206161141.128921-1-matthew.auld@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
---
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    | 25 +++++++++++--
 drivers/gpu/drm/i915/gem/i915_gem_mman.c      |  2 +-
 drivers/gpu/drm/i915/i915_gem_evict.c         | 37 ++++++++++++++-----
 drivers/gpu/drm/i915/i915_gem_evict.h         |  4 +-
 drivers/gpu/drm/i915/i915_vma.c               |  2 +-
 .../gpu/drm/i915/selftests/i915_gem_evict.c   |  4 +-
 6 files changed, 56 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 86956b902c97..e2ce1e4e9723 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -745,25 +745,44 @@ static int eb_reserve(struct i915_execbuffer *eb)
 	 *
 	 * Defragmenting is skipped if all objects are pinned at a fixed location.
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
 				mutex_unlock(&eb->context->vm->mutex);
 			}
 			if (err)
 				return err;
 		}
 
+		if (pass == 3) {
+retry:
+			err = mutex_lock_interruptible(&eb->context->vm->mutex);
+			if (!err) {
+				struct drm_i915_gem_object *busy_bo = NULL;
+
+				err = i915_gem_evict_vm(eb->context->vm, &eb->ww, &busy_bo);
+				mutex_unlock(&eb->context->vm->mutex);
+				if (err && busy_bo) {
+					err = i915_gem_object_lock(busy_bo, &eb->ww);
+					i915_gem_object_put(busy_bo);
+					if (!err)
+						goto retry;
+				}
+			}
+			if (err)
+				return err;
+		}
+
 		list_for_each_entry(ev, &eb->unbound, bind_link) {
 			err = eb_reserve_vma(eb, ev, pin_flags);
 			if (err)
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

