Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83236A37F1
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjB0CNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjB0CNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:13:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5AE1CF76;
        Sun, 26 Feb 2023 18:11:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1F6A60D32;
        Mon, 27 Feb 2023 02:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A776C433D2;
        Mon, 27 Feb 2023 02:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463453;
        bh=Yb8bvgTaHXrEzRgnWUDNwBSKzeSjbPXx9dISVcTbv1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CMhfsq+vh/XywIumkn+vLCC5ZUX7l6RCzcQikEWglk3y+yrI9eZWqyBZ9us+22iiW
         7+VLiVJb6lOIlS/OufqRD5Y5ipJH0FILofs3ZsBXvJ8rd6gH9fK1Q7QdaxVFsu25qk
         VA9Db/NLKvMjG/YMA3rTN2xXimNsiJIEghP8i05jXdLuO7wgFPvMNpKHJx/GlGnW9Q
         s+r4mOlC5de0wFQT3o8USZ8d+EpLHQ0DBbOIr8OW1YSvcr/8H8HTK9TGxIFVkp5rcJ
         LrK2TNonDHEwJi8UomFWiglHHvdskcoJPZoLPPJ6rLyNomhd/e+HGRp2xwdrpBLn1q
         xj2uIPBouKN5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Hansen Dsouza <hansen.dsouza@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, wenjing.liu@amd.com, wayne.lin@amd.com,
        Alvin.Lee2@amd.com, Syed.Hassan@amd.com, Daniel.Miess@amd.com,
        roman.li@amd.com, michael.strauss@amd.com, Martin.Leung@amd.com,
        Aurabindo.Pillai@amd.com, Charlene.Liu@amd.com, Eric.Yang2@amd.com,
        Anthony.Koo@amd.com, Aric.Cyr@amd.com, HaoPing.Liu@amd.com,
        dingchen.zhang@amd.com, mghaddar@amd.com, Max.Tseng@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 50/60] drm/amd/display: Move DCN314 DOMAIN power control to DMCUB
Date:   Sun, 26 Feb 2023 21:00:35 -0500
Message-Id: <20230227020045.1045105-50-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit e383b12709e32d6494c948422070c2464b637e44 ]

[Why]
DOMAIN power gating control is now required to be done via firmware
due to interlock with other power features. This is to avoid
intermittent issues in the LB memories.

[How]
If the firmware supports the command then use the new firmware as
the sequence can avoid potential display corruption issues.

The command will be ignored on firmware that does not support DOMAIN
power control and the pipes will remain always on - frequent PG cycling
can cause the issue to occur on the old sequence, so we should avoid it.

Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn314/dcn314_hwseq.c  | 24 ++++++++++++++++++
 .../drm/amd/display/dc/dcn314/dcn314_hwseq.h  |  2 ++
 .../drm/amd/display/dc/dcn314/dcn314_init.c   |  2 +-
 .../gpu/drm/amd/display/dmub/inc/dmub_cmd.h   | 25 +++++++++++++++++++
 4 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
index a0741794db62a..8e824dc81dede 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
@@ -391,3 +391,27 @@ void dcn314_set_pixels_per_cycle(struct pipe_ctx *pipe_ctx)
 		pipe_ctx->stream_res.stream_enc->funcs->set_input_mode(pipe_ctx->stream_res.stream_enc,
 				pix_per_cycle);
 }
+
+void dcn314_hubp_pg_control(struct dce_hwseq *hws, unsigned int hubp_inst, bool power_on)
+{
+	struct dc_context *ctx = hws->ctx;
+	union dmub_rb_cmd cmd;
+
+	if (hws->ctx->dc->debug.disable_hubp_power_gate)
+		return;
+
+	PERF_TRACE();
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.domain_control.header.type = DMUB_CMD__VBIOS;
+	cmd.domain_control.header.sub_type = DMUB_CMD__VBIOS_DOMAIN_CONTROL;
+	cmd.domain_control.header.payload_bytes = sizeof(cmd.domain_control.data);
+	cmd.domain_control.data.inst = hubp_inst;
+	cmd.domain_control.data.power_gate = !power_on;
+
+	dc_dmub_srv_cmd_queue(ctx->dmub_srv, &cmd);
+	dc_dmub_srv_cmd_execute(ctx->dmub_srv);
+	dc_dmub_srv_wait_idle(ctx->dmub_srv);
+
+	PERF_TRACE();
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
index 244280298212c..c419d3dbdfee6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
@@ -41,4 +41,6 @@ unsigned int dcn314_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsig
 
 void dcn314_set_pixels_per_cycle(struct pipe_ctx *pipe_ctx);
 
+void dcn314_hubp_pg_control(struct dce_hwseq *hws, unsigned int hubp_inst, bool power_on);
+
 #endif /* __DC_HWSS_DCN314_H__ */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
index 31feb4b0edee9..25f345ff6c8f0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
@@ -137,7 +137,7 @@ static const struct hwseq_private_funcs dcn314_private_funcs = {
 	.plane_atomic_disable = dcn20_plane_atomic_disable,
 	.plane_atomic_power_down = dcn10_plane_atomic_power_down,
 	.enable_power_gating_plane = dcn314_enable_power_gating_plane,
-	.hubp_pg_control = dcn31_hubp_pg_control,
+	.hubp_pg_control = dcn314_hubp_pg_control,
 	.program_all_writeback_pipes_in_tree = dcn30_program_all_writeback_pipes_in_tree,
 	.update_odm = dcn314_update_odm,
 	.dsc_pg_control = dcn314_dsc_pg_control,
diff --git a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
index 33907feefebbd..8fea8e42cc174 100644
--- a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
+++ b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
@@ -457,6 +457,10 @@ enum dmub_cmd_vbios_type {
 	 * Query DP alt status on a transmitter.
 	 */
 	DMUB_CMD__VBIOS_TRANSMITTER_QUERY_DP_ALT  = 26,
+	/**
+	 * Controls domain power gating
+	 */
+	DMUB_CMD__VBIOS_DOMAIN_CONTROL = 28,
 };
 
 //==============================================================================
@@ -1204,6 +1208,23 @@ struct dmub_rb_cmd_dig1_transmitter_control {
 	union dmub_cmd_dig1_transmitter_control_data transmitter_control; /**< payload */
 };
 
+/**
+ * struct dmub_rb_cmd_domain_control_data - Data for DOMAIN power control
+ */
+struct dmub_rb_cmd_domain_control_data {
+	uint8_t inst : 6; /**< DOMAIN instance to control */
+	uint8_t power_gate : 1; /**< 1=power gate, 0=power up */
+	uint8_t reserved[3]; /**< Reserved for future use */
+};
+
+/**
+ * struct dmub_rb_cmd_domain_control - Controls DOMAIN power gating
+ */
+struct dmub_rb_cmd_domain_control {
+	struct dmub_cmd_header header; /**< header */
+	struct dmub_rb_cmd_domain_control_data data; /**< payload */
+};
+
 /**
  * DPIA tunnel command parameters.
  */
@@ -3231,6 +3252,10 @@ union dmub_rb_cmd {
 	 * Definition of a DMUB_CMD__VBIOS_DIG1_TRANSMITTER_CONTROL command.
 	 */
 	struct dmub_rb_cmd_dig1_transmitter_control dig1_transmitter_control;
+	/**
+	 * Definition of a DMUB_CMD__VBIOS_DOMAIN_CONTROL command.
+	 */
+	struct dmub_rb_cmd_domain_control domain_control;
 	/**
 	 * Definition of a DMUB_CMD__PSR_SET_VERSION command.
 	 */
-- 
2.39.0

