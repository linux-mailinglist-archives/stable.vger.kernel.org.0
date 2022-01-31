Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99914A4286
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359847AbiAaLMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377475AbiAaLKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:10:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAA6C06134A;
        Mon, 31 Jan 2022 03:07:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9F4DB82A4D;
        Mon, 31 Jan 2022 11:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDEFC340E8;
        Mon, 31 Jan 2022 11:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627259;
        bh=WJH/WMRQmxbS06uo+5eXwHRkUhuULA/XPYmFL+01HdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txqvAmpENQ0hHp5moA11GlqB9xhU+hMVPtlPotAhVTWBdO5BDg5rA4v23xPwHfUEO
         riRlTskPzjQ1PKd/F8zTAu1qfew0x4Uf3qMr8A4SSUuoEORdyKQ6tBiEe5KQGdGbzV
         otTWj5bJeFJwvPS2h9HbxW5aqW1Rvvr0XQQpYGl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 004/171] net: stmmac: skip only stmmac_ptp_register when resume from suspend
Date:   Mon, 31 Jan 2022 11:54:29 +0100
Message-Id: <20220131105230.116569901@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
 
@@ -3240,7 +3238,7 @@ static int stmmac_fpe_start_wq(struct st
 /**
  * stmmac_hw_setup - setup mac in a usable state.
  *  @dev : pointer to the device structure.
- *  @init_ptp: initialize PTP if set
+ *  @ptp_register: register PTP if set
  *  Description:
  *  this is the main function to setup the HW in a usable state because the
  *  dma engine is reset, the core registers are configured (e.g. AXI,
@@ -3250,7 +3248,7 @@ static int stmmac_fpe_start_wq(struct st
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
+static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
@@ -3307,13 +3305,13 @@ static int stmmac_hw_setup(struct net_de
 
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
 


