Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48BC650156
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiLRQ2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiLRQ1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:27:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C98CC74E;
        Sun, 18 Dec 2022 08:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2D1760C99;
        Sun, 18 Dec 2022 16:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E460C433D2;
        Sun, 18 Dec 2022 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379808;
        bh=scAjh5f8FKUHPUIaZJCpBxjtgn9vl/P0GaSN3HR+cwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwNTZgIFAQoliuf77jm4sursZHCaJfvWkxNxCF05847NUaxnwOivA6shnrnEuyikO
         EN/DvJi2trT9avk6A2vMa6kTgKqBnZPdXv0+ZNM3raZBGV5qhB6JWwFlbRKHdV+8G3
         7dxL2m+LPH4kL373jofqMipr6d+G/F+TEAYNdkA5qeMrn+/gzErGLGpzT3JsXKocvI
         zngUR/HTS6cmy4QFDno1PRHfJ6WjlxaqBIwxHiCG1O7Cc88u0p60T0vCxK26wVMRLc
         D0CjNwjM+LNNKH9v6rcRX3xmGoTSpp1uuhoNt+/GHc5a6EllQuWzl5gUEl0rlBejzR
         4/Gti3muUMm1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Shen <george.shen@amd.com>, Alvin Lee <Alvin.Lee2@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, jun.lei@amd.com, Dillon.Varone@amd.com,
        samson.tam@amd.com, rdunlap@infradead.org, David.Galiffi@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 39/73] drm/amd/display: Workaround to increase phantom pipe vactive in pipesplit
Date:   Sun, 18 Dec 2022 11:07:07 -0500
Message-Id: <20221218160741.927862-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
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

From: George Shen <george.shen@amd.com>

[ Upstream commit 5b8f9deaf3b6badfc0da968e6e07ceabd19700b6 ]

[Why]
Certain high resolution displays exhibit DCC line corruption with SubVP
enabled. This is likely due to insufficient DCC meta data buffered
immediately after the mclk switch.

[How]
Add workaround to increase phantom pipe vactive height by
meta_row_height number of lines, thus increasing the amount of meta data
buffered immediately after mclk switch finishes.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 07c56e231b04..d05df4f7139f 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -485,9 +485,11 @@ void dcn32_set_phantom_stream_timing(struct dc *dc,
 	unsigned int i, pipe_idx;
 	struct pipe_ctx *pipe;
 	uint32_t phantom_vactive, phantom_bp, pstate_width_fw_delay_lines;
+	unsigned int num_dpp;
 	unsigned int vlevel = context->bw_ctx.dml.vba.VoltageLevel;
 	unsigned int dcfclk = context->bw_ctx.dml.vba.DCFCLKState[vlevel][context->bw_ctx.dml.vba.maxMpcComb];
 	unsigned int socclk = context->bw_ctx.dml.vba.SOCCLKPerState[vlevel];
+	struct vba_vars_st *vba = &context->bw_ctx.dml.vba;
 
 	dc_assert_fp_enabled();
 
@@ -523,6 +525,11 @@ void dcn32_set_phantom_stream_timing(struct dc *dc,
 	phantom_vactive = get_subviewport_lines_needed_in_mall(&context->bw_ctx.dml, pipes, pipe_cnt, pipe_idx) +
 				pstate_width_fw_delay_lines + dc->caps.subvp_swath_height_margin_lines;
 
+	// W/A for DCC corruption with certain high resolution timings.
+	// Determing if pipesplit is used. If so, add meta_row_height to the phantom vactive.
+	num_dpp = vba->NoOfDPP[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]];
+	phantom_vactive += num_dpp > 1 ? vba->meta_row_height[vba->pipe_plane[pipe_idx]] : 0;
+
 	// For backporch of phantom pipe, use vstartup of the main pipe
 	phantom_bp = get_vstartup(&context->bw_ctx.dml, pipes, pipe_cnt, pipe_idx);
 
-- 
2.35.1

