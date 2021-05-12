Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E294437CA80
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbhELQaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235101AbhELQX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:23:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FE9F61D99;
        Wed, 12 May 2021 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834456;
        bh=6O1N67F8EJ7O21PVsSxa1lODBKQJtyYLzzoo6UOsCyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YP62goGqC4f6qQmn3kWMs/i10PX5oTiT0lFd8yzt6iUttpiyg0JyED+0tWZD4tI7d
         X92KjCRGERwtdEnz6JacRKI6z5tf9qBucDOIwxcEX3Hpfez5sh6tYt1i20erfodlbJ
         EHE0jQ850cGmvN0/fOEhlhDR8awEZhkgCq+chdEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 550/601] net: phy: intel-xway: enable integrated led functions
Date:   Wed, 12 May 2021 16:50:27 +0200
Message-Id: <20210512144845.975285322@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 357a07c26697a770d39d28b6b111f978deb4017d ]

The Intel xway phys offer the possibility to deactivate the integrated
LED function and to control the LEDs manually.
If this was set by the bootloader, it must be ensured that the
integrated LED function is enabled for all LEDs when loading the driver.

Before commit 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
the LEDs were enabled by a soft-reset of the PHY (using
genphy_soft_reset). Initialize the XWAY_MDIO_LED with it's default
value (which is applied during a soft reset) instead of adding back
the soft reset. This brings back the default LED configuration while
still preventing an excessive amount of soft resets.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/intel-xway.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/phy/intel-xway.c b/drivers/net/phy/intel-xway.c
index 6eac50d4b42f..d453ec016168 100644
--- a/drivers/net/phy/intel-xway.c
+++ b/drivers/net/phy/intel-xway.c
@@ -11,6 +11,18 @@
 
 #define XWAY_MDIO_IMASK			0x19	/* interrupt mask */
 #define XWAY_MDIO_ISTAT			0x1A	/* interrupt status */
+#define XWAY_MDIO_LED			0x1B	/* led control */
+
+/* bit 15:12 are reserved */
+#define XWAY_MDIO_LED_LED3_EN		BIT(11)	/* Enable the integrated function of LED3 */
+#define XWAY_MDIO_LED_LED2_EN		BIT(10)	/* Enable the integrated function of LED2 */
+#define XWAY_MDIO_LED_LED1_EN		BIT(9)	/* Enable the integrated function of LED1 */
+#define XWAY_MDIO_LED_LED0_EN		BIT(8)	/* Enable the integrated function of LED0 */
+/* bit 7:4 are reserved */
+#define XWAY_MDIO_LED_LED3_DA		BIT(3)	/* Direct Access to LED3 */
+#define XWAY_MDIO_LED_LED2_DA		BIT(2)	/* Direct Access to LED2 */
+#define XWAY_MDIO_LED_LED1_DA		BIT(1)	/* Direct Access to LED1 */
+#define XWAY_MDIO_LED_LED0_DA		BIT(0)	/* Direct Access to LED0 */
 
 #define XWAY_MDIO_INIT_WOL		BIT(15)	/* Wake-On-LAN */
 #define XWAY_MDIO_INIT_MSRE		BIT(14)
@@ -159,6 +171,15 @@ static int xway_gphy_config_init(struct phy_device *phydev)
 	/* Clear all pending interrupts */
 	phy_read(phydev, XWAY_MDIO_ISTAT);
 
+	/* Ensure that integrated led function is enabled for all leds */
+	err = phy_write(phydev, XWAY_MDIO_LED,
+			XWAY_MDIO_LED_LED0_EN |
+			XWAY_MDIO_LED_LED1_EN |
+			XWAY_MDIO_LED_LED2_EN |
+			XWAY_MDIO_LED_LED3_EN);
+	if (err)
+		return err;
+
 	phy_write_mmd(phydev, MDIO_MMD_VEND2, XWAY_MMD_LEDCH,
 		      XWAY_MMD_LEDCH_NACS_NONE |
 		      XWAY_MMD_LEDCH_SBF_F02HZ |
-- 
2.30.2



