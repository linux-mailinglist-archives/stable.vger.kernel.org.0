Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C44F6CC288
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbjC1OqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbjC1OqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DE8CC32
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:45:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54C6B6181D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A0DC433EF;
        Tue, 28 Mar 2023 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014740;
        bh=24mkFbCUIXECyTzZL+0rLx5b5fymqAVu66TJ/KOYf/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEALRDkvES13AshFuqd25xdgY0xfO4GEuN9R5760tM8yqdWKvh1xUtQ0MBDlmLeFO
         3Mz9yOmtv9Za7Qj+PADqBJT42Ims2+zB40iF9q+3frOtcwTaS7mdAtHtXbu4/yB8dm
         +f1DR/22MEP8JO7UO/o54Xuu1bvac8S+694jDryY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alvin Lee <Alvin.Lee2@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 007/240] drm/amd/display: fix k1 k2 divider programming for phantom streams
Date:   Tue, 28 Mar 2023 16:39:30 +0200
Message-Id: <20230328142619.959314875@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 3b214bb7185d8284d7d4c53e15127f69a375abf6 ]

[Why & How]
When k1 and k2 divider programming logic is executed for a phantom
stream, the corresponding master stream should be used for the
calculation. Fix the if condition to use the master stream for checking
signal type instead of the phantom stream.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 709671ffb15d ("drm/amd/display: Remove OTG DIV register write for Virtual signals.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index b8767be1e4c55..e119f4f76fdc8 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1178,13 +1178,13 @@ unsigned int dcn32_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsign
 	if (is_dp_128b_132b_signal(pipe_ctx)) {
 		*k1_div = PIXEL_RATE_DIV_BY_1;
 		*k2_div = PIXEL_RATE_DIV_BY_1;
-	} else if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal) || dc_is_dvi_signal(pipe_ctx->stream->signal)) {
+	} else if (dc_is_hdmi_tmds_signal(stream->signal) || dc_is_dvi_signal(stream->signal)) {
 		*k1_div = PIXEL_RATE_DIV_BY_1;
 		if (stream->timing.pixel_encoding == PIXEL_ENCODING_YCBCR420)
 			*k2_div = PIXEL_RATE_DIV_BY_2;
 		else
 			*k2_div = PIXEL_RATE_DIV_BY_4;
-	} else if (dc_is_dp_signal(pipe_ctx->stream->signal) || dc_is_virtual_signal(pipe_ctx->stream->signal)) {
+	} else if (dc_is_dp_signal(stream->signal) || dc_is_virtual_signal(stream->signal)) {
 		if (two_pix_per_container) {
 			*k1_div = PIXEL_RATE_DIV_BY_1;
 			*k2_div = PIXEL_RATE_DIV_BY_2;
-- 
2.39.2



