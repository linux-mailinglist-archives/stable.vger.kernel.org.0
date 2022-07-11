Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA18456FC2A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiGKJkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiGKJji (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:39:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3768AEF8;
        Mon, 11 Jul 2022 02:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A8A612A0;
        Mon, 11 Jul 2022 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6314CC34115;
        Mon, 11 Jul 2022 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531219;
        bh=xg0CrHl7GlZrxDRdsAtEDs9u9TY5OWj2ONOEpuzc1A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0TzSY+zLy0gw4G+3DmQbGihMA9/SEU2dmhr0b9Y++Jc5ZqiyD8wMLPdyaGZHSRLJ
         AAvtVOFug2vjDYo5xnn0xitlv7rk6XAeXtCO1+oiQr8atVVVDS4dmXCiY3Dz/PI21V
         9N75u7oAmxrJmS4LG2w0RwDyRIKR/fD+IkXCVMBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/230] Input: goodix - add a goodix.h header file
Date:   Mon, 11 Jul 2022 11:04:42 +0200
Message-Id: <20220711090604.819190707@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a2233cb7b65a017067e2f2703375ecc930a0ab30 ]

Add a goodix.h header file, and move the register definitions,
and struct declarations there and add prototypes for various
helper functions.

This is a preparation patch for adding support for controllers
without flash, which need to have their firmware uploaded and
need some other special handling too.

Since MAINTAINERS needs updating because of this change anyways,
also add myself as co-maintainer.

Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210920150643.155872-3-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                        |  3 +-
 drivers/input/touchscreen/goodix.c | 74 +++---------------------------
 drivers/input/touchscreen/goodix.h | 73 +++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 69 deletions(-)
 create mode 100644 drivers/input/touchscreen/goodix.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a60d7e0466af..edc32575828b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7952,9 +7952,10 @@ F:	drivers/media/usb/go7007/
 
 GOODIX TOUCHSCREEN
 M:	Bastien Nocera <hadess@hadess.net>
+M:	Hans de Goede <hdegoede@redhat.com>
 L:	linux-input@vger.kernel.org
 S:	Maintained
-F:	drivers/input/touchscreen/goodix.c
+F:	drivers/input/touchscreen/goodix*
 
 GOOGLE ETHERNET DRIVERS
 M:	Jeroen de Borst <jeroendb@google.com>
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index 1eb776abe562..5ccdd6abd868 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -14,20 +14,15 @@
 #include <linux/kernel.h>
 #include <linux/dmi.h>
 #include <linux/firmware.h>
-#include <linux/gpio/consumer.h>
-#include <linux/i2c.h>
-#include <linux/input.h>
-#include <linux/input/mt.h>
-#include <linux/input/touchscreen.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <asm/unaligned.h>
+#include "goodix.h"
 
 #define GOODIX_GPIO_INT_NAME		"irq"
 #define GOODIX_GPIO_RST_NAME		"reset"
@@ -38,22 +33,11 @@
 #define GOODIX_CONTACT_SIZE		8
 #define GOODIX_MAX_CONTACT_SIZE		9
 #define GOODIX_MAX_CONTACTS		10
-#define GOODIX_MAX_KEYS			7
 
 #define GOODIX_CONFIG_MIN_LENGTH	186
 #define GOODIX_CONFIG_911_LENGTH	186
 #define GOODIX_CONFIG_967_LENGTH	228
 #define GOODIX_CONFIG_GT9X_LENGTH	240
-#define GOODIX_CONFIG_MAX_LENGTH	240
-
-/* Register defines */
-#define GOODIX_REG_COMMAND		0x8040
-#define GOODIX_CMD_SCREEN_OFF		0x05
-
-#define GOODIX_READ_COOR_ADDR		0x814E
-#define GOODIX_GT1X_REG_CONFIG_DATA	0x8050
-#define GOODIX_GT9X_REG_CONFIG_DATA	0x8047
-#define GOODIX_REG_ID			0x8140
 
 #define GOODIX_BUFFER_STATUS_READY	BIT(7)
 #define GOODIX_HAVE_KEY			BIT(4)
@@ -68,55 +52,11 @@
 #define ACPI_GPIO_SUPPORT
 #endif
 
-struct goodix_ts_data;
-
-enum goodix_irq_pin_access_method {
-	IRQ_PIN_ACCESS_NONE,
-	IRQ_PIN_ACCESS_GPIO,
-	IRQ_PIN_ACCESS_ACPI_GPIO,
-	IRQ_PIN_ACCESS_ACPI_METHOD,
-};
-
-struct goodix_chip_data {
-	u16 config_addr;
-	int config_len;
-	int (*check_config)(struct goodix_ts_data *ts, const u8 *cfg, int len);
-	void (*calc_config_checksum)(struct goodix_ts_data *ts);
-};
-
 struct goodix_chip_id {
 	const char *id;
 	const struct goodix_chip_data *data;
 };
 
