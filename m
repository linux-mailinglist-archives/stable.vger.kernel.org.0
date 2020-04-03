Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC519DA86
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 17:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgDCPsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 11:48:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390961AbgDCPsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 11:48:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585928921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Sb9VDhHMrgFicenags/SlqyyHwSucJM7aSnz3ab/8iQ=;
        b=elnHMTmukQsOluX4zGjFUAavfAhxWkvAjrkpgO35/twfxO1q3VsipxwYu3rBE7GZzbllot
        YDFFE+z0u9+6E8plypJmnGrWgLlehY/wWKQPNCGak2dO+9nqYg+aEM9DWF/IQnJpnP4EcH
        LnIh33AZt/qJcJqmfW5vnxJbruAmQ2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-H93XVpFtOPOmG0ByITn-lA-1; Fri, 03 Apr 2020 11:48:39 -0400
X-MC-Unique: H93XVpFtOPOmG0ByITn-lA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE52018C35A2;
        Fri,  3 Apr 2020 15:48:37 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-115-123.ams2.redhat.com [10.36.115.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3383589F0A;
        Fri,  3 Apr 2020 15:48:36 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "5 . 4+" <stable@vger.kernel.org>
Subject: [PATCH v3 1/2] ACPI: PM: Add acpi_[un]register_wakeup_handler()
Date:   Fri,  3 Apr 2020 17:48:33 +0200
Message-Id: <20200403154834.303105-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from
waking up the system") the SCI triggering without there being a wakeup
cause recognized by the ACPI sleep code will no longer wakeup the system.

This works as intended, but this is a problem for devices where the SCI
is shared with another device which is also a wakeup source.

In the past these, from the pov of the ACPI sleep code, spurious SCIs
would still cause a wakeup so the wakeup from the device sharing the
interrupt would actually wakeup the system. This now no longer works.

This is a problem on e.g. Bay Trail-T and Cherry Trail devices where
some peripherals (typically the XHCI controller) can signal a
Power Management Event (PME) to the Power Management Controller (PMC)
to wakeup the system, this uses the same interrupt as the SCI.
These wakeups are handled through a special INT0002 ACPI device which
checks for events in the GPE0a_STS for this and takes care of acking
the PME so that the shared interrupt stops triggering.

The change to the ACPI sleep code to ignore the spurious SCI, causes
the system to no longer wakeup on these PME events. To make things
worse this means that the INT0002 device driver interrupt handler will
no longer run, causing the PME to not get cleared and resulting in the
system hanging. Trying to wakeup the system after such a PME through e.g.
the power button no longer works.

Add an acpi_register_wakeup_handler() function which registers
a handler to be called from acpi_s2idle_wake() and when the handler
returns true, return true from acpi_s2idle_wake().

The INT0002 driver will use this mechanism to check the GPE0a_STS
register from acpi_s2idle_wake() and to tell the system to wakeup
if a PME is signaled in the register.

Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking=
 up the system")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v3:
- Some small indentation changes

Changes in v2:
- Move the new helpers to drivers/acpi/wakeup.c
- Rename the helpers to acpi_[un]register_wakeup_handler(), also give som=
e
  types/variables better names
---
 drivers/acpi/sleep.c  |  4 +++
 drivers/acpi/sleep.h  |  1 +
 drivers/acpi/wakeup.c | 81 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h  |  5 +++
 4 files changed, 91 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index e5f95922bc21..dc8c71c47285 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1025,6 +1025,10 @@ static bool acpi_s2idle_wake(void)
 		if (acpi_any_gpe_status_set() && !acpi_ec_dispatch_gpe())
 			return true;
=20
+		/* Check wakeups from drivers sharing the SCI. */
+		if (acpi_check_wakeup_handlers())
+			return true;
+
 		/*
 		 * Cancel the wakeup and process all pending events in case
 		 * there are any wakeup ones in there.
diff --git a/drivers/acpi/sleep.h b/drivers/acpi/sleep.h
index 41675d24a9bc..3d90480ce1b1 100644
--- a/drivers/acpi/sleep.h
+++ b/drivers/acpi/sleep.h
@@ -2,6 +2,7 @@
=20
 extern void acpi_enable_wakeup_devices(u8 sleep_state);
 extern void acpi_disable_wakeup_devices(u8 sleep_state);
+extern bool acpi_check_wakeup_handlers(void);
=20
 extern struct list_head acpi_wakeup_device_list;
 extern struct mutex acpi_device_lock;
diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
index 9614126bf56e..90c40f992e13 100644
--- a/drivers/acpi/wakeup.c
+++ b/drivers/acpi/wakeup.c
@@ -12,6 +12,15 @@
 #include "internal.h"
 #include "sleep.h"
=20
+struct acpi_wakeup_handler {
+	struct list_head list_node;
+	bool (*wakeup)(void *context);
+	void *context;
+};
+
+static LIST_HEAD(acpi_wakeup_handler_head);
+static DEFINE_MUTEX(acpi_wakeup_handler_mutex);
+
 /*
  * We didn't lock acpi_device_lock in the file, because it invokes oops =
in
  * suspend/resume and isn't really required as this is called in S-state=
. At
@@ -96,3 +105,75 @@ int __init acpi_wakeup_device_init(void)
 	mutex_unlock(&acpi_device_lock);
 	return 0;
 }
+
+/**
+ * acpi_register_wakeup_handler - Register wakeup handler
+ * @wake_irq: The IRQ through which the device may receive wakeups
+ * @wakeup:   Wakeup-handler to call when the SCI has triggered a wakeup
+ * @context:  Context to pass to the handler when calling it
+ *
+ * Drivers which may share an IRQ with the SCI can use this to register
+ * a handler which returns true when the device they are managing wants
+ * to trigger a wakeup.
+ */
+int acpi_register_wakeup_handler(int wake_irq, bool (*wakeup)(void *cont=
ext),
+				 void *context)
+{
+	struct acpi_wakeup_handler *handler;
+
+	/*
+	 * If the device is not sharing its IRQ with the SCI, there is no
+	 * need to register the handler.
+	 */
+	if (!acpi_sci_irq_valid() || wake_irq !=3D acpi_sci_irq)
+		return 0;
+
+	handler =3D kmalloc(sizeof(*handler), GFP_KERNEL);
+	if (!handler)
+		return -ENOMEM;
+
+	handler->wakeup =3D wakeup;
+	handler->context =3D context;
+
+	mutex_lock(&acpi_wakeup_handler_mutex);
+	list_add(&handler->list_node, &acpi_wakeup_handler_head);
+	mutex_unlock(&acpi_wakeup_handler_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_register_wakeup_handler);
+
+/**
+ * acpi_unregister_wakeup_handler - Unregister wakeup handler
+ * @wakeup:   Wakeup-handler passed to acpi_register_wakeup_handler()
+ * @context:  Context passed to acpi_register_wakeup_handler()
+ */
+void acpi_unregister_wakeup_handler(bool (*wakeup)(void *context),
+				    void *context)
+{
+	struct acpi_wakeup_handler *handler;
+
+	mutex_lock(&acpi_wakeup_handler_mutex);
+	list_for_each_entry(handler, &acpi_wakeup_handler_head, list_node) {
+		if (handler->wakeup =3D=3D wakeup && handler->context =3D=3D context) =
{
+			list_del(&handler->list_node);
+			kfree(handler);
+			break;
+		}
+	}
+	mutex_unlock(&acpi_wakeup_handler_mutex);
+}
+EXPORT_SYMBOL_GPL(acpi_unregister_wakeup_handler);
+
+bool acpi_check_wakeup_handlers(void)
+{
+	struct acpi_wakeup_handler *handler;
+
+	/* No need to lock, nothing else is running when we're called. */
+	list_for_each_entry(handler, &acpi_wakeup_handler_head, list_node) {
+		if (handler->wakeup(handler->context))
+			return true;
+	}
+
+	return false;
+}
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 0f24d701fbdc..efac0f9c01a2 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -488,6 +488,11 @@ void __init acpi_nvs_nosave_s3(void);
 void __init acpi_sleep_no_blacklist(void);
 #endif /* CONFIG_PM_SLEEP */
=20
+int acpi_register_wakeup_handler(
+	int wake_irq, bool (*wakeup)(void *context), void *context);
+void acpi_unregister_wakeup_handler(
+	bool (*wakeup)(void *context), void *context);
+
 struct acpi_osc_context {
 	char *uuid_str;			/* UUID string */
 	int rev;
--=20
2.26.0

