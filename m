Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFAF35C096
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240341AbhDLJOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240892AbhDLJLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA7F16137E;
        Mon, 12 Apr 2021 09:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218435;
        bh=Gjr8Seg0OoD2QzfVpvreFqk5jUpQHCuSQfh1C4zy/as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m44QChQ+eJfpyf0RA3BP+2fSdjRZqM3C0kMh9A9WdSa7zMeTkRvufAo21Zrj3wXdy
         DZDSaX+e9ssD/X7w5yGrwv1S/WOAQl8sQ2WOM2S1jjnoixR4XPml/VhN4N1W5iUIGS
         7NClphgb94iHfJCEX5PnjkNbsOJLMON9CZ0LkzAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Roman Guskov <rguskov@dh-electronics.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.11 196/210] gpiolib: Read "gpio-line-names" from a firmware node
Date:   Mon, 12 Apr 2021 10:41:41 +0200
Message-Id: <20210412084022.537703636@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -365,22 +365,18 @@ static int gpiochip_set_desc_names(struc
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
 
@@ -394,7 +390,7 @@ static int devprop_gpiochip_set_names(st
 	if (!names)
 		return -ENOMEM;
 
-	ret = device_property_read_string_array(dev, "gpio-line-names",
+	ret = fwnode_property_read_string_array(fwnode, "gpio-line-names",
 						names, count);
 	if (ret < 0) {
 		dev_warn(&gdev->dev, "failed to read GPIO line names\n");


