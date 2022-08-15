Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46757593F3E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348931AbiHOViD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349068AbiHOVgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:36:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CC1B7;
        Mon, 15 Aug 2022 12:26:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADE0BB810C6;
        Mon, 15 Aug 2022 19:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CE8C433D6;
        Mon, 15 Aug 2022 19:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591575;
        bh=2YYp1pyJZPc3drJBP+v525omMRdvo3xH8Vra2/XQD5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pN3GqIvxjeqN4/jpC76H/K3n/mWGBc+d21npGOUO9QeUjZRAFxvzDyTmYnX/RKC85
         NkVs07G9sLUb8euwz3QakTqF9WWLVSosX3bRkQduitf9iZiXaigwwaOWO3nNaSs5aC
         /IZMm5hFwXF6Oa0e+C2DGeRS6IFDpPG1l0cE0X1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagath Jog J <jagathjog1996@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0585/1095] iio: accel: bma400: conversion to device-managed function
Date:   Mon, 15 Aug 2022 19:59:44 +0200
Message-Id: <20220815180453.792763307@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagath Jog J <jagathjog1996@gmail.com>

[ Upstream commit 12c99f859fd3da5fc8f8491826e7023001f54821 ]

This is a conversion to device-managed by using devm_iio_device_register()
inside probe function. Previously the bma400 was not put into power down
mode in some error paths in probe where it now is, but that should cause
no harm.

The dev_set_drvdata() call, bma400_remove() function and hooks in the I2C
and SPI driver struct is removed as devm_iio_device_register() function is
used to automatically unregister on driver detach.

Signed-off-by: Jagath Jog J <jagathjog1996@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220505133021.22362-4-jagathjog1996@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma400.h      |  2 -
 drivers/iio/accel/bma400_core.c | 77 ++++++++++++++++-----------------
 drivers/iio/accel/bma400_i2c.c  |  8 ----
 drivers/iio/accel/bma400_spi.c  |  6 ---
 4 files changed, 38 insertions(+), 55 deletions(-)

diff --git a/drivers/iio/accel/bma400.h b/drivers/iio/accel/bma400.h
index 80330c7ce17f..1c8c47a9a317 100644
--- a/drivers/iio/accel/bma400.h
+++ b/drivers/iio/accel/bma400.h
@@ -113,6 +113,4 @@ extern const struct regmap_config bma400_regmap_config;
 
 int bma400_probe(struct device *dev, struct regmap *regmap, const char *name);
 
-void bma400_remove(struct device *dev);
-
 #endif
diff --git a/drivers/iio/accel/bma400_core.c b/drivers/iio/accel/bma400_core.c
index 25ad1f7339bc..07674d89d978 100644
--- a/drivers/iio/accel/bma400_core.c
+++ b/drivers/iio/accel/bma400_core.c
@@ -560,6 +560,26 @@ static void bma400_init_tables(void)
 	}
 }
 
+static void bma400_regulators_disable(void *data_ptr)
+{
+	struct bma400_data *data = data_ptr;
+
+	regulator_bulk_disable(ARRAY_SIZE(data->regulators), data->regulators);
+}
+
+static void bma400_power_disable(void *data_ptr)
+{
+	struct bma400_data *data = data_ptr;
+	int ret;
+
+	mutex_lock(&data->mutex);
+	ret = bma400_set_power_mode(data, POWER_MODE_SLEEP);
+	mutex_unlock(&data->mutex);
+	if (ret)
+		dev_warn(data->dev, "Failed to put device into sleep mode (%pe)\n",
+			 ERR_PTR(ret));
+}
+
 static int bma400_init(struct bma400_data *data)
 {
 	unsigned int val;
@@ -569,13 +589,12 @@ static int bma400_init(struct bma400_data *data)
 	ret = regmap_read(data->regmap, BMA400_CHIP_ID_REG, &val);
 	if (ret) {
 		dev_err(data->dev, "Failed to read chip id register\n");
-		goto out;
+		return ret;
 	}
 
 	if (val != BMA400_ID_REG_VAL) {
 		dev_err(data->dev, "Chip ID mismatch\n");
-		ret = -ENODEV;
-		goto out;
+		return -ENODEV;
 	}
 
 	data->regulators[BMA400_VDD_REGULATOR].supply = "vdd";
@@ -589,27 +608,31 @@ static int bma400_init(struct bma400_data *data)
 				"Failed to get regulators: %d\n",
 				ret);
 
-		goto out;
+		return ret;
 	}
 	ret = regulator_bulk_enable(ARRAY_SIZE(data->regulators),
 				    data->regulators);
 	if (ret) {
 		dev_err(data->dev, "Failed to enable regulators: %d\n",
 			ret);
-		goto out;
+		return ret;
 	}
 
