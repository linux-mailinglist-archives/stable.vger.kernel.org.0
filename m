Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAE94D80F4
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbiCNLg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239171AbiCNLgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:36:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FA442A32;
        Mon, 14 Mar 2022 04:35:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B62A8B80DBD;
        Mon, 14 Mar 2022 11:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DC6C340E9;
        Mon, 14 Mar 2022 11:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257734;
        bh=QxHQ28wRY2IGzUajMuDSfGiPm+ApCv1p8tDgCACPylg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzle4YppIOn9ua9xCF4JpLwUx9NWbqfcWgUlBaGn31M1EBQDhAPgQ3m6C1g1XaQqi
         9JXXqWqw1sxE981DtETBo56XkhnWRsj0uWFZujPldfx8QA+hGhsAjH/hqYq3V6RC0A
         emIGwl+0Eg0ng10Y+27Gymk/zYJkZwWbqRCYUJNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 04/20] net: ethernet: lpc_eth: Handle error for clk_enable
Date:   Mon, 14 Mar 2022 12:34:05 +0100
Message-Id: <20220314112730.518411329@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112730.388955049@linuxfoundation.org>
References: <20220314112730.388955049@linuxfoundation.org>
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
index ad7b9772a4b2..78f34e87212a 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1515,6 +1515,7 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct netdata_local *pldat;
+	int ret;
 
 	if (device_may_wakeup(&pdev->dev))
 		disable_irq_wake(ndev->irq);
@@ -1524,7 +1525,9 @@ static int lpc_eth_drv_resume(struct platform_device *pdev)
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



