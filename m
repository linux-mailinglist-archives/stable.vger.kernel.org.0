Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5952528B70B
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbgJLNkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730025AbgJLNjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:39:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E84A2087E;
        Mon, 12 Oct 2020 13:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509959;
        bh=OGdeTlFKw57eyKFUEiRtSsYgTwVINWma8HeXhYBjhbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pxZI7QMSOqc6JlC+UoNDZmPDvCPnO4hPQPbmrEF4xw14qOYtUvHfFfcTIry431mLR
         96QjIxDV5uqKTLjcxT6zyluzH9Q+MJ1fUrR6LQ11sKOnuOQhuEVcYZADRN5VvyxTE5
         ugF8BiooXAAbwnHV2BXgwmWkC6lfXNZRCEsNbf64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 04/49] Revert "ravb: Fixed to be able to unload modules"
Date:   Mon, 12 Oct 2020 15:26:50 +0200
Message-Id: <20201012132629.654184210@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 77972b55fb9d35d4a6b0abca99abffaa4ec6a85b upstream.

This reverts commit 1838d6c62f57836639bd3d83e7855e0ee4f6defc.

This commit moved the ravb_mdio_init() call (and thus the
of_mdiobus_register() call) from the ravb_probe() to the ravb_open()
call.  This causes a regression during system resume (s2idle/s2ram), as
new PHY devices cannot be bound while suspended.

During boot, the Micrel PHY is detected like this:

    Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=228)
    ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

During system suspend, (A) defer_all_probes is set to true, and (B)
usermodehelper_disabled is set to UMH_DISABLED, to avoid drivers being
probed while suspended.

  A. If CONFIG_MODULES=n, phy_device_register() calling device_add()
     merely adds the device, but does not probe it yet, as
     really_probe() returns early due to defer_all_probes being set:

       dpm_resume+0x128/0x4f8
	 device_resume+0xcc/0x1b0
	   dpm_run_callback+0x74/0x340
	     ravb_resume+0x190/0x1b8
	       ravb_open+0x84/0x770
		 of_mdiobus_register+0x1e0/0x468
		   of_mdiobus_register_phy+0x1b8/0x250
		     of_mdiobus_phy_device_register+0x178/0x1e8
		       phy_device_register+0x114/0x1b8
			 device_add+0x3d4/0x798
			   bus_probe_device+0x98/0xa0
			     device_initial_probe+0x10/0x18
			       __device_attach+0xe4/0x140
				 bus_for_each_drv+0x64/0xc8
				   __device_attach_driver+0xb8/0xe0
				     driver_probe_device.part.11+0xc4/0xd8
				       really_probe+0x32c/0x3b8

     Later, phy_attach_direct() notices no PHY driver has been bound,
     and falls back to the Generic PHY, leading to degraded operation:

       Generic PHY e6800000.ethernet-ffffffff:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=POLL)
       ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

  B. If CONFIG_MODULES=y, request_module() returns early with -EBUSY due
     to UMH_DISABLED, and MDIO initialization fails completely:

       mdio_bus e6800000.ethernet-ffffffff:00: error -16 loading PHY driver module for ID 0x00221622
       ravb e6800000.ethernet eth0: failed to initialize MDIO
       PM: dpm_run_callback(): ravb_resume+0x0/0x1b8 returns -16
       PM: Device e6800000.ethernet failed to resume: error -16

     Ignoring -EBUSY in phy_request_driver_module(), like was done for
     -ENOENT in commit 21e194425abd65b5 ("net: phy: fix issue with loading
     PHY driver w/o initramfs"), would makes it fall back to the Generic
     PHY, like in the CONFIG_MODULES=n case.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/renesas/ravb_main.c |  110 +++++++++++++++----------------
 1 file changed, 55 insertions(+), 55 deletions(-)

--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1337,51 +1337,6 @@ static inline int ravb_hook_irq(unsigned
 	return error;
 }
 
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
 /* Network device open function for Ethernet AVB */
 static int ravb_open(struct net_device *ndev)
 {
@@ -1390,13 +1345,6 @@ static int ravb_open(struct net_device *
 	struct device *dev = &pdev->dev;
 	int error;
 
-	/* MDIO bus init */
-	error = ravb_mdio_init(priv);
-	if (error) {
-		netdev_err(ndev, "failed to initialize MDIO\n");
-		return error;
-	}
-
 	napi_enable(&priv->napi[RAVB_BE]);
 	napi_enable(&priv->napi[RAVB_NC]);
 
@@ -1474,7 +1422,6 @@ out_free_irq:
 out_napi_off:
 	napi_disable(&priv->napi[RAVB_NC]);
 	napi_disable(&priv->napi[RAVB_BE]);
-	ravb_mdio_release(priv);
 	return error;
 }
 
@@ -1774,8 +1721,6 @@ static int ravb_close(struct net_device
 	ravb_ring_free(ndev, RAVB_BE);
 	ravb_ring_free(ndev, RAVB_NC);
 
-	ravb_mdio_release(priv);
-
 	return 0;
 }
 
@@ -1922,6 +1867,51 @@ static const struct net_device_ops ravb_
 	.ndo_set_features	= ravb_set_features,
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
 static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,etheravb-r8a7794", .data = (void *)RCAR_GEN2 },
@@ -2148,6 +2138,13 @@ static int ravb_probe(struct platform_de
 		eth_hw_addr_random(ndev);
 	}
 
+	/* MDIO bus init */
+	error = ravb_mdio_init(priv);
+	if (error) {
+		dev_err(&pdev->dev, "failed to initialize MDIO\n");
+		goto out_dma_free;
+	}
+
 	netif_napi_add(ndev, &priv->napi[RAVB_BE], ravb_poll, 64);
 	netif_napi_add(ndev, &priv->napi[RAVB_NC], ravb_poll, 64);
 
@@ -2169,6 +2166,8 @@ static int ravb_probe(struct platform_de
 out_napi_del:
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
+	ravb_mdio_release(priv);
+out_dma_free:
 	dma_free_coherent(ndev->dev.parent, priv->desc_bat_size, priv->desc_bat,
 			  priv->desc_bat_dma);
 
@@ -2200,6 +2199,7 @@ static int ravb_remove(struct platform_d
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
+	ravb_mdio_release(priv);
 	pm_runtime_disable(&pdev->dev);
 	free_netdev(ndev);
 	platform_set_drvdata(pdev, NULL);


