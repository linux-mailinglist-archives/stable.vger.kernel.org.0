Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9DF1308F0
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 17:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgAEQEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 11:04:06 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38847 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726368AbgAEQEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 11:04:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578240245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A/33Bm+13CRC3/45n5naRZGL+ZJZLmQDLr9YNBU43Z0=;
        b=jUVuLhCGQja2JIrphQpBbJHAeh6CPy9drnrTM+J5Y0l8/Kp0daf/0+EzywLlpqcL1nwuih
        L7HSZ11dUqKKtn+YK/Enc40qk2/Cu6ANo7SUEBNY2bLD1EnZVdzIWllfgoLRPDxQRb8Yk0
        4edcHZXUDWwYXwxDiN4UOJ2Ko63bVaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-p2CHF7ToMSOCDQ4oXvMuzA-1; Sun, 05 Jan 2020 11:04:04 -0500
X-MC-Unique: p2CHF7ToMSOCDQ4oXvMuzA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E8CA800D48;
        Sun,  5 Jan 2020 16:04:02 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-82.ams2.redhat.com [10.36.116.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80D8760C87;
        Sun,  5 Jan 2020 16:04:00 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH resend v2 1/2] gpiolib: acpi: Turn dmi_system_id table into a generic quirk table
Date:   Sun,  5 Jan 2020 17:03:56 +0100
Message-Id: <20200105160357.97154-2-hdegoede@redhat.com>
In-Reply-To: <20200105160357.97154-1-hdegoede@redhat.com>
References: <20200105160357.97154-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Turn the existing run_edge_events_on_boot_blacklist dmi_system_id table
into a generic quirk table, storing the quirks in the driver_data ptr.

This is a preparation patch for adding other types of (DMI based) quirks.

Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/gpio/gpiolib-acpi.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index d30e57dc755c..2b47d906d536 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -21,6 +21,8 @@
 #include "gpiolib.h"
 #include "gpiolib-acpi.h"
=20
+#define QUIRK_NO_EDGE_EVENTS_ON_BOOT		0x01l
+
 static int run_edge_events_on_boot =3D -1;
 module_param(run_edge_events_on_boot, int, 0444);
 MODULE_PARM_DESC(run_edge_events_on_boot,
@@ -1309,7 +1311,7 @@ static int acpi_gpio_handle_deferred_request_irqs(v=
oid)
 /* We must use _sync so that this runs after the first deferred_probe ru=
n */
 late_initcall_sync(acpi_gpio_handle_deferred_request_irqs);
=20
-static const struct dmi_system_id run_edge_events_on_boot_blacklist[] =3D=
 {
+static const struct dmi_system_id gpiolib_acpi_quirks[] =3D {
 	{
 		/*
 		 * The Minix Neo Z83-4 has a micro-USB-B id-pin handler for
@@ -1319,7 +1321,8 @@ static const struct dmi_system_id run_edge_events_o=
n_boot_blacklist[] =3D {
 		.matches =3D {
 			DMI_MATCH(DMI_SYS_VENDOR, "MINIX"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Z83-4"),
-		}
+		},
+		.driver_data =3D (void *)QUIRK_NO_EDGE_EVENTS_ON_BOOT,
 	},
 	{
 		/*
@@ -1331,15 +1334,23 @@ static const struct dmi_system_id run_edge_events=
_on_boot_blacklist[] =3D {
 		.matches =3D {
 			DMI_MATCH(DMI_SYS_VENDOR, "Wortmann_AG"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "TERRA_PAD_1061"),
-		}
+		},
+		.driver_data =3D (void *)QUIRK_NO_EDGE_EVENTS_ON_BOOT,
 	},
 	{} /* Terminating entry */
 };
=20
 static int acpi_gpio_setup_params(void)
 {
+	const struct dmi_system_id *id;
+	long quirks =3D 0;
+
+	id =3D dmi_first_match(gpiolib_acpi_quirks);
+	if (id)
+		quirks =3D (long)id->driver_data;
+
 	if (run_edge_events_on_boot < 0) {
-		if (dmi_check_system(run_edge_events_on_boot_blacklist))
+		if (quirks & QUIRK_NO_EDGE_EVENTS_ON_BOOT)
 			run_edge_events_on_boot =3D 0;
 		else
 			run_edge_events_on_boot =3D 1;
--=20
2.24.1

