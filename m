Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC5F61EE2D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfEOLSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730754AbfEOLSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E604C206BF;
        Wed, 15 May 2019 11:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919085;
        bh=fEl58TO3qbyRhsWQ3MIb3kKu4P+hvOm4yJGY1tFADg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXEqGlyo5BP7RGchqrN2tZL9q856fijiOS1zNKdPK5074ThNiod/y997TuGLppcpY
         sFlf94YuQYe3yJUnwo1wUcNTB16Wih7c683P+Lc2KyYQN4rUvDzkuLlIK0ndhdghIA
         yhz+0yt9NZk6VFV7XAskxY80YbY7Tny9L0OxITtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 062/115] net: stmmac: Move debugfs init/exit to ->probe()/->remove()
Date:   Wed, 15 May 2019 12:55:42 +0200
Message-Id: <20190515090704.047782660@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5f2b8b62786853341a20d4cd4948f9cbca3db002 ]

Setting up and tearing down debugfs is current unbalanced, as seen by
this error during resume from suspend:

    [  752.134067] dwc-eth-dwmac 2490000.ethernet eth0: ERROR failed to create debugfs directory
    [  752.134347] dwc-eth-dwmac 2490000.ethernet eth0: stmmac_hw_setup: failed debugFS registration

The imbalance happens because the driver creates the debugfs hierarchy
when the device is opened and tears it down when the device is closed.
There's little gain in that, and it could be argued that it is even
surprising because it's not usually done for other devices. Fix the
imbalance by moving the debugfs creation and teardown to the driver's
->probe() and ->remove() implementations instead.

Note that the ring descriptors cannot be read while the interface is
down, so make sure to return an empty file when the descriptors_status
debugfs file is read.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Acked-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0f85e540001ff..f4df9ab0aed5f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2530,12 +2530,6 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 			netdev_warn(priv->dev, "PTP init failed\n");
 	}
 
-#ifdef CONFIG_DEBUG_FS
-	ret = stmmac_init_fs(dev);
-	if (ret < 0)
-		netdev_warn(priv->dev, "%s: failed debugFS registration\n",
-			    __func__);
-#endif
 	priv->tx_lpi_timer = STMMAC_DEFAULT_TWT_LS;
 
 	if ((priv->use_riwt) && (priv->hw->dma->rx_watchdog)) {
@@ -2729,10 +2723,6 @@ static int stmmac_release(struct net_device *dev)
 
 	netif_carrier_off(dev);
 
-#ifdef CONFIG_DEBUG_FS
-	stmmac_exit_fs(dev);
-#endif
-
 	stmmac_release_ptp(priv);
 
 	return 0;
@@ -3839,6 +3829,9 @@ static int stmmac_sysfs_ring_read(struct seq_file *seq, void *v)
 	u32 tx_count = priv->plat->tx_queues_to_use;
 	u32 queue;
 
+	if ((dev->flags & IFF_UP) == 0)
+		return 0;
+
 	for (queue = 0; queue < rx_count; queue++) {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 
@@ -4310,6 +4303,13 @@ int stmmac_dvr_probe(struct device *device,
 		goto error_netdev_register;
 	}
 
+#ifdef CONFIG_DEBUG_FS
+	ret = stmmac_init_fs(ndev);
+	if (ret < 0)
+		netdev_warn(priv->dev, "%s: failed debugFS registration\n",
+			    __func__);
+#endif
+
 	return ret;
 
 error_netdev_register:
@@ -4343,6 +4343,9 @@ int stmmac_dvr_remove(struct device *dev)
 
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
+#ifdef CONFIG_DEBUG_FS
+	stmmac_exit_fs(ndev);
+#endif
 	stmmac_stop_all_dma(priv);
 
 	priv->hw->mac->set_mac(priv->ioaddr, false);
-- 
2.20.1



