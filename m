Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBF0205C9A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388052AbgFWUDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388067AbgFWUDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:03:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E030A20EDD;
        Tue, 23 Jun 2020 20:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942617;
        bh=y+hdL9e6h+jVf+mXjOQ4AGF2MWv20bPcWichUI1CHMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEKIh7wzEYIGoz5Io7EiUto8cEcpGoPogDjJ7i2c2gDuW122S/kGS3eI6LMOI6SL0
         MkbKSVjkZinczt8+MfJAwxkznaNHBTJ7wFf73DwW/CBH5xzLISgkgSUNNkePErsq4G
         RuyDrggttirME58RsbxPuRtjNfIIi2S1eipNZGwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 038/477] clk: samsung: Mark top ISP and CAM clocks on Exynos542x as critical
Date:   Tue, 23 Jun 2020 21:50:35 +0200
Message-Id: <20200623195409.401629319@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c9e5a1fb66539..edb2363c735af 100644
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
@@ -943,25 +943,25 @@ static const struct samsung_gate_clock exynos5x_gate_clks[] __initconst = {
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
@@ -1161,8 +1161,10 @@ static const struct samsung_gate_clock exynos5x_gate_clks[] __initconst = {
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



