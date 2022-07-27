Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDD3582E22
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbiG0RIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240940AbiG0RH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:07:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5704213DE6;
        Wed, 27 Jul 2022 09:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F586B8200D;
        Wed, 27 Jul 2022 16:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C84C433C1;
        Wed, 27 Jul 2022 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940010;
        bh=VMLCUBZCobyAXdrRzT/Jh16eeai0MEhj4Z65pThCLuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8RwktXznhvsZhGpCljxpvlt2lDM64Df4zFNBP8v43T6Vl1TbDRhD1JuNQUOpkv+r
         tC/JF4uC31FUlPEoaPm594hsGmrcLcFCVAIuQUhh0G36DtA518qBemHvx5ovRFw2+T
         Wcnhr1BS37F4A9AsNIZWmaoOmRu6J3zxptmtxZMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikita Lipski <mikita.lipski@amd.com>,
        Wayne Lin <Wayne.Lin@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/201] drm/amd/display: Add option to defer works of hpd_rx_irq
Date:   Wed, 27 Jul 2022 18:09:07 +0200
Message-Id: <20220727161028.661523908@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit 410ad92d7fecd30de7456c19e326e272c2153ff2 ]

[Why & How]
Due to some code flow constraints, we need to defer dc_lock needed works
from dc_link_handle_hpd_rx_irq(). Thus, do following changes:

* Change allow_hpd_rx_irq() from static to public
* Change handle_automated_test() from static to public
* Extract link lost handling flow out from dc_link_handle_hpd_rx_irq()
  and put those into a new function dc_link_dp_handle_link_loss()
* Add one option parameter to decide whether defer works within
  dc_link_handle_hpd_rx_irq()

Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_link_dp.c  | 92 ++++++++++++-------
 drivers/gpu/drm/amd/display/dc/dc_link.h      |  3 +
 2 files changed, 63 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 05f81d44aa6c..9b6111eb9ca4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2743,7 +2743,7 @@ void decide_link_settings(struct dc_stream_state *stream,
 }
 
 /*************************Short Pulse IRQ***************************/
-static bool allow_hpd_rx_irq(const struct dc_link *link)
+bool dc_link_dp_allow_hpd_rx_irq(const struct dc_link *link)
 {
 	/*
 	 * Don't handle RX IRQ unless one of following is met:
@@ -3177,7 +3177,7 @@ static void dp_test_get_audio_test_data(struct dc_link *link, bool disable_video
 	}
 }
 
-static void handle_automated_test(struct dc_link *link)
+void dc_link_dp_handle_automated_test(struct dc_link *link)
 {
 	union test_request test_request;
 	union test_response test_response;
@@ -3226,17 +3226,50 @@ static void handle_automated_test(struct dc_link *link)
 			sizeof(test_response));
 }
 
-bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd_irq_dpcd_data, bool *out_link_loss)
+void dc_link_dp_handle_link_loss(struct dc_link *link)
+{
+	int i;
+	struct pipe_ctx *pipe_ctx;
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
+		if (pipe_ctx && pipe_ctx->stream && pipe_ctx->stream->link == link)
+			break;
+	}
+
+	if (pipe_ctx == NULL || pipe_ctx->stream == NULL)
+		return;
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
+		if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
+				pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe) {
+			core_link_disable_stream(pipe_ctx);
+		}
+	}
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
+		if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
+				pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe) {
+			core_link_enable_stream(link->dc->current_state, pipe_ctx);
+		}
+	}
+}
+
+static bool handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd_irq_dpcd_data, bool *out_link_loss,
+							bool defer_handling, bool *has_left_work)
 {
 	union hpd_irq_data hpd_irq_dpcd_data = { { { {0} } } };
 	union device_service_irq device_service_clear = { { 0 } };
 	enum dc_status result;
 	bool status = false;
-	struct pipe_ctx *pipe_ctx;
-	int i;
 
 	if (out_link_loss)
 		*out_link_loss = false;
+
+	if (has_left_work)
+		*has_left_work = false;
 	/* For use cases related to down stream connection status change,
 	 * PSR and device auto test, refer to function handle_sst_hpd_irq
 	 * in DAL2.1*/
@@ -3268,11 +3301,14 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 			&device_service_clear.raw,
 			sizeof(device_service_clear.raw));
 		device_service_clear.raw = 0;
