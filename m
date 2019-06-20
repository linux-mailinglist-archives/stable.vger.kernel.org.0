Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE7F4D73B
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfFTSQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728759AbfFTSQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:16:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8062089C;
        Thu, 20 Jun 2019 18:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054603;
        bh=6KortFgTHn9xDhXXxKrciBL1+5CdIJECwaCiJ6aLxVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SncB9YtsmS3eN3pGgGQuxEoJoJzWWifF05xIS6CREcle+Z71bjLWXCyupwXVkwDZy
         EbXhzvB36jePeSTnYNUyd5HZl9YkwglHMS53UHg9Dp/wMZG/Uz/EqplkhtbBdUoCwa
         3zkroN44xDMVBusi/s1qRWpXvILVX4FAtM6xYEjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Uvarov <muvarov@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 86/98] net: phy: dp83867: increase SGMII autoneg timer duration
Date:   Thu, 20 Jun 2019 19:57:53 +0200
Message-Id: <20190620174353.661952293@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1a97a477e666cbdededab93bd3754e508f0c09d7 ]

After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
That is not enough to finalize autonegatiation on some devices.
Increase this timer duration to maximum supported 16ms.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 29cae4de9a4f..ffaf67bdb140 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -26,6 +26,12 @@
 
 /* Extended Registers */
 #define DP83867_CFG4            0x0031
+#define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
+#define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_16MS   (0 << 5)
+
 #define DP83867_RGMIICTL	0x0032
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
@@ -292,6 +298,18 @@ static int dp83867_config_init(struct phy_device *phydev)
 				     0);
 		if (ret)
 			return ret;
+
+		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
+		 * are 01). That is not enough to finalize autoneg on some
+		 * devices. Increase this timer duration to maximum 16ms.
+		 */
+		ret = phy_modify_mmd(phydev, DP83867_DEVADDR,
+				     DP83867_CFG4,
+				     DP83867_CFG4_SGMII_ANEG_MASK,
+				     DP83867_CFG4_SGMII_ANEG_TIMER_16MS);
+
+		if (ret)
+			return ret;
 	}
 
 	/* Enable Interrupt output INT_OE in CFG3 register */
-- 
2.20.1



