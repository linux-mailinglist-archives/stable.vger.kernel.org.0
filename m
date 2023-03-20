Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACED46C1925
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjCTPbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbjCTPan (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:30:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E8738B77
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDE77615A9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F07C433D2;
        Mon, 20 Mar 2023 15:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325792;
        bh=Ed3pU383HVMS7+m2FVX1Tx39zViPKwp/B/wTTwKwH/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJ1g/QhNjeFDZyo37wldCK9dYuMVMJFRkTT39TNj3nRo2kW6Sl8CfX8oQ/vrcaSbq
         Pf+c63k6kX5tMjfcOnE7Eu15xNjp23A2v6ZR3bFWI+FKVhuAPHISFK4nDHee+p1l+W
         W6Mueyv33s3p7c6yErkpPK+lbJ7Cn3q2dGvpqeIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 102/211] hwmon: (ucd90320) Add minimum delay between bus accesses
Date:   Mon, 20 Mar 2023 15:53:57 +0100
Message-Id: <20230320145517.556592924@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit 8d655e65237643c48ada2c131b83679bf1105373 ]

When probing the ucd90320 access to some of the registers randomly fails.
Sometimes it NACKs a transfer, sometimes it returns just random data and
the PEC check fails.

Experimentation shows that this seems to be triggered by a register access
directly back to back with a previous register write. Experimentation also
shows that inserting a small delay after register writes makes the issue go
away.

Use a similar solution to what the max15301 driver does to solve the same
problem. Create a custom set of bus read and write functions that make sure
that the delay is added.

Fixes: a470f11c5ba2 ("hwmon: (pmbus/ucd9000) Add support for UCD90320 Power Sequencer")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20230312160312.2227405-1-lars@metafoo.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/ucd9000.c | 75 +++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
index 75fc770c9e403..3daaf22378322 100644
--- a/drivers/hwmon/pmbus/ucd9000.c
+++ b/drivers/hwmon/pmbus/ucd9000.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/debugfs.h>
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
@@ -16,6 +17,7 @@
 #include <linux/i2c.h>
 #include <linux/pmbus.h>
 #include <linux/gpio/driver.h>
+#include <linux/timekeeping.h>
 #include "pmbus.h"
 
 enum chips { ucd9000, ucd90120, ucd90124, ucd90160, ucd90320, ucd9090,
@@ -65,6 +67,7 @@ struct ucd9000_data {
 	struct gpio_chip gpio;
 #endif
 	struct dentry *debugfs;
+	ktime_t write_time;
 };
 #define to_ucd9000_data(_info) container_of(_info, struct ucd9000_data, info)
 
@@ -73,6 +76,73 @@ struct ucd9000_debugfs_entry {
 	u8 index;
 };
 
+/*
+ * It has been observed that the UCD90320 randomly fails register access when
+ * doing another access right on the back of a register write. To mitigate this
+ * make sure that there is a minimum delay between a write access and the
+ * following access. The 250us is based on experimental data. At a delay of
+ * 200us the issue seems to go away. Add a bit of extra margin to allow for
+ * system to system differences.
+ */
+#define UCD90320_WAIT_DELAY_US 250
+
+static inline void ucd90320_wait(const struct ucd9000_data *data)
+{
+	s64 delta = ktime_us_delta(ktime_get(), data->write_time);
+
+	if (delta < UCD90320_WAIT_DELAY_US)
+		udelay(UCD90320_WAIT_DELAY_US - delta);
+}
+
+static int ucd90320_read_word_data(struct i2c_client *client, int page,
+				   int phase, int reg)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+
+	if (reg >= PMBUS_VIRT_BASE)
+		return -ENXIO;
+
+	ucd90320_wait(data);
+	return pmbus_read_word_data(client, page, phase, reg);
+}
+
+static int ucd90320_read_byte_data(struct i2c_client *client, int page, int reg)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+
+	ucd90320_wait(data);
+	return pmbus_read_byte_data(client, page, reg);
+}
+
+static int ucd90320_write_word_data(struct i2c_client *client, int page,
+				    int reg, u16 word)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+	int ret;
+
+	ucd90320_wait(data);
+	ret = pmbus_write_word_data(client, page, reg, word);
+	data->write_time = ktime_get();
+
+	return ret;
+}
+
+static int ucd90320_write_byte(struct i2c_client *client, int page, u8 value)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+	int ret;
+
+	ucd90320_wait(data);
+	ret = pmbus_write_byte(client, page, value);
+	data->write_time = ktime_get();
+
+	return ret;
+}
+
 static int ucd9000_get_fan_config(struct i2c_client *client, int fan)
 {
 	int fan_config = 0;
@@ -598,6 +668,11 @@ static int ucd9000_probe(struct i2c_client *client)
 		info->read_byte_data = ucd9000_read_byte_data;
 		info->func[0] |= PMBUS_HAVE_FAN12 | PMBUS_HAVE_STATUS_FAN12
 		  | PMBUS_HAVE_FAN34 | PMBUS_HAVE_STATUS_FAN34;
+	} else if (mid->driver_data == ucd90320) {
+		info->read_byte_data = ucd90320_read_byte_data;
+		info->read_word_data = ucd90320_read_word_data;
+		info->write_byte = ucd90320_write_byte;
+		info->write_word_data = ucd90320_write_word_data;
 	}
 
 	ucd9000_probe_gpio(client, mid, data);
-- 
2.39.2



