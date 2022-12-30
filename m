Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB8F657C89
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbiL1Pdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiL1Pdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:33:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E8F15FF3
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:33:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB74B81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7478EC433D2;
        Wed, 28 Dec 2022 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241607;
        bh=DXdQWeoysPaw/9wUZQGmlRUuc4w33EF4zPla2J5b2gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmCcGt5fIlDCQEkz0z6dmK36KcYNQyRN9z5IOkV/ZqhEF2jNNLAjELAG9oiMJLYUJ
         kReuhljF2yDKvrbbvxwIry8dZ9j+HdnZajyyBPAfEQklys7bn9qulrFER/Pztag4wG
         KuKGUMhWrqiZxHogUPCLiJS3VAsSeyu/wLwUsd5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0272/1073] drm/msm/dsi: use drm_dsc_config instead of msm_display_dsc_config
Date:   Wed, 28 Dec 2022 15:31:00 +0100
Message-Id: <20221228144335.405061219@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 4b2b1b3674f80ed786e73d8e24c19e7129257ad8 ]

There is no need to use the struct msm_display_dsc_config wrapper inside
the dsi driver, use the struct drm_dsc_config directly to pass pps data.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/493341/
Link: https://lore.kernel.org/r/20220711100432.455268-3-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: 01a907980e0b ("drm/msm/dsi: Remove useless math in DSC calculations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c |   2 +-
 drivers/gpu/drm/msm/dsi/dsi.c           |   2 +-
 drivers/gpu/drm/msm/dsi/dsi.h           |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c      | 157 +++++++++++-------------
 drivers/gpu/drm/msm/msm_drv.h           |   9 +-
 5 files changed, 79 insertions(+), 93 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index af5e027eb86f..c99c7a218ddb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -582,7 +582,7 @@ static int _dpu_kms_initialize_dsi(struct drm_device *dev,
 		info.h_tile_instance[info.num_of_h_tiles++] = i;
 		info.is_cmd_mode = msm_dsi_is_cmd_mode(priv->dsi[i]);
 
-		info.dsc = msm_dsi_get_dsc_config(priv->dsi[i])->drm;
+		info.dsc = msm_dsi_get_dsc_config(priv->dsi[i]);
 
 		if (msm_dsi_is_bonded_dsi(priv->dsi[i]) && priv->dsi[other]) {
 			rc = msm_dsi_modeset_init(priv->dsi[other], dev, encoder);
diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index 3db85b5c0feb..31e452ede71f 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -21,7 +21,7 @@ bool msm_dsi_is_cmd_mode(struct msm_dsi *msm_dsi)
 	return !(host_flags & MIPI_DSI_MODE_VIDEO);
 }
 
-struct msm_display_dsc_config *msm_dsi_get_dsc_config(struct msm_dsi *msm_dsi)
+struct drm_dsc_config *msm_dsi_get_dsc_config(struct msm_dsi *msm_dsi)
 {
 	return msm_dsi_host_get_dsc_config(msm_dsi->host);
 }
diff --git a/drivers/gpu/drm/msm/dsi/dsi.h b/drivers/gpu/drm/msm/dsi/dsi.h
index 580a1e6358bf..df46cdda1b43 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.h
+++ b/drivers/gpu/drm/msm/dsi/dsi.h
@@ -154,7 +154,7 @@ int dsi_calc_clk_rate_v2(struct msm_dsi_host *msm_host, bool is_bonded_dsi);
 int dsi_calc_clk_rate_6g(struct msm_dsi_host *msm_host, bool is_bonded_dsi);
 void msm_dsi_host_snapshot(struct msm_disp_state *disp_state, struct mipi_dsi_host *host);
 void msm_dsi_host_test_pattern_en(struct mipi_dsi_host *host);
-struct msm_display_dsc_config *msm_dsi_host_get_dsc_config(struct mipi_dsi_host *host);
+struct drm_dsc_config *msm_dsi_host_get_dsc_config(struct mipi_dsi_host *host);
 
 /* dsi phy */
 struct msm_dsi_phy;
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index a34078497af1..15e108be1901 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -33,7 +33,7 @@
 
 #define DSI_RESET_TOGGLE_DELAY_MS 20
 
-static int dsi_populate_dsc_params(struct msm_display_dsc_config *dsc);
+static int dsi_populate_dsc_params(struct drm_dsc_config *dsc);
 
 static int dsi_get_version(const void __iomem *base, u32 *major, u32 *minor)
 {
@@ -161,7 +161,7 @@ struct msm_dsi_host {
 	struct regmap *sfpb;
 
 	struct drm_display_mode *mode;
-	struct msm_display_dsc_config *dsc;
+	struct drm_dsc_config *dsc;
 
 	/* connected device info */
 	struct device_node *device_node;
@@ -916,7 +916,7 @@ static void dsi_ctrl_config(struct msm_dsi_host *msm_host, bool enable,
 
 static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mode, u32 hdisplay)
 {
-	struct msm_display_dsc_config *dsc = msm_host->dsc;
+	struct drm_dsc_config *dsc = msm_host->dsc;
 	u32 reg, intf_width, reg_ctrl, reg_ctrl2;
 	u32 slice_per_intf, total_bytes_per_intf;
 	u32 pkt_per_line;
@@ -927,24 +927,24 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 	 * compress mode registers
 	 */
 	intf_width = hdisplay;
-	slice_per_intf = DIV_ROUND_UP(intf_width, dsc->drm->slice_width);
+	slice_per_intf = DIV_ROUND_UP(intf_width, dsc->slice_width);
 
 	/* If slice_per_pkt is greater than slice_per_intf
 	 * then default to 1. This can happen during partial
 	 * update.
 	 */
-	if (slice_per_intf > dsc->drm->slice_count)
-		dsc->drm->slice_count = 1;
+	if (slice_per_intf > dsc->slice_count)
+		dsc->slice_count = 1;
 
-	slice_per_intf = DIV_ROUND_UP(hdisplay, dsc->drm->slice_width);
-	bytes_in_slice = DIV_ROUND_UP(dsc->drm->slice_width * dsc->drm->bits_per_pixel, 8);
+	slice_per_intf = DIV_ROUND_UP(hdisplay, dsc->slice_width);
+	bytes_in_slice = DIV_ROUND_UP(dsc->slice_width * dsc->bits_per_pixel, 8);
 
-	dsc->drm->slice_chunk_size = bytes_in_slice;
+	dsc->slice_chunk_size = bytes_in_slice;
 
 	total_bytes_per_intf = bytes_in_slice * slice_per_intf;
 
 	eol_byte_num = total_bytes_per_intf % 3;
-	pkt_per_line = slice_per_intf / dsc->drm->slice_count;
+	pkt_per_line = slice_per_intf / dsc->slice_count;
 
 	if (is_cmd_mode) /* packet data type */
 		reg = DSI_COMMAND_COMPRESSION_MODE_CTRL_STREAM0_DATATYPE(MIPI_DSI_DCS_LONG_WRITE);
@@ -1009,7 +1009,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 	}
 
 	if (msm_host->dsc) {
-		struct msm_display_dsc_config *dsc = msm_host->dsc;
+		struct drm_dsc_config *dsc = msm_host->dsc;
 
 		/* update dsc params with timing params */
 		if (!dsc || !mode->hdisplay || !mode->vdisplay) {
@@ -1018,9 +1018,9 @@ static void dsi_timing_setup(struct msm_dsi_host *msm_host, bool is_bonded_dsi)
 			return;
 		}
 
-		dsc->drm->pic_width = mode->hdisplay;
-		dsc->drm->pic_height = mode->vdisplay;
-		DBG("Mode %dx%d\n", dsc->drm->pic_width, dsc->drm->pic_height);
+		dsc->pic_width = mode->hdisplay;
+		dsc->pic_height = mode->vdisplay;
+		DBG("Mode %dx%d\n", dsc->pic_width, dsc->pic_height);
 
 		/* we do the calculations for dsc parameters here so that
 		 * panel can use these parameters
@@ -1841,7 +1841,7 @@ static char bpg_offset[DSC_NUM_BUF_RANGES] = {
 	2, 0, 0, -2, -4, -6, -8, -8, -8, -10, -10, -12, -12, -12, -12
 };
 
-static int dsi_populate_dsc_params(struct msm_display_dsc_config *dsc)
+static int dsi_populate_dsc_params(struct drm_dsc_config *dsc)
 {
 	int mux_words_size;
 	int groups_per_line, groups_total;
@@ -1854,98 +1854,98 @@ static int dsi_populate_dsc_params(struct msm_display_dsc_config *dsc)
 	int final_value, final_scale;
 	int i;
 
-	dsc->drm->rc_model_size = 8192;
-	dsc->drm->first_line_bpg_offset = 12;
-	dsc->drm->rc_edge_factor = 6;
-	dsc->drm->rc_tgt_offset_high = 3;
-	dsc->drm->rc_tgt_offset_low = 3;
-	dsc->drm->simple_422 = 0;
-	dsc->drm->convert_rgb = 1;
-	dsc->drm->vbr_enable = 0;
+	dsc->rc_model_size = 8192;
+	dsc->first_line_bpg_offset = 12;
+	dsc->rc_edge_factor = 6;
+	dsc->rc_tgt_offset_high = 3;
+	dsc->rc_tgt_offset_low = 3;
+	dsc->simple_422 = 0;
+	dsc->convert_rgb = 1;
+	dsc->vbr_enable = 0;
 
 	/* handle only bpp = bpc = 8 */
 	for (i = 0; i < DSC_NUM_BUF_RANGES - 1 ; i++)
-		dsc->drm->rc_buf_thresh[i] = dsi_dsc_rc_buf_thresh[i];
+		dsc->rc_buf_thresh[i] = dsi_dsc_rc_buf_thresh[i];
 
 	for (i = 0; i < DSC_NUM_BUF_RANGES; i++) {
-		dsc->drm->rc_range_params[i].range_min_qp = min_qp[i];
-		dsc->drm->rc_range_params[i].range_max_qp = max_qp[i];
-		dsc->drm->rc_range_params[i].range_bpg_offset = bpg_offset[i];
+		dsc->rc_range_params[i].range_min_qp = min_qp[i];
+		dsc->rc_range_params[i].range_max_qp = max_qp[i];
+		dsc->rc_range_params[i].range_bpg_offset = bpg_offset[i];
 	}
 
-	dsc->drm->initial_offset = 6144; /* Not bpp 12 */
-	if (dsc->drm->bits_per_pixel != 8)
-		dsc->drm->initial_offset = 2048;	/* bpp = 12 */
+	dsc->initial_offset = 6144; /* Not bpp 12 */
+	if (dsc->bits_per_pixel != 8)
+		dsc->initial_offset = 2048;	/* bpp = 12 */
 
 	mux_words_size = 48;		/* bpc == 8/10 */
-	if (dsc->drm->bits_per_component == 12)
+	if (dsc->bits_per_component == 12)
 		mux_words_size = 64;
 
-	dsc->drm->initial_xmit_delay = 512;
-	dsc->drm->initial_scale_value = 32;
-	dsc->drm->first_line_bpg_offset = 12;
-	dsc->drm->line_buf_depth = dsc->drm->bits_per_component + 1;
+	dsc->initial_xmit_delay = 512;
+	dsc->initial_scale_value = 32;
+	dsc->first_line_bpg_offset = 12;
+	dsc->line_buf_depth = dsc->bits_per_component + 1;
 
 	/* bpc 8 */
-	dsc->drm->flatness_min_qp = 3;
-	dsc->drm->flatness_max_qp = 12;
-	dsc->drm->rc_quant_incr_limit0 = 11;
-	dsc->drm->rc_quant_incr_limit1 = 11;
-	dsc->drm->mux_word_size = DSC_MUX_WORD_SIZE_8_10_BPC;
+	dsc->flatness_min_qp = 3;
+	dsc->flatness_max_qp = 12;
+	dsc->rc_quant_incr_limit0 = 11;
+	dsc->rc_quant_incr_limit1 = 11;
+	dsc->mux_word_size = DSC_MUX_WORD_SIZE_8_10_BPC;
 
 	/* FIXME: need to call drm_dsc_compute_rc_parameters() so that rest of
 	 * params are calculated
 	 */
-	groups_per_line = DIV_ROUND_UP(dsc->drm->slice_width, 3);
-	dsc->drm->slice_chunk_size = dsc->drm->slice_width * dsc->drm->bits_per_pixel / 8;
-	if ((dsc->drm->slice_width * dsc->drm->bits_per_pixel) % 8)
-		dsc->drm->slice_chunk_size++;
+	groups_per_line = DIV_ROUND_UP(dsc->slice_width, 3);
+	dsc->slice_chunk_size = dsc->slice_width * dsc->bits_per_pixel / 8;
+	if ((dsc->slice_width * dsc->bits_per_pixel) % 8)
+		dsc->slice_chunk_size++;
 
 	/* rbs-min */
-	min_rate_buffer_size =  dsc->drm->rc_model_size - dsc->drm->initial_offset +
-				dsc->drm->initial_xmit_delay * dsc->drm->bits_per_pixel +
-				groups_per_line * dsc->drm->first_line_bpg_offset;
+	min_rate_buffer_size =  dsc->rc_model_size - dsc->initial_offset +
+				dsc->initial_xmit_delay * dsc->bits_per_pixel +
+				groups_per_line * dsc->first_line_bpg_offset;
 
-	hrd_delay = DIV_ROUND_UP(min_rate_buffer_size, dsc->drm->bits_per_pixel);
+	hrd_delay = DIV_ROUND_UP(min_rate_buffer_size, dsc->bits_per_pixel);
 
-	dsc->drm->initial_dec_delay = hrd_delay - dsc->drm->initial_xmit_delay;
+	dsc->initial_dec_delay = hrd_delay - dsc->initial_xmit_delay;
 
-	dsc->drm->initial_scale_value = 8 * dsc->drm->rc_model_size /
-				       (dsc->drm->rc_model_size - dsc->drm->initial_offset);
+	dsc->initial_scale_value = 8 * dsc->rc_model_size /
+				       (dsc->rc_model_size - dsc->initial_offset);
 
-	slice_bits = 8 * dsc->drm->slice_chunk_size * dsc->drm->slice_height;
+	slice_bits = 8 * dsc->slice_chunk_size * dsc->slice_height;
 
-	groups_total = groups_per_line * dsc->drm->slice_height;
+	groups_total = groups_per_line * dsc->slice_height;
 
-	data = dsc->drm->first_line_bpg_offset * 2048;
+	data = dsc->first_line_bpg_offset * 2048;
 
-	dsc->drm->nfl_bpg_offset = DIV_ROUND_UP(data, (dsc->drm->slice_height - 1));
+	dsc->nfl_bpg_offset = DIV_ROUND_UP(data, (dsc->slice_height - 1));
 
-	pre_num_extra_mux_bits = 3 * (mux_words_size + (4 * dsc->drm->bits_per_component + 4) - 2);
+	pre_num_extra_mux_bits = 3 * (mux_words_size + (4 * dsc->bits_per_component + 4) - 2);
 
 	num_extra_mux_bits = pre_num_extra_mux_bits - (mux_words_size -
 			     ((slice_bits - pre_num_extra_mux_bits) % mux_words_size));
 
-	data = 2048 * (dsc->drm->rc_model_size - dsc->drm->initial_offset + num_extra_mux_bits);
-	dsc->drm->slice_bpg_offset = DIV_ROUND_UP(data, groups_total);
+	data = 2048 * (dsc->rc_model_size - dsc->initial_offset + num_extra_mux_bits);
+	dsc->slice_bpg_offset = DIV_ROUND_UP(data, groups_total);
 
 	/* bpp * 16 + 0.5 */
-	data = dsc->drm->bits_per_pixel * 16;
+	data = dsc->bits_per_pixel * 16;
 	data *= 2;
 	data++;
 	data /= 2;
 	target_bpp_x16 = data;
 
-	data = (dsc->drm->initial_xmit_delay * target_bpp_x16) / 16;
-	final_value =  dsc->drm->rc_model_size - data + num_extra_mux_bits;
-	dsc->drm->final_offset = final_value;
+	data = (dsc->initial_xmit_delay * target_bpp_x16) / 16;
+	final_value =  dsc->rc_model_size - data + num_extra_mux_bits;
+	dsc->final_offset = final_value;
 
-	final_scale = 8 * dsc->drm->rc_model_size / (dsc->drm->rc_model_size - final_value);
+	final_scale = 8 * dsc->rc_model_size / (dsc->rc_model_size - final_value);
 
-	data = (final_scale - 9) * (dsc->drm->nfl_bpg_offset + dsc->drm->slice_bpg_offset);
-	dsc->drm->scale_increment_interval = (2048 * dsc->drm->final_offset) / data;
+	data = (final_scale - 9) * (dsc->nfl_bpg_offset + dsc->slice_bpg_offset);
+	dsc->scale_increment_interval = (2048 * dsc->final_offset) / data;
 
-	dsc->drm->scale_decrement_interval = groups_per_line / (dsc->drm->initial_scale_value - 8);
+	dsc->scale_decrement_interval = groups_per_line / (dsc->initial_scale_value - 8);
 
 	return 0;
 }
@@ -2165,17 +2165,8 @@ int msm_dsi_host_modeset_init(struct mipi_dsi_host *host,
 	msm_host->dev = dev;
 	panel = msm_dsi_host_get_panel(&msm_host->base);
 
-	if (!IS_ERR(panel) && panel->dsc) {
-		struct msm_display_dsc_config *dsc = msm_host->dsc;
-
-		if (!dsc) {
-			dsc = devm_kzalloc(&msm_host->pdev->dev, sizeof(*dsc), GFP_KERNEL);
-			if (!dsc)
-				return -ENOMEM;
-			dsc->drm = panel->dsc;
-			msm_host->dsc = dsc;
-		}
-	}
+	if (!IS_ERR(panel) && panel->dsc)
+		msm_host->dsc = panel->dsc;
 
 	ret = cfg_hnd->ops->tx_buf_alloc(msm_host, SZ_4K);
 	if (ret) {
@@ -2659,22 +2650,22 @@ enum drm_mode_status msm_dsi_host_check_dsc(struct mipi_dsi_host *host,
 					    const struct drm_display_mode *mode)
 {
 	struct msm_dsi_host *msm_host = to_msm_dsi_host(host);
-	struct msm_display_dsc_config *dsc = msm_host->dsc;
+	struct drm_dsc_config *dsc = msm_host->dsc;
 	int pic_width = mode->hdisplay;
 	int pic_height = mode->vdisplay;
 
 	if (!msm_host->dsc)
 		return MODE_OK;
 
-	if (pic_width % dsc->drm->slice_width) {
+	if (pic_width % dsc->slice_width) {
 		pr_err("DSI: pic_width %d has to be multiple of slice %d\n",
-		       pic_width, dsc->drm->slice_width);
+		       pic_width, dsc->slice_width);
 		return MODE_H_ILLEGAL;
 	}
 
-	if (pic_height % dsc->drm->slice_height) {
+	if (pic_height % dsc->slice_height) {
 		pr_err("DSI: pic_height %d has to be multiple of slice %d\n",
-		       pic_height, dsc->drm->slice_height);
+		       pic_height, dsc->slice_height);
 		return MODE_V_ILLEGAL;
 	}
 
@@ -2771,7 +2762,7 @@ void msm_dsi_host_test_pattern_en(struct mipi_dsi_host *host)
 				DSI_TEST_PATTERN_GEN_CMD_STREAM0_TRIGGER_SW_TRIGGER);
 }
 
-struct msm_display_dsc_config *msm_dsi_host_get_dsc_config(struct mipi_dsi_host *host)
+struct drm_dsc_config *msm_dsi_host_get_dsc_config(struct mipi_dsi_host *host)
 {
 	struct msm_dsi_host *msm_host = to_msm_dsi_host(host);
 
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 80da0d3cfdc1..03e5b6863319 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -96,11 +96,6 @@ struct msm_drm_thread {
 	struct kthread_worker *worker;
 };
 
-/* DSC config */
-struct msm_display_dsc_config {
-	struct drm_dsc_config *drm;
-};
-
 struct msm_drm_private {
 
 	struct drm_device *dev;
@@ -290,7 +285,7 @@ void msm_dsi_snapshot(struct msm_disp_state *disp_state, struct msm_dsi *msm_dsi
 bool msm_dsi_is_cmd_mode(struct msm_dsi *msm_dsi);
 bool msm_dsi_is_bonded_dsi(struct msm_dsi *msm_dsi);
 bool msm_dsi_is_master_dsi(struct msm_dsi *msm_dsi);
-struct msm_display_dsc_config *msm_dsi_get_dsc_config(struct msm_dsi *msm_dsi);
+struct drm_dsc_config *msm_dsi_get_dsc_config(struct msm_dsi *msm_dsi);
 #else
 static inline void __init msm_dsi_register(void)
 {
@@ -320,7 +315,7 @@ static inline bool msm_dsi_is_master_dsi(struct msm_dsi *msm_dsi)
 	return false;
 }
 
-static inline struct msm_display_dsc_config *msm_dsi_get_dsc_config(struct msm_dsi *msm_dsi)
+static inline struct drm_dsc_config *msm_dsi_get_dsc_config(struct msm_dsi *msm_dsi)
 {
 	return NULL;
 }
-- 
2.35.1



