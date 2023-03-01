Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8531C6A7324
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCASNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjCASNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:13:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A0D144B4
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:13:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96FC2CE1DAF
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CEBC433D2;
        Wed,  1 Mar 2023 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694381;
        bh=OrFODWod5r7AsMCEk2kWAYxiC5A3Fz0JuBQgIvS84Xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIrK860Qqcxi8yT4mv0FfxejLcOJxLZj2lWAm4du+y8edKLE5brYvuKi4HPQvx3MG
         +85mrZaYLy0V2tR+tQZ8x2UMD0VMrFYyAY/wsaAzihzNSlXaLNG0U5gPiMQhA7ki+i
         mUYToq08q/js7rIhwJUO2T9VEkWPs55uu4JqKVoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hansen Dsouza <hansen.dsouza@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 28/42] drm/amd/display: Move DCN314 DOMAIN power control to DMCUB
Date:   Wed,  1 Mar 2023 19:08:49 +0100
Message-Id: <20230301180658.309176585@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit e383b12709e32d6494c948422070c2464b637e44 upstream.

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
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c |   24 ++++++++++++++++++
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h |    2 +
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c  |    2 -
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h      |   25 +++++++++++++++++++
 4 files changed, 52 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
@@ -391,3 +391,27 @@ void dcn314_set_pixels_per_cycle(struct
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
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.h
@@ -41,4 +41,6 @@ unsigned int dcn314_calculate_dccg_k1_k2
 
 void dcn314_set_pixels_per_cycle(struct pipe_ctx *pipe_ctx);
 
+void dcn314_hubp_pg_control(struct dce_hwseq *hws, unsigned int hubp_inst, bool power_on);
+
 #endif /* __DC_HWSS_DCN314_H__ */
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_init.c
@@ -137,7 +137,7 @@ static const struct hwseq_private_funcs
 	.plane_atomic_disable = dcn20_plane_atomic_disable,
 	.plane_atomic_power_down = dcn10_plane_atomic_power_down,
 	.enable_power_gating_plane = dcn314_enable_power_gating_plane,
-	.hubp_pg_control = dcn31_hubp_pg_control,
+	.hubp_pg_control = dcn314_hubp_pg_control,
 	.program_all_writeback_pipes_in_tree = dcn30_program_all_writeback_pipes_in_tree,
 	.update_odm = dcn314_update_odm,
 	.dsc_pg_control = dcn314_dsc_pg_control,
--- a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
+++ b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
@@ -450,6 +450,10 @@ enum dmub_cmd_vbios_type {
 	 * Query DP alt status on a transmitter.
 	 */
 	DMUB_CMD__VBIOS_TRANSMITTER_QUERY_DP_ALT  = 26,
+	/**
+	 * Controls domain power gating
+	 */
+	DMUB_CMD__VBIOS_DOMAIN_CONTROL = 28,
 };
 
 //==============================================================================
@@ -1192,6 +1196,23 @@ struct dmub_rb_cmd_dig1_transmitter_cont
 };
 
 /**
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
+/**
  * DPIA tunnel command parameters.
  */
 struct dmub_cmd_dig_dpia_control_data {
@@ -3188,6 +3209,10 @@ union dmub_rb_cmd {
 	 */
 	struct dmub_rb_cmd_dig1_transmitter_control dig1_transmitter_control;
 	/**
+	 * Definition of a DMUB_CMD__VBIOS_DOMAIN_CONTROL command.
+	 */
+	struct dmub_rb_cmd_domain_control domain_control;
+	/**
 	 * Definition of a DMUB_CMD__PSR_SET_VERSION command.
 	 */
 	struct dmub_rb_cmd_psr_set_version psr_set_version;


