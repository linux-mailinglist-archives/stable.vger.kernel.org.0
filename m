Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC0B21FABD
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgGNSzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730846AbgGNSzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:55:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2454522B45;
        Tue, 14 Jul 2020 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752913;
        bh=Ad+qtcP7m90TJkaeB4xLLz7v3rfFl5dJLbmoMSLc2eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvvvU+WHdZhOG7QeXWfMK1Hr1GG5YtU/aEfv6QQaLxzOLQ7cl075vpezfkZhJjX/T
         nFgnjnLx751RiZ1FTCww1phnFBOZ52miBdO2/VyNZYmswWWZT8ntbkKu8naOCQukdf
         vh9F8pvb4yfWgP2TrlkCzMiWsXQXxzsHsL+RpVNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 048/166] gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2
Date:   Tue, 14 Jul 2020 20:43:33 +0200
Message-Id: <20200714184118.182908556@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ba8c90c6184784b397807b72403656085ac2f8c1 ]

ACPI table on Intel Galileo Gen 2 has wrong pin number for IRQ resource
of one of the I²C GPIO expanders. Since we know what that number is and
luckily have GPIO bases fixed for SoC's controllers, we may use a simple
DMI quirk to match the platform and retrieve GpioInt() pin on it for
the expander in question.

Mika suggested the way to avoid a quirk in the GPIO ACPI library and
here is the second, almost rewritten version of it.

Fixes: f32517bf1ae0 ("gpio: pca953x: support ACPI devices found on Galileo Gen2")
Depends-on: 25e3ef894eef ("gpio: acpi: Split out acpi_gpio_get_irq_resource() helper")
Suggested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 79 +++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index d8ba6c5195be7..8571e54512476 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -107,6 +107,79 @@ static const struct i2c_device_id pca953x_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, pca953x_id);
 
+#ifdef CONFIG_GPIO_PCA953X_IRQ
+
+#include <linux/dmi.h>
+#include <linux/gpio.h>
+#include <linux/list.h>
+
+static const struct dmi_system_id pca953x_dmi_acpi_irq_info[] = {
+	{
+		/*
+		 * On Intel Galileo Gen 2 board the IRQ pin of one of
+		 * the I²C GPIO expanders, which has GpioInt() resource,
+		 * is provided as an absolute number instead of being
+		 * relative. Since first controller (gpio-sch.c) and
+		 * second (gpio-dwapb.c) are at the fixed bases, we may
+		 * safely refer to the number in the global space to get
+		 * an IRQ out of it.
+		 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "GalileoGen2"),
+		},
+	},
+	{}
+};
+
+#ifdef CONFIG_ACPI
+static int pca953x_acpi_get_pin(struct acpi_resource *ares, void *data)
+{
+	struct acpi_resource_gpio *agpio;
+	int *pin = data;
+
+	if (acpi_gpio_get_irq_resource(ares, &agpio))
+		*pin = agpio->pin_table[0];
+	return 1;
+}
+
+static int pca953x_acpi_find_pin(struct device *dev)
+{
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	int pin = -ENOENT, ret;
+	LIST_HEAD(r);
+
+	ret = acpi_dev_get_resources(adev, &r, pca953x_acpi_get_pin, &pin);
+	acpi_dev_free_resource_list(&r);
+	if (ret < 0)
+		return ret;
+
+	return pin;
+}
+#else
+static inline int pca953x_acpi_find_pin(struct device *dev) { return -ENXIO; }
+#endif
+
+static int pca953x_acpi_get_irq(struct device *dev)
+{
+	int pin, ret;
+
+	pin = pca953x_acpi_find_pin(dev);
+	if (pin < 0)
+		return pin;
+
+	dev_info(dev, "Applying ACPI interrupt quirk (GPIO %d)\n", pin);
+
+	if (!gpio_is_valid(pin))
+		return -EINVAL;
+
+	ret = gpio_request(pin, "pca953x interrupt");
+	if (ret)
+		return ret;
+
+	return gpio_to_irq(pin);
+}
+#endif
+
 static const struct acpi_device_id pca953x_acpi_ids[] = {
 	{ "INT3491", 16 | PCA953X_TYPE | PCA_LATCH_INT, },
 	{ }
@@ -744,6 +817,12 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	DECLARE_BITMAP(irq_stat, MAX_LINE);
 	int ret;
 
+	if (dmi_first_match(pca953x_dmi_acpi_irq_info)) {
+		ret = pca953x_acpi_get_irq(&client->dev);
+		if (ret > 0)
+			client->irq = ret;
+	}
+
 	if (!client->irq)
 		return 0;
 
-- 
2.25.1



