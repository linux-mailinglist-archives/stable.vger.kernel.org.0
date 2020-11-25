Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D212C41E1
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 15:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgKYOLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 09:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbgKYOLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 09:11:12 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D281C0613D4;
        Wed, 25 Nov 2020 06:11:00 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id k5so1165137plt.6;
        Wed, 25 Nov 2020 06:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gsCr3Cp4C3hok2q4VVMQ7Utb3j9ypCmO2a0uaLLpB+I=;
        b=AH9eHDcvG9W7CzxkfinqnD7zmouK/uIPFaHNjCgqNAIrhfzCkQ7YW98lcuRonNFxWB
         rmhv8fPOJHBYazjaEfnJvTCR/ioSj0vLKIoS6lGe7uSFzGgaMW0UehVxSKobOBEQ48J/
         hgpk/IpXI9bBO/SK8W+5nLpxZKlRl0PEB+96N14620eNMT1laaPbBfA+U0/UeB0aCvd9
         yKo92NvCh2+OY8NFk+gEv7uLs5V5AEajAZxSyXAy2S3wSjhGv3DmloNqDNiBIBnyoO+N
         6AssB/145g113FoE71+eNNI9x6wste0XHJ/r8R7ZRIj4LXh1F/gXni9Osv03InD+SOGi
         S03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gsCr3Cp4C3hok2q4VVMQ7Utb3j9ypCmO2a0uaLLpB+I=;
        b=aR1sVqU3I86Aw7kXUBVesEz7ZdyhUgq89vZ0hqtKb1pRmo8QK7E0eYR9XhWxXDwCZt
         Z6VUshmYvqSNKW/JhHHhspPOU2KX6luIBFdIl8SxuKffMEnMm1gJPzysY98Z9XkL/Ayr
         gzkPGDkxocFx+Nn4Zqww2FkgSchKzMK1ChEqkETUA493yEnGcQJlv6RBSGzJ7YxEn+ot
         hO4kGizlU6he1YWFlZL/V+4mxw0e8uX86ar4TmaQFiEF4aj339+RX9zy9bw+13Md4T57
         OP3xaEX2GDm3VFY48z/DqKFDFSI+CQ9orhzpd1rHO5h10heioIEQ191ZSBH2IULg1zXT
         Il5Q==
X-Gm-Message-State: AOAM532EB6U1OTj/1s28p9vfWXiaVKxvD26ffg+4In/6PUbwaogtCL7u
        tIofp8/ffDZvjvZxVGrBSIlhvM0iwQyUA2L4
X-Google-Smtp-Source: ABdhPJyaaqqUUYIKqzzJCIMINnG0GeQQ8iCa3qdD+lwOLFcurGYSaUx7v0gbEROSRMC/VEkggU1cnA==
X-Received: by 2002:a17:902:ba8b:b029:d9:d8b9:f2d7 with SMTP id k11-20020a170902ba8bb02900d9d8b9f2d7mr3153771pls.77.1606313458455;
        Wed, 25 Nov 2020 06:10:58 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id v3sm2146869pfn.215.2020.11.25.06.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 06:10:57 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Helmut Stult <helmut.stult@schinfo.de>,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Baq Domalaq <domalak@gmail.com>,
        Pedro Ribeiro <pedrib@gmail.com>, stable@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4] HID: i2c-hid: add polling mode based on connected GPIO chip's pin status
Date:   Wed, 25 Nov 2020 22:10:22 +0800
Message-Id: <20201125141022.321643-1-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For a broken touchpad, it may take several months or longer to be fixed.
Polling mode could be a fallback solution for enthusiastic Linux users
when they have a new laptop. It also acts like a debugging feature. If
polling mode works for a broken touchpad, we can almost be certain
the root cause is related to the interrupt or power setting.

This patch could fix touchpads of Lenovo AMD gaming laptops including
Legion-5 15ARH05 (R7000), Legion-5P (R7000P) and IdeaPad Gaming 3
15ARH05.

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

Note xf86-input-synaptics doesn't work well with this polling mode
for the Synaptics touchpad. The Synaptics touchpad would often locks
into scroll mode when using multitouch gestures [1]. One remedy is to
decrease the polling interval.

Thanks to Barnabás's thorough review of this patch and the useful
feedback!

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190/comments/235

Cc: <stable@vger.kernel.org>
Cc: Barnabás Pőcze <pobrn@protonmail.com>
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1887190
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 152 +++++++++++++++++++++++++++--
 1 file changed, 142 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index aeff1ffb0c8b..f25503f31ccf 100644
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
 
@@ -60,6 +62,25 @@
 #define I2C_HID_PWR_ON		0x00
 #define I2C_HID_PWR_SLEEP	0x01
 
