Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2F23787D0
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhEJLS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236672AbhEJLI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9389461919;
        Mon, 10 May 2021 11:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644583;
        bh=Wm6JspxkzxF3Cfp0fZil21rw4Y+hepvR/gttYOPuVPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNCkj6IPIy0+fTJ3iX+tUJWSewm0rjiWBHWqCszd0xSzotmuB5E9PARkmX9BxcY1H
         17sB4J6BsnAPvso2lxEsT9XOJ9TlRc+ENvOpwIbeOCgYwos4jTyangmqSpcqnYADIO
         gXX6Zs2za9SchW6CLBJKc4kydtIbqaNrSOeYBZrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Ward <Adam.Ward.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 140/384] regulator: da9121: automotive variants identity fix
Date:   Mon, 10 May 2021 12:18:49 +0200
Message-Id: <20210510102019.508388007@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ward <Adam.Ward.opensource@diasemi.com>

[ Upstream commit 013592be146a10d3567c0062cd1416faab060704 ]

This patch fixes identification of DA913x parts by the DA9121 driver,
where a lack of clarity lead to implementation on the basis that variant
IDs were to be identical to the equivalent rated non-automotive parts.

There is a new emphasis on the DT identity to cope with overlap in these
ID's - this is not considered to be problematic, because projects would
be exclusively using automotive or consumer grade parts.

Signed-off-by: Adam Ward <Adam.Ward.opensource@diasemi.com>
Link: https://lore.kernel.org/r/20210421120306.DB5B880007F@slsrvapps-01.diasemi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9121-regulator.c | 80 ++++++++++++++++++----------
 drivers/regulator/da9121-regulator.h | 13 +++++
 2 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/drivers/regulator/da9121-regulator.c b/drivers/regulator/da9121-regulator.c
index a2ede7d7897e..08cbf688e14d 100644
--- a/drivers/regulator/da9121-regulator.c
+++ b/drivers/regulator/da9121-regulator.c
@@ -40,6 +40,7 @@ struct da9121 {
 	unsigned int passive_delay;
 	int chip_irq;
 	int variant_id;
+	int subvariant_id;
 };
 
 /* Define ranges for different variants, enabling translation to/from
@@ -812,7 +813,6 @@ static struct regmap_config da9121_2ch_regmap_config = {
 static int da9121_check_device_type(struct i2c_client *i2c, struct da9121 *chip)
 {
 	u32 device_id;
-	u8 chip_id = chip->variant_id;
 	u32 variant_id;
 	u8 variant_mrc, variant_vrc;
 	char *type;
@@ -839,22 +839,34 @@ static int da9121_check_device_type(struct i2c_client *i2c, struct da9121 *chip)
 
 	variant_vrc = variant_id & DA9121_MASK_OTP_VARIANT_ID_VRC;
 
-	switch (variant_vrc) {
-	case DA9121_VARIANT_VRC:
-		type = "DA9121/DA9130";
-		config_match = (chip_id == DA9121_TYPE_DA9121_DA9130);
+	switch (chip->subvariant_id) {
+	case DA9121_SUBTYPE_DA9121:
+		type = "DA9121";
+		config_match = (variant_vrc == DA9121_VARIANT_VRC);
 		break;
-	case DA9220_VARIANT_VRC:
-		type = "DA9220/DA9132";
-		config_match = (chip_id == DA9121_TYPE_DA9220_DA9132);
+	case DA9121_SUBTYPE_DA9130:
+		type = "DA9130";
+		config_match = (variant_vrc == DA9130_VARIANT_VRC);
 		break;
-	case DA9122_VARIANT_VRC:
-		type = "DA9122/DA9131";
-		config_match = (chip_id == DA9121_TYPE_DA9122_DA9131);
+	case DA9121_SUBTYPE_DA9220:
+		type = "DA9220";
+		config_match = (variant_vrc == DA9220_VARIANT_VRC);
 		break;
-	case DA9217_VARIANT_VRC:
+	case DA9121_SUBTYPE_DA9132:
+		type = "DA9132";
+		config_match = (variant_vrc == DA9132_VARIANT_VRC);
+		break;
+	case DA9121_SUBTYPE_DA9122:
+		type = "DA9122";
+		config_match = (variant_vrc == DA9122_VARIANT_VRC);
+		break;
+	case DA9121_SUBTYPE_DA9131:
+		type = "DA9131";
+		config_match = (variant_vrc == DA9131_VARIANT_VRC);
+		break;
+	case DA9121_SUBTYPE_DA9217:
 		type = "DA9217";
-		config_match = (chip_id == DA9121_TYPE_DA9217);
+		config_match = (variant_vrc == DA9217_VARIANT_VRC);
 		break;
 	default:
 		type = "Unknown";
@@ -892,15 +904,27 @@ static int da9121_assign_chip_model(struct i2c_client *i2c,
 
 	chip->dev = &i2c->dev;
 
-	switch (chip->variant_id) {
-	case DA9121_TYPE_DA9121_DA9130:
-		fallthrough;
-	case DA9121_TYPE_DA9217:
+	/* Use configured subtype to select the regulator descriptor index and
+	 * register map, common to both consumer and automotive grade variants
+	 */
+	switch (chip->subvariant_id) {
+	case DA9121_SUBTYPE_DA9121:
+	case DA9121_SUBTYPE_DA9130:
+		chip->variant_id = DA9121_TYPE_DA9121_DA9130;
 		regmap = &da9121_1ch_regmap_config;
 		break;
-	case DA9121_TYPE_DA9122_DA9131:
-		fallthrough;
-	case DA9121_TYPE_DA9220_DA9132:
+	case DA9121_SUBTYPE_DA9217:
+		chip->variant_id = DA9121_TYPE_DA9217;
+		regmap = &da9121_1ch_regmap_config;
+		break;
+	case DA9121_SUBTYPE_DA9122:
+	case DA9121_SUBTYPE_DA9131:
+		chip->variant_id = DA9121_TYPE_DA9122_DA9131;
+		regmap = &da9121_2ch_regmap_config;
+		break;
+	case DA9121_SUBTYPE_DA9220:
+	case DA9121_SUBTYPE_DA9132:
+		chip->variant_id = DA9121_TYPE_DA9220_DA9132;
 		regmap = &da9121_2ch_regmap_config;
 		break;
 	}
@@ -975,13 +999,13 @@ regmap_error:
 }
 
 static const struct of_device_id da9121_dt_ids[] = {
-	{ .compatible = "dlg,da9121", .data = (void *) DA9121_TYPE_DA9121_DA9130 },
-	{ .compatible = "dlg,da9130", .data = (void *) DA9121_TYPE_DA9121_DA9130 },
-	{ .compatible = "dlg,da9217", .data = (void *) DA9121_TYPE_DA9217 },
-	{ .compatible = "dlg,da9122", .data = (void *) DA9121_TYPE_DA9122_DA9131 },
-	{ .compatible = "dlg,da9131", .data = (void *) DA9121_TYPE_DA9122_DA9131 },
-	{ .compatible = "dlg,da9220", .data = (void *) DA9121_TYPE_DA9220_DA9132 },
-	{ .compatible = "dlg,da9132", .data = (void *) DA9121_TYPE_DA9220_DA9132 },
+	{ .compatible = "dlg,da9121", .data = (void *) DA9121_SUBTYPE_DA9121 },
+	{ .compatible = "dlg,da9130", .data = (void *) DA9121_SUBTYPE_DA9130 },
+	{ .compatible = "dlg,da9217", .data = (void *) DA9121_SUBTYPE_DA9217 },
+	{ .compatible = "dlg,da9122", .data = (void *) DA9121_SUBTYPE_DA9122 },
+	{ .compatible = "dlg,da9131", .data = (void *) DA9121_SUBTYPE_DA9131 },
+	{ .compatible = "dlg,da9220", .data = (void *) DA9121_SUBTYPE_DA9220 },
+	{ .compatible = "dlg,da9132", .data = (void *) DA9121_SUBTYPE_DA9132 },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, da9121_dt_ids);
@@ -1011,7 +1035,7 @@ static int da9121_i2c_probe(struct i2c_client *i2c,
 	}
 
 	chip->pdata = i2c->dev.platform_data;
-	chip->variant_id = da9121_of_get_id(&i2c->dev);
+	chip->subvariant_id = da9121_of_get_id(&i2c->dev);
 
 	ret = da9121_assign_chip_model(i2c, chip);
 	if (ret < 0)
diff --git a/drivers/regulator/da9121-regulator.h b/drivers/regulator/da9121-regulator.h
index 3c34cb889ca8..357f416e17c1 100644
--- a/drivers/regulator/da9121-regulator.h
+++ b/drivers/regulator/da9121-regulator.h
@@ -29,6 +29,16 @@ enum da9121_variant {
 	DA9121_TYPE_DA9217
 };
 
+enum da9121_subvariant {
+	DA9121_SUBTYPE_DA9121,
+	DA9121_SUBTYPE_DA9130,
+	DA9121_SUBTYPE_DA9220,
+	DA9121_SUBTYPE_DA9132,
+	DA9121_SUBTYPE_DA9122,
+	DA9121_SUBTYPE_DA9131,
+	DA9121_SUBTYPE_DA9217
+};
+
 /* Minimum, maximum and default polling millisecond periods are provided
  * here as an example. It is expected that any final implementation will
  * include a modification of these settings to match the required
@@ -279,6 +289,9 @@ enum da9121_variant {
 #define DA9220_VARIANT_VRC	0x0
 #define DA9122_VARIANT_VRC	0x2
 #define DA9217_VARIANT_VRC	0x7
+#define DA9130_VARIANT_VRC	0x0
+#define DA9131_VARIANT_VRC	0x1
+#define DA9132_VARIANT_VRC	0x2
 
 /* DA9121_REG_OTP_CUSTOMER_ID */
 
-- 
2.30.2



