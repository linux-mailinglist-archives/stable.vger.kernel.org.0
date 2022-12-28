Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C542657F26
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiL1QCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbiL1QB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:01:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D531903C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:01:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08C7AB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DA6C433D2;
        Wed, 28 Dec 2022 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243297;
        bh=Jv9wMGkUwXiKR3PpljhzxnPOPwVv9XQlVbd8Dkysqs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hG/AohpzRTisivI+ZveZFdow9eUIIkUGPaegnKNDWmPT9byOIfyuS2OLycDnn9Zse
         qTaL0sXMOC7F1LKgLBR4a+tvWpaf9FZimZUN4roirFgsIEwc1EDCXu5eFAPWWbNTSV
         KSkH/W6srZJLl22+ZtSHOgrlnuV+wCb1YTvTo2jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0477/1146] hwmon: (jc42) Convert register access and caching to regmap/regcache
Date:   Wed, 28 Dec 2022 15:33:36 +0100
Message-Id: <20221228144343.139545225@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 8f2fa4726faf01094d7a5be7bd0c120c565f54d9 ]

Switch the jc42 driver to use an I2C regmap to access the registers.
Also move over to regmap's built-in caching instead of adding a
custom caching implementation. This works for JC42_REG_TEMP_UPPER,
JC42_REG_TEMP_LOWER and JC42_REG_TEMP_CRITICAL as these values never
change except when explicitly written. The cache For JC42_REG_TEMP is
dropped (regmap can't cache it because it's volatile, meaning it can
change at any time) as well for simplicity and consistency with other
drivers.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20221023213157.11078-2-martin.blumenstingl@googlemail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 084ed144c448 ("hwmon: (jc42) Restore the min/max/critical temperatures on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig |   1 +
 drivers/hwmon/jc42.c  | 233 ++++++++++++++++++++++++------------------
 2 files changed, 132 insertions(+), 102 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 7ac3daaf59ce..d3bccc8176c5 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -799,6 +799,7 @@ config SENSORS_IT87
 config SENSORS_JC42
 	tristate "JEDEC JC42.4 compliant memory module temperature sensors"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here, you get support for JEDEC JC42.4 compliant
 	  temperature sensors, which are used on many DDR3 memory modules for
diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 30888feaf589..355639d208d0 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -19,6 +19,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/regmap.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = {
@@ -199,31 +200,14 @@ static struct jc42_chips jc42_chips[] = {
 	{ STM_MANID, STTS3000_DEVID, STTS3000_DEVID_MASK },
 };
 
-enum temp_index {
-	t_input = 0,
-	t_crit,
-	t_min,
-	t_max,
-	t_num_temp
-};
-
-static const u8 temp_regs[t_num_temp] = {
-	[t_input] = JC42_REG_TEMP,
-	[t_crit] = JC42_REG_TEMP_CRITICAL,
-	[t_min] = JC42_REG_TEMP_LOWER,
-	[t_max] = JC42_REG_TEMP_UPPER,
-};
-
 /* Each client has this additional data */
 struct jc42_data {
-	struct i2c_client *client;
 	struct mutex	update_lock;	/* protect register access */
+	struct regmap	*regmap;
 	bool		extended;	/* true if extended range supported */
 	bool		valid;
-	unsigned long	last_updated;	/* In jiffies */
 	u16		orig_config;	/* original configuration */
 	u16		config;		/* current configuration */
-	u16		temp[t_num_temp];/* Temperatures */
 };
 
 #define JC42_TEMP_MIN_EXTENDED	(-40000)
@@ -248,85 +232,102 @@ static int jc42_temp_from_reg(s16 reg)
 	return reg * 125 / 2;
 }
 
-static struct jc42_data *jc42_update_device(struct device *dev)
-{
-	struct jc42_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
-	struct jc42_data *ret = data;
-	int i, val;
-
-	mutex_lock(&data->update_lock);
-
-	if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
-		for (i = 0; i < t_num_temp; i++) {
-			val = i2c_smbus_read_word_swapped(client, temp_regs[i]);
-			if (val < 0) {
-				ret = ERR_PTR(val);
-				goto abort;
-			}
-			data->temp[i] = val;
-		}
-		data->last_updated = jiffies;
-		data->valid = true;
-	}
-abort:
-	mutex_unlock(&data->update_lock);
-	return ret;
-}
-
 static int jc42_read(struct device *dev, enum hwmon_sensor_types type,
 		     u32 attr, int channel, long *val)
 {
-	struct jc42_data *data = jc42_update_device(dev);
-	int temp, hyst;
+	struct jc42_data *data = dev_get_drvdata(dev);
+	unsigned int regval;
+	int ret, temp, hyst;
 
-	if (IS_ERR(data))
-		return PTR_ERR(data);
+	mutex_lock(&data->update_lock);
 
 	switch (attr) {
 	case hwmon_temp_input:
-		*val = jc42_temp_from_reg(data->temp[t_input]);
-		return 0;
+		ret = regmap_read(data->regmap, JC42_REG_TEMP, &regval);
+		if (ret)
+			break;
+
+		*val = jc42_temp_from_reg(regval);
+		break;
 	case hwmon_temp_min:
-		*val = jc42_temp_from_reg(data->temp[t_min]);
-		return 0;
+		ret = regmap_read(data->regmap, JC42_REG_TEMP_LOWER, &regval);
+		if (ret)
+			break;
+
+		*val = jc42_temp_from_reg(regval);
+		break;
 	case hwmon_temp_max:
-		*val = jc42_temp_from_reg(data->temp[t_max]);
-		return 0;
+		ret = regmap_read(data->regmap, JC42_REG_TEMP_UPPER, &regval);
+		if (ret)
+			break;
+
+		*val = jc42_temp_from_reg(regval);
+		break;
 	case hwmon_temp_crit:
-		*val = jc42_temp_from_reg(data->temp[t_crit]);
-		return 0;
+		ret = regmap_read(data->regmap, JC42_REG_TEMP_CRITICAL,
+				  &regval);
+		if (ret)
+			break;
+
+		*val = jc42_temp_from_reg(regval);
+		break;
 	case hwmon_temp_max_hyst:
-		temp = jc42_temp_from_reg(data->temp[t_max]);
+		ret = regmap_read(data->regmap, JC42_REG_TEMP_UPPER, &regval);
+		if (ret)
+			break;
+
+		temp = jc42_temp_from_reg(regval);
 		hyst = jc42_hysteresis[(data->config & JC42_CFG_HYST_MASK)
 						>> JC42_CFG_HYST_SHIFT];
 		*val = temp - hyst;
-		return 0;
+		break;
 	case hwmon_temp_crit_hyst:
-		temp = jc42_temp_from_reg(data->temp[t_crit]);
+		ret = regmap_read(data->regmap, JC42_REG_TEMP_CRITICAL,
+				  &regval);
+		if (ret)
+			break;
+
+		temp = jc42_temp_from_reg(regval);
 		hyst = jc42_hysteresis[(data->config & JC42_CFG_HYST_MASK)
 						>> JC42_CFG_HYST_SHIFT];
 		*val = temp - hyst;
-		return 0;
+		break;
 	case hwmon_temp_min_alarm:
-		*val = (data->temp[t_input] >> JC42_ALARM_MIN_BIT) & 1;
-		return 0;
+		ret = regmap_read(data->regmap, JC42_REG_TEMP, &regval);
+		if (ret)
+			break;
+
+		*val = (regval >> JC42_ALARM_MIN_BIT) & 1;
+		break;
 	case hwmon_temp_max_alarm:
-		*val = (data->temp[t_input] >> JC42_ALARM_MAX_BIT) & 1;
-		return 0;
+		ret = regmap_read(data->regmap, JC42_REG_TEMP, &regval);
+		if (ret)
+			break;
+
+		*val = (regval >> JC42_ALARM_MAX_BIT) & 1;
+		break;
 	case hwmon_temp_crit_alarm:
-		*val = (data->temp[t_input] >> JC42_ALARM_CRIT_BIT) & 1;
-		return 0;
+		ret = regmap_read(data->regmap, JC42_REG_TEMP, &regval);
+		if (ret)
+			break;
+
+		*val = (regval >> JC42_ALARM_CRIT_BIT) & 1;
+		break;
 	default:
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		break;
 	}
+
+	mutex_unlock(&data->update_lock);
+
+	return ret;
 }
 
 static int jc42_write(struct device *dev, enum hwmon_sensor_types type,
 		      u32 attr, int channel, long val)
 {
 	struct jc42_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
+	unsigned int regval;
 	int diff, hyst;
 	int ret;
 
@@ -334,21 +335,23 @@ static int jc42_write(struct device *dev, enum hwmon_sensor_types type,
 
 	switch (attr) {
 	case hwmon_temp_min:
-		data->temp[t_min] = jc42_temp_to_reg(val, data->extended);
-		ret = i2c_smbus_write_word_swapped(client, temp_regs[t_min],
-						   data->temp[t_min]);
+		ret = regmap_write(data->regmap, JC42_REG_TEMP_LOWER,
+				   jc42_temp_to_reg(val, data->extended));
 		break;
 	case hwmon_temp_max:
-		data->temp[t_max] = jc42_temp_to_reg(val, data->extended);
-		ret = i2c_smbus_write_word_swapped(client, temp_regs[t_max],
-						   data->temp[t_max]);
+		ret = regmap_write(data->regmap, JC42_REG_TEMP_UPPER,
+				   jc42_temp_to_reg(val, data->extended));
 		break;
 	case hwmon_temp_crit:
-		data->temp[t_crit] = jc42_temp_to_reg(val, data->extended);
-		ret = i2c_smbus_write_word_swapped(client, temp_regs[t_crit],
-						   data->temp[t_crit]);
+		ret = regmap_write(data->regmap, JC42_REG_TEMP_CRITICAL,
+				   jc42_temp_to_reg(val, data->extended));
 		break;
 	case hwmon_temp_crit_hyst:
+		ret = regmap_read(data->regmap, JC42_REG_TEMP_CRITICAL,
+				  &regval);
+		if (ret)
+			return ret;
+
 		/*
 		 * JC42.4 compliant chips only support four hysteresis values.
 		 * Pick best choice and go from there.
@@ -356,7 +359,7 @@ static int jc42_write(struct device *dev, enum hwmon_sensor_types type,
 		val = clamp_val(val, (data->extended ? JC42_TEMP_MIN_EXTENDED
 						     : JC42_TEMP_MIN) - 6000,
 				JC42_TEMP_MAX);
-		diff = jc42_temp_from_reg(data->temp[t_crit]) - val;
+		diff = jc42_temp_from_reg(regval) - val;
 		hyst = 0;
 		if (diff > 0) {
 			if (diff < 2250)
@@ -368,9 +371,8 @@ static int jc42_write(struct device *dev, enum hwmon_sensor_types type,
 		}
 		data->config = (data->config & ~JC42_CFG_HYST_MASK) |
 				(hyst << JC42_CFG_HYST_SHIFT);
-		ret = i2c_smbus_write_word_swapped(data->client,
-						   JC42_REG_CONFIG,
-						   data->config);
+		ret = regmap_write(data->regmap, JC42_REG_CONFIG,
+				   data->config);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
@@ -470,51 +472,80 @@ static const struct hwmon_chip_info jc42_chip_info = {
 	.info = jc42_info,
 };
 
+static bool jc42_readable_reg(struct device *dev, unsigned int reg)
+{
+	return (reg >= JC42_REG_CAP && reg <= JC42_REG_DEVICEID) ||
+		reg == JC42_REG_SMBUS;
+}
+
+static bool jc42_writable_reg(struct device *dev, unsigned int reg)
+{
+	return (reg >= JC42_REG_CONFIG && reg <= JC42_REG_TEMP_CRITICAL) ||
+		reg == JC42_REG_SMBUS;
+}
+
+static bool jc42_volatile_reg(struct device *dev, unsigned int reg)
+{
+	return reg == JC42_REG_CONFIG || reg == JC42_REG_TEMP;
+}
+
+static const struct regmap_config jc42_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 16,
+	.val_format_endian = REGMAP_ENDIAN_BIG,
+	.max_register = JC42_REG_SMBUS,
+	.writeable_reg = jc42_writable_reg,
+	.readable_reg = jc42_readable_reg,
+	.volatile_reg = jc42_volatile_reg,
+	.cache_type = REGCACHE_RBTREE,
+};
+
 static int jc42_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct device *hwmon_dev;
+	unsigned int config, cap;
 	struct jc42_data *data;
-	int config, cap;
+	int ret;
 
 	data = devm_kzalloc(dev, sizeof(struct jc42_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->client = client;
+	data->regmap = devm_regmap_init_i2c(client, &jc42_regmap_config);
+	if (IS_ERR(data->regmap))
+		return PTR_ERR(data->regmap);
+
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->update_lock);
 
-	cap = i2c_smbus_read_word_swapped(client, JC42_REG_CAP);
-	if (cap < 0)
-		return cap;
+	ret = regmap_read(data->regmap, JC42_REG_CAP, &cap);
+	if (ret)
+		return ret;
 
 	data->extended = !!(cap & JC42_CAP_RANGE);
 
 	if (device_property_read_bool(dev, "smbus-timeout-disable")) {
-		int smbus;
-
 		/*
 		 * Not all chips support this register, but from a
 		 * quick read of various datasheets no chip appears
 		 * incompatible with the below attempt to disable
 		 * the timeout. And the whole thing is opt-in...
 		 */
-		smbus = i2c_smbus_read_word_swapped(client, JC42_REG_SMBUS);
-		if (smbus < 0)
-			return smbus;
-		i2c_smbus_write_word_swapped(client, JC42_REG_SMBUS,
-					     smbus | SMBUS_STMOUT);
+		ret = regmap_set_bits(data->regmap, JC42_REG_SMBUS,
+				      SMBUS_STMOUT);
+		if (ret)
+			return ret;
 	}
 
-	config = i2c_smbus_read_word_swapped(client, JC42_REG_CONFIG);
-	if (config < 0)
-		return config;
+	ret = regmap_read(data->regmap, JC42_REG_CONFIG, &config);
+	if (ret)
+		return ret;
 
 	data->orig_config = config;
 	if (config & JC42_CFG_SHUTDOWN) {
 		config &= ~JC42_CFG_SHUTDOWN;
-		i2c_smbus_write_word_swapped(client, JC42_REG_CONFIG, config);
+		regmap_write(data->regmap, JC42_REG_CONFIG, config);
 	}
 	data->config = config;
 
@@ -535,7 +566,7 @@ static void jc42_remove(struct i2c_client *client)
 
 		config = (data->orig_config & ~JC42_CFG_HYST_MASK)
 		  | (data->config & JC42_CFG_HYST_MASK);
-		i2c_smbus_write_word_swapped(client, JC42_REG_CONFIG, config);
+		regmap_write(data->regmap, JC42_REG_CONFIG, config);
 	}
 }
 
@@ -546,8 +577,7 @@ static int jc42_suspend(struct device *dev)
 	struct jc42_data *data = dev_get_drvdata(dev);
 
 	data->config |= JC42_CFG_SHUTDOWN;
-	i2c_smbus_write_word_swapped(data->client, JC42_REG_CONFIG,
-				     data->config);
+	regmap_write(data->regmap, JC42_REG_CONFIG, data->config);
 	return 0;
 }
 
@@ -556,8 +586,7 @@ static int jc42_resume(struct device *dev)
 	struct jc42_data *data = dev_get_drvdata(dev);
 
 	data->config &= ~JC42_CFG_SHUTDOWN;
-	i2c_smbus_write_word_swapped(data->client, JC42_REG_CONFIG,
-				     data->config);
+	regmap_write(data->regmap, JC42_REG_CONFIG, data->config);
 	return 0;
 }
 
-- 
2.35.1



