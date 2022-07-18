Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701B9578BE1
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 22:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbiGRUfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 16:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbiGRUfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 16:35:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBC930548
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 13:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C06C060B36
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 20:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91445C341C0;
        Mon, 18 Jul 2022 20:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658176541;
        bh=QKQTU4td/VTILPnY4L3P7f61LwyTWrDyCFOKHbjz2gY=;
        h=Subject:To:Cc:From:Date:From;
        b=i/oOeqtx2QtGNEgem7PqPCkoKc9DWNVS1p4Kl1od1mw1YUTCjgHz8GH5yzW5DzN8a
         HGW+4Rws7wmimA2YFlFge951p8S87QVvAoA1WK8aOnNyt49cRRcCc8AuEt0eySOsjt
         vI/1gSECqdG1cFmQz+YSl/ob+3vC4EH0aqG9ET6c=
Subject: FAILED: patch "[PATCH] drm/amd/display: Ensure valid event timestamp for cursor-only" failed to apply to 5.15-stable tree
To:     mdaenzer@redhat.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jul 2022 22:35:29 +0200
Message-ID: <165817652924721@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3283c83eb6fcfbda8ea03d7149d8e42e71c5d45e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>
Date: Mon, 11 Jul 2022 16:51:31 +0200
Subject: [PATCH] drm/amd/display: Ensure valid event timestamp for cursor-only
 commits
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Requires enabling the vblank machinery for them.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2030
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d2e628358429..93ac33a8de9a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -463,6 +463,26 @@ static void dm_pflip_high_irq(void *interrupt_params)
 		     vrr_active, (int) !e);
 }
 
+static void dm_crtc_handle_vblank(struct amdgpu_crtc *acrtc)
+{
+	struct drm_crtc *crtc = &acrtc->base;
+	struct drm_device *dev = crtc->dev;
+	unsigned long flags;
+
+	drm_crtc_handle_vblank(crtc);
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+
+	/* Send completion event for cursor-only commits */
+	if (acrtc->event && acrtc->pflip_status != AMDGPU_FLIP_SUBMITTED) {
+		drm_crtc_send_vblank_event(crtc, acrtc->event);
+		drm_crtc_vblank_put(crtc);
+		acrtc->event = NULL;
+	}
+
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+}
+
 static void dm_vupdate_high_irq(void *interrupt_params)
 {
 	struct common_irq_params *irq_params = interrupt_params;
@@ -501,7 +521,7 @@ static void dm_vupdate_high_irq(void *interrupt_params)
 		 * if a pageflip happened inside front-porch.
 		 */
 		if (vrr_active) {
-			drm_crtc_handle_vblank(&acrtc->base);
+			dm_crtc_handle_vblank(acrtc);
 
 			/* BTR processing for pre-DCE12 ASICs */
 			if (acrtc->dm_irq_params.stream &&
@@ -553,7 +573,7 @@ static void dm_crtc_high_irq(void *interrupt_params)
 	 * to dm_vupdate_high_irq after end of front-porch.
 	 */
 	if (!vrr_active)
-		drm_crtc_handle_vblank(&acrtc->base);
+		dm_crtc_handle_vblank(acrtc);
 
 	/**
 	 * Following stuff must happen at start of vblank, for crc
@@ -9174,6 +9194,7 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 	struct amdgpu_bo *abo;
 	uint32_t target_vblank, last_flip_vblank;
 	bool vrr_active = amdgpu_dm_vrr_active(acrtc_state);
+	bool cursor_update = false;
 	bool pflip_present = false;
 	struct {
 		struct dc_surface_update surface_updates[MAX_SURFACES];
@@ -9209,8 +9230,13 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 		struct dm_plane_state *dm_new_plane_state = to_dm_plane_state(new_plane_state);
 
 		/* Cursor plane is handled after stream updates */
-		if (plane->type == DRM_PLANE_TYPE_CURSOR)
+		if (plane->type == DRM_PLANE_TYPE_CURSOR) {
+			if ((fb && crtc == pcrtc) ||
+			    (old_plane_state->fb && old_plane_state->crtc == pcrtc))
+				cursor_update = true;
+
 			continue;
+		}
 
 		if (!fb || !crtc || pcrtc != crtc)
 			continue;
@@ -9373,6 +9399,17 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 				bundle->stream_update.vrr_infopacket =
 					&acrtc_state->stream->vrr_infopacket;
 		}
+	} else if (cursor_update && acrtc_state->active_planes > 0 &&
+		   !acrtc_state->force_dpms_off &&
+		   acrtc_attach->base.state->event) {
+		drm_crtc_vblank_get(pcrtc);
+
+		spin_lock_irqsave(&pcrtc->dev->event_lock, flags);
+
+		acrtc_attach->event = acrtc_attach->base.state->event;
+		acrtc_attach->base.state->event = NULL;
+
+		spin_unlock_irqrestore(&pcrtc->dev->event_lock, flags);
 	}
 
 	/* Update the planes if changed or disable if we don't have any. */

