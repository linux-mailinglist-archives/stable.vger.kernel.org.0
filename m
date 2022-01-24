Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B70499181
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379416AbiAXULZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:11:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33746 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378320AbiAXUGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:06:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E8161324;
        Mon, 24 Jan 2022 20:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93889C340E5;
        Mon, 24 Jan 2022 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054810;
        bh=SRAw0h8NYECOGKjSJjF9DsNbnXDNk3/S7oZf5Nhl9fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uIsoq6NJO7/45MSw32TRI5YbyGhkdKTgEA9WrhTWrYsDRsAwbDdZUTYfQJk0HA+zV
         EH+c3ZR9qV73Lrzyc3IFuOwWdHBAGn1+GHEZ+kEzHQGIYpyTQfrZZNi5P3ZUsW7aJ1
         5QNWKBFbfJus/h4jZKjHybb/kNZyf2dYTAsz8K24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 511/563] net/fsl: xgmac_mdio: Add workaround for erratum A-009885
Date:   Mon, 24 Jan 2022 19:44:36 +0100
Message-Id: <20220124184042.137459992@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

commit 6198c722019774d38018457a8bfb9ba3ed8c931e upstream.

Once an MDIO read transaction is initiated, we must read back the data
register within 16 MDC cycles after the transaction completes. Outside
of this window, reads may return corrupt data.

Therefore, disable local interrupts in the critical section, to
maximize the probability that we can satisfy this requirement.

Fixes: d55ad2967d89 ("powerpc/mpc85xx: Create dts components for the FSL QorIQ DPAA FMan")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -49,6 +49,7 @@ struct tgec_mdio_controller {
 struct mdio_fsl_priv {
 	struct	tgec_mdio_controller __iomem *mdio_base;
 	bool	is_little_endian;
+	bool	has_a009885;
 	bool	has_a011043;
 };
 
@@ -184,10 +185,10 @@ static int xgmac_mdio_read(struct mii_bu
 {
 	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
+	unsigned long flags;
 	uint16_t dev_addr;
 	uint32_t mdio_stat;
 	uint32_t mdio_ctl;
-	uint16_t value;
 	int ret;
 	bool endian = priv->is_little_endian;
 
@@ -219,12 +220,18 @@ static int xgmac_mdio_read(struct mii_bu
 			return ret;
 	}
 
+	if (priv->has_a009885)
+		/* Once the operation completes, i.e. MDIO_STAT_BSY clears, we
+		 * must read back the data register within 16 MDC cycles.
+		 */
+		local_irq_save(flags);
+
 	/* Initiate the read */
 	xgmac_write32(mdio_ctl | MDIO_CTL_READ, &regs->mdio_ctl, endian);
 
 	ret = xgmac_wait_until_done(&bus->dev, regs, endian);
 	if (ret)
-		return ret;
+		goto irq_restore;
 
 	/* Return all Fs if nothing was there */
 	if ((xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) &&
@@ -232,13 +239,17 @@ static int xgmac_mdio_read(struct mii_bu
 		dev_dbg(&bus->dev,
 			"Error while reading PHY%d reg at %d.%hhu\n",
 			phy_id, dev_addr, regnum);
-		return 0xffff;
+		ret = 0xffff;
+	} else {
+		ret = xgmac_read32(&regs->mdio_data, endian) & 0xffff;
+		dev_dbg(&bus->dev, "read %04x\n", ret);
 	}
 
-	value = xgmac_read32(&regs->mdio_data, endian) & 0xffff;
-	dev_dbg(&bus->dev, "read %04x\n", value);
+irq_restore:
+	if (priv->has_a009885)
+		local_irq_restore(flags);
 
-	return value;
+	return ret;
 }
 
 static int xgmac_mdio_probe(struct platform_device *pdev)
@@ -282,6 +293,8 @@ static int xgmac_mdio_probe(struct platf
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
 
+	priv->has_a009885 = device_property_read_bool(&pdev->dev,
+						      "fsl,erratum-a009885");
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 


