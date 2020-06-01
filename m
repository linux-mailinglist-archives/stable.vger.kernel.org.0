Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D03D1EAC36
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbgFASQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbgFASQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4B092065C;
        Mon,  1 Jun 2020 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035406;
        bh=BPDbNvzzUjnGPujcA72DFHzXh6nHpYbT++JHYM1ydrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYhqQkOL/jB8zBAVeth8hyQaPiQz5h23D0k3VmF0IXtmGpHjAypMUgRSwtF6m2/a2
         UvP4xinORi40yth63TyUT11pDx4g1CeX2Rm0Urb3VopTpmapxAvnSUApxqT8KPfST1
         m1qc32kDXW+WJqAh0wAVanK3Ct3HDHMrteEyfNlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <aric.cyr@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 128/177] drm/amd/display: Use cursor locking to prevent flip delays
Date:   Mon,  1 Jun 2020 19:54:26 +0200
Message-Id: <20200601174059.219244252@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit b2a7b0ce0773bfa4406bc0a78e41979532a1edd7 ]

[Why]
Current locking scheme for cursor can result in a flip missing
its vsync, deferring it for one or more vsyncs.  Result is a
potential for stuttering when cursor is moved.

[How]
Use cursor update lock so that flips are not blocked while cursor
is being programmed.

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/core/dc_stream.c   | 40 ++-----------------
 .../display/dc/dce110/dce110_hw_sequencer.c   |  1 +
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 10 +++++
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.h |  1 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_init.c |  1 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c  | 15 +++++++
 .../gpu/drm/amd/display/dc/dcn10/dcn10_mpc.h  | 20 +++++++---
 .../drm/amd/display/dc/dcn10/dcn10_resource.c | 14 ++++++-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_init.c |  1 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c  |  1 +
 .../gpu/drm/amd/display/dc/dcn20/dcn20_mpc.h  |  3 +-
 .../drm/amd/display/dc/dcn20/dcn20_resource.c |  4 ++
 .../gpu/drm/amd/display/dc/dcn21/dcn21_init.c |  1 +
 .../drm/amd/display/dc/dcn21/dcn21_resource.c |  4 ++
 drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h   | 16 ++++++++
 .../gpu/drm/amd/display/dc/inc/hw_sequencer.h |  1 +
 16 files changed, 88 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index 8c20e9e907b2..4f0e7203dba4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -231,34 +231,6 @@ struct dc_stream_status *dc_stream_get_status(
 	return dc_stream_get_status_from_state(dc->current_state, stream);
 }
 
