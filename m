Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A1D3CAA5F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242728AbhGOTNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244026AbhGOTKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31F9B60FF4;
        Thu, 15 Jul 2021 19:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376054;
        bh=Pejy/uqWhrg1kICAUZHy8d81O/DaGGBOY2v3hc5bJ9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcif3C04BgqY6Kqqu3WmTugBbAwiWew7d864i/u1xfIyFtYqm3chBbGP9GnQ2igfT
         g/rno5grfyoatP3P4Q/75EVFV6v8Wtq5SKv6idBAgIXa06QMIF9fGVEDLAnieGeow8
         lZzCNJ3+t47MiUGW+8Cstp61d8nKTT2vZgNq2QuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 106/266] drm/amd/display: Cover edge-case when changing DISPCLK WDIVIDER
Date:   Thu, 15 Jul 2021 20:37:41 +0200
Message-Id: <20210715182632.619513356@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit 78ebca321999699f30ea19029726d1a3908b395f ]

[WHY]
When changing the DISPCLK_WDIVIDER value from 126 to 127, the change in
clock rate is too great for the FIFOs to handle. This can cause visible
corruption during clock change.

HW has handed down this register sequence to fix the issue.

[HOW]
The sequence, from HW:
a.	127 -> 126
Read  DIG_FIFO_CAL_AVERAGE_LEVEL
FIFO level N = DIG_FIFO_CAL_AVERAGE_LEVEL / 4
Set DCCG_FIFO_ERRDET_OVR_EN = 1
Write 1 to OTGx_DROP_PIXEL for (N-4) times
Set DCCG_FIFO_ERRDET_OVR_EN = 0
Write DENTIST_DISPCLK_RDIVIDER = 126

Because of frequency stepping, sequence a can be executed to change the
divider from 127 to any other divider value.

b.	126 -> 127
Read  DIG_FIFO_CAL_AVERAGE_LEVEL
FIFO level N = DIG_FIFO_CAL_AVERAGE_LEVEL / 4
Set DCCG_FIFO_ERRDET_OVR_EN = 1
Write 1 to OTGx_ADD_PIXEL for (12-N) times
Set DCCG_FIFO_ERRDET_OVR_EN = 0
Write DENTIST_DISPCLK_RDIVIDER = 127

Because of frequency stepping, divider must first be set from any other
divider value to 126 before executing sequence b.

Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c  | 68 ++++++++++++++++++-
 .../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h  |  3 +-
 .../display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c  |  4 +-
 3 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
index 372d53b5a34d..3d335b4e9891 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
@@ -123,7 +123,7 @@ void dcn20_update_clocks_update_dpp_dto(struct clk_mgr_internal *clk_mgr,
 	}
 }
 
