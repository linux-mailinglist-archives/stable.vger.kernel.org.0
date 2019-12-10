Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC35E1196DA
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfLJVKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728384AbfLJVKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDEC3246AC;
        Tue, 10 Dec 2019 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012210;
        bh=zOQHlGxGlD22dSvYMFWP0Utebo3AOdsp8NUI2OFX6hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXDrGBeqthkGBjlGUh69UlxOW0lFWJhMpVyVOosAagD3JsbB82cEfOCv2WG6m/zIv
         5ancxEiEW0g4ThZvGrukmv8QBBKKjFFi6J+Rqa3LrWn1hnTpliR7+6Eif5nuDUldkL
         HBVvfWxSy1BcQa4WXYHVGnAxrNpERda8hQtpuPwM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Koo <Anthony.Koo@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 162/350] drm/amd/display: correctly populate dpp refclk in fpga
Date:   Tue, 10 Dec 2019 16:04:27 -0500
Message-Id: <20191210210735.9077-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Koo <Anthony.Koo@amd.com>

[ Upstream commit 952f6c4b5d72d40f93f3deb61239290b357d434e ]

[Why]
In diags environment we are not programming the DPP DTO
correctly.

[How]
Populate the dpp refclk in dccg so it can be used to correctly
program DPP DTO.

Signed-off-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c   | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
index 3e8ac303bd526..23ec283eb07b6 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
@@ -320,6 +320,8 @@ void dcn2_update_clocks_fpga(struct clk_mgr *clk_mgr,
 		struct dc_state *context,
 		bool safe_to_lower)
 {
+	struct clk_mgr_internal *clk_mgr_int = TO_CLK_MGR_INTERNAL(clk_mgr);
+
 	struct dc_clocks *new_clocks = &context->bw_ctx.bw.dcn.clk;
 	/* Min fclk = 1.2GHz since all the extra scemi logic seems to run off of it */
 	int fclk_adj = new_clocks->fclk_khz > 1200000 ? new_clocks->fclk_khz : 1200000;
@@ -357,14 +359,18 @@ void dcn2_update_clocks_fpga(struct clk_mgr *clk_mgr,
 		clk_mgr->clks.dispclk_khz = new_clocks->dispclk_khz;
 	}
 
-	/* Both fclk and dppclk ref are run on the same scemi clock so we
-	 * need to keep the same value for both
+	/* Both fclk and ref_dppclk run on the same scemi clock.
+	 * So take the higher value since the DPP DTO is typically programmed
+	 * such that max dppclk is 1:1 with ref_dppclk.
 	 */
 	if (clk_mgr->clks.fclk_khz > clk_mgr->clks.dppclk_khz)
 		clk_mgr->clks.dppclk_khz = clk_mgr->clks.fclk_khz;
 	if (clk_mgr->clks.dppclk_khz > clk_mgr->clks.fclk_khz)
 		clk_mgr->clks.fclk_khz = clk_mgr->clks.dppclk_khz;
 
+	// Both fclk and ref_dppclk run on the same scemi clock.
+	clk_mgr_int->dccg->ref_dppclk = clk_mgr->clks.fclk_khz;
+
 	dm_set_dcn_clocks(clk_mgr->ctx, &clk_mgr->clks);
 }
 
-- 
2.20.1

