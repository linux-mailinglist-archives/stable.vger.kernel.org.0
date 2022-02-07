Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABF14ABC7D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352058AbiBGLhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384583AbiBGL3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:29:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D73C02B5CA;
        Mon,  7 Feb 2022 03:27:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA7D560A6B;
        Mon,  7 Feb 2022 11:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BEFC004E1;
        Mon,  7 Feb 2022 11:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233241;
        bh=WnFNuTNHN+U9z+3wWHwApqEJQhHlO7hieQexRD6JlRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJ5l6lmQaAelIsYwLlQXgjDc1hg95m9lAqQAFC+Kp8yGuwV2aBdT+ZkcdXaGfgdHi
         twN2vuWU6rsGWUi56VJBveduyIxQdN5EuEH57MZqFLh82OqQjx7WPPmYPIcXLAcTx4
         LxlAzWgHFKpchxeenljoogrtHDMml6FIgycwUMR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 062/110] net: stmmac: dwmac-visconti: No change to ETHER_CLOCK_SEL for unexpected speed request.
Date:   Mon,  7 Feb 2022 12:06:35 +0100
Message-Id: <20220207103804.384237281@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>

commit 928d6fe996f69330ded6b887baf4534c5fac7988 upstream.

Variable clk_sel_val is not initialized in the default case of the first switch statement.
In that case, the function should return immediately without any changes to the hardware.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: b38dd98ff8d0 ("net: stmmac: Add Toshiba Visconti SoCs glue driver")
Signed-off-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -49,13 +49,15 @@ struct visconti_eth {
 	void __iomem *reg;
 	u32 phy_intf_sel;
 	struct clk *phy_ref_clk;
+	struct device *dev;
 	spinlock_t lock; /* lock to protect register update */
 };
 
 static void visconti_eth_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct visconti_eth *dwmac = priv;
-	unsigned int val, clk_sel_val;
+	struct net_device *netdev = dev_get_drvdata(dwmac->dev);
+	unsigned int val, clk_sel_val = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dwmac->lock, flags);
@@ -85,7 +87,9 @@ static void visconti_eth_fix_mac_speed(v
 		break;
 	default:
 		/* No bit control */
-		break;
+		netdev_err(netdev, "Unsupported speed request (%d)", speed);
+		spin_unlock_irqrestore(&dwmac->lock, flags);
+		return;
 	}
 
 	writel(val, dwmac->reg + MAC_CTRL_REG);
@@ -230,6 +234,7 @@ static int visconti_eth_dwmac_probe(stru
 
 	spin_lock_init(&dwmac->lock);
 	dwmac->reg = stmmac_res.addr;
+	dwmac->dev = &pdev->dev;
 	plat_dat->bsp_priv = dwmac;
 	plat_dat->fix_mac_speed = visconti_eth_fix_mac_speed;
 


