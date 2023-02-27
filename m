Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B5B6A3833
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjB0CQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbjB0CPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:15:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E53B1A487;
        Sun, 26 Feb 2023 18:13:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E327B60D2B;
        Mon, 27 Feb 2023 02:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D00C433EF;
        Mon, 27 Feb 2023 02:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463409;
        bh=INn+U1GXAUe+gaSxv5/iSa1snUoDzIdU/5IrwnueNkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jq1BWOgxysCDtStz0aJNGM2A6LW0V5hLpUMG64QApE+UcAinzossSUuQAhwSrMDd9
         mtmXMnL7vUIO3+Q0EsNgUVVFwvux8YPMmICC170NvNCZRCKztofd32wD64hM75vW89
         9wowWtd3sAoy+b/nEEhpYa/K7LJj857QPbErp5TqdZS2AfYoRZ0Brg2bmVvuwU1VFz
         4Lz+y2iWFwQulk2FwSikYYHbx3foKBA3n0COtjG0RlPboMjLbg0yDoOkTu7dXU/M4X
         9xWwIBT1hIvxOH6nVkrHJDmga+GC5Cb00csifL5ggJ9Pvi2nxoZwi7NXXP03nmcPW0
         xHbiQZECvnGyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, wenjing.liu@amd.com, HaoPing.Liu@amd.com,
        Anthony.Koo@amd.com, Roman.Li@amd.com, mwen@igalia.com,
        Jingwen.Zhu@amd.com, Alvin.Lee2@amd.com, felipe.clark@amd.com,
        sungjoon.kim@amd.com, aurabindo.pillai@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 45/60] drm/amd/display: Do not set DRR on pipe commit
Date:   Sun, 26 Feb 2023 21:00:30 -0500
Message-Id: <20230227020045.1045105-45-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
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

[ Upstream commit 4f1b5e739dfd1edde33329e3f376733a131fb1ff ]

[WHY]
Writing to DRR registers such as OTG_V_TOTAL_MIN on the same frame as a
pipe commit can cause underflow.

[HOW]
Defer all DPP adjustment requests till optimized_required is false.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 8c50457112649..c20e9f76f0213 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -992,8 +992,5 @@ void dcn30_prepare_bandwidth(struct dc *dc,
 			dc->clk_mgr->funcs->set_max_memclk(dc->clk_mgr, dc->clk_mgr->bw_params->clk_table.entries[dc->clk_mgr->bw_params->clk_table.num_entries - 1].memclk_mhz);
 
 	dcn20_prepare_bandwidth(dc, context);
-
-	dc_dmub_srv_p_state_delegate(dc,
-		context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching, context);
 }
 
-- 
2.39.0

