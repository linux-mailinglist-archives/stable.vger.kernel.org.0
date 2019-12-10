Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0437E1199DA
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfLJVI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbfLJVIz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 411A7246A1;
        Tue, 10 Dec 2019 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012135;
        bh=otZ2XpBNGM9vqKhgPacAje6pQSlojqxZHAUN4DW+jHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLB9382rjLw457Ctuz8+2DPtIZpNT1hDMPQH5av7/G+qeM7X6rAezo+muJVFNHJqQ
         rZforpA+4CW3uHwbRhf+cpg42ztYCUtLcEFbyfFQFfDqamKlrocbBd6FiDriU7Mdq6
         3GU2J1I8lRFzsA+jk8gE6wOBgTLk4ssx953AuKP0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Parkin <julian.parkin@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 102/350] drm/amd/display: Program DWB watermarks from correct state
Date:   Tue, 10 Dec 2019 16:03:27 -0500
Message-Id: <20191210210735.9077-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Parkin <julian.parkin@amd.com>

[ Upstream commit edb922b022c0c94805c4ffad202b3edff83d76f0 ]

[Why]
When diags adds a DWB via a stream update, we calculate MMHUBBUB
paramaters, but dc->current_state has not yet been updated
when the DWB programming happens. This leads to overflow on
high bandwidth tests since the incorrect MMHUBBUB arbitration
parameters are programmed.

[How]
Pass the updated context down to the (enable|update)_writeback functions
so that they can use the correct watermarks when programming MMHUBBUB.

Signed-off-by: Julian Parkin <julian.parkin@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    | 4 ++--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 5 +++--
 drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h  | 6 ++++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index bf1d7bb90e0f9..bb09243758fe3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -423,10 +423,10 @@ bool dc_stream_add_writeback(struct dc *dc,
 
 		if (dwb->funcs->is_enabled(dwb)) {
 			/* writeback pipe already enabled, only need to update */
-			dc->hwss.update_writeback(dc, stream_status, wb_info);
+			dc->hwss.update_writeback(dc, stream_status, wb_info, dc->current_state);
 		} else {
 			/* Enable writeback pipe from scratch*/
-			dc->hwss.enable_writeback(dc, stream_status, wb_info);
+			dc->hwss.enable_writeback(dc, stream_status, wb_info, dc->current_state);
 		}
 	}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 1212da12c4144..9108240d3c1b2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1337,7 +1337,8 @@ bool dcn20_update_bandwidth(
 static void dcn20_enable_writeback(
 		struct dc *dc,
 		const struct dc_stream_status *stream_status,
-		struct dc_writeback_info *wb_info)
+		struct dc_writeback_info *wb_info,
+		struct dc_state *context)
 {
 	struct dwbc *dwb;
 	struct mcif_wb *mcif_wb;
@@ -1354,7 +1355,7 @@ static void dcn20_enable_writeback(
 	optc->funcs->set_dwb_source(optc, wb_info->dwb_pipe_inst);
 	/* set MCIF_WB buffer and arbitration configuration */
 	mcif_wb->funcs->config_mcif_buf(mcif_wb, &wb_info->mcif_buf_params, wb_info->dwb_params.dest_height);
-	mcif_wb->funcs->config_mcif_arb(mcif_wb, &dc->current_state->bw_ctx.bw.dcn.bw_writeback.mcif_wb_arb[wb_info->dwb_pipe_inst]);
+	mcif_wb->funcs->config_mcif_arb(mcif_wb, &context->bw_ctx.bw.dcn.bw_writeback.mcif_wb_arb[wb_info->dwb_pipe_inst]);
 	/* Enable MCIF_WB */
 	mcif_wb->funcs->enable_mcif(mcif_wb);
 	/* Enable DWB */
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index 3a938cd414ea4..f6cc2d6f576d2 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -321,10 +321,12 @@ struct hw_sequencer_funcs {
 			struct dc_state *context);
 	void (*update_writeback)(struct dc *dc,
 			const struct dc_stream_status *stream_status,
-			struct dc_writeback_info *wb_info);
+			struct dc_writeback_info *wb_info,
+			struct dc_state *context);
 	void (*enable_writeback)(struct dc *dc,
 			const struct dc_stream_status *stream_status,
-			struct dc_writeback_info *wb_info);
+			struct dc_writeback_info *wb_info,
+			struct dc_state *context);
 	void (*disable_writeback)(struct dc *dc,
 			unsigned int dwb_pipe_inst);
 #endif
-- 
2.20.1

