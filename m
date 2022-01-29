Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB924A2DE6
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 11:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiA2K7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 05:59:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35960 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiA2K7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 05:59:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF94160B0F;
        Sat, 29 Jan 2022 10:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456C9C340E5;
        Sat, 29 Jan 2022 10:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643453963;
        bh=KPXkSlTYVtnfzEPQpHj3Hf12N4OApx+0shn2dNvSD8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AF6N86M5SauqzGrIOFW/Q3ZxjQTR7jX6lKRfIcHzNUdEhPCqbhyxF6i/e7wWvTGC6
         s8la51od/gd1JUfH2rkYHrXQKYvIBfnIsaX8wG/uwPPRcCFW5i9FDRlDzuhWi8O2wE
         VIWiu2XQ5P17xeAtzYlfW+cEFkQs4w3S1iflBf+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.4.301
Date:   Sat, 29 Jan 2022 11:59:03 +0100
Message-Id: <164345394310570@kroah.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <164345394359198@kroah.com>
References: <164345394359198@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 29bb2f87dd2a..3bf23154499e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 4
-SUBLEVEL = 300
+SUBLEVEL = 301
 EXTRAVERSION =
 NAME = Blurry Fish Butt
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index adbbcaf14af6..8d7d102af52f 100644
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
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index f56af0aaafde..ffce88930371 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2212,6 +2212,85 @@ i915_gem_object_put_pages_gtt(struct drm_i915_gem_object *obj)
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
@@ -2230,6 +2309,14 @@ i915_gem_object_put_pages(struct drm_i915_gem_object *obj)
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
diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 65a53ee398b8..b2bb0b268ea9 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -3538,6 +3538,9 @@ int i915_vma_bind(struct i915_vma *vma, enum i915_cache_level cache_level,
 
 	vma->bound |= bind_flags;
 
+	if (vma->obj)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 603d8cdfc5f1..33a9b80da5dc 100644
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
