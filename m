Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7716E582680
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 14:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbiG0MaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 08:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbiG0MaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 08:30:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA21402EC;
        Wed, 27 Jul 2022 05:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2035611E0;
        Wed, 27 Jul 2022 12:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D780C43141;
        Wed, 27 Jul 2022 12:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658925001;
        bh=c7qOC1C12r1LYkOoQUuN/lHfMMwKwIf4vSK+nBo3JKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXhCf6Z4+ufJE9p/Te7ARaH9Fhp7F1CT+IRa1XWKVztKn2U8p9IUAlXX/vLGPuM81
         /kxR2ahK3nTo0y+KdeBZc0RSmmca8E+c2eO5u+9QfdCLJp8D8Yk5Rj9SEH3o4vwfOy
         hPBZK8b4jDcrBqEUJUGno9g7WWMzkPMpSgws+Pmiaj0EKf72THAbMne5CkaZzghRV1
         csN2GSKecogdRIHb5fULY0FaSvPGsNIVvelkP1kuOqGB8KSCjcLbiryxvQ0hjno+XV
         IRbpCUY0qBiZHyOc+ODbPtNLv0JOlcUhR04oTQIQue3NAtp6sW/qGYXRgekTd1bppz
         3v5lxmZr3Tc4w==
Received: from mchehab by mail.kernel.org with local (Exim 4.95)
        (envelope-from <mchehab@kernel.org>)
        id 1oGgAo-003xmP-CW;
        Wed, 27 Jul 2022 14:29:58 +0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Ayaz A Siddiqui <ayaz.siddiqui@intel.com>,
        Casey Bowman <casey.g.bowman@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Cheng <michael.cheng@intel.com>,
        Nirmoy Das <nirmoy.das@linux.intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, stable@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Fei Yang <fei.yang@intel.com>
Subject: [PATCH v3 5/6] drm/i915/gt: Batch TLB invalidations
Date:   Wed, 27 Jul 2022 14:29:55 +0200
Message-Id: <4e97ef5deb6739cadaaf40aa45620547e9c4ec06.1658924372.git.mchehab@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1658924372.git.mchehab@kernel.org>
References: <cover.1658924372.git.mchehab@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@intel.com>

Invalidate TLB in batches, in order to reduce performance regressions.

Currently, every caller performs a full barrier around a TLB
invalidation, ignoring all other invalidations that may have already
removed their PTEs from the cache. As this is a synchronous operation
and can be quite slow, we cause multiple threads to contend on the TLB
invalidate mutex blocking userspace.

We only need to invalidate the TLB once after replacing our PTE to
ensure that there is no possible continued access to the physical
address before releasing our pages. By tracking a seqno for each full
TLB invalidate we can quickly determine if one has been performed since
rewriting the PTE, and only if necessary trigger one for ourselves.

That helps to reduce the performance regression introduced by TLB
invalidate logic.

[mchehab: rebased to not require moving the code to a separate file]

Cc: stable@vger.kernel.org
Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
Suggested-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
---

To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v3 0/6] at: https://lore.kernel.org/all/cover.1658924372.git.mchehab@kernel.org/

 .../gpu/drm/i915/gem/i915_gem_object_types.h  |  3 +-
 drivers/gpu/drm/i915/gem/i915_gem_pages.c     | 21 +++++---
 drivers/gpu/drm/i915/gt/intel_gt.c            | 53 ++++++++++++++-----
 drivers/gpu/drm/i915/gt/intel_gt.h            | 12 ++++-
 drivers/gpu/drm/i915/gt/intel_gt_types.h      | 18 ++++++-
 drivers/gpu/drm/i915/gt/intel_ppgtt.c         |  8 ++-
 drivers/gpu/drm/i915/i915_vma.c               | 33 +++++++++---
 drivers/gpu/drm/i915/i915_vma.h               |  1 +
 drivers/gpu/drm/i915/i915_vma_resource.c      |  5 +-
 drivers/gpu/drm/i915/i915_vma_resource.h      |  6 ++-
 10 files changed, 125 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
