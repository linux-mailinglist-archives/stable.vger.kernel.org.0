Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CECD35BD38
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbhDLIsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:48:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238022AbhDLIrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:47:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECB1A60241;
        Mon, 12 Apr 2021 08:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217214;
        bh=Z5yp3c1JKRaDWcp/FAKciNoNk4fIeyswpLIHlDudOWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsI7D3YQXpM9Rf1PJPTZ3WoLoCKhbnPS6CA7M7+bZRxip0aTlJ4HDWWBwU9vkp+8l
         hG9xR4VojJ6kPMXcWoPpYfHRAT05JjQX22KKCatTertlaKApjYRLNxAz4kV/hbAbDb
         kFfW/mZ+tYrX2zL4aqX8ZkXd3JtIo+YKDWePdO/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/111] net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits
Date:   Mon, 12 Apr 2021 10:40:22 +0200
Message-Id: <20210412084005.718187166@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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
[ Updated after the upstream commit 3e9005be87777 required some changes
  for Linux 5.4 ]
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e0f5d406e6c0..dc75e798dbff 100644
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
@@ -817,9 +821,11 @@ static int gswip_setup(struct dsa_switch *ds)
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
@@ -1594,6 +1600,9 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
+
+		/* Configure the RMII clock as output: */
+		miicfg |= GSWIP_MII_CFG_RMII_CLK;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
@@ -1606,7 +1615,11 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 			"Unsupported interface: %d\n", state->interface);
 		return;
 	}
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_MODE_MASK, miicfg, port);
+
+	gswip_mii_mask_cfg(priv,
+			   GSWIP_MII_CFG_MODE_MASK | GSWIP_MII_CFG_RMII_CLK |
+			   GSWIP_MII_CFG_RGMII_IBS | GSWIP_MII_CFG_LDCLKDIS,
+			   miicfg, port);
 
 	gswip_port_set_speed(priv, port, state->speed, state->interface);
 	gswip_port_set_duplex(priv, port, state->duplex);
-- 
2.30.2



