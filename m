Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59B8290613
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 15:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406893AbgJPNNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 09:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406679AbgJPNNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 09:13:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD2EC061755;
        Fri, 16 Oct 2020 06:13:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a1so1498481pjd.1;
        Fri, 16 Oct 2020 06:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r5Hg3Dk+SylQ4f7Edvw0KnX3T45iNPufDTirpc/94f4=;
        b=P8XLPB+1rw5hOmfd0EX46Wwjt9+Yi/55Xa1ESJR2IRDVgtIIdIduxJ4dk8KwXO2PK/
         JWFHbJoYYRFv9qAxgV5mVi9zev8EAN8BP4rMCC1GxemLojHwTKTcsvXpUTgK7CAjss1k
         BkjOo5eAo0SDCuv2pBc53lecf18q1lVUw/gK7jBxASET7xPXin73br5J46O0Zi+YDx+6
         UvY8CCcsa/tn6NG7MiQPjAV0iKbTjHqsi3NRhhGrubPWgPBIEgA9S7MGw512SQRMZo2h
         6srtgbEzbuVSyjR+8k2EgIK8wIoulMJaOPEjl2DWkAOvez8i+4q8SQMJfHvsFoeF0o2b
         m8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r5Hg3Dk+SylQ4f7Edvw0KnX3T45iNPufDTirpc/94f4=;
        b=EF5/oG+y6nqEWOSOVvw8NHOZzuGW2cGWompqJk424nlqLlzTtsAlZko9LHhEMVKf5Y
         8mpnIOMNAmHDGsNyINyCr5cDmX+eV2gn1cj3G0SKJFn8enddbePu8D8J5yfteVTogG1e
         gWeTHNd9iT9yuY4b3A1tnxWx+80k0x3uagRy1tbdhYMlFEMeOnYdghPP3ww7dTYxsDIK
         ismHNcfaJx93EgqACWmiE51aDA7JsSkvG2sTBIjojY74oIJxJ9YUSwy8nY0V7QcQtoGH
         KIRRFmiliDlbng0j335RyB9pg286nSbdSLCdHrYS401MBws3glblYRxg6A6G9L0LKsXv
         QvqQ==
X-Gm-Message-State: AOAM530lp/r6lhm11B3nlUM87UFDHRHlmc+ayJLFv9Q30fPlKDL/KyZb
        77ntYz17IcH+1mUgiwqQgWIEFs9BOABE8n0v
X-Google-Smtp-Source: ABdhPJxBXCYVxJCr/2KNV6N/iuWIi8hwoi9+qi4LXIlO+IYIEeAL9uhPanxPUH3rzVzJEbUO8rp8IA==
X-Received: by 2002:a17:902:848b:b029:d4:e5b2:fb9b with SMTP id c11-20020a170902848bb02900d4e5b2fb9bmr3824765plo.34.1602854027523;
        Fri, 16 Oct 2020 06:13:47 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id t10sm3208237pjr.37.2020.10.16.06.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 06:13:47 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Helmut Stult <helmut.stult@schinfo.de>,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        stable@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] HID: i2c-hid: add polling mode based on connected GPIO chip's pin status
Date:   Fri, 16 Oct 2020 21:13:35 +0800
Message-Id: <20201016131335.8121-1-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For a broken touchpad, it may take several months or longer to be fixed.
Polling mode could be a fallback solution for enthusiastic Linux users
when they have a new laptop. It also acts like a debugging feature. If
polling mode works for a broken touchpad, we can almost be certain
the root cause is related to the interrupt or power setting.

When polling mode is enabled, an I2C device can't wake up the suspended
system since enable/disable_irq_wake is invalid for polling mode.

Three module parameters are added to i2c-hid,
    - polling_mode: by default set to 0, i.e., polling is disabled
    - polling_interval_idle_ms: the polling internal when the touchpad
      is idle, default to 10ms
    - polling_interval_active_us: the polling internal when the touchpad
      is active, default to 4000us

User can change the last two runtime polling parameter by writing to
/sys/module/i2c_hid/parameters/polling_interval_{idle_ms,active_us}.

Cc: <stable@vger.kernel.org>
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 151 ++++++++++++++++++++++++++---
 1 file changed, 135 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index dbd04492825d..0bb8075424b6 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -36,6 +36,8 @@
 #include <linux/hid.h>
 #include <linux/mutex.h>
 #include <linux/acpi.h>
