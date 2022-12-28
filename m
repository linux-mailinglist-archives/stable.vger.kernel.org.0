Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C976965844C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiL1Q4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbiL1Qzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:55:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A11B491
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:50:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E544B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA5FC433EF;
        Wed, 28 Dec 2022 16:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246247;
        bh=zMN0JpNGVOLNjuMgyWyYnkzVk1/TzmYVAsYau57Uow4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nalTqNyfbB3+HGYI+kfGasoVRTkGiwNqhIwvuaUejAqBJcKC7U9YdbkAWKfyVzTju
         izcdkg2+0HRfmpwc4ConlJAtTgArCERF1zbc3kRmSZZ3PsBoVz1FSiK2k+YZWc5bPc
         2VGvzeErJtAkx6b8rvjubXf68+wPmTQDIjTZM5eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alvin Lee <Alvin.Lee2@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        George Shen <george.shen@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1009/1146] drm/amd/display: Workaround to increase phantom pipe vactive in pipesplit
Date:   Wed, 28 Dec 2022 15:42:28 +0100
Message-Id: <20221228144357.775129043@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2abe3967f7fb..d1bf49d207de 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -531,9 +531,11 @@ void dcn32_set_phantom_stream_timing(struct dc *dc,
 	unsigned int i, pipe_idx;
 	struct pipe_ctx *pipe;
 	uint32_t phantom_vactive, phantom_bp, pstate_width_fw_delay_lines;
+	unsigned int num_dpp;
 	unsigned int vlevel = context->bw_ctx.dml.vba.VoltageLevel;
 	unsigned int dcfclk = context->bw_ctx.dml.vba.DCFCLKState[vlevel][context->bw_ctx.dml.vba.maxMpcComb];
 	unsigned int socclk = context->bw_ctx.dml.vba.SOCCLKPerState[vlevel];
+	struct vba_vars_st *vba = &context->bw_ctx.dml.vba;
 
 	dc_assert_fp_enabled();
 
@@ -569,6 +571,11 @@ void dcn32_set_phantom_stream_timing(struct dc *dc,
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



