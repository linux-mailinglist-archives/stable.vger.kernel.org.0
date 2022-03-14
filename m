Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA7C4D82F8
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240701AbiCNML6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242569AbiCNMKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E8027145;
        Mon, 14 Mar 2022 05:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0119161314;
        Mon, 14 Mar 2022 12:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D009C340E9;
        Mon, 14 Mar 2022 12:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259738;
        bh=qg4Tamhr5MaCuWqdiN/NuTky4KqcE9z6OeSBMmRh3WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvPmbewrQ8t0Yo7uxXBkdoqdEtfhfwXkZoEhidMlHpzI7J5uo4JcXidEFmTxqEbw9
         4EkPDSaDFUZM9vQqOVP/IDk8JCiEfXm1oPLn4+Uko0P1wopAsAwoaZJQ9V8/7NppVG
         N5uOENPfSB7J/LIdiU905YjkYbcfc1XBT2ZL096k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/110] net: ethernet: lpc_eth: Handle error for clk_enable
Date:   Mon, 14 Mar 2022 12:53:39 +0100
Message-Id: <20220314112744.074078873@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 2169b79258c8be803d2595d6456b1e77129fe154 ]

As the potential failure of the clk_enable(),
it should be better to check it and return error
if fails.

Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index c910fa2f40a4..919140522885 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1469,6 +1469,7 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct netdata_local *pldat;
+	int ret;
 
 	if (device_may_wakeup(&pdev->dev))
 		disable_irq_wake(ndev->irq);
@@ -1478,7 +1479,9 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
 			pldat = netdev_priv(ndev);
 
 			/* Enable interface clock */
-			clk_enable(pldat->clk);
+			ret = clk_enable(pldat->clk);
+			if (ret)
+				return ret;
 
 			/* Reset and initialize */
 			__lpc_eth_reset(pldat);
-- 
2.34.1



