Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B16E28BA53
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbgJLNeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389062AbgJLNcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:32:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EE4A20878;
        Mon, 12 Oct 2020 13:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509572;
        bh=Aa1hEP8l8eNGl0K2ERTxmiFBm7d9nfbiKUMwCxfGjHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjnF/IdhbWz79IaTqLeSEvAZBVuMxDW9hiJKESjDyrJ4edftDe5ROqwwCfCwpGjmJ
         L2dXAUxzKvZeAgRsQ/P7dQWvHu1vjLpTkG/Qs7oGHgAuvxMhthS/CTxQw2gr/zNL8b
         OlybDLTkxAS4nL1PAusCMHlW91oyhi2Yo6W8xJkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Voon Weifeng <weifeng.voon@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 33/39] net: stmmac: removed enabling eee in EEE set callback
Date:   Mon, 12 Oct 2020 15:27:03 +0200
Message-Id: <20201012132629.693707225@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

[ Upstream commit 7241c5a697479c7d0c5a96595822cdab750d41ae ]

EEE should be only be enabled during stmmac_mac_link_up() when the
link are up and being set up properly. set_eee should only do settings
configuration and disabling the eee.

Without this fix, turning on EEE using ethtool will return
"Operation not supported". This is due to the driver is in a dead loop
waiting for eee to be advertised in the for eee to be activated but the
driver will only configure the EEE advertisement after the eee is
activated.

Ethtool should only return "Operation not supported" if there is no EEE
capbility in the MAC controller.

Fixes: 8a7493e58ad6 ("net: stmmac: Fix a race in EEE enable callback")
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Acked-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c  | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index fbf701e5f1e9f..6fe441696882d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -616,23 +616,16 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
 
-	if (!edata->eee_enabled) {
+	if (!priv->dma_cap.eee)
+		return -EOPNOTSUPP;
+
+	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
-	} else {
-		/* We are asking for enabling the EEE but it is safe
-		 * to verify all by invoking the eee_init function.
-		 * In case of failure it will return an error.
-		 */
-		edata->eee_enabled = stmmac_eee_init(priv);
-		if (!edata->eee_enabled)
-			return -EOPNOTSUPP;
-	}
 
 	ret = phy_ethtool_set_eee(dev->phydev, edata);
 	if (ret)
 		return ret;
 
-	priv->eee_enabled = edata->eee_enabled;
 	priv->tx_lpi_timer = edata->tx_lpi_timer;
 	return 0;
 }
-- 
2.25.1



