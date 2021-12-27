Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC86148005B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhL0Ppt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:45:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44990 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239935AbhL0PoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46116B810CF;
        Mon, 27 Dec 2021 15:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DC6C36AEB;
        Mon, 27 Dec 2021 15:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619842;
        bh=KwpW/ydRUHaCWt8qToP5e5UKlXqxNTOwwPe7v96VZcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsPqWbhc50oRiRlidTdGNmdR+U9CQ/OLOi6AtNzVvK4ntUg1dhSUOBIdEF4KAEaFY
         zUOjvmbG0pVkNAByA4it5RkgRe/HDcH10e++USQ01Ihe2o8Q1r/o3hP1UJPePoaGfu
         IyeJqxHqWjGoC+R2Z1YiZqSOePdXDbsiRErtIP2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David T. Wilson" <david.wilson@nasa.gov>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/128] hwmon: (lm90) Add basic support for TI TMP461
Date:   Mon, 27 Dec 2021 16:30:31 +0100
Message-Id: <20211227151333.383840220@linuxfoundation.org>
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

[ Upstream commit f8344f7693a25d9025a59d164450b50c6f5aa3c0 ]

TMP461 is almost identical to TMP451 and was actually detected as TMP451
with the existing lm90 driver if its I2C address is 0x4c. Add support
for it to the lm90 driver. At the same time, improve the chip detection
function to at least try to distinguish between TMP451 and TMP461.

As a side effect, this fixes commit 24333ac26d01 ("hwmon: (tmp401) use
smb word operations instead of 2 smb byte operations"). TMP461 does not
support word operations on temperature registers, which causes bad
temperature readings with the tmp401 driver. The lm90 driver does not
perform word operations on temperature registers and thus does not have
this problem.

Support is listed as basic because TMP461 supports a sensor resolution
of 0.0625 degrees C, while the lm90 driver assumes a resolution of 0.125
degrees C. Also, the TMP461 supports negative temperatures with its
default temperature range, which is not the case for similar chips
supported by the lm90 and the tmp401 drivers. Those limitations will be
addressed with follow-up patches.

Fixes: 24333ac26d01 ("hwmon: (tmp401) use smb word operations instead of 2 smb byte operations")
Reported-by: David T. Wilson <david.wilson@nasa.gov>
Cc: David T. Wilson <david.wilson@nasa.gov>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/lm90.rst | 10 +++++++
 drivers/hwmon/Kconfig        |  2 +-
 drivers/hwmon/lm90.c         | 54 ++++++++++++++++++++++++++----------
 3 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/Documentation/hwmon/lm90.rst b/Documentation/hwmon/lm90.rst
index 3da8c6e06a365..05391fb4042d9 100644
--- a/Documentation/hwmon/lm90.rst
+++ b/Documentation/hwmon/lm90.rst
@@ -265,6 +265,16 @@ Supported chips:
 
 	       https://www.ti.com/litv/pdf/sbos686
 
+  * Texas Instruments TMP461
+
+    Prefix: 'tmp461'
+
+    Addresses scanned: I2C 0x48 through 0x4F
+
+    Datasheet: Publicly available at TI website
+
+	       https://www.ti.com/lit/gpn/tmp461
+
 Author: Jean Delvare <jdelvare@suse.de>
 
 
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index c4578e8f34bb5..ccdaeafed0bb7 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1317,7 +1317,7 @@ config SENSORS_LM90
 	  Maxim MAX6646, MAX6647, MAX6648, MAX6649, MAX6654, MAX6657, MAX6658,
 	  MAX6659, MAX6680, MAX6681, MAX6692, MAX6695, MAX6696,
 	  ON Semiconductor NCT1008, Winbond/Nuvoton W83L771W/G/AWG/ASG,
-	  Philips SA56004, GMT G781, and Texas Instruments TMP451
+	  Philips SA56004, GMT G781, Texas Instruments TMP451 and TMP461
 	  sensor chips.
 
 	  This driver can also be built as a module. If so, the module
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 0463179be5504..72969ea83d82e 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -69,10 +69,10 @@
  * This driver also supports the G781 from GMT. This device is compatible
  * with the ADM1032.
  *
- * This driver also supports TMP451 from Texas Instruments. This device is
- * supported in both compatibility and extended mode. It's mostly compatible
- * with ADT7461 except for local temperature low byte register and max
- * conversion rate.
+ * This driver also supports TMP451 and TMP461 from Texas Instruments.
+ * Those devices are supported in both compatibility and extended mode.
+ * They are mostly compatible with ADT7461 except for local temperature
+ * low byte register and max conversion rate.
  *
  * Since the LM90 was the first chipset supported by this driver, most
  * comments will refer to this chipset, but are actually general and
@@ -112,7 +112,7 @@ static const unsigned short normal_i2c[] = {
 	0x4d, 0x4e, 0x4f, I2C_CLIENT_END };
 
 enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
-	max6646, w83l771, max6696, sa56004, g781, tmp451, max6654 };
+	max6646, w83l771, max6696, sa56004, g781, tmp451, tmp461, max6654 };
 
 /*
  * The LM90 registers
@@ -168,8 +168,12 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 
 #define LM90_MAX_CONVRATE_MS	16000	/* Maximum conversion rate in ms */
 
