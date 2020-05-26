Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8515A1AA3E7
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506176AbgDONOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897045AbgDOLfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9019321655;
        Wed, 15 Apr 2020 11:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950522;
        bh=cV2r83eP8e/jucUSXYvFnWLjmbcZKhtPCDO2eIQor/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CexCzCrQuMR6tCdW9mYjVpsN/3eDKMbyW4QXjJJEZkfjcIlnM/wzmvAZ3WdCdFjAC
         hUc4CNI9gxgWpVvIZpLxje/9BzTUizApQ3e7E5GW1YEzx94dqal+ejg/Isr/6GTsPc
         18mg/wpdJ2rh9xlXviFJc68oWD23c6u6L4hD/ngc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 031/129] soc: imx: gpc: fix power up sequencing
Date:   Wed, 15 Apr 2020 07:33:06 -0400
Message-Id: <20200415113445.11881-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit e0ea2d11f8a08ba7066ff897e16c5217215d1e68 ]

Currently we wait only until the PGC inverts the isolation setting
before disabling the peripheral clocks. This doesn't ensure that the
reset is properly propagated through the peripheral devices in the
power domain.

Wait until the PGC signals that the power up request is done and
wait a bit for resets to propagate before disabling the clocks.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpc.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/soc/imx/gpc.c b/drivers/soc/imx/gpc.c
index 98b9d9a902ae3..90a8b2c0676ff 100644
--- a/drivers/soc/imx/gpc.c
+++ b/drivers/soc/imx/gpc.c
@@ -87,8 +87,8 @@ static int imx6_pm_domain_power_off(struct generic_pm_domain *genpd)
 static int imx6_pm_domain_power_on(struct generic_pm_domain *genpd)
 {
 	struct imx_pm_domain *pd = to_imx_pm_domain(genpd);
-	int i, ret, sw, sw2iso;
-	u32 val;
+	int i, ret;
+	u32 val, req;
 
 	if (pd->supply) {
 		ret = regulator_enable(pd->supply);
@@ -107,17 +107,18 @@ static int imx6_pm_domain_power_on(struct generic_pm_domain *genpd)
 	regmap_update_bits(pd->regmap, pd->reg_offs + GPC_PGC_CTRL_OFFS,
 			   0x1, 0x1);
 
-	/* Read ISO and ISO2SW power up delays */
-	regmap_read(pd->regmap, pd->reg_offs + GPC_PGC_PUPSCR_OFFS, &val);
-	sw = val & 0x3f;
-	sw2iso = (val >> 8) & 0x3f;
-
 	/* Request GPC to power up domain */
-	val = BIT(pd->cntr_pdn_bit + 1);
-	regmap_update_bits(pd->regmap, GPC_CNTR, val, val);
+	req = BIT(pd->cntr_pdn_bit + 1);
+	regmap_update_bits(pd->regmap, GPC_CNTR, req, req);
 
-	/* Wait ISO + ISO2SW IPG clock cycles */
-	udelay(DIV_ROUND_UP(sw + sw2iso, pd->ipg_rate_mhz));
+	/* Wait for the PGC to handle the request */
+	ret = regmap_read_poll_timeout(pd->regmap, GPC_CNTR, val, !(val & req),
+				       1, 50);
+	if (ret)
+		pr_err("powerup request on domain %s timed out\n", genpd->name);
+
+	/* Wait for reset to propagate through peripherals */
+	usleep_range(5, 10);
 
 	/* Disable reset clocks for all devices in the domain */
 	for (i = 0; i < pd->num_clks; i++)
@@ -343,6 +344,7 @@ static const struct regmap_config imx_gpc_regmap_config = {
 	.rd_table = &access_table,
 	.wr_table = &access_table,
 	.max_register = 0x2ac,
+	.fast_io = true,
 };
 
 static struct generic_pm_domain *imx_gpc_onecell_domains[] = {
-- 
2.20.1

