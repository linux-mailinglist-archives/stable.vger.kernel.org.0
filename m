Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673F2205F40
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391085AbgFWUbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391081AbgFWUbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:31:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0CD4206C3;
        Tue, 23 Jun 2020 20:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944261;
        bh=Vzlziez2etOyHDxeMK8xVgG/C2LUpR0dM/kx/cWwAAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndq+Ze/VJ77wA7Spqjzn9y73gnhSf3pGFf3k/J1pqWJD9hQR8PSk/SM3+Thdk3gq+
         lCpjQTXWwsTLIeOITQwET83Iif6uGPtONxg+sBb+BWibOmXjlAekz5cV9B1ltEexeL
         oSxI1D3oepUKuRfcl41Wtpbp4KgDTNlFz5C4hD6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/314] clk: ast2600: Fix AHB clock divider for A1
Date:   Tue, 23 Jun 2020 21:56:29 +0200
Message-Id: <20200623195348.178452084@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b1318e6b655bc..675cab6fa7814 100644
--- a/drivers/clk/clk-ast2600.c
+++ b/drivers/clk/clk-ast2600.c
@@ -599,14 +599,22 @@ static const u32 ast2600_a0_axi_ahb_div_table[] = {
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
 
@@ -636,11 +644,22 @@ static void __init aspeed_g6_cc(struct regmap *map)
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



