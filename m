Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC45594758
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242510AbiHOXWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349988AbiHOXVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:21:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EA514AEF2;
        Mon, 15 Aug 2022 13:04:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2591B60693;
        Mon, 15 Aug 2022 20:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117DEC433C1;
        Mon, 15 Aug 2022 20:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593892;
        bh=bYjTcbptDzrg7/HEdTWPzKHGF7oKXRTTcTi+jj9lZZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yg8vZ+ox6IUY7ndwRZ+W9SFQwkrFcsfanSTXP+YTWvbwYTmjnq7AHDqkSWf6ZL5km
         VUyTDdpu4BLeMCM9NU7dNCOaaxrEojwEm6VyCnGeOey+M8oSK+fD1w6132QfZPfqob
         j7NPKr7Yuik43cj8dVdcAzQjMIS7cCofrO3bVsqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Martin <martin.leung@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0344/1157] drm/amdgpu/display: Prepare for new interfaces
Date:   Mon, 15 Aug 2022 19:55:00 +0200
Message-Id: <20220815180453.462354102@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leung, Martin <Martin.Leung@amd.com>

[ Upstream commit a820190204aef0739aa3a067d00273d117f9367c ]

why:
lut pipeline will be hooked up differently in some asics
need to add new interfaces

how:
add them

Reviewed-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Martin <martin.leung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 17 +++++-
 .../gpu/drm/amd/display/dc/core/dc_link_dp.c  | 52 +++++++++++--------
 drivers/gpu/drm/amd/display/dc/dc.h           |  1 +
 .../display/dc/dce110/dce110_hw_sequencer.c   | 23 ++++++--
 .../gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c | 13 +++--
 .../gpu/drm/amd/display/dc/dcn31/dcn31_dccg.h |  2 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h  |  4 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h   |  5 ++
 .../amd/display/dc/inc/hw_sequencer_private.h |  2 +
 10 files changed, 83 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 3087dd1a1856..d055d3c7eed6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1563,6 +1563,8 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		DRM_INFO("Seamless boot condition check passed\n");
 	}
 
+	init_data.flags.enable_mipi_converter_optimization = true;
+
 	INIT_LIST_HEAD(&adev->dm.da_list);
 
 	retrieve_dmi_info(&adev->dm);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index a789ea8af27f..55a8f58ee239 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -235,7 +235,8 @@ bool dc_link_detect_sink(struct dc_link *link, enum dc_connection_type *type)
 
 	if (link->connector_signal == SIGNAL_TYPE_EDP) {
 		/*in case it is not on*/
-		link->dc->hwss.edp_power_control(link, true);
+		if (!link->dc->config.edp_no_power_sequencing)
+			link->dc->hwss.edp_power_control(link, true);
 		link->dc->hwss.edp_wait_for_hpd_ready(link, true);
 	}
 
@@ -1016,6 +1017,7 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 	bool same_edid = false;
 	enum dc_edid_status edid_status;
 	struct dc_context *dc_ctx = link->ctx;
+	struct dc *dc = dc_ctx->dc;
 	struct dc_sink *sink = NULL;
 	struct dc_sink *prev_sink = NULL;
 	struct dpcd_caps prev_dpcd_caps;