index 5cf36a130061..9f6b14ec189a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -335,7 +335,6 @@ struct drm_i915_gem_object {
 #define I915_BO_READONLY          BIT(7)
 #define I915_TILING_QUIRK_BIT     8 /* unknown swizzling; do not release! */
 #define I915_BO_PROTECTED         BIT(9)
-#define I915_BO_WAS_BOUND_BIT     10
 	/**
 	 * @mem_flags - Mutable placement-related flags
 	 *
@@ -616,6 +615,8 @@ struct drm_i915_gem_object {
 		 * pages were last acquired.
 		 */
 		bool dirty:1;
+
+		u32 tlb;
 	} mm;
 
 	struct {
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index 6835279943df..8357dbdcab5c 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -191,6 +191,18 @@ static void unmap_object(struct drm_i915_gem_object *obj, void *ptr)
 		vunmap(ptr);
 }
 
+static void flush_tlb_invalidate(struct drm_i915_gem_object *obj)
+{
+	struct drm_i915_private *i915 = to_i915(obj->base.dev);
+	struct intel_gt *gt = to_gt(i915);
+
+	if (!obj->mm.tlb)
+		return;
+
+	intel_gt_invalidate_tlb(gt, obj->mm.tlb);
+	obj->mm.tlb = 0;
+}
+
 struct sg_table *
 __i915_gem_object_unset_pages(struct drm_i915_gem_object *obj)
 {
@@ -216,14 +228,7 @@ __i915_gem_object_unset_pages(struct drm_i915_gem_object *obj)
 	__i915_gem_object_reset_page_iter(obj);
 	obj->mm.page_sizes.phys = obj->mm.page_sizes.sg = 0;
 
-	if (test_and_clear_bit(I915_BO_WAS_BOUND_BIT, &obj->flags)) {
-		struct drm_i915_private *i915 = to_i915(obj->base.dev);
-		struct intel_gt *gt = to_gt(i915);
-		intel_wakeref_t wakeref;
-
-		with_intel_gt_pm_if_awake(gt, wakeref)
-			intel_gt_invalidate_tlbs(gt);
-	}
+	flush_tlb_invalidate(obj);
 
 	return pages;
 }
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
index 5c55a90672f4..f435e06125aa 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -38,8 +38,6 @@ static void __intel_gt_init_early(struct intel_gt *gt)
 {
 	spin_lock_init(&gt->irq_lock);
 
-	mutex_init(&gt->tlb_invalidate_lock);
-
 	INIT_LIST_HEAD(&gt->closed_vma);
 	spin_lock_init(&gt->closed_lock);
 
@@ -50,6 +48,8 @@ static void __intel_gt_init_early(struct intel_gt *gt)
 	intel_gt_init_reset(gt);
 	intel_gt_init_requests(gt);
 	intel_gt_init_timelines(gt);
+	mutex_init(&gt->tlb.invalidate_lock);
+	seqcount_mutex_init(&gt->tlb.seqno, &gt->tlb.invalidate_lock);
 	intel_gt_pm_init_early(gt);
 
 	intel_uc_init_early(&gt->uc);
@@ -770,6 +770,7 @@ void intel_gt_driver_late_release_all(struct drm_i915_private *i915)
 		intel_gt_fini_requests(gt);
 		intel_gt_fini_reset(gt);
 		intel_gt_fini_timelines(gt);
+		mutex_destroy(&gt->tlb.invalidate_lock);
 		intel_engines_free(gt);
 	}
 }
@@ -908,7 +909,7 @@ get_reg_and_bit(const struct intel_engine_cs *engine, const bool gen8,
 	return rb;
 }
 
