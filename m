Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA7B4D8113
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbiCNLio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239550AbiCNLiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:38:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC90F424A9;
        Mon, 14 Mar 2022 04:37:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33469CE1173;
        Mon, 14 Mar 2022 11:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25685C340E9;
        Mon, 14 Mar 2022 11:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257822;
        bh=FvaAcrh3CRXnvv0gw1cYKnnHim79vbLSJegrEr3zwZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJ/tFiSixJ5Zr2YkWSSAD88LvH6FeWQcZKfm0WdvGGi0JhdQ/RQ4H5H54eqKuxO0P
         7GYQo8S3Dt4qvXcvuFd6fMIATe3Ywy4xodYp5wvkd47Aow6FaX85ubaktQjzua+CUT
         ZFdeIeiO/zsQTiP/daxSb1irL/XekXfl7E1B7+AI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/23] net: ethernet: lpc_eth: Handle error for clk_enable
Date:   Mon, 14 Mar 2022 12:34:18 +0100
Message-Id: <20220314112731.210973062@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.050583127@linuxfoundation.org>
References: <20220314112731.050583127@linuxfoundation.org>
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
index 415ac33341c5..27c22f0e9d25 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1512,6 +1512,7 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct netdata_local *pldat;
+	int ret;
 
 	if (device_may_wakeup(&pdev->dev))
 		disable_irq_wake(ndev->irq);
@@ -1521,7 +1522,9 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
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



