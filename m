Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C45497F2D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbiAXMU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238286AbiAXMUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:20:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CC4C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 04:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F686B80EFD
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5398DC340E1;
        Mon, 24 Jan 2022 12:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643026848;
        bh=KvsJoTxlZWadqC3aJcb/XssqoMl/1owPFlzUjWJri90=;
        h=Subject:To:Cc:From:Date:From;
        b=bSIky5eLczHEYsAGGIlRH32YymSw0Swolb+Hj2rMPbRFdFecFI6gkgOpLpzcMNfyM
         OwNA6RtPNaPuYfpm5A6vHGCaQbgDY/3V35yLklfTbNn1M7vcjePae4xbZvNHODu+JS
         PuOY150pXoWyNBOUSFtDF8nXeuDt1igqvPdYhEYI=
Subject: FAILED: patch "[PATCH] net/fsl: xgmac_mdio: Add workaround for erratum A-009885" failed to apply to 4.14-stable tree
To:     tobias@waldekranz.com, andrew@lunn.ch, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:20:32 +0100
Message-ID: <1643026832134250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6198c722019774d38018457a8bfb9ba3ed8c931e Mon Sep 17 00:00:00 2001
From: Tobias Waldekranz <tobias@waldekranz.com>
Date: Tue, 18 Jan 2022 22:50:50 +0100
Subject: [PATCH] net/fsl: xgmac_mdio: Add workaround for erratum A-009885

Once an MDIO read transaction is initiated, we must read back the data
register within 16 MDC cycles after the transaction completes. Outside
of this window, reads may return corrupt data.

Therefore, disable local interrupts in the critical section, to
maximize the probability that we can satisfy this requirement.

Fixes: d55ad2967d89 ("powerpc/mpc85xx: Create dts components for the FSL QorIQ DPAA FMan")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 5b8b9bcf41a2..bf566ac3195b 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -51,6 +51,7 @@ struct tgec_mdio_controller {
 struct mdio_fsl_priv {
 	struct	tgec_mdio_controller __iomem *mdio_base;
 	bool	is_little_endian;
+	bool	has_a009885;
 	bool	has_a011043;
 };
 
@@ -186,10 +187,10 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
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
 
@@ -221,12 +222,18 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
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
@@ -234,13 +241,17 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
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
@@ -287,6 +298,8 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv->is_little_endian = device_property_read_bool(&pdev->dev,
 							   "little-endian");
 
+	priv->has_a009885 = device_property_read_bool(&pdev->dev,
+						      "fsl,erratum-a009885");
 	priv->has_a011043 = device_property_read_bool(&pdev->dev,
 						      "fsl,erratum-a011043");
 

