Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6FE111C0C
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfLCWjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:39:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbfLCWjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94F532080F;
        Tue,  3 Dec 2019 22:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412782;
        bh=3F2pxH644GYrnzt6iwQEkQ9qYogZ/qu94MAd/ic4aOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGNbUESnnXu5+/wOYhH3+rHcCjdWDhh5/XPzPiCaU9q3r9v7EnUeUI+bPI44y+a44
         XEoD7fBw22XZKnv4QO09PCblnDkNKOHh+mVKzxtBcATPUP1cT2XonHR9bG4AHIhUTa
         qjpTLx+D9yGeYQ0l9or+7rkNKORhNX3R0davLUcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marian Mihailescu <mihailescu2m@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 015/135] clk: samsung: exynos542x: Move G3D subsystem clocks to its sub-CMU
Date:   Tue,  3 Dec 2019 23:34:15 +0100
Message-Id: <20191203213008.333510326@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit c9f7567aff31348a3dcf54845f7e389f5df0c0c1 ]

G3D clocks require special handling of their parent bus clock during power
domain on/off sequences. Those clocks were not initially added to the
sub-CMU handler, because that time there was no open-source driver for the
G3D (MALI Panfrost) hardware module and it was not possible to test it.

This patch fixes this issue. Parent clock for G3D hardware block is now
properly preserved during G3D power domain on/off sequence. This restores
proper MALI Panfrost performance broken by commit 8686764fc071
("ARM: dts: exynos: Add G3D power domain to Exynos542x").

Reported-by: Marian Mihailescu <mihailescu2m@gmail.com>
Fixes: b06a532bf1fa ("clk: samsung: Add Exynos5 sub-CMU clock driver")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marian Mihailescu <mihailescu2m@gmail.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos5420.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 7670cc596c742..dfa862d55246e 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -1172,8 +1172,6 @@ static const struct samsung_gate_clock exynos5x_gate_clks[] __initconst = {
 	GATE(CLK_SCLK_ISP_SENSOR2, "sclk_isp_sensor2", "dout_isp_sensor2",
 			GATE_TOP_SCLK_ISP, 12, CLK_SET_RATE_PARENT, 0),
 
-	GATE(CLK_G3D, "g3d", "mout_user_aclk_g3d", GATE_IP_G3D, 9, 0, 0),
-
 	/* CDREX */
 	GATE(CLK_CLKM_PHY0, "clkm_phy0", "dout_sclk_cdrex",
 			GATE_BUS_CDREX0, 0, 0, 0),
@@ -1248,6 +1246,15 @@ static struct exynos5_subcmu_reg_dump exynos5x_gsc_suspend_regs[] = {
 	{ DIV2_RATIO0, 0, 0x30 },	/* DIV dout_gscl_blk_300 */
 };
 
+static const struct samsung_gate_clock exynos5x_g3d_gate_clks[] __initconst = {
+	GATE(CLK_G3D, "g3d", "mout_user_aclk_g3d", GATE_IP_G3D, 9, 0, 0),
+};
+
+static struct exynos5_subcmu_reg_dump exynos5x_g3d_suspend_regs[] = {
+	{ GATE_IP_G3D, 0x3ff, 0x3ff },	/* G3D gates */
+	{ SRC_TOP5, 0, BIT(16) },	/* MUX mout_user_aclk_g3d */
+};
+
 static const struct samsung_div_clock exynos5x_mfc_div_clks[] __initconst = {
 	DIV(0, "dout_mfc_blk", "mout_user_aclk333", DIV4_RATIO, 0, 2),
 };
@@ -1320,6 +1327,14 @@ static const struct exynos5_subcmu_info exynos5x_gsc_subcmu = {
 	.pd_name	= "GSC",
 };
 
+static const struct exynos5_subcmu_info exynos5x_g3d_subcmu = {
+	.gate_clks	= exynos5x_g3d_gate_clks,
+	.nr_gate_clks	= ARRAY_SIZE(exynos5x_g3d_gate_clks),
+	.suspend_regs	= exynos5x_g3d_suspend_regs,
+	.nr_suspend_regs = ARRAY_SIZE(exynos5x_g3d_suspend_regs),
+	.pd_name	= "G3D",
+};
+
 static const struct exynos5_subcmu_info exynos5x_mfc_subcmu = {
 	.div_clks	= exynos5x_mfc_div_clks,
 	.nr_div_clks	= ARRAY_SIZE(exynos5x_mfc_div_clks),
@@ -1351,6 +1366,7 @@ static const struct exynos5_subcmu_info exynos5800_mau_subcmu = {
 static const struct exynos5_subcmu_info *exynos5x_subcmus[] = {
 	&exynos5x_disp_subcmu,
 	&exynos5x_gsc_subcmu,
+	&exynos5x_g3d_subcmu,
 	&exynos5x_mfc_subcmu,
 	&exynos5x_mscl_subcmu,
 };
@@ -1358,6 +1374,7 @@ static const struct exynos5_subcmu_info *exynos5x_subcmus[] = {
 static const struct exynos5_subcmu_info *exynos5800_subcmus[] = {
 	&exynos5x_disp_subcmu,
 	&exynos5x_gsc_subcmu,
+	&exynos5x_g3d_subcmu,
 	&exynos5x_mfc_subcmu,
 	&exynos5x_mscl_subcmu,
 	&exynos5800_mau_subcmu,
-- 
2.20.1