-/* TMP451 registers */
+/* TMP451/TMP461 registers */
 #define TMP451_REG_R_LOCAL_TEMPL	0x15
+#define TMP451_REG_CONALERT		0x22
+
+#define TMP461_REG_CHEN			0x16
+#define TMP461_REG_DFC			0x24
 
 /*
  * Device flags
@@ -230,6 +234,7 @@ static const struct i2c_device_id lm90_id[] = {
 	{ "w83l771", w83l771 },
 	{ "sa56004", sa56004 },
 	{ "tmp451", tmp451 },
+	{ "tmp461", tmp461 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lm90_id);
@@ -327,6 +332,10 @@ static const struct of_device_id __maybe_unused lm90_of_match[] = {
 		.compatible = "ti,tmp451",
 		.data = (void *)tmp451
 	},
+	{
+		.compatible = "ti,tmp461",
+		.data = (void *)tmp461
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, lm90_of_match);
@@ -428,6 +437,13 @@ static const struct lm90_params lm90_params[] = {
 		.max_convrate = 9,
 		.reg_local_ext = TMP451_REG_R_LOCAL_TEMPL,
 	},
+	[tmp461] = {
+		.flags = LM90_HAVE_OFFSET | LM90_HAVE_REM_LIMIT_EXT
+		  | LM90_HAVE_BROKEN_ALERT | LM90_HAVE_EXTENDED_TEMP,
+		.alert_alarms = 0x7c,
+		.max_convrate = 9,
+		.reg_local_ext = TMP451_REG_R_LOCAL_TEMPL,
+	},
 };
 
 /*
@@ -1627,18 +1643,26 @@ static int lm90_detect(struct i2c_client *client,
 		 && convrate <= 0x08)
 			name = "g781";
 	} else
-	if (address == 0x4C
-	 && man_id == 0x55) { /* Texas Instruments */
-		int local_ext;
+	if (man_id == 0x55 && chip_id == 0x00 &&
+	    (config1 & 0x1B) == 0x00 && convrate <= 0x09) {
+		int local_ext, conalert, chen, dfc;
 
 		local_ext = i2c_smbus_read_byte_data(client,
 						     TMP451_REG_R_LOCAL_TEMPL);
-
-		if (chip_id == 0x00 /* TMP451 */
-		 && (config1 & 0x1B) == 0x00
-		 && convrate <= 0x09
-		 && (local_ext & 0x0F) == 0x00)
-			name = "tmp451";
+		conalert = i2c_smbus_read_byte_data(client,
+						    TMP451_REG_CONALERT);
+		chen = i2c_smbus_read_byte_data(client, TMP461_REG_CHEN);
+		dfc = i2c_smbus_read_byte_data(client, TMP461_REG_DFC);
+
+		if ((local_ext & 0x0F) == 0x00 &&
+		    (conalert & 0xf1) == 0x01 &&
+		    (chen & 0xfc) == 0x00 &&
+		    (dfc & 0xfc) == 0x00) {
+			if (address == 0x4c && !(chen & 0x03))
+				name = "tmp451";
+			else if (address >= 0x48 && address <= 0x4f)
+				name = "tmp461";
+		}
 	}
 
 	if (!name) { /* identification failed */
-- 
2.34.1