-		handle_automated_test(link);
+		if (defer_handling && has_left_work)
+			*has_left_work = true;
+		else
+			dc_link_dp_handle_automated_test(link);
 		return false;
 	}
 
-	if (!allow_hpd_rx_irq(link)) {
+	if (!dc_link_dp_allow_hpd_rx_irq(link)) {
 		DC_LOG_HW_HPD_IRQ("%s: skipping HPD handling on %d\n",
 			__func__, link->link_index);
 		return false;
@@ -3286,12 +3322,18 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 	 * so do not handle as a normal sink status change interrupt.
 	 */
 
-	if (hpd_irq_dpcd_data.bytes.device_service_irq.bits.UP_REQ_MSG_RDY)
+	if (hpd_irq_dpcd_data.bytes.device_service_irq.bits.UP_REQ_MSG_RDY) {
+		if (defer_handling && has_left_work)
+			*has_left_work = true;
 		return true;
+	}
 
 	/* check if we have MST msg and return since we poll for it */
-	if (hpd_irq_dpcd_data.bytes.device_service_irq.bits.DOWN_REP_MSG_RDY)
+	if (hpd_irq_dpcd_data.bytes.device_service_irq.bits.DOWN_REP_MSG_RDY) {
+		if (defer_handling && has_left_work)
+			*has_left_work = true;
 		return false;
+	}
 
 	/* For now we only handle 'Downstream port status' case.
 	 * If we got sink count changed it means
@@ -3308,29 +3350,10 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 					sizeof(hpd_irq_dpcd_data),
 					"Status: ");
 
-		for (i = 0; i < MAX_PIPES; i++) {
-			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream && pipe_ctx->stream->link == link)
-				break;
-		}
-
-		if (pipe_ctx == NULL || pipe_ctx->stream == NULL)
-			return false;
-
-
-		for (i = 0; i < MAX_PIPES; i++) {
-			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
-					pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe)
-				core_link_disable_stream(pipe_ctx);
-		}
-
-		for (i = 0; i < MAX_PIPES; i++) {
-			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
-					pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe)
-				core_link_enable_stream(link->dc->current_state, pipe_ctx);
-		}
+		if (defer_handling && has_left_work)
+			*has_left_work = true;
+		else
+			dc_link_dp_handle_link_loss(link);
 
 		status = false;
 		if (out_link_loss)
@@ -3356,6 +3379,11 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 	return status;
 }
 
+bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd_irq_dpcd_data, bool *out_link_loss)
+{
+	return handle_hpd_rx_irq(link, out_hpd_irq_dpcd_data, out_link_loss, false, NULL);
+}
+
 /*query dpcd for version and mst cap addresses*/
 bool is_mst_supported(struct dc_link *link)
 {
diff --git a/drivers/gpu/drm/amd/display/dc/dc_link.h b/drivers/gpu/drm/amd/display/dc/dc_link.h
index 83845d006c54..0efa2bc8639b 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_link.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_link.h
@@ -308,6 +308,9 @@ bool dc_link_wait_for_t12(struct dc_link *link);
 enum dc_status read_hpd_rx_irq_data(
 	struct dc_link *link,
 	union hpd_irq_data *irq_data);
+void dc_link_dp_handle_automated_test(struct dc_link *link);
+void dc_link_dp_handle_link_loss(struct dc_link *link);
+bool dc_link_dp_allow_hpd_rx_irq(const struct dc_link *link);
 
 struct dc_sink_init_data;
 
-- 
2.35.1



