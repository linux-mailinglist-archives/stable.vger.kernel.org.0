Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1341F594B43
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350715AbiHPAOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353234AbiHPAKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:10:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5094DCCE18;
        Mon, 15 Aug 2022 13:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 911E4B80EB1;
        Mon, 15 Aug 2022 20:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BBEC433D6;
        Mon, 15 Aug 2022 20:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595365;
        bh=REkwR5J41q/Hrazw8AkkdOJJpFzFGfPiF5Ij9pcyQ+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFYt1SFst0oribzCjK7N9Fn4ZRrsEs3fogVl6jxvwDxIpTO8BFhZzx1mc7U1KfILg
         HYY2ShnNq8dxuJmRjWNQjjQRGvWUZjJDJmubndPn7iVAN18d+KfxjBHXKThqJJQP1y
         xn2vudxCub5TQfuBxNzLIl1Uv1MOKNt+gtaXB0A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abel Vesa <abel.vesa@nxp.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Liu Ying <victor.liu@nxp.com>,
        Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0724/1157] clk: imx: clk-fracn-gppll: Return rate in rate table properly in ->recalc_rate()
Date:   Mon, 15 Aug 2022 20:01:20 +0200
Message-Id: <20220815180508.438042675@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 5ebaf9f7da5bb2dc56d394eabfcbe46dc6b1ea8d ]

The PLL parameters in rate table should be directly compared with
those read from PLL registers instead of the cooked ones.

Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Cc: Abel Vesa <abel.vesa@nxp.com>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20220609132902.3504651-6-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index 36a53c60e71f..cb06b0045e9e 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -131,18 +131,7 @@ static unsigned long clk_fracn_gppll_recalc_rate(struct clk_hw *hw, unsigned lon
 	mfi = FIELD_GET(PLL_MFI_MASK, pll_div);
 
 	rdiv = FIELD_GET(PLL_RDIV_MASK, pll_div);
-	rdiv = rdiv + 1;
 	odiv = FIELD_GET(PLL_ODIV_MASK, pll_div);
-	switch (odiv) {
-	case 0:
-		odiv = 2;
-		break;
-	case 1:
-		odiv = 3;
-		break;
-	default:
-		break;
-	}
 
 	/*
 	 * Sometimes, the recalculated rate has deviation due to
@@ -160,6 +149,19 @@ static unsigned long clk_fracn_gppll_recalc_rate(struct clk_hw *hw, unsigned lon
 	if (rate)
 		return (unsigned long)rate;
 
+	rdiv = rdiv + 1;
+
+	switch (odiv) {
+	case 0:
+		odiv = 2;
+		break;
+	case 1:
+		odiv = 3;
+		break;
+	default:
+		break;
+	}
+
 	/* Fvco = Fref * (MFI + MFN / MFD) */
 	fvco = fvco * mfi * mfd + fvco * mfn;
 	do_div(fvco, mfd * rdiv * odiv);
-- 
2.35.1