-void intel_gt_invalidate_tlbs(struct intel_gt *gt)
+static void mmio_invalidate_full(struct intel_gt *gt)
 {
 	static const i915_reg_t gen8_regs[] = {
 		[RENDER_CLASS]			= GEN8_RTCR,
@@ -931,12 +932,6 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	const i915_reg_t *regs;
 	unsigned int num = 0;
 
-	if (I915_SELFTEST_ONLY(gt->awake == -ENODEV))
-		return;
-
-	if (intel_gt_is_wedged(gt))
-		return;
-
 	if (GRAPHICS_VER(i915) == 12) {
 		regs = gen12_regs;
 		num = ARRAY_SIZE(gen12_regs);
@@ -951,9 +946,6 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 			  "Platform does not implement TLB invalidation!"))
 		return;
 
-	GEM_TRACE("\n");
-
-	mutex_lock(&gt->tlb_invalidate_lock);
 	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
 
 	spin_lock_irq(&uncore->lock); /* serialise invalidate with GT reset */
@@ -973,6 +965,8 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 		awake |= engine->mask;
 	}
 
+	GT_TRACE(gt, "invalidated engines %08x\n", awake);
+
 	/* Wa_2207587034:tgl,dg1,rkl,adl-s,adl-p */
 	if (awake &&
 	    (IS_TIGERLAKE(i915) ||
@@ -1012,5 +1006,38 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
 	 * transitions.
 	 */
 	intel_uncore_forcewake_put_delayed(uncore, FORCEWAKE_ALL);
-	mutex_unlock(&gt->tlb_invalidate_lock);
+}
+
+static bool tlb_seqno_passed(const struct intel_gt *gt, u32 seqno)
+{
+	u32 cur = intel_gt_tlb_seqno(gt);
+
+	/* Only skip if a *full* TLB invalidate barrier has passed */
+	return (s32)(cur - ALIGN(seqno, 2)) > 0;
+}
+
+void intel_gt_invalidate_tlb(struct intel_gt *gt, u32 seqno)
+{
+	intel_wakeref_t wakeref;
+
+	if (I915_SELFTEST_ONLY(gt->awake == -ENODEV))
+		return;
+
+	if (intel_gt_is_wedged(gt))
+		return;
+
+	if (tlb_seqno_passed(gt, seqno))
+		return;
+
+	with_intel_gt_pm_if_awake(gt, wakeref) {
+		mutex_lock(&gt->tlb.invalidate_lock);
+		if (tlb_seqno_passed(gt, seqno))
+			goto unlock;
+
+		mmio_invalidate_full(gt);
+
+		write_seqcount_invalidate(&gt->tlb.seqno);
+unlock:
+		mutex_unlock(&gt->tlb.invalidate_lock);
+	}
 }
diff --git a/drivers/gpu/drm/i915/gt/intel_gt.h b/drivers/gpu/drm/i915/gt/intel_gt.h
index 82d6f248d876..40b06adf509a 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt.h
@@ -101,6 +101,16 @@ void intel_gt_info_print(const struct intel_gt_info *info,
 
 void intel_gt_watchdog_work(struct work_struct *work);
 
-void intel_gt_invalidate_tlbs(struct intel_gt *gt);
+static inline u32 intel_gt_tlb_seqno(const struct intel_gt *gt)
+{
+	return seqprop_sequence(&gt->tlb.seqno);
+}
+
+static inline u32 intel_gt_next_invalidate_tlb_full(const struct intel_gt *gt)
+{
+	return intel_gt_tlb_seqno(gt) | 1;
+}
+
+void intel_gt_invalidate_tlb(struct intel_gt *gt, u32 seqno);
 
 #endif /* __INTEL_GT_H__ */
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_types.h b/drivers/gpu/drm/i915/gt/intel_gt_types.h
index df708802889d..3804a583382b 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_types.h
@@ -11,6 +11,7 @@
 #include <linux/llist.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
+#include <linux/seqlock.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
@@ -83,7 +84,22 @@ struct intel_gt {
 	struct intel_uc uc;
 	struct intel_gsc gsc;
 
-	struct mutex tlb_invalidate_lock;
+	struct {
+		/* Serialize global tlb invalidations */
+		struct mutex invalidate_lock;
+
+		/*
+		 * Batch TLB invalidations
+		 *
+		 * After unbinding the PTE, we need to ensure the TLB
+		 * are invalidated prior to releasing the physical pages.
+		 * But we only need one such invalidation for all unbinds,
+		 * so we track how many TLB invalidations have been
+		 * performed since unbind the PTE and only emit an extra
+		 * invalidate if no full barrier has been passed.
+		 */
+		seqcount_mutex_t seqno;
+	} tlb;
 
 	struct i915_wa_list wa_list;
 
diff --git a/drivers/gpu/drm/i915/gt/intel_ppgtt.c b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
index d8b94d638559..2da6c82a8bd2 100644
--- a/drivers/gpu/drm/i915/gt/intel_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_ppgtt.c
@@ -206,8 +206,12 @@ void ppgtt_bind_vma(struct i915_address_space *vm,
 void ppgtt_unbind_vma(struct i915_address_space *vm,
 		      struct i915_vma_resource *vma_res)
 {
-	if (vma_res->allocated)
-		vm->clear_range(vm, vma_res->start, vma_res->vma_size);
+	if (!vma_res->allocated)
+		return;
+
+	vm->clear_range(vm, vma_res->start, vma_res->vma_size);
+	if (vma_res->tlb)
+		vma_invalidate_tlb(vm, *vma_res->tlb);
 }
 
 static unsigned long pd_count(u64 size, int shift)
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index ef3b04c7e153..84a9ccbc5fc5 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -538,8 +538,6 @@ int i915_vma_bind(struct i915_vma *vma,
 				   bind_flags);
 	}
 
-	set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
-
 	atomic_or(bind_flags, &vma->flags);
 	return 0;
 }
@@ -1310,6 +1308,19 @@ I915_SELFTEST_EXPORT int i915_vma_get_pages(struct i915_vma *vma)
 	return err;
 }
 
+void vma_invalidate_tlb(struct i915_address_space *vm, u32 tlb)
+{
+	/*
+	 * Before we release the pages that were bound by this vma, we
+	 * must invalidate all the TLBs that may still have a reference
+	 * back to our physical address. It only needs to be done once,
+	 * so after updating the PTE to point away from the pages, record
+	 * the most recent TLB invalidation seqno, and if we have not yet
+	 * flushed the TLBs upon release, perform a full invalidation.
+	 */
+	WRITE_ONCE(tlb, intel_gt_next_invalidate_tlb_full(vm->gt));
+}
+
 static void __vma_put_pages(struct i915_vma *vma, unsigned int count)
 {
 	/* We allocate under vma_get_pages, so beware the shrinker */
@@ -1941,7 +1952,12 @@ struct dma_fence *__i915_vma_evict(struct i915_vma *vma, bool async)
 		vma->vm->skip_pte_rewrite;
 	trace_i915_vma_unbind(vma);
 
-	unbind_fence = i915_vma_resource_unbind(vma_res);
+	if (async)
+		unbind_fence = i915_vma_resource_unbind(vma_res,
+							&vma->obj->mm.tlb);
+	else
+		unbind_fence = i915_vma_resource_unbind(vma_res, NULL);
+
 	vma->resource = NULL;
 
 	atomic_and(~(I915_VMA_BIND_MASK | I915_VMA_ERROR | I915_VMA_GGTT_WRITE),
@@ -1949,10 +1965,13 @@ struct dma_fence *__i915_vma_evict(struct i915_vma *vma, bool async)
 
 	i915_vma_detach(vma);
 
-	if (!async && unbind_fence) {
-		dma_fence_wait(unbind_fence, false);
-		dma_fence_put(unbind_fence);
-		unbind_fence = NULL;
+	if (!async) {
+		if (unbind_fence) {
+			dma_fence_wait(unbind_fence, false);
+			dma_fence_put(unbind_fence);
+			unbind_fence = NULL;
+		}
+		vma_invalidate_tlb(vma->vm, vma->obj->mm.tlb);
 	}
 
 	/*
diff --git a/drivers/gpu/drm/i915/i915_vma.h b/drivers/gpu/drm/i915/i915_vma.h
index 88ca0bd9c900..5048eed536da 100644
--- a/drivers/gpu/drm/i915/i915_vma.h
+++ b/drivers/gpu/drm/i915/i915_vma.h
@@ -213,6 +213,7 @@ bool i915_vma_misplaced(const struct i915_vma *vma,
 			u64 size, u64 alignment, u64 flags);
 void __i915_vma_set_map_and_fenceable(struct i915_vma *vma);
 void i915_vma_revoke_mmap(struct i915_vma *vma);
+void vma_invalidate_tlb(struct i915_address_space *vm, u32 tlb);
 struct dma_fence *__i915_vma_evict(struct i915_vma *vma, bool async);
 int __i915_vma_unbind(struct i915_vma *vma);
 int __must_check i915_vma_unbind(struct i915_vma *vma);
diff --git a/drivers/gpu/drm/i915/i915_vma_resource.c b/drivers/gpu/drm/i915/i915_vma_resource.c
index 27c55027387a..5a67995ea5fe 100644
--- a/drivers/gpu/drm/i915/i915_vma_resource.c
+++ b/drivers/gpu/drm/i915/i915_vma_resource.c
@@ -223,10 +223,13 @@ i915_vma_resource_fence_notify(struct i915_sw_fence *fence,
  * Return: A refcounted pointer to a dma-fence that signals when unbinding is
  * complete.
  */
-struct dma_fence *i915_vma_resource_unbind(struct i915_vma_resource *vma_res)
+struct dma_fence *i915_vma_resource_unbind(struct i915_vma_resource *vma_res,
+					   u32 *tlb)
 {
 	struct i915_address_space *vm = vma_res->vm;
 
+	vma_res->tlb = tlb;
+
 	/* Reference for the sw fence */
 	i915_vma_resource_get(vma_res);
 
diff --git a/drivers/gpu/drm/i915/i915_vma_resource.h b/drivers/gpu/drm/i915/i915_vma_resource.h
index 5d8427caa2ba..06923d1816e7 100644
--- a/drivers/gpu/drm/i915/i915_vma_resource.h
+++ b/drivers/gpu/drm/i915/i915_vma_resource.h
@@ -67,6 +67,7 @@ struct i915_page_sizes {
  * taken when the unbind is scheduled.
  * @skip_pte_rewrite: During ggtt suspend and vm takedown pte rewriting
  * needs to be skipped for unbind.
+ * @tlb: pointer for obj->mm.tlb, if async unbind. Otherwise, NULL
  *
  * The lifetime of a struct i915_vma_resource is from a binding request to
  * the actual possible asynchronous unbind has completed.
@@ -119,6 +120,8 @@ struct i915_vma_resource {
 	bool immediate_unbind:1;
 	bool needs_wakeref:1;
 	bool skip_pte_rewrite:1;
+
+	u32 *tlb;
 };
 
 bool i915_vma_resource_hold(struct i915_vma_resource *vma_res,
@@ -131,7 +134,8 @@ struct i915_vma_resource *i915_vma_resource_alloc(void);
 
 void i915_vma_resource_free(struct i915_vma_resource *vma_res);
 
-struct dma_fence *i915_vma_resource_unbind(struct i915_vma_resource *vma_res);
+struct dma_fence *i915_vma_resource_unbind(struct i915_vma_resource *vma_res,
+					   u32 *tlb);
 
 void __i915_vma_resource_init(struct i915_vma_resource *vma_res);
 
-- 
2.36.1

