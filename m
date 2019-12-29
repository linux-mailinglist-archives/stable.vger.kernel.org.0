Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DBB12CA1C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfL2RXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:23:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727268AbfL2RXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:23:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDE9F20CC7;
        Sun, 29 Dec 2019 17:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640231;
        bh=nie5E4wN1HIpMmq7neBcmQuVrAMzR5DezXZ/OIavkYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcxM5a5xvzgy5RwlznouQhrzm5lu8Nu+lBLlCSHd7eE1DOH8CZIzVP8nTA9KxmGf5
         +a5qVv4DBQXLm+VWxQMp0FVeUZ1Uf+9e20g7akBA1p70nl+dpNzF7yMcH+oD8iRS9D
         c0vqvmn/XsL6LIXvgEffTsjTwXlNti+torsks4DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 071/161] net: phy: dp83867: enable robust auto-mdix
Date:   Sun, 29 Dec 2019 18:18:39 +0100
Message-Id: <20191229162421.660580953@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 5a7f08c2abb0efc9d17aff2fc75d6d3b85e622e4 ]

The link detection timeouts can be observed (or link might not be detected
at all) when dp83867 PHY is configured in manual mode (speed/duplex).

CFG3[9] Robust Auto-MDIX option allows to significantly improve link detection
in case dp83867 is configured in manual mode and reduce link detection
time.
As per DM: "If link partners are configured to operational modes that are
not supported by normal Auto MDI/MDIX mode (like Auto-Neg versus Force
100Base-TX or Force 100Base-TX versus Force 100Base-TX), this Robust Auto
MDI/MDIX mode allows MDI/MDIX resolution and prevents deadlock."

Hence, enable this option by default as there are no known reasons
not to do so.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index e03e91d5f1b1..0cbcced0870e 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -84,6 +84,10 @@
 #define DP83867_IO_MUX_CFG_IO_IMPEDANCE_MAX	0x0
 #define DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN	0x1f
 
+/* CFG3 bits */
+#define DP83867_CFG3_INT_OE			BIT(7)
+#define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
+
 /* CFG4 bits */
 #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
 
@@ -320,12 +324,13 @@ static int dp83867_config_init(struct phy_device *phydev)
 			return ret;
 	}
 
+	val = phy_read(phydev, DP83867_CFG3);
 	/* Enable Interrupt output INT_OE in CFG3 register */
-	if (phy_interrupt_is_valid(phydev)) {
-		val = phy_read(phydev, DP83867_CFG3);
-		val |= BIT(7);
-		phy_write(phydev, DP83867_CFG3, val);
-	}
+	if (phy_interrupt_is_valid(phydev))
+		val |= DP83867_CFG3_INT_OE;
+
+	val |= DP83867_CFG3_ROBUST_AUTO_MDIX;
+	phy_write(phydev, DP83867_CFG3, val);
 
 	if (dp83867->port_mirroring != DP83867_PORT_MIRROING_KEEP)
 		dp83867_config_port_mirroring(phydev);
-- 
2.20.1



