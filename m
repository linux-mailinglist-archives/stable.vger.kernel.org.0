Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374FD34C9CD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhC2Idw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233798AbhC2Ib0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:31:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AABB2619EC;
        Mon, 29 Mar 2021 08:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006684;
        bh=5Fawb5tvwtCZz6TUKFkS6upUocIjlFAgmfnWDk2K0CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsoUe7ZTgcSOyQL7xXcn5BIzUwI4HX9mpqbMfY9M4bK0RU85tPzpJrvv8NVqOLl5k
         Az+kaw8lgtpYtStavd/97n+ZY6OIePFGqnpLVtkZ+bidLzQxlpMrdXoh+ONOohVF1Y
         etX7ji4sU6gf/xOPDwRk7p7nIIbgXRcfgdWgYDGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 043/254] drm/amd/display: Enable pflip interrupt upon pipe enable
Date:   Mon, 29 Mar 2021 09:55:59 +0200
Message-Id: <20210329075634.571796492@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

[ Upstream commit 7afa0033d6f7fb8a84798ef99d1117661c4e696c ]

[Why]
pflip interrupt would not be enabled promptly if a pipe is disabled
and re-enabled, causing flip_done timeout error during DP
compliance tests

[How]
Enable pflip interrupt upon pipe enablement

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c     |  1 +
 drivers/gpu/drm/amd/display/dc/dc.h                   |  1 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c     | 11 +++++++++++
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.h     |  6 ++++++
 .../gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c |  7 +++++++
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c     |  1 +
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c    |  6 ++++++
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c     |  1 +
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c     |  1 +
 drivers/gpu/drm/amd/display/dc/inc/hw/hubp.h          |  2 ++
 10 files changed, 37 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1d26e82602f7..ad4afbc37d51 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4616,6 +4616,7 @@ static int fill_dc_plane_attributes(struct amdgpu_device *adev,
 	dc_plane_state->global_alpha_value = plane_info.global_alpha_value;
 	dc_plane_state->dcc = plane_info.dcc;
 	dc_plane_state->layer_index = plane_info.layer_index; // Always returns 0
+	dc_plane_state->flip_int_enabled = true;
 
 	/*
 	 * Always set input transfer function, since plane state is refreshed
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 3aedadb34548..414b44b4ced4 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -889,6 +889,7 @@ struct dc_plane_state {
 	int layer_index;
 
 	union surface_update_flags update_flags;
+	bool flip_int_enabled;
 	/* private to DC core */
 	struct dc_plane_status status;
 	struct dc_context *ctx;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
index 9e796dfeac20..714c71a5fbde 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c
@@ -1257,6 +1257,16 @@ void hubp1_soft_reset(struct hubp *hubp, bool reset)
 	REG_UPDATE(DCHUBP_CNTL, HUBP_DISABLE, reset ? 1 : 0);
 }
 
