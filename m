Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AEDC64A14F
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiLLNiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiLLNhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:37:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF5613F1E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:37:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4441EB80D2B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB01C433D2;
        Mon, 12 Dec 2022 13:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852231;
        bh=+jeoKhMCkpT4hn7N4p82uMxd1KjE2kJWwyTuu2+7Vlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJ7NdQYJEMgabI0/KgfS/YQVSTumkxq0npLN/wq5ti3gA2Eqf0k7JmPNsntwV2i9d
         HVZrjUFWyzBoMXv3n9PwfYz/n8CSMF1CfvSLHwHQMdLN288KM5JRXry4KYR9ZdxXas
         wa5XFee2V07atI7Mz8ELv0z7uUZawzZY0wrQ1zGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Brian Chang <Brian.Chang@amd.com>,
        Taimur Hassan <Syed.Hassan@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 039/157] drm/amd/display: Avoid setting pixel rate divider to N/A
Date:   Mon, 12 Dec 2022 14:16:27 +0100
Message-Id: <20221212130936.105799251@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Taimur Hassan <Syed.Hassan@amd.com>

[ Upstream commit 2a5dd86a69ea5435f1a837bdb7fafcda609a7c91 ]

[Why]
Pixel rate divider values should never be set to N/A (0xF) as the K1/K2
field is only 1/2 bits wide.

[How]
Set valid divider values for virtual and FRL/DP2 cases.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Taimur Hassan <Syed.Hassan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c  | 7 +++++++
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c    | 4 +++-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c   | 1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
index fb729674953b..de9fa534b77a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_dccg.c
@@ -96,6 +96,13 @@ static void dccg314_set_pixel_rate_div(
 	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
 	enum pixel_rate_div cur_k1 = PIXEL_RATE_DIV_NA, cur_k2 = PIXEL_RATE_DIV_NA;
 
+	// Don't program 0xF into the register field. Not valid since
+	// K1 / K2 field is only 1 / 2 bits wide
+	if (k1 == PIXEL_RATE_DIV_NA || k2 == PIXEL_RATE_DIV_NA) {
+		BREAK_TO_DEBUGGER();
+		return;
+	}
+
 	dccg314_get_pixel_rate_div(dccg, otg_inst, &cur_k1, &cur_k2);
 	if (k1 == PIXEL_RATE_DIV_NA || k2 == PIXEL_RATE_DIV_NA || (k1 == cur_k1 && k2 == cur_k2))
 		return;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
index f4d1b83979fe..a0741794db62 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
@@ -349,6 +349,7 @@ unsigned int dcn314_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsig
 	odm_combine_factor = get_odm_config(pipe_ctx, NULL);
 
 	if (is_dp_128b_132b_signal(pipe_ctx)) {
+		*k1_div = PIXEL_RATE_DIV_BY_1;
 		*k2_div = PIXEL_RATE_DIV_BY_1;
 	} else if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal) || dc_is_dvi_signal(pipe_ctx->stream->signal)) {
 		*k1_div = PIXEL_RATE_DIV_BY_1;
@@ -356,7 +357,7 @@ unsigned int dcn314_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsig
 			*k2_div = PIXEL_RATE_DIV_BY_2;
 		else
 			*k2_div = PIXEL_RATE_DIV_BY_4;
-	} else if (dc_is_dp_signal(pipe_ctx->stream->signal)) {
+	} else if (dc_is_dp_signal(pipe_ctx->stream->signal) || dc_is_virtual_signal(pipe_ctx->stream->signal)) {
 		if (two_pix_per_container) {
 			*k1_div = PIXEL_RATE_DIV_BY_1;
 			*k2_div = PIXEL_RATE_DIV_BY_2;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
index 6640d0ac4304..6dd8dadd68a5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
@@ -96,8 +96,10 @@ static void dccg32_set_pixel_rate_div(
 
 	// Don't program 0xF into the register field. Not valid since
 	// K1 / K2 field is only 1 / 2 bits wide
-	if (k1 == PIXEL_RATE_DIV_NA || k2 == PIXEL_RATE_DIV_NA)
+	if (k1 == PIXEL_RATE_DIV_NA || k2 == PIXEL_RATE_DIV_NA) {
+		BREAK_TO_DEBUGGER();
 		return;
+	}
 
 	dccg32_get_pixel_rate_div(dccg, otg_inst, &cur_k1, &cur_k2);
 	if (k1 == cur_k1 && k2 == cur_k2)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index bbc0bfbec6c4..3128c111c619 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1171,6 +1171,7 @@ unsigned int dcn32_calculate_dccg_k1_k2_values(struct pipe_ctx *pipe_ctx, unsign
 	odm_combine_factor = get_odm_config(pipe_ctx, NULL);
 
 	if (is_dp_128b_132b_signal(pipe_ctx)) {
+		*k1_div = PIXEL_RATE_DIV_BY_1;
 		*k2_div = PIXEL_RATE_DIV_BY_1;
 	} else if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal) || dc_is_dvi_signal(pipe_ctx->stream->signal)) {
 		*k1_div = PIXEL_RATE_DIV_BY_1;
-- 
2.35.1



