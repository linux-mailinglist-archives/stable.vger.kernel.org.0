Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0E75F269D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiJBWzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiJBWyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:54:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE9C14096;
        Sun,  2 Oct 2022 15:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0440B80924;
        Sun,  2 Oct 2022 22:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2E9C433C1;
        Sun,  2 Oct 2022 22:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751100;
        bh=1Btak+V6mpWCjnqSLc99b3Qti2O6zO1lxM7YkezTo3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILoSiazZSmoj6NQDvv30yA6Zw4zBe5FjW2/Z6KWLYSdR3T6/SrHB1Ie2gwP8IRQOz
         K4iRfm/FUgYaDFc/sUyUOir6EeuhOgcsRW/BBfDOrZH6qkQHZ6c65UBdrzN8IGwlT/
         CDPgAESaBHGk2k5yoyTmQLmAwhWRiwZVbzhv94LHabG3wFV1RPvHCBbmgwqcm3cPax
         QdK5LiCsmffi9KkkGwtXQ8zGnJHLtSAoKbs03J+fZOREqE3EzjdiU89dI8M1ox/hoT
         z5ef4w82D4m4TFzH+HgAQ+EXrVHlD7vGLk+nZTB6Yv4u2O/PR2Z/EW3nBUsOJ41ZBd
         KgQmM7Bxq4mMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leo Li <sunpeng.li@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Wayne Lin <wayne.lin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        nicholas.kazlauskas@amd.com, aurabindo.pillai@amd.com,
        roman.li@amd.com, shenshih@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 17/20] drm/amd/display: Fix double cursor on non-video RGB MPO
Date:   Sun,  2 Oct 2022 18:50:56 -0400
Message-Id: <20221002225100.239217-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225100.239217-1-sashal@kernel.org>
References: <20221002225100.239217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Li <sunpeng.li@amd.com>

[ Upstream commit b261509952bc19d1012cf732f853659be6ebc61e ]

[Why]

DC makes use of layer_index (zpos) when picking the HW plane to enable
HW cursor on. However, some compositors will not attach zpos information
to each DRM plane. Consequently, in amdgpu, we default layer_index to 0
and do not update it.

This causes said DC logic to enable HW cursor on all planes of the same
layer_index, which manifests as a double cursor issue if one of the
planes is scaled (and hence scaling the cursor as well).

[How]

Use DRM core helpers to calculate a normalized_zpos value for each
drm_plane_state under each crtc, within the atomic state.

This helper will first consider existing zpos values, and if
identical/unset, fallback to plane ID ordering.

The normalized_zpos is then passed to dc_plane_info during atomic check
for later use by the cursor logic.

Reviewed-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e3dfea3d44a4..c826fc493e0f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5442,7 +5442,7 @@ fill_dc_plane_info_and_addr(struct amdgpu_device *adev,
 	plane_info->visible = true;
 	plane_info->stereo_format = PLANE_STEREO_FORMAT_NONE;
 
-	plane_info->layer_index = 0;
+	plane_info->layer_index = plane_state->normalized_zpos;
 
 	ret = fill_plane_color_attributes(plane_state, plane_info->format,
 					  &plane_info->color_space);
@@ -5509,7 +5509,7 @@ static int fill_dc_plane_attributes(struct amdgpu_device *adev,
 	dc_plane_state->global_alpha = plane_info.global_alpha;
 	dc_plane_state->global_alpha_value = plane_info.global_alpha_value;
 	dc_plane_state->dcc = plane_info.dcc;
-	dc_plane_state->layer_index = plane_info.layer_index; // Always returns 0
+	dc_plane_state->layer_index = plane_info.layer_index;
 	dc_plane_state->flip_int_enabled = true;
 
 	/*
@@ -10828,6 +10828,14 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		}
 	}
 
+	/*
+	 * DC consults the zpos (layer_index in DC terminology) to determine the
+	 * hw plane on which to enable the hw cursor (see
+	 * `dcn10_can_pipe_disable_cursor`). By now, all modified planes are in
+	 * atomic state, so call drm helper to normalize zpos.
+	 */
+	drm_atomic_normalize_zpos(dev, state);
+
 	/* Remove exiting planes if they are modified */
 	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
 		ret = dm_update_plane_state(dc, state, plane,
-- 
2.35.1

