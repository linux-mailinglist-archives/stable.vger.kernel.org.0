Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F017065D98F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbjADQ0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbjADQZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:25:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01ED333D5B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:25:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FE33B817B0
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BB8C433F0;
        Wed,  4 Jan 2023 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849522;
        bh=jrjfi5nfcpLhh5t4AUV0O4yH+ut+mriY1/lz0HpYKls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFJJ7XzNZksCiTpmw4U2QPGF7qqtAD79oFOOvSdsBWIl9cEalnNgrvfM2dh7aKgNS
         vQ7O9VBYKHZ59hvmati5F5lGPWLnaZsC1VnUmpkVQokZjcxIi6MYv5lk24xhbTn65H
         iZabuD7uo7IkcqTV7zDzC75GAkF80YGXRnRjzIWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Auld <matthew.auld@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Mani Milani <mani@chromium.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 202/207] drm/i915: improve the catch-all evict to handle lock contention
Date:   Wed,  4 Jan 2023 17:07:40 +0100
Message-Id: <20230104160518.317643247@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

commit 3f882f2d4f689627c1566c2c92087bc3ff734953 upstream.

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
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Mani Milani <mani@chromium.org>
Cc: <stable@vger.kernel.org> # v5.18+
Reviewed-by: Mani Milani <mani@chromium.org>
Tested-by: Mani Milani <mani@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221216113456.414183-1-matthew.auld@intel.com
(cherry picked from commit 801fa7a81f6da533cc5442fc40e32c72b76cd42a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c  |   59 +++++++++++++++++++-----
 drivers/gpu/drm/i915/gem/i915_gem_mman.c        |    2 
 drivers/gpu/drm/i915/i915_gem_evict.c           |   37 ++++++++++-----
 drivers/gpu/drm/i915/i915_gem_evict.h           |    4 +
 drivers/gpu/drm/i915/i915_vma.c                 |    2 
 drivers/gpu/drm/i915/selftests/i915_gem_evict.c |    4 -
 6 files changed, 82 insertions(+), 26 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -729,32 +729,69 @@ static int eb_reserve(struct i915_execbu
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
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -369,7 +369,7 @@ retry:
 		if (vma == ERR_PTR(-ENOSPC)) {
 			ret = mutex_lock_interruptible(&ggtt->vm.mutex);
 			if (!ret) {
-				ret = i915_gem_evict_vm(&ggtt->vm, &ww);
+				ret = i915_gem_evict_vm(&ggtt->vm, &ww, NULL);
 				mutex_unlock(&ggtt->vm.mutex);
 			}
 			if (ret)
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -416,6 +416,11 @@ int i915_gem_evict_for_node(struct i915_
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
@@ -425,7 +430,8 @@ int i915_gem_evict_for_node(struct i915_
  * To clarify: This is for freeing up virtual address space, not for freeing
  * memory in e.g. the shrinker.
  */
-int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
+int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww,
+		      struct drm_i915_gem_object **busy_bo)
 {
 	int ret = 0;
 
@@ -457,15 +463,22 @@ int i915_gem_evict_vm(struct i915_addres
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
@@ -473,25 +486,29 @@ int i915_gem_evict_vm(struct i915_addres
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
 
--- a/drivers/gpu/drm/i915/i915_gem_evict.h
+++ b/drivers/gpu/drm/i915/i915_gem_evict.h
@@ -11,6 +11,7 @@
 struct drm_mm_node;
 struct i915_address_space;
 struct i915_gem_ww_ctx;
+struct drm_i915_gem_object;
 
 int __must_check i915_gem_evict_something(struct i915_address_space *vm,
 					  struct i915_gem_ww_ctx *ww,
@@ -23,6 +24,7 @@ int __must_check i915_gem_evict_for_node
 					 struct drm_mm_node *node,
 					 unsigned int flags);
 int i915_gem_evict_vm(struct i915_address_space *vm,
-		      struct i915_gem_ww_ctx *ww);
+		      struct i915_gem_ww_ctx *ww,
+		      struct drm_i915_gem_object **busy_bo);
 
 #endif /* __I915_GEM_EVICT_H__ */
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1569,7 +1569,7 @@ static int __i915_ggtt_pin(struct i915_v
 			 * locked objects when called from execbuf when pinning
 			 * is removed. This would probably regress badly.
 			 */
-			i915_gem_evict_vm(vm, NULL);
+			i915_gem_evict_vm(vm, NULL, NULL);
 			mutex_unlock(&vm->mutex);
 		}
 	} while (1);
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
 


