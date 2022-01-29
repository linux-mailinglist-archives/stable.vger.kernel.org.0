Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD794A2DEE
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 11:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiA2K7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 05:59:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36106 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbiA2K7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 05:59:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E670860B27;
        Sat, 29 Jan 2022 10:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A739AC340E5;
        Sat, 29 Jan 2022 10:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643453983;
        bh=E1fbyFHrZPmPEjzKZszGLqXvNwPzsORweGc41ybj3sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9VYOI6GkNtEV4Z9IYQwcLUNSMAxhYpjYMlRSr5G7cD+0spoFnZ5jPO2NGMLQ33ad
         bmHpjFxPfc4gDcUURWX9TL4K1cRMLD++MtzyhUobS5an+dczgPWBiCpi+VzFGETBzt
         Gj1eOionAGMlkLl0utvlBvDAW6sSSzHx/xAJ5NAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.264
Date:   Sat, 29 Jan 2022 11:59:30 +0100
Message-Id: <1643453970171206@kroah.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <1643453970118134@kroah.com>
References: <1643453970118134@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 0d754c4d8925..c5508214fa1f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 263
+SUBLEVEL = 264
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 816781f209d6..f8d13ee2d538 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -2166,6 +2166,8 @@ struct drm_i915_private {
 
 	struct intel_uncore uncore;
 
+	struct mutex tlb_invalidate_lock;
+
 	struct i915_virtual_gpu vgpu;
 
 	struct intel_gvt *gvt;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 9263b65720bc..08d31744e2d9 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2220,6 +2220,76 @@ static void __i915_gem_object_reset_page_iter(struct drm_i915_gem_object *obj)
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
@@ -2257,8 +2327,18 @@ void __i915_gem_object_put_pages(struct drm_i915_gem_object *obj,
 
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
@@ -4972,6 +5052,8 @@ i915_gem_load_init(struct drm_i915_private *dev_priv)
 
 	spin_lock_init(&dev_priv->fb_tracking.lock);
 
+	mutex_init(&dev_priv->tlb_invalidate_lock);
+
 	return 0;
 
 err_priorities:
diff --git a/drivers/gpu/drm/i915/i915_gem_object.h b/drivers/gpu/drm/i915/i915_gem_object.h
index 39cfe04dcdb8..180a8bf24791 100644
--- a/drivers/gpu/drm/i915/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/i915_gem_object.h
@@ -135,6 +135,7 @@ struct drm_i915_gem_object {
 	 * activity?
 	 */
 #define I915_BO_ACTIVE_REF 0
+#define I915_BO_WAS_BOUND_BIT    1
 
 	/*
 	 * Is the object to be mapped as read-only to the GPU
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 1db70350af0b..333e94381789 100644
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
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 76eed1fdac09..5653e7bac914 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -272,6 +272,10 @@ int i915_vma_bind(struct i915_vma *vma, enum i915_cache_level cache_level,
 		return ret;
 
 	vma->flags |= bind_flags;
+
+	if (vma->obj)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 8c65cc3b0dda..8f5321f09856 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -837,15 +837,14 @@ extern int vmw_execbuf_fence_commands(struct drm_file *file_priv,
 				      struct vmw_private *dev_priv,
 				      struct vmw_fence_obj **p_fence,
 				      uint32_t *p_handle);
-extern void vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
+extern int vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 					struct vmw_fpriv *vmw_fp,
 					int ret,
 					struct drm_vmw_fence_rep __user
 					*user_fence_rep,
 					struct vmw_fence_obj *fence,
 					uint32_t fence_handle,
-					int32_t out_fence_fd,
-					struct sync_file *sync_file);
+					int32_t out_fence_fd);
 extern int vmw_validate_single_buffer(struct vmw_private *dev_priv,
 				      struct ttm_buffer_object *bo,
 				      bool interruptible,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index dc677ba4dc38..996696ad6f98 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3848,20 +3848,19 @@ int vmw_execbuf_fence_commands(struct drm_file *file_priv,
  * object so we wait for it immediately, and then unreference the
  * user-space reference.
  */
-void
+int
 vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 			    struct vmw_fpriv *vmw_fp,
 			    int ret,
 			    struct drm_vmw_fence_rep __user *user_fence_rep,
 			    struct vmw_fence_obj *fence,
 			    uint32_t fence_handle,
-			    int32_t out_fence_fd,
-			    struct sync_file *sync_file)
+			    int32_t out_fence_fd)
 {
 	struct drm_vmw_fence_rep fence_rep;
 
 	if (user_fence_rep == NULL)
-		return;
+		return 0;
 
 	memset(&fence_rep, 0, sizeof(fence_rep));
 
@@ -3889,20 +3888,14 @@ vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
 	 * and unreference the handle.
 	 */
 	if (unlikely(ret != 0) && (fence_rep.error == 0)) {
-		if (sync_file)
-			fput(sync_file->file);
-
-		if (fence_rep.fd != -1) {
-			put_unused_fd(fence_rep.fd);
-			fence_rep.fd = -1;
-		}
-
 		ttm_ref_object_base_unref(vmw_fp->tfile,
 					  fence_handle, TTM_REF_USAGE);
 		DRM_ERROR("Fence copy error. Syncing.\n");
 		(void) vmw_fence_obj_wait(fence, false, false,
 					  VMW_FENCE_WAIT_TIMEOUT);
 	}
+
+	return ret ? -EFAULT : 0;
 }
 
 /**
@@ -4262,16 +4255,23 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 
 			(void) vmw_fence_obj_wait(fence, false, false,
 						  VMW_FENCE_WAIT_TIMEOUT);
+		}
+	}
+
+	ret = vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv), ret,
+				    user_fence_rep, fence, handle, out_fence_fd);
+
+	if (sync_file) {
+		if (ret) {
+			/* usercopy of fence failed, put the file object */
+			fput(sync_file->file);
+			put_unused_fd(out_fence_fd);
 		} else {
 			/* Link the fence with the FD created earlier */
 			fd_install(out_fence_fd, sync_file->file);
 		}
 	}
 
