Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5E548926F
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbiAJHmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242233AbiAJHkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:40:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87404C0225B9;
        Sun,  9 Jan 2022 23:34:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29EEA60B03;
        Mon, 10 Jan 2022 07:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1582BC36AE9;
        Mon, 10 Jan 2022 07:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800063;
        bh=eYFFKT1o1Y/rgN/OYwhhdSde3R2dhRsHpH0/eFJ275s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwV5xZIJrmydVbgv3355pCyqV0ivHHf87Av9kTt1N6AafrLC9YijrAR0psz7f3B9n
         CmmjhMYjWDBPbGdPpcYP0EE+C93lAPXIiZvLftV1BEL7igF30Lyv05yUgTpbvPNznB
         XR0FdTKdw/aA5jzI7qg6zBUcju31n5pPvquIFtCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 65/72] drm/amd/display: fix B0 TMDS deepcolor no dislay issue
Date:   Mon, 10 Jan 2022 08:23:42 +0100
Message-Id: <20220110071823.767304921@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 2eb82577a16d4c8eb31e4ed520649850bb95b223 ]

[why]
B0 PHY C map to F, D map to G driver use logic instance, dmub does the
remap. Driver still need use the right PHY instance to access right HW.

[how]
use phyical instance when program PHY register.

[note]
could move resync_control programming to dmub next.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn31/dcn31_resource.c | 25 +++++++++++++--
 .../drm/amd/display/dc/dcn31/dcn31_resource.h | 31 +++++++++++++++++++
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index 6d8f26dada722..0fe570717ba01 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -352,6 +352,14 @@ static const struct dce110_clk_src_regs clk_src_regs[] = {
 	clk_src_regs(3, D),
 	clk_src_regs(4, E)
 };
+/*pll_id being rempped in dmub, in driver it is logical instance*/
+static const struct dce110_clk_src_regs clk_src_regs_b0[] = {
+	clk_src_regs(0, A),
+	clk_src_regs(1, B),
+	clk_src_regs(2, F),
+	clk_src_regs(3, G),
+	clk_src_regs(4, E)
+};
 
 static const struct dce110_clk_src_shift cs_shift = {
 		CS_COMMON_MASK_SH_LIST_DCN2_0(__SHIFT)
@@ -2019,14 +2027,27 @@ static bool dcn31_resource_construct(
 			dcn30_clock_source_create(ctx, ctx->dc_bios,
 				CLOCK_SOURCE_COMBO_PHY_PLL1,
 				&clk_src_regs[1], false);
-	pool->base.clock_sources[DCN31_CLK_SRC_PLL2] =
+	/*move phypllx_pixclk_resync to dmub next*/
+	if (dc->ctx->asic_id.hw_internal_rev == YELLOW_CARP_B0) {
+		pool->base.clock_sources[DCN31_CLK_SRC_PLL2] =
+			dcn30_clock_source_create(ctx, ctx->dc_bios,
+				CLOCK_SOURCE_COMBO_PHY_PLL2,
+				&clk_src_regs_b0[2], false);
+		pool->base.clock_sources[DCN31_CLK_SRC_PLL3] =
+			dcn30_clock_source_create(ctx, ctx->dc_bios,
+				CLOCK_SOURCE_COMBO_PHY_PLL3,
+				&clk_src_regs_b0[3], false);
+	} else {
+		pool->base.clock_sources[DCN31_CLK_SRC_PLL2] =
 			dcn30_clock_source_create(ctx, ctx->dc_bios,
 				CLOCK_SOURCE_COMBO_PHY_PLL2,
 				&clk_src_regs[2], false);
-	pool->base.clock_sources[DCN31_CLK_SRC_PLL3] =
+		pool->base.clock_sources[DCN31_CLK_SRC_PLL3] =
 			dcn30_clock_source_create(ctx, ctx->dc_bios,
 				CLOCK_SOURCE_COMBO_PHY_PLL3,
 				&clk_src_regs[3], false);
+	}
+
 	pool->base.clock_sources[DCN31_CLK_SRC_PLL4] =
 			dcn30_clock_source_create(ctx, ctx->dc_bios,
 				CLOCK_SOURCE_COMBO_PHY_PLL4,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.h b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.h
index 93571c9769967..cc4bed675588c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.h
@@ -39,4 +39,35 @@ struct resource_pool *dcn31_create_resource_pool(
 		const struct dc_init_data *init_data,
 		struct dc *dc);
 
+/*temp: B0 specific before switch to dcn313 headers*/
+#ifndef regPHYPLLF_PIXCLK_RESYNC_CNTL
+#define regPHYPLLF_PIXCLK_RESYNC_CNTL 0x007e
+#define regPHYPLLF_PIXCLK_RESYNC_CNTL_BASE_IDX 1
+#define regPHYPLLG_PIXCLK_RESYNC_CNTL 0x005f
+#define regPHYPLLG_PIXCLK_RESYNC_CNTL_BASE_IDX 1
+
+//PHYPLLF_PIXCLK_RESYNC_CNTL
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_PIXCLK_RESYNC_ENABLE__SHIFT 0x0
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_DEEP_COLOR_DTO_ENABLE_STATUS__SHIFT 0x1
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_DCCG_DEEP_COLOR_CNTL__SHIFT 0x4
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_PIXCLK_ENABLE__SHIFT 0x8
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_PIXCLK_DOUBLE_RATE_ENABLE__SHIFT 0x9
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_PIXCLK_RESYNC_ENABLE_MASK 0x00000001L
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_DEEP_COLOR_DTO_ENABLE_STATUS_MASK 0x00000002L
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_DCCG_DEEP_COLOR_CNTL_MASK 0x00000030L
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_PIXCLK_ENABLE_MASK 0x00000100L
+#define PHYPLLF_PIXCLK_RESYNC_CNTL__PHYPLLF_PIXCLK_DOUBLE_RATE_ENABLE_MASK 0x00000200L
+
+//PHYPLLG_PIXCLK_RESYNC_CNTL
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_PIXCLK_RESYNC_ENABLE__SHIFT 0x0
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_DEEP_COLOR_DTO_ENABLE_STATUS__SHIFT 0x1
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_DCCG_DEEP_COLOR_CNTL__SHIFT 0x4
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_PIXCLK_ENABLE__SHIFT 0x8
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_PIXCLK_DOUBLE_RATE_ENABLE__SHIFT 0x9
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_PIXCLK_RESYNC_ENABLE_MASK 0x00000001L
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_DEEP_COLOR_DTO_ENABLE_STATUS_MASK 0x00000002L
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_DCCG_DEEP_COLOR_CNTL_MASK 0x00000030L
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_PIXCLK_ENABLE_MASK 0x00000100L
+#define PHYPLLG_PIXCLK_RESYNC_CNTL__PHYPLLG_PIXCLK_DOUBLE_RATE_ENABLE_MASK 0x00000200L
+#endif
 #endif /* _DCN31_RESOURCE_H_ */
-- 
2.34.1



