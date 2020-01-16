Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E06613E0C0
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgAPQpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:54202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbgAPQpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:45:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C2E3214AF;
        Thu, 16 Jan 2020 16:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193123;
        bh=DiQHE5REgQamHOQjDKS+KWLMX0tIKuXjs1EZJ4ndLqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTnVAGqO06gMlbaovWi08KGkdGygqtQxDrl6Dgtjbj8OSKEluRS12BCzHlTANHTzZ
         qcZeMI4DdRWHk4s9SxTXv5/Gm6G0qZ+EcbKl5OomrgrlYz74BXf9YtPPXozLQ/VUJJ
         XWEKR0/FQ15DuiH2f9X7J+z1d/MoineNSJvQB0MQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 029/205] clk: imx: pll14xx: Fix quick switch of S/K parameter
Date:   Thu, 16 Jan 2020 11:40:04 -0500
Message-Id: <20200116164300.6705-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

[ Upstream commit 094234fcf46146339caaac8282aa15d225a5911a ]

The PLL14xx on imx8m can change the S and K parameter without requiring
a reset and relock of the whole PLL.

Fix clk_pll144xx_mp_change register reading and use it for pll1443 as
well since no reset+relock is required on K changes either.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Fixes: 8646d4dcc7fb ("clk: imx: Add PLLs driver for imx8mm soc")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-pll14xx.c | 40 +++++++----------------------------
 1 file changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/clk/imx/clk-pll14xx.c b/drivers/clk/imx/clk-pll14xx.c
index d43b4a3c0de8..047f1d8fe323 100644
--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -112,43 +112,17 @@ static unsigned long clk_pll1443x_recalc_rate(struct clk_hw *hw,
 	return fvco;
 }
 
-static inline bool clk_pll1416x_mp_change(const struct imx_pll14xx_rate_table *rate,
+static inline bool clk_pll14xx_mp_change(const struct imx_pll14xx_rate_table *rate,
 					  u32 pll_div)
 {
 	u32 old_mdiv, old_pdiv;
 
-	old_mdiv = (pll_div >> MDIV_SHIFT) & MDIV_MASK;
-	old_pdiv = (pll_div >> PDIV_SHIFT) & PDIV_MASK;
+	old_mdiv = (pll_div & MDIV_MASK) >> MDIV_SHIFT;
+	old_pdiv = (pll_div & PDIV_MASK) >> PDIV_SHIFT;
 
 	return rate->mdiv != old_mdiv || rate->pdiv != old_pdiv;
 }
 
-static inline bool clk_pll1443x_mpk_change(const struct imx_pll14xx_rate_table *rate,
-					  u32 pll_div_ctl0, u32 pll_div_ctl1)
-{
-	u32 old_mdiv, old_pdiv, old_kdiv;
-
-	old_mdiv = (pll_div_ctl0 >> MDIV_SHIFT) & MDIV_MASK;
-	old_pdiv = (pll_div_ctl0 >> PDIV_SHIFT) & PDIV_MASK;
-	old_kdiv = (pll_div_ctl1 >> KDIV_SHIFT) & KDIV_MASK;
-
-	return rate->mdiv != old_mdiv || rate->pdiv != old_pdiv ||
-		rate->kdiv != old_kdiv;
-}
-
-static inline bool clk_pll1443x_mp_change(const struct imx_pll14xx_rate_table *rate,
-					  u32 pll_div_ctl0, u32 pll_div_ctl1)
-{
-	u32 old_mdiv, old_pdiv, old_kdiv;
-
-	old_mdiv = (pll_div_ctl0 >> MDIV_SHIFT) & MDIV_MASK;
-	old_pdiv = (pll_div_ctl0 >> PDIV_SHIFT) & PDIV_MASK;
-	old_kdiv = (pll_div_ctl1 >> KDIV_SHIFT) & KDIV_MASK;
-
-	return rate->mdiv != old_mdiv || rate->pdiv != old_pdiv ||
-		rate->kdiv != old_kdiv;
-}
-
 static int clk_pll14xx_wait_lock(struct clk_pll14xx *pll)
 {
 	u32 val;
@@ -174,7 +148,7 @@ static int clk_pll1416x_set_rate(struct clk_hw *hw, unsigned long drate,
 
 	tmp = readl_relaxed(pll->base + 4);
 
-	if (!clk_pll1416x_mp_change(rate, tmp)) {
+	if (!clk_pll14xx_mp_change(rate, tmp)) {
 		tmp &= ~(SDIV_MASK) << SDIV_SHIFT;
 		tmp |= rate->sdiv << SDIV_SHIFT;
 		writel_relaxed(tmp, pll->base + 4);
@@ -239,13 +213,15 @@ static int clk_pll1443x_set_rate(struct clk_hw *hw, unsigned long drate,
 	}
 
 	tmp = readl_relaxed(pll->base + 4);
-	div_val = readl_relaxed(pll->base + 8);
 
-	if (!clk_pll1443x_mpk_change(rate, tmp, div_val)) {
+	if (!clk_pll14xx_mp_change(rate, tmp)) {
 		tmp &= ~(SDIV_MASK) << SDIV_SHIFT;
 		tmp |= rate->sdiv << SDIV_SHIFT;
 		writel_relaxed(tmp, pll->base + 4);
 
+		tmp = rate->kdiv << KDIV_SHIFT;
+		writel_relaxed(tmp, pll->base + 8);
+
 		return 0;
 	}
 
-- 
2.20.1

