Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917752E4235
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436929AbgL1OCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436926AbgL1OCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB4C20799;
        Mon, 28 Dec 2020 14:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164144;
        bh=DKwu98r1K7Z9QKiOI5WH4uYFgtW/cWIUVQjOIqVzCQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8Os9tqnkQimS/Z2WWEerK/u4fGb7T4Or4gJaTKSRAwYEcTvfrQSRfIxPfylijxyJ
         f0a/G8PXJnTXpCJwYwZyGHKH4FCTFoOKFLHtD25uVZebSIPs+gAH2Ls/F+wvOX1vyn
         ruw9UP7RWWape6UvvkLRzOMRqmHKx8cdmLVYBtZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanmay Shah <tanmay@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/717] drm/msm/dp: DisplayPort PHY compliance tests fixup
Date:   Mon, 28 Dec 2020 13:40:44 +0100
Message-Id: <20201228125023.195997830@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tanmay Shah <tanmay@codeaurora.org>

[ Upstream commit 6625e2637d93d2f52ef0d17656f21bfa2cb4983a ]

Bandwidth code was being used as test link rate. Fix this by converting
bandwidth code to test link rate

Do not reset voltage and pre-emphasis level during IRQ HPD attention
interrupt. Also fix pre-emphasis parsing during test link status process

Signed-off-by: Tanmay Shah <tanmay@codeaurora.org>
Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c    |  3 ---
 drivers/gpu/drm/msm/dp/dp_display.c |  1 +
 drivers/gpu/drm/msm/dp/dp_link.c    | 12 +++++++++++-
 drivers/gpu/drm/msm/dp/dp_link.h    |  1 +
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 2e3e1917351f0..872b12689e317 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1643,9 +1643,6 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	if (rc)
 		return rc;
 
-	ctrl->link->phy_params.p_level = 0;
-	ctrl->link->phy_params.v_level = 0;
-
 	while (--link_train_max_retries &&
 		!atomic_read(&ctrl->dp_ctrl.aborted)) {
 		rc = dp_ctrl_reinitialize_mainlink(ctrl);
diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index e175aa3fd3a93..ae9989ece73f4 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -335,6 +335,7 @@ static int dp_display_process_hpd_high(struct dp_display_private *dp)
 	dp->dp_display.max_pclk_khz = DP_MAX_PIXEL_CLK_KHZ;
 	dp->dp_display.max_dp_lanes = dp->parser->max_dp_lanes;
 
+	dp_link_reset_phy_params_vx_px(dp->link);
 	rc = dp_ctrl_on_link(dp->ctrl);
 	if (rc) {
 		DRM_ERROR("failed to complete DP link training\n");
diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index c811da515fb3b..49d7fad36fc4e 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -869,6 +869,9 @@ static int dp_link_parse_vx_px(struct dp_link_private *link)
 		drm_dp_get_adjust_request_voltage(link->link_status, 0);
 	link->dp_link.phy_params.p_level =
 		drm_dp_get_adjust_request_pre_emphasis(link->link_status, 0);
+
+	link->dp_link.phy_params.p_level >>= DP_TRAIN_PRE_EMPHASIS_SHIFT;
+
 	DRM_DEBUG_DP("Requested: v_level = 0x%x, p_level = 0x%x\n",
 			link->dp_link.phy_params.v_level,
 			link->dp_link.phy_params.p_level);
@@ -911,7 +914,8 @@ static int dp_link_process_phy_test_pattern_request(
 			link->request.test_lane_count);
 
 	link->dp_link.link_params.num_lanes = link->request.test_lane_count;
-	link->dp_link.link_params.rate = link->request.test_link_rate;
+	link->dp_link.link_params.rate =
+		drm_dp_bw_code_to_link_rate(link->request.test_link_rate);
 
 	ret = dp_link_parse_vx_px(link);
 
@@ -1156,6 +1160,12 @@ int dp_link_adjust_levels(struct dp_link *dp_link, u8 *link_status)
 	return 0;
 }
 
+void dp_link_reset_phy_params_vx_px(struct dp_link *dp_link)
+{
+	dp_link->phy_params.v_level = 0;
+	dp_link->phy_params.p_level = 0;
+}
+
 u32 dp_link_get_test_bits_depth(struct dp_link *dp_link, u32 bpp)
 {
 	u32 tbd;
diff --git a/drivers/gpu/drm/msm/dp/dp_link.h b/drivers/gpu/drm/msm/dp/dp_link.h
index 49811b6221e53..9dd4dd9265304 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.h
+++ b/drivers/gpu/drm/msm/dp/dp_link.h
@@ -135,6 +135,7 @@ static inline u32 dp_link_bit_depth_to_bpc(u32 tbd)
 	}
 }
 
+void dp_link_reset_phy_params_vx_px(struct dp_link *dp_link);
 u32 dp_link_get_test_bits_depth(struct dp_link *dp_link, u32 bpp);
 int dp_link_process_request(struct dp_link *dp_link);
 int dp_link_get_colorimetry_config(struct dp_link *dp_link);
-- 
2.27.0