+#include <linux/kthread.h>
+#include <linux/gpio/driver.h>
 #include <linux/of.h>
 #include <linux/regulator/consumer.h>

@@ -60,6 +62,24 @@
 #define I2C_HID_PWR_ON		0x00
 #define I2C_HID_PWR_SLEEP	0x01

+/* polling mode */
+#define I2C_POLLING_DISABLED 0
+#define I2C_POLLING_GPIO_PIN 1
+#define POLLING_INTERVAL 10
+
+static u8 polling_mode;
+module_param(polling_mode, byte, 0444);
+MODULE_PARM_DESC(polling_mode, "How to poll - 0 disabled; 1 based on GPIO pin's status");
+
+static unsigned int polling_interval_active_us = 4000;
+module_param(polling_interval_active_us, uint, 0644);
+MODULE_PARM_DESC(polling_interval_active_us,
+		 "Poll every {polling_interval_active_us} us when the touchpad is active. Default to 4000 us");
+
+static unsigned int polling_interval_idle_ms = 10;
+module_param(polling_interval_idle_ms, uint, 0644);
+MODULE_PARM_DESC(polling_interval_ms,
+		 "Poll every {polling_interval_idle_ms} ms when the touchpad is idle. Default to 10 ms");
 /* debug option */
 static bool debug;
 module_param(debug, bool, 0444);
@@ -158,6 +178,8 @@ struct i2c_hid {

 	struct i2c_hid_platform_data pdata;

+	struct task_struct *polling_thread;
+
 	bool			irq_wake_enabled;
 	struct mutex		reset_lock;
 };
@@ -772,7 +794,9 @@ static int i2c_hid_start(struct hid_device *hid)
 		i2c_hid_free_buffers(ihid);

 		ret = i2c_hid_alloc_buffers(ihid, bufsize);
-		enable_irq(client->irq);
+
+		if (polling_mode == I2C_POLLING_DISABLED)
+			enable_irq(client->irq);

 		if (ret)
 			return ret;
@@ -814,6 +838,86 @@ struct hid_ll_driver i2c_hid_ll_driver = {
 };
 EXPORT_SYMBOL_GPL(i2c_hid_ll_driver);