+	ret = devm_add_action_or_reset(data->dev, bma400_regulators_disable, data);
+	if (ret)
+		return ret;
+
 	ret = bma400_get_power_mode(data);
 	if (ret) {
 		dev_err(data->dev, "Failed to get the initial power-mode\n");
-		goto err_reg_disable;
+		return ret;
 	}
 
 	if (data->power_mode != POWER_MODE_NORMAL) {
 		ret = bma400_set_power_mode(data, POWER_MODE_NORMAL);
 		if (ret) {
 			dev_err(data->dev, "Failed to wake up the device\n");
-			goto err_reg_disable;
+			return ret;
 		}
 		/*
 		 * TODO: The datasheet waits 1500us here in the example, but
@@ -618,19 +641,23 @@ static int bma400_init(struct bma400_data *data)
 		usleep_range(1500, 2000);
 	}
 
+	ret = devm_add_action_or_reset(data->dev, bma400_power_disable, data);
+	if (ret)
+		return ret;
+
 	bma400_init_tables();
 
 	ret = bma400_get_accel_output_data_rate(data);
 	if (ret)
-		goto err_reg_disable;
+		return ret;
 
 	ret = bma400_get_accel_oversampling_ratio(data);
 	if (ret)
-		goto err_reg_disable;
+		return ret;
 
 	ret = bma400_get_accel_scale(data);
 	if (ret)
-		goto err_reg_disable;
+		return ret;
 
 	/*
 	 * Once the interrupt engine is supported we might use the
@@ -639,12 +666,6 @@ static int bma400_init(struct bma400_data *data)
 	 * channel.
 	 */
 	return regmap_write(data->regmap, BMA400_ACC_CONFIG2_REG, 0x00);
-
-err_reg_disable:
-	regulator_bulk_disable(ARRAY_SIZE(data->regulators),
-			       data->regulators);
-out:
-	return ret;
 }
 
 static int bma400_read_raw(struct iio_dev *indio_dev,
@@ -822,32 +843,10 @@ int bma400_probe(struct device *dev, struct regmap *regmap, const char *name)
 	indio_dev->num_channels = ARRAY_SIZE(bma400_channels);
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
-	dev_set_drvdata(dev, indio_dev);
-
-	return iio_device_register(indio_dev);
+	return devm_iio_device_register(dev, indio_dev);
 }
 EXPORT_SYMBOL_NS(bma400_probe, IIO_BMA400);
 
-void bma400_remove(struct device *dev)
-{
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct bma400_data *data = iio_priv(indio_dev);
-	int ret;
-
-	mutex_lock(&data->mutex);
-	ret = bma400_set_power_mode(data, POWER_MODE_SLEEP);
-	mutex_unlock(&data->mutex);
-
-	if (ret)
-		dev_warn(dev, "Failed to put device into sleep mode (%pe)\n", ERR_PTR(ret));
-
-	regulator_bulk_disable(ARRAY_SIZE(data->regulators),
-			       data->regulators);
-
-	iio_device_unregister(indio_dev);
-}
-EXPORT_SYMBOL_NS(bma400_remove, IIO_BMA400);
-
 MODULE_AUTHOR("Dan Robertson <dan@dlrobertson.com>");
 MODULE_DESCRIPTION("Bosch BMA400 triaxial acceleration sensor core");
 MODULE_LICENSE("GPL");
diff --git a/drivers/iio/accel/bma400_i2c.c b/drivers/iio/accel/bma400_i2c.c
index da104ffd3fe0..4f6e01a3b3a1 100644
--- a/drivers/iio/accel/bma400_i2c.c
+++ b/drivers/iio/accel/bma400_i2c.c
@@ -27,13 +27,6 @@ static int bma400_i2c_probe(struct i2c_client *client,
 	return bma400_probe(&client->dev, regmap, id->name);
 }
 
-static int bma400_i2c_remove(struct i2c_client *client)
-{
-	bma400_remove(&client->dev);
-
-	return 0;
-}
-
 static const struct i2c_device_id bma400_i2c_ids[] = {
 	{ "bma400", 0 },
 	{ }
@@ -52,7 +45,6 @@ static struct i2c_driver bma400_i2c_driver = {
 		.of_match_table = bma400_of_i2c_match,
 	},
 	.probe    = bma400_i2c_probe,
-	.remove   = bma400_i2c_remove,
 	.id_table = bma400_i2c_ids,
 };
 
diff --git a/drivers/iio/accel/bma400_spi.c b/drivers/iio/accel/bma400_spi.c
index 51f23bdc0ea5..28e240400a3f 100644
--- a/drivers/iio/accel/bma400_spi.c
+++ b/drivers/iio/accel/bma400_spi.c
@@ -87,11 +87,6 @@ static int bma400_spi_probe(struct spi_device *spi)
 	return bma400_probe(&spi->dev, regmap, id->name);
 }
 
-static void bma400_spi_remove(struct spi_device *spi)
-{
-	bma400_remove(&spi->dev);
-}
-
 static const struct spi_device_id bma400_spi_ids[] = {
 	{ "bma400", 0 },
 	{ }
@@ -110,7 +105,6 @@ static struct spi_driver bma400_spi_driver = {
 		.of_match_table = bma400_of_spi_match,
 	},
 	.probe    = bma400_spi_probe,
-	.remove   = bma400_spi_remove,
 	.id_table = bma400_spi_ids,
 };
 
-- 
2.35.1



