Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32311657D2E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiL1PkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbiL1PkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39C8167DF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AE49B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0139AC433D2;
        Wed, 28 Dec 2022 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242017;
        bh=bW1aOMrTRUttyI3VIMBCfWgzz0HAU3MruvekUoEfb5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oML8YTa8IgBKi6m6PWieQOD/QmkjsyLERJ6mDn4v7sIcZKAU6tynBwgwHmNu9vxxs
         BhI1toZ9kYHDH4LqxPH1sPInrC1mxBlCuqAQ/K1BO7p2f6gU2H12PotoA1JI3J2MKc
         E/yI5X9/+3znz6vL0uAJdUTdr0LK+uvRothhpCks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Peng Fan <peng.fan@nxp.com>, Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0355/1073] clk: imx93: unmap anatop base in error handling path
Date:   Wed, 28 Dec 2022 15:32:23 +0100
Message-Id: <20221228144337.646412898@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit bda7b7f396f94d8df89ecacc88f2826908e8762c ]

The anatop base is not unmapped during error handling path, fix it.

Fixes: 24defbe194b6 ("clk: imx: add i.MX93 clk")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20221028095211.2598312-2-peng.fan@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index 4d2524addc3e..8d67b065f7b6 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -247,7 +247,7 @@ static int imx93_clocks_probe(struct platform_device *pdev)
 	struct device_node *np = dev->of_node;
 	const struct imx93_clk_root *root;
 	const struct imx93_clk_ccgr *ccgr;
-	void __iomem *base = NULL;
+	void __iomem *base, *anatop_base;
 	int i, ret;
 
 	clk_hw_data = kzalloc(struct_size(clk_hw_data, hws,
@@ -274,20 +274,22 @@ static int imx93_clocks_probe(struct platform_device *pdev)
 								    "sys_pll_pfd2", 1, 2);
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx93-anatop");
-	base = of_iomap(np, 0);
+	anatop_base = of_iomap(np, 0);
 	of_node_put(np);
-	if (WARN_ON(!base))
+	if (WARN_ON(!anatop_base))
 		return -ENOMEM;
 
-	clks[IMX93_CLK_AUDIO_PLL] = imx_clk_fracn_gppll("audio_pll", "osc_24m", base + 0x1200,
+	clks[IMX93_CLK_AUDIO_PLL] = imx_clk_fracn_gppll("audio_pll", "osc_24m", anatop_base + 0x1200,
 							&imx_fracn_gppll);
-	clks[IMX93_CLK_VIDEO_PLL] = imx_clk_fracn_gppll("video_pll", "osc_24m", base + 0x1400,
+	clks[IMX93_CLK_VIDEO_PLL] = imx_clk_fracn_gppll("video_pll", "osc_24m", anatop_base + 0x1400,
 							&imx_fracn_gppll);
 
 	np = dev->of_node;
 	base = devm_platform_ioremap_resource(pdev, 0);
-	if (WARN_ON(IS_ERR(base)))
+	if (WARN_ON(IS_ERR(base))) {
+		iounmap(anatop_base);
 		return PTR_ERR(base);
+	}
 
 	for (i = 0; i < ARRAY_SIZE(root_array); i++) {
 		root = &root_array[i];
@@ -317,6 +319,7 @@ static int imx93_clocks_probe(struct platform_device *pdev)
 
 unregister_hws:
 	imx_unregister_hw_clocks(clks, IMX93_CLK_END);
+	iounmap(anatop_base);
 
 	return ret;
 }
-- 
2.35.1



