Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258DEACE12
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731978AbfIHMuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731998AbfIHMuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:50:12 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D21A2190F;
        Sun,  8 Sep 2019 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947011;
        bh=tGLxt853tx3yqdgy409J0Zbq+dfq+TyDsgOM80UyRuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaIeswMPvOqPxfJWV+CapR2N83k9wByyyYH7EiHDAWGZvgU6mJBIWwXWNmoMF0s1i
         ZmrVXbPZEJNTOf4iwwylZnMqnkyPFdIsqmmnq0lwG6KYzTxpK55Gb/EpNj7prTd68e
         9eL7PT9anLi2sn7x9WZn/zjuquoFPLRJrdVbqkBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 27/94] clk: samsung: exynos542x: Move MSCL subsystem clocks to its sub-CMU
Date:   Sun,  8 Sep 2019 13:41:23 +0100
Message-Id: <20190908121151.219083615@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit baf7b79e1ad79a41fafd8ab8597b9a96962d822d ]

M2M scaler clocks require special handling of their parent bus clock during
power domain on/off sequences. MSCL clocks were not initially added to the
sub-CMU handler, because that time there was no driver for the M2M scaler
device and it was not possible to test it.

This patch fixes this issue. Parent clock for M2M scaler devices is now
properly preserved during MSC power domain on/off sequence. This gives M2M
scaler devices proper performance: fullHD XRGB32 image 1000 rotations test
takes 3.17s instead of 45.08s.

