Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EA533BAB9
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbhCOOKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232105AbhCON6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C143364F26;
        Mon, 15 Mar 2021 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816684;
        bh=wdYP8A9YSW13Zm9rj4iecbtkbcaVWHR0gA37V1xYZGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnnfteiwzMNig/MtCnAe+84Zv3a8ySqDp6xJRjVB0K5BhmGNZmx+eIvtOWTX5btUS
         TgEJymPJLe17PYwoM418OUIeg3J6HTaRFoKq0QIWt/d+G4b3b6bRCGlQhMh5Z9VBDr
         fb5ka3UJysxvFvMX8FF+4Cin+oSA7MpqXSgo7OEE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 054/290] net: stmmac: Fix VLAN filter delete timeout issue in Intel mGBE SGMII
Date:   Mon, 15 Mar 2021 14:52:27 +0100
Message-Id: <20210315135543.756630933@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ong Boon Leong <boon.leong.ong@intel.com>

commit 9a7b3950c7e15968e23d83be215e95ccc7c92a53 upstream.

For Intel mGbE controller, MAC VLAN filter delete operation will time-out
if serdes power-down sequence happened first during driver remove() with
below message.

[82294.764958] intel-eth-pci 0000:00:1e.4 eth2: stmmac_dvr_remove: removing driver
[82294.778677] intel-eth-pci 0000:00:1e.4 eth2: Timeout accessing MAC_VLAN_Tag_Filter
[82294.779997] intel-eth-pci 0000:00:1e.4 eth2: failed to kill vid 0081/0
[82294.947053] intel-eth-pci 0000:00:1d.2 eth1: stmmac_dvr_remove: removing driver
[82295.002091] intel-eth-pci 0000:00:1d.1 eth0: stmmac_dvr_remove: removing driver

Therefore, we delay the serdes power-down to be after unregister_netdev()
which triggers the VLAN filter delete.

Fixes: b9663b7ca6ff ("net: stmmac: Enable SERDES power up/down sequence")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5114,13 +5114,16 @@ int stmmac_dvr_remove(struct device *dev
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
 	stmmac_stop_all_dma(priv);
+	stmmac_mac_set(priv, priv->ioaddr, false);
+	netif_carrier_off(ndev);
+	unregister_netdev(ndev);
 
+	/* Serdes power down needs to happen after VLAN filter
+	 * is deleted that is triggered by unregister_netdev().
+	 */
 	if (priv->plat->serdes_powerdown)
 		priv->plat->serdes_powerdown(ndev, priv->plat->bsp_priv);
 
-	stmmac_mac_set(priv, priv->ioaddr, false);
-	netif_carrier_off(ndev);
-	unregister_netdev(ndev);
 #ifdef CONFIG_DEBUG_FS
 	stmmac_exit_fs(ndev);
 #endif