+/* polling mode */
+#define I2C_HID_POLLING_DISABLED 0
+#define I2C_HID_POLLING_GPIO_PIN 1
+#define I2C_HID_POLLING_INTERVAL_ACTIVE_US 4000
+#define I2C_HID_POLLING_INTERVAL_IDLE_MS 10
+
+static u8 polling_mode;
+module_param(polling_mode, byte, 0444);
+MODULE_PARM_DESC(polling_mode, "How to poll (default=0) - 0 disabled; 1 based on GPIO pin's status");
+
+static unsigned int polling_interval_active_us __read_mostly = I2C_HID_POLLING_INTERVAL_ACTIVE_US;
+module_param(polling_interval_active_us, uint, 0644);
+MODULE_PARM_DESC(polling_interval_active_us,
+		 "Poll every {polling_interval_active_us} us when the touchpad is active (default=" __stringify(I2C_HID_POLLING_INTERVAL_ACTIVE_US) " us)");
+
+static unsigned int polling_interval_idle_ms __read_mostly = I2C_HID_POLLING_INTERVAL_IDLE_MS;
+module_param(polling_interval_idle_ms, uint, 0644);
+MODULE_PARM_DESC(polling_interval_idle_ms,
+		 "Poll every {polling_interval_idle_ms} ms when the touchpad is idle (default=" __stringify(I2C_HID_POLLING_INTERVAL_IDLE_MS) "ms)");
 /* debug option */
 static bool debug;
 module_param(debug, bool, 0444);
@@ -158,6 +179,10 @@ struct i2c_hid {
 
 	struct i2c_hid_platform_data pdata;
 
+	struct task_struct *polling_thread;
+	unsigned long irq_trigger_type;
+	struct irq_desc *irq_desc;
+
 	bool			irq_wake_enabled;
 	struct mutex		reset_lock;
 };
@@ -772,7 +797,9 @@ static int i2c_hid_start(struct hid_device *hid)
 		i2c_hid_free_buffers(ihid);
 
 		ret = i2c_hid_alloc_buffers(ihid, bufsize);
-		enable_irq(client->irq);
+
+		if (polling_mode == I2C_HID_POLLING_DISABLED)
+			enable_irq(client->irq);
 
 		if (ret)
 			return ret;
@@ -814,6 +841,96 @@ struct hid_ll_driver i2c_hid_ll_driver = {
 };
 EXPORT_SYMBOL_GPL(i2c_hid_ll_driver);
 
