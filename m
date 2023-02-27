Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBA66A36C5
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjB0CEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjB0CEl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:04:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B6010D4;
        Sun, 26 Feb 2023 18:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 440CBB80CAF;
        Mon, 27 Feb 2023 02:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332F7C4339B;
        Mon, 27 Feb 2023 02:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463422;
        bh=evSKf+g6FfKT5ycXth9R2zqOmzfES6JKtu2kvL91xZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lD795nHykP24vkiKZG+/nl51Dwcb6uPYC0wOfyCFx00SEH/hVwwg0JYnBe05DtJhi
         4y1FQ1S+peBQlJvPUetM/vPnoSlo1kHZpHtPi2rc+m3vII2xYP3ub7L/t3AkVQS6y7
         NMVmQcwVFcpAiT9hn5Q1zTfbKNJcJzUwErr4NCyfb4SzX5H1V4MgvaQ8xMkil2RJP1
         88B9SOWDKiciTzEBkAqmx/bZIVo4Q7M9TGMTGmRHNU9jGpJ75tPkBlnHrRlP3s5+LI
         hj/c6JH2C36aQ/kUe/fl19p8BDX057IBwUQBOYglKKnV6oymibNf6fUUe1sdIHszoE
         9oaVe2Ou0RHoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Alvin.Lee2@amd.com, aurabindo.pillai@amd.com,
        samson.tam@amd.com, Dillon.Varone@amd.com, HaoPing.Liu@amd.com,
        Josip.Pavic@amd.com, aric.cyr@amd.com,
        jiapeng.chong@linux.alibaba.com, jdhillon@amd.com,
        felipe.clark@amd.com, Wayne.Lin@amd.com,
        harry.vanzylldejong@amd.com, Duncan.Ma@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 46/60] drm/amd/display: Do not commit pipe when updating DRR
Date:   Sun, 26 Feb 2023 21:00:31 -0500
Message-Id: <20230227020045.1045105-46-sashal@kernel.org>
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

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit 8f0d304d21b351d65e8c434c5399a40231876ba1 ]

