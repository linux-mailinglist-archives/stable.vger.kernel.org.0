Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89723BB1F9
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhGDXNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhGDXMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B0FC6194D;
        Sun,  4 Jul 2021 23:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440115;
        bh=+7fhU4ItvdQ0Yth24tWmm7vGV5ywWE6yO1g7gARPz7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbmsJvbOlujFGW2b02uW8ZweJLNLzQuO6j1MXnqanLPfkzTpQ23iz5SFfgWhZRRUk
         J7ZNsVUEly+YzndQHzvxDnOjrX1R4GCajeRo3Fxar+6J10XV1FcJiJ6nU8Z8w5r5Vg
         WV9vWvtDIlkUhCz2BYTkcdwpA2L4kwRIEg4GTPFxmoqmH2zapnTeRnYBEf2B38c7gn
         vx+NU4A6EoK0VkuVnnteMixuC/MuWTtGAPCGoqQqoKU8ii5ETpUf9jWMQK1d8QE9jW
         gnI4ZWpxa/Ph8nCaY+i/OyWpeYlKDMvNITUaqEznH3RoLK/HRTOWSA4vHqYdc4mvL8
         83wKteOAn6ZEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 22/70] regmap-i2c: Set regmap max raw r/w from quirks
Date:   Sun,  4 Jul 2021 19:07:15 -0400
Message-Id: <20210704230804.1490078-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Tanure <tanureal@opensource.cirrus.com>

[ Upstream commit ea030ca688193462b8d612c1628c37129aa30072 ]

Set regmap raw read/write from i2c quirks max read/write
so regmap_raw_read/write can split the access into chunks

Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210512135222.223203-1-tanureal@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-i2c.c | 45 +++++++++++++++++++++++++++-----
 drivers/base/regmap/regmap.c     |  2 ++
 include/linux/regmap.h           |  2 ++
 3 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index 62b95a9212ae..980e5ce6a3a3 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -306,33 +306,64 @@ static const struct regmap_bus regmap_i2c_smbus_i2c_block_reg16 = {
 static const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,
 					const struct regmap_config *config)
 {
+	const struct i2c_adapter_quirks *quirks;
+	const struct regmap_bus *bus = NULL;
+	struct regmap_bus *ret_bus;
+	u16 max_read = 0, max_write = 0;
+
 	if (i2c_check_functionality(i2c->adapter, I2C_FUNC_I2C))
-		return &regmap_i2c;
+		bus = &regmap_i2c;
 	else if (config->val_bits == 8 && config->reg_bits == 8 &&
 		 i2c_check_functionality(i2c->adapter,
 					 I2C_FUNC_SMBUS_I2C_BLOCK))
-		return &regmap_i2c_smbus_i2c_block;
+		bus = &regmap_i2c_smbus_i2c_block;
 	else if (config->val_bits == 8 && config->reg_bits == 16 &&
 		i2c_check_functionality(i2c->adapter,
 					I2C_FUNC_SMBUS_I2C_BLOCK))
-		return &regmap_i2c_smbus_i2c_block_reg16;
+		bus = &regmap_i2c_smbus_i2c_block_reg16;
 	else if (config->val_bits == 16 && config->reg_bits == 8 &&
 		 i2c_check_functionality(i2c->adapter,
 					 I2C_FUNC_SMBUS_WORD_DATA))
 		switch (regmap_get_val_endian(&i2c->dev, NULL, config)) {
 		case REGMAP_ENDIAN_LITTLE:
-			return &regmap_smbus_word;
+			bus = &regmap_smbus_word;
+			break;
 		case REGMAP_ENDIAN_BIG:
-			return &regmap_smbus_word_swapped;
+			bus = &regmap_smbus_word_swapped;
+			break;
 		default:		/* everything else is not supported */
 			break;
 		}
 	else if (config->val_bits == 8 && config->reg_bits == 8 &&
 		 i2c_check_functionality(i2c->adapter,
 					 I2C_FUNC_SMBUS_BYTE_DATA))
-		return &regmap_smbus_byte;
+		bus = &regmap_smbus_byte;
+
+	if (!bus)
+		return ERR_PTR(-ENOTSUPP);
+
+	quirks = i2c->adapter->quirks;
+	if (quirks) {
+		if (quirks->max_read_len &&
+		    (bus->max_raw_read == 0 || bus->max_raw_read > quirks->max_read_len))
+			max_read = quirks->max_read_len;
+
+		if (quirks->max_write_len &&
+		    (bus->max_raw_write == 0 || bus->max_raw_write > quirks->max_write_len))
+			max_write = quirks->max_write_len;
+
+		if (max_read || max_write) {
+			ret_bus = kmemdup(bus, sizeof(*bus), GFP_KERNEL);
+			if (!ret_bus)
+				return ERR_PTR(-ENOMEM);
+			ret_bus->free_on_exit = true;
+			ret_bus->max_raw_read = max_read;
+			ret_bus->max_raw_write = max_write;
+			bus = ret_bus;
+		}
+	}
 
-	return ERR_PTR(-ENOTSUPP);
+	return bus;
 }
 
 struct regmap *__regmap_init_i2c(struct i2c_client *i2c,
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 5db536ccfcd6..e4802aa512a5 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1496,6 +1496,8 @@ void regmap_exit(struct regmap *map)
 		mutex_destroy(&map->mutex);
 	kfree_const(map->name);
 	kfree(map->patch);
+	if (map->bus && map->bus->free_on_exit)
+		kfree(map->bus);
 	kfree(map);
 }
 EXPORT_SYMBOL_GPL(regmap_exit);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e7834d98207f..56503d99eda7 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -497,6 +497,7 @@ typedef void (*regmap_hw_free_context)(void *context);
  *     DEFAULT, BIG is assumed.
  * @max_raw_read: Max raw read size that can be used on the bus.
  * @max_raw_write: Max raw write size that can be used on the bus.
+ * @free_on_exit: kfree this on exit of regmap
  */
 struct regmap_bus {
 	bool fast_io;
@@ -514,6 +515,7 @@ struct regmap_bus {
 	enum regmap_endian val_format_endian_default;
 	size_t max_raw_read;
 	size_t max_raw_write;
+	bool free_on_exit;
 };
 
 /*
-- 
2.30.2

