Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05A4A4492
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343974AbiAaLbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376919AbiAaLZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8682BC034007;
        Mon, 31 Jan 2022 03:15:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49821B82A5F;
        Mon, 31 Jan 2022 11:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACA3C340E8;
        Mon, 31 Jan 2022 11:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627744;
        bh=HbYfrjwt8H/vzQGQ7TPm1AUDImSS1Yp0zKMJ6+kYdjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTX7ly7CAUJ+TCf2FqKgzbqdeJhwIqUOPugS6hvNuMzx28EVGe+7OtY1hc8Mn7aWA
         lzxKDjwUR4TBZVQGL8CcdtWeb/RcOnrK6Ym14fgcj3bD8pENgmjrun5tJJF7QHibaT
         oVfn2PPutwmE+07gBnvhZZm1beq2QcGmCgFFRt3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 012/200] net: stmmac: skip only stmmac_ptp_register when resume from suspend
Date:   Mon, 31 Jan 2022 11:54:35 +0100
Message-Id: <20220131105233.971639659@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>

commit 0735e639f129dff455aeb91da291f5c578cc33db upstream.

When resume from suspend, besides skipping PTP registration, it also
skipping PTP HW initialization. This could cause PTP clock not able to
operate properly when resume from suspend.

To fix this, only stmmac_ptp_register() is skipped when resume from
suspend.

Fixes: fe1319291150 ("stmmac: Don't init ptp again when resume from suspend/hibernation")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -924,8 +924,6 @@ static int stmmac_init_ptp(struct stmmac
 	priv->hwts_tx_en = 0;
 	priv->hwts_rx_en = 0;
 
-	stmmac_ptp_register(priv);
-
 	return 0;
 }
 
@@ -3248,7 +3246,7 @@ static int stmmac_fpe_start_wq(struct st
 /**
  * stmmac_hw_setup - setup mac in a usable state.
  *  @dev : pointer to the device structure.
- *  @init_ptp: initialize PTP if set
+ *  @ptp_register: register PTP if set
  *  Description:
  *  this is the main function to setup the HW in a usable state because the
  *  dma engine is reset, the core registers are configured (e.g. AXI,
@@ -3258,7 +3256,7 @@ static int stmmac_fpe_start_wq(struct st
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
+static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
@@ -3315,13 +3313,13 @@ static int stmmac_hw_setup(struct net_de
 
 	stmmac_mmc_setup(priv);
 
-	if (init_ptp) {
-		ret = stmmac_init_ptp(priv);
-		if (ret == -EOPNOTSUPP)
-			netdev_warn(priv->dev, "PTP not supported by HW\n");
-		else if (ret)
-			netdev_warn(priv->dev, "PTP init failed\n");
-	}
+	ret = stmmac_init_ptp(priv);
+	if (ret == -EOPNOTSUPP)
+		netdev_warn(priv->dev, "PTP not supported by HW\n");
+	else if (ret)
+		netdev_warn(priv->dev, "PTP init failed\n");
+	else if (ptp_register)
+		stmmac_ptp_register(priv);
 
 	priv->eee_tw_timer = STMMAC_DEFAULT_TWT_LS;
 


