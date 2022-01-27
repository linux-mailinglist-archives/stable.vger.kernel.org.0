Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C64849E9BF
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244864AbiA0SJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:09:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58670 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234646AbiA0SJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3FFAB820C4;
        Thu, 27 Jan 2022 18:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8457C340E4;
        Thu, 27 Jan 2022 18:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306954;
        bh=3l5jVY4LoNQVrXUWco9W8SiC2E6sUDrQ4Xhb9Ba0SC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a11it+U2sE4LuLNOEET/gOpupi5CRo3aIj73GP1X7PUgHdl2hVn0InL/wZCww+HFj
         9gteZ+L7yFw+f0sflQbXjlkbQuYUlTxlqIdxHxkUfNT/My4Sg+4ZR4qjdRhAMgXTBU
         zpxmhnPJ8QGPzqm/AjVTRj/ZvaDlkPr5Rml5E8aU=
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
Subject: [PATCH 4.14 1/2] drm/i915: Flush TLBs before releasing backing store
Date:   Thu, 27 Jan 2022 19:08:56 +0100
Message-Id: <20220127180256.811271517@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180256.764665162@linuxfoundation.org>
References: <20220127180256.764665162@linuxfoundation.org>
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
 drivers/gpu/drm/i915/i915_drv.h        |    2 
 drivers/gpu/drm/i915/i915_gem.c        |   84 ++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/i915/i915_gem_object.h |    1 
 drivers/gpu/drm/i915/i915_reg.h        |    6 ++
 drivers/gpu/drm/i915/i915_vma.c        |    4 +
 5 files changed, 96 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -2166,6 +2166,8 @@ struct drm_i915_private {
 
 	struct intel_uncore uncore;
 
+	struct mutex tlb_invalidate_lock;
+
 	struct i915_virtual_gpu vgpu;
 
 	struct intel_gvt *gvt;
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2220,6 +2220,76 @@ static void __i915_gem_object_reset_page
 	rcu_read_unlock();
 }
 
+struct reg_and_bit {
+	i915_reg_t reg;
+	u32 bit;
+};
+
+static struct reg_and_bit
+get_reg_and_bit(const struct intel_engine_cs *engine,
+		const i915_reg_t *regs, const unsigned int num)
+{
+	const unsigned int class = engine->class;
+	struct reg_and_bit rb = { .bit = 1 };
+
+	if (WARN_ON_ONCE(class >= num || !regs[class].reg))
+		return rb;
+
+	rb.reg = regs[class];
+	if (class == VIDEO_DECODE_CLASS)
+		rb.reg.reg += 4 * engine->instance; /* GEN8_M2TCR */
+
+	return rb;
+}
+
+static void invalidate_tlbs(struct drm_i915_private *dev_priv)
+{
+	static const i915_reg_t gen8_regs[] = {
+		[RENDER_CLASS]                  = GEN8_RTCR,
+		[VIDEO_DECODE_CLASS]            = GEN8_M1TCR, /* , GEN8_M2TCR */
+		[VIDEO_ENHANCEMENT_CLASS]       = GEN8_VTCR,
+		[COPY_ENGINE_CLASS]             = GEN8_BTCR,
+	};
+	const unsigned int num = ARRAY_SIZE(gen8_regs);
+	const i915_reg_t *regs = gen8_regs;
+	struct intel_engine_cs *engine;
+	enum intel_engine_id id;
+
+	if (INTEL_GEN(dev_priv) < 8)
+		return;
+
+	assert_rpm_wakelock_held(dev_priv);
+
+	mutex_lock(&dev_priv->tlb_invalidate_lock);
+	intel_uncore_forcewake_get(dev_priv, FORCEWAKE_ALL);
+
+	for_each_engine(engine, dev_priv, id) {
+		/*
+		 * HW architecture suggest typical invalidation time at 40us,
+		 * with pessimistic cases up to 100us and a recommendation to
+		 * cap at 1ms. We go a bit higher just in case.
+		 */
+		const unsigned int timeout_us = 100;
+		const unsigned int timeout_ms = 4;
+		struct reg_and_bit rb;
+
+		rb = get_reg_and_bit(engine, regs, num);
+		if (!i915_mmio_reg_offset(rb.reg))
+			continue;
+
+		I915_WRITE_FW(rb.reg, rb.bit);
+		if (__intel_wait_for_register_fw(dev_priv,
+						 rb.reg, rb.bit, 0,
+						 timeout_us, timeout_ms,
+						 NULL))
+			DRM_ERROR_RATELIMITED("%s TLB invalidation did not complete in %ums!\n",
+					      engine->name, timeout_ms);
+	}
+
+	intel_uncore_forcewake_put(dev_priv, FORCEWAKE_ALL);
+	mutex_unlock(&dev_priv->tlb_invalidate_lock);
+}
+
 void __i915_gem_object_put_pages(struct drm_i915_gem_object *obj,
 				 enum i915_mm_subclass subclass)
 {
@@ -2257,8 +2327,18 @@ void __i915_gem_object_put_pages(struct
 
 	__i915_gem_object_reset_page_iter(obj);
 
-	if (!IS_ERR(pages))
+	if (!IS_ERR(pages)) {
+		if (test_and_clear_bit(I915_BO_WAS_BOUND_BIT, &obj->flags)) {
+			struct drm_i915_private *i915 = to_i915(obj->base.dev);
+
+			if (intel_runtime_pm_get_if_in_use(i915)) {
+				invalidate_tlbs(i915);
+				intel_runtime_pm_put(i915);
+			}
+		}
+
 		obj->ops->put_pages(obj, pages);
+	}
 
 unlock:
 	mutex_unlock(&obj->mm.lock);
@@ -4972,6 +5052,8 @@ i915_gem_load_init(struct drm_i915_priva
 
 	spin_lock_init(&dev_priv->fb_tracking.lock);
 
+	mutex_init(&dev_priv->tlb_invalidate_lock);
+
 	return 0;
 
 err_priorities:
--- a/drivers/gpu/drm/i915/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/i915_gem_object.h
@@ -135,6 +135,7 @@ struct drm_i915_gem_object {
 	 * activity?
 	 */
 #define I915_BO_ACTIVE_REF 0
+#define I915_BO_WAS_BOUND_BIT    1
 
 	/*
 	 * Is the object to be mapped as read-only to the GPU
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2380,6 +2380,12 @@ enum i915_power_well_id {
 #define GAMT_CHKN_BIT_REG	_MMIO(0x4ab8)
 #define   GAMT_CHKN_DISABLE_DYNAMIC_CREDIT_SHARING	(1<<28)
 
+#define GEN8_RTCR	_MMIO(0x4260)
+#define GEN8_M1TCR	_MMIO(0x4264)
+#define GEN8_M2TCR	_MMIO(0x4268)
+#define GEN8_BTCR	_MMIO(0x426c)
+#define GEN8_VTCR	_MMIO(0x4270)
+
 #if 0
 #define PRB0_TAIL	_MMIO(0x2030)
 #define PRB0_HEAD	_MMIO(0x2034)
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -272,6 +272,10 @@ int i915_vma_bind(struct i915_vma *vma,
 		return ret;
 
 	vma->flags |= bind_flags;
+
+	if (vma->obj)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+
 	return 0;
 }
 


