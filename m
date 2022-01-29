Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B0E4A2DF0
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 11:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbiA2K7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 05:59:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52822 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbiA2K7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 05:59:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2152B8235B;
        Sat, 29 Jan 2022 10:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10258C340E5;
        Sat, 29 Jan 2022 10:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643453986;
        bh=rdBVwmalGs9PCn2hgZmVPkCLXkjXCVoYIZhnHcYTuuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQSAQWIsVnIFAx5M4nm0v+kGFJW4gfKSm31D27U1x8TDEFr2LijsUk6Imz4GB+VAl
         fi8cGLjnL0mAIqcIeVOx7BGCyDsbPtJLSsUdLwyMcRetHcjp+5VPFkypN6jg2a2sW6
         oaYIKlvVy4VOyfhf4UbygJHYrMcPq4n+GU21QlCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.227
Date:   Sat, 29 Jan 2022 11:59:35 +0100
Message-Id: <1643453975114131@kroah.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <164345397562207@kroah.com>
References: <164345397562207@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 72399555ce88..1e9652cb9c1f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 226
+SUBLEVEL = 227
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 37c80cfecd09..c25ee6a02d65 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1595,6 +1595,8 @@ struct drm_i915_private {
 
 	struct intel_uncore uncore;
 
+	struct mutex tlb_invalidate_lock;
+
 	struct i915_virtual_gpu vgpu;
 
 	struct intel_gvt *gvt;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index c7d05ac7af3c..5b0d6d8b3ab8 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2446,6 +2446,78 @@ static void __i915_gem_object_reset_page_iter(struct drm_i915_gem_object *obj)
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
+	GEM_TRACE("\n");
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
 static struct sg_table *
 __i915_gem_object_unset_pages(struct drm_i915_gem_object *obj)
 {
@@ -2475,6 +2547,15 @@ __i915_gem_object_unset_pages(struct drm_i915_gem_object *obj)
 	__i915_gem_object_reset_page_iter(obj);
 	obj->mm.page_sizes.phys = obj->mm.page_sizes.sg = 0;
 
+	if (test_and_clear_bit(I915_BO_WAS_BOUND_BIT, &obj->flags)) {
+		struct drm_i915_private *i915 = to_i915(obj->base.dev);
+
+		if (intel_runtime_pm_get_if_in_use(i915)) {
+			invalidate_tlbs(i915);
+			intel_runtime_pm_put(i915);
+		}
+	}
+
 	return pages;
 }
 
@@ -5792,6 +5873,8 @@ int i915_gem_init_early(struct drm_i915_private *dev_priv)
 
 	spin_lock_init(&dev_priv->fb_tracking.lock);
 
+	mutex_init(&dev_priv->tlb_invalidate_lock);
+
 	err = i915_gemfs_init(dev_priv);
 	if (err)
 		DRM_NOTE("Unable to create a private tmpfs mount, hugepage support will be disabled(%d).\n", err);
diff --git a/drivers/gpu/drm/i915/i915_gem_object.h b/drivers/gpu/drm/i915/i915_gem_object.h
index 83e5e01fa9ea..2e3a713e9bcd 100644
--- a/drivers/gpu/drm/i915/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/i915_gem_object.h
@@ -136,6 +136,7 @@ struct drm_i915_gem_object {
 	 * activity?
 	 */
 #define I915_BO_ACTIVE_REF 0
+#define I915_BO_WAS_BOUND_BIT    1
 
 	/*
 	 * Is the object to be mapped as read-only to the GPU
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index a6f4f32dd71c..830049985e56 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2431,6 +2431,12 @@ enum i915_power_well_id {
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
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index 98358b4b36de..9aceacc43f4b 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -335,6 +335,10 @@ int i915_vma_bind(struct i915_vma *vma, enum i915_cache_level cache_level,
 		return ret;
 
 	vma->flags |= bind_flags;
+
+	if (vma->obj)
+		set_bit(I915_BO_WAS_BOUND_BIT, &vma->obj->flags);
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 1abe21758b0d..bca0b8980c0e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -855,15 +855,14 @@ extern int vmw_execbuf_fence_commands(struct drm_file *file_priv,
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
index 3834aa71c9c4..e65554f5a89d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3873,20 +3873,19 @@ int vmw_execbuf_fence_commands(struct drm_file *file_priv,
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
 
@@ -3914,20 +3913,14 @@ vmw_execbuf_copy_fence_user(struct vmw_private *dev_priv,
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
@@ -4287,16 +4280,23 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 
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
@@ -4315,7 +4315,7 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	 */
 	vmw_resource_list_unreference(sw_context, &resource_list);
 
-	return 0;
+	return ret;
 
 out_unlock_binding:
 	mutex_unlock(&dev_priv->binding_mutex);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 3d546d409334..72a75316d472 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1169,7 +1169,7 @@ int vmw_fence_event_ioctl(struct drm_device *dev, void *data,
 	}
 
 	vmw_execbuf_copy_fence_user(dev_priv, vmw_fp, 0, user_fence_rep, fence,
-				    handle, -1, NULL);
+				    handle, -1);
 	vmw_fence_obj_unreference(&fence);
 	return 0;
 out_no_create:
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index e486b6517ac5..d87bd2a8c75f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2662,7 +2662,7 @@ void vmw_kms_helper_buffer_finish(struct vmw_private *dev_priv,
 	if (file_priv)
 		vmw_execbuf_copy_fence_user(dev_priv, vmw_fpriv(file_priv),
 					    ret, user_fence_rep, fence,
-					    handle, -1, NULL);
+					    handle, -1);
 	if (out_fence)
 		*out_fence = fence;
 	else
diff --git a/fs/select.c b/fs/select.c
index 11a7051075b4..1c3985d0bcc3 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -431,9 +431,11 @@ static int max_select_fd(unsigned long n, fd_set_bits *fds)
 	return max;
 }
 
