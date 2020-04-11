Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCF81A5114
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgDKMTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgDKMTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:19:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 863952084D;
        Sat, 11 Apr 2020 12:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607578;
        bh=0ki8E5fUwDomXD5A8RGGssTovd2CPn5Nv7qRhsklLKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoPuAodLR8oDySanKcrP8PpiMw3JVe0Mgg6GZ4H9NXa+sRRGxGH8oYRWZfeUQxCWi
         ccdQ6G6IS0OTtTS1q3VSU7pv5f6us29A0yABp5NUPiLxlppccoxneZK4oFDciX6Rai
         0Q/O3a4HurtEvQCXWI7ZB2phxZmvHOAlrRjXsbnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.5 34/44] ACPI: PM: Add acpi_[un]register_wakeup_handler()
Date:   Sat, 11 Apr 2020 14:09:54 +0200
Message-Id: <20200411115500.209065272@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115456.934174282@linuxfoundation.org>
References: <20200411115456.934174282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit ddfd9dcf270ce23ed1985b66fcfa163920e2e1b8 upstream.

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

Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking up the system")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c  |    4 ++
 drivers/acpi/sleep.h  |    1 
 drivers/acpi/wakeup.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h  |    5 +++
 4 files changed, 91 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1009,6 +1009,10 @@ static bool acpi_s2idle_wake(void)
 		if (acpi_any_fixed_event_status_set())
 			return true;
 
+		/* Check wakeups from drivers sharing the SCI. */
+		if (acpi_check_wakeup_handlers())
+			return true;
+
 		/*
 		 * If there are no EC events to process and at least one of the
 		 * other enabled GPEs is active, the wakeup is regarded as a
--- a/drivers/acpi/sleep.h
+++ b/drivers/acpi/sleep.h
@@ -2,6 +2,7 @@
 
 extern void acpi_enable_wakeup_devices(u8 sleep_state);
 extern void acpi_disable_wakeup_devices(u8 sleep_state);
+extern bool acpi_check_wakeup_handlers(void);
 
 extern struct list_head acpi_wakeup_device_list;
 extern struct mutex acpi_device_lock;
--- a/drivers/acpi/wakeup.c
+++ b/drivers/acpi/wakeup.c
@@ -12,6 +12,15 @@
 #include "internal.h"
 #include "sleep.h"
 
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
  * We didn't lock acpi_device_lock in the file, because it invokes oops in
  * suspend/resume and isn't really required as this is called in S-state. At
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
+int acpi_register_wakeup_handler(int wake_irq, bool (*wakeup)(void *context),
+				 void *context)
+{
+	struct acpi_wakeup_handler *handler;
+
+	/*
+	 * If the device is not sharing its IRQ with the SCI, there is no
+	 * need to register the handler.
+	 */
+	if (!acpi_sci_irq_valid() || wake_irq != acpi_sci_irq)
+		return 0;
+
+	handler = kmalloc(sizeof(*handler), GFP_KERNEL);
+	if (!handler)
+		return -ENOMEM;
+
+	handler->wakeup = wakeup;
+	handler->context = context;
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
+		if (handler->wakeup == wakeup && handler->context == context) {
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
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -473,6 +473,11 @@ void __init acpi_nvs_nosave_s3(void);
 void __init acpi_sleep_no_blacklist(void);
 #endif /* CONFIG_PM_SLEEP */
 
+int acpi_register_wakeup_handler(
+	int wake_irq, bool (*wakeup)(void *context), void *context);
+void acpi_unregister_wakeup_handler(
+	bool (*wakeup)(void *context), void *context);
+
 struct acpi_osc_context {
 	char *uuid_str;			/* UUID string */
 	int rev;


