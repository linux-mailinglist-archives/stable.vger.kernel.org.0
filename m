Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1296B454D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjCJOdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjCJOcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:32:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98439DB6E0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:31:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A9F3617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D77C433EF;
        Fri, 10 Mar 2023 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458698;
        bh=QK6yGbs9L+HdA/RvPTijrMvxHa6fQ9emJGmrEEjvBik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coXEIc3L7R05naTjE8VF9fMdXu4p7JKMBJm1YRxTcixlm6waGlMZ5DXNVhLKzlVYR
         p3p8qFcZoRkDLgjZnT5cZBp8tKYK42CEFwD2N/ZygNJ4MJwR09IZLSNepW8MqWLRvo
         d99n/kiVrkku6j/t3bigVtIlPIKVh5Jlzyi7na3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Thomas Zimmermann <tzimmermann@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/357] drm: Initialize struct drm_crtc_state.no_vblank from device settings
Date:   Fri, 10 Mar 2023 14:36:42 +0100
Message-Id: <20230310133739.641491296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 7beb691f1e6f349c9df3384a85e7a53c5601aaaf ]

At the end of a commit, atomic helpers can generate a fake VBLANK event
automatically. Originally implemented for writeback connectors, the
functionality can be used by any driver and/or hardware without proper
VBLANK interrupt.

The patch updates the documentation to make this behaviour official:
settings struct drm_crtc_state.no_vblank to true enables automatic
generation of fake VBLANK events.

The new interface drm_dev_has_vblank() returns true if vblanking has
been initialized for a device, or false otherwise. Atomic helpers use
this function when initializing no_vblank in the CRTC state in
drm_atomic_helper_check_modeset(). If vblanking has been initialized
for a device, no_blank is disabled. Otherwise it's enabled. Hence,
atomic helpers will automatically send out fake VBLANK events with any
driver that did not initialize vblanking.

v5:
	* more precise documentation and commit message
v4:
	* replace drm_crtc_has_vblank() with drm_dev_has_vblank()
	* add drm_dev_has_vblank() in this patch
	* move driver changes into separate patches
v3:
	* squash all related changes patches into this patch

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200129120531.6891-2-tzimmermann@suse.de
Stable-dep-of: 13fcfcb2a9a4 ("drm/msm/mdp5: Add check for kzalloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_helper.c | 10 ++++++++-
 drivers/gpu/drm/drm_vblank.c        | 28 ++++++++++++++++++++++++
 include/drm/drm_crtc.h              | 34 +++++++++++++++++++++++------
 include/drm/drm_simple_kms_helper.h |  7 ++++--
 include/drm/drm_vblank.h            |  1 +
 5 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index e95c45cf5ffe8..62b77f3a950b8 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -589,6 +589,7 @@ mode_valid(struct drm_atomic_state *state)
  * &drm_crtc_state.connectors_changed is set when a connector is added or
  * removed from the crtc.  &drm_crtc_state.active_changed is set when
  * &drm_crtc_state.active changes, which is used for DPMS.
+ * &drm_crtc_state.no_vblank is set from the result of drm_dev_has_vblank().
  * See also: drm_atomic_crtc_needs_modeset()
  *
  * IMPORTANT:
@@ -655,6 +656,11 @@ drm_atomic_helper_check_modeset(struct drm_device *dev,
 
 			return -EINVAL;
 		}
+
+		if (drm_dev_has_vblank(dev))
+			new_crtc_state->no_vblank = false;
+		else
+			new_crtc_state->no_vblank = true;
 	}
 
 	ret = handle_conflicting_encoders(state, false);
@@ -2205,7 +2211,9 @@ EXPORT_SYMBOL(drm_atomic_helper_wait_for_dependencies);
  * when a job is queued, and any change to the pipeline that does not touch the
  * connector is leading to timeouts when calling
  * drm_atomic_helper_wait_for_vblanks() or
- * drm_atomic_helper_wait_for_flip_done().
+ * drm_atomic_helper_wait_for_flip_done(). In addition to writeback
+ * connectors, this function can also fake VBLANK events for CRTCs without
+ * VBLANK interrupt.
  *
  * This is part of the atomic helper support for nonblocking commits, see
  * drm_atomic_helper_setup_commit() for an overview.
diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
index 552ec82e9bc52..c98ed8146242d 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -69,6 +69,12 @@
  * &drm_driver.max_vblank_count. In that case the vblank core only disables the
  * vblanks after a timer has expired, which can be configured through the
  * ``vblankoffdelay`` module parameter.
