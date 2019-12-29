Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43C112C80F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731870AbfL2Ru3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731882AbfL2Ru3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E20222C3;
        Sun, 29 Dec 2019 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641828;
        bh=LPi1426rsVbv0B6jQmiHlJRqJnNTlgPmM7p/7ONp2Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdli3PaVTf5TmqA2hTNDBWt0NimAVUhHFdguZ1IU5+Rf1Z7UHzlNSSpNdqKLs7Ttd
         KdFHqvkoz0pds2ZrQBc/rcq+IHs/NTlOOwjZi90XUScIOffscZKKHWepLmSFNz88Q8
         ncwL8Gxiv0zcd/CjxCw3v4+uuF6cVAuENUSkiD9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Koo <Anthony.Koo@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/434] drm/amd/display: correctly populate dpp refclk in fpga
Date:   Sun, 29 Dec 2019 18:24:04 +0100
Message-Id: <20191229172714.509042266@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3e8ac303bd52..23ec283eb07b 100644
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



