Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1961FE697
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgFRCe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbgFRBOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 136B9221F0;
        Thu, 18 Jun 2020 01:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442862;
        bh=yxjlZXBHSwssaqDKkjpPc3u3wRsrsKwzGkwMtEVmXMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tThE2/P6lgln4Nj0KFtkreybaiC0tWn/b2VYDR/5lYndMbdPvZkU2VK/6tSrYqDJm
         KOmHiWbh2+wXA+1MGVS+PDtfBNVu0HNhQkhx4gsNvCbIEbnBgYPblwZaLwsOJ/S5VR
         J+dbygA3/XSQk3vZTar4SrQ4FImtshLKft+ibHwE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eddie James <eajames@linux.ibm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 291/388] clk: ast2600: Fix AHB clock divider for A1
Date:   Wed, 17 Jun 2020 21:06:28 -0400
Message-Id: <20200618010805.600873-291-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 2d491066ccd4286538450c227fc5094ceb04b494 ]

The latest specs for the AST2600 A1 chip include some different bit
definitions for calculating the AHB clock divider. Implement these in
order to get the correct AHB clock value in Linux.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lkml.kernel.org/r/20200408203616.4031-1-eajames@linux.ibm.com
Fixes: d3d04f6c330a ("clk: Add support for AST2600 SoC")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-ast2600.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk-ast2600.c b/drivers/clk/clk-ast2600.c
index 392d01705b97..99afc949925f 100644
--- a/drivers/clk/clk-ast2600.c
+++ b/drivers/clk/clk-ast2600.c
@@ -642,14 +642,22 @@ static const u32 ast2600_a0_axi_ahb_div_table[] = {
 	2, 2, 3, 5,
 };
 
-static const u32 ast2600_a1_axi_ahb_div_table[] = {
-	4, 6, 2, 4,
+static const u32 ast2600_a1_axi_ahb_div0_tbl[] = {
+	3, 2, 3, 4,
+};
+
+static const u32 ast2600_a1_axi_ahb_div1_tbl[] = {
+	3, 4, 6, 8,
+};
+
+static const u32 ast2600_a1_axi_ahb200_tbl[] = {
+	3, 4, 3, 4, 2, 2, 2, 2,
 };
 
 static void __init aspeed_g6_cc(struct regmap *map)
 {
 	struct clk_hw *hw;
-	u32 val, div, chip_id, axi_div, ahb_div;
+	u32 val, div, divbits, chip_id, axi_div, ahb_div;
 
 	clk_hw_register_fixed_rate(NULL, "clkin", NULL, 0, 25000000);
 
@@ -679,11 +687,22 @@ static void __init aspeed_g6_cc(struct regmap *map)
 	else
 		axi_div = 2;
 
+	divbits = (val >> 11) & 0x3;
 	regmap_read(map, ASPEED_G6_SILICON_REV, &chip_id);
-	if (chip_id & BIT(16))
-		ahb_div = ast2600_a1_axi_ahb_div_table[(val >> 11) & 0x3];
-	else
+	if (chip_id & BIT(16)) {
+		if (!divbits) {
+			ahb_div = ast2600_a1_axi_ahb200_tbl[(val >> 8) & 0x3];
+			if (val & BIT(16))
+				ahb_div *= 2;
+		} else {
+			if (val & BIT(16))
+				ahb_div = ast2600_a1_axi_ahb_div1_tbl[divbits];
+			else
+				ahb_div = ast2600_a1_axi_ahb_div0_tbl[divbits];
+		}
+	} else {
 		ahb_div = ast2600_a0_axi_ahb_div_table[(val >> 11) & 0x3];
+	}
 
 	hw = clk_hw_register_fixed_factor(NULL, "ahb", "hpll", 0, 1, axi_div * ahb_div);
 	aspeed_g6_clk_data->hws[ASPEED_CLK_AHB] = hw;
-- 
2.25.1

