Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E7319B28C
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389044AbgDAQpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389802AbgDAQpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:45:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420422063A;
        Wed,  1 Apr 2020 16:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759500;
        bh=YfM0gg+xV2Mo+TLdynotmAczm4BoIwtXuyQJXXXrzRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRlN2n2Q5CY4aXJ+ZX78FRA8seoZO/i8a1Ow1cwCjJiuXztCDuE8SUdNYtZw0Dcf2
         /6OvNsYj7eJg3uA2xyhn1YtdpqqQTQXzXC0otyleUCysK+9+3wy4hhIs9SZ3eInkKU
         jLbTJLDlb+fcqXQhfvzgiRJ94GE7IGjOZJ1kqvxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.14 099/148] gpiolib: acpi: Rework honor_wakeup option into an ignore_wake option
Date:   Wed,  1 Apr 2020 18:18:11 +0200
Message-Id: <20200401161602.331345377@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 2ccb21f5516afef5e251184eeefbf36db90206d7 upstream.

Commit aa23ca3d98f7 ("gpiolib: acpi: Add honor_wakeup module-option +
quirk mechanism") was added to deal with spurious wakeups on one specific
model of the HP x2 10 series.

The approach taken there was to add a bool controlling wakeup support for
all ACPI GPIO events. This was sufficient for the specific HP x2 10 model
the commit was trying to fix, but in the mean time other models have
turned up which need a similar workaround to avoid spurious wakeups from
suspend, but only for one of the pins on which the ACPI tables request
ACPI GPIO events.

Since the honor_wakeup option was added to be able to ignore wake events,
the name was perhaps not the best, this commit renames it to ignore_wake
and changes it to a string with the following format:
gpiolib_acpi.ignore_wake=controller@pin[,controller@pin[,...]]

This allows working around spurious wakeup issues on a per pin basis.

This commit also reworks the existing quirk for the HP x2 10 so that
it functions as before.

Note:
-This removes the honor_wakeup parameter. This has only been upstream for
 a short time and to the best of my knowledge there are no users using
 this module parameter.

-The controller@pin[,controller@pin[,...]] syntax is based on an existing
 kernel module parameter using the same controller@pin format. That version
 uses ';' as separator, but in practice that is problematic because grub2
 cannot handle this without taking special care to escape the ';', so here
 we are using a ',' as separator instead which does not have this issue.

Fixes: aa23ca3d98f7 ("gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200302111225.6641-2-hdegoede@redhat.com
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-acpi.c |   96 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 20 deletions(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -24,18 +24,21 @@
 
 #include "gpiolib.h"
 
-#define QUIRK_NO_EDGE_EVENTS_ON_BOOT		0x01l
-#define QUIRK_NO_WAKEUP				0x02l
-
 static int run_edge_events_on_boot = -1;
 module_param(run_edge_events_on_boot, int, 0444);
 MODULE_PARM_DESC(run_edge_events_on_boot,
 		 "Run edge _AEI event-handlers at boot: 0=no, 1=yes, -1=auto");
 
-static int honor_wakeup = -1;
-module_param(honor_wakeup, int, 0444);
-MODULE_PARM_DESC(honor_wakeup,
-		 "Honor the ACPI wake-capable flag: 0=no, 1=yes, -1=auto");
+static char *ignore_wake;
+module_param(ignore_wake, charp, 0444);
+MODULE_PARM_DESC(ignore_wake,
+		 "controller@pin combos on which to ignore the ACPI wake flag "
+		 "ignore_wake=controller@pin[,controller@pin[,...]]");
+
+struct acpi_gpiolib_dmi_quirk {
+	bool no_edge_events_on_boot;
+	char *ignore_wake;
+};
 
 /**
  * struct acpi_gpio_event - ACPI GPIO event handler data
@@ -262,6 +265,57 @@ static void acpi_gpiochip_request_irqs(s
 		acpi_gpiochip_request_irq(acpi_gpio, event);
 }
 
+static bool acpi_gpio_in_ignore_list(const char *controller_in, int pin_in)
+{
+	const char *controller, *pin_str;
+	int len, pin;
+	char *endp;
+
+	controller = ignore_wake;
+	while (controller) {
+		pin_str = strchr(controller, '@');
+		if (!pin_str)
+			goto err;
+
+		len = pin_str - controller;
+		if (len == strlen(controller_in) &&
+		    strncmp(controller, controller_in, len) == 0) {
+			pin = simple_strtoul(pin_str + 1, &endp, 10);
+			if (*endp != 0 && *endp != ',')
+				goto err;
+
+			if (pin == pin_in)
+				return true;
+		}
+
+		controller = strchr(controller, ',');
+		if (controller)
+			controller++;
+	}
+
+	return false;
+err:
+	pr_err_once("Error invalid value for gpiolib_acpi.ignore_wake: %s\n",
+		    ignore_wake);
+	return false;
+}
+
+static bool acpi_gpio_irq_is_wake(struct device *parent,
+				  struct acpi_resource_gpio *agpio)
+{
+	int pin = agpio->pin_table[0];
+
+	if (agpio->wake_capable != ACPI_WAKE_CAPABLE)
+		return false;
+
+	if (acpi_gpio_in_ignore_list(dev_name(parent), pin)) {
+		dev_info(parent, "Ignoring wakeup on pin %d\n", pin);
+		return false;
+	}
+
+	return true;
+}
+
 static acpi_status acpi_gpiochip_alloc_event(struct acpi_resource *ares,
 					     void *context)
 {
@@ -347,7 +401,7 @@ static acpi_status acpi_gpiochip_alloc_e
 	event->handle = evt_handle;
 	event->handler = handler;
 	event->irq = irq;
-	event->irq_is_wake = honor_wakeup && agpio->wake_capable == ACPI_WAKE_CAPABLE;
+	event->irq_is_wake = acpi_gpio_irq_is_wake(chip->parent, agpio);
 	event->pin = pin;
 	event->desc = desc;
 
@@ -1331,7 +1385,9 @@ static const struct dmi_system_id gpioli
 			DMI_MATCH(DMI_SYS_VENDOR, "MINIX"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
 		},
-		.driver_data = (void *)QUIRK_NO_EDGE_EVENTS_ON_BOOT,
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.no_edge_events_on_boot = true,
+		},
 	},
 	{
 		/*
@@ -1344,7 +1400,9 @@ static const struct dmi_system_id gpioli
 			DMI_MATCH(DMI_SYS_VENDOR, "Wortmann_AG"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "TERRA_PAD_1061"),
 		},
-		.driver_data = (void *)QUIRK_NO_EDGE_EVENTS_ON_BOOT,
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.no_edge_events_on_boot = true,
+		},
 	},
 	{
 		/*
@@ -1363,33 +1421,31 @@ static const struct dmi_system_id gpioli
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP x2 Detachable 10-p0XX"),
 		},
-		.driver_data = (void *)QUIRK_NO_WAKEUP,
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "INT33FF:01@0,INT0002:00@2",
+		},
 	},
 	{} /* Terminating entry */
 };
 
 static int acpi_gpio_setup_params(void)
 {
+	const struct acpi_gpiolib_dmi_quirk *quirk = NULL;
 	const struct dmi_system_id *id;
-	long quirks = 0;
 
 	id = dmi_first_match(gpiolib_acpi_quirks);
 	if (id)
-		quirks = (long)id->driver_data;
+		quirk = id->driver_data;
 
 	if (run_edge_events_on_boot < 0) {
-		if (quirks & QUIRK_NO_EDGE_EVENTS_ON_BOOT)
+		if (quirk && quirk->no_edge_events_on_boot)
 			run_edge_events_on_boot = 0;
 		else
 			run_edge_events_on_boot = 1;
 	}
 
-	if (honor_wakeup < 0) {
-		if (quirks & QUIRK_NO_WAKEUP)
-			honor_wakeup = 0;
-		else
-			honor_wakeup = 1;
-	}
+	if (ignore_wake == NULL && quirk && quirk->ignore_wake)
+		ignore_wake = quirk->ignore_wake;
 
 	return 0;
 }


