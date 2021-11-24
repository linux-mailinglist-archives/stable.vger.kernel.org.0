Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F9745C240
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348114AbhKXN0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:26:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348197AbhKXNYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:24:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6040D61B31;
        Wed, 24 Nov 2021 12:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758126;
        bh=/lSpLM0GBiciicG6UKDrEZfg2qbvOWc3J3e8ZnRvYnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWLvXkfQ3nzVnC0WtqJTxWQ0AFHi/bAdW90xj03HYkzaAsvjM3oAuK2iJrS5bxdG6
         jYZbqxZcyvdgIqnpgqjonvWRusPg6XcTtz7J9AZK27pXrF+OuSOunTFNRsCt2VRg0D
         BytKaRHLNROXhDGJ7HnKYMN/58Uk2m1hNBI7cKpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/100] clk/ast2600: Fix soc revision for AHB
Date:   Wed, 24 Nov 2021 12:57:53 +0100
Message-Id: <20211124115656.071697275@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
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
index af957179b135e..48122f574cb65 100644
--- a/drivers/clk/clk-ast2600.c
+++ b/drivers/clk/clk-ast2600.c
@@ -48,6 +48,8 @@ static DEFINE_SPINLOCK(aspeed_g6_clk_lock);
 static struct clk_hw_onecell_data *aspeed_g6_clk_data;
 
 static void __iomem *scu_g6_base;
+/* AST2600 revision: A0, A1, A2, etc */
+static u8 soc_rev;
 
 /*
  * Clocks marked with CLK_IS_CRITICAL:
@@ -190,9 +192,8 @@ static struct clk_hw *ast2600_calc_pll(const char *name, u32 val)
 static struct clk_hw *ast2600_calc_apll(const char *name, u32 val)
 {
 	unsigned int mult, div;
-	u32 chip_id = readl(scu_g6_base + ASPEED_G6_SILICON_REV);
 
-	if (((chip_id & CHIP_REVISION_ID) >> 16) >= 2) {
+	if (soc_rev >= 2) {
 		if (val & BIT(24)) {
 			/* Pass through mode */
 			mult = div = 1;
@@ -664,7 +665,7 @@ static const u32 ast2600_a1_axi_ahb200_tbl[] = {
 static void __init aspeed_g6_cc(struct regmap *map)
 {
 	struct clk_hw *hw;
-	u32 val, div, divbits, chip_id, axi_div, ahb_div;
+	u32 val, div, divbits, axi_div, ahb_div;
 
 	clk_hw_register_fixed_rate(NULL, "clkin", NULL, 0, 25000000);
 
@@ -695,8 +696,7 @@ static void __init aspeed_g6_cc(struct regmap *map)
 		axi_div = 2;
 
 	divbits = (val >> 11) & 0x3;
-	regmap_read(map, ASPEED_G6_SILICON_REV, &chip_id);
-	if (chip_id & BIT(16)) {
+	if (soc_rev >= 1) {
 		if (!divbits) {
 			ahb_div = ast2600_a1_axi_ahb200_tbl[(val >> 8) & 0x3];
 			if (val & BIT(16))
@@ -741,6 +741,8 @@ static void __init aspeed_g6_cc_init(struct device_node *np)
 	if (!scu_g6_base)
 		return;
 
+	soc_rev = (readl(scu_g6_base + ASPEED_G6_SILICON_REV) & CHIP_REVISION_ID) >> 16;
+
 	aspeed_g6_clk_data = kzalloc(struct_size(aspeed_g6_clk_data, hws,
 				      ASPEED_G6_NUM_CLKS), GFP_KERNEL);
 	if (!aspeed_g6_clk_data)
-- 
2.33.0