[WHY]
DRR and Pipe cannot be updated on
the same frame, or else underflow will
occur.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c          | 15 +++++++++++++++
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.h |  3 ++-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c |  9 +++++++++
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.h |  2 ++
 .../drm/amd/display/dc/inc/hw/timing_generator.h  |  1 +
 5 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index c03e86e49fea3..698ef50e83f3f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3335,6 +3335,21 @@ static void commit_planes_for_stream(struct dc *dc,
 
 	dc_z10_restore(dc);
 
+	if (update_type == UPDATE_TYPE_FULL) {
+		/* wait for all double-buffer activity to clear on all pipes */
+		int pipe_idx;
+
+		for (pipe_idx = 0; pipe_idx < dc->res_pool->pipe_count; pipe_idx++) {
+			struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[pipe_idx];
+
+			if (!pipe_ctx->stream)
+				continue;
+
+			if (pipe_ctx->stream_res.tg->funcs->wait_drr_doublebuffer_pending_clear)
+				pipe_ctx->stream_res.tg->funcs->wait_drr_doublebuffer_pending_clear(pipe_ctx->stream_res.tg);
+		}
+	}
+
 	if (get_seamless_boot_stream_count(context) > 0 && surface_count > 0) {
 		/* Optimize seamless boot flag keeps clocks and watermarks high until
 		 * first flip. After first flip, optimization is required to lower
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.h
index 88ac5f6f4c96c..0b37bb0e184b2 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.h
@@ -519,7 +519,8 @@ struct dcn_optc_registers {
 	type OTG_CRC_DATA_STREAM_COMBINE_MODE;\
 	type OTG_CRC_DATA_STREAM_SPLIT_MODE;\
 	type OTG_CRC_DATA_FORMAT;\
-	type OTG_V_TOTAL_LAST_USED_BY_DRR;
+	type OTG_V_TOTAL_LAST_USED_BY_DRR;\
+	type OTG_DRR_TIMING_DBUF_UPDATE_PENDING;
 
 #define TG_REG_FIELD_LIST_DCN3_2(type) \
 	type OTG_H_TIMING_DIV_MODE_MANUAL;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c
index 867d60151aebb..08b92715e2e64 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c
@@ -291,6 +291,14 @@ static void optc3_set_timing_double_buffer(struct timing_generator *optc, bool e
 		   OTG_DRR_TIMING_DBUF_UPDATE_MODE, mode);
 }
 
+void optc3_wait_drr_doublebuffer_pending_clear(struct timing_generator *optc)
+{
+	struct optc *optc1 = DCN10TG_FROM_TG(optc);
+
+	REG_WAIT(OTG_DOUBLE_BUFFER_CONTROL, OTG_DRR_TIMING_DBUF_UPDATE_PENDING, 0, 2, 100000); /* 1 vupdate at 5hz */
+
+}
+
 void optc3_set_vtotal_min_max(struct timing_generator *optc, int vtotal_min, int vtotal_max)
 {
 	optc1_set_vtotal_min_max(optc, vtotal_min, vtotal_max);
@@ -360,6 +368,7 @@ static struct timing_generator_funcs dcn30_tg_funcs = {
 		.program_manual_trigger = optc2_program_manual_trigger,
 		.setup_manual_trigger = optc2_setup_manual_trigger,
 		.get_hw_timing = optc1_get_hw_timing,
+		.wait_drr_doublebuffer_pending_clear = optc3_wait_drr_doublebuffer_pending_clear,
 };
 
 void dcn30_timing_generator_init(struct optc *optc1)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.h b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.h
index dd45a5499b078..fb06dc9a48937 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.h
@@ -279,6 +279,7 @@
 	SF(OTG0_OTG_DRR_TRIGGER_WINDOW, OTG_DRR_TRIGGER_WINDOW_END_X, mask_sh),\
 	SF(OTG0_OTG_DRR_V_TOTAL_CHANGE, OTG_DRR_V_TOTAL_CHANGE_LIMIT, mask_sh),\
 	SF(OTG0_OTG_H_TIMING_CNTL, OTG_H_TIMING_DIV_BY2, mask_sh),\
+	SF(OTG0_OTG_DOUBLE_BUFFER_CONTROL, OTG_DRR_TIMING_DBUF_UPDATE_PENDING, mask_sh),\
 	SF(OTG0_OTG_DOUBLE_BUFFER_CONTROL, OTG_DRR_TIMING_DBUF_UPDATE_MODE, mask_sh),\
 	SF(OTG0_OTG_DOUBLE_BUFFER_CONTROL, OTG_BLANK_DATA_DOUBLE_BUFFER_EN, mask_sh)
 
@@ -317,6 +318,7 @@
 	SF(OTG0_OTG_DRR_TRIGGER_WINDOW, OTG_DRR_TRIGGER_WINDOW_END_X, mask_sh),\
 	SF(OTG0_OTG_DRR_V_TOTAL_CHANGE, OTG_DRR_V_TOTAL_CHANGE_LIMIT, mask_sh),\
 	SF(OTG0_OTG_H_TIMING_CNTL, OTG_H_TIMING_DIV_MODE, mask_sh),\
+	SF(OTG0_OTG_DOUBLE_BUFFER_CONTROL, OTG_DRR_TIMING_DBUF_UPDATE_PENDING, mask_sh),\
 	SF(OTG0_OTG_DOUBLE_BUFFER_CONTROL, OTG_DRR_TIMING_DBUF_UPDATE_MODE, mask_sh)
 
 void dcn30_timing_generator_init(struct optc *optc1);
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
index 0e42e721dd15a..1d9f9c53d2bd6 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
@@ -331,6 +331,7 @@ struct timing_generator_funcs {
 			uint32_t vtotal_change_limit);
 
 	void (*init_odm)(struct timing_generator *tg);
+	void (*wait_drr_doublebuffer_pending_clear)(struct timing_generator *tg);
 };
 
 #endif
-- 
2.39.0

