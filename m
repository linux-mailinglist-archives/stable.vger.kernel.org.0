Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F375334C90F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhC2I0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233001AbhC2IYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85C1B619B4;
        Mon, 29 Mar 2021 08:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006285;
        bh=eyBy7NQX+haWMqdNHTQLb7bD6fRAY9Lnc9ZIE3KEXC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jonJr/hyaWRMJu4v69Mlmgwl/iEEA3ra+6/0JvNlRZTBQc9LUHNfJfpNXnCbNyyLI
         ZjSGq2JEv0zTwAiF2j5W8OlFqHANA0hRCBmoHVjrh3JhDwdkll3PXu7IyaSxNS8OVb
         sRCm/cH0NJZENnArlLVAD+IxdCV7lmAfHqzE12AQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/221] net: phy: broadcom: Avoid forward for bcm54xx_config_clock_delay()
Date:   Mon, 29 Mar 2021 09:58:37 +0200
Message-Id: <20210329075635.336327630@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 133bf7b4fbbe58cff5492e37e95e75c88161f1b8 ]

Avoid a forward declaration by moving the callers of
bcm54xx_config_clock_delay() below its body.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 74 +++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 38 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 739efcce6dd5..88e9708e0562 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -26,44 +26,6 @@ MODULE_DESCRIPTION("Broadcom PHY driver");
 MODULE_AUTHOR("Maciej W. Rozycki");
 MODULE_LICENSE("GPL");
 
-static int bcm54xx_config_clock_delay(struct phy_device *phydev);
-
-static int bcm54210e_config_init(struct phy_device *phydev)
-{
-	int val;
-
-	bcm54xx_config_clock_delay(phydev);
-
-	if (phydev->dev_flags & PHY_BRCM_EN_MASTER_MODE) {
-		val = phy_read(phydev, MII_CTRL1000);
-		val |= CTL1000_AS_MASTER | CTL1000_ENABLE_MASTER;
-		phy_write(phydev, MII_CTRL1000, val);
-	}
-
-	return 0;
-}
-
-static int bcm54612e_config_init(struct phy_device *phydev)
-{
-	int reg;
-
-	bcm54xx_config_clock_delay(phydev);
-
-	/* Enable CLK125 MUX on LED4 if ref clock is enabled. */
-	if (!(phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED)) {
-		int err;
-
-		reg = bcm_phy_read_exp(phydev, BCM54612E_EXP_SPARE0);
-		err = bcm_phy_write_exp(phydev, BCM54612E_EXP_SPARE0,
-					BCM54612E_LED4_CLK125OUT_EN | reg);
-
-		if (err < 0)
-			return err;
-	}
-
-	return 0;
-}
-
 static int bcm54xx_config_clock_delay(struct phy_device *phydev)
 {
 	int rc, val;
@@ -105,6 +67,42 @@ static int bcm54xx_config_clock_delay(struct phy_device *phydev)
 	return 0;
 }
 
+static int bcm54210e_config_init(struct phy_device *phydev)
+{
+	int val;
+
+	bcm54xx_config_clock_delay(phydev);
+
+	if (phydev->dev_flags & PHY_BRCM_EN_MASTER_MODE) {
+		val = phy_read(phydev, MII_CTRL1000);
+		val |= CTL1000_AS_MASTER | CTL1000_ENABLE_MASTER;
+		phy_write(phydev, MII_CTRL1000, val);
+	}
+
+	return 0;
+}
+
+static int bcm54612e_config_init(struct phy_device *phydev)
+{
+	int reg;
+
+	bcm54xx_config_clock_delay(phydev);
+
+	/* Enable CLK125 MUX on LED4 if ref clock is enabled. */
+	if (!(phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED)) {
+		int err;
+
+		reg = bcm_phy_read_exp(phydev, BCM54612E_EXP_SPARE0);
+		err = bcm_phy_write_exp(phydev, BCM54612E_EXP_SPARE0,
+					BCM54612E_LED4_CLK125OUT_EN | reg);
+
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 /* Needs SMDSP clock enabled via bcm54xx_phydsp_config() */
 static int bcm50610_a0_workaround(struct phy_device *phydev)
 {
-- 
2.30.1



