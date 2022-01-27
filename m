Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC449E9A8
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbiA0SI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239156AbiA0SI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:08:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B6AC061714;
        Thu, 27 Jan 2022 10:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E191B818E1;
        Thu, 27 Jan 2022 18:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BE9C340E4;
        Thu, 27 Jan 2022 18:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306906;
        bh=I+qDbx+ZdhX+V2eAiz0xOS7auZnOKPIc3FLckVjaU1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SF29z1P62OZtYZ28ynlWs8wRig9zDRQnjXrjj7Skl78CTgNBxgWQNPCQ/26+DnyQ3
         5TSUjiqVV605Rkkw/o7SqRUwjSu7I90P0KkdlPLTFUTvL4o+xVyK1VXptCiZcd7Y5h
         1nlDNrBDZLl9xnv8YxZgxw/eoJTUmbMW+MKJ3KcY=
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
Subject: [PATCH 4.4 1/1] drm/i915: Flush TLBs before releasing backing store
Date:   Thu, 27 Jan 2022 19:08:14 +0100
Message-Id: <20220127180256.388962601@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180256.347004543@linuxfoundation.org>
References: <20220127180256.347004543@linuxfoundation.org>
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
 drivers/gpu/drm/i915/i915_drv.h     |    5 ++
 drivers/gpu/drm/i915/i915_gem.c     |   89 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_gtt.c |    3 +
 drivers/gpu/drm/i915/i915_reg.h     |    6 ++
 4 files changed, 103 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1719,6 +1719,8 @@ struct drm_i915_private {
 
 	struct intel_uncore uncore;
 
+	struct mutex tlb_invalidate_lock;
+
 	struct i915_virtual_gpu vgpu;
 
 	struct intel_guc guc;
@@ -2066,6 +2068,9 @@ struct drm_i915_gem_object {
 	 */
 	unsigned int active:I915_NUM_RINGS;
 
+	unsigned long flags;
+#define I915_BO_WAS_BOUND_BIT    0
+
 	/**
 	 * This is set if the object has been written to since last bound
 	 * to the GTT
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2212,6 +2212,85 @@ i915_gem_object_put_pages_gtt(struct drm
 	kfree(obj->pages);
 }
 
+#define _wait_for_us(COND, US, W) ({ \
+	unsigned long timeout__ = jiffies + usecs_to_jiffies(US) + 1;   \
+	int ret__;                                                      \
+	for (;;) {                                                      \
+		bool expired__ = time_after(jiffies, timeout__);        \
+		if (COND) {                                             \
+			ret__ = 0;                                      \
+			break;                                          \
+		}                                                       \
+		if (expired__) {                                        \
+			ret__ = -ETIMEDOUT;                             \
+			break;                                          \
+		}                                                       \
+		usleep_range((W), (W)*2);                               \
+	}                                                               \
+	ret__;                                                          \
+})
+
+static int
+__intel_wait_for_register_fw(struct drm_i915_private *dev_priv,
+			     u32 reg,
+			     const u32 mask,
+			     const u32 value,
+			     const unsigned int timeout_us,
+			     const unsigned int timeout_ms)
+{
+#define done ((I915_READ_FW(reg) & mask) == value)
+	int ret = _wait_for_us(done, timeout_us, 2);
+	if (ret)
+		ret = wait_for(done, timeout_ms);
+	return ret;
+#undef done
+}
+
+static void invalidate_tlbs(struct drm_i915_private *dev_priv)
+{
+	static const u32 gen8_regs[] = {
+		[RCS]  = GEN8_RTCR,
+		[VCS]  = GEN8_M1TCR,
+		[VCS2] = GEN8_M2TCR,
+		[VECS] = GEN8_VTCR,
+		[BCS]  = GEN8_BTCR,
+	};
+	enum intel_ring_id id;
+
+	if (INTEL_INFO(dev_priv)->gen < 8)
+		return;
+
+	mutex_lock(&dev_priv->tlb_invalidate_lock);
+	intel_uncore_forcewake_get(dev_priv, FORCEWAKE_ALL);
+
+	for (id = 0; id < I915_NUM_RINGS; id++) {
+		struct intel_engine_cs *engine = &dev_priv->ring[id];
+		/*
+		 * HW architecture suggest typical invalidation time at 40us,
+		 * with pessimistic cases up to 100us and a recommendation to
+		 * cap at 1ms. We go a bit higher just in case.
+		 */
+		const unsigned int timeout_us = 100;
+		const unsigned int timeout_ms = 4;
+
+		if (!intel_ring_initialized(engine))
+			continue;
+
+		if (WARN_ON_ONCE(id >= ARRAY_SIZE(gen8_regs) || !gen8_regs[id]))
+			continue;
+
+		I915_WRITE_FW(gen8_regs[id], 1);
+		if (__intel_wait_for_register_fw(dev_priv,
+						 gen8_regs[id], 1, 0,
+						 timeout_us, timeout_ms))
+			DRM_ERROR_RATELIMITED("%s TLB invalidation did not complete in %ums!\n",
+					      engine->name, timeout_ms);
+	}
+
+	intel_uncore_forcewake_put(dev_priv, FORCEWAKE_ALL);
+	mutex_unlock(&dev_priv->tlb_invalidate_lock);
+}
+
 int
 i915_gem_object_put_pages(struct drm_i915_gem_object *obj)
 {
@@ -2230,6 +2309,14 @@ i915_gem_object_put_pages(struct drm_i91
 	 * lists early. */
 	list_del(&obj->global_list);
 
+	if (test_and_clear_bit(I915_BO_WAS_BOUND_BIT, &obj->flags)) {
+		struct drm_i915_private *i915 = to_i915(obj->base.dev);
+
+		intel_runtime_pm_get(i915);
+		invalidate_tlbs(i915);
+		intel_runtime_pm_put(i915);
+	}
+
 	ops->put_pages(obj);
 	obj->pages = NULL;
 
@@ -5050,6 +5137,8 @@ i915_gem_load(struct drm_device *dev)
 	i915_gem_shrinker_init(dev_priv);
 
 	mutex_init(&dev_priv->fb_tracking.lock);
+
+	mutex_init(&dev_priv->tlb_invalidate_lock);
 }
 
 void i915_gem_release(struct drm_device *dev, struct drm_file *file)
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -3538,6 +3538,9 @@ int i915_vma_bind(struct i915_vma *vma,
 
 	vma->bound |= bind_flags;
 
+	if (vma->obj)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1592,6 +1592,12 @@ enum skl_disp_power_wells {
 
 #define GEN7_TLB_RD_ADDR	0x4700
 
+#define GEN8_RTCR	0x4260
+#define GEN8_M1TCR	0x4264
+#define GEN8_M2TCR	0x4268
+#define GEN8_BTCR	0x426c
+#define GEN8_VTCR	0x4270
+
 #if 0
 #define PRB0_TAIL	0x02030
 #define PRB0_HEAD	0x02034


