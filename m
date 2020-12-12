Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E402D2D87A8
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439410AbgLLQKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:10:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439407AbgLLQJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:09:56 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brandon Syu <Brandon.Syu@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 20/23] drm/amd/display: Init clock value by current vbios CLKs
Date:   Sat, 12 Dec 2020 11:08:01 -0500
Message-Id: <20201212160804.2334982-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brandon Syu <Brandon.Syu@amd.com>

[ Upstream commit 7e0b367db85ef7b91399006253759a024eab7653 ]

[Why]
While booting into OS, driver updates DPP/DISP CLKs.
But init clock value is zero which is invalid.

[How]
Get current clocks value to update init clocks.
To avoid underflow.

Signed-off-by: Brandon Syu <Brandon.Syu@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c   | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index 2f8fee05547ac..c001307b0a59a 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -163,8 +163,17 @@ void rn_update_clocks(struct clk_mgr *clk_mgr_base,
 			new_clocks->dppclk_khz = 100000;
 	}
 
-	if (should_set_clock(safe_to_lower, new_clocks->dppclk_khz, clk_mgr->base.clks.dppclk_khz)) {
-		if (clk_mgr->base.clks.dppclk_khz > new_clocks->dppclk_khz)
+	/*
+	 * Temporally ignore thew 0 cases for disp and dpp clks.
+	 * We may have a new feature that requires 0 clks in the future.
+	 */
+	if (new_clocks->dppclk_khz == 0 || new_clocks->dispclk_khz == 0) {
+		new_clocks->dppclk_khz = clk_mgr_base->clks.dppclk_khz;
+		new_clocks->dispclk_khz = clk_mgr_base->clks.dispclk_khz;
+	}
+
+	if (should_set_clock(safe_to_lower, new_clocks->dppclk_khz, clk_mgr_base->clks.dppclk_khz)) {
+		if (clk_mgr_base->clks.dppclk_khz > new_clocks->dppclk_khz)
 			dpp_clock_lowered = true;
 		clk_mgr_base->clks.dppclk_khz = new_clocks->dppclk_khz;
 		update_dppclk = true;
-- 
2.27.0

