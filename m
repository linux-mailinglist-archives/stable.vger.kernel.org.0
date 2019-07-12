Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7666D4E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbfGLM2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfGLM2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:28:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52C7321019;
        Fri, 12 Jul 2019 12:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934511;
        bh=JRa2eEbk8WJA/i//yKvGucM4xdTlylVBekg2TwSXVIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeKNjc/OtQC3GNLKz9VaDSpFJQJXdoMCCVX52LZagU3OxiQhnGHaxN3z2B9WP5vVP
         BQ5GCiymzid1I9l/xpZAJQY1dXzVlIh5RNdSUu08Eoonl3HwoSP0jrcQ5g06RCKSAT
         T4CiqxfEVG2g7dLDZx/j/78KGLQF7VleJX5Yz/dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 035/138] can: mcp251x: add support for mcp25625
Date:   Fri, 12 Jul 2019 14:18:19 +0200
Message-Id: <20190712121630.035300742@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 35b7fa4d07c43ad79b88e6462119e7140eae955c ]

Fully compatible with mcp2515, the mcp25625 have integrated transceiver.

This patch adds support for the mcp25625 to the existing mcp251x driver.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/Kconfig   |  5 +++--
 drivers/net/can/spi/mcp251x.c | 25 ++++++++++++++++---------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/spi/Kconfig b/drivers/net/can/spi/Kconfig
index 8f2e0dd7b756..792e9c6c4a2f 100644
--- a/drivers/net/can/spi/Kconfig
+++ b/drivers/net/can/spi/Kconfig
@@ -8,9 +8,10 @@ config CAN_HI311X
 	  Driver for the Holt HI311x SPI CAN controllers.
 
 config CAN_MCP251X
-	tristate "Microchip MCP251x SPI CAN controllers"
+	tristate "Microchip MCP251x and MCP25625 SPI CAN controllers"
 	depends on HAS_DMA
 	---help---
-	  Driver for the Microchip MCP251x SPI CAN controllers.
+	  Driver for the Microchip MCP251x and MCP25625 SPI CAN
+	  controllers.
 
 endmenu
diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index e90817608645..da64e71a62ee 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1,5 +1,5 @@
 /*
- * CAN bus driver for Microchip 251x CAN Controller with SPI Interface
+ * CAN bus driver for Microchip 251x/25625 CAN Controller with SPI Interface
  *
  * MCP2510 support and bug fixes by Christian Pellegrin
  * <chripell@evolware.org>
@@ -41,7 +41,7 @@
  * static struct spi_board_info spi_board_info[] = {
  *         {
  *                 .modalias = "mcp2510",
- *			// or "mcp2515" depending on your controller
+ *			// "mcp2515" or "mcp25625" depending on your controller
  *                 .platform_data = &mcp251x_info,
  *                 .irq = IRQ_EINT13,
  *                 .max_speed_hz = 2*1000*1000,
@@ -238,6 +238,7 @@ static const struct can_bittiming_const mcp251x_bittiming_const = {
 enum mcp251x_model {
 	CAN_MCP251X_MCP2510	= 0x2510,
 	CAN_MCP251X_MCP2515	= 0x2515,
+	CAN_MCP251X_MCP25625	= 0x25625,
 };
 
 struct mcp251x_priv {
@@ -280,7 +281,6 @@ static inline int mcp251x_is_##_model(struct spi_device *spi) \
 }
 
 MCP251X_IS(2510);
-MCP251X_IS(2515);
 
 static void mcp251x_clean(struct net_device *net)
 {
@@ -639,7 +639,7 @@ static int mcp251x_hw_reset(struct spi_device *spi)
 
 	/* Wait for oscillator startup timer after reset */
 	mdelay(MCP251X_OST_DELAY_MS);
-	
+
 	reg = mcp251x_read_reg(spi, CANSTAT);
 	if ((reg & CANCTRL_REQOP_MASK) != CANCTRL_REQOP_CONF)
 		return -ENODEV;
@@ -820,9 +820,8 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 		/* receive buffer 0 */
 		if (intf & CANINTF_RX0IF) {
 			mcp251x_hw_rx(spi, 0);
-			/*
-			 * Free one buffer ASAP
-			 * (The MCP2515 does this automatically.)
+			/* Free one buffer ASAP
+			 * (The MCP2515/25625 does this automatically.)
 			 */
 			if (mcp251x_is_2510(spi))
 				mcp251x_write_bits(spi, CANINTF, CANINTF_RX0IF, 0x00);
@@ -831,7 +830,7 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 		/* receive buffer 1 */
 		if (intf & CANINTF_RX1IF) {
 			mcp251x_hw_rx(spi, 1);
-			/* the MCP2515 does this automatically */
+			/* The MCP2515/25625 does this automatically. */
 			if (mcp251x_is_2510(spi))
 				clear_intf |= CANINTF_RX1IF;
 		}
@@ -1006,6 +1005,10 @@ static const struct of_device_id mcp251x_of_match[] = {
 		.compatible	= "microchip,mcp2515",
 		.data		= (void *)CAN_MCP251X_MCP2515,
 	},
+	{
+		.compatible	= "microchip,mcp25625",
+		.data		= (void *)CAN_MCP251X_MCP25625,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mcp251x_of_match);
@@ -1019,6 +1022,10 @@ static const struct spi_device_id mcp251x_id_table[] = {
 		.name		= "mcp2515",
 		.driver_data	= (kernel_ulong_t)CAN_MCP251X_MCP2515,
 	},
+	{
+		.name		= "mcp25625",
+		.driver_data	= (kernel_ulong_t)CAN_MCP251X_MCP25625,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(spi, mcp251x_id_table);
@@ -1259,5 +1266,5 @@ module_spi_driver(mcp251x_can_driver);
 
 MODULE_AUTHOR("Chris Elston <celston@katalix.com>, "
 	      "Christian Pellegrin <chripell@evolware.org>");
-MODULE_DESCRIPTION("Microchip 251x CAN driver");
+MODULE_DESCRIPTION("Microchip 251x/25625 CAN driver");
 MODULE_LICENSE("GPL v2");
-- 
2.20.1



