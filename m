Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF21E4A2EA0
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242620AbiA2MB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiA2MB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:01:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDD5C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 04:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 205D3B822B2
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275EFC340E5;
        Sat, 29 Jan 2022 12:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643457684;
        bh=OfF9LhE4SyXuxjxOFAXZ3vvYcLdOg26v5CGZVDhV4RY=;
        h=Subject:To:Cc:From:Date:From;
        b=eBYav0TDWjDahrUWLMdo2cMwBFMkC79WPyI9Q8ju9fJz5J+GJsb+2pLxTBdbusXaY
         CK6j1l8fKyqEql2BnpHZILJozWOHquEAyvz2QYPts+dy93qVH+F94rJQTgwfNgaeSV
         1nJ9DsegTqDEjExdsPRITiB8+wp3JlQhEKPG4oj4=
Subject: FAILED: patch "[PATCH] net: stmmac: skip only stmmac_ptp_register when resume from" failed to apply to 4.4-stable tree
To:     mohammad.athari.ismail@intel.com, davem@davemloft.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:01:21 +0100
Message-ID: <1643457681186119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0735e639f129dff455aeb91da291f5c578cc33db Mon Sep 17 00:00:00 2001
From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Date: Wed, 26 Jan 2022 17:47:23 +0800
Subject: [PATCH] net: stmmac: skip only stmmac_ptp_register when resume from
 suspend

When resume from suspend, besides skipping PTP registration, it also
skipping PTP HW initialization. This could cause PTP clock not able to
operate properly when resume from suspend.

To fix this, only stmmac_ptp_register() is skipped when resume from
suspend.

Fixes: fe1319291150 ("stmmac: Don't init ptp again when resume from suspend/hibernation")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 25c802344356..639a753266e6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -915,8 +915,6 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
 	priv->hwts_tx_en = 0;
 	priv->hwts_rx_en = 0;
 
-	stmmac_ptp_register(priv);
-
 	return 0;
 }
 
@@ -3242,7 +3240,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
 /**
  * stmmac_hw_setup - setup mac in a usable state.
  *  @dev : pointer to the device structure.
- *  @init_ptp: initialize PTP if set
+ *  @ptp_register: register PTP if set
  *  Description:
  *  this is the main function to setup the HW in a usable state because the
  *  dma engine is reset, the core registers are configured (e.g. AXI,
@@ -3252,7 +3250,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
+static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
@@ -3309,13 +3307,13 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 
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
 

