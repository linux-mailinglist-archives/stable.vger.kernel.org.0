Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5EA2E3A9B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391332AbgL1NjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:39:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391320AbgL1NjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:39:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 915532072C;
        Mon, 28 Dec 2020 13:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162710;
        bh=rv1yFjZZ9I9JlrjIrNoNTrEZQKLua7ohWVI9uMNSZi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCFy3XOh2NglaPQG26ulO87tApgMKIs4J/SIQki9CBgT+OT56LLgWNEPe+uNaXlJB
         nzVCZ8PvFH1prcrXrQmWGEo0jZguzMjmbdkDMFyJoOKEnooe+GZi0hWnMCvkwzPBHR
         B0cQOQvE7ssvybmUOQSD1xLryVaQByF1syLbdXps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brandon Syu <Brandon.Syu@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/453] drm/amd/display: Init clock value by current vbios CLKs
Date:   Mon, 28 Dec 2020 13:44:43 +0100
Message-Id: <20201228124939.518905538@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index dd92f9c295b45..9f301f8575a54 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -97,8 +97,17 @@ void rn_update_clocks(struct clk_mgr *clk_mgr_base,
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