-static void delay_cursor_until_vupdate(struct pipe_ctx *pipe_ctx, struct dc *dc)
-{
-#if defined(CONFIG_DRM_AMD_DC_DCN)
-	unsigned int vupdate_line;
-	unsigned int lines_to_vupdate, us_to_vupdate, vpos, nvpos;
-	struct dc_stream_state *stream = pipe_ctx->stream;
-	unsigned int us_per_line;
-
-	if (!dc->hwss.get_vupdate_offset_from_vsync)
-		return;
-
-	vupdate_line = dc->hwss.get_vupdate_offset_from_vsync(pipe_ctx);
-	if (!dc_stream_get_crtc_position(dc, &stream, 1, &vpos, &nvpos))
-		return;
-
-	if (vpos >= vupdate_line)
-		return;
-
-	us_per_line =
-		stream->timing.h_total * 10000 / stream->timing.pix_clk_100hz;
-	lines_to_vupdate = vupdate_line - vpos;
-	us_to_vupdate = lines_to_vupdate * us_per_line;
-
-	/* 70 us is a conservative estimate of cursor update time*/
-	if (us_to_vupdate < 70)
-		udelay(us_to_vupdate);
-#endif
-}
 
 /**
  * dc_stream_set_cursor_attributes() - Update cursor attributes and set cursor surface address
@@ -298,9 +270,7 @@ bool dc_stream_set_cursor_attributes(
 
 		if (!pipe_to_program) {
 			pipe_to_program = pipe_ctx;
-
-			delay_cursor_until_vupdate(pipe_ctx, dc);
-			dc->hwss.pipe_control_lock(dc, pipe_to_program, true);
+			dc->hwss.cursor_lock(dc, pipe_to_program, true);
 		}
 
 		dc->hwss.set_cursor_attribute(pipe_ctx);
@@ -309,7 +279,7 @@ bool dc_stream_set_cursor_attributes(
 	}
 
 	if (pipe_to_program)
-		dc->hwss.pipe_control_lock(dc, pipe_to_program, false);
+		dc->hwss.cursor_lock(dc, pipe_to_program, false);
 
 	return true;
 }
@@ -349,16 +319,14 @@ bool dc_stream_set_cursor_position(
 
 		if (!pipe_to_program) {
 			pipe_to_program = pipe_ctx;
-
-			delay_cursor_until_vupdate(pipe_ctx, dc);
-			dc->hwss.pipe_control_lock(dc, pipe_to_program, true);
+			dc->hwss.cursor_lock(dc, pipe_to_program, true);
 		}
 
 		dc->hwss.set_cursor_position(pipe_ctx);
 	}
 
 	if (pipe_to_program)
-		dc->hwss.pipe_control_lock(dc, pipe_to_program, false);
+		dc->hwss.cursor_lock(dc, pipe_to_program, false);
 
 	return true;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 56d4ec7bdad7..454a123b92fc 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -2723,6 +2723,7 @@ static const struct hw_sequencer_funcs dce110_funcs = {
 	.disable_plane = dce110_power_down_fe,
 	.pipe_control_lock = dce_pipe_control_lock,
 	.interdependent_update_lock = NULL,
+	.cursor_lock = dce_pipe_control_lock,
 	.prepare_bandwidth = dce110_prepare_bandwidth,
 	.optimize_bandwidth = dce110_optimize_bandwidth,
 	.set_drr = set_drr,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 7fc559acffcd..97a820b90541 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1592,6 +1592,16 @@ void dcn10_pipe_control_lock(
 		hws->funcs.verify_allow_pstate_change_high(dc);
 }
 
+void dcn10_cursor_lock(struct dc *dc, struct pipe_ctx *pipe, bool lock)
+{
+	/* cursor lock is per MPCC tree, so only need to lock one pipe per stream */
+	if (!pipe || pipe->top_pipe)
+		return;
+
+	dc->res_pool->mpc->funcs->cursor_lock(dc->res_pool->mpc,
+			pipe->stream_res.opp->inst, lock);
+}
+
 static bool wait_for_reset_trigger_to_occur(
 	struct dc_context *dc_ctx,
 	struct timing_generator *tg)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
index 16a50e05ffbf..af51424315d5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
@@ -49,6 +49,7 @@ void dcn10_pipe_control_lock(
 	struct dc *dc,
 	struct pipe_ctx *pipe,
 	bool lock);
