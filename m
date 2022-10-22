Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFC860866E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiJVHts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiJVHso (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC45D1EF075;
        Sat, 22 Oct 2022 00:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86C4A60B82;
        Sat, 22 Oct 2022 07:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA9BC433D6;
        Sat, 22 Oct 2022 07:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424509;
        bh=B9/5WzG7VmvisZ35bxicFFxNTPqdrMbAcqvJCyyI0FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frJJm0BMFAyXUuXAp5+v6x7CnUh2/N+izHyfxwcfaUhZB6xTfT/IwyitDqtwkx6c9
         pZhFCjp/9AS3XPPLEzTiUU6mLeCUEjq+CX0OcBdT+a0HfIBvU99dqYXjP/9FrrL0nR
         Vwf0+zE8me8ehOmWa8EiWMk9/QNxqc1xXTGfZGjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Yunxiang Li <Yunxiang.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 173/717] drm/amd/display: Fix vblank refcount in vrr transition
Date:   Sat, 22 Oct 2022 09:20:52 +0200
Message-Id: <20221022072446.142164857@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunxiang Li <Yunxiang.Li@amd.com>

commit 8799c0be89ebb99a16098bdf618f49f817bef76a upstream.

manage_dm_interrupts disable/enable vblank using drm_crtc_vblank_off/on
which causes drm_crtc_vblank_get in vrr_transition to fail, and later
when drm_crtc_vblank_put is called the refcount on vblank will be messed
up. Therefore move the call to after manage_dm_interrupts.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1247
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1380

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   55 ++++++++++------------
 1 file changed, 26 insertions(+), 29 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9157,15 +9157,15 @@ static void amdgpu_dm_handle_vrr_transit
 		 * We also need vupdate irq for the actual core vblank handling
 		 * at end of vblank.
 		 */
-		dm_set_vupdate_irq(new_state->base.crtc, true);
-		drm_crtc_vblank_get(new_state->base.crtc);
+		WARN_ON(dm_set_vupdate_irq(new_state->base.crtc, true) != 0);
+		WARN_ON(drm_crtc_vblank_get(new_state->base.crtc) != 0);
 		DRM_DEBUG_DRIVER("%s: crtc=%u VRR off->on: Get vblank ref\n",
 				 __func__, new_state->base.crtc->base.id);
 	} else if (old_vrr_active && !new_vrr_active) {
 		/* Transition VRR active -> inactive:
 		 * Allow vblank irq disable again for fixed refresh rate.
 		 */
-		dm_set_vupdate_irq(new_state->base.crtc, false);
+		WARN_ON(dm_set_vupdate_irq(new_state->base.crtc, false) != 0);
 		drm_crtc_vblank_put(new_state->base.crtc);
 		DRM_DEBUG_DRIVER("%s: crtc=%u VRR on->off: Drop vblank ref\n",
 				 __func__, new_state->base.crtc->base.id);
@@ -9916,23 +9916,6 @@ static void amdgpu_dm_atomic_commit_tail
 		mutex_unlock(&dm->dc_lock);
 	}
 
-	/* Count number of newly disabled CRTCs for dropping PM refs later. */
-	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state,
-				      new_crtc_state, i) {
-		if (old_crtc_state->active && !new_crtc_state->active)
-			crtc_disable_count++;
-
-		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
-		dm_old_crtc_state = to_dm_crtc_state(old_crtc_state);
-
-		/* For freesync config update on crtc state and params for irq */
-		update_stream_irq_parameters(dm, dm_new_crtc_state);
-
-		/* Handle vrr on->off / off->on transitions */
-		amdgpu_dm_handle_vrr_transition(dm_old_crtc_state,
-						dm_new_crtc_state);
-	}
-
 	/**
 	 * Enable interrupts for CRTCs that are newly enabled or went through
 	 * a modeset. It was intentionally deferred until after the front end
@@ -9942,16 +9925,29 @@ static void amdgpu_dm_atomic_commit_tail
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
 		struct amdgpu_crtc *acrtc = to_amdgpu_crtc(crtc);
 #ifdef CONFIG_DEBUG_FS
-		bool configure_crc = false;
 		enum amdgpu_dm_pipe_crc_source cur_crc_src;
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
-		struct crc_rd_work *crc_rd_wrk = dm->crc_rd_wrk;
+		struct crc_rd_work *crc_rd_wrk;
+#endif
+#endif
+		/* Count number of newly disabled CRTCs for dropping PM refs later. */
+		if (old_crtc_state->active && !new_crtc_state->active)
+			crtc_disable_count++;
+
+		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
+		dm_old_crtc_state = to_dm_crtc_state(old_crtc_state);
+
+		/* For freesync config update on crtc state and params for irq */
+		update_stream_irq_parameters(dm, dm_new_crtc_state);
+
+#ifdef CONFIG_DEBUG_FS
+#if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
+		crc_rd_wrk = dm->crc_rd_wrk;
 #endif
 		spin_lock_irqsave(&adev_to_drm(adev)->event_lock, flags);
 		cur_crc_src = acrtc->dm_irq_params.crc_src;
 		spin_unlock_irqrestore(&adev_to_drm(adev)->event_lock, flags);
 #endif
-		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
 
 		if (new_crtc_state->active &&
 		    (!old_crtc_state->active ||
@@ -9959,16 +9955,19 @@ static void amdgpu_dm_atomic_commit_tail
 			dc_stream_retain(dm_new_crtc_state->stream);
 			acrtc->dm_irq_params.stream = dm_new_crtc_state->stream;
 			manage_dm_interrupts(adev, acrtc, true);
+		}
+		/* Handle vrr on->off / off->on transitions */
+		amdgpu_dm_handle_vrr_transition(dm_old_crtc_state, dm_new_crtc_state);
 
 #ifdef CONFIG_DEBUG_FS
+		if (new_crtc_state->active &&
+		    (!old_crtc_state->active ||
+		     drm_atomic_crtc_needs_modeset(new_crtc_state))) {
 			/**
 			 * Frontend may have changed so reapply the CRC capture
 			 * settings for the stream.
 			 */
-			dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
-
 			if (amdgpu_dm_is_valid_crc_source(cur_crc_src)) {
-				configure_crc = true;
 #if defined(CONFIG_DRM_AMD_SECURE_DISPLAY)
 				if (amdgpu_dm_crc_window_is_activated(crtc)) {
 					spin_lock_irqsave(&adev_to_drm(adev)->event_lock, flags);
@@ -9980,12 +9979,10 @@ static void amdgpu_dm_atomic_commit_tail
 					spin_unlock_irqrestore(&adev_to_drm(adev)->event_lock, flags);
 				}
 #endif
-			}
-
-			if (configure_crc)
 				if (amdgpu_dm_crtc_configure_crc_source(
 					crtc, dm_new_crtc_state, cur_crc_src))
 					DRM_DEBUG_DRIVER("Failed to configure crc source");
+			}
 #endif
 		}
 	}


