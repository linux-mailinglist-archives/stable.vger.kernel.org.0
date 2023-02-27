Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491C46A36E4
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjB0CF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjB0CFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:05:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA44199D9;
        Sun, 26 Feb 2023 18:04:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F8E460D14;
        Mon, 27 Feb 2023 02:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E20EC433EF;
        Mon, 27 Feb 2023 02:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463489;
        bh=FH7W+agOE0A/uArAr5xI5FYIYFmaGbWjLz+pByNEFJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jw2JpwwCLhtvlYuEkI+VvXcRpcdqRjF1RONNQU+s0Wl+cHkmlceTpj86IB1IMIuyk
         t37XqQKCY1UeVBtBjE3tjeIbDV+3y0wFhfniBZLZ1PlXDM3Yr+kdg57sOPXTbnl+hH
         twL3XBue9/hTy+bAhZRwRkRupQ9hP5hAL9eo2ShkHrFijPChZ4dNK3sSpA0KzOCn4f
         J9x3z0JfOELyUJs2qr4ML06Id0+r1jogB7skEQjUtIRZx9DVTO8EPmaQu1lMESfpl8
         YYUze11wOkoOuX9QQlwa/bpEybId4jl7B3QHlUDqBmgL1VLaPrrJLCT6j440SaO33C
         0YjhHEeJo6pYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, roman.li@amd.com,
        hersenxs.wu@amd.com, stylon.wang@amd.com, aric.cyr@amd.com,
        Jun.Lei@amd.com, Alvin.Lee2@amd.com, wenjing.liu@amd.com,
        mwen@igalia.com, Jimmy.Kizito@amd.com, alex.hung@amd.com,
        Nevenko.Stupar@amd.com, Dillon.Varone@amd.com, George.Shen@amd.com,
        rdunlap@infradead.org, David.Galiffi@amd.com,
        Hawking.Zhang@amd.com, evan.quan@amd.com, dingchen.zhang@amd.com,
        Stanley.Yang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 54/60] drm/amd/display: disable SubVP + DRR to prevent underflow
Date:   Sun, 26 Feb 2023 21:00:39 -0500
Message-Id: <20230227020045.1045105-54-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 80c6d6804f31451848a3956a70c2bcb1f07cfcb0 ]

[Why&How]
Temporarily disable SubVP+DRR since Xorg has an architectural limitation
where freesync will not work in a multi monitor configuration. SubVP+DRR
requires that freesync be working.

Whether OS has variable refresh setting enabled or not, the state on
the crtc remains same unless an application requests VRR. Due to this,
there is no way to know whether freesync will actually work or not
while we are on the desktop from the kernel's perspective.

If userspace does not have a limitation with multi-display freesync (for
example wayland), then this feature can be enabled by adding a
dcfeaturemask option to amdgpu on the kernel cmdline like:

amdgpu.dcfeaturemask=0x200

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    | 5 +++++
 drivers/gpu/drm/amd/display/dc/dc.h                  | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 4 ++++
 drivers/gpu/drm/amd/include/amd_shared.h             | 1 +
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 07fe82715cdcb..ac66cb56be9bd 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1551,6 +1551,11 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	if (amdgpu_dc_feature_mask & DC_DISABLE_LTTPR_DP2_0)
 		init_data.flags.allow_lttpr_non_transparent_mode.bits.DP2_0 = true;
 
+	/* Disable SubVP + DRR config by default */
+	init_data.flags.disable_subvp_drr = true;
+	if (amdgpu_dc_feature_mask & DC_ENABLE_SUBVP_DRR)
+		init_data.flags.disable_subvp_drr = false;
+
 	init_data.flags.seamless_boot_edp_requested = false;
 
 	if (check_seamless_boot_capability(adev)) {
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 85ebeaa2de186..37998dc0fc144 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -410,7 +410,7 @@ struct dc_config {
 	bool force_bios_enable_lttpr;
 	uint8_t force_bios_fixed_vs;
 	int sdpif_request_limit_words_per_umc;
-
+	bool disable_subvp_drr;
 };
 
 enum visual_confirm {
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 8450f59c26186..69e205ac58b25 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -877,6 +877,10 @@ static bool subvp_drr_schedulable(struct dc *dc, struct dc_state *context, struc
 	int16_t stretched_drr_us = 0;
 	int16_t drr_stretched_vblank_us = 0;
 	int16_t max_vblank_mallregion = 0;
+	const struct dc_config *config = &dc->config;
+
+	if (config->disable_subvp_drr)
+		return false;
 
 	// Find SubVP pipe
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/amd/include/amd_shared.h
index f175e65b853a0..e4a22c68517d1 100644
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -240,6 +240,7 @@ enum DC_FEATURE_MASK {
 	DC_DISABLE_LTTPR_DP2_0 = (1 << 6), //0x40, disabled by default
 	DC_PSR_ALLOW_SMU_OPT = (1 << 7), //0x80, disabled by default
 	DC_PSR_ALLOW_MULTI_DISP_OPT = (1 << 8), //0x100, disabled by default
+	DC_ENABLE_SUBVP_DRR = (1 << 9), // 0x200, disabled by default
 };
 
 enum DC_DEBUG_MASK {
-- 
2.39.0

