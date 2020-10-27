Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0ADE29B628
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796982AbgJ0PU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796976AbgJ0PU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:20:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54DE420728;
        Tue, 27 Oct 2020 15:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812054;
        bh=OfHh6nhWWArbokHqlxxtz0cg0SoxDgOag/ODKgJdD8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=laUtxQ98Ntwec2VaLU1BZywpPxkbWzwrgJgj/ckEABNYZNGRYb29Tpb6a6vgRTnMi
         56WQdet5+OizgQ7sFIPcVaLM3G2haVhr+CkbYg+lULaIn5HtDB1Hk75CRAXMvx6esY
         td6NxIgPS3PE9GN8wdtxbwF1HMIIJFsj0Y8KqgXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 046/757] netsec: ignore phy-mode device property on ACPI systems
Date:   Tue, 27 Oct 2020 14:44:56 +0100
Message-Id: <20201027135452.696109373@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit acd7aaf51b20263a7e62d2a26569988c63bdd3d8 ]

Since commit bbc4d71d63549bc ("net: phy: realtek: fix rtl8211e rx/tx
delay config"), the Realtek PHY driver will override any TX/RX delay
set by hardware straps if the phy-mode device property does not match.

This is causing problems on SynQuacer based platforms (the only SoC
that incorporates the netsec hardware), since many were built with
this Realtek PHY, and shipped with firmware that defines the phy-mode
as 'rgmii', even though the PHY is configured for TX and RX delay using
pull-ups.

>From the driver's perspective, we should not make any assumptions in
the general case that the PHY hardware does not require any initial
configuration. However, the situation is slightly different for ACPI
boot, since it implies rich firmware with AML abstractions to handle
hardware details that are not exposed to the OS. So in the ACPI case,
it is reasonable to assume that the PHY comes up in the right mode,
regardless of whether the mode is set by straps, by boot time firmware
or by AML executed by the ACPI interpreter.

So let's ignore the 'phy-mode' device property when probing the netsec
driver in ACPI mode, and hardcode the mode to PHY_INTERFACE_MODE_NA,
which should work with any PHY provided that it is configured by the
time the driver attaches to it. While at it, document that omitting
the mode is permitted for DT probing as well, by setting the phy-mode
DT property to the empty string.

Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20201018163625.2392-1-ardb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/socionext-netsec.txt |    4 +-
 drivers/net/ethernet/socionext/netsec.c                    |   24 +++++++++----
 2 files changed, 20 insertions(+), 8 deletions(-)

--- a/Documentation/devicetree/bindings/net/socionext-netsec.txt
+++ b/Documentation/devicetree/bindings/net/socionext-netsec.txt
@@ -30,7 +30,9 @@ Optional properties: (See ethernet.txt f
 - max-frame-size: See ethernet.txt in the same directory.
 
 The MAC address will be determined using the optional properties
-defined in ethernet.txt.
+defined in ethernet.txt. The 'phy-mode' property is required, but may
+be set to the empty string if the PHY configuration is programmed by
+the firmware or set by hardware straps, and needs to be preserved.
 
 Example:
 	eth0: ethernet@522d0000 {
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -6,6 +6,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/acpi.h>
 #include <linux/of_mdio.h>
+#include <linux/of_net.h>
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -1833,6 +1834,14 @@ static const struct net_device_ops netse
 static int netsec_of_probe(struct platform_device *pdev,
 			   struct netsec_priv *priv, u32 *phy_addr)
 {
+	int err;
+
+	err = of_get_phy_mode(pdev->dev.of_node, &priv->phy_interface);
+	if (err) {
+		dev_err(&pdev->dev, "missing required property 'phy-mode'\n");
+		return err;
+	}
+
 	priv->phy_np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (!priv->phy_np) {
 		dev_err(&pdev->dev, "missing required property 'phy-handle'\n");
@@ -1859,6 +1868,14 @@ static int netsec_acpi_probe(struct plat
 	if (!IS_ENABLED(CONFIG_ACPI))
 		return -ENODEV;
 
+	/* ACPI systems are assumed to configure the PHY in firmware, so
+	 * there is really no need to discover the PHY mode from the DSDT.
+	 * Since firmware is known to exist in the field that configures the
+	 * PHY correctly but passes the wrong mode string in the phy-mode
+	 * device property, we have no choice but to ignore it.
+	 */
+	priv->phy_interface = PHY_INTERFACE_MODE_NA;
+
 	ret = device_property_read_u32(&pdev->dev, "phy-channel", phy_addr);
 	if (ret) {
 		dev_err(&pdev->dev,
@@ -1995,13 +2012,6 @@ static int netsec_probe(struct platform_
 	priv->msg_enable = NETIF_MSG_TX_ERR | NETIF_MSG_HW | NETIF_MSG_DRV |
 			   NETIF_MSG_LINK | NETIF_MSG_PROBE;
 
-	priv->phy_interface = device_get_phy_mode(&pdev->dev);
-	if ((int)priv->phy_interface < 0) {
-		dev_err(&pdev->dev, "missing required property 'phy-mode'\n");
-		ret = -ENODEV;
-		goto free_ndev;
-	}
-
 	priv->ioaddr = devm_ioremap(&pdev->dev, mmio_res->start,
 				    resource_size(mmio_res));
 	if (!priv->ioaddr) {


