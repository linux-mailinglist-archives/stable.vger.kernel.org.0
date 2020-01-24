Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8EB147AF9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgAXJjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:39:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729889AbgAXJjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:39:46 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B26EE20709;
        Fri, 24 Jan 2020 09:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858786;
        bh=2PHrdgqqeuFCQbwYL39ztV2mWCBBHES/M9lB5GRFZXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0ETeFD/NLXbx2XQZYP09IJUqUQqLjjsJbI9aDZz+97tX4mvV747eopydGR5gNfQx
         gXy1YS+5xFfADD7n709UZDCSGd0pPfX7ZaoRLGGO2Vep8xZQoxnkz/qEFC2cH1cpv/
         9Y4y6anDuXTYXfTjFF2nyva8plg78xm1zOv3WWnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manasa Mudireddy <manasa.mudireddy@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 030/102] net: phy: broadcom: Fix RGMII delays configuration for BCM54210E
Date:   Fri, 24 Jan 2020 10:30:31 +0100
Message-Id: <20200124092810.747410368@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit fea7fda7f50a6059220f83251e70709e45cc8040 upstream.

Commit 0fc9ae107669 ("net: phy: broadcom: add support for
BCM54210E") added support for BCM54210E but also unconditionally cleared
the RXC to RXD skew and the TXD to TXC skew, thus only making
PHY_INTERFACE_MODE_RGMII a possible configuration. Use
bcm54xx_config_clock_delay() which correctly sets the registers
depending on the 4 possible PHY interface values that exist for RGMII.

Fixes: 0fc9ae107669 ("net: phy: broadcom: add support for BCM54210E")
Reported-by: Manasa Mudireddy <manasa.mudireddy@broadcom.com>
Reported-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/broadcom.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -26,18 +26,13 @@ MODULE_DESCRIPTION("Broadcom PHY driver"
 MODULE_AUTHOR("Maciej W. Rozycki");
 MODULE_LICENSE("GPL");
 
+static int bcm54xx_config_clock_delay(struct phy_device *phydev);
+
 static int bcm54210e_config_init(struct phy_device *phydev)
 {
 	int val;
 
-	val = bcm54xx_auxctl_read(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
-	val &= ~MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_SKEW_EN;
-	val |= MII_BCM54XX_AUXCTL_MISC_WREN;
-	bcm54xx_auxctl_write(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC, val);
-
-	val = bcm_phy_read_shadow(phydev, BCM54810_SHD_CLK_CTL);
-	val &= ~BCM54810_SHD_CLK_CTL_GTXCLK_EN;
-	bcm_phy_write_shadow(phydev, BCM54810_SHD_CLK_CTL, val);
+	bcm54xx_config_clock_delay(phydev);
 
 	if (phydev->dev_flags & PHY_BRCM_EN_MASTER_MODE) {
 		val = phy_read(phydev, MII_CTRL1000);


