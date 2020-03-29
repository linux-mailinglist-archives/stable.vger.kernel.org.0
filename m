Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B826D1970CE
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 00:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgC2Wec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 18:34:32 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:56675 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728895AbgC2Web (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 18:34:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585521270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mXnpHPVB8oNjkrr0GvLRzt8WY0+Fyot03Jm3B6RUun4=;
        b=haI11/WLAPkOdyrzmTehxAHWxuEsmj3cpwngLPollSetdnJQ8hNM59Noj7fTBuBApYVTSY
        Qy4ApMWcul1sb37Ehs2MalrJy8z3jYxajztxKOXRj10B1gCptsZvtM2qCuz8/O1owwYwms
        lMq2cMm5ETMwflGR2c2XXeG33s5Kg50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-Gvb4R2v2Pza2-RVY6EJ3PA-1; Sun, 29 Mar 2020 18:34:26 -0400
X-MC-Unique: Gvb4R2v2Pza2-RVY6EJ3PA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 327C113F9;
        Sun, 29 Mar 2020 22:34:25 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-12.ams2.redhat.com [10.36.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 749045DA66;
        Sun, 29 Mar 2020 22:34:23 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        "5 . 4+" <stable@vger.kernel.org>
Subject: [PATCH 5.6 regression fix 1/2] ACPI: PM: Add acpi_s2idle_register_wake_callback()
Date:   Mon, 30 Mar 2020 00:34:18 +0200
Message-Id: <20200329223419.122796-2-hdegoede@redhat.com>
In-Reply-To: <20200329223419.122796-1-hdegoede@redhat.com>
References: <20200329223419.122796-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Add an acpi_s2idle_register_wake_callback() function which registers
a callback to be called from acpi_s2idle_wake() and when the callback
returns true, return true from acpi_s2idle_wake().

The INT0002 driver will use this mechanism to check the GPE0a_STS
register from acpi_s2idle_wake() and to tell the system to wakeup
if a PME is signaled in the register.

Fixes: fdde0ff8590b ("ACPI: PM: s2idle: Prevent spurious SCIs from waking=
 up the system")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/acpi/sleep.c | 70 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h |  7 +++++
 2 files changed, 77 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index e5f95922bc21..e360e51afa8e 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -943,6 +943,65 @@ static struct acpi_scan_handler lps0_handler =3D {
 	.attach =3D lps0_device_attach,
 };
=20
+struct s2idle_wake_callback {
+	struct list_head list;
+	bool (*function)(void *data);
+	void *user_data;
+};
+
+static LIST_HEAD(s2idle_wake_callback_head);
+static DEFINE_MUTEX(s2idle_wake_callback_mutex);
+
+/*
+ * Drivers which may share an IRQ with the SCI can use this to register
+ * a callback which returns true when the device they are managing wants
+ * to trigger a wakeup.
+ */
+int acpi_s2idle_register_wake_callback(
+	int wake_irq, bool (*function)(void *data), void *user_data)
+{
+	struct s2idle_wake_callback *callback;
+
+	/*
+	 * If the device is not sharing its IRQ with the SCI, there is no
+	 * need to register the callback.
+	 */
+	if (!acpi_sci_irq_valid() || wake_irq !=3D acpi_sci_irq)
+		return 0;
+
+	callback =3D kmalloc(sizeof(*callback), GFP_KERNEL);
+	if (!callback)
+		return -ENOMEM;
+
+	callback->function =3D function;
+	callback->user_data =3D user_data;
+
+	mutex_lock(&s2idle_wake_callback_mutex);
+	list_add(&callback->list, &s2idle_wake_callback_head);
+	mutex_unlock(&s2idle_wake_callback_mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_s2idle_register_wake_callback);
+
+void acpi_s2idle_unregister_wake_callback(
+	bool (*function)(void *data), void *user_data)
+{
+	struct s2idle_wake_callback *cb;
+
+	mutex_lock(&s2idle_wake_callback_mutex);
+	list_for_each_entry(cb, &s2idle_wake_callback_head, list) {
+		if (cb->function =3D=3D function &&
+		    cb->user_data =3D=3D user_data) {
+			list_del(&cb->list);
+			kfree(cb);
+			break;
+		}
+	}
+	mutex_unlock(&s2idle_wake_callback_mutex);
+}
+EXPORT_SYMBOL_GPL(acpi_s2idle_unregister_wake_callback);
+
 static int acpi_s2idle_begin(void)
 {
 	acpi_scan_lock_acquire();
@@ -992,6 +1051,8 @@ static void acpi_s2idle_sync(void)
=20
 static bool acpi_s2idle_wake(void)
 {
+	struct s2idle_wake_callback *cb;
+
 	if (!acpi_sci_irq_valid())
 		return pm_wakeup_pending();
=20
@@ -1025,6 +1086,15 @@ static bool acpi_s2idle_wake(void)
 		if (acpi_any_gpe_status_set() && !acpi_ec_dispatch_gpe())
 			return true;
=20
+		/*
+		 * Check callbacks registered by drivers sharing the SCI.
+		 * Note no need to lock, nothing else is running.
+		 */
+		list_for_each_entry(cb, &s2idle_wake_callback_head, list) {
+			if (cb->function(cb->user_data))
+				return true;
+		}
+
 		/*
 		 * Cancel the wakeup and process all pending events in case
 		 * there are any wakeup ones in there.
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 0f24d701fbdc..9f06e1dc79c1 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -488,6 +488,13 @@ void __init acpi_nvs_nosave_s3(void);
 void __init acpi_sleep_no_blacklist(void);
 #endif /* CONFIG_PM_SLEEP */
=20
+#ifdef CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT
+int acpi_s2idle_register_wake_callback(
+	int wake_irq, bool (*function)(void *data), void *user_data);
+void acpi_s2idle_unregister_wake_callback(
+	bool (*function)(void *data), void *user_data);
+#endif
+
 struct acpi_osc_context {
 	char *uuid_str;			/* UUID string */
 	int rev;
--=20
2.26.0

