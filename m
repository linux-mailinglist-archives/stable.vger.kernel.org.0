Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F2C12F187
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgABWL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgABWL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:11:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F9CA21835;
        Thu,  2 Jan 2020 22:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003085;
        bh=yMahMulFgQ6WtFTm+jLd4UQx43/b4oX/EyX46Ne8n/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUPyAaDRY8H5GWNCsBSZXtnKRkKr4gYGyBC1GoLtXZhhWWnVrhHI7iuMh85mMUEz+
         K8PNb9plLtllfRVCkz/fvTW6LJR87GpI1GoaZ2iAz13YpUdyMZZ1nA4s5+25V5SJyA
         no03tnB1/6d6eVoQNv4kSWKtkyNimX9sL3XhLYyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/191] platform/x86: peaq-wmi: switch to using polled mode of input devices
Date:   Thu,  2 Jan 2020 23:04:56 +0100
Message-Id: <20200102215831.258686995@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 60d15095336cfb56dce5c7767ed3b8c6c1cf79a3 ]

We have added polled mode to the normal input devices with the intent of
retiring input_polled_dev. This converts peaq-wmi driver to use the
polling mode of standard input devices and removes dependency on
INPUT_POLLDEV.

Because the new polling coded does not allow peeking inside the poller
structure to get the poll interval, we change the "debounce" process to
operate on the time basis, instead of counting events.

We also fix error handling during initialization, as previously we leaked
input device structure when we failed to register it.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig    |  1 -
 drivers/platform/x86/peaq-wmi.c | 66 +++++++++++++++++++++------------
 2 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index ae21d08c65e8..1cab99320514 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -806,7 +806,6 @@ config PEAQ_WMI
 	tristate "PEAQ 2-in-1 WMI hotkey driver"
 	depends on ACPI_WMI
 	depends on INPUT
-	select INPUT_POLLDEV
 	help
 	 Say Y here if you want to support WMI-based hotkeys on PEAQ 2-in-1s.
 
diff --git a/drivers/platform/x86/peaq-wmi.c b/drivers/platform/x86/peaq-wmi.c
index fdeb3624c529..cf9c44c20a82 100644
--- a/drivers/platform/x86/peaq-wmi.c
+++ b/drivers/platform/x86/peaq-wmi.c
@@ -6,7 +6,7 @@
 
 #include <linux/acpi.h>
 #include <linux/dmi.h>
-#include <linux/input-polldev.h>
+#include <linux/input.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -18,8 +18,7 @@
 
 MODULE_ALIAS("wmi:"PEAQ_DOLBY_BUTTON_GUID);
 
-static unsigned int peaq_ignore_events_counter;
-static struct input_polled_dev *peaq_poll_dev;
+static struct input_dev *peaq_poll_dev;
 
 /*
  * The Dolby button (yes really a Dolby button) causes an ACPI variable to get
@@ -28,8 +27,10 @@ static struct input_polled_dev *peaq_poll_dev;
  * (if polling after the release) or twice (polling between press and release).
  * We ignore events for 0.5s after the first event to avoid reporting 2 presses.
  */
-static void peaq_wmi_poll(struct input_polled_dev *dev)
+static void peaq_wmi_poll(struct input_dev *input_dev)
 {
+	static unsigned long last_event_time;
+	static bool had_events;
 	union acpi_object obj;
 	acpi_status status;
 	u32 dummy = 0;
@@ -44,22 +45,25 @@ static void peaq_wmi_poll(struct input_polled_dev *dev)
 		return;
 
 	if (obj.type != ACPI_TYPE_INTEGER) {
-		dev_err(&peaq_poll_dev->input->dev,
+		dev_err(&input_dev->dev,
 			"Error WMBC did not return an integer\n");
 		return;
 	}
 
-	if (peaq_ignore_events_counter && peaq_ignore_events_counter--)
+	if (!obj.integer.value)
 		return;
 
-	if (obj.integer.value) {
-		input_event(peaq_poll_dev->input, EV_KEY, KEY_SOUND, 1);
-		input_sync(peaq_poll_dev->input);
-		input_event(peaq_poll_dev->input, EV_KEY, KEY_SOUND, 0);
-		input_sync(peaq_poll_dev->input);
-		peaq_ignore_events_counter = max(1u,
-			PEAQ_POLL_IGNORE_MS / peaq_poll_dev->poll_interval);
-	}
+	if (had_events && time_before(jiffies, last_event_time +
+					msecs_to_jiffies(PEAQ_POLL_IGNORE_MS)))
+		return;
+
+	input_event(input_dev, EV_KEY, KEY_SOUND, 1);
+	input_sync(input_dev);
+	input_event(input_dev, EV_KEY, KEY_SOUND, 0);
+	input_sync(input_dev);
+
+	last_event_time = jiffies;
+	had_events = true;
 }
 
 /* Some other devices (Shuttle XS35) use the same WMI GUID for other purposes */
@@ -75,6 +79,8 @@ static const struct dmi_system_id peaq_dmi_table[] __initconst = {
 
 static int __init peaq_wmi_init(void)
 {
+	int err;
+
 	/* WMI GUID is not unique, also check for a DMI match */
 	if (!dmi_check_system(peaq_dmi_table))
 		return -ENODEV;
@@ -82,24 +88,36 @@ static int __init peaq_wmi_init(void)
 	if (!wmi_has_guid(PEAQ_DOLBY_BUTTON_GUID))
 		return -ENODEV;
 
-	peaq_poll_dev = input_allocate_polled_device();
+	peaq_poll_dev = input_allocate_device();
 	if (!peaq_poll_dev)
 		return -ENOMEM;
 
-	peaq_poll_dev->poll = peaq_wmi_poll;
-	peaq_poll_dev->poll_interval = PEAQ_POLL_INTERVAL_MS;
-	peaq_poll_dev->poll_interval_max = PEAQ_POLL_MAX_MS;
-	peaq_poll_dev->input->name = "PEAQ WMI hotkeys";
-	peaq_poll_dev->input->phys = "wmi/input0";
-	peaq_poll_dev->input->id.bustype = BUS_HOST;
-	input_set_capability(peaq_poll_dev->input, EV_KEY, KEY_SOUND);
+	peaq_poll_dev->name = "PEAQ WMI hotkeys";
+	peaq_poll_dev->phys = "wmi/input0";
+	peaq_poll_dev->id.bustype = BUS_HOST;
+	input_set_capability(peaq_poll_dev, EV_KEY, KEY_SOUND);
+
+	err = input_setup_polling(peaq_poll_dev, peaq_wmi_poll);
+	if (err)
+		goto err_out;
+
+	input_set_poll_interval(peaq_poll_dev, PEAQ_POLL_INTERVAL_MS);
+	input_set_max_poll_interval(peaq_poll_dev, PEAQ_POLL_MAX_MS);
+
+	err = input_register_device(peaq_poll_dev);
+	if (err)
+		goto err_out;
+
+	return 0;
 
-	return input_register_polled_device(peaq_poll_dev);
+err_out:
+	input_free_device(peaq_poll_dev);
+	return err;
 }
 
 static void __exit peaq_wmi_exit(void)
 {
-	input_unregister_polled_device(peaq_poll_dev);
+	input_unregister_device(peaq_poll_dev);
 }
 
 module_init(peaq_wmi_init);
-- 
2.20.1