+ *
+ * Drivers for hardware without support for vertical-blanking interrupts
+ * must not call drm_vblank_init(). For such drivers, atomic helpers will
+ * automatically generate fake vblank events as part of the display update.
+ * This functionality also can be controlled by the driver by enabling and
+ * disabling struct drm_crtc_state.no_vblank.
  */
 
 /* Retry timestamp calculation up to 3 times to satisfy
@@ -488,6 +494,28 @@ int drm_vblank_init(struct drm_device *dev, unsigned int num_crtcs)
 }
 EXPORT_SYMBOL(drm_vblank_init);
 
+/**
+ * drm_dev_has_vblank - test if vblanking has been initialized for
+ *                      a device
+ * @dev: the device
+ *
+ * Drivers may call this function to test if vblank support is
+ * initialized for a device. For most hardware this means that vblanking
+ * can also be enabled.
+ *
+ * Atomic helpers use this function to initialize
+ * &drm_crtc_state.no_vblank. See also drm_atomic_helper_check_modeset().
+ *
+ * Returns:
+ * True if vblanking has been initialized for the given device, false
+ * otherwise.
+ */
+bool drm_dev_has_vblank(const struct drm_device *dev)
+{
+	return dev->num_crtcs != 0;
+}
+EXPORT_SYMBOL(drm_dev_has_vblank);
+
 /**
  * drm_crtc_vblank_waitqueue - get vblank waitqueue for the CRTC
  * @crtc: which CRTC's vblank waitqueue to retrieve
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 408b6f4e63c0c..ebcce95f9da63 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -175,12 +175,25 @@ struct drm_crtc_state {
 	 * @no_vblank:
 	 *
 	 * Reflects the ability of a CRTC to send VBLANK events. This state
-	 * usually depends on the pipeline configuration, and the main usuage
-	 * is CRTCs feeding a writeback connector operating in oneshot mode.
-	 * In this case the VBLANK event is only generated when a job is queued
-	 * to the writeback connector, and we want the core to fake VBLANK
-	 * events when this part of the pipeline hasn't changed but others had
-	 * or when the CRTC and connectors are being disabled.
+	 * usually depends on the pipeline configuration. If set to true, DRM
+	 * atomic helpers will send out a fake VBLANK event during display
+	 * updates after all hardware changes have been committed. This is
+	 * implemented in drm_atomic_helper_fake_vblank().
+	 *
+	 * One usage is for drivers and/or hardware without support for VBLANK
+	 * interrupts. Such drivers typically do not initialize vblanking
+	 * (i.e., call drm_vblank_init() with the number of CRTCs). For CRTCs
+	 * without initialized vblanking, this field is set to true in
+	 * drm_atomic_helper_check_modeset(), and a fake VBLANK event will be
+	 * send out on each update of the display pipeline by
+	 * drm_atomic_helper_fake_vblank().
+	 *
+	 * Another usage is CRTCs feeding a writeback connector operating in
+	 * oneshot mode. In this case the fake VBLANK event is only generated
+	 * when a job is queued to the writeback connector, and we want the
+	 * core to fake VBLANK events when this part of the pipeline hasn't
+	 * changed but others had or when the CRTC and connectors are being
+	 * disabled.
 	 *
 	 * __drm_atomic_helper_crtc_duplicate_state() will not reset the value
 	 * from the current state, the CRTC driver is then responsible for
@@ -336,7 +349,14 @@ struct drm_crtc_state {
 	 *  - Events for disabled CRTCs are not allowed, and drivers can ignore
 	 *    that case.
 	 *
-	 * This can be handled by the drm_crtc_send_vblank_event() function,
+	 * For very simple hardware without VBLANK interrupt, enabling
+	 * &struct drm_crtc_state.no_vblank makes DRM's atomic commit helpers
+	 * send a fake VBLANK event at the end of the display update after all
+	 * hardware changes have been applied. See
+	 * drm_atomic_helper_fake_vblank().
+	 *
+	 * For more complex hardware this
+	 * can be handled by the drm_crtc_send_vblank_event() function,
 	 * which the driver should call on the provided event upon completion of
 	 * the atomic commit. Note that if the driver supports vblank signalling
 	 * and timestamping the vblank counters and timestamps must agree with
diff --git a/include/drm/drm_simple_kms_helper.h b/include/drm/drm_simple_kms_helper.h
index 4d89cd0a60db8..df615eb92b098 100644
--- a/include/drm/drm_simple_kms_helper.h
+++ b/include/drm/drm_simple_kms_helper.h
@@ -100,8 +100,11 @@ struct drm_simple_display_pipe_funcs {
 	 * This is the function drivers should submit the
 	 * &drm_pending_vblank_event from. Using either
 	 * drm_crtc_arm_vblank_event(), when the driver supports vblank
-	 * interrupt handling, or drm_crtc_send_vblank_event() directly in case
-	 * the hardware lacks vblank support entirely.
+	 * interrupt handling, or drm_crtc_send_vblank_event() for more
+	 * complex case. In case the hardware lacks vblank support entirely,
+	 * drivers can set &struct drm_crtc_state.no_vblank in
+	 * &struct drm_simple_display_pipe_funcs.check and let DRM's
+	 * atomic helper fake a vblank event.
 	 */
 	void (*update)(struct drm_simple_display_pipe *pipe,
 		       struct drm_plane_state *old_plane_state);
diff --git a/include/drm/drm_vblank.h b/include/drm/drm_vblank.h
index 9fe4ba8bc622c..2559fb9218699 100644
--- a/include/drm/drm_vblank.h
+++ b/include/drm/drm_vblank.h
@@ -195,6 +195,7 @@ struct drm_vblank_crtc {
 };
 
 int drm_vblank_init(struct drm_device *dev, unsigned int num_crtcs);
+bool drm_dev_has_vblank(const struct drm_device *dev);
 u64 drm_crtc_vblank_count(struct drm_crtc *crtc);
 u64 drm_crtc_vblank_count_and_time(struct drm_crtc *crtc,
 				   ktime_t *vblanktime);
-- 
2.39.2