+static int get_gpio_pin_state(struct irq_desc *irq_desc)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(&irq_desc->irq_data);
+	int value;
+
+	/*
+	 * This part of code is borrowed from gpiod_get_raw_value_commit in
+	 * drivers/gpio/gpiolib.c. Ideally, gpiod_get_value_cansleep can be re-used
+	 * instead but there is no API of converting (struct irq_desc *) to
+	 * (struct gpio_desc*).
+	 */
+	value = gc->get ? gc->get(gc, irq_desc->irq_data.hwirq) : -EIO;
+	value = value < 0 ? value : !!value;
+	return value;
+}
+
+static bool interrupt_line_active(struct i2c_hid *ihid)
+{
+	int status = get_gpio_pin_state(ihid->irq_desc);
+	struct i2c_client *client = ihid->client;
+
+	if (status < 0) {
+		dev_dbg_ratelimited(&client->dev,
+				    "Failed to get GPIO Interrupt line status for %s",
+				    client->name);
+		return false;
+	}
+	/*
+	 * According to Windows Precsiontion Touchpad's specs
+	 * https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/windows-precision-touchpad-device-bus-connectivity,
+	 * GPIO Interrupt Assertion Leve could be either ActiveLow or
+	 * ActiveHigh.
+	 */
+	if (ihid->irq_trigger_type & IRQF_TRIGGER_LOW)
+		return !status;
+
+	return status;
+}
+
+static int i2c_hid_polling_thread(void *i2c_hid)
+{
+	struct i2c_hid *ihid = i2c_hid;
+	unsigned int polling_interval_idle;
+
+	while (!kthread_should_stop()) {
+		while (interrupt_line_active(i2c_hid) &&
+		       !test_bit(I2C_HID_READ_PENDING, &ihid->flags) &&
+		       !kthread_should_stop()) {
+			i2c_hid_get_input(ihid);
+			usleep_range(polling_interval_active_us,
+				     polling_interval_active_us + 100);
+		}
+		/*
+		 * re-calculate polling_interval_idle
+		 * so the module parameters polling_interval_idle_ms can be
+		 * changed dynamically through sysfs as polling_interval_active_us
+		 */
+		polling_interval_idle = polling_interval_idle_ms * 1000;
+		usleep_range(polling_interval_idle,
+			     polling_interval_idle + 1000);
+	}
+
+	return 0;
+}
+
+static int i2c_hid_init_polling(struct i2c_hid *ihid)
+{
+	struct i2c_client *client = ihid->client;
+
+	ihid->irq_trigger_type = irq_get_trigger_type(client->irq);
+	if (!ihid->irq_trigger_type) {
+		dev_dbg(&client->dev,
+			"Failed to get GPIO Interrupt Assertion Level, could not enable polling mode for %s",
+			 client->name);
+		return -EINVAL;
+	}
+
+	ihid->polling_thread = kthread_create(i2c_hid_polling_thread, ihid,
+					      "I2C HID polling thread");
+
+	if (IS_ERR(ihid->polling_thread)) {
+		dev_err(&client->dev, "Failed to create I2C HID polling thread");
+		return PTR_ERR(ihid->polling_thread);
+	}
+
+	ihid->irq_desc = irq_to_desc(client->irq);
+	wake_up_process(ihid->polling_thread);
+	return 0;
+}
+
 static int i2c_hid_init_irq(struct i2c_client *client)
 {
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
@@ -1014,6 +1131,15 @@ static void i2c_hid_fwnode_probe(struct i2c_client *client,
 		pdata->post_power_delay_ms = val;
 }
 
+static void free_irq_or_stop_polling(struct i2c_client *client,
+				     struct i2c_hid *ihid)
+{
+	if (polling_mode != I2C_HID_POLLING_DISABLED)
+		kthread_stop(ihid->polling_thread);
+	else
+		free_irq(client->irq, ihid);
+}
+
 static int i2c_hid_probe(struct i2c_client *client,
 			 const struct i2c_device_id *dev_id)
 {
@@ -1109,7 +1235,11 @@ static int i2c_hid_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto err_regulator;
 
-	ret = i2c_hid_init_irq(client);
+	if (polling_mode != I2C_HID_POLLING_DISABLED)
+		ret = i2c_hid_init_polling(ihid);
+	else
+		ret = i2c_hid_init_irq(client);
+
 	if (ret < 0)
 		goto err_regulator;
 
@@ -1148,7 +1278,7 @@ static int i2c_hid_probe(struct i2c_client *client,
 	hid_destroy_device(hid);
 
 err_irq:
-	free_irq(client->irq, ihid);
+	free_irq_or_stop_polling(client, ihid);
 
 err_regulator:
 	regulator_bulk_disable(ARRAY_SIZE(ihid->pdata.supplies),
@@ -1165,7 +1295,7 @@ static int i2c_hid_remove(struct i2c_client *client)
 	hid = ihid->hid;
 	hid_destroy_device(hid);
 
-	free_irq(client->irq, ihid);
+	free_irq_or_stop_polling(client, ihid);
 
 	if (ihid->bufsize)
 		i2c_hid_free_buffers(ihid);
@@ -1181,7 +1311,7 @@ static void i2c_hid_shutdown(struct i2c_client *client)
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
 
 	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
-	free_irq(client->irq, ihid);
+	free_irq_or_stop_polling(client, ihid);
 
 	i2c_hid_acpi_shutdown(&client->dev);
 }
@@ -1204,15 +1334,16 @@ static int i2c_hid_suspend(struct device *dev)
 	/* Save some power */
 	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
 
-	disable_irq(client->irq);
+	if (polling_mode == I2C_HID_POLLING_DISABLED)
+		disable_irq(client->irq);
 
-	if (device_may_wakeup(&client->dev)) {
+	if (device_may_wakeup(&client->dev) && polling_mode == I2C_HID_POLLING_DISABLED) {
 		wake_status = enable_irq_wake(client->irq);
 		if (!wake_status)
 			ihid->irq_wake_enabled = true;
 		else
 			hid_warn(hid, "Failed to enable irq wake: %d\n",
-				wake_status);
+				 wake_status);
 	} else {
 		regulator_bulk_disable(ARRAY_SIZE(ihid->pdata.supplies),
 				       ihid->pdata.supplies);
@@ -1229,7 +1360,7 @@ static int i2c_hid_resume(struct device *dev)
 	struct hid_device *hid = ihid->hid;
 	int wake_status;
 
-	if (!device_may_wakeup(&client->dev)) {
+	if (!device_may_wakeup(&client->dev) || polling_mode != I2C_HID_POLLING_DISABLED) {
 		ret = regulator_bulk_enable(ARRAY_SIZE(ihid->pdata.supplies),
 					    ihid->pdata.supplies);
 		if (ret)
@@ -1246,7 +1377,8 @@ static int i2c_hid_resume(struct device *dev)
 				wake_status);
 	}
 
-	enable_irq(client->irq);
+	if (polling_mode == I2C_HID_POLLING_DISABLED)
+		enable_irq(client->irq);
 
 	/* Instead of resetting device, simply powers the device on. This
 	 * solves "incomplete reports" on Raydium devices 2386:3118 and
-- 
2.29.2

