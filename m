Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388216648BC
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238948AbjAJSOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbjAJSNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:13:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CD34914F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:11:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A43D261870
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85E7C433F0;
        Tue, 10 Jan 2023 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374314;
        bh=w3rkMHyOLysfq/DrTNdef7doeNH2+eXsesypNstpKKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5/rWFGvtvVVeb5EbXo68NQGwCp5KyWW93FCNeMb3v69YLJunma7bcVFBGrJzOiGN
         3MdelbFiQiDMoqzcr6oD8upF+Sm8eUbWYvQG41bGBXKNYlcm78Eu3ObPofDShlmf8G
         2zi/+J/6SNv8BLw1LiilM5tKK2CHaj1yqE1K9WoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 126/148] Revert "drm/amd/display: Enable Freesync Video Mode by default"
Date:   Tue, 10 Jan 2023 19:03:50 +0100
Message-Id: <20230110180021.185653179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michel Dänzer <mdaenzer@redhat.com>

commit 6fe6ece398f7431784847e922a2c8c385dc58a35 upstream.

This reverts commit de05abe6b9d0fe08f65d744f7f75a4cba4df27ad.

The bug referenced below was bisected to this commit. There has been no
activity toward fixing it in 3 months, so let's revert for now.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2162
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h               |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c           |   27 ++++++++++++++++++++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   12 +++++----
 3 files changed, 35 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -196,6 +196,7 @@ extern int amdgpu_emu_mode;
 extern uint amdgpu_smu_memory_pool_size;
 extern int amdgpu_smu_pptable_id;
 extern uint amdgpu_dc_feature_mask;
+extern uint amdgpu_freesync_vid_mode;
 extern uint amdgpu_dc_debug_mask;
 extern uint amdgpu_dc_visual_confirm;
 extern uint amdgpu_dm_abm_level;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -177,6 +177,7 @@ int amdgpu_mes_kiq;
 int amdgpu_noretry = -1;
 int amdgpu_force_asic_type = -1;
 int amdgpu_tmz = -1; /* auto */
+uint amdgpu_freesync_vid_mode;
 int amdgpu_reset_method = -1; /* auto */
 int amdgpu_num_kcq = -1;
 int amdgpu_smartshift_bias;
@@ -863,6 +864,32 @@ MODULE_PARM_DESC(tmz, "Enable TMZ featur
 module_param_named(tmz, amdgpu_tmz, int, 0444);
 
 /**
+ * DOC: freesync_video (uint)
+ * Enable the optimization to adjust front porch timing to achieve seamless
+ * mode change experience when setting a freesync supported mode for which full
+ * modeset is not needed.
+ *
+ * The Display Core will add a set of modes derived from the base FreeSync
+ * video mode into the corresponding connector's mode list based on commonly
+ * used refresh rates and VRR range of the connected display, when users enable
+ * this feature. From the userspace perspective, they can see a seamless mode
+ * change experience when the change between different refresh rates under the
+ * same resolution. Additionally, userspace applications such as Video playback
+ * can read this modeset list and change the refresh rate based on the video
+ * frame rate. Finally, the userspace can also derive an appropriate mode for a
+ * particular refresh rate based on the FreeSync Mode and add it to the
+ * connector's mode list.
+ *
+ * Note: This is an experimental feature.
+ *
+ * The default value: 0 (off).
+ */
+MODULE_PARM_DESC(
+	freesync_video,
+	"Enable freesync modesetting optimization feature (0 = off (default), 1 = on)");
+module_param_named(freesync_video, amdgpu_freesync_vid_mode, uint, 0444);
+
+/**
  * DOC: reset_method (int)
  * GPU reset method (-1 = auto (default), 0 = legacy, 1 = mode0, 2 = mode1, 3 = mode2, 4 = baco)
  */
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5821,7 +5821,8 @@ create_stream_for_sink(struct amdgpu_dm_
 		 */
 		DRM_DEBUG_DRIVER("No preferred mode found\n");
 	} else {
-		recalculate_timing = is_freesync_video_mode(&mode, aconnector);
+		recalculate_timing = amdgpu_freesync_vid_mode &&
+				 is_freesync_video_mode(&mode, aconnector);
 		if (recalculate_timing) {
 			freesync_mode = get_highest_refresh_rate_mode(aconnector, false);
 			drm_mode_copy(&saved_mode, &mode);
@@ -6895,7 +6896,7 @@ static void amdgpu_dm_connector_add_free
 	struct amdgpu_dm_connector *amdgpu_dm_connector =
 		to_amdgpu_dm_connector(connector);
 
-	if (!edid)
+	if (!(amdgpu_freesync_vid_mode && edid))
 		return;
 
 	if (amdgpu_dm_connector->max_vfreq - amdgpu_dm_connector->min_vfreq > 10)
@@ -8766,7 +8767,8 @@ static int dm_update_crtc_state(struct a
 		 * TODO: Refactor this function to allow this check to work
 		 * in all conditions.
 		 */
-		if (dm_new_crtc_state->stream &&
+		if (amdgpu_freesync_vid_mode &&
+		    dm_new_crtc_state->stream &&
 		    is_timing_unchanged_for_freesync(new_crtc_state, old_crtc_state))
 			goto skip_modeset;
 
@@ -8801,7 +8803,7 @@ static int dm_update_crtc_state(struct a
 		if (!dm_old_crtc_state->stream)
 			goto skip_modeset;
 
-		if (dm_new_crtc_state->stream &&
+		if (amdgpu_freesync_vid_mode && dm_new_crtc_state->stream &&
 		    is_timing_unchanged_for_freesync(new_crtc_state,
 						     old_crtc_state)) {
 			new_crtc_state->mode_changed = false;
@@ -8813,7 +8815,7 @@ static int dm_update_crtc_state(struct a
 			set_freesync_fixed_config(dm_new_crtc_state);
 
 			goto skip_modeset;
-		} else if (aconnector &&
+		} else if (amdgpu_freesync_vid_mode && aconnector &&
 			   is_freesync_video_mode(&new_crtc_state->mode,
 						  aconnector)) {
 			struct drm_display_mode *high_mode;


