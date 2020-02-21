Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54B5167126
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgBUHvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:51:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbgBUHvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:51:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3147E2073A;
        Fri, 21 Feb 2020 07:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271496;
        bh=WbO+uEKXoG/iwhQ7nd5kQE3ky3wQoI1Lapj7wUubyT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7wjN85Ivel6B7jLJGwNNDiH98yNZ5USiW8kuX8H+5J/2yQ1TYTkvv7j3lTTRogDF
         j1YXdCeZivq73XUBwFUvuZnq5UzZHtua7q4ZQehhakhWHd7Ovcy1ZIXzS68BuF1Dc8
         uxVe/COP0nL1I9zVkMTd5Q7i4gdYZUBCLsaOqGnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 187/399] net: phy: realtek: add logging for the RGMII TX delay configuration
Date:   Fri, 21 Feb 2020 08:38:32 +0100
Message-Id: <20200221072420.996253867@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 3aec743d69822d22d4a5b60deb9518ed8be6fa67 ]

RGMII requires a delay of 2ns between the data and the clock signal.
There are at least three ways this can happen. One possibility is by
having the PHY generate this delay.
This is a common source for problems (for example with slow TX speeds or
packet loss when sending data). The TX delay configuration of the
RTL8211F PHY can be set either by pin-strappping the RXD1 pin (HIGH
means enabled, LOW means disabled) or through configuring a paged
register. The setting from the RXD1 pin is also reflected in the
register.

Add debug logging to the TX delay configuration on RTL8211F so it's
easier to spot these issues (for example if the TX delay is enabled for
both, the RTL8211F PHY and the MAC).
This is especially helpful because there is no public datasheet for the
RTL8211F PHY available with all the RX/TX delay specifics.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 476db5345e1af..879ca37c85081 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -171,7 +171,9 @@ static int rtl8211c_config_init(struct phy_device *phydev)
 
 static int rtl8211f_config_init(struct phy_device *phydev)
 {
+	struct device *dev = &phydev->mdio.dev;
 	u16 val;
+	int ret;
 
 	/* enable TX-delay for rgmii-{id,txid}, and disable it for rgmii and
 	 * rgmii-rxid. The RX-delay can be enabled by the external RXDLY pin.
@@ -189,7 +191,22 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 		return 0;
 	}
 
-	return phy_modify_paged(phydev, 0xd08, 0x11, RTL8211F_TX_DELAY, val);
+	ret = phy_modify_paged_changed(phydev, 0xd08, 0x11, RTL8211F_TX_DELAY,
+				       val);
+	if (ret < 0) {
+		dev_err(dev, "Failed to update the TX delay register\n");
+		return ret;
+	} else if (ret) {
+		dev_dbg(dev,
+			"%s 2ns TX delay (and changing the value from pin-strapping RXD1 or the bootloader)\n",
+			val ? "Enabling" : "Disabling");
+	} else {
+		dev_dbg(dev,
+			"2ns TX delay was already %s (by pin-strapping RXD1 or bootloader configuration)\n",
+			val ? "enabled" : "disabled");
+	}
+
+	return 0;
 }
 
 static int rtl8211e_config_init(struct phy_device *phydev)
-- 
2.20.1