-#define GOODIX_ID_MAX_LEN	4
-
-struct goodix_ts_data {
-	struct i2c_client *client;
-	struct input_dev *input_dev;
-	const struct goodix_chip_data *chip;
-	struct touchscreen_properties prop;
-	unsigned int max_touch_num;
-	unsigned int int_trigger_type;
-	struct regulator *avdd28;
-	struct regulator *vddio;
-	struct gpio_desc *gpiod_int;
-	struct gpio_desc *gpiod_rst;
-	int gpio_count;
-	int gpio_int_idx;
-	char id[GOODIX_ID_MAX_LEN + 1];
-	u16 version;
-	const char *cfg_name;
-	bool reset_controller_at_probe;
-	bool load_cfg_from_disk;
-	struct completion firmware_loading_complete;
-	unsigned long irq_flags;
-	enum goodix_irq_pin_access_method irq_pin_access_method;
-	unsigned int contact_size;
-	u8 config[GOODIX_CONFIG_MAX_LENGTH];
-	unsigned short keymap[GOODIX_MAX_KEYS];
-};
-
 static int goodix_check_cfg_8(struct goodix_ts_data *ts,
 			      const u8 *cfg, int len);
 static int goodix_check_cfg_16(struct goodix_ts_data *ts,
@@ -216,8 +156,7 @@ static const struct dmi_system_id inverted_x_screen[] = {
  * @buf: raw write data buffer.
  * @len: length of the buffer to write
  */
-static int goodix_i2c_read(struct i2c_client *client,
-			   u16 reg, u8 *buf, int len)
+int goodix_i2c_read(struct i2c_client *client, u16 reg, u8 *buf, int len)
 {
 	struct i2c_msg msgs[2];
 	__be16 wbuf = cpu_to_be16(reg);
@@ -245,8 +184,7 @@ static int goodix_i2c_read(struct i2c_client *client,
  * @buf: raw data buffer to write.
  * @len: length of the buffer to write
  */
-static int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf,
-			    int len)
+int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf, int len)
 {
 	u8 *addr_buf;
 	struct i2c_msg msg;
@@ -270,7 +208,7 @@ static int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf,
 	return ret < 0 ? ret : (ret != 1 ? -EIO : 0);
 }
 
-static int goodix_i2c_write_u8(struct i2c_client *client, u16 reg, u8 value)
+int goodix_i2c_write_u8(struct i2c_client *client, u16 reg, u8 value)
 {
 	return goodix_i2c_write(client, reg, &value, sizeof(value));
 }
@@ -554,7 +492,7 @@ static int goodix_check_cfg(struct goodix_ts_data *ts, const u8 *cfg, int len)
  * @cfg: config firmware to write to device
  * @len: config data length
  */
-static int goodix_send_cfg(struct goodix_ts_data *ts, const u8 *cfg, int len)
+int goodix_send_cfg(struct goodix_ts_data *ts, const u8 *cfg, int len)
 {
 	int error;
 
@@ -652,7 +590,7 @@ static int goodix_irq_direction_input(struct goodix_ts_data *ts)
 	return -EINVAL; /* Never reached */
 }
 
-static int goodix_int_sync(struct goodix_ts_data *ts)
+int goodix_int_sync(struct goodix_ts_data *ts)
 {
 	int error;
 
diff --git a/drivers/input/touchscreen/goodix.h b/drivers/input/touchscreen/goodix.h
new file mode 100644
index 000000000000..cdaced4f2980
--- /dev/null
+++ b/drivers/input/touchscreen/goodix.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __GOODIX_H__
+#define __GOODIX_H__
+
+#include <linux/gpio/consumer.h>
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/input/mt.h>
+#include <linux/input/touchscreen.h>
+#include <linux/regulator/consumer.h>
+
+/* Register defines */
+#define GOODIX_REG_COMMAND			0x8040
+#define GOODIX_CMD_SCREEN_OFF			0x05
+
+#define GOODIX_GT1X_REG_CONFIG_DATA		0x8050
+#define GOODIX_GT9X_REG_CONFIG_DATA		0x8047
+#define GOODIX_REG_ID				0x8140
+#define GOODIX_READ_COOR_ADDR			0x814E
+
+#define GOODIX_ID_MAX_LEN			4
+#define GOODIX_CONFIG_MAX_LENGTH		240
+#define GOODIX_MAX_KEYS				7
+
+enum goodix_irq_pin_access_method {
+	IRQ_PIN_ACCESS_NONE,
+	IRQ_PIN_ACCESS_GPIO,
+	IRQ_PIN_ACCESS_ACPI_GPIO,
+	IRQ_PIN_ACCESS_ACPI_METHOD,
+};
+
+struct goodix_ts_data;
+
+struct goodix_chip_data {
+	u16 config_addr;
+	int config_len;
+	int (*check_config)(struct goodix_ts_data *ts, const u8 *cfg, int len);
+	void (*calc_config_checksum)(struct goodix_ts_data *ts);
+};
+
+struct goodix_ts_data {
+	struct i2c_client *client;
+	struct input_dev *input_dev;
+	const struct goodix_chip_data *chip;
+	struct touchscreen_properties prop;
+	unsigned int max_touch_num;
+	unsigned int int_trigger_type;
+	struct regulator *avdd28;
+	struct regulator *vddio;
+	struct gpio_desc *gpiod_int;
+	struct gpio_desc *gpiod_rst;
+	int gpio_count;
+	int gpio_int_idx;
+	char id[GOODIX_ID_MAX_LEN + 1];
+	u16 version;
+	const char *cfg_name;
+	bool reset_controller_at_probe;
+	bool load_cfg_from_disk;
+	struct completion firmware_loading_complete;
+	unsigned long irq_flags;
+	enum goodix_irq_pin_access_method irq_pin_access_method;
+	unsigned int contact_size;
+	u8 config[GOODIX_CONFIG_MAX_LENGTH];
+	unsigned short keymap[GOODIX_MAX_KEYS];
+};
+
+int goodix_i2c_read(struct i2c_client *client, u16 reg, u8 *buf, int len);
+int goodix_i2c_write(struct i2c_client *client, u16 reg, const u8 *buf, int len);
+int goodix_i2c_write_u8(struct i2c_client *client, u16 reg, u8 value);
+int goodix_send_cfg(struct goodix_ts_data *ts, const u8 *cfg, int len);
+int goodix_int_sync(struct goodix_ts_data *ts);
+
+#endif
-- 
2.35.1



