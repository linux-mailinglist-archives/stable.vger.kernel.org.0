Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69C065013F
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiLRQZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiLRQZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:25:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A28DE9B;
        Sun, 18 Dec 2022 08:09:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0839BB80BA4;
        Sun, 18 Dec 2022 16:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B44C433D2;
        Sun, 18 Dec 2022 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379779;
        bh=G3ROSK40a4GXYNI2mhMT7pqzHEVcNH4bNL+rSJgEHkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxBWNw6AdC7+OYvqyX76vDQ1iBafDtDNF6N+AFZiach5wwNQhjlpQufi80FjUuz90
         dFR97iMg2jfPNgmGACwoOPrlpUnOMrzKjr+0RY8aGm05eybr3UFX6WaA4VbtbjOQA1
         gqQLoy1Lib68/ST7HrCqH3uyd7vW2YtzSNw3/15TNwuN43pJEuOih2TJKfHzJg0RFx
         CLY+WMSJIuwBVg0acWbLoeMyVEjn9FtriO11G4SrFXBaGIt5RE/Ivn4n1Y2RPdB6cD
         idWCnFIdXdZWuj9pRzk5r3p0TeHAMxnIWw4WlzuY8Njn6FafPQ5CNBavL9aLOl4T3c
         yUr4DP+IPSbcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Alan Liu <HaoPing.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, wayne.lin@amd.com, alex.hung@amd.com,
        Anthony.Koo@amd.com, Roman.Li@amd.com, felipe.clark@amd.com,
        Jingwen.Zhu@amd.com, Alvin.Lee2@amd.com, aurabindo.pillai@amd.com,
        aric.cyr@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 31/73] drm/amd/display: Disable DRR actions during state commit
Date:   Sun, 18 Dec 2022 11:06:59 -0500
Message-Id: <20221218160741.927862-31-sashal@kernel.org>
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

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit de020e5fa9ebc6fc32e82ae6ccb0282451ed937c ]

[WHY]
Committing a state while performing DRR actions can cause underflow.

[HOW]
Disabled features performing DRR actions during state commit.
Need to follow-up on why DRR actions affect state commit.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index fb59fed8f425..9d369155901a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -973,8 +973,5 @@ void dcn30_prepare_bandwidth(struct dc *dc,
 			dc->clk_mgr->funcs->set_max_memclk(dc->clk_mgr, dc->clk_mgr->bw_params->clk_table.entries[dc->clk_mgr->bw_params->clk_table.num_entries - 1].memclk_mhz);
 
 	dcn20_prepare_bandwidth(dc, context);
-
-	dc_dmub_srv_p_state_delegate(dc,
-		context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching, context);
 }
 
-- 
2.35.1

