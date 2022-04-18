Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F739505309
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbiDRMzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240240AbiDRMyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:54:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF18B12ABA;
        Mon, 18 Apr 2022 05:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF0D0611A9;
        Mon, 18 Apr 2022 12:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F49C385A7;
        Mon, 18 Apr 2022 12:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285298;
        bh=pJfrW3zZPhq6NUsLDJ0MlaigPRNzH9Yv9ppEgEo0WAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQ7L2K/UhbGLjQlOxZDALj9E2dTGI0X9yTKq2F2wjsXf15EAv0BkJN4WIlj1DxojG
         ndLjPqQOY3od9rD8680Ncxawm6EEdkIiOOtthJmeMb7CLOmNplQMC/ntsU9LIiYEZ9
         OSyni5upGGqozEL+P/hVdlkBUVp5/Lonuwen/VVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Melissa Wen <mwen@igalia.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Simon Ser <contact@emersion.fr>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 163/189] drm/amd/display: dont ignore alpha property on pre-multiplied mode
Date:   Mon, 18 Apr 2022 14:13:03 +0200
Message-Id: <20220418121207.012373130@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Melissa Wen <mwen@igalia.com>

commit e4f1541caf60fcbe5a59e9d25805c0b5865e546a upstream.

"Pre-multiplied" is the default pixel blend mode for KMS/DRM, as
documented in supported_modes of drm_plane_create_blend_mode_property():
https://cgit.freedesktop.org/drm/drm-misc/tree/drivers/gpu/drm/drm_blend.c

In this mode, both 'pixel alpha' and 'plane alpha' participate in the
calculation, as described by the pixel blend mode formula in KMS/DRM
documentation:

out.rgb = plane_alpha * fg.rgb +
          (1 - (plane_alpha * fg.alpha)) * bg.rgb

Considering the blend config mechanisms we have in the driver so far,
the alpha mode that better fits this blend mode is the
_PER_PIXEL_ALPHA_COMBINED_GLOBAL_GAIN, where the value for global_gain
is the plane alpha (global_alpha).

With this change, alpha property stops to be ignored. It also addresses
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1734

v2:
 * keep the 8-bit value for global_alpha_value (Nicholas)
 * correct the logical ordering for combined global gain (Nicholas)
 * apply to dcn10 too (Nicholas)

Signed-off-by: Melissa Wen <mwen@igalia.com>
Tested-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Simon Ser <contact@emersion.fr>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c |   14 +++++++++-----
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c        |   14 +++++++++-----
 2 files changed, 18 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -2460,14 +2460,18 @@ void dcn10_update_mpcc(struct dc *dc, st
 	struct mpc *mpc = dc->res_pool->mpc;
 	struct mpc_tree *mpc_tree_params = &(pipe_ctx->stream_res.opp->mpc_tree_params);
 
-	if (per_pixel_alpha)
-		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA;
-	else
-		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_GLOBAL_ALPHA;
-
 	blnd_cfg.overlap_only = false;
 	blnd_cfg.global_gain = 0xff;
 
+	if (per_pixel_alpha && pipe_ctx->plane_state->global_alpha) {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA_COMBINED_GLOBAL_GAIN;
+		blnd_cfg.global_gain = pipe_ctx->plane_state->global_alpha_value;
+	} else if (per_pixel_alpha) {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA;
+	} else {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_GLOBAL_ALPHA;
+	}
+
 	if (pipe_ctx->plane_state->global_alpha)
 		blnd_cfg.global_alpha = pipe_ctx->plane_state->global_alpha_value;
 	else
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -2297,14 +2297,18 @@ void dcn20_update_mpcc(struct dc *dc, st
 	struct mpc *mpc = dc->res_pool->mpc;
 	struct mpc_tree *mpc_tree_params = &(pipe_ctx->stream_res.opp->mpc_tree_params);
 
-	if (per_pixel_alpha)
-		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA;
-	else
-		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_GLOBAL_ALPHA;
-
 	blnd_cfg.overlap_only = false;
 	blnd_cfg.global_gain = 0xff;
 
+	if (per_pixel_alpha && pipe_ctx->plane_state->global_alpha) {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA_COMBINED_GLOBAL_GAIN;
+		blnd_cfg.global_gain = pipe_ctx->plane_state->global_alpha_value;
+	} else if (per_pixel_alpha) {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_PER_PIXEL_ALPHA;
+	} else {
+		blnd_cfg.alpha_mode = MPCC_ALPHA_BLEND_MODE_GLOBAL_ALPHA;
+	}
+
 	if (pipe_ctx->plane_state->global_alpha)
 		blnd_cfg.global_alpha = pipe_ctx->plane_state->global_alpha_value;
 	else


