Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3AE579E62
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243317AbiGSNA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242680AbiGSM70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E204945F60;
        Tue, 19 Jul 2022 05:24:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 788B661924;
        Tue, 19 Jul 2022 12:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D6DC341DA;
        Tue, 19 Jul 2022 12:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233465;
        bh=xM1h63EzfJyAhP/Vsu8PXkT6uqn3siEWV0H/xcVOprY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iku6esDkcr51/ler92EIDPSyQJwP01GkNQhGr9rXcGM35vZiIwWsU3HSfqImN0z+i
         BM3GCV28K6c87DZcAW0Tdzr4EqPmlMc25k02Ufx5elKyFhg7azV3rhMSuanUo8sVkr
         wh1IVhk+xzpQEB5wmAH12AkREuIjZiaAW5HB0Z1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 132/231] drm/amd/display: Ensure valid event timestamp for cursor-only commits
Date:   Tue, 19 Jul 2022 13:53:37 +0200
Message-Id: <20220719114725.544527782@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Michel Dänzer <mdaenzer@redhat.com>

[ Upstream commit 3283c83eb6fcfbda8ea03d7149d8e42e71c5d45e ]

Requires enabling the vblank machinery for them.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2030
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   43 ++++++++++++++++++++--
 1 file changed, 40 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -464,6 +464,26 @@ static void dm_pflip_high_irq(void *inte
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
@@ -502,7 +522,7 @@ static void dm_vupdate_high_irq(void *in
 		 * if a pageflip happened inside front-porch.
 		 */
 		if (vrr_active) {
-			drm_crtc_handle_vblank(&acrtc->base);
+			dm_crtc_handle_vblank(acrtc);
 
 			/* BTR processing for pre-DCE12 ASICs */
 			if (acrtc->dm_irq_params.stream &&
@@ -554,7 +574,7 @@ static void dm_crtc_high_irq(void *inter
 	 * to dm_vupdate_high_irq after end of front-porch.
 	 */
 	if (!vrr_active)
-		drm_crtc_handle_vblank(&acrtc->base);
+		dm_crtc_handle_vblank(acrtc);
 
 	/**
 	 * Following stuff must happen at start of vblank, for crc
@@ -9199,6 +9219,7 @@ static void amdgpu_dm_commit_planes(stru
 	struct amdgpu_bo *abo;
 	uint32_t target_vblank, last_flip_vblank;
 	bool vrr_active = amdgpu_dm_vrr_active(acrtc_state);
+	bool cursor_update = false;
 	bool pflip_present = false;
 	struct {
 		struct dc_surface_update surface_updates[MAX_SURFACES];
@@ -9234,8 +9255,13 @@ static void amdgpu_dm_commit_planes(stru
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
@@ -9397,6 +9423,17 @@ static void amdgpu_dm_commit_planes(stru
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


