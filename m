Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA41491600
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbiARCc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344669AbiARCah (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:30:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16BEC0611DB;
        Mon, 17 Jan 2022 18:27:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43B7F6093C;
        Tue, 18 Jan 2022 02:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCD3C36AEF;
        Tue, 18 Jan 2022 02:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472824;
        bh=aug2AgPul4+1rtGBkdjgMe/sxvl/qaJGkkDEMxcKFcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNVyZxIRghyA7lgMpyAsAUR8BnJQ04/W15fd9PCqMoxNkbge7JhzL0EDQzUEphF5I
         s10BgNLRyGzQk4Ho60PopqkvuLvNu/rmdcLUZDHuLEMWoRCrL98zYOn/JvGdzF+WO9
         Df4w2vHgs8IqzPWt/fLh19T0cAjIe9DhY+kASg+eQ76FEmdJqYeF4ut3mWyg8dz7PS
         ZAgLhNJl5Ifg7LyRTMgPGx01ao42y5VN1/NrXcL0SVkDS3GJbVM0zbWXuX3zdHEGnu
         uGPxZyW0ezZGjaXifueqgkOSw248o5QKT6yqlMbKEyD2THXjlD65um9ucNpVLarodc
         AF35kKrgnVLNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Maxim Schwalm <maxim.schwalm@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, thierry.reding@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, jonathanh@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 144/217] drm/tegra: dc: rgb: Allow changing PLLD rate on Tegra30+
Date:   Mon, 17 Jan 2022 21:18:27 -0500
Message-Id: <20220118021940.1942199-144-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 0c921b6d4ba06bc899fd84d3ce1c1afd3d00bc1c ]

Asus Transformer TF700T is a Tegra30 tablet device which uses RGB->DSI
bridge that requires a precise clock rate in order to operate properly.
Tegra30 has a dedicated PLL for each display controller, hence the PLL
rate can be changed freely. Allow PLL rate changes on Tegra30+ for RGB
output. Configure the clock rate before display controller is enabled
since DC itself may be running off this PLL and it's not okay to change
the rate of the active PLL that doesn't support dynamic frequency
switching since hardware will hang.

Tested-by: Maxim Schwalm <maxim.schwalm@gmail.com> #TF700T
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c  | 27 ++++++++++++--------
 drivers/gpu/drm/tegra/dc.h  |  1 +
 drivers/gpu/drm/tegra/rgb.c | 49 +++++++++++++++++++++++++++++++++++--
 3 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index a29d64f875635..cc379555243c4 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -1762,10 +1762,9 @@ int tegra_dc_state_setup_clock(struct tegra_dc *dc,
 	return 0;
 }
 
