Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EA24800E9
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240440AbhL0Pve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238970AbhL0Pt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:49:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FD4C08EB24;
        Mon, 27 Dec 2021 07:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3097EB810C5;
        Mon, 27 Dec 2021 15:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4082FC36AE7;
        Mon, 27 Dec 2021 15:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619845;
        bh=4MiR6cM1GTRpv3SBcSNCSUda0UYiLZXClM0i8A2Nvrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+E6gLbBILeIcyLFpt+r90eVT7iqMyiDU47QkYjJWrMMZxjmeHScygkihUexjQf46
         xOBO1QjdElcylSKh6TE5Uz/ReQcFK2NpCfPcld/Nl5vaFBA5ETlsAJpES16DhOhYCb
         1ySlph42Ow0OcwOTP21rrEyLPWGNfKQXlk8wOV0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Lehan <krellan@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/128] hwmon: (lm90) Drop critical attribute support for MAX6654
Date:   Mon, 27 Dec 2021 16:30:32 +0100
Message-Id: <20211227151333.414376646@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
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
index 72969ea83d82e..6597d055e09d8 100644
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
@@ -668,20 +675,22 @@ static int lm90_update_limits(struct device *dev)
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
@@ -1902,11 +1911,14 @@ static int lm90_probe(struct i2c_client *client)
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



