Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3ECC47FFBF
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbhL0PlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238677AbhL0PjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:39:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1217C07E5EB;
        Mon, 27 Dec 2021 07:37:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51AC8610A5;
        Mon, 27 Dec 2021 15:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B627C36AF9;
        Mon, 27 Dec 2021 15:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619468;
        bh=5jjV2tqpH2LNmY1mKjvSx8G9Dg1QUZh7Xuprz6j5A0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ac/sp0P6BrX4hl7FdF7gl7goFD7b5Y+XqtPpqBLkwNaH4le01Y9cAZlsoow8bRoKg
         frO1OKhlXFHArOT/f5cPzGXGyLj0TIknl0qP2c62KdvM+H/kYQtea4NRarxS7Ke1BH
         MDbbFcNyfGSE/ZE59Swt5qWaOGzM6YiOJtglaJJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Lehan <krellan@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/76] hwmon: (lm90) Drop critical attribute support for MAX6654
Date:   Mon, 27 Dec 2021 16:30:48 +0100
Message-Id: <20211227151325.845412021@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 16ba51b5dcd3f6dde2e51d5ccc86313119dcf889 ]

Tests with a real chip and a closer look into the datasheet show that
MAX6654 does not support CRIT/THERM/OVERTEMP limits, so drop support
of the respective attributes for this chip.

Introduce LM90_HAVE_CRIT flag and use it to instantiate critical limit
attributes to solve the problem.

Cc: Josh Lehan <krellan@google.com>
Fixes: 229d495d8189 ("hwmon: (lm90) Add max6654 support to lm90 driver")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 86 +++++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 37 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 2961e992faa85..97e0332f46790 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -35,13 +35,14 @@
  * explicitly as max6659, or if its address is not 0x4c.
  * These chips lack the remote temperature offset feature.
  *
- * This driver also supports the MAX6654 chip made by Maxim. This chip can
- * be at 9 different addresses, similar to MAX6680/MAX6681. The MAX6654 is
- * otherwise similar to MAX6657/MAX6658/MAX6659. Extended range is available
- * by setting the configuration register accordingly, and is done during
- * initialization. Extended precision is only available at conversion rates
- * of 1 Hz and slower. Note that extended precision is not enabled by
- * default, as this driver initializes all chips to 2 Hz by design.
+ * This driver also supports the MAX6654 chip made by Maxim. This chip can be
+ * at 9 different addresses, similar to MAX6680/MAX6681. The MAX6654 is similar
+ * to MAX6657/MAX6658/MAX6659, but does not support critical temperature
+ * limits. Extended range is available by setting the configuration register
+ * accordingly, and is done during initialization. Extended precision is only
+ * available at conversion rates of 1 Hz and slower. Note that extended
+ * precision is not enabled by default, as this driver initializes all chips
+ * to 2 Hz by design.
  *
  * This driver also supports the MAX6646, MAX6647, MAX6648, MAX6649 and
  * MAX6692 chips made by Maxim.  These are again similar to the LM86,
@@ -188,6 +189,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 #define LM90_HAVE_BROKEN_ALERT	(1 << 7) /* Broken alert		*/
 #define LM90_HAVE_EXTENDED_TEMP	(1 << 8) /* extended temperature support*/
 #define LM90_PAUSE_FOR_CONFIG	(1 << 9) /* Pause conversion for config	*/
+#define LM90_HAVE_CRIT		(1 << 10)/* Chip supports CRIT/OVERT register	*/
 
 /* LM90 status */
 #define LM90_STATUS_LTHRM	(1 << 0) /* local THERM limit tripped */
@@ -354,38 +356,43 @@ struct lm90_params {
 static const struct lm90_params lm90_params[] = {
 	[adm1032] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
-		  | LM90_HAVE_BROKEN_ALERT,
+		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 10,
 	},
 	[adt7461] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
-		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_EXTENDED_TEMP,
+		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_EXTENDED_TEMP
+		  | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 10,
 	},
 	[g781] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