+void dcn10_cursor_lock(struct dc *dc, struct pipe_ctx *pipe, bool lock);
 void dcn10_blank_pixel_data(
 		struct dc *dc,
 		struct pipe_ctx *pipe_ctx,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
index b88ef9703b2b..4a8e4b797bea 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_init.c
@@ -50,6 +50,7 @@ static const struct hw_sequencer_funcs dcn10_funcs = {
 	.disable_audio_stream = dce110_disable_audio_stream,
 	.disable_plane = dcn10_disable_plane,
 	.pipe_control_lock = dcn10_pipe_control_lock,
+	.cursor_lock = dcn10_cursor_lock,
 	.interdependent_update_lock = dcn10_lock_all_pipes,
 	.prepare_bandwidth = dcn10_prepare_bandwidth,
 	.optimize_bandwidth = dcn10_optimize_bandwidth,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
index 04f863499cfb..3fcd408e9103 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.c
@@ -223,6 +223,9 @@ struct mpcc *mpc1_insert_plane(
 	REG_SET(MPCC_TOP_SEL[mpcc_id], 0, MPCC_TOP_SEL, dpp_id);
 	REG_SET(MPCC_OPP_ID[mpcc_id], 0, MPCC_OPP_ID, tree->opp_id);
 
+	/* Configure VUPDATE lock set for this MPCC to map to the OPP */
+	REG_SET(MPCC_UPDATE_LOCK_SEL[mpcc_id], 0, MPCC_UPDATE_LOCK_SEL, tree->opp_id);
+
 	/* update mpc tree mux setting */
 	if (tree->opp_list == insert_above_mpcc) {
 		/* insert the toppest mpcc */
@@ -318,6 +321,7 @@ void mpc1_remove_mpcc(
 		REG_SET(MPCC_TOP_SEL[mpcc_id], 0, MPCC_TOP_SEL, 0xf);
 		REG_SET(MPCC_BOT_SEL[mpcc_id], 0, MPCC_BOT_SEL, 0xf);
 		REG_SET(MPCC_OPP_ID[mpcc_id],  0, MPCC_OPP_ID,  0xf);
+		REG_SET(MPCC_UPDATE_LOCK_SEL[mpcc_id], 0, MPCC_UPDATE_LOCK_SEL, 0xf);
 
 		/* mark this mpcc as not in use */
 		mpc10->mpcc_in_use_mask &= ~(1 << mpcc_id);
@@ -328,6 +332,7 @@ void mpc1_remove_mpcc(
 		REG_SET(MPCC_TOP_SEL[mpcc_id], 0, MPCC_TOP_SEL, 0xf);
 		REG_SET(MPCC_BOT_SEL[mpcc_id], 0, MPCC_BOT_SEL, 0xf);
 		REG_SET(MPCC_OPP_ID[mpcc_id],  0, MPCC_OPP_ID,  0xf);
+		REG_SET(MPCC_UPDATE_LOCK_SEL[mpcc_id], 0, MPCC_UPDATE_LOCK_SEL, 0xf);
 	}
 }
 
@@ -361,6 +366,7 @@ void mpc1_mpc_init(struct mpc *mpc)
 		REG_SET(MPCC_TOP_SEL[mpcc_id], 0, MPCC_TOP_SEL, 0xf);
 		REG_SET(MPCC_BOT_SEL[mpcc_id], 0, MPCC_BOT_SEL, 0xf);
 		REG_SET(MPCC_OPP_ID[mpcc_id],  0, MPCC_OPP_ID,  0xf);
+		REG_SET(MPCC_UPDATE_LOCK_SEL[mpcc_id], 0, MPCC_UPDATE_LOCK_SEL, 0xf);
 
 		mpc1_init_mpcc(&(mpc->mpcc_array[mpcc_id]), mpcc_id);
 	}
@@ -381,6 +387,7 @@ void mpc1_mpc_init_single_inst(struct mpc *mpc, unsigned int mpcc_id)
 	REG_SET(MPCC_TOP_SEL[mpcc_id], 0, MPCC_TOP_SEL, 0xf);
 	REG_SET(MPCC_BOT_SEL[mpcc_id], 0, MPCC_BOT_SEL, 0xf);
 	REG_SET(MPCC_OPP_ID[mpcc_id],  0, MPCC_OPP_ID,  0xf);
+	REG_SET(MPCC_UPDATE_LOCK_SEL[mpcc_id], 0, MPCC_UPDATE_LOCK_SEL, 0xf);
 
 	mpc1_init_mpcc(&(mpc->mpcc_array[mpcc_id]), mpcc_id);
 
@@ -453,6 +460,13 @@ void mpc1_read_mpcc_state(
 			MPCC_BUSY, &s->busy);
 }
 
+void mpc1_cursor_lock(struct mpc *mpc, int opp_id, bool lock)
+{
+	struct dcn10_mpc *mpc10 = TO_DCN10_MPC(mpc);
+
+	REG_SET(CUR[opp_id], 0, CUR_VUPDATE_LOCK_SET, lock ? 1 : 0);
+}
+
 static const struct mpc_funcs dcn10_mpc_funcs = {
 	.read_mpcc_state = mpc1_read_mpcc_state,
 	.insert_plane = mpc1_insert_plane,
@@ -464,6 +478,7 @@ static const struct mpc_funcs dcn10_mpc_funcs = {
 	.assert_mpcc_idle_before_connect = mpc1_assert_mpcc_idle_before_connect,
 	.init_mpcc_list_from_hw = mpc1_init_mpcc_list_from_hw,
 	.update_blending = mpc1_update_blending,
+	.cursor_lock = mpc1_cursor_lock,
 	.set_denorm = NULL,
 	.set_denorm_clamp = NULL,
 	.set_output_csc = NULL,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.h
index 962a68e322ee..66a4719c22a0 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_mpc.h
@@ -39,11 +39,12 @@
 	SRII(MPCC_BG_G_Y, MPCC, inst),\
 	SRII(MPCC_BG_R_CR, MPCC, inst),\
 	SRII(MPCC_BG_B_CB, MPCC, inst),\
-	SRII(MPCC_BG_B_CB, MPCC, inst),\
-	SRII(MPCC_SM_CONTROL, MPCC, inst)
+	SRII(MPCC_SM_CONTROL, MPCC, inst),\
+	SRII(MPCC_UPDATE_LOCK_SEL, MPCC, inst)
 
 #define MPC_OUT_MUX_COMMON_REG_LIST_DCN1_0(inst) \
-	SRII(MUX, MPC_OUT, inst)
+	SRII(MUX, MPC_OUT, inst),\
+	VUPDATE_SRII(CUR, VUPDATE_LOCK_SET, inst)
 
 #define MPC_COMMON_REG_VARIABLE_LIST \
 	uint32_t MPCC_TOP_SEL[MAX_MPCC]; \
@@ -55,7 +56,9 @@
 	uint32_t MPCC_BG_R_CR[MAX_MPCC]; \
 	uint32_t MPCC_BG_B_CB[MAX_MPCC]; \
 	uint32_t MPCC_SM_CONTROL[MAX_MPCC]; \
-	uint32_t MUX[MAX_OPP];
+	uint32_t MUX[MAX_OPP]; \
+	uint32_t MPCC_UPDATE_LOCK_SEL[MAX_MPCC]; \
+	uint32_t CUR[MAX_OPP];
 
 #define MPC_COMMON_MASK_SH_LIST_DCN1_0(mask_sh)\
 	SF(MPCC0_MPCC_TOP_SEL, MPCC_TOP_SEL, mask_sh),\
@@ -78,7 +81,8 @@
 	SF(MPCC0_MPCC_SM_CONTROL, MPCC_SM_FIELD_ALT, mask_sh),\
 	SF(MPCC0_MPCC_SM_CONTROL, MPCC_SM_FORCE_NEXT_FRAME_POL, mask_sh),\
 	SF(MPCC0_MPCC_SM_CONTROL, MPCC_SM_FORCE_NEXT_TOP_POL, mask_sh),\
-	SF(MPC_OUT0_MUX, MPC_OUT_MUX, mask_sh)
+	SF(MPC_OUT0_MUX, MPC_OUT_MUX, mask_sh),\
+	SF(MPCC0_MPCC_UPDATE_LOCK_SEL, MPCC_UPDATE_LOCK_SEL, mask_sh)
 
 #define MPC_REG_FIELD_LIST(type) \
 	type MPCC_TOP_SEL;\
@@ -101,7 +105,9 @@
 	type MPCC_SM_FIELD_ALT;\
 	type MPCC_SM_FORCE_NEXT_FRAME_POL;\
 	type MPCC_SM_FORCE_NEXT_TOP_POL;\
-	type MPC_OUT_MUX;
+	type MPC_OUT_MUX;\
+	type MPCC_UPDATE_LOCK_SEL;\
+	type CUR_VUPDATE_LOCK_SET;
 
 struct dcn_mpc_registers {
 	MPC_COMMON_REG_VARIABLE_LIST
@@ -192,4 +198,6 @@ void mpc1_read_mpcc_state(
 		int mpcc_inst,
 		struct mpcc_state *s);
 
+void mpc1_cursor_lock(struct mpc *mpc, int opp_id, bool lock);
+
 #endif
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
index 3b71898e859e..e3c4c06ac191 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_resource.c
@@ -181,6 +181,14 @@ enum dcn10_clk_src_array_id {
 	.reg_name[id] = BASE(mm ## block ## id ## _ ## reg_name ## _BASE_IDX) + \
 					mm ## block ## id ## _ ## reg_name
 
+#define VUPDATE_SRII(reg_name, block, id)\
+	.reg_name[id] = BASE(mm ## reg_name ## 0 ## _ ## block ## id ## _BASE_IDX) + \
+					mm ## reg_name ## 0 ## _ ## block ## id
+
+/* set field/register/bitfield name */
+#define SFRB(field_name, reg_name, bitfield, post_fix)\
+	.field_name = reg_name ## __ ## bitfield ## post_fix
+
 /* NBIO */
 #define NBIO_BASE_INNER(seg) \
 	NBIF_BASE__INST0_SEG ## seg
@@ -419,11 +427,13 @@ static const struct dcn_mpc_registers mpc_regs = {
 };
 
 static const struct dcn_mpc_shift mpc_shift = {
-	MPC_COMMON_MASK_SH_LIST_DCN1_0(__SHIFT)
+	MPC_COMMON_MASK_SH_LIST_DCN1_0(__SHIFT),\
+	SFRB(CUR_VUPDATE_LOCK_SET, CUR0_VUPDATE_LOCK_SET0, CUR0_VUPDATE_LOCK_SET, __SHIFT)
 };
 
 static const struct dcn_mpc_mask mpc_mask = {
-	MPC_COMMON_MASK_SH_LIST_DCN1_0(_MASK),
+	MPC_COMMON_MASK_SH_LIST_DCN1_0(_MASK),\
+	SFRB(CUR_VUPDATE_LOCK_SET, CUR0_VUPDATE_LOCK_SET0, CUR0_VUPDATE_LOCK_SET, _MASK)
 };
 
 #define tg_regs(id)\
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
index 1642bf546ceb..0cae0c2f84c4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_init.c
@@ -52,6 +52,7 @@ static const struct hw_sequencer_funcs dcn20_funcs = {
 	.disable_plane = dcn20_disable_plane,
 	.pipe_control_lock = dcn20_pipe_control_lock,
 	.interdependent_update_lock = dcn10_lock_all_pipes,
+	.cursor_lock = dcn10_cursor_lock,
 	.prepare_bandwidth = dcn20_prepare_bandwidth,
 	.optimize_bandwidth = dcn20_optimize_bandwidth,
 	.update_bandwidth = dcn20_update_bandwidth,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c
index de9c857ab3e9..570dfd9a243f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.c
@@ -545,6 +545,7 @@ const struct mpc_funcs dcn20_mpc_funcs = {
 	.mpc_init = mpc1_mpc_init,
 	.mpc_init_single_inst = mpc1_mpc_init_single_inst,
 	.update_blending = mpc2_update_blending,
+	.cursor_lock = mpc1_cursor_lock,
 	.get_mpcc_for_dpp = mpc2_get_mpcc_for_dpp,
 	.wait_for_idle = mpc2_assert_idle_mpcc,
 	.assert_mpcc_idle_before_connect = mpc2_assert_mpcc_idle_before_connect,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.h b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.h
index c78fd5123497..496658f420db 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_mpc.h
@@ -179,7 +179,8 @@
 	SF(MPC_OUT0_DENORM_CLAMP_G_Y, MPC_OUT_DENORM_CLAMP_MAX_G_Y, mask_sh),\
 	SF(MPC_OUT0_DENORM_CLAMP_G_Y, MPC_OUT_DENORM_CLAMP_MIN_G_Y, mask_sh),\
 	SF(MPC_OUT0_DENORM_CLAMP_B_CB, MPC_OUT_DENORM_CLAMP_MAX_B_CB, mask_sh),\
-	SF(MPC_OUT0_DENORM_CLAMP_B_CB, MPC_OUT_DENORM_CLAMP_MIN_B_CB, mask_sh)
+	SF(MPC_OUT0_DENORM_CLAMP_B_CB, MPC_OUT_DENORM_CLAMP_MIN_B_CB, mask_sh),\
+	SF(CUR_VUPDATE_LOCK_SET0, CUR_VUPDATE_LOCK_SET, mask_sh)
 
 /*
  *	DCN2 MPC_OCSC debug status register:
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 1b0bca9587d0..1ba47f3a6857 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -506,6 +506,10 @@ enum dcn20_clk_src_array_id {
 	.block ## _ ## reg_name[id] = BASE(mm ## block ## id ## _ ## reg_name ## _BASE_IDX) + \
 					mm ## block ## id ## _ ## reg_name
 
+#define VUPDATE_SRII(reg_name, block, id)\
+	.reg_name[id] = BASE(mm ## reg_name ## _ ## block ## id ## _BASE_IDX) + \
+					mm ## reg_name ## _ ## block ## id
+
 /* NBIO */
 #define NBIO_BASE_INNER(seg) \
 	NBIO_BASE__INST0_SEG ## seg
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
index 8b91445389df..8fe8ec7c0882 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_init.c
@@ -53,6 +53,7 @@ static const struct hw_sequencer_funcs dcn21_funcs = {
 	.disable_plane = dcn20_disable_plane,
 	.pipe_control_lock = dcn20_pipe_control_lock,
 	.interdependent_update_lock = dcn10_lock_all_pipes,
+	.cursor_lock = dcn10_cursor_lock,
 	.prepare_bandwidth = dcn20_prepare_bandwidth,
 	.optimize_bandwidth = dcn20_optimize_bandwidth,
 	.update_bandwidth = dcn20_update_bandwidth,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index 122d3e734c59..5286cc7d1261 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -306,6 +306,10 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_1_soc = {
 	.block ## _ ## reg_name[id] = BASE(mm ## block ## id ## _ ## reg_name ## _BASE_IDX) + \
 					mm ## block ## id ## _ ## reg_name
 
+#define VUPDATE_SRII(reg_name, block, id)\
+	.reg_name[id] = BASE(mm ## reg_name ## _ ## block ## id ## _BASE_IDX) + \
+					mm ## reg_name ## _ ## block ## id
+
 /* NBIO */
 #define NBIO_BASE_INNER(seg) \
 	NBIF0_BASE__INST0_SEG ## seg
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h b/drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h
index 094afc4c8173..50ee8aa7ec3b 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/mpc.h
@@ -210,6 +210,22 @@ struct mpc_funcs {
 		struct mpcc_blnd_cfg *blnd_cfg,
 		int mpcc_id);
 
+	/*
+	 * Lock cursor updates for the specified OPP.
+	 * OPP defines the set of MPCC that are locked together for cursor.
+	 *
+	 * Parameters:
+	 * [in] 	mpc		- MPC context.
+	 * [in]     opp_id	- The OPP to lock cursor updates on
+	 * [in]		lock	- lock/unlock the OPP
+	 *
+	 * Return:  void
+	 */
+	void (*cursor_lock)(
+			struct mpc *mpc,
+			int opp_id,
+			bool lock);
+
 	struct mpcc* (*get_mpcc_for_dpp)(
 			struct mpc_tree *tree,
 			int dpp_id);
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index d4c1fb242c63..e57467d99d66 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -86,6 +86,7 @@ struct hw_sequencer_funcs {
 			struct dc_state *context, bool lock);
 	void (*set_flip_control_gsl)(struct pipe_ctx *pipe_ctx,
 			bool flip_immediate);
+	void (*cursor_lock)(struct dc *dc, struct pipe_ctx *pipe, bool lock);
 
 	/* Timing Related */
 	void (*get_position)(struct pipe_ctx **pipe_ctx, int num_pipes,
-- 
2.25.1



