Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B7092249
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 13:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfHSL07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 07:26:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39659 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfHSL07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 07:26:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so1053607pgi.6;
        Mon, 19 Aug 2019 04:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vRVye6B8XFgwGVUEF0GcA194DZPYgp0SHGUoR6zegFI=;
        b=eoOeXs46jigQlSjUrPijc/oAUBkYCMh5h7wy7K5rCwFMCI6NX5c67Ftrq7DQTgNEYA
         rhi6pWmJ5wOab8uC9xZ60knm73pwug1ubUJMCgbe7BdN4k1fXliPgHEnzR4mUFSkWLJD
         NOmdvihYR1oLgfDoHKMYrzC3xG6cacVYOabtrv8imr9G2I0nK57rf0i3nh2WEr2/wTOn
         sF5SSNdCz1QC0wihKUP46q7IailDx74HUxS6VDxAJp9SmWLSChgz73DEkX153UQyAeIa
         fwRkZwhx/JOA4l0QMpZ4n7p018JBE6g9pJmPelQXbDKwAD/2U0eObhWrL7T1LNy9k1Vh
         Mb4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vRVye6B8XFgwGVUEF0GcA194DZPYgp0SHGUoR6zegFI=;
        b=PHhZKsenuZ8VDfaRm4iwVLt+8Qn5qJF8ULrcYeSczlstt0ChQ+eQRh7nezoNZG1abm
         Ty+8WaiUWmWkwWzCkHNe9QKlaaeka68N0Q+JVKBKfpuw88+1z3EvsZ8n3LM8gm7gYU1f
         6nyuZv8CDwC4j8I3ASjvhMs3Q91KlQiIMFLSJCbI04pISYL6BkTEAQKZ6drGGetN9OE3
         iqlUKeQjP/NL+WNZmjBlgcG7gxtQt+fsEaQucMZFz+nX/J03vrToXLHxaktF5TAd7i3s
         JiJPm8+Tj2OkrgDIPKTs+a2p4/wgGVQnl1bleHCy9HVo01iX8znW5H0rFiZC7dF7wXif
         9IoQ==
X-Gm-Message-State: APjAAAV/noRaT2NJnyl9cfnPhJSqa7OtZQ59831L910ommbrKK6naZOm
        yDPEll/sk1aXhOFJKap82cI=
X-Google-Smtp-Source: APXvYqx0jyZSkUJc+ccc4cDOsChOkIyUbxMIWJOpwE3D6Rdphhg/hGR2Jsau1+7LWRECYdHdPsbsbA==
X-Received: by 2002:a63:194f:: with SMTP id 15mr19939402pgz.382.1566214018788;
        Mon, 19 Aug 2019 04:26:58 -0700 (PDT)
Received: from localhost.localdomain ([58.173.144.54])
        by smtp.googlemail.com with ESMTPSA id br18sm13826091pjb.20.2019.08.19.04.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 04:26:58 -0700 (PDT)
From:   Ian W MORRISON <ianwmorrison@gmail.com>
To:     benjamin.tissoires@redhat.com, hdegoede@redhat.com,
        mika.westerberg@linux.intel.com, andriy.shevchenko@linux.intel.com,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com
Cc:     linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ian W MORRISON <ianwmorrison@gmail.com>
Subject: [PATCH v2] Skip deferred request irqs for devices known to fail
Date:   Mon, 19 Aug 2019 21:26:37 +1000
Message-Id: <20190819112637.29943-1-ianwmorrison@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch ca876c7483b6 "gpiolib-acpi: make sure we trigger edge events at
least once on boot" causes the MINIX family of mini PCs to fail to boot
resulting in a "black screen". 

This patch excludes MINIX devices from executing this trigger in order
to successfully boot.

Cc: stable@vger.kernel.org
Signed-off-by: Ian W MORRISON <ianwmorrison@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index fdee8afa5339..f6c3dcdc91c9 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -13,6 +13,7 @@
 #include <linux/gpio/machine.h>
 #include <linux/export.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/pinctrl/pinctrl.h>
@@ -20,6 +21,17 @@
 #include "gpiolib.h"
 #include "gpiolib-acpi.h"
 
+static const struct dmi_system_id skip_deferred_request_irqs_table[] = {
+	{
+		.ident = "MINIX Z83-4",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "MINIX"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
+		},
+	},
+	{}
+};
+
 /**
  * struct acpi_gpio_event - ACPI GPIO event handler data
  *
@@ -1273,19 +1285,28 @@ bool acpi_can_fallback_to_crs(struct acpi_device *adev, const char *con_id)
 	return con_id == NULL;
 }
 
-/* Run deferred acpi_gpiochip_request_irqs() */
+/*
+ * Run deferred acpi_gpiochip_request_irqs()
+ * but exclude devices known to fail
+*/
 static int acpi_gpio_handle_deferred_request_irqs(void)
 {
 	struct acpi_gpio_chip *acpi_gpio, *tmp;
+	const struct dmi_system_id *dmi_id;
 
-	mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
-	list_for_each_entry_safe(acpi_gpio, tmp,
+	dmi_id = dmi_first_match(skip_deferred_request_irqs_table);
+	if (dmi_id)
+		return 0;
+	else {
+		mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
+		list_for_each_entry_safe(acpi_gpio, tmp,
 				 &acpi_gpio_deferred_req_irqs_list,
 				 deferred_req_irqs_list_entry)
-		acpi_gpiochip_request_irqs(acpi_gpio);
+			acpi_gpiochip_request_irqs(acpi_gpio);
 
-	acpi_gpio_deferred_req_irqs_done = true;
-	mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
+		acpi_gpio_deferred_req_irqs_done = true;
+		mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
+	}
 
 	return 0;
 }
-- 
2.17.1

