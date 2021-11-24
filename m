Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD5D45C300
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350008AbhKXNez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:34:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349477AbhKXNc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:32:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E3E615E2;
        Wed, 24 Nov 2021 12:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758403;
        bh=wz2BgDrdXATOuIut9HiksyjNZr92zAn+60QAjRjiz9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJg3kcYTWrviPbeQY87EagybgU2iiCKjY9EidLIFQeTlu4DdPrNk484v66RNOpqeh
         1d8s3CYG0NKobCVRSEwV8BXNJdkC0hpAywAgMsrfvDBVuapcIGbg30v7goH+4g2qJU
         jMYmM8cLIhVfJxM4OAfOwfK8Il/KM+04WbdAhUkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/154] clk/ast2600: Fix soc revision for AHB
Date:   Wed, 24 Nov 2021 12:57:34 +0100
Message-Id: <20211124115704.203802090@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit f45c5b1c27293f834682e89003f88b3512329ab4 ]

Move the soc revision parsing to the initial probe, saving the driver
from parsing the register multiple times.

Use this variable to select the correct divisor table for the AHB clock.
Before this fix the A2 would have used the A0 table.

Fixes: 2d491066ccd4 ("clk: ast2600: Fix AHB clock divider for A1")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20210922235449.213631-1-joel@jms.id.au
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-ast2600.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk-ast2600.c b/drivers/clk/clk-ast2600.c
index bc3be5f3eae15..24dab2312bc6f 100644
--- a/drivers/clk/clk-ast2600.c
+++ b/drivers/clk/clk-ast2600.c
@@ -51,6 +51,8 @@ static DEFINE_SPINLOCK(aspeed_g6_clk_lock);
 static struct clk_hw_onecell_data *aspeed_g6_clk_data;
 
 static void __iomem *scu_g6_base;
+/* AST2600 revision: A0, A1, A2, etc */
+static u8 soc_rev;
 
 /*
  * Clocks marked with CLK_IS_CRITICAL:
@@ -191,9 +193,8 @@ static struct clk_hw *ast2600_calc_pll(const char *name, u32 val)
 static struct clk_hw *ast2600_calc_apll(const char *name, u32 val)
 {
 	unsigned int mult, div;
-	u32 chip_id = readl(scu_g6_base + ASPEED_G6_SILICON_REV);
 
-	if (((chip_id & CHIP_REVISION_ID) >> 16) >= 2) {
+	if (soc_rev >= 2) {
 		if (val & BIT(24)) {
 			/* Pass through mode */
 			mult = div = 1;
@@ -707,7 +708,7 @@ static const u32 ast2600_a1_axi_ahb200_tbl[] = {
 static void __init aspeed_g6_cc(struct regmap *map)
 {
 	struct clk_hw *hw;
-	u32 val, div, divbits, chip_id, axi_div, ahb_div;
+	u32 val, div, divbits, axi_div, ahb_div;
 
 	clk_hw_register_fixed_rate(NULL, "clkin", NULL, 0, 25000000);
 
@@ -738,8 +739,7 @@ static void __init aspeed_g6_cc(struct regmap *map)
 		axi_div = 2;
 
 	divbits = (val >> 11) & 0x3;
-	regmap_read(map, ASPEED_G6_SILICON_REV, &chip_id);
-	if (chip_id & BIT(16)) {
+	if (soc_rev >= 1) {
 		if (!divbits) {
 			ahb_div = ast2600_a1_axi_ahb200_tbl[(val >> 8) & 0x3];
 			if (val & BIT(16))
@@ -784,6 +784,8 @@ static void __init aspeed_g6_cc_init(struct device_node *np)
 	if (!scu_g6_base)
 		return;
 
+	soc_rev = (readl(scu_g6_base + ASPEED_G6_SILICON_REV) & CHIP_REVISION_ID) >> 16;
+
 	aspeed_g6_clk_data = kzalloc(struct_size(aspeed_g6_clk_data, hws,
 				      ASPEED_G6_NUM_CLKS), GFP_KERNEL);
 	if (!aspeed_g6_clk_data)
-- 
2.33.0