-static void tegra_dc_commit_state(struct tegra_dc *dc,
-				  struct tegra_dc_state *state)
+static void tegra_dc_set_clock_rate(struct tegra_dc *dc,
+				    struct tegra_dc_state *state)
 {
-	u32 value;
 	int err;
 
 	err = clk_set_parent(dc->clk, state->clk);
@@ -1796,11 +1795,6 @@ static void tegra_dc_commit_state(struct tegra_dc *dc,
 	DRM_DEBUG_KMS("rate: %lu, div: %u\n", clk_get_rate(dc->clk),
 		      state->div);
 	DRM_DEBUG_KMS("pclk: %lu\n", state->pclk);
-
-	if (!dc->soc->has_nvdisplay) {
-		value = SHIFT_CLK_DIVIDER(state->div) | PIXEL_CLK_DIVIDER_PCD1;
-		tegra_dc_writel(dc, value, DC_DISP_DISP_CLOCK_CONTROL);
-	}
 }
 
 static void tegra_dc_stop(struct tegra_dc *dc)
@@ -2002,6 +1996,9 @@ static void tegra_crtc_atomic_enable(struct drm_crtc *crtc,
 	u32 value;
 	int err;
 
+	/* apply PLL changes */
+	tegra_dc_set_clock_rate(dc, crtc_state);
+
 	err = host1x_client_resume(&dc->client);
 	if (err < 0) {
 		dev_err(dc->dev, "failed to resume: %d\n", err);
@@ -2076,8 +2073,11 @@ static void tegra_crtc_atomic_enable(struct drm_crtc *crtc,
 	else
 		tegra_dc_writel(dc, 0, DC_DISP_BORDER_COLOR);
 
-	/* apply PLL and pixel clock changes */
-	tegra_dc_commit_state(dc, crtc_state);
+	/* apply pixel clock changes */
+	if (!dc->soc->has_nvdisplay) {
+		value = SHIFT_CLK_DIVIDER(crtc_state->div) | PIXEL_CLK_DIVIDER_PCD1;
+		tegra_dc_writel(dc, value, DC_DISP_DISP_CLOCK_CONTROL);
+	}
 
 	/* program display mode */
 	tegra_dc_set_timings(dc, mode);
@@ -2685,6 +2685,7 @@ static const struct tegra_dc_soc_info tegra20_dc_soc_info = {
 	.has_win_b_vfilter_mem_client = true,
 	.has_win_c_without_vert_filter = true,
 	.plane_tiled_memory_bandwidth_x2 = false,
+	.has_pll_d2_out0 = false,
 };
 
 static const struct tegra_dc_soc_info tegra30_dc_soc_info = {
@@ -2707,6 +2708,7 @@ static const struct tegra_dc_soc_info tegra30_dc_soc_info = {
 	.has_win_b_vfilter_mem_client = true,
 	.has_win_c_without_vert_filter = false,
 	.plane_tiled_memory_bandwidth_x2 = true,
+	.has_pll_d2_out0 = true,
 };
 
 static const struct tegra_dc_soc_info tegra114_dc_soc_info = {
@@ -2729,6 +2731,7 @@ static const struct tegra_dc_soc_info tegra114_dc_soc_info = {
 	.has_win_b_vfilter_mem_client = false,
 	.has_win_c_without_vert_filter = false,
 	.plane_tiled_memory_bandwidth_x2 = true,
+	.has_pll_d2_out0 = true,
 };
 
 static const struct tegra_dc_soc_info tegra124_dc_soc_info = {
@@ -2751,6 +2754,7 @@ static const struct tegra_dc_soc_info tegra124_dc_soc_info = {
 	.has_win_b_vfilter_mem_client = false,
 	.has_win_c_without_vert_filter = false,
 	.plane_tiled_memory_bandwidth_x2 = false,
+	.has_pll_d2_out0 = true,
 };
 
 static const struct tegra_dc_soc_info tegra210_dc_soc_info = {
@@ -2773,6 +2777,7 @@ static const struct tegra_dc_soc_info tegra210_dc_soc_info = {
 	.has_win_b_vfilter_mem_client = false,
 	.has_win_c_without_vert_filter = false,
 	.plane_tiled_memory_bandwidth_x2 = false,
+	.has_pll_d2_out0 = true,
 };
 
 static const struct tegra_windowgroup_soc tegra186_dc_wgrps[] = {
@@ -2823,6 +2828,7 @@ static const struct tegra_dc_soc_info tegra186_dc_soc_info = {
 	.wgrps = tegra186_dc_wgrps,
 	.num_wgrps = ARRAY_SIZE(tegra186_dc_wgrps),
 	.plane_tiled_memory_bandwidth_x2 = false,
+	.has_pll_d2_out0 = false,
 };
 
 static const struct tegra_windowgroup_soc tegra194_dc_wgrps[] = {
@@ -2873,6 +2879,7 @@ static const struct tegra_dc_soc_info tegra194_dc_soc_info = {
 	.wgrps = tegra194_dc_wgrps,
 	.num_wgrps = ARRAY_SIZE(tegra194_dc_wgrps),
 	.plane_tiled_memory_bandwidth_x2 = false,
+	.has_pll_d2_out0 = false,
 };
 
 static const struct of_device_id tegra_dc_of_match[] = {
diff --git a/drivers/gpu/drm/tegra/dc.h b/drivers/gpu/drm/tegra/dc.h
index 40378308d527a..c9c4c45c05183 100644
--- a/drivers/gpu/drm/tegra/dc.h
+++ b/drivers/gpu/drm/tegra/dc.h
@@ -76,6 +76,7 @@ struct tegra_dc_soc_info {
 	bool has_win_b_vfilter_mem_client;
 	bool has_win_c_without_vert_filter;
 	bool plane_tiled_memory_bandwidth_x2;
+	bool has_pll_d2_out0;
 };
 
 struct tegra_dc {
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
index 606c78a2b988f..a84aee2f4acd0 100644
--- a/drivers/gpu/drm/tegra/rgb.c
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -17,6 +17,8 @@ struct tegra_rgb {
 	struct tegra_output output;
 	struct tegra_dc *dc;
 
+	struct clk *pll_d_out0;
+	struct clk *pll_d2_out0;
 	struct clk *clk_parent;
 	struct clk *clk;
 };
@@ -123,6 +125,18 @@ static void tegra_rgb_encoder_enable(struct drm_encoder *encoder)
 	tegra_dc_commit(rgb->dc);
 }
 
+static bool tegra_rgb_pll_rate_change_allowed(struct tegra_rgb *rgb)
+{
+	if (!rgb->pll_d2_out0)
+		return false;
+
+	if (!clk_is_match(rgb->clk_parent, rgb->pll_d_out0) &&
+	    !clk_is_match(rgb->clk_parent, rgb->pll_d2_out0))
+		return false;
+
+	return true;
+}
+
 static int
 tegra_rgb_encoder_atomic_check(struct drm_encoder *encoder,
 			       struct drm_crtc_state *crtc_state,
@@ -151,8 +165,17 @@ tegra_rgb_encoder_atomic_check(struct drm_encoder *encoder,
 	 * and hope that the desired frequency can be matched (or at least
 	 * matched sufficiently close that the panel will still work).
 	 */
-	div = ((clk_get_rate(rgb->clk) * 2) / pclk) - 2;
-	pclk = 0;
+	if (tegra_rgb_pll_rate_change_allowed(rgb)) {
+		/*
+		 * Set display controller clock to x2 of PCLK in order to
+		 * produce higher resolution pulse positions.
+		 */
+		div = 2;
+		pclk *= 2;
+	} else {
+		div = ((clk_get_rate(rgb->clk) * 2) / pclk) - 2;
+		pclk = 0;
+	}
 
 	err = tegra_dc_state_setup_clock(dc, crtc_state, rgb->clk_parent,
 					 pclk, div);
@@ -210,6 +233,22 @@ int tegra_dc_rgb_probe(struct tegra_dc *dc)
 		return err;
 	}
 
+	rgb->pll_d_out0 = clk_get_sys(NULL, "pll_d_out0");
+	if (IS_ERR(rgb->pll_d_out0)) {
+		err = PTR_ERR(rgb->pll_d_out0);
+		dev_err(dc->dev, "failed to get pll_d_out0: %d\n", err);
+		return err;
+	}
+
+	if (dc->soc->has_pll_d2_out0) {
+		rgb->pll_d2_out0 = clk_get_sys(NULL, "pll_d2_out0");
+		if (IS_ERR(rgb->pll_d2_out0)) {
+			err = PTR_ERR(rgb->pll_d2_out0);
+			dev_err(dc->dev, "failed to get pll_d2_out0: %d\n", err);
+			return err;
+		}
+	}
+
 	dc->rgb = &rgb->output;
 
 	return 0;
@@ -217,9 +256,15 @@ int tegra_dc_rgb_probe(struct tegra_dc *dc)
 
 int tegra_dc_rgb_remove(struct tegra_dc *dc)
 {
+	struct tegra_rgb *rgb;
+
 	if (!dc->rgb)
 		return 0;
 
+	rgb = to_rgb(dc->rgb);
+	clk_put(rgb->pll_d2_out0);
+	clk_put(rgb->pll_d_out0);
+
 	tegra_output_remove(dc->rgb);
 	dc->rgb = NULL;
 
-- 
2.34.1

