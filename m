Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDA8169542
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgBWCg6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:36:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727775AbgBWCVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:21:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ECEC20707;
        Sun, 23 Feb 2020 02:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424510;
        bh=h326O0kpeMI5X0FsCoPQhAf7UBcRPRc+4W84GVod7kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lku9fMTzyTi73cV/Ub5k0K1Ti0RCx7GxCwOmkrVjqsqWcHAqyBiFFY7tR7npbkiFq
         1QLtg9/P4pUy4unFNmDZR4iNEvA2kDWCT/w2Pug0vFRJK1CNh2ZRda677rbdKAkpzx
         fk4t+nc9Gamtvr6oHmpA7TBIkMIOu0ACNfMFqsxA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongqiang Sun <yongqiang.sun@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 25/58] drm/amd/display: Limit minimum DPPCLK to 100MHz.
Date:   Sat, 22 Feb 2020 21:20:46 -0500
Message-Id: <20200223022119.707-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqiang Sun <yongqiang.sun@amd.com>

[ Upstream commit 6c81917a0485ee2a1be0dc23321ac10ecfd9578b ]

[Why]
Underflow is observed when plug in a 4K@60 monitor with
1366x768 eDP due to DPPCLK is too low.

[How]
Limit minimum DPPCLK to 100MHz.

Signed-off-by: Yongqiang Sun <yongqiang.sun@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index 35c55e54eac01..619b1a18b0441 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -149,6 +149,12 @@ void rn_update_clocks(struct clk_mgr *clk_mgr_base,
 		rn_vbios_smu_set_min_deep_sleep_dcfclk(clk_mgr, clk_mgr_base->clks.dcfclk_deep_sleep_khz);
 	}
 
+	// workaround: Limit dppclk to 100Mhz to avoid lower eDP panel switch to plus 4K monitor underflow.
+	if (!IS_DIAG_DC(dc->ctx->dce_environment)) {
+		if (new_clocks->dppclk_khz < 100000)
+			new_clocks->dppclk_khz = 100000;
+	}
+
 	if (should_set_clock(safe_to_lower, new_clocks->dppclk_khz, clk_mgr->base.clks.dppclk_khz)) {
 		if (clk_mgr->base.clks.dppclk_khz > new_clocks->dppclk_khz)
 			dpp_clock_lowered = true;
-- 
2.20.1

