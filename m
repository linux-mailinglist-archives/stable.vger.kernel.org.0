Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579CA52903C
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344819AbiEPUEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351053AbiEPUB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B43047574;
        Mon, 16 May 2022 12:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9C10B81611;
        Mon, 16 May 2022 19:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4691C385AA;
        Mon, 16 May 2022 19:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731049;
        bh=UjCNsi/Km5kGaHrRsNuwAvz0UG/d/uYUJNAm0zwg2mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9OK31JjY7MpYsvCwcYFrMgL3VJXee58xAOau6/VUu3EPFNTlD9v04Jwpir2jgfk+
         cO5ml/VSEcf6Q63RTAcYnIyq6oHo1eiTzFgkBRhtgMnVJDqonXOdWg3r8TYZIXFlAv
         p0tkPLSwTwGVpyNhYu3H6QB3Z1VAIXp1/8t4bK/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 047/114] drm/vmwgfx: Fix fencing on SVGAv3
Date:   Mon, 16 May 2022 21:36:21 +0200
Message-Id: <20220516193626.845283268@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

[ Upstream commit 1d6595b4cd47acfd824550f48f10b54a6f0e93ee ]

Port of the vmwgfx to SVGAv3 lacked support for fencing. SVGAv3 removed
FIFO's and replaced them with command buffers and extra registers.
The initial version of SVGAv3 lacked support for most advanced features
(e.g. 3D) which made fences unnecessary. That is no longer the case,
especially as 3D support is being turned on.

Switch from FIFO commands and capabilities to command buffers and extra
registers to enable fences on SVGAv3.

Fixes: 2cd80dbd3551 ("drm/vmwgfx: Add basic support for SVGA3")
Signed-off-by: Zack Rusin <zackr@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Reviewed-by: Maaz Mombasawala <mombasawalam@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220302152426.885214-5-zack@kde.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c   |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h   |  8 ++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c | 28 ++++++++++++++++++++-------
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c   | 26 +++++++++++++++++--------
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c   |  8 +++++---
 5 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
index a3bfbb6c3e14..bf1b394753da 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
@@ -528,7 +528,7 @@ int vmw_cmd_send_fence(struct vmw_private *dev_priv, uint32_t *seqno)
 		*seqno = atomic_add_return(1, &dev_priv->marker_seq);
 	} while (*seqno == 0);
 