-	vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv), ret,
-				    user_fence_rep, fence, handle,
-				    out_fence_fd, sync_file);
-
 	/* Don't unreference when handing fence out */
 	if (unlikely(out_fence != NULL)) {
 		*out_fence = fence;
@@ -4290,7 +4290,7 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	 */
 	vmw_resource_list_unreference(sw_context, &resource_list);
 
-	return 0;
+	return ret;
 
 out_unlock_binding:
 	mutex_unlock(&dev_priv->binding_mutex);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index d6b1c509ae01..7d2482644ef7 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1150,7 +1150,7 @@ int vmw_fence_event_ioctl(struct drm_device *dev, void *data,
 	}
 
 	vmw_execbuf_copy_fence_user(dev_priv, vmw_fp, 0, user_fence_rep, fence,
-				    handle, -1, NULL);
+				    handle, -1);
 	vmw_fence_obj_unreference(&fence);
 	return 0;
 out_no_create:
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 848c9d009be2..fbba55edbfd0 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2511,7 +2511,7 @@ void vmw_kms_helper_buffer_finish(struct vmw_private *dev_priv,
 	if (file_priv)
 		vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv),
 					    ret, user_fence_rep, fence,
-					    handle, -1, NULL);
+					    handle, -1);
 	if (out_fence)
 		*out_fence = fence;
 	else
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 324c4cdc003e..b3f3b02ffd42 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -762,21 +762,21 @@ static struct bcm_op *bcm_find_op(struct list_head *ops,
 static void bcm_remove_op(struct bcm_op *op)
 {
 	if (op->tsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
-		       hrtimer_active(&op->timer)) {
-			hrtimer_cancel(&op->timer);
+		do {
 			tasklet_kill(&op->tsklet);
-		}
+			hrtimer_cancel(&op->timer);
+		} while (test_bit(TASKLET_STATE_SCHED, &op->tsklet.state) ||
+			 test_bit(TASKLET_STATE_RUN, &op->tsklet.state) ||
+			 hrtimer_active(&op->timer));
 	}
 
 	if (op->thrtsklet.func) {
-		while (test_bit(TASKLET_STATE_SCHED, &op->thrtsklet.state) ||
-		       test_bit(TASKLET_STATE_RUN, &op->thrtsklet.state) ||
-		       hrtimer_active(&op->thrtimer)) {
-			hrtimer_cancel(&op->thrtimer);
+		do {
 			tasklet_kill(&op->thrtsklet);
-		}
+			hrtimer_cancel(&op->thrtimer);
+		} while (test_bit(TASKLET_STATE_SCHED, &op->thrtsklet.state) ||
+			 test_bit(TASKLET_STATE_RUN, &op->thrtsklet.state) ||
+			 hrtimer_active(&op->thrtimer));
 	}
 
 	if ((op->frames) && (op->frames != &op->sframe))
