Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523DA33B782
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhCOOAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231927AbhCON7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A84FD64F0B;
        Mon, 15 Mar 2021 13:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816729;
        bh=KoUpgp8ToaoesoT0JL2Hjzzsk/DNrsi7MvsYZQLfZ28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YEyxvZXALIbTLqG2dQocveyv01Kn09cfsP7oy8V+Voi8IBPs4gWRezWHM+bMpdav
         v6f07brrs8PQqBzXLfLc6jhTw0ZwgYtSIfHqDxGLHXdlejMik2jH4w3XKtVAUa/FVm
         5H4r3HEX5GwIzAR3upAd2JVbpoOvMd5RIJUYxYHU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.10 079/290] gpiolib: acpi: Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk
Date:   Mon, 15 Mar 2021 14:52:52 +0100
Message-Id: <20210315135544.583551677@linuxfoundation.org>
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

commit 62d5247d239d4b48762192a251c647d7c997616a upstream.

On some systems the ACPI tables has wrong pin number and instead of
having a relative one it provides an absolute one in the global GPIO
number space.

Add ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk to cope with such cases.

Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
Depends-on: 0ea683931adb ("gpio: dwapb: Convert driver to using the GPIO-lib-based IRQ-chip")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c   |    7 ++++++-
 include/linux/gpio/consumer.h |    2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -649,6 +649,7 @@ static int acpi_populate_gpio_lookup(str
 	if (!lookup->desc) {
 		const struct acpi_resource_gpio *agpio = &ares->data.gpio;
 		bool gpioint = agpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT;
+		struct gpio_desc *desc;
 		int pin_index;
 
 		if (lookup->info.quirks & ACPI_GPIO_QUIRK_ONLY_GPIOIO && gpioint)
@@ -661,8 +662,12 @@ static int acpi_populate_gpio_lookup(str
 		if (pin_index >= agpio->pin_table_length)
 			return 1;
 
-		lookup->desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
+		if (lookup->info.quirks & ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER)
+			desc = gpio_to_desc(agpio->pin_table[pin_index]);
+		else
+			desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
 					      agpio->pin_table[pin_index]);
+		lookup->desc = desc;
 		lookup->info.pin_config = agpio->pin_config;
 		lookup->info.gpioint = gpioint;
 
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -674,6 +674,8 @@ struct acpi_gpio_mapping {
  * get GpioIo type explicitly, this quirk may be used.
  */
 #define ACPI_GPIO_QUIRK_ONLY_GPIOIO		BIT(1)
+/* Use given pin as an absolute GPIO number in the system */
+#define ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER		BIT(2)
 
 	unsigned int quirks;
 };