+void hubp1_set_flip_int(struct hubp *hubp)
+{
+	struct dcn10_hubp *hubp1 = TO_DCN10_HUBP(hubp);
+
+	REG_UPDATE(DCSURF_SURFACE_FLIP_INTERRUPT,
+		SURFACE_FLIP_INT_MASK, 1);
+
+	return;
+}
+
 void hubp1_init(struct hubp *hubp)
 {
 	//do nothing
@@ -1290,6 +1300,7 @@ static const struct hubp_funcs dcn10_hubp_funcs = {
 	.dmdata_load = NULL,
 	.hubp_soft_reset = hubp1_soft_reset,
 	.hubp_in_blank = hubp1_in_blank,
+	.hubp_set_flip_int = hubp1_set_flip_int,
 };
 
 /*****************************************/
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.h
index a9a6ed7f4f99..e2f2f6995935 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.h
@@ -74,6 +74,7 @@
 	SRI(DCSURF_SURFACE_EARLIEST_INUSE_C, HUBPREQ, id),\
 	SRI(DCSURF_SURFACE_EARLIEST_INUSE_HIGH_C, HUBPREQ, id),\
 	SRI(DCSURF_SURFACE_CONTROL, HUBPREQ, id),\
+	SRI(DCSURF_SURFACE_FLIP_INTERRUPT, HUBPREQ, id),\
 	SRI(HUBPRET_CONTROL, HUBPRET, id),\
 	SRI(DCN_EXPANSION_MODE, HUBPREQ, id),\
 	SRI(DCHUBP_REQ_SIZE_CONFIG, HUBP, id),\
@@ -183,6 +184,7 @@
 	uint32_t DCSURF_SURFACE_EARLIEST_INUSE_C; \
 	uint32_t DCSURF_SURFACE_EARLIEST_INUSE_HIGH_C; \
 	uint32_t DCSURF_SURFACE_CONTROL; \
+	uint32_t DCSURF_SURFACE_FLIP_INTERRUPT; \
 	uint32_t HUBPRET_CONTROL; \
 	uint32_t DCN_EXPANSION_MODE; \
 	uint32_t DCHUBP_REQ_SIZE_CONFIG; \
@@ -332,6 +334,7 @@
 	HUBP_SF(HUBPREQ0_DCSURF_SURFACE_CONTROL, SECONDARY_META_SURFACE_TMZ_C, mask_sh),\
 	HUBP_SF(HUBPREQ0_DCSURF_SURFACE_CONTROL, SECONDARY_SURFACE_DCC_EN, mask_sh),\
 	HUBP_SF(HUBPREQ0_DCSURF_SURFACE_CONTROL, SECONDARY_SURFACE_DCC_IND_64B_BLK, mask_sh),\
+	HUBP_SF(HUBPREQ0_DCSURF_SURFACE_FLIP_INTERRUPT, SURFACE_FLIP_INT_MASK, mask_sh),\
 	HUBP_SF(HUBPRET0_HUBPRET_CONTROL, DET_BUF_PLANE1_BASE_ADDRESS, mask_sh),\
 	HUBP_SF(HUBPRET0_HUBPRET_CONTROL, CROSSBAR_SRC_CB_B, mask_sh),\
 	HUBP_SF(HUBPRET0_HUBPRET_CONTROL, CROSSBAR_SRC_CR_R, mask_sh),\
@@ -531,6 +534,7 @@
 	type PRIMARY_SURFACE_DCC_IND_64B_BLK;\
 	type SECONDARY_SURFACE_DCC_EN;\
 	type SECONDARY_SURFACE_DCC_IND_64B_BLK;\
+	type SURFACE_FLIP_INT_MASK;\
 	type DET_BUF_PLANE1_BASE_ADDRESS;\
 	type CROSSBAR_SRC_CB_B;\
 	type CROSSBAR_SRC_CR_R;\
@@ -777,4 +781,6 @@ void hubp1_read_state_common(struct hubp *hubp);
 bool hubp1_in_blank(struct hubp *hubp);
 void hubp1_soft_reset(struct hubp *hubp, bool reset);
 
+void hubp1_set_flip_int(struct hubp *hubp);
+
 #endif
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 017b67b830e6..3e86e042de0d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -2195,6 +2195,13 @@ static void dcn10_enable_plane(
 	if (dc->debug.sanity_checks) {
 		hws->funcs.verify_allow_pstate_change_high(dc);
 	}
+
+	if (!pipe_ctx->top_pipe
+		&& pipe_ctx->plane_state
+		&& pipe_ctx->plane_state->flip_int_enabled
+		&& pipe_ctx->plane_res.hubp->funcs->hubp_set_flip_int)
+			pipe_ctx->plane_res.hubp->funcs->hubp_set_flip_int(pipe_ctx->plane_res.hubp);
+
 }
 
 void dcn10_program_gamut_remap(struct pipe_ctx *pipe_ctx)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c
index 0df0da2e6a4d..bec7059f6d5d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c
@@ -1597,6 +1597,7 @@ static struct hubp_funcs dcn20_hubp_funcs = {
 	.validate_dml_output = hubp2_validate_dml_output,
 	.hubp_in_blank = hubp1_in_blank,
 	.hubp_soft_reset = hubp1_soft_reset,
+	.hubp_set_flip_int = hubp1_set_flip_int,
 };
 
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 09b9732424e1..077ba9cf69c5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1146,6 +1146,12 @@ void dcn20_enable_plane(
 		pipe_ctx->plane_res.hubp->funcs->hubp_set_vm_system_aperture_settings(pipe_ctx->plane_res.hubp, &apt);
 	}
 
+	if (!pipe_ctx->top_pipe
+		&& pipe_ctx->plane_state
+		&& pipe_ctx->plane_state->flip_int_enabled
+		&& pipe_ctx->plane_res.hubp->funcs->hubp_set_flip_int)
+			pipe_ctx->plane_res.hubp->funcs->hubp_set_flip_int(pipe_ctx->plane_res.hubp);
+
 //	if (dc->debug.sanity_checks) {
 //		dcn10_verify_allow_pstate_change_high(dc);
 //	}
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c
index f9045852728f..b0c9180b808f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c
@@ -838,6 +838,7 @@ static struct hubp_funcs dcn21_hubp_funcs = {
 	.hubp_set_flip_control_surface_gsl = hubp2_set_flip_control_surface_gsl,
 	.hubp_init = hubp21_init,
 	.validate_dml_output = hubp21_validate_dml_output,
+	.hubp_set_flip_int = hubp1_set_flip_int,
 };
 
 bool hubp21_construct(
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c
index 88ffa9ff1ed1..f24612523248 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hubp.c
@@ -511,6 +511,7 @@ static struct hubp_funcs dcn30_hubp_funcs = {
 	.hubp_init = hubp3_init,
 	.hubp_in_blank = hubp1_in_blank,
 	.hubp_soft_reset = hubp1_soft_reset,
+	.hubp_set_flip_int = hubp1_set_flip_int,
 };
 
 bool hubp3_construct(
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/hubp.h b/drivers/gpu/drm/amd/display/dc/inc/hw/hubp.h
index 22f3f643ed1b..346dcd87dc10 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/hubp.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/hubp.h
@@ -191,6 +191,8 @@ struct hubp_funcs {
 	bool (*hubp_in_blank)(struct hubp *hubp);
 	void (*hubp_soft_reset)(struct hubp *hubp, bool reset);
 
+	void (*hubp_set_flip_int)(struct hubp *hubp);
+
 };
 
 #endif
-- 
2.30.1



