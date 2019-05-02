Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C19711E04
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfEBPaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbfEBPai (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:30:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9782C20B7C;
        Thu,  2 May 2019 15:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811038;
        bh=XTacDxyNCC4ihSVlkcv8rr0jsw2yfHYGXcCX7hTEZfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWU5kshRRzzwnu0Ah9yUAPR05BdVipHqXOan8Y5XBT7t3ZikCHNQ0/E37BIrvbqPZ
         5KOLLmwV+JsfAKmPYqIRdfbO32KQCMhIN4s2cF5jEnpSaHD9e+i0ziwmC4hkpc3hCP
         vJuvru71aTxRMSbOns/VC/KXCVhbKyObwEQyHxKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 050/101] net: phy: Add DP83825I to the DP83822 driver
Date:   Thu,  2 May 2019 17:20:52 +0200
Message-Id: <20190502143343.035266894@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 06acc17a96215a11134114aee26532b12dc8fde1 ]

Add the DP83825I ethernet PHY to the DP83822 driver.
These devices share the same WoL register bits and addresses.

The phy_driver init was made into a macro as there may be future
devices appended to this driver that will share the register space.

http://www.ti.com/lit/gpn/dp83825i

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 24c7f149f3e6..e11057892f07 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -23,6 +23,8 @@
 #include <linux/netdevice.h>
 
 #define DP83822_PHY_ID	        0x2000a240
+#define DP83825I_PHY_ID		0x2000a150
+
 #define DP83822_DEVADDR		0x1f
 
 #define MII_DP83822_PHYSCR	0x11
@@ -312,26 +314,30 @@ static int dp83822_resume(struct phy_device *phydev)
 	return 0;
 }
 
+#define DP83822_PHY_DRIVER(_id, _name)				\
+	{							\
+		PHY_ID_MATCH_MODEL(_id),			\
+		.name		= (_name),			\
+		.features	= PHY_BASIC_FEATURES,		\
+		.soft_reset	= dp83822_phy_reset,		\
+		.config_init	= dp83822_config_init,		\
+		.get_wol = dp83822_get_wol,			\
+		.set_wol = dp83822_set_wol,			\
+		.ack_interrupt = dp83822_ack_interrupt,		\
+		.config_intr = dp83822_config_intr,		\
+		.suspend = dp83822_suspend,			\
+		.resume = dp83822_resume,			\
+	}
+
 static struct phy_driver dp83822_driver[] = {
-	{
-		.phy_id = DP83822_PHY_ID,
-		.phy_id_mask = 0xfffffff0,
-		.name = "TI DP83822",
-		.features = PHY_BASIC_FEATURES,
-		.config_init = dp83822_config_init,
-		.soft_reset = dp83822_phy_reset,
-		.get_wol = dp83822_get_wol,
-		.set_wol = dp83822_set_wol,
-		.ack_interrupt = dp83822_ack_interrupt,
-		.config_intr = dp83822_config_intr,
-		.suspend = dp83822_suspend,
-		.resume = dp83822_resume,
-	 },
+	DP83822_PHY_DRIVER(DP83822_PHY_ID, "TI DP83822"),
+	DP83822_PHY_DRIVER(DP83825I_PHY_ID, "TI DP83825I"),
 };
 module_phy_driver(dp83822_driver);
 
 static struct mdio_device_id __maybe_unused dp83822_tbl[] = {
 	{ DP83822_PHY_ID, 0xfffffff0 },
+	{ DP83825I_PHY_ID, 0xfffffff0 },
 	{ },
 };
 MODULE_DEVICE_TABLE(mdio, dp83822_tbl);
-- 
2.19.1



