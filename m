Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F745EAB5
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 10:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376395AbhKZJwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 04:52:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhKZJux (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 04:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27138610CA;
        Fri, 26 Nov 2021 09:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637920061;
        bh=RmPE7rdsieIifKFC/2nZXzuK2s8nnr82tj6/PHry4Qo=;
        h=From:To:Cc:Subject:Date:From;
        b=c/lDHTmQHwvSOh6AakQdNa6DGTUsQ42KJCtqCS62fTP8B4lo3zDaTh2qbGNUhV7dN
         uSrdTydmu7zWMSs4LJkRh5e8lsly1E+151lx68FXJlMh9xRKEmrswLP6LWYwFw0xzp
         4wSRTful9VQ07xDWjGHDSREAbG2Cb1TOyFKT9WF1+Rbp7jXZtrLpNDYoF04EuPSk/3
         K2bHvMC9QxveOOJiDQwPDPOGsWvi+uZJXCG6jnVNtvm47OIGgGbSGB405D8gGo6Y+Y
         0Cj/YzCrAQofxf4tA6fOT7gj8nHnbnLTGq0jH2otzL8f9kWwmlruI7lzyezORJ0FOu
         aGFPNZvP8crSA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mqXpB-0008HL-NS; Fri, 26 Nov 2021 10:47:22 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maarten Brock <m.brock@vanmierlo.com>, stable@vger.kernel.org,
        Karoly Pados <pados@pados.hu>
Subject: [PATCH] USB: serial: cp210x: fix CP2105 GPIO registration
Date:   Fri, 26 Nov 2021 10:43:48 +0100
Message-Id: <20211126094348.31698-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When generalising GPIO support and adding support for CP2102N, the GPIO
registration for some CP2105 devices accidentally broke. Specifically,
when all the pins of a port are in "modem" mode, and thus unavailable
for GPIO use, the GPIO chip would now be registered without having
initialised the number of GPIO lines. This would in turn be rejected by
gpiolib and some errors messages would be printed (but importantly probe
would still succeed).

Fix this by initialising the number of GPIO lines before registering the
GPIO chip.

Note that as for the other device types, and as when all CP2105 pins are
muxed for LED function, the GPIO chip is registered also when no pins
are available for GPIO use.

Reported-by: Maarten Brock <m.brock@vanmierlo.com>
Link: https://lore.kernel.org/r/5eb560c81d2ea1a2b4602a92d9f48a89@vanmierlo.com
Fixes: c8acfe0aadbe ("USB: serial: cp210x: implement GPIO support for CP2102N")
Cc: stable@vger.kernel.org      # 4.19
Cc: Karoly Pados <pados@pados.hu>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 7705328034ca..8a60c0d56863 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -1635,6 +1635,8 @@ static int cp2105_gpioconf_init(struct usb_serial *serial)
 
 	/*  2 banks of GPIO - One for the pins taken from each serial port */
 	if (intf_num == 0) {
+		priv->gc.ngpio = 2;
+
 		if (mode.eci == CP210X_PIN_MODE_MODEM) {
 			/* mark all GPIOs of this interface as reserved */
 			priv->gpio_altfunc = 0xff;
@@ -1645,8 +1647,9 @@ static int cp2105_gpioconf_init(struct usb_serial *serial)
 		priv->gpio_pushpull = (u8)((le16_to_cpu(config.gpio_mode) &
 						CP210X_ECI_GPIO_MODE_MASK) >>
 						CP210X_ECI_GPIO_MODE_OFFSET);
-		priv->gc.ngpio = 2;
 	} else if (intf_num == 1) {
+		priv->gc.ngpio = 3;
+
 		if (mode.sci == CP210X_PIN_MODE_MODEM) {
 			/* mark all GPIOs of this interface as reserved */
 			priv->gpio_altfunc = 0xff;
@@ -1657,7 +1660,6 @@ static int cp2105_gpioconf_init(struct usb_serial *serial)
 		priv->gpio_pushpull = (u8)((le16_to_cpu(config.gpio_mode) &
 						CP210X_SCI_GPIO_MODE_MASK) >>
 						CP210X_SCI_GPIO_MODE_OFFSET);
-		priv->gc.ngpio = 3;
 	} else {
 		return -ENODEV;
 	}
-- 
2.32.0

