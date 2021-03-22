Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8630E344117
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCVMai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230229AbhCVMaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2C5C6198D;
        Mon, 22 Mar 2021 12:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416223;
        bh=UxZLv/gtj3D/RylHe0RM7hakEhX/5E0MhNK3QdRNp9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhTKDH7j6thZF690X9/o2yazxM+LqwJY9+249f1gvj40Rp8JoaGOpah2xVoHxPSDS
         UNIAJDUheHVLDDvrszyDea5Jy9oluZqPyXS0haQFoNO/LIdxWZIoTncQ0YZhMRDU6i
         me3uDJTyshvZJ0R5m1rgYxtQ9wdZ3E04oDJ+TraY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Dillon Varone <dillon.varone@amd.com>,
        Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 025/120] drm/amd/display: Remove MPC gamut remap logic for DCN30
Date:   Mon, 22 Mar 2021 13:26:48 +0100
Message-Id: <20210322121930.499376187@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Varone <dillon.varone@amd.com>

commit beb6b2f97e0a02164c7f0df6e08c49219cfc2b80 upstream.

[Why?]
Should only reroute gamut remap to mpc unless 3D LUT is not used and all
planes are using the same src->dest.

[How?]
Remove DCN30 specific logic for rerouting gamut remap to mpc.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1513
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Reviewed-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Acked-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   34 +--------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1501,38 +1501,8 @@ static void dcn20_update_dchubp_dpp(
 	if (pipe_ctx->update_flags.bits.enable || pipe_ctx->update_flags.bits.opp_changed
 			|| pipe_ctx->stream->update_flags.bits.gamut_remap
 			|| pipe_ctx->stream->update_flags.bits.out_csc) {
-		struct mpc *mpc = pipe_ctx->stream_res.opp->ctx->dc->res_pool->mpc;
-
-		if (mpc->funcs->set_gamut_remap) {
-			int i;
-			int mpcc_id = hubp->inst;
-			struct mpc_grph_gamut_adjustment adjust;
-			bool enable_remap_dpp = false;
-
-			memset(&adjust, 0, sizeof(adjust));
-			adjust.gamut_adjust_type = GRAPHICS_GAMUT_ADJUST_TYPE_BYPASS;
-
-			/* save the enablement of gamut remap for dpp */
-			enable_remap_dpp = pipe_ctx->stream->gamut_remap_matrix.enable_remap;
-
-			/* force bypass gamut remap for dpp/cm */
-			pipe_ctx->stream->gamut_remap_matrix.enable_remap = false;
-			dc->hwss.program_gamut_remap(pipe_ctx);
-
-			/* restore gamut remap flag and use this remap into mpc */
-			pipe_ctx->stream->gamut_remap_matrix.enable_remap = enable_remap_dpp;
-
-			/* build remap matrix for top plane if enabled */
-			if (enable_remap_dpp && pipe_ctx->top_pipe == NULL) {
-					adjust.gamut_adjust_type = GRAPHICS_GAMUT_ADJUST_TYPE_SW;
-					for (i = 0; i < CSC_TEMPERATURE_MATRIX_SIZE; i++)
-						adjust.temperature_matrix[i] =
-								pipe_ctx->stream->gamut_remap_matrix.matrix[i];
-			}
-			mpc->funcs->set_gamut_remap(mpc, mpcc_id, &adjust);
-		} else
-			/* dpp/cm gamut remap*/
-			dc->hwss.program_gamut_remap(pipe_ctx);
+		/* dpp/cm gamut remap*/
+		dc->hwss.program_gamut_remap(pipe_ctx);
 
 		/*call the dcn2 method which uses mpc csc*/
 		dc->hwss.program_output_csc(dc,


