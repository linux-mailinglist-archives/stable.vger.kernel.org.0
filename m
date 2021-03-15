Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E667933B781
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhCOOAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232152AbhCON7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA65464F35;
        Mon, 15 Mar 2021 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816732;
        bh=wg2yj9QpO+l8N0iOHMXm7lpOUNINfu6Tujb51ym6jf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4KKZm+PTPkijVJh6inix8Zv183rS3hGwCqaDRLk1Ewpptwpm/G3/F2eaFY88v+k+
         0cdtH1Yr6RDendZ2AqA0muwrk4ftDHtHmT0sPmik+CZ7aYJtvF1hMcXrC7TgqzIj2I
         /Ptg1YEpBA/aaVlC3pFc4gL6q4AKqvGdtEmqdDVw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Roman Guskov <rguskov@dh-electronics.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 081/290] gpiolib: Read "gpio-line-names" from a firmware node
Date:   Mon, 15 Mar 2021 14:52:54 +0100
Message-Id: <20210315135544.659848571@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b41ba2ec54a70908067034f139aa23d0dd2985ce upstream.

On STM32MP1, the GPIO banks are subnodes of pin-controller@50002000,
see arch/arm/boot/dts/stm32mp151.dtsi. The driver for
pin-controller@50002000 is in drivers/pinctrl/stm32/pinctrl-stm32.c
and iterates over all of its DT subnodes when registering each GPIO
bank gpiochip. Each gpiochip has:

  - gpio_chip.parent = dev,
    where dev is the device node of the pin controller
  - gpio_chip.of_node = np,
    which is the OF node of the GPIO bank

Therefore, dev_fwnode(chip->parent) != of_fwnode_handle(chip.of_node),
i.e. pin-controller@50002000 != pin-controller@50002000/gpio@5000*000.

The original code behaved correctly, as it extracted the "gpio-line-names"
from of_fwnode_handle(chip.of_node) = pin-controller@50002000/gpio@5000*000.

To achieve the same behaviour, read property from the firmware node.

Fixes: 7cba1a4d5e162 ("gpiolib: generalize devprop_gpiochip_set_names() for device properties")
Reported-by: Marek Vasut <marex@denx.de>
Reported-by: Roman Guskov <rguskov@dh-electronics.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Marek Vasut <marex@denx.de>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -364,22 +364,18 @@ static int gpiochip_set_desc_names(struc
  *
  * Looks for device property "gpio-line-names" and if it exists assigns
  * GPIO line names for the chip. The memory allocated for the assigned
- * names belong to the underlying software node and should not be released
+ * names belong to the underlying firmware node and should not be released
  * by the caller.
  */
 static int devprop_gpiochip_set_names(struct gpio_chip *chip)
 {
 	struct gpio_device *gdev = chip->gpiodev;
-	struct device *dev = chip->parent;
+	struct fwnode_handle *fwnode = dev_fwnode(&gdev->dev);
 	const char **names;
 	int ret, i;
 	int count;
 
-	/* GPIO chip may not have a parent device whose properties we inspect. */
-	if (!dev)
-		return 0;
-
-	count = device_property_string_array_count(dev, "gpio-line-names");
+	count = fwnode_property_string_array_count(fwnode, "gpio-line-names");
 	if (count < 0)
 		return 0;
 
@@ -393,7 +389,7 @@ static int devprop_gpiochip_set_names(st
 	if (!names)
 		return -ENOMEM;
 
-	ret = device_property_read_string_array(dev, "gpio-line-names",
+	ret = fwnode_property_read_string_array(fwnode, "gpio-line-names",
 						names, count);
 	if (ret < 0) {
 		dev_warn(&gdev->dev, "failed to read GPIO line names\n");


