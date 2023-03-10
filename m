Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF6C6B47EA
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbjCJO42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbjCJOzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:55:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA0212EE5A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:51:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3640619F2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB58C4339B;
        Fri, 10 Mar 2023 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459757;
        bh=bn3mzWZV4gVUFUo0PiCcYs/RxKRHPaZFEyQ9H4WJQZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ne8bELJFPlh3tLn0Bp+uX97NBD6rGdrJgT0W28UO9MvaeVf9cMkqYKP1bovhWVj1d
         QQlecXkVE3JmXtIRzk2YGr3RrUaXV11D4wWUnRpiNR2By2eY3tFHVJndpzF4AVNcXt
         Cb5/bnkS/a5xfoEAUtJzcr1wJJv/Mo3D49NP4uk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/529] net: ethernet: ti: am65-cpsw: handle deferred probe with dev_err_probe()
Date:   Fri, 10 Mar 2023 14:34:12 +0100
Message-Id: <20230310133810.037791501@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 8fbc2f9edce23d19fc09ef5bf8d4eb38be2db0f8 ]

Use new dev_err_probe() API to handle deferred probe properly and simplify
the code.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 28 +++++++++---------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 487c1570dd420..5300e1439e1e5 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1487,9 +1487,8 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 						    tx_chn->tx_chn_name,
 						    &tx_cfg);
 		if (IS_ERR(tx_chn->tx_chn)) {
-			ret = PTR_ERR(tx_chn->tx_chn);
-			dev_err(dev, "Failed to request tx dma channel %d\n",
-				ret);
+			ret = dev_err_probe(dev, PTR_ERR(tx_chn->tx_chn),
+					    "Failed to request tx dma channel\n");
 			goto err;
 		}
 
@@ -1560,8 +1559,8 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 
 	rx_chn->rx_chn = k3_udma_glue_request_rx_chn(dev, "rx", &rx_cfg);
 	if (IS_ERR(rx_chn->rx_chn)) {
-		ret = PTR_ERR(rx_chn->rx_chn);
-		dev_err(dev, "Failed to request rx dma channel %d\n", ret);
+		ret = dev_err_probe(dev, PTR_ERR(rx_chn->rx_chn),
+				    "Failed to request rx dma channel\n");
 		goto err;
 	}
 
@@ -1768,12 +1767,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		/* get phy/link info */
 		if (of_phy_is_fixed_link(port_np)) {
 			ret = of_phy_register_fixed_link(port_np);
-			if (ret) {
-				if (ret != -EPROBE_DEFER)
-					dev_err(dev, "%pOF failed to register fixed-link phy: %d\n",
-						port_np, ret);
-				return ret;
-			}
+			if (ret)
+				return dev_err_probe(dev, ret,
+						     "failed to register fixed-link phy %pOF\n",
+						     port_np);
 			port->slave.phy_node = of_node_get(port_np);
 		} else {
 			port->slave.phy_node =
@@ -2062,13 +2059,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	clk = devm_clk_get(dev, "fck");
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "error getting fck clock %d\n", ret);
-		return ret;
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk), "getting fck clock\n");
 	common->bus_freq = clk_get_rate(clk);
 
 	pm_runtime_enable(dev);
-- 
2.39.2



