Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6D19B851
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 23:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393066AbfHWVxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 17:53:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60466 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392654AbfHWVxG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 17:53:06 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 196E485536;
        Fri, 23 Aug 2019 21:53:06 +0000 (UTC)
Received: from dhcp-44-196.space.revspace.nl (unknown [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A798600C1;
        Fri, 23 Aug 2019 21:53:00 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Drake <drake@endlessm.com>,
        Ian W MORRISON <ianwmorrison@gmail.com>
Subject: [PATCH] gpiolib: acpi: Add gpiolib_acpi_run_edge_events_on_boot option and blacklist
Date:   Fri, 23 Aug 2019 23:52:55 +0200
Message-Id: <20190823215255.7631-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 23 Aug 2019 21:53:06 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Another day; another DSDT bug we need to workaround...

Since commit ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events
at least once on boot") we call _AEI edge handlers at boot.

In some rare cases this causes problems. One example of this is the Minix
Neo Z83-4 mini PC, this device has a clear DSDT bug where it has some copy
and pasted code for dealing with Micro USB-B connector host/device role
switching, while the mini PC does not even have a micro-USB connector.
This code, which should not be there, messes with the DDC data pin from
the HDMI connector (switching it to GPIO mode) breaking HDMI support.

To avoid problems like this, this commit adds a new
gpiolib_acpi_run_edge_events_on_boot kernel commandline option which
can be "on", "off", or "auto" (default).

In auto mode the default is on and a DMI based blacklist is used,
the initial version of this blacklist contains the Minix Neo Z83-4
fixing the HDMI being broken on this device.

Cc: stable@vger.kernel.org
Cc: Daniel Drake <drake@endlessm.com>
Cc: Ian W MORRISON <ianwmorrison@gmail.com>
Reported-by: Ian W MORRISON <ianwmorrison@gmail.com>
Suggested-by: Ian W MORRISON <ianwmorrison@gmail.com>
Fixes: ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/gpio/gpiolib-acpi.c | 52 ++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 39f2f9035c11..546dc2c1f3f1 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -7,6 +7,7 @@
  *          Mika Westerberg <mika.westerberg@linux.intel.com>
  */
 
+#include <linux/dmi.h>
 #include <linux/errno.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/driver.h>
@@ -19,6 +20,23 @@
 
 #include "gpiolib.h"
 
+static int gpiolib_acpi_run_edge_events_on_boot = -1;
+
+static int __init gpiolib_acpi_run_edge_events_on_boot_setup(char *arg)
+{
+	if (!strcmp(arg, "on"))
+		gpiolib_acpi_run_edge_events_on_boot = 1;
+	else if (!strcmp(arg, "off"))
+		gpiolib_acpi_run_edge_events_on_boot = 0;
+	else if (!strcmp(arg, "auto"))
+		gpiolib_acpi_run_edge_events_on_boot = -1;
+
+	return 1;
+}
+
+__setup("gpiolib_acpi_run_edge_events_on_boot=",
+        gpiolib_acpi_run_edge_events_on_boot_setup);
+
 /**
  * struct acpi_gpio_event - ACPI GPIO event handler data
  *
@@ -150,6 +168,29 @@ bool acpi_gpio_get_irq_resource(struct acpi_resource *ares,
 }
 EXPORT_SYMBOL_GPL(acpi_gpio_get_irq_resource);
 
+static const struct dmi_system_id run_edge_events_on_boot_blacklist[] =
+{
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MINIX"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
+		}
+	},
+	{} /* Terminating entry */
+};
+
+static bool acpi_gpiochip_run_edge_events_on_boot(void)
+{
+	if (gpiolib_acpi_run_edge_events_on_boot == -1) {
+		if (dmi_check_system(run_edge_events_on_boot_blacklist))
+			gpiolib_acpi_run_edge_events_on_boot = 0;
+		else
+			gpiolib_acpi_run_edge_events_on_boot = 1;
+	}
+
+	return gpiolib_acpi_run_edge_events_on_boot;
+}
+
 static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
 				      struct acpi_gpio_event *event)
 {
@@ -170,10 +211,13 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
 	event->irq_requested = true;
 
 	/* Make sure we trigger the initial state of edge-triggered IRQs */
-	value = gpiod_get_raw_value_cansleep(event->desc);
-	if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
-	    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
-		event->handler(event->irq, event);
+	if (acpi_gpiochip_run_edge_events_on_boot() &&
+	    (event->irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
+		value = gpiod_get_raw_value_cansleep(event->desc);
+		if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
+		    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
+			event->handler(event->irq, event);
+	}
 }
 
 static void acpi_gpiochip_request_irqs(struct acpi_gpio_chip *acpi_gpio)
-- 
2.22.0