Fixes: b06a532bf1fa ("clk: samsung: Add Exynos5 sub-CMU clock driver")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lkml.kernel.org/r/20190808121839.23892-1-m.szyprowski@samsung.com
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos5420.c | 48 ++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 5eb0ce4b2648b..893697e00d2aa 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -870,9 +870,6 @@ static const struct samsung_div_clock exynos5x_div_clks[] __initconst = {
 	/* GSCL Block */
 	DIV(0, "dout_gscl_blk_333", "aclk333_432_gscl", DIV2_RATIO0, 6, 2),
 
-	/* MSCL Block */
-	DIV(0, "dout_mscl_blk", "aclk400_mscl", DIV2_RATIO0, 28, 2),
-
 	/* PSGEN */
 	DIV(0, "dout_gen_blk", "mout_user_aclk266", DIV2_RATIO0, 8, 1),
 	DIV(0, "dout_jpg_blk", "aclk166", DIV2_RATIO0, 20, 1),
@@ -1136,17 +1133,6 @@ static const struct samsung_gate_clock exynos5x_gate_clks[] __initconst = {
 	GATE(CLK_FIMC_LITE3, "fimc_lite3", "aclk333_432_gscl",
 			GATE_IP_GSCL1, 17, 0, 0),
 
-	/* MSCL Block */
-	GATE(CLK_MSCL0, "mscl0", "aclk400_mscl", GATE_IP_MSCL, 0, 0, 0),
-	GATE(CLK_MSCL1, "mscl1", "aclk400_mscl", GATE_IP_MSCL, 1, 0, 0),
-	GATE(CLK_MSCL2, "mscl2", "aclk400_mscl", GATE_IP_MSCL, 2, 0, 0),
-	GATE(CLK_SMMU_MSCL0, "smmu_mscl0", "dout_mscl_blk",
-			GATE_IP_MSCL, 8, 0, 0),
-	GATE(CLK_SMMU_MSCL1, "smmu_mscl1", "dout_mscl_blk",
-			GATE_IP_MSCL, 9, 0, 0),
-	GATE(CLK_SMMU_MSCL2, "smmu_mscl2", "dout_mscl_blk",
-			GATE_IP_MSCL, 10, 0, 0),
-
 	/* ISP */
 	GATE(CLK_SCLK_UART_ISP, "sclk_uart_isp", "dout_uart_isp",
 			GATE_TOP_SCLK_ISP, 0, CLK_SET_RATE_PARENT, 0),
@@ -1229,6 +1215,28 @@ static struct exynos5_subcmu_reg_dump exynos5x_mfc_suspend_regs[] = {
 	{ DIV4_RATIO, 0, 0x3 },			/* DIV dout_mfc_blk */
 };
 
+static const struct samsung_gate_clock exynos5x_mscl_gate_clks[] __initconst = {
+	/* MSCL Block */
+	GATE(CLK_MSCL0, "mscl0", "aclk400_mscl", GATE_IP_MSCL, 0, 0, 0),
+	GATE(CLK_MSCL1, "mscl1", "aclk400_mscl", GATE_IP_MSCL, 1, 0, 0),
+	GATE(CLK_MSCL2, "mscl2", "aclk400_mscl", GATE_IP_MSCL, 2, 0, 0),
+	GATE(CLK_SMMU_MSCL0, "smmu_mscl0", "dout_mscl_blk",
+			GATE_IP_MSCL, 8, 0, 0),
+	GATE(CLK_SMMU_MSCL1, "smmu_mscl1", "dout_mscl_blk",
+			GATE_IP_MSCL, 9, 0, 0),
+	GATE(CLK_SMMU_MSCL2, "smmu_mscl2", "dout_mscl_blk",
+			GATE_IP_MSCL, 10, 0, 0),
+};
+
+static const struct samsung_div_clock exynos5x_mscl_div_clks[] __initconst = {
+	DIV(0, "dout_mscl_blk", "aclk400_mscl", DIV2_RATIO0, 28, 2),
+};
+
+static struct exynos5_subcmu_reg_dump exynos5x_mscl_suspend_regs[] = {
+	{ GATE_IP_MSCL, 0xffffffff, 0xffffffff }, /* MSCL gates */
+	{ SRC_TOP3, 0, BIT(4) },		/* MUX mout_user_aclk400_mscl */
+	{ DIV2_RATIO0, 0, 0x30000000 },		/* DIV dout_mscl_blk */
+};
 
 static const struct samsung_gate_clock exynos5800_mau_gate_clks[] __initconst = {
 	GATE(CLK_MAU_EPLL, "mau_epll", "mout_user_mau_epll",
@@ -1273,6 +1281,16 @@ static const struct exynos5_subcmu_info exynos5x_mfc_subcmu = {
 	.pd_name	= "MFC",
 };
 
+static const struct exynos5_subcmu_info exynos5x_mscl_subcmu = {
+	.div_clks	= exynos5x_mscl_div_clks,
+	.nr_div_clks	= ARRAY_SIZE(exynos5x_mscl_div_clks),
+	.gate_clks	= exynos5x_mscl_gate_clks,
+	.nr_gate_clks	= ARRAY_SIZE(exynos5x_mscl_gate_clks),
+	.suspend_regs	= exynos5x_mscl_suspend_regs,
+	.nr_suspend_regs = ARRAY_SIZE(exynos5x_mscl_suspend_regs),
+	.pd_name	= "MSC",
+};
+
 static const struct exynos5_subcmu_info exynos5800_mau_subcmu = {
 	.gate_clks	= exynos5800_mau_gate_clks,
 	.nr_gate_clks	= ARRAY_SIZE(exynos5800_mau_gate_clks),
@@ -1285,12 +1303,14 @@ static const struct exynos5_subcmu_info *exynos5x_subcmus[] = {
 	&exynos5x_disp_subcmu,
 	&exynos5x_gsc_subcmu,
 	&exynos5x_mfc_subcmu,
+	&exynos5x_mscl_subcmu,
 };
 
 static const struct exynos5_subcmu_info *exynos5800_subcmus[] = {
 	&exynos5x_disp_subcmu,
 	&exynos5x_gsc_subcmu,
 	&exynos5x_mfc_subcmu,
+	&exynos5x_mscl_subcmu,
 	&exynos5800_mau_subcmu,
 };
 
-- 
2.20.1



