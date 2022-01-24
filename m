Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B484998BE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352492AbiAXV3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:29:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37822 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447065AbiAXVSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:18:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36925B8105C;
        Mon, 24 Jan 2022 21:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68541C340E4;
        Mon, 24 Jan 2022 21:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059119;
        bh=pieXjopHJClA3R5Ukxgru4qNpdVk33ngFDmFKm50a+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvVRPgn4Xt1ZTAJDSOxyQevyqvoCTx2Bcd4W7dalyLuuloDTGXdGYeDFPmQ0ybph7
         h5cT8moIDqbqzW5Pa/Ixnzo6YKLw6D/PLaFBXs91In4gKC6yMAWdHkgcYYjYpfLCEA
         YN4NQjBDZUQyps12KMQRoudivMVswLUbcs1kUSJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Swapnil Jakhade <sjakhade@cadence.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0509/1039] phy: cadence: Sierra: Fix to get correct parent for mux clocks
Date:   Mon, 24 Jan 2022 19:38:18 +0100
Message-Id: <20220124184142.400075607@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Swapnil Jakhade <sjakhade@cadence.com>

[ Upstream commit da08aab940092a050a4fb2857ed9479d2b0e03c4 ]

Fix get_parent() callback to return the correct index of the parent for
PLL_CMNLC1 clock. Add a separate table of register values corresponding
to the parent index for PLL_CMNLC1. Update set_parent() callback
accordingly.

Fixes: 28081b72859f ("phy: cadence: Sierra: Model PLL_CMNLC and PLL_CMNLC1 as clocks (mux clocks)")
Signed-off-by: Swapnil Jakhade <sjakhade@cadence.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Link: https://lore.kernel.org/r/20211223060137.9252-12-sjakhade@cadence.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/cadence/phy-cadence-sierra.c | 31 ++++++++++++++++++++----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/phy/cadence/phy-cadence-sierra.c b/drivers/phy/cadence/phy-cadence-sierra.c
index e93818e3991fd..3e2d096d54fd7 100644
--- a/drivers/phy/cadence/phy-cadence-sierra.c
+++ b/drivers/phy/cadence/phy-cadence-sierra.c
@@ -215,7 +215,10 @@ static const int pll_mux_parent_index[][SIERRA_NUM_CMN_PLLC_PARENTS] = {
 	[CMN_PLLLC1] = { PLL1_REFCLK, PLL0_REFCLK },
 };
 
-static u32 cdns_sierra_pll_mux_table[] = { 0, 1 };
+static u32 cdns_sierra_pll_mux_table[][SIERRA_NUM_CMN_PLLC_PARENTS] = {
+	[CMN_PLLLC] = { 0, 1 },
+	[CMN_PLLLC1] = { 1, 0 },
+};
 
 struct cdns_sierra_inst {
 	struct phy *phy;
@@ -436,11 +439,25 @@ static const struct phy_ops ops = {
 static u8 cdns_sierra_pll_mux_get_parent(struct clk_hw *hw)
 {
 	struct cdns_sierra_pll_mux *mux = to_cdns_sierra_pll_mux(hw);
+	struct regmap_field *plllc1en_field = mux->plllc1en_field;
+	struct regmap_field *termen_field = mux->termen_field;
 	struct regmap_field *field = mux->pfdclk_sel_preg;
 	unsigned int val;
+	int index;
 
 	regmap_field_read(field, &val);
-	return clk_mux_val_to_index(hw, cdns_sierra_pll_mux_table, 0, val);
+
+	if (strstr(clk_hw_get_name(hw), clk_names[CDNS_SIERRA_PLL_CMNLC1])) {
+		index = clk_mux_val_to_index(hw, cdns_sierra_pll_mux_table[CMN_PLLLC1], 0, val);
+		if (index == 1) {
+			regmap_field_write(plllc1en_field, 1);
+			regmap_field_write(termen_field, 1);
+		}
+	} else {
+		index = clk_mux_val_to_index(hw, cdns_sierra_pll_mux_table[CMN_PLLLC], 0, val);
+	}
+
+	return index;
 }
 
 static int cdns_sierra_pll_mux_set_parent(struct clk_hw *hw, u8 index)
@@ -458,7 +475,11 @@ static int cdns_sierra_pll_mux_set_parent(struct clk_hw *hw, u8 index)
 		ret |= regmap_field_write(termen_field, 1);
 	}
 
-	val = cdns_sierra_pll_mux_table[index];
+	if (strstr(clk_hw_get_name(hw), clk_names[CDNS_SIERRA_PLL_CMNLC1]))
+		val = cdns_sierra_pll_mux_table[CMN_PLLLC1][index];
+	else
+		val = cdns_sierra_pll_mux_table[CMN_PLLLC][index];
+
 	ret |= regmap_field_write(field, val);
 
 	return ret;
@@ -496,8 +517,8 @@ static int cdns_sierra_pll_mux_register(struct cdns_sierra_phy *sp,
 	for (i = 0; i < num_parents; i++) {
 		clk = sp->input_clks[pll_mux_parent_index[clk_index][i]];
 		if (IS_ERR_OR_NULL(clk)) {
-			dev_err(dev, "No parent clock for derived_refclk\n");
-			return PTR_ERR(clk);
+			dev_err(dev, "No parent clock for PLL mux clocks\n");
+			return IS_ERR(clk) ? PTR_ERR(clk) : -ENOENT;
 		}
 		parent_names[i] = __clk_get_name(clk);
 	}
-- 
2.34.1