-#define POLLIN_SET (EPOLLRDNORM | EPOLLRDBAND | EPOLLIN | EPOLLHUP | EPOLLERR)
-#define POLLOUT_SET (EPOLLWRBAND | EPOLLWRNORM | EPOLLOUT | EPOLLERR)
-#define POLLEX_SET (EPOLLPRI)
+#define POLLIN_SET (EPOLLRDNORM | EPOLLRDBAND | EPOLLIN | EPOLLHUP | EPOLLERR |\
+			EPOLLNVAL)
+#define POLLOUT_SET (EPOLLWRBAND | EPOLLWRNORM | EPOLLOUT | EPOLLERR |\
+			 EPOLLNVAL)
+#define POLLEX_SET (EPOLLPRI | EPOLLNVAL)
 
 static inline void wait_key_set(poll_table *wait, unsigned long in,
 				unsigned long out, unsigned long bit,
@@ -500,6 +502,7 @@ static int do_select(int n, fd_set_bits *fds, struct timespec64 *end_time)
 					break;
 				if (!(bit & all_bits))
 					continue;
+				mask = EPOLLNVAL;
 				f = fdget(i);
 				if (f.file) {
 					wait_key_set(wait, in, out, bit,
@@ -507,34 +510,34 @@ static int do_select(int n, fd_set_bits *fds, struct timespec64 *end_time)
 					mask = vfs_poll(f.file, wait);
 
 					fdput(f);
-					if ((mask & POLLIN_SET) && (in & bit)) {
-						res_in |= bit;
-						retval++;
-						wait->_qproc = NULL;
-					}
-					if ((mask & POLLOUT_SET) && (out & bit)) {
-						res_out |= bit;
-						retval++;
-						wait->_qproc = NULL;
-					}
-					if ((mask & POLLEX_SET) && (ex & bit)) {
-						res_ex |= bit;
-						retval++;
-						wait->_qproc = NULL;
-					}
-					/* got something, stop busy polling */
-					if (retval) {
-						can_busy_loop = false;
-						busy_flag = 0;
-
-					/*
-					 * only remember a returned
-					 * POLL_BUSY_LOOP if we asked for it
-					 */
-					} else if (busy_flag & mask)
-						can_busy_loop = true;
-
 				}
+				if ((mask & POLLIN_SET) && (in & bit)) {
+					res_in |= bit;
+					retval++;
+					wait->_qproc = NULL;
+				}
+				if ((mask & POLLOUT_SET) && (out & bit)) {
+					res_out |= bit;
+					retval++;
+					wait->_qproc = NULL;
+				}
+				if ((mask & POLLEX_SET) && (ex & bit)) {
+					res_ex |= bit;
+					retval++;
+					wait->_qproc = NULL;
+				}
+				/* got something, stop busy polling */
+				if (retval) {
+					can_busy_loop = false;
+					busy_flag = 0;
+
+				/*
+				 * only remember a returned
+				 * POLL_BUSY_LOOP if we asked for it
+				 */
+				} else if (busy_flag & mask)
+					can_busy_loop = true;
+
 			}
 			if (res_in)
 				*rinp = res_in;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index a350c05b7ff5..7c6b1024dd4b 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -42,6 +42,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ethhdr *eth;
 	u16 vid = 0;
 
+	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
+
 	rcu_read_lock();
 	nf_ops = rcu_dereference(nf_br_ops);
 	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {
