Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E6C2D9FCA
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732908AbgLNS7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502221AbgLNRh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:29 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 035/105] usb: ohci-omap: Fix descriptor conversion
Date:   Mon, 14 Dec 2020 18:28:09 +0100
Message-Id: <20201214172556.969079739@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 45c5775460f32ed8cdb7c16986ae1a2c254346b3 ]

There were a bunch of issues with the patch converting the
OMAP1 OSK board to use descriptors for controlling the USB
host:

- The chip label was incorrect
- The GPIO offset was off-by-one
- The code should use sleeping accessors

This patch tries to fix all issues at the same time.

Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Fixes: 15d157e87443 ("usb: ohci-omap: Convert to use GPIO descriptors")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20201130083033.29435-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/board-osk.c | 2 +-
 drivers/usb/host/ohci-omap.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index 144b9caa935c4..a720259099edf 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -288,7 +288,7 @@ static struct gpiod_lookup_table osk_usb_gpio_table = {
 	.dev_id = "ohci",
 	.table = {
 		/* Power GPIO on the I2C-attached TPS65010 */
-		GPIO_LOOKUP("i2c-tps65010", 1, "power", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("tps65010", 0, "power", GPIO_ACTIVE_HIGH),
 		GPIO_LOOKUP(OMAP_GPIO_LABEL, 9, "overcurrent",
 			    GPIO_ACTIVE_HIGH),
 	},
diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
index 9ccdf2c216b51..6374501ba1390 100644
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -91,14 +91,14 @@ static int omap_ohci_transceiver_power(struct ohci_omap_priv *priv, int on)
 				| ((1 << 5/*usb1*/) | (1 << 3/*usb2*/)),
 			       INNOVATOR_FPGA_CAM_USB_CONTROL);
 		else if (priv->power)
-			gpiod_set_value(priv->power, 0);
+			gpiod_set_value_cansleep(priv->power, 0);
 	} else {
 		if (machine_is_omap_innovator() && cpu_is_omap1510())
 			__raw_writeb(__raw_readb(INNOVATOR_FPGA_CAM_USB_CONTROL)
 				& ~((1 << 5/*usb1*/) | (1 << 3/*usb2*/)),
 			       INNOVATOR_FPGA_CAM_USB_CONTROL);
 		else if (priv->power)
-			gpiod_set_value(priv->power, 1);
+			gpiod_set_value_cansleep(priv->power, 1);
 	}
 
 	return 0;
-- 
2.27.0



