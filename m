Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD2568308D
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjAaPDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjAaPDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:03:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6561E561BA;
        Tue, 31 Jan 2023 07:00:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CD5761546;
        Tue, 31 Jan 2023 15:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923FEC4339B;
        Tue, 31 Jan 2023 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177253;
        bh=BE7t3BHAtkfh4ocJ/M8wo22S/1Tn4jF2RQyS6I5LgMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LETgZk0ZaRQZ185s+zOS7JdfaXIo0WGpeFvcvO2deUZ08PtnYcogjCL/HvNZzuPz1
         ytOj/WfGEgvOVqTz5QKnGupSmIQDTj3DM+D6N3jMrJhCdpc3ZwznN09+52lUoFalNE
         aKwozqHKen7Q+xG00gNGn4Vpqvet1KNGpXxh4ljSvd/p0FWoPKeZIjpUyVI4xVkAn5
         xn6KBeUmXZ/XI2zxAEOnr38DBmrGijoGcV1aqpUFUlwb5SRRpE9fZ9sbbUVslXZq9g
         HlVoc8vBMVQ3eG1V0JFdbpNLtHWL8sdfw1SbstEiAmzWBvjLB1zzcqQXl40UAukK0R
         tDyqptmrVbMbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Alan Liu <HaoPing.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, roman.li@amd.com, stylon.wang@amd.com,
        lyude@redhat.com, Jerry.Zuo@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 11/12] drm/amd/display: Fix timing not changning when freesync video is enabled
Date:   Tue, 31 Jan 2023 10:00:29 -0500
Message-Id: <20230131150030.1250104-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150030.1250104-1-sashal@kernel.org>
References: <20230131150030.1250104-1-sashal@kernel.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 4b069553246f993c4221e382d0d0ae34f5ba730e ]

[Why&How]
Switching between certain modes that are freesync video modes and those
are not freesync video modes result in timing not changing as seen by
the monitor due to incorrect timing being driven.

The issue is fixed by ensuring that when a non freesync video mode is
set, we reset the freesync status on the crtc.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 409739ee5ba0..ee238a16572e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10140,6 +10140,13 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 		if (!dm_old_crtc_state->stream)
 			goto skip_modeset;
 
+		/* Unset freesync video if it was active before */
+		if (dm_old_crtc_state->freesync_config.state == VRR_STATE_ACTIVE_FIXED) {
+			dm_new_crtc_state->freesync_config.state = VRR_STATE_INACTIVE;
+			dm_new_crtc_state->freesync_config.fixed_refresh_in_uhz = 0;
+		}
+
+		/* Now check if we should set freesync video mode */
 		if (amdgpu_freesync_vid_mode && dm_new_crtc_state->stream &&
 		    is_timing_unchanged_for_freesync(new_crtc_state,
 						     old_crtc_state)) {
-- 
2.39.0

