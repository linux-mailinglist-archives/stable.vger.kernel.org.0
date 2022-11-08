Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FE96210C3
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiKHMcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbiKHMcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:32:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B1350F24
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 010096153C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6800C433D6;
        Tue,  8 Nov 2022 12:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667910733;
        bh=Hb3HQ9hl9fMkrvHNYntXkNlQKpVucu39yAmQenVEi4E=;
        h=Subject:To:Cc:From:Date:From;
        b=JNy/B8K4us2fK3VNK4NWcbCNoZBphN6YDzM9/CwDR4qfsYu61sLijjjHpFso3WKv1
         obU8lNhZs+Gnj/Pc6GvRVtD2eyByTqY3kxEmQvyQiPRPBhTMTZy9S6mPbUNuWm5Ubv
         o9WZfWamGhr8U5E54pjNGcPMxZFYIPl0X2Fy/sqY=
Subject: FAILED: patch "[PATCH] drm/amd/display: Limit dcn32 to 1950Mhz display clock" failed to apply to 6.0-stable tree
To:     jun.lei@amd.com, Alvin.Lee2@amd.com, Rodrigo.Siqueira@amd.com,
        alexander.deucher@amd.com, mark.broadworth@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Nov 2022 13:32:09 +0100
Message-ID: <16679107291722@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e59843c4cdd6 ("drm/amd/display: Limit dcn32 to 1950Mhz display clock")
d6170e418d1d ("drm/amd/display: Acquire FCLK DPM levels on DCN32")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e59843c4cdd68a369591630088171eeacce9859f Mon Sep 17 00:00:00 2001
From: Jun Lei <jun.lei@amd.com>
Date: Thu, 20 Oct 2022 11:46:44 -0400
Subject: [PATCH] drm/amd/display: Limit dcn32 to 1950Mhz display clock

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

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index 1c612ccf1944..fd0313468fdb 100644
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

