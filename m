Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66F133B74F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhCOOAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhCON7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A046B64F2A;
        Mon, 15 Mar 2021 13:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816733;
        bh=fHyZTa1DYU/Knqh6mLdjAJX4WqBhgq98n0fx+lI7uVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGAfQ+Vvz4Kp/gHIXcuTz95+mcQa4XwkSglAzB2ZRSS72qgCkE2JBdLTZChcJ6O/7
         wDjmNHS9ZDhxOUztm5RUxU2WsN7q0kkO4BXNO/7dDUZHwM3QfEhyo3PRnsWWXxlTzR
         ZGXX6aoCrj6p00OD9cggUVNkPYPsjZCwXvlNSILc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 082/290] gpio: pca953x: Set IRQ type when handle Intel Galileo Gen 2
Date:   Mon, 15 Mar 2021 14:52:55 +0100
Message-Id: <20210315135544.690847979@linuxfoundation.org>
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

commit eb441337c7147514ab45036cadf09c3a71e4ce31 upstream.

The commit 0ea683931adb ("gpio: dwapb: Convert driver to using the
GPIO-lib-based IRQ-chip") indeliberately made a regression on how
IRQ line from GPIO I²C expander is handled. I.e. it reveals that
the quirk for Intel Galileo Gen 2 misses the part of setting IRQ type
which previously was predefined by gpio-dwapb driver. Now, we have to
reorganize the approach to call necessary parts, which can be done via
ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk.

Without this fix and with above mentioned change the kernel hangs
on the first IRQ event with:

    gpio gpiochip3: Persistence not supported for GPIO 1
    irq 32, desc: 62f8fb50, depth: 0, count: 0, unhandled: 0
    ->handle_irq():  41c7b0ab, handle_bad_irq+0x0/0x40
    ->irq_data.chip(): e03f1e72, 0xc2539218
    ->action(): 0ecc7e6f
    ->action->handler(): 8a3db21e, irq_default_primary_handler+0x0/0x10
       IRQ_NOPROBE set
    unexpected IRQ trap at vector 20

Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
Depends-on: 0ea683931adb ("gpio: dwapb: Convert driver to using the GPIO-lib-based IRQ-chip")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pca953x.c |   78 ++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 55 deletions(-)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -112,8 +112,29 @@ MODULE_DEVICE_TABLE(i2c, pca953x_id);
 #ifdef CONFIG_GPIO_PCA953X_IRQ
 
 #include <linux/dmi.h>
-#include <linux/gpio.h>
-#include <linux/list.h>
+
+static const struct acpi_gpio_params pca953x_irq_gpios = { 0, 0, true };
+
+static const struct acpi_gpio_mapping pca953x_acpi_irq_gpios[] = {
+	{ "irq-gpios", &pca953x_irq_gpios, 1, ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER },
+	{ }
+};
+
+static int pca953x_acpi_get_irq(struct device *dev)
+{
+	int ret;
+
+	ret = devm_acpi_dev_add_driver_gpios(dev, pca953x_acpi_irq_gpios);
+	if (ret)
+		dev_warn(dev, "can't add GPIO ACPI mapping\n");
+
+	ret = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev), "irq-gpios", 0);
+	if (ret < 0)
+		return ret;
+
+	dev_info(dev, "ACPI interrupt quirk (IRQ %d)\n", ret);
+	return ret;
+}
 
 static const struct dmi_system_id pca953x_dmi_acpi_irq_info[] = {
 	{
@@ -132,59 +153,6 @@ static const struct dmi_system_id pca953
 	},
 	{}
 };
-
-#ifdef CONFIG_ACPI
-static int pca953x_acpi_get_pin(struct acpi_resource *ares, void *data)
-{
-	struct acpi_resource_gpio *agpio;
-	int *pin = data;
-
-	if (acpi_gpio_get_irq_resource(ares, &agpio))
-		*pin = agpio->pin_table[0];
-	return 1;
-}
-
-static int pca953x_acpi_find_pin(struct device *dev)
-{
-	struct acpi_device *adev = ACPI_COMPANION(dev);
-	int pin = -ENOENT, ret;
-	LIST_HEAD(r);
-
-	ret = acpi_dev_get_resources(adev, &r, pca953x_acpi_get_pin, &pin);
-	acpi_dev_free_resource_list(&r);
-	if (ret < 0)
-		return ret;
-
-	return pin;
-}
-#else
-static inline int pca953x_acpi_find_pin(struct device *dev) { return -ENXIO; }
-#endif
-
-static int pca953x_acpi_get_irq(struct device *dev)
-{
-	int pin, ret;
-
-	pin = pca953x_acpi_find_pin(dev);
-	if (pin < 0)
-		return pin;
-
-	dev_info(dev, "Applying ACPI interrupt quirk (GPIO %d)\n", pin);
-
-	if (!gpio_is_valid(pin))
-		return -EINVAL;
-
-	ret = gpio_request(pin, "pca953x interrupt");
-	if (ret)
-		return ret;
-
-	ret = gpio_to_irq(pin);
-
-	/* When pin is used as an IRQ, no need to keep it requested */
-	gpio_free(pin);
-
-	return ret;
-}
 #endif
 
 static const struct acpi_device_id pca953x_acpi_ids[] = {