-	if (!(vmw_fifo_caps(dev_priv) & SVGA_FIFO_CAP_FENCE)) {
+	if (!vmw_has_fences(dev_priv)) {
 
 		/*
 		 * Don't request hardware to send a fence. The
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index ea3ecdda561d..6de0b9ef5c77 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1679,4 +1679,12 @@ static inline void vmw_irq_status_write(struct vmw_private *vmw,
 		outl(status, vmw->io_start + SVGA_IRQSTATUS_PORT);
 }
 
+static inline bool vmw_has_fences(struct vmw_private *vmw)
+{
+	if ((vmw->capabilities & (SVGA_CAP_COMMAND_BUFFERS |
+				  SVGA_CAP_CMD_BUFFERS_2)) != 0)
+		return true;
+	return (vmw_fifo_caps(vmw) & SVGA_FIFO_CAP_FENCE) != 0;
+}
+
 #endif
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index 5001b87aebe8..a16b854ca18a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -82,6 +82,22 @@ fman_from_fence(struct vmw_fence_obj *fence)
 	return container_of(fence->base.lock, struct vmw_fence_manager, lock);
 }
 
+static u32 vmw_fence_goal_read(struct vmw_private *vmw)
+{
+	if ((vmw->capabilities2 & SVGA_CAP2_EXTRA_REGS) != 0)
+		return vmw_read(vmw, SVGA_REG_FENCE_GOAL);
+	else
+		return vmw_fifo_mem_read(vmw, SVGA_FIFO_FENCE_GOAL);
+}
+
+static void vmw_fence_goal_write(struct vmw_private *vmw, u32 value)
+{
+	if ((vmw->capabilities2 & SVGA_CAP2_EXTRA_REGS) != 0)
+		vmw_write(vmw, SVGA_REG_FENCE_GOAL, value);
+	else
+		vmw_fifo_mem_write(vmw, SVGA_FIFO_FENCE_GOAL, value);
+}
+
 /*
  * Note on fencing subsystem usage of irqs:
  * Typically the vmw_fences_update function is called
@@ -392,7 +408,7 @@ static bool vmw_fence_goal_new_locked(struct vmw_fence_manager *fman,
 	if (likely(!fman->seqno_valid))
 		return false;
 
-	goal_seqno = vmw_fifo_mem_read(fman->dev_priv, SVGA_FIFO_FENCE_GOAL);
+	goal_seqno = vmw_fence_goal_read(fman->dev_priv);
 	if (likely(passed_seqno - goal_seqno >= VMW_FENCE_WRAP))
 		return false;
 
@@ -400,9 +416,8 @@ static bool vmw_fence_goal_new_locked(struct vmw_fence_manager *fman,
 	list_for_each_entry(fence, &fman->fence_list, head) {
 		if (!list_empty(&fence->seq_passed_actions)) {
 			fman->seqno_valid = true;
-			vmw_fifo_mem_write(fman->dev_priv,
-					   SVGA_FIFO_FENCE_GOAL,
-					   fence->base.seqno);
+			vmw_fence_goal_write(fman->dev_priv,
+					     fence->base.seqno);
 			break;
 		}
 	}
@@ -434,13 +449,12 @@ static bool vmw_fence_goal_check_locked(struct vmw_fence_obj *fence)
 	if (dma_fence_is_signaled_locked(&fence->base))
 		return false;
 
-	goal_seqno = vmw_fifo_mem_read(fman->dev_priv, SVGA_FIFO_FENCE_GOAL);
+	goal_seqno = vmw_fence_goal_read(fman->dev_priv);
 	if (likely(fman->seqno_valid &&
 		   goal_seqno - fence->base.seqno < VMW_FENCE_WRAP))
 		return false;
 
-	vmw_fifo_mem_write(fman->dev_priv, SVGA_FIFO_FENCE_GOAL,
-			   fence->base.seqno);
+	vmw_fence_goal_write(fman->dev_priv, fence->base.seqno);
 	fman->seqno_valid = true;
 
 	return true;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
index c5191de365ca..fe4732bf2c9d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
@@ -32,6 +32,14 @@
 
 #define VMW_FENCE_WRAP (1 << 24)
 
+static u32 vmw_irqflag_fence_goal(struct vmw_private *vmw)
+{
+	if ((vmw->capabilities2 & SVGA_CAP2_EXTRA_REGS) != 0)
+		return SVGA_IRQFLAG_REG_FENCE_GOAL;
+	else
+		return SVGA_IRQFLAG_FENCE_GOAL;
+}
+
 /**
  * vmw_thread_fn - Deferred (process context) irq handler
  *
@@ -96,7 +104,7 @@ static irqreturn_t vmw_irq_handler(int irq, void *arg)
 		wake_up_all(&dev_priv->fifo_queue);
 
 	if ((masked_status & (SVGA_IRQFLAG_ANY_FENCE |
-			      SVGA_IRQFLAG_FENCE_GOAL)) &&
+			      vmw_irqflag_fence_goal(dev_priv))) &&
 	    !test_and_set_bit(VMW_IRQTHREAD_FENCE, dev_priv->irqthread_pending))
 		ret = IRQ_WAKE_THREAD;
 
@@ -137,8 +145,7 @@ bool vmw_seqno_passed(struct vmw_private *dev_priv,
 	if (likely(dev_priv->last_read_seqno - seqno < VMW_FENCE_WRAP))
 		return true;
 
-	if (!(vmw_fifo_caps(dev_priv) & SVGA_FIFO_CAP_FENCE) &&
-	    vmw_fifo_idle(dev_priv, seqno))
+	if (!vmw_has_fences(dev_priv) && vmw_fifo_idle(dev_priv, seqno))
 		return true;
 
 	/**
@@ -160,6 +167,7 @@ int vmw_fallback_wait(struct vmw_private *dev_priv,
 		      unsigned long timeout)
 {
 	struct vmw_fifo_state *fifo_state = dev_priv->fifo;
+	bool fifo_down = false;
 
 	uint32_t count = 0;
 	uint32_t signal_seq;
@@ -176,12 +184,14 @@ int vmw_fallback_wait(struct vmw_private *dev_priv,
 	 */
 
 	if (fifo_idle) {
-		down_read(&fifo_state->rwsem);
 		if (dev_priv->cman) {
 			ret = vmw_cmdbuf_idle(dev_priv->cman, interruptible,
 					      10*HZ);
 			if (ret)
 				goto out_err;
+		} else if (fifo_state) {
+			down_read(&fifo_state->rwsem);
+			fifo_down = true;
 		}
 	}
 
@@ -218,12 +228,12 @@ int vmw_fallback_wait(struct vmw_private *dev_priv,
 		}
 	}
 	finish_wait(&dev_priv->fence_queue, &__wait);
-	if (ret == 0 && fifo_idle)
+	if (ret == 0 && fifo_idle && fifo_state)
 		vmw_fence_write(dev_priv, signal_seq);
 
 	wake_up_all(&dev_priv->fence_queue);
 out_err:
-	if (fifo_idle)
+	if (fifo_down)
 		up_read(&fifo_state->rwsem);
 
 	return ret;
@@ -266,13 +276,13 @@ void vmw_seqno_waiter_remove(struct vmw_private *dev_priv)
 
 void vmw_goal_waiter_add(struct vmw_private *dev_priv)
 {
-	vmw_generic_waiter_add(dev_priv, SVGA_IRQFLAG_FENCE_GOAL,
+	vmw_generic_waiter_add(dev_priv, vmw_irqflag_fence_goal(dev_priv),
 			       &dev_priv->goal_queue_waiters);
 }
 
 void vmw_goal_waiter_remove(struct vmw_private *dev_priv)
 {
-	vmw_generic_waiter_remove(dev_priv, SVGA_IRQFLAG_FENCE_GOAL,
+	vmw_generic_waiter_remove(dev_priv, vmw_irqflag_fence_goal(dev_priv),
 				  &dev_priv->goal_queue_waiters);
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index bbd2f4ec08ec..93431e8f6606 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1344,7 +1344,6 @@ vmw_kms_new_framebuffer(struct vmw_private *dev_priv,
 		ret = vmw_kms_new_framebuffer_surface(dev_priv, surface, &vfb,
 						      mode_cmd,
 						      is_bo_proxy);
-
 		/*
 		 * vmw_create_bo_proxy() adds a reference that is no longer
 		 * needed
@@ -1385,13 +1384,16 @@ static struct drm_framebuffer *vmw_kms_fb_create(struct drm_device *dev,
 	ret = vmw_user_lookup_handle(dev_priv, file_priv,
 				     mode_cmd->handles[0],
 				     &surface, &bo);
-	if (ret)
+	if (ret) {
+		DRM_ERROR("Invalid buffer object handle %u (0x%x).\n",
+			  mode_cmd->handles[0], mode_cmd->handles[0]);
 		goto err_out;
+	}
 
 
 	if (!bo &&
 	    !vmw_kms_srf_ok(dev_priv, mode_cmd->width, mode_cmd->height)) {
-		DRM_ERROR("Surface size cannot exceed %dx%d",
+		DRM_ERROR("Surface size cannot exceed %dx%d\n",
 			dev_priv->texture_max_width,
 			dev_priv->texture_max_height);
 		goto err_out;
-- 
2.35.1



