Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F7E1FE572
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbgFRCZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728975AbgFRBRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F94E21D82;
        Thu, 18 Jun 2020 01:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443031;
        bh=888Jc3QOglMoOyYRAqKKyDwxmx47rmmkZ4WPk0QR3qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQBtimaxX3ik/MKqAdGZ0CxWW9JLCX+gnrch4GLVmQ6+Fa6BLcLuT987LYOgjXM5/
         x8kfOhLKuw3ePGS4tH81e64vsvMM3nU+ZMfPyudZjglDp0h3ImQF9NSjOIlE8g/eyE
         EEwNA8te6L2Fl407DcOKTHEfIe4KiXhT9q9AWysk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 030/266] clk: samsung: Mark top ISP and CAM clocks on Exynos542x as critical
Date:   Wed, 17 Jun 2020 21:12:35 -0400
Message-Id: <20200618011631.604574-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit e47bd937e602bb4379546095d1bd0b9871fa60c2 ]

The TOP 'aclk*_isp', 'aclk550_cam', 'gscl_wa' and 'gscl_wb' clocks must
be kept enabled all the time to allow proper access to power management
control for the ISP and CAM power domains. The last two clocks, although
related to GScaler device and GSCL power domain, provides also the
I_WRAP_CLK signal to MIPI CSIS0/1 devices, which are a part of CAM power
domain and are needed for proper power on/off sequence.

Currently there are no drivers for the devices, which are part of CAM and
ISP power domains yet. This patch only fixes the race between disabling
the unused power domains and disabling unused clocks, which randomly
resulted in the following error during boot:

Power domain CAM disable failed
Power domain ISP disable failed

Fixes: 318fa46cc60d ("clk/samsung: exynos542x: mark some clocks as critical")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos5420.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 27fd274e92f8..dfef5f0833db 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -540,7 +540,7 @@ static const struct samsung_div_clock exynos5800_div_clks[] __initconst = {
 
 static const struct samsung_gate_clock exynos5800_gate_clks[] __initconst = {
 	GATE(CLK_ACLK550_CAM, "aclk550_cam", "mout_user_aclk550_cam",
-				GATE_BUS_TOP, 24, 0, 0),
+				GATE_BUS_TOP, 24, CLK_IS_CRITICAL, 0),
 	GATE(CLK_ACLK432_SCALER, "aclk432_scaler", "mout_user_aclk432_scaler",
 				GATE_BUS_TOP, 27, CLK_IS_CRITICAL, 0),
 };
@@ -940,25 +940,25 @@ static const struct samsung_gate_clock exynos5x_gate_clks[] __initconst = {
 	GATE(0, "aclk300_jpeg", "mout_user_aclk300_jpeg",
 			GATE_BUS_TOP, 4, CLK_IGNORE_UNUSED, 0),
 	GATE(0, "aclk333_432_isp0", "mout_user_aclk333_432_isp0",
-			GATE_BUS_TOP, 5, 0, 0),
+			GATE_BUS_TOP, 5, CLK_IS_CRITICAL, 0),
 	GATE(0, "aclk300_gscl", "mout_user_aclk300_gscl",
 			GATE_BUS_TOP, 6, CLK_IS_CRITICAL, 0),
 	GATE(0, "aclk333_432_gscl", "mout_user_aclk333_432_gscl",
 			GATE_BUS_TOP, 7, CLK_IGNORE_UNUSED, 0),
 	GATE(0, "aclk333_432_isp", "mout_user_aclk333_432_isp",
-			GATE_BUS_TOP, 8, 0, 0),
+			GATE_BUS_TOP, 8, CLK_IS_CRITICAL, 0),
 	GATE(CLK_PCLK66_GPIO, "pclk66_gpio", "mout_user_pclk66_gpio",
 			GATE_BUS_TOP, 9, CLK_IGNORE_UNUSED, 0),
 	GATE(0, "aclk66_psgen", "mout_user_aclk66_psgen",
 			GATE_BUS_TOP, 10, CLK_IGNORE_UNUSED, 0),
 	GATE(0, "aclk266_isp", "mout_user_aclk266_isp",
-			GATE_BUS_TOP, 13, 0, 0),
+			GATE_BUS_TOP, 13, CLK_IS_CRITICAL, 0),
 	GATE(0, "aclk166", "mout_user_aclk166",
 			GATE_BUS_TOP, 14, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_ACLK333, "aclk333", "mout_user_aclk333",
 			GATE_BUS_TOP, 15, CLK_IS_CRITICAL, 0),
 	GATE(0, "aclk400_isp", "mout_user_aclk400_isp",
-			GATE_BUS_TOP, 16, 0, 0),
+			GATE_BUS_TOP, 16, CLK_IS_CRITICAL, 0),
 	GATE(0, "aclk400_mscl", "mout_user_aclk400_mscl",
 			GATE_BUS_TOP, 17, CLK_IS_CRITICAL, 0),
 	GATE(0, "aclk200_disp1", "mout_user_aclk200_disp1",
@@ -1158,8 +1158,10 @@ static const struct samsung_gate_clock exynos5x_gate_clks[] __initconst = {
 			GATE_IP_GSCL1, 3, 0, 0),
 	GATE(CLK_SMMU_FIMCL1, "smmu_fimcl1", "dout_gscl_blk_333",
 			GATE_IP_GSCL1, 4, 0, 0),
-	GATE(CLK_GSCL_WA, "gscl_wa", "sclk_gscl_wa", GATE_IP_GSCL1, 12, 0, 0),
-	GATE(CLK_GSCL_WB, "gscl_wb", "sclk_gscl_wb", GATE_IP_GSCL1, 13, 0, 0),
+	GATE(CLK_GSCL_WA, "gscl_wa", "sclk_gscl_wa", GATE_IP_GSCL1, 12,
+			CLK_IS_CRITICAL, 0),
+	GATE(CLK_GSCL_WB, "gscl_wb", "sclk_gscl_wb", GATE_IP_GSCL1, 13,
+			CLK_IS_CRITICAL, 0),
 	GATE(CLK_SMMU_FIMCL3, "smmu_fimcl3,", "dout_gscl_blk_333",
 			GATE_IP_GSCL1, 16, 0, 0),
 	GATE(CLK_FIMC_LITE3, "fimc_lite3", "aclk333_432_gscl",
-- 
2.25.1

