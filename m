Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0795F35BF65
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238037AbhDLJGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238988AbhDLJCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4A5E61220;
        Mon, 12 Apr 2021 09:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218052;
        bh=hVbYCz/9WfYrFQmnE77euXnoc9pDzhUZ0wwqOUp4IAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4H/0jHryT8UCFQxDHQtYHibNpRROEf1n3gki+kr9vFf499uh82R6rdByPGqydm08
         Cm5FsRsZVTH6r2QyUvvVlbNRKWLpBQK7PSUnxE70mnNQaBdKEMb8jnpndG2YFX0aSX
         m0qQvYJtc/VxngT8SAv+WUX8LPjEtLqTZkJ4eyOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 018/210] net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits
Date:   Mon, 12 Apr 2021 10:38:43 +0200
Message-Id: <20210412084016.614703345@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

commit 4b5923249b8fa427943b50b8f35265176472be38 upstream.

There are a few more bits in the GSWIP_MII_CFG register for which we
did rely on the boot-loader (or the hardware defaults) to set them up
properly.

For some external RMII PHYs we need to select the GSWIP_MII_CFG_RMII_CLK
bit and also we should un-set it for non-RMII PHYs. The
GSWIP_MII_CFG_RMII_CLK bit is ignored for other PHY connection modes.

The GSWIP IP also supports in-band auto-negotiation for RGMII PHYs when
the GSWIP_MII_CFG_RGMII_IBS bit is set. Clear this bit always as there's
no known hardware which uses this (so it is not tested yet).

Clear the xMII isolation bit when set at initialization time if it was
previously set by the bootloader. Not doing so could lead to no traffic
(neither RX nor TX) on a port with this bit set.

While here, also add the GSWIP_MII_CFG_RESET bit. We don't need to
manage it because this bit is self-clearning when set. We still add it
here to get a better overview of the GSWIP_MII_CFG register.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Cc: stable@vger.kernel.org
Suggested-by: Hauke Mehrtens <hauke@hauke-m.de>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lantiq_gswip.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -93,8 +93,12 @@
 
 /* GSWIP MII Registers */
 #define GSWIP_MII_CFGp(p)		(0x2 * (p))
+#define  GSWIP_MII_CFG_RESET		BIT(15)
 #define  GSWIP_MII_CFG_EN		BIT(14)
+#define  GSWIP_MII_CFG_ISOLATE		BIT(13)
 #define  GSWIP_MII_CFG_LDCLKDIS		BIT(12)
+#define  GSWIP_MII_CFG_RGMII_IBS	BIT(8)
+#define  GSWIP_MII_CFG_RMII_CLK		BIT(7)
 #define  GSWIP_MII_CFG_MODE_MIIP	0x0
 #define  GSWIP_MII_CFG_MODE_MIIM	0x1
 #define  GSWIP_MII_CFG_MODE_RMIIP	0x2
@@ -833,9 +837,11 @@ static int gswip_setup(struct dsa_switch
 	/* Configure the MDIO Clock 2.5 MHz */
 	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
 
-	/* Disable the xMII link */
+	/* Disable the xMII interface and clear it's isolation bit */
 	for (i = 0; i < priv->hw_info->max_ports; i++)
-		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
+		gswip_mii_mask_cfg(priv,
+				   GSWIP_MII_CFG_EN | GSWIP_MII_CFG_ISOLATE,
+				   0, i);
 
 	/* enable special tag insertion on cpu port */
 	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
@@ -1611,6 +1617,9 @@ static void gswip_phylink_mac_config(str
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
+
+		/* Configure the RMII clock as output: */
+		miicfg |= GSWIP_MII_CFG_RMII_CLK;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
@@ -1623,7 +1632,11 @@ static void gswip_phylink_mac_config(str
 			"Unsupported interface: %d\n", state->interface);
 		return;
 	}
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_MODE_MASK, miicfg, port);
+
+	gswip_mii_mask_cfg(priv,
+			   GSWIP_MII_CFG_MODE_MASK | GSWIP_MII_CFG_RMII_CLK |
+			   GSWIP_MII_CFG_RGMII_IBS | GSWIP_MII_CFG_LDCLKDIS,
+			   miicfg, port);
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_RGMII_ID:


