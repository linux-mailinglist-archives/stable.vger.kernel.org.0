Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB2D47FF59
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbhL0Pgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:36:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40468 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbhL0PgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:36:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AEE30CE10CC;
        Mon, 27 Dec 2021 15:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A224C36AEA;
        Mon, 27 Dec 2021 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619379;
        bh=qWlq/4RXBxpB1L0u62b6ubbd1OpywQGXIpzD2an/ksY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3sWp7UivXQGdFuL7B+kn4Qp6o965PgaEMaG3OAJI7GVitXaSacAIMWeYk8vcqZwl
         AMgPb3xgtQlHZtFuZxjZmWRYkb8mmSrTPZyrzcCxYZP1BGaXAOMhbRTb4XtaQNf0RL
         GGliwCRx0QD3aDCJoCOekGGEJXzdBF9BltDGskxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Lehan <krellan@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/47] hwmon: (lm90) Add max6654 support to lm90 driver
Date:   Mon, 27 Dec 2021 16:30:54 +0100
Message-Id: <20211227151321.419466557@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Lehan <krellan@google.com>

[ Upstream commit 229d495d8189ae785dacee72e5633a58edc25ddf ]

Add support for the Maxim MAX6654 to the lm90 driver.

The MAX6654 is a temperature sensor, similar to the others,
but with some differences regarding the configuration
register, and the sampling rate at which extended resolution
becomes possible.

Signed-off-by: Josh Lehan <krellan@google.com>
Link: https://lore.kernel.org/r/20200513184248.145765-1-krellan@google.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/lm90.rst | 23 ++++++++++++++++--
 drivers/hwmon/Kconfig        |  9 ++++----
 drivers/hwmon/lm90.c         | 45 ++++++++++++++++++++++++++++++++----
 3 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/Documentation/hwmon/lm90.rst b/Documentation/hwmon/lm90.rst
index 953315987c06e..78dfc01b47a23 100644
--- a/Documentation/hwmon/lm90.rst
+++ b/Documentation/hwmon/lm90.rst
@@ -123,6 +123,18 @@ Supported chips:
 
 	       http://www.maxim-ic.com/quick_view2.cfm/qv_pk/3497
 
+  * Maxim MAX6654
+
+    Prefix: 'max6654'
+
+    Addresses scanned: I2C 0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b,
+
+			   0x4c, 0x4d and 0x4e
+
+    Datasheet: Publicly available at the Maxim website
+
+	       https://www.maximintegrated.com/en/products/sensors/MAX6654.html
+
   * Maxim MAX6657
 
     Prefix: 'max6657'
@@ -301,6 +313,13 @@ ADT7461, ADT7461A, NCT1008:
   * Extended temperature range (breaks compatibility)
   * Lower resolution for remote temperature
 
+MAX6654:
+  * Better local resolution
+  * Selectable address
+  * Remote sensor type selection
+  * Extended temperature range
+  * Extended resolution only available when conversion rate <= 1 Hz
+
 MAX6657 and MAX6658:
   * Better local resolution
   * Remote sensor type selection
@@ -336,8 +355,8 @@ SA56004X:
 
 All temperature values are given in degrees Celsius. Resolution
 is 1.0 degree for the local temperature, 0.125 degree for the remote
-temperature, except for the MAX6657, MAX6658 and MAX6659 which have a
-resolution of 0.125 degree for both temperatures.
+temperature, except for the MAX6654, MAX6657, MAX6658 and MAX6659 which have
+a resolution of 0.125 degree for both temperatures.
 
 Each sensor has its own high and low limits, plus a critical limit.
 Additionally, there is a relative hysteresis value common to both critical
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 13a6b4afb4b36..fdf8fab7eb396 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1132,10 +1132,11 @@ config SENSORS_LM90
 	help
 	  If you say yes here you get support for National Semiconductor LM90,
 	  LM86, LM89 and LM99, Analog Devices ADM1032, ADT7461, and ADT7461A,
-	  Maxim MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
-	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, ON Semiconductor NCT1008,
-	  Winbond/Nuvoton W83L771W/G/AWG/ASG, Philips SA56004, GMT G781, and
-	  Texas Instruments TMP451 sensor chips.
+	  Maxim MAX6646, MAX6647, MAX6648, MAX6649, MAX6654, MAX6657, MAX6658,
+	  MAX6659, MAX6680, MAX6681, MAX6692, MAX6695, MAX6696,
+	  ON Semiconductor NCT1008, Winbond/Nuvoton W83L771W/G/AWG/ASG,
+	  Philips SA56004, GMT G781, and Texas Instruments TMP451
+	  sensor chips.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called lm90.
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 6d6f543baea68..9d48a7405932f 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -35,6 +35,14 @@
  * explicitly as max6659, or if its address is not 0x4c.
  * These chips lack the remote temperature offset feature.
  *
+ * This driver also supports the MAX6654 chip made by Maxim. This chip can
+ * be at 9 different addresses, similar to MAX6680/MAX6681. The MAX6654 is
+ * otherwise similar to MAX6657/MAX6658/MAX6659. Extended range is available
+ * by setting the configuration register accordingly, and is done during
+ * initialization. Extended precision is only available at conversion rates
+ * of 1 Hz and slower. Note that extended precision is not enabled by
+ * default, as this driver initializes all chips to 2 Hz by design.
+ *
  * This driver also supports the MAX6646, MAX6647, MAX6648, MAX6649 and
  * MAX6692 chips made by Maxim.  These are again similar to the LM86,
  * but they use unsigned temperature values and can report temperatures
@@ -94,8 +102,8 @@
  * have address 0x4d.
  * MAX6647 has address 0x4e.
  * MAX6659 can have address 0x4c, 0x4d or 0x4e.
- * MAX6680 and MAX6681 can have address 0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b,
- * 0x4c, 0x4d or 0x4e.
+ * MAX6654, MAX6680, and MAX6681 can have address 0x18, 0x19, 0x1a, 0x29,
+ * 0x2a, 0x2b, 0x4c, 0x4d or 0x4e.
  * SA56004 can have address 0x48 through 0x4F.
  */
 
@@ -104,7 +112,7 @@ static const unsigned short normal_i2c[] = {
 	0x4d, 0x4e, 0x4f, I2C_CLIENT_END };
 
 enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
-	max6646, w83l771, max6696, sa56004, g781, tmp451 };
+	max6646, w83l771, max6696, sa56004, g781, tmp451, max6654 };
 
 /*
  * The LM90 registers
@@ -145,7 +153,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 #define LM90_REG_R_TCRIT_HYST		0x21
 #define LM90_REG_W_TCRIT_HYST		0x21
 
-/* MAX6646/6647/6649/6657/6658/6659/6695/6696 registers */
+/* MAX6646/6647/6649/6654/6657/6658/6659/6695/6696 registers */
 
 #define MAX6657_REG_R_LOCAL_TEMPL	0x11
 #define MAX6696_REG_R_STATUS2		0x12
@@ -209,6 +217,7 @@ static const struct i2c_device_id lm90_id[] = {
 	{ "max6646", max6646 },
 	{ "max6647", max6646 },
 	{ "max6649", max6646 },
+	{ "max6654", max6654 },
 	{ "max6657", max6657 },
 	{ "max6658", max6657 },
 	{ "max6659", max6659 },
@@ -269,6 +278,10 @@ static const struct of_device_id __maybe_unused lm90_of_match[] = {
 		.compatible = "dallas,max6649",
 		.data = (void *)max6646
 	},
+	{
+		.compatible = "dallas,max6654",
+		.data = (void *)max6654
+	},
 	{
 		.compatible = "dallas,max6657",
 		.data = (void *)max6657
@@ -367,6 +380,11 @@ static const struct lm90_params lm90_params[] = {
 		.max_convrate = 6,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
+	[max6654] = {
+		.alert_alarms = 0x7c,
+		.max_convrate = 7,
+		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
+	},
 	[max6657] = {
 		.flags = LM90_PAUSE_FOR_CONFIG,
 		.alert_alarms = 0x7c,
@@ -1556,6 +1574,16 @@ static int lm90_detect(struct i2c_client *client,
 		 && (config1 & 0x3f) == 0x00
 		 && convrate <= 0x07) {
 			name = "max6646";
+		} else
+		/*
+		 * The chip_id of the MAX6654 holds the revision of the chip.
+		 * The lowest 3 bits of the config1 register are unused and
+		 * should return zero when read.
+		 */
+		if (chip_id == 0x08
+		 && (config1 & 0x07) == 0x00
+		 && convrate <= 0x07) {
+			name = "max6654";
 		}
 	} else
 	if (address == 0x4C
@@ -1659,6 +1687,15 @@ static int lm90_init_client(struct i2c_client *client, struct lm90_data *data)
 	if (data->kind == max6680)
 		config |= 0x18;
 
+	/*
+	 * Put MAX6654 into extended range (0x20, extend minimum range from
+	 * 0 degrees to -64 degrees). Note that extended resolution is not
+	 * possible on the MAX6654 unless conversion rate is set to 1 Hz or
+	 * slower, which is intentionally not done by default.
+	 */
+	if (data->kind == max6654)
+		config |= 0x20;
+
 	/*
 	 * Select external channel 0 for max6695/96
 	 */
-- 
2.34.1