@@ -1095,6 +1097,16 @@ static bool detect_link_and_local_sink(struct dc_link *link,
 
 			detect_edp_sink_caps(link);
 			read_current_link_settings_on_detect(link);
+
+			/* Disable power sequence on MIPI panel + converter
+			 */
+			if (dc->config.enable_mipi_converter_optimization &&
+				dc_ctx->dce_version == DCN_VERSION_3_01 &&
+				link->dpcd_caps.sink_dev_id == DP_BRANCH_DEVICE_ID_0022B9 &&
+				memcmp(&link->dpcd_caps.branch_dev_name, DP_SINK_BRANCH_DEV_NAME_7580,
+					sizeof(link->dpcd_caps.branch_dev_name)) == 0)
+				dc->config.edp_no_power_sequencing = true;
+
 			sink_caps.transaction_type = DDC_TRANSACTION_TYPE_I2C_OVER_AUX;
 			sink_caps.signal = SIGNAL_TYPE_EDP;
 			break;
@@ -1993,7 +2005,8 @@ static enum dc_status enable_link_dp(struct dc_state *state,
 
 	if (pipe_ctx->stream->signal == SIGNAL_TYPE_EDP) {
 		/*in case it is not on*/
-		link->dc->hwss.edp_power_control(link, true);
+		if (!link->dc->config.edp_no_power_sequencing)
+			link->dc->hwss.edp_power_control(link, true);
 		link->dc->hwss.edp_wait_for_hpd_ready(link, true);
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index d8eee89e63ce..a4fc9a6c850e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2074,7 +2074,8 @@ static enum link_training_result dp_perform_128b_132b_channel_eq_done_sequence(
 	uint32_t wait_time = 0;
 	union lane_align_status_updated dpcd_lane_status_updated = {0};
 	union lane_status dpcd_lane_status[LANE_COUNT_DP_MAX] = {0};
-	enum link_training_result status = LINK_TRAINING_SUCCESS;
+	enum dc_status status = DC_OK;
+	enum link_training_result result = LINK_TRAINING_SUCCESS;
 	union lane_adjust dpcd_lane_adjust[LANE_COUNT_DP_MAX] = {0};
 
 	/* Transmit 128b/132b_TPS1 over Main-Link */
@@ -2099,22 +2100,24 @@ static enum link_training_result dp_perform_128b_132b_channel_eq_done_sequence(
 			lt_settings->pattern_for_eq, DPRX);
 
 	/* poll for channel EQ done */
-	while (status == LINK_TRAINING_SUCCESS) {
+	while (result == LINK_TRAINING_SUCCESS) {
 		dp_wait_for_training_aux_rd_interval(link, aux_rd_interval);
 		wait_time += aux_rd_interval;
-		dp_get_lane_status_and_lane_adjust(link, lt_settings, dpcd_lane_status,
+		status = dp_get_lane_status_and_lane_adjust(link, lt_settings, dpcd_lane_status,
 				&dpcd_lane_status_updated, dpcd_lane_adjust, DPRX);
 		dp_decide_lane_settings(lt_settings, dpcd_lane_adjust,
 			lt_settings->hw_lane_settings, lt_settings->dpcd_lane_settings);
 		dpcd_128b_132b_get_aux_rd_interval(link, &aux_rd_interval);
-		if (dp_is_ch_eq_done(lt_settings->link_settings.lane_count,
+		if (status != DC_OK) {
+			result = LINK_TRAINING_ABORT;
+		} else if (dp_is_ch_eq_done(lt_settings->link_settings.lane_count,
 				dpcd_lane_status)) {
 			/* pass */
 			break;
 		} else if (loop_count >= lt_settings->eq_loop_count_limit) {
-			status = DP_128b_132b_MAX_LOOP_COUNT_REACHED;
+			result = DP_128b_132b_MAX_LOOP_COUNT_REACHED;
 		} else if (dpcd_lane_status_updated.bits.LT_FAILED_128b_132b) {
-			status = DP_128b_132b_LT_FAILED;
+			result = DP_128b_132b_LT_FAILED;
 		} else {
 			dp_set_hw_lane_settings(link, link_res, lt_settings, DPRX);
 			dpcd_set_lane_settings(link, lt_settings, DPRX);
@@ -2123,24 +2126,26 @@ static enum link_training_result dp_perform_128b_132b_channel_eq_done_sequence(
 	}
 
 	/* poll for EQ interlane align done */
-	while (status == LINK_TRAINING_SUCCESS) {
-		if (dpcd_lane_status_updated.bits.EQ_INTERLANE_ALIGN_DONE_128b_132b) {
+	while (result == LINK_TRAINING_SUCCESS) {
+		if (status != DC_OK) {
+			result = LINK_TRAINING_ABORT;
+		} else if (dpcd_lane_status_updated.bits.EQ_INTERLANE_ALIGN_DONE_128b_132b) {
 			/* pass */
 			break;
 		} else if (wait_time >= lt_settings->eq_wait_time_limit) {
-			status = DP_128b_132b_CHANNEL_EQ_DONE_TIMEOUT;
+			result = DP_128b_132b_CHANNEL_EQ_DONE_TIMEOUT;
 		} else if (dpcd_lane_status_updated.bits.LT_FAILED_128b_132b) {
-			status = DP_128b_132b_LT_FAILED;
+			result = DP_128b_132b_LT_FAILED;
 		} else {
 			dp_wait_for_training_aux_rd_interval(link,
 					lt_settings->eq_pattern_time);
 			wait_time += lt_settings->eq_pattern_time;
-			dp_get_lane_status_and_lane_adjust(link, lt_settings, dpcd_lane_status,
+			status = dp_get_lane_status_and_lane_adjust(link, lt_settings, dpcd_lane_status,
 					&dpcd_lane_status_updated, dpcd_lane_adjust, DPRX);
 		}
 	}
 
-	return status;
+	return result;
 }
 
 static enum link_training_result dp_perform_128b_132b_cds_done_sequence(
@@ -2149,7 +2154,8 @@ static enum link_training_result dp_perform_128b_132b_cds_done_sequence(
 		struct link_training_settings *lt_settings)
 {
 	/* Assumption: assume hardware has transmitted eq pattern */
-	enum link_training_result status = LINK_TRAINING_SUCCESS;
+	enum dc_status status = DC_OK;
+	enum link_training_result result = LINK_TRAINING_SUCCESS;
 	union lane_align_status_updated dpcd_lane_status_updated = {0};
 	union lane_status dpcd_lane_status[LANE_COUNT_DP_MAX] = {0};
 	union lane_adjust dpcd_lane_adjust[LANE_COUNT_DP_MAX] = { { {0} } };
@@ -2159,24 +2165,26 @@ static enum link_training_result dp_perform_128b_132b_cds_done_sequence(
 	dpcd_set_training_pattern(link, lt_settings->pattern_for_cds);
 
 	/* poll for CDS interlane align done and symbol lock */
-	while (status == LINK_TRAINING_SUCCESS) {
+	while (result  == LINK_TRAINING_SUCCESS) {
 		dp_wait_for_training_aux_rd_interval(link,
 				lt_settings->cds_pattern_time);
 		wait_time += lt_settings->cds_pattern_time;
-		dp_get_lane_status_and_lane_adjust(link, lt_settings, dpcd_lane_status,
+		status = dp_get_lane_status_and_lane_adjust(link, lt_settings, dpcd_lane_status,
 						&dpcd_lane_status_updated, dpcd_lane_adjust, DPRX);
-		if (dp_is_symbol_locked(lt_settings->link_settings.lane_count, dpcd_lane_status) &&
+		if (status != DC_OK) {
+			result = LINK_TRAINING_ABORT;
+		} else if (dp_is_symbol_locked(lt_settings->link_settings.lane_count, dpcd_lane_status) &&
 				dpcd_lane_status_updated.bits.CDS_INTERLANE_ALIGN_DONE_128b_132b) {
 			/* pass */
 			break;
 		} else if (dpcd_lane_status_updated.bits.LT_FAILED_128b_132b) {
-			status = DP_128b_132b_LT_FAILED;
+			result = DP_128b_132b_LT_FAILED;
 		} else if (wait_time >= lt_settings->cds_wait_time_limit) {
-			status = DP_128b_132b_CDS_DONE_TIMEOUT;
+			result = DP_128b_132b_CDS_DONE_TIMEOUT;
 		}
 	}
 
-	return status;
+	return result;
 }
 
 static enum link_training_result dp_perform_8b_10b_link_training(
@@ -7099,7 +7107,8 @@ void dp_enable_link_phy(
 	unsigned int i;
 
 	if (link->connector_signal == SIGNAL_TYPE_EDP) {
-		link->dc->hwss.edp_power_control(link, true);
+		if (!link->dc->config.edp_no_power_sequencing)
+			link->dc->hwss.edp_power_control(link, true);
 		link->dc->hwss.edp_wait_for_hpd_ready(link, true);
 	}
 
@@ -7226,7 +7235,8 @@ void dp_disable_link_phy(struct dc_link *link, const struct link_resource *link_
 			link->dc->hwss.edp_backlight_control(link, false);
 		if (link_hwss->ext.disable_dp_link_output)
 			link_hwss->ext.disable_dp_link_output(link, link_res, signal);
-		link->dc->hwss.edp_power_control(link, false);
+		if (!link->dc->config.edp_no_power_sequencing)
+			link->dc->hwss.edp_power_control(link, false);
 	} else {
 		if (dmcu != NULL && dmcu->funcs->lock_phy)
 			dmcu->funcs->lock_phy(dmcu);
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 817028d3c4a0..11b02a98cf0f 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -337,6 +337,7 @@ struct dc_config {
 	bool is_single_rank_dimm;
 	bool use_pipe_ctx_sync_logic;
 	bool ignore_dpref_ss;
+	bool enable_mipi_converter_optimization;
 };
 
 enum visual_confirm {
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 5f2afa5b4814..aee31c785aa9 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1245,8 +1245,18 @@ void dce110_blank_stream(struct pipe_ctx *pipe_ctx)
 			 * has changed or they enter protection state and hang.
 			 */
 			msleep(60);
-		} else if (pipe_ctx->stream->signal == SIGNAL_TYPE_EDP)
-			edp_receiver_ready_T9(link);
+		} else if (pipe_ctx->stream->signal == SIGNAL_TYPE_EDP) {
+			if (!link->dc->config.edp_no_power_sequencing) {
+				/*
+				 * Sometimes, DP receiver chip power-controlled externally by an
+				 * Embedded Controller could be treated and used as eDP,
+				 * if it drives mobile display. In this case,
+				 * we shouldn't be doing power-sequencing, hence we can skip
+				 * waiting for T9-ready.
+				 */
+				edp_receiver_ready_T9(link);
+			}
+		}
 	}
 
 }
@@ -2161,15 +2171,18 @@ static void dce110_setup_audio_dto(
 			build_audio_output(context, pipe_ctx, &audio_output);
 
 			if (dc->res_pool->dccg && dc->res_pool->dccg->funcs->set_audio_dtbclk_dto) {
-				/* disable audio DTBCLK DTO */
-				dc->res_pool->dccg->funcs->set_audio_dtbclk_dto(
-					dc->res_pool->dccg, 0);
+				struct dtbclk_dto_params dto_params = {0};
 
 				pipe_ctx->stream_res.audio->funcs->wall_dto_setup(
 						pipe_ctx->stream_res.audio,
 						pipe_ctx->stream->signal,
 						&audio_output.crtc_info,
 						&audio_output.pll_info);
+
+				dc->res_pool->dccg->funcs->set_audio_dtbclk_dto(
+					dc->res_pool->dccg,
+					&dto_params);
+
 			} else
 				pipe_ctx->stream_res.audio->funcs->wall_dto_setup(
 					pipe_ctx->stream_res.audio,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c
index bbc58d167c63..4519ecef2e7b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.c
@@ -513,7 +513,7 @@ void dccg31_set_physymclk(
 /* Controls the generation of pixel valid for OTG in (OTG -> HPO case) */
 static void dccg31_set_dtbclk_dto(
 		struct dccg *dccg,
-		struct dtbclk_dto_params *params)
+		const struct dtbclk_dto_params *params)
 {
 	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
 	int req_dtbclk_khz = params->pixclk_khz;
@@ -579,18 +579,17 @@ static void dccg31_set_dtbclk_dto(
 
 void dccg31_set_audio_dtbclk_dto(
 		struct dccg *dccg,
-		uint32_t req_audio_dtbclk_khz)
+		const struct dtbclk_dto_params *params)
 {
 	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
 
-	if (dccg->ref_dtbclk_khz && req_audio_dtbclk_khz) {
+	if (params->ref_dtbclk_khz && params->req_audio_dtbclk_khz) {
 		uint32_t modulo, phase;
 
 		// phase / modulo = dtbclk / dtbclk ref
-		modulo = dccg->ref_dtbclk_khz * 1000;
-		phase = div_u64((((unsigned long long)modulo * req_audio_dtbclk_khz) + dccg->ref_dtbclk_khz - 1),
-			dccg->ref_dtbclk_khz);
-
+		modulo = params->ref_dtbclk_khz * 1000;
+		phase = div_u64((((unsigned long long)modulo * params->req_audio_dtbclk_khz) + params->ref_dtbclk_khz - 1),
+			params->ref_dtbclk_khz);
 
 		REG_WRITE(DCCG_AUDIO_DTBCLK_DTO_MODULO, modulo);
 		REG_WRITE(DCCG_AUDIO_DTBCLK_DTO_PHASE, phase);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.h b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.h
index 269cabbea72a..f158c1ea214b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_dccg.h
@@ -192,7 +192,7 @@ void dccg31_set_physymclk(
 
 void dccg31_set_audio_dtbclk_dto(
 		struct dccg *dccg,
-		uint32_t req_audio_dtbclk_khz);
+		const struct dtbclk_dto_params *params);
 
 void dccg31_set_hdmistreamclk(
 		struct dccg *dccg,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h b/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h
index c7021915bac8..c1023cc84f55 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h
@@ -120,11 +120,11 @@ struct dccg_funcs {
 
 	void (*set_dtbclk_dto)(
 			struct dccg *dccg,
-			struct dtbclk_dto_params *dto_params);
+			const struct dtbclk_dto_params *params);
 
 	void (*set_audio_dtbclk_dto)(
 			struct dccg *dccg,
-			uint32_t req_audio_dtbclk_khz);
+			const struct dtbclk_dto_params *params);
 
 	void (*set_dispclk_change_mode)(
 			struct dccg *dccg,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h b/drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h
index f5fd2a067323..5097037e3962 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h
@@ -346,6 +346,11 @@ struct mpc_funcs {
 			int mpcc_id,
 			const struct mpc_grph_gamut_adjustment *adjust);
 
+	bool (*program_1dlut)(
+			struct mpc *mpc,
+			const struct pwl_params *params,
+			uint32_t rmu_idx);
+
 	bool (*program_shaper)(
 			struct mpc *mpc,
 			const struct pwl_params *params,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer_private.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer_private.h
index 8c2f190c4712..d2cb0e794500 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer_private.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer_private.h
@@ -140,6 +140,8 @@ struct hwseq_private_funcs {
 			const struct dc_plane_state *plane_state);
 	bool (*set_shaper_3dlut)(struct pipe_ctx *pipe_ctx,
 			const struct dc_plane_state *plane_state);
+	bool (*set_mcm_luts)(struct pipe_ctx *pipe_ctx,
+			const struct dc_plane_state *plane_state);
 	void (*PLAT_58856_wa)(struct dc_state *context,
 			struct pipe_ctx *pipe_ctx);
 	void (*setup_hpo_hw_control)(const struct dce_hwseq *hws, bool enable);
-- 
2.35.1