-void dcn20_update_clocks_update_dentist(struct clk_mgr_internal *clk_mgr)
+void dcn20_update_clocks_update_dentist(struct clk_mgr_internal *clk_mgr, struct dc_state *context)
 {
 	int dpp_divider = DENTIST_DIVIDER_RANGE_SCALE_FACTOR
 			* clk_mgr->base.dentist_vco_freq_khz / clk_mgr->base.clks.dppclk_khz;
@@ -132,6 +132,68 @@ void dcn20_update_clocks_update_dentist(struct clk_mgr_internal *clk_mgr)
 
 	uint32_t dppclk_wdivider = dentist_get_did_from_divider(dpp_divider);
 	uint32_t dispclk_wdivider = dentist_get_did_from_divider(disp_divider);
+	uint32_t current_dispclk_wdivider;
+	uint32_t i;
+
+	REG_GET(DENTIST_DISPCLK_CNTL,
+			DENTIST_DISPCLK_WDIVIDER, &current_dispclk_wdivider);
+
+	/* When changing divider to or from 127, some extra programming is required to prevent corruption */
+	if (current_dispclk_wdivider == 127 && dispclk_wdivider != 127) {
+		for (i = 0; i < clk_mgr->base.ctx->dc->res_pool->pipe_count; i++) {
+			struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+			uint32_t fifo_level;
+			struct dccg *dccg = clk_mgr->base.ctx->dc->res_pool->dccg;
+			struct stream_encoder *stream_enc = pipe_ctx->stream_res.stream_enc;
+			int32_t N;
+			int32_t j;
+
+			if (!pipe_ctx->stream)
+				continue;
+			/* Virtual encoders don't have this function */
+			if (!stream_enc->funcs->get_fifo_cal_average_level)
+				continue;
+			fifo_level = stream_enc->funcs->get_fifo_cal_average_level(
+					stream_enc);
+			N = fifo_level / 4;
+			dccg->funcs->set_fifo_errdet_ovr_en(
+					dccg,
+					true);
+			for (j = 0; j < N - 4; j++)
+				dccg->funcs->otg_drop_pixel(
+						dccg,
+						pipe_ctx->stream_res.tg->inst);
+			dccg->funcs->set_fifo_errdet_ovr_en(
+					dccg,
+					false);
+		}
+	} else if (dispclk_wdivider == 127 && current_dispclk_wdivider != 127) {
+		REG_UPDATE(DENTIST_DISPCLK_CNTL,
+				DENTIST_DISPCLK_WDIVIDER, 126);
+		REG_WAIT(DENTIST_DISPCLK_CNTL, DENTIST_DISPCLK_CHG_DONE, 1, 50, 100);
+		for (i = 0; i < clk_mgr->base.ctx->dc->res_pool->pipe_count; i++) {
+			struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+			struct dccg *dccg = clk_mgr->base.ctx->dc->res_pool->dccg;
+			struct stream_encoder *stream_enc = pipe_ctx->stream_res.stream_enc;
+			uint32_t fifo_level;
+			int32_t N;
+			int32_t j;
+
+			if (!pipe_ctx->stream)
+				continue;
+			/* Virtual encoders don't have this function */
+			if (!stream_enc->funcs->get_fifo_cal_average_level)
+				continue;
+			fifo_level = stream_enc->funcs->get_fifo_cal_average_level(
+					stream_enc);
+			N = fifo_level / 4;
+			dccg->funcs->set_fifo_errdet_ovr_en(dccg, true);
+			for (j = 0; j < 12 - N; j++)
+				dccg->funcs->otg_add_pixel(dccg,
+						pipe_ctx->stream_res.tg->inst);
+			dccg->funcs->set_fifo_errdet_ovr_en(dccg, false);
+		}
+	}
 
 	REG_UPDATE(DENTIST_DISPCLK_CNTL,
 			DENTIST_DISPCLK_WDIVIDER, dispclk_wdivider);
@@ -251,11 +313,11 @@ void dcn2_update_clocks(struct clk_mgr *clk_mgr_base,
 		if (dpp_clock_lowered) {
 			// if clock is being lowered, increase DTO before lowering refclk
 			dcn20_update_clocks_update_dpp_dto(clk_mgr, context, safe_to_lower);
-			dcn20_update_clocks_update_dentist(clk_mgr);
+			dcn20_update_clocks_update_dentist(clk_mgr, context);
 		} else {
 			// if clock is being raised, increase refclk before lowering DTO
 			if (update_dppclk || update_dispclk)
-				dcn20_update_clocks_update_dentist(clk_mgr);
+				dcn20_update_clocks_update_dentist(clk_mgr, context);
 			// always update dtos unless clock is lowered and not safe to lower
 			dcn20_update_clocks_update_dpp_dto(clk_mgr, context, safe_to_lower);
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h
index 0b9c045b0c8e..d254d0b6fba1 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.h
@@ -50,7 +50,8 @@ void dcn2_get_clock(struct clk_mgr *clk_mgr,
 			enum dc_clock_type clock_type,
 			struct dc_clock_config *clock_cfg);
 
-void dcn20_update_clocks_update_dentist(struct clk_mgr_internal *clk_mgr);
+void dcn20_update_clocks_update_dentist(struct clk_mgr_internal *clk_mgr,
+					struct dc_state *context);
 
 void dcn2_read_clocks_from_hw_dentist(struct clk_mgr *clk_mgr_base);
 
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
index 652fa89fae5f..513676a6f52b 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c
@@ -334,11 +334,11 @@ static void dcn3_update_clocks(struct clk_mgr *clk_mgr_base,
 		if (dpp_clock_lowered) {
 			/* if clock is being lowered, increase DTO before lowering refclk */
 			dcn20_update_clocks_update_dpp_dto(clk_mgr, context, safe_to_lower);
-			dcn20_update_clocks_update_dentist(clk_mgr);
+			dcn20_update_clocks_update_dentist(clk_mgr, context);
 		} else {
 			/* if clock is being raised, increase refclk before lowering DTO */
 			if (update_dppclk || update_dispclk)
-				dcn20_update_clocks_update_dentist(clk_mgr);
+				dcn20_update_clocks_update_dentist(clk_mgr, context);
 			/* There is a check inside dcn20_update_clocks_update_dpp_dto which ensures
 			 * that we do not lower dto when it is not safe to lower. We do not need to
 			 * compare the current and new dppclk before calling this function.*/
-- 
2.30.2



