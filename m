Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE43627FD9
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbiKNNCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237729AbiKNNCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BA629355
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD6CB80EC2
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCB2C433D7;
        Mon, 14 Nov 2022 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430924;
        bh=d3D0aiJTptEhMm3hYwsH5xqmEXxlwVIYyrFu0G3+w5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12ycGao4CjD/pn0MZsUM0KSQYr9aLY5HFC+4l7tHo82u8UopKK1gioQQfPZs4rB+/
         DkvuqOzhPOwvW+Ei27yR2SBicjbJdzGzg4mASnacMxSFz6Abz/cBftTiAwT5x890Tm
         OLftrNBmvUUqX/paYtEr5galSZNa0xdDdxgt4Wfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Broadworth <mark.broadworth@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Jun Lei <jun.lei@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 009/190] drm/amd/display: Limit dcn32 to 1950Mhz display clock
Date:   Mon, 14 Nov 2022 13:43:53 +0100
Message-Id: <20221114124459.191839576@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Jun Lei <jun.lei@amd.com>

[ Upstream commit e59843c4cdd68a369591630088171eeacce9859f ]

[why]
Hardware team recommends we limit dispclock to 1950Mhz for all DCN3.2.x

[how]
Limit to 1950 when initializing clocks.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Jun Lei <jun.lei@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c  | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index f4c7bbd9961a..f3090ead9af5 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -157,6 +157,7 @@ void dcn32_init_clocks(struct clk_mgr *clk_mgr_base)
 	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
 	unsigned int num_levels;
 	struct clk_limit_num_entries *num_entries_per_clk = &clk_mgr_base->bw_params->clk_table.num_entries_per_clk;
+	unsigned int i;
 
 	memset(&(clk_mgr_base->clks), 0, sizeof(struct dc_clocks));
 	clk_mgr_base->clks.p_state_change_support = true;
@@ -205,18 +206,17 @@ void dcn32_init_clocks(struct clk_mgr *clk_mgr_base)
 		clk_mgr->dpm_present = true;
 
 	if (clk_mgr_base->ctx->dc->debug.min_disp_clk_khz) {
-		unsigned int i;
-
 		for (i = 0; i < num_levels; i++)
 			if (clk_mgr_base->bw_params->clk_table.entries[i].dispclk_mhz
 					< khz_to_mhz_ceil(clk_mgr_base->ctx->dc->debug.min_disp_clk_khz))
 				clk_mgr_base->bw_params->clk_table.entries[i].dispclk_mhz
 					= khz_to_mhz_ceil(clk_mgr_base->ctx->dc->debug.min_disp_clk_khz);
 	}
+	for (i = 0; i < num_levels; i++)
+		if (clk_mgr_base->bw_params->clk_table.entries[i].dispclk_mhz > 1950)
+			clk_mgr_base->bw_params->clk_table.entries[i].dispclk_mhz = 1950;
 
 	if (clk_mgr_base->ctx->dc->debug.min_dpp_clk_khz) {
-		unsigned int i;
-
 		for (i = 0; i < num_levels; i++)
 			if (clk_mgr_base->bw_params->clk_table.entries[i].dppclk_mhz
 					< khz_to_mhz_ceil(clk_mgr_base->ctx->dc->debug.min_dpp_clk_khz))
-- 
2.35.1