-		  | LM90_HAVE_BROKEN_ALERT,
+		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 8,
 	},
 	[lm86] = {
-		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
+		  | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7b,
 		.max_convrate = 9,
 	},
 	[lm90] = {
-		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
+		  | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7b,
 		.max_convrate = 9,
 	},
 	[lm99] = {
-		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
+		  | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7b,
 		.max_convrate = 9,
 	},
 	[max6646] = {
+		.flags = LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 6,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
@@ -396,50 +403,50 @@ static const struct lm90_params lm90_params[] = {
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[max6657] = {
-		.flags = LM90_PAUSE_FOR_CONFIG,
+		.flags = LM90_PAUSE_FOR_CONFIG | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 8,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[max6659] = {
-		.flags = LM90_HAVE_EMERGENCY,
+		.flags = LM90_HAVE_EMERGENCY | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 8,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[max6680] = {
-		.flags = LM90_HAVE_OFFSET,
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 7,
 	},
 	[max6696] = {
 		.flags = LM90_HAVE_EMERGENCY
-		  | LM90_HAVE_EMERGENCY_ALARM | LM90_HAVE_TEMP3,
+		  | LM90_HAVE_EMERGENCY_ALARM | LM90_HAVE_TEMP3 | LM90_HAVE_CRIT,
 		.alert_alarms = 0x1c7c,
 		.max_convrate = 6,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
 	[w83l771] = {
-		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 8,
 	},
 	[sa56004] = {
-		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT,
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7b,
 		.max_convrate = 9,
 		.reg_local_ext = SA56004_REG_R_LOCAL_TEMPL,
 	},
 	[tmp451] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
-		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_EXTENDED_TEMP,
+		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_EXTENDED_TEMP | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 9,
 		.reg_local_ext = TMP451_REG_R_LOCAL_TEMPL,
 	},
 	[tmp461] = {
 		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
-		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_EXTENDED_TEMP,
+		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_EXTENDED_TEMP | LM90_HAVE_CRIT,
 		.alert_alarms = 0x7c,
 		.max_convrate = 9,
 		.reg_local_ext = TMP451_REG_R_LOCAL_TEMPL,
@@ -667,20 +674,22 @@ static int lm90_update_limits(struct device *dev)
 	struct i2c_client *client = data->client;
 	int val;
 
-	val = lm90_read_reg(client, LM90_REG_R_LOCAL_CRIT);
-	if (val < 0)
-		return val;
-	data->temp8[LOCAL_CRIT] = val;
+	if (data->flags & LM90_HAVE_CRIT) {
+		val = lm90_read_reg(client, LM90_REG_R_LOCAL_CRIT);
+		if (val < 0)
+			return val;
+		data->temp8[LOCAL_CRIT] = val;
 
-	val = lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT);
-	if (val < 0)
-		return val;
-	data->temp8[REMOTE_CRIT] = val;
+		val = lm90_read_reg(client, LM90_REG_R_REMOTE_CRIT);
+		if (val < 0)
+			return val;
+		data->temp8[REMOTE_CRIT] = val;
 
-	val = lm90_read_reg(client, LM90_REG_R_TCRIT_HYST);
-	if (val < 0)
-		return val;
-	data->temp_hyst = val;
+		val = lm90_read_reg(client, LM90_REG_R_TCRIT_HYST);
+		if (val < 0)
+			return val;
+		data->temp_hyst = val;
+	}
 
 	val = lm90_read_reg(client, LM90_REG_R_REMOTE_LOWH);
 	if (val < 0)
@@ -1866,11 +1875,14 @@ static int lm90_probe(struct i2c_client *client)
 	info->config = data->channel_config;
 
 	data->channel_config[0] = HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-		HWMON_T_CRIT | HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
-		HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM;
+		HWMON_T_MIN_ALARM | HWMON_T_MAX_ALARM;
 	data->channel_config[1] = HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
-		HWMON_T_CRIT | HWMON_T_CRIT_HYST | HWMON_T_MIN_ALARM |
-		HWMON_T_MAX_ALARM | HWMON_T_CRIT_ALARM | HWMON_T_FAULT;
+		HWMON_T_MIN_ALARM | HWMON_T_MAX_ALARM | HWMON_T_FAULT;
+
+	if (data->flags & LM90_HAVE_CRIT) {
+		data->channel_config[0] |= HWMON_T_CRIT | HWMON_T_CRIT_ALARM | HWMON_T_CRIT_HYST;
+		data->channel_config[1] |= HWMON_T_CRIT | HWMON_T_CRIT_ALARM | HWMON_T_CRIT_HYST;
+	}
 
 	if (data->flags & LM90_HAVE_OFFSET)
 		data->channel_config[1] |= HWMON_T_OFFSET;
-- 
2.34.1



