Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1607449E9AB
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbiA0SIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:08:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46094 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239322AbiA0SIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:08:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A22661CEC;
        Thu, 27 Jan 2022 18:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15053C340E4;
        Thu, 27 Jan 2022 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306915;
        bh=M1i5XkgRI+ZxWZ4dBGJxnUM8yP3/Z0e9D4FGmHRJDlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLHbo5M9v26X+k6fVm9l/rED18vRtA63EstlwPQCRW9F6TVxcQv4Wbqtl1nGk0ocL
         JvOTwBv7kwWlZ6wtxIsu9aYtt7gQKhOt026S+7SdH+t4OMFjshyqMu2rtA7TLeVpqZ
         QR7nnZDdQp8MFVccZyct632l/B+IEQ9pZkUEsjHM=
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
Subject: [PATCH 4.9 1/9] drm/i915: Flush TLBs before releasing backing store
Date:   Thu, 27 Jan 2022 19:08:19 +0100
Message-Id: <20220127180257.271800251@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180257.225641300@linuxfoundation.org>
References: <20220127180257.225641300@linuxfoundation.org>
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
 drivers/gpu/drm/i915/i915_gem.c     |   72 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_gtt.c |    4 ++
 drivers/gpu/drm/i915/i915_reg.h     |    6 +++
 4 files changed, 86 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1763,6 +1763,8 @@ struct drm_i915_private {
 
 	struct intel_uncore uncore;
 
+	struct mutex tlb_invalidate_lock;
+
 	struct i915_virtual_gpu vgpu;
 
 	struct intel_gvt gvt;
@@ -2211,7 +2213,8 @@ struct drm_i915_gem_object {
 	 * rendering and so a non-zero seqno), and is not set if it i s on
 	 * inactive (ready to be unbound) list.
 	 */
-#define I915_BO_ACTIVE_SHIFT 0
+#define I915_BO_WAS_BOUND_BIT    0
+#define I915_BO_ACTIVE_SHIFT 1
 #define I915_BO_ACTIVE_MASK ((1 << I915_NUM_ENGINES) - 1)
 #define __I915_BO_ACTIVE(bo) \
 	((READ_ONCE((bo)->flags) >> I915_BO_ACTIVE_SHIFT) & I915_BO_ACTIVE_MASK)
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2185,6 +2185,67 @@ i915_gem_object_put_pages_gtt(struct drm
 	kfree(obj->pages);
 }
 
+static int
+__intel_wait_for_register_fw(struct drm_i915_private *dev_priv,
+			     i915_reg_t reg,
+			     const u32 mask,
+			     const u32 value,
+			     const unsigned int timeout_us,
+			     const unsigned int timeout_ms)
+{
+#define done ((I915_READ_FW(reg) & mask) == value)
+	int ret = wait_for_us(done, timeout_us);
+	if (ret)
+		ret = wait_for(done, timeout_ms);
+	return ret;
+#undef done
+}
+
+static void invalidate_tlbs(struct drm_i915_private *dev_priv)
+{
+	static const i915_reg_t gen8_regs[] = {
+		[RCS]  = GEN8_RTCR,
+		[VCS]  = GEN8_M1TCR,
+		[VCS2] = GEN8_M2TCR,
+		[VECS] = GEN8_VTCR,
+		[BCS]  = GEN8_BTCR,
+	};
+	struct intel_engine_cs *engine;
+
+	if (INTEL_GEN(dev_priv) < 8)
+		return;
+
+	assert_rpm_wakelock_held(dev_priv);
+
+	mutex_lock(&dev_priv->tlb_invalidate_lock);
+	intel_uncore_forcewake_get(dev_priv, FORCEWAKE_ALL);
+
+	for_each_engine(engine, dev_priv) {
+		/*
+		 * HW architecture suggest typical invalidation time at 40us,
+		 * with pessimistic cases up to 100us and a recommendation to
+		 * cap at 1ms. We go a bit higher just in case.
+		 */
+		const unsigned int timeout_us = 100;
+		const unsigned int timeout_ms = 4;
+		const enum intel_engine_id id = engine->id;
+
+		if (WARN_ON_ONCE(id >= ARRAY_SIZE(gen8_regs) ||
+				 !i915_mmio_reg_offset(gen8_regs[id])))
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
@@ -2215,6 +2276,15 @@ i915_gem_object_put_pages(struct drm_i91
 		obj->mapping = NULL;
 	}
 
+	if (test_and_clear_bit(I915_BO_WAS_BOUND_BIT, &obj->flags)) {
+		struct drm_i915_private *i915 = to_i915(obj->base.dev);
+
+		if (intel_runtime_pm_get_if_in_use(i915)) {
+			invalidate_tlbs(i915);
+			intel_runtime_pm_put(i915);
+		}
+	}
+
 	ops->put_pages(obj);
 	obj->pages = NULL;
 
@@ -4627,6 +4697,8 @@ i915_gem_load_init(struct drm_device *de
 
 	atomic_set(&dev_priv->mm.bsd_engine_dispatch_index, 0);
 
+	mutex_init(&dev_priv->tlb_invalidate_lock);
+
 	spin_lock_init(&dev_priv->fb_tracking.lock);
 }
 
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -3685,6 +3685,10 @@ int i915_vma_bind(struct i915_vma *vma,
 		return ret;
 
 	vma->flags |= bind_flags;
+
+	if (vma->obj)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1698,6 +1698,12 @@ enum skl_disp_power_wells {
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


