Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E0168D7D5
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjBGNDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjBGNDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:03:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8763020D27
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E4C0B8198D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED14C433D2;
        Tue,  7 Feb 2023 13:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775015;
        bh=eRsj5y8UdJOC4NowCEwWyDg1p4PLIzX1ZtV3qYNCjMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iItr3Cegz7x1Jh6cdmJtRrG1wtF9lJSv8aZQusNq0RcQDF4vkg3Gog2VANm3TwvGV
         GyuIKN2myvPYo4DhWmcbyMCW+AFOqPvlEkm7Q2l/NhGu9F++hPVt0Dc/FRjTpATvN8
         8/BTz4zcChIgsMFTNZrd2As2V/HO/3RRDdZA+KkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Alan Liu <HaoPing.Liu@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/208] drm/amd/display: Fix timing not changning when freesync video is enabled
Date:   Tue,  7 Feb 2023 13:56:03 +0100
Message-Id: <20230207125639.301488550@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 85bd1f18259c..b425ec00817c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8784,6 +8784,13 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
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



