Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8492F15CE
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731337AbhAKNpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbhAKNLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:11:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EE692250F;
        Mon, 11 Jan 2021 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370653;
        bh=XDAwESQ4s9euZtoYkuxHhJ1wUbaYZ6pzGd2Ec/bDwO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2jNKQyMRmG58ZdpIMbYLq+wuTBPz+WgKkSZp3RxcTVs4HfdawcjHjwHj55jzS2jBt
         +5Ny4iNGyI2AoFttU2NvACUkmaf4NeCr+ITskQr/bFAmYdoAeXe5fNCHedgElkIehv
         6XfjGbZrJcVkgViRcZR8c/8oB1OKV7qxaqf+mz3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 40/92] net: dsa: lantiq_gswip: Fix GSWIP_MII_CFG(p) register access
Date:   Mon, 11 Jan 2021 14:01:44 +0100
Message-Id: <20210111130041.081687151@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 709a3c9dff2a639966ae7d8ba6239d2b8aba036d ]

There is one GSWIP_MII_CFG register for each switch-port except the CPU
port. The register offset for the first port is 0x0, 0x02 for the
second, 0x04 for the third and so on.

Update the driver to not only restrict the GSWIP_MII_CFG registers to
ports 0, 1 and 5. Handle ports 0..5 instead but skip the CPU port. This
means we are not overwriting the configuration for the third port (port
two since we start counting from zero) with the settings for the sixth
port (with number five) anymore.

The GSWIP_MII_PCDU(p) registers are not updated because there's really
only three (one for each of the following ports: 0, 1, 5).

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lantiq_gswip.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -92,9 +92,7 @@
 					 GSWIP_MDIO_PHY_FDUP_MASK)
 
 /* GSWIP MII Registers */
-#define GSWIP_MII_CFG0			0x00
-#define GSWIP_MII_CFG1			0x02
-#define GSWIP_MII_CFG5			0x04
+#define GSWIP_MII_CFGp(p)		(0x2 * (p))
 #define  GSWIP_MII_CFG_EN		BIT(14)
 #define  GSWIP_MII_CFG_LDCLKDIS		BIT(12)
 #define  GSWIP_MII_CFG_MODE_MIIP	0x0
@@ -392,17 +390,9 @@ static void gswip_mii_mask(struct gswip_
 static void gswip_mii_mask_cfg(struct gswip_priv *priv, u32 clear, u32 set,
 			       int port)
 {
-	switch (port) {
-	case 0:
-		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG0);
-		break;
-	case 1:
-		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG1);
-		break;
-	case 5:
-		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG5);
-		break;
-	}
+	/* There's no MII_CFG register for the CPU port */
+	if (!dsa_is_cpu_port(priv->ds, port))
+		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFGp(port));
 }
 
 static void gswip_mii_mask_pcdu(struct gswip_priv *priv, u32 clear, u32 set,
@@ -806,9 +796,8 @@ static int gswip_setup(struct dsa_switch
 	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
 
 	/* Disable the xMII link */
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, 0);
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, 1);
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, 5);
+	for (i = 0; i < priv->hw_info->max_ports; i++)
+		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
 
 	/* enable special tag insertion on cpu port */
 	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,


