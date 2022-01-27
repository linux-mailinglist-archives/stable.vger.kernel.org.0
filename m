Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85D249E9DB
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245103AbiA0SKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245102AbiA0SKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66C5C06175F;
        Thu, 27 Jan 2022 10:09:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7848C61998;
        Thu, 27 Jan 2022 18:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF2EC340E4;
        Thu, 27 Jan 2022 18:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306976;
        bh=a2HwaX7gwQcBa/uKoUIkgkD1oBfKnidjfViQpYAN6u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xX0AAibZXT2bymSXmCYGhTHipadhf7k1PXS94Y0ehIhNZclio9vF4q11korbl5T3U
         dDCJkor3ZLwbbUrYA5gUr1nl8a8Q5zZ9IVynIv/r8XGlPEctzZTJ3nPaG0xPL1vwaB
         GD2CdGYC70KxqSKebApZ0ybdQYBKiMbrpOg1zQDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 01/11] drm/i915: Flush TLBs before releasing backing store
Date:   Thu, 27 Jan 2022 19:09:02 +0100
Message-Id: <20220127180258.408413788@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.362000607@linuxfoundation.org>
References: <20220127180258.362000607@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit 7938d61591d33394a21bdd7797a245b65428f44c upstream.

We need to flush TLBs before releasing backing store otherwise userspace
is able to encounter stale entries if a) it is not declaring access to
certain buffers and b) it races with the backing store release from a
such undeclared execution already executing on the GPU in parallel.

The approach taken is to mark any buffer objects which were ever bound
to the GPU and to trigger a serialized TLB flush when their backing
store is released.

Alternatively the flushing could be done on VMA unbind, at which point
we would be able to ascertain whether there is potential a parallel GPU
execution (which could race), but essentially it boils down to paying
the cost of TLB flushes potentially needlessly at VMA unbind time (when
the backing store is not known to be going away so not needed for
safety), versus potentially needlessly at backing store relase time
(since we at that point cannot tell whether there is anything executing
on the GPU which uses that object).

