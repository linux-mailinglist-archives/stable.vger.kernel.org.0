Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB121308F3
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 17:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgAEQEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 11:04:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21447 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726212AbgAEQEL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 11:04:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578240250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0949pnRMfVEMOsmz9w7+euue4V+BXtAsSOKyd1WMVz4=;
        b=FAB17OJY/n+oE1NsvkZieRdsrNNvqeyIbCKWZMJII15PIc00uQNy3plj4x3HP9edeiXWHK
        A5zDV7fcTXZv62tTOpbZ1n7SVyxYRaGE7Psmjqmjfenjd8aFKIcNi1HMKqSAmwv2wwezdd
        HQ+IBoIFPW+Fwm9/s2JZ5I6f5yp8acw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-7uUyjDCTP--8Re8hyDJqeg-1; Sun, 05 Jan 2020 11:04:05 -0500
X-MC-Unique: 7uUyjDCTP--8Re8hyDJqeg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F06041800D42;
        Sun,  5 Jan 2020 16:04:03 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-82.ams2.redhat.com [10.36.116.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63ABC60C63;
        Sun,  5 Jan 2020 16:04:02 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH resend v2 2/2] gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism
Date:   Sun,  5 Jan 2020 17:03:57 +0100
Message-Id: <20200105160357.97154-3-hdegoede@redhat.com>
In-Reply-To: <20200105160357.97154-1-hdegoede@redhat.com>
References: <20200105160357.97154-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On some laptops enabling wakeup on the GPIO interrupts used for ACPI _AEI
event handling causes spurious wakeups.

This commit adds a new honor_wakeup option, defaulting to true (our curre=
nt
behavior), which can be used to disable wakeup on troublesome hardware
to avoid these spurious wakeups.

This is a workaround for an architectural problem with s2idle under Linux
where we do not have any mechanism to immediately go back to sleep after
wakeup events, other then for embedded-controller events using the standa=
rd
ACPI EC interface, for details see:
https://lore.kernel.org/linux-acpi/61450f9b-cbc6-0c09-8b3a-aff6bf9a0b3c@r=
edhat.com/

One series of laptops which is not able to suspend without this workaroun=
d
is the HP x2 10 Cherry Trail models, this commit adds a DMI based quirk
which makes sets honor_wakeup to false on these models.

Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Use honor_wakeup && ... instead of if (honor_wakeup) ...
- Fix some typos in the comment explaining the need for the quirk
---
 drivers/gpio/gpiolib-acpi.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 2b47d906d536..31fee5e918b7 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -22,12 +22,18 @@
 #include "gpiolib-acpi.h"
=20
 #define QUIRK_NO_EDGE_EVENTS_ON_BOOT		0x01l
+#define QUIRK_NO_WAKEUP				0x02l
=20
 static int run_edge_events_on_boot =3D -1;
 module_param(run_edge_events_on_boot, int, 0444);
 MODULE_PARM_DESC(run_edge_events_on_boot,
 		 "Run edge _AEI event-handlers at boot: 0=3Dno, 1=3Dyes, -1=3Dauto");
=20
+static int honor_wakeup =3D -1;
+module_param(honor_wakeup, int, 0444);
+MODULE_PARM_DESC(honor_wakeup,
+		 "Honor the ACPI wake-capable flag: 0=3Dno, 1=3Dyes, -1=3Dauto");
+
 /**
  * struct acpi_gpio_event - ACPI GPIO event handler data
  *
@@ -283,7 +289,7 @@ static acpi_status acpi_gpiochip_alloc_event(struct a=
cpi_resource *ares,
 	event->handle =3D evt_handle;
 	event->handler =3D handler;
 	event->irq =3D irq;
-	event->irq_is_wake =3D agpio->wake_capable =3D=3D ACPI_WAKE_CAPABLE;
+	event->irq_is_wake =3D honor_wakeup && agpio->wake_capable =3D=3D ACPI_=
WAKE_CAPABLE;
 	event->pin =3D pin;
 	event->desc =3D desc;
=20
@@ -1337,6 +1343,23 @@ static const struct dmi_system_id gpiolib_acpi_qui=
rks[] =3D {
 		},
 		.driver_data =3D (void *)QUIRK_NO_EDGE_EVENTS_ON_BOOT,
 	},
+	{
+		/*
+		 * Various HP X2 10 Cherry Trail models use an external
+		 * embedded-controller connected via I2C + an ACPI GPIO
+		 * event handler. The embedded controller generates various
+		 * spurious wakeup events when suspended. So disable wakeup
+		 * for its handler (it uses the only ACPI GPIO event handler).
+		 * This breaks wakeup when opening the lid, the user needs
+		 * to press the power-button to wakeup the system. The
+		 * alternative is suspend simply not working, which is worse.
+		 */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP x2 Detachable 10-p0XX"),
+		},
+		.driver_data =3D (void *)QUIRK_NO_WAKEUP,
+	},
 	{} /* Terminating entry */
 };
=20
@@ -1356,6 +1379,13 @@ static int acpi_gpio_setup_params(void)
 			run_edge_events_on_boot =3D 1;
 	}
=20
+	if (honor_wakeup < 0) {
+		if (quirks & QUIRK_NO_WAKEUP)
+			honor_wakeup =3D 0;
+		else
+			honor_wakeup =3D 1;
+	}
+
 	return 0;
 }
=20
--=20
2.24.1

