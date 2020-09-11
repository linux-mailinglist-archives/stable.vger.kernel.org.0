Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F88266693
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgIKR2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgIKM6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:58:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCE802076C;
        Fri, 11 Sep 2020 12:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828933;
        bh=kx2e4of3ZWDzyOT5Xs2w6FJ2lWznfZsKxv7uI27JN08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkREvrn+f7GLLwt5Y7rfHW/dMadWT+2h0LMAcg2kByG8wQkpGBpfTKp60fimMlYf8
         mhJ57/J9HG4cMaAhucWrBuT6UjJ/ay0+llbyyh45sYATfkICIMq21JmzPXsI/TpuZv
         S39PdwOf3CCBVlZS4DkwTjzDK3lCugSt7TnVZqCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 56/62] ravb: Fixed to be able to unload modules
Date:   Fri, 11 Sep 2020 14:46:39 +0200
Message-Id: <20200911122505.184614231@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuusuke Ashizuka <ashiduka@fujitsu.com>

commit 1838d6c62f57836639bd3d83e7855e0ee4f6defc upstream.

When this driver is built as a module, I cannot rmmod it after insmoding
it.
This is because that this driver calls ravb_mdio_init() at the time of
probe, and module->refcnt is incremented by alloc_mdio_bitbang() called
after that.
Therefore, even if ifup is not performed, the driver is in use and rmmod
cannot be performed.

$ lsmod
Module                  Size  Used by
ravb                   40960  1
$ rmmod ravb
rmmod: ERROR: Module ravb is in use

Call ravb_mdio_init() at open and free_mdio_bitbang() at close, thereby
rmmod is possible in the ifdown state.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/renesas/ravb_main.c |  110 +++++++++++++++----------------
 1 file changed, 55 insertions(+), 55 deletions(-)

--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1214,12 +1214,64 @@ static const struct ethtool_ops ravb_eth
 	.get_ts_info		= ravb_get_ts_info,
 };
 
+/* MDIO bus init function */
+static int ravb_mdio_init(struct ravb_private *priv)
+{
+	struct platform_device *pdev = priv->pdev;
+	struct device *dev = &pdev->dev;
+	int error;
+
+	/* Bitbang init */
+	priv->mdiobb.ops = &bb_ops;
+
+	/* MII controller setting */
+	priv->mii_bus = alloc_mdio_bitbang(&priv->mdiobb);
+	if (!priv->mii_bus)
+		return -ENOMEM;
+
+	/* Hook up MII support for ethtool */
+	priv->mii_bus->name = "ravb_mii";
+	priv->mii_bus->parent = dev;
+	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
+		 pdev->name, pdev->id);
+
+	/* Register MDIO bus */
+	error = of_mdiobus_register(priv->mii_bus, dev->of_node);
+	if (error)
+		goto out_free_bus;
+
+	return 0;
+
+out_free_bus:
+	free_mdio_bitbang(priv->mii_bus);
+	return error;
+}
+
+/* MDIO bus release function */
+static int ravb_mdio_release(struct ravb_private *priv)
+{
+	/* Unregister mdio bus */
+	mdiobus_unregister(priv->mii_bus);
+
+	/* Free bitbang info */
+	free_mdio_bitbang(priv->mii_bus);
+
+	return 0;
+}
+
 /* Network device open function for Ethernet AVB */
 static int ravb_open(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	int error;
 
+	/* MDIO bus init */
+	error = ravb_mdio_init(priv);
+	if (error) {
+		netdev_err(ndev, "failed to initialize MDIO\n");
+		return error;
+	}
+
 	napi_enable(&priv->napi[RAVB_BE]);
 	napi_enable(&priv->napi[RAVB_NC]);
 
@@ -1268,6 +1320,7 @@ out_free_irq:
 out_napi_off:
 	napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
+	ravb_mdio_release(priv);
 	return error;
 }
 
@@ -1561,6 +1614,8 @@ static int ravb_close(struct net_device
 	ravb_ring_free(ndev, RAVB_BE);
 	ravb_ring_free(ndev, RAVB_NC);
 
+	ravb_mdio_release(priv);
+
 	return 0;
 }
 
@@ -1664,51 +1719,6 @@ static const struct net_device_ops ravb_
 	.ndo_change_mtu		= eth_change_mtu,
 };
 
-/* MDIO bus init function */
-static int ravb_mdio_init(struct ravb_private *priv)
-{
-	struct platform_device *pdev = priv->pdev;
-	struct device *dev = &pdev->dev;
-	int error;
-
-	/* Bitbang init */
-	priv->mdiobb.ops = &bb_ops;
-
-	/* MII controller setting */
-	priv->mii_bus = alloc_mdio_bitbang(&priv->mdiobb);
-	if (!priv->mii_bus)
-		return -ENOMEM;
-
-	/* Hook up MII support for ethtool */
-	priv->mii_bus->name = "ravb_mii";
-	priv->mii_bus->parent = dev;
-	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
-		 pdev->name, pdev->id);
-
-	/* Register MDIO bus */
-	error = of_mdiobus_register(priv->mii_bus, dev->of_node);
-	if (error)
-		goto out_free_bus;
-
-	return 0;
-
-out_free_bus:
-	free_mdio_bitbang(priv->mii_bus);
-	return error;
-}
-
-/* MDIO bus release function */
-static int ravb_mdio_release(struct ravb_private *priv)
-{
-	/* Unregister mdio bus */
-	mdiobus_unregister(priv->mii_bus);
-
-	/* Free bitbang info */
-	free_mdio_bitbang(priv->mii_bus);
-
-	return 0;
-}
-
 static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,etheravb-r8a7794", .data = (void *)RCAR_GEN2 },
@@ -1847,13 +1857,6 @@ static int ravb_probe(struct platform_de
 		eth_hw_addr_random(ndev);
 	}
 
-	/* MDIO bus init */
-	error = ravb_mdio_init(priv);
-	if (error) {
-		dev_err(&pdev->dev, "failed to initialize MDIO\n");
-		goto out_dma_free;
-	}
-
 	netif_napi_add(ndev, &priv->napi[RAVB_BE], ravb_poll, 64);
 	netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll, 64);
 
@@ -1873,8 +1876,6 @@ static int ravb_probe(struct platform_de
 out_napi_del:
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
-	ravb_mdio_release(priv);
-out_dma_free:
 	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
 			  priv->desc_bat_dma);
 out_release:
@@ -1899,7 +1900,6 @@ static int ravb_remove(struct platform_d
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
-	ravb_mdio_release(priv);
 	pm_runtime_disable(&pdev->dev);
 	free_netdev(ndev);
 	platform_set_drvdata(pdev, NULL);