+static int get_gpio_pin_state(struct irq_desc *irq_desc)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(&irq_desc->irq_data);
+
+	return gc->get(gc, irq_desc->irq_data.hwirq);
+}
+
+static bool interrupt_line_active(struct i2c_client *client)
+{
+	unsigned long trigger_type = irq_get_trigger_type(client->irq);
+	struct irq_desc *irq_desc = irq_to_desc(client->irq);
+
+	/*
+	 * According to Windows Precsiontion Touchpad's specs
+	 * https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/windows-precision-touchpad-device-bus-connectivity,
+	 * GPIO Interrupt Assertion Leve could be either ActiveLow or
+	 * ActiveHigh.
+	 */
+	if (trigger_type & IRQF_TRIGGER_LOW)
+		return !get_gpio_pin_state(irq_desc);
+
+	return get_gpio_pin_state(irq_desc);
+}
+
+static int i2c_hid_polling_thread(void *i2c_hid)
+{
+	struct i2c_hid *ihid = i2c_hid;
+	struct i2c_client *client = ihid->client;
+	unsigned int polling_interval_idle;
+
+	while (1) {
+		/*
+		 * re-calculate polling_interval_idle
+		 * so the module parameters polling_interval_idle_ms can be
+		 * changed dynamically through sysfs as polling_interval_active_us
+		 */
+		polling_interval_idle = polling_interval_idle_ms * 1000;
+		if (test_bit(I2C_HID_READ_PENDING, &ihid->flags))
+			usleep_range(50000, 100000);
+
+		if (kthread_should_stop())
+			break;
+
+		while (interrupt_line_active(client)) {
+			i2c_hid_get_input(ihid);
+			usleep_range(polling_interval_active_us,
+				     polling_interval_active_us + 100);
+		}
+
+		usleep_range(polling_interval_idle,
+			     polling_interval_idle + 1000);
+	}
+
+	do_exit(0);
+	return 0;
+}
+
+static int i2c_hid_init_polling(struct i2c_hid *ihid)
+{
+	struct i2c_client *client = ihid->client;
+
+	if (!irq_get_trigger_type(client->irq)) {
+		dev_warn(&client->dev,
+			 "Failed to get GPIO Interrupt Assertion Level, could not enable polling mode for %s",
+			 client->name);
+		return -1;
+	}
+
+	ihid->polling_thread = kthread_create(i2c_hid_polling_thread, ihid,
+					      "I2C HID polling thread");
+
+	if (ihid->polling_thread) {
+		pr_info("I2C HID polling thread");
+		wake_up_process(ihid->polling_thread);
+		return 0;
+	}
+
+	return -1;
+}
+
 static int i2c_hid_init_irq(struct i2c_client *client)
 {
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
@@ -997,6 +1101,15 @@ static void i2c_hid_fwnode_probe(struct i2c_client *client,
 		pdata->post_power_delay_ms = val;
 }

+static void free_irq_or_stop_polling(struct i2c_client *client,
+				     struct i2c_hid *ihid)
+{
+	if (polling_mode != I2C_POLLING_DISABLED)
+		kthread_stop(ihid->polling_thread);
+	else
+		free_irq(client->irq, ihid);
+}
+
 static int i2c_hid_probe(struct i2c_client *client,
 			 const struct i2c_device_id *dev_id)
 {
@@ -1090,7 +1203,11 @@ static int i2c_hid_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto err_regulator;

-	ret = i2c_hid_init_irq(client);
+	if (polling_mode != I2C_POLLING_DISABLED)
+		ret = i2c_hid_init_polling(ihid);
+	else
+		ret = i2c_hid_init_irq(client);
+
 	if (ret < 0)
 		goto err_regulator;

@@ -1129,7 +1246,7 @@ static int i2c_hid_probe(struct i2c_client *client,
 	hid_destroy_device(hid);

 err_irq:
-	free_irq(client->irq, ihid);
+	free_irq_or_stop_polling(client, ihid);

 err_regulator:
 	regulator_bulk_disable(ARRAY_SIZE(ihid->pdata.supplies),
@@ -1146,7 +1263,7 @@ static int i2c_hid_remove(struct i2c_client *client)
 	hid = ihid->hid;
 	hid_destroy_device(hid);

-	free_irq(client->irq, ihid);
+	free_irq_or_stop_polling(client, ihid);

 	if (ihid->bufsize)
 		i2c_hid_free_buffers(ihid);
@@ -1162,7 +1279,7 @@ static void i2c_hid_shutdown(struct i2c_client *client)
 	struct i2c_hid *ihid = i2c_get_clientdata(client);

 	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
-	free_irq(client->irq, ihid);
+	free_irq_or_stop_polling(client, ihid);
 }

 #ifdef CONFIG_PM_SLEEP
@@ -1183,15 +1300,16 @@ static int i2c_hid_suspend(struct device *dev)
 	/* Save some power */
 	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);

-	disable_irq(client->irq);
-
-	if (device_may_wakeup(&client->dev)) {
-		wake_status = enable_irq_wake(client->irq);
-		if (!wake_status)
-			ihid->irq_wake_enabled = true;
-		else
-			hid_warn(hid, "Failed to enable irq wake: %d\n",
-				wake_status);
+	if (polling_mode == I2C_POLLING_DISABLED) {
+		disable_irq(client->irq);
+		if (device_may_wakeup(&client->dev)) {
+			wake_status = enable_irq_wake(client->irq);
+			if (!wake_status)
+				ihid->irq_wake_enabled = true;
+			else
+				hid_warn(hid, "Failed to enable irq wake: %d\n",
+					 wake_status);
+		}
 	} else {
 		regulator_bulk_disable(ARRAY_SIZE(ihid->pdata.supplies),
 				       ihid->pdata.supplies);
@@ -1208,7 +1326,7 @@ static int i2c_hid_resume(struct device *dev)
 	struct hid_device *hid = ihid->hid;
 	int wake_status;

-	if (!device_may_wakeup(&client->dev)) {
+	if (!device_may_wakeup(&client->dev) || polling_mode != I2C_POLLING_DISABLED) {
 		ret = regulator_bulk_enable(ARRAY_SIZE(ihid->pdata.supplies),
 					    ihid->pdata.supplies);
 		if (ret)
@@ -1225,7 +1343,8 @@ static int i2c_hid_resume(struct device *dev)
 				wake_status);
 	}

-	enable_irq(client->irq);
+	if (polling_mode == I2C_POLLING_DISABLED)
+		enable_irq(client->irq);

 	/* Instead of resetting device, simply powers the device on. This
 	 * solves "incomplete reports" on Raydium devices 2386:3118 and
--
2.28.0