Thereforce simplicity of implementation has been chosen for now with
scope to benchmark and refine later as required.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reported-by: Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Dave Airlie <airlied@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h |    3 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c        |   10 ++
 drivers/gpu/drm/i915/gt/intel_gt.c               |   99 +++++++++++++++++++++++
 drivers/gpu/drm/i915/gt/intel_gt.h               |    2 
 drivers/gpu/drm/i915/gt/intel_gt_types.h         |    2 
 drivers/gpu/drm/i915/i915_reg.h                  |   11 ++
 drivers/gpu/drm/i915/i915_vma.c                  |    4 
 7 files changed, 131 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -118,6 +118,9 @@ struct drm_i915_gem_object {
 
 	I915_SELFTEST_DECLARE(struct list_head st_link);
 
+	unsigned long flags;
+#define I915_BO_WAS_BOUND_BIT    0
+
 	/*
 	 * Is the object to be mapped as read-only to the GPU
 	 * Only honoured if hardware has relevant pte bit
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -8,6 +8,8 @@
 #include "i915_gem_object.h"
 #include "i915_scatterlist.h"
 
+#include "gt/intel_gt.h"
+
 void __i915_gem_object_set_pages(struct drm_i915_gem_object *obj,
 				 struct sg_table *pages,
 				 unsigned int sg_page_sizes)
@@ -176,6 +178,14 @@ __i915_gem_object_unset_pages(struct drm
 	__i915_gem_object_reset_page_iter(obj);
 	obj->mm.page_sizes.phys = obj->mm.page_sizes.sg = 0;
 
+	if (test_and_clear_bit(I915_BO_WAS_BOUND_BIT, &obj->flags)) {
+		struct drm_i915_private *i915 = to_i915(obj->base.dev);
+		intel_wakeref_t wakeref;
+
+		with_intel_runtime_pm_if_in_use(&i915->runtime_pm, wakeref)
+			intel_gt_invalidate_tlbs(&i915->gt);
+	}
+
 	return pages;
 }
 
--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -15,6 +15,8 @@ void intel_gt_init_early(struct intel_gt
 
 	spin_lock_init(&gt->irq_lock);
 
+	mutex_init(&gt->tlb_invalidate_lock);
+
 	INIT_LIST_HEAD(&gt->closed_vma);
 	spin_lock_init(&gt->closed_lock);
 
@@ -266,3 +268,100 @@ void intel_gt_driver_late_release(struct
 	intel_uc_driver_late_release(&gt->uc);
 	intel_gt_fini_reset(gt);
 }
+
+struct reg_and_bit {
+	i915_reg_t reg;
+	u32 bit;
+};
+
+static struct reg_and_bit
+get_reg_and_bit(const struct intel_engine_cs *engine, const bool gen8,
+		const i915_reg_t *regs, const unsigned int num)
+{
+	const unsigned int class = engine->class;
+	struct reg_and_bit rb = { };
+
+	if (WARN_ON_ONCE(class >= num || !regs[class].reg))
+		return rb;
+
+	rb.reg = regs[class];
+	if (gen8 && class == VIDEO_DECODE_CLASS)
+		rb.reg.reg += 4 * engine->instance; /* GEN8_M2TCR */
+	else
+		rb.bit = engine->instance;
+
+	rb.bit = BIT(rb.bit);
+
+	return rb;
+}
+
+void intel_gt_invalidate_tlbs(struct intel_gt *gt)
+{
+	static const i915_reg_t gen8_regs[] = {
+		[RENDER_CLASS]			= GEN8_RTCR,
+		[VIDEO_DECODE_CLASS]		= GEN8_M1TCR, /* , GEN8_M2TCR */
+		[VIDEO_ENHANCEMENT_CLASS]	= GEN8_VTCR,
+		[COPY_ENGINE_CLASS]		= GEN8_BTCR,
+	};
+	static const i915_reg_t gen12_regs[] = {
+		[RENDER_CLASS]			= GEN12_GFX_TLB_INV_CR,
+		[VIDEO_DECODE_CLASS]		= GEN12_VD_TLB_INV_CR,
+		[VIDEO_ENHANCEMENT_CLASS]	= GEN12_VE_TLB_INV_CR,
+		[COPY_ENGINE_CLASS]		= GEN12_BLT_TLB_INV_CR,
+	};
+	struct drm_i915_private *i915 = gt->i915;
+	struct intel_uncore *uncore = gt->uncore;
+	struct intel_engine_cs *engine;
+	enum intel_engine_id id;
+	const i915_reg_t *regs;
+	unsigned int num = 0;
+
+	if (I915_SELFTEST_ONLY(gt->awake == -ENODEV))
+		return;
+
+	if (INTEL_GEN(i915) == 12) {
+		regs = gen12_regs;
+		num = ARRAY_SIZE(gen12_regs);
+	} else if (INTEL_GEN(i915) >= 8 && INTEL_GEN(i915) <= 11) {
+		regs = gen8_regs;
+		num = ARRAY_SIZE(gen8_regs);
+	} else if (INTEL_GEN(i915) < 8) {
+		return;
+	}
+
+	if (WARN_ONCE(!num, "Platform does not implement TLB invalidation!"))
+		return;
+
+	GEM_TRACE("\n");
+
+	assert_rpm_wakelock_held(&i915->runtime_pm);
+
+	mutex_lock(&gt->tlb_invalidate_lock);
+	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
+
+	for_each_engine(engine, gt, id) {
+		/*
+		 * HW architecture suggest typical invalidation time at 40us,
+		 * with pessimistic cases up to 100us and a recommendation to
+		 * cap at 1ms. We go a bit higher just in case.
+		 */
+		const unsigned int timeout_us = 100;
+		const unsigned int timeout_ms = 4;
+		struct reg_and_bit rb;
+
+		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
+		if (!i915_mmio_reg_offset(rb.reg))
+			continue;
+
+		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
+		if (__intel_wait_for_register_fw(uncore,
+						 rb.reg, rb.bit, 0,
+						 timeout_us, timeout_ms,
+						 NULL))
+			DRM_ERROR_RATELIMITED("%s TLB invalidation did not complete in %ums!\n",
+					      engine->name, timeout_ms);
+	}
+
+	intel_uncore_forcewake_put(uncore, FORCEWAKE_ALL);
+	mutex_unlock(&gt->tlb_invalidate_lock);
+}
--- a/drivers/gpu/drm/i915/gt/intel_gt.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt.h
@@ -57,4 +57,6 @@ static inline bool intel_gt_is_wedged(st
 
 void intel_gt_queue_hangcheck(struct intel_gt *gt);
 
+void intel_gt_invalidate_tlbs(struct intel_gt *gt);
+
 #endif /* __INTEL_GT_H__ */
--- a/drivers/gpu/drm/i915/gt/intel_gt_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_types.h
@@ -40,6 +40,8 @@ struct intel_gt {
 
 	struct intel_uc uc;
 
+	struct mutex tlb_invalidate_lock;
+
 	struct intel_gt_timelines {
 		spinlock_t lock; /* protects active_list */
 		struct list_head active_list;
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2519,6 +2519,12 @@ static inline bool i915_mmio_reg_valid(i
 #define   GAMT_CHKN_DISABLE_DYNAMIC_CREDIT_SHARING	(1 << 28)
 #define   GAMT_CHKN_DISABLE_I2M_CYCLE_ON_WR_PORT	(1 << 24)
 
+#define GEN8_RTCR	_MMIO(0x4260)
+#define GEN8_M1TCR	_MMIO(0x4264)
+#define GEN8_M2TCR	_MMIO(0x4268)
+#define GEN8_BTCR	_MMIO(0x426c)
+#define GEN8_VTCR	_MMIO(0x4270)
+
 #if 0
 #define PRB0_TAIL	_MMIO(0x2030)
 #define PRB0_HEAD	_MMIO(0x2034)
@@ -2602,6 +2608,11 @@ static inline bool i915_mmio_reg_valid(i
 #define   FAULT_VA_HIGH_BITS		(0xf << 0)
 #define   FAULT_GTT_SEL			(1 << 4)
 
+#define GEN12_GFX_TLB_INV_CR	_MMIO(0xced8)
+#define GEN12_VD_TLB_INV_CR	_MMIO(0xcedc)
+#define GEN12_VE_TLB_INV_CR	_MMIO(0xcee0)
+#define GEN12_BLT_TLB_INV_CR	_MMIO(0xcee4)
+
 #define FPGA_DBG		_MMIO(0x42300)
 #define   FPGA_DBG_RM_NOCLAIM	(1 << 31)
 
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -341,6 +341,10 @@ int i915_vma_bind(struct i915_vma *vma,
 		return ret;
 
 	vma->flags |= bind_flags;
+
+	if (vma->obj)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+
 	return 0;
 }
 


