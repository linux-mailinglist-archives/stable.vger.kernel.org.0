Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA677452620
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359344AbhKPCCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240011AbhKOSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA2E36326C;
        Mon, 15 Nov 2021 17:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998100;
        bh=Ch2rbR+vG3kQ5vYZ87EmlOLe3mNcEuYrL8A9puRiuwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WQsd78eJeGiBTCQdytmJbpxJklz0Ly5tOPnNQSsiluymHt872x3N/ifQZQzSAYMb
         2kPhPYjFCG1Rqw/i9BJqR84NaWI23Jk3gGT6yNkDNbo3qA/v+YzxO5y/Oll38sdScz
         c9D/nVMqEY24XlzrPz6pVdDSDP8tvIV0jD7qhdDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 386/575] iio: st_sensors: Call st_sensors_power_enable() from bus drivers
Date:   Mon, 15 Nov 2021 18:01:51 +0100
Message-Id: <20211115165357.126783589@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7db4f2cacbede1c6d95552c0d10e77398665a733 ]

In case we would initialize two IIO devices from one physical device,
we shouldn't have a clash on regulators. That's why move
st_sensors_power_enable() call from core to bus drivers.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210414195454.84183-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/st_accel_core.c       | 21 +++++----------------
 drivers/iio/accel/st_accel_i2c.c        | 17 +++++++++++++++--
 drivers/iio/accel/st_accel_spi.c        | 17 +++++++++++++++--
 drivers/iio/gyro/st_gyro_core.c         | 15 +++------------
 drivers/iio/gyro/st_gyro_i2c.c          | 17 +++++++++++++++--
 drivers/iio/gyro/st_gyro_spi.c          | 17 +++++++++++++++--
 drivers/iio/magnetometer/st_magn_core.c | 15 +++------------
 drivers/iio/magnetometer/st_magn_i2c.c  | 14 +++++++++++++-
 drivers/iio/magnetometer/st_magn_spi.c  | 14 +++++++++++++-
 drivers/iio/pressure/st_pressure_core.c | 15 +++------------
 drivers/iio/pressure/st_pressure_i2c.c  | 17 +++++++++++++++--
 drivers/iio/pressure/st_pressure_spi.c  | 17 +++++++++++++++--
 12 files changed, 130 insertions(+), 66 deletions(-)

diff --git a/drivers/iio/accel/st_accel_core.c b/drivers/iio/accel/st_accel_core.c
index 43c50167d220c..bde0ca3ef7a4c 100644
--- a/drivers/iio/accel/st_accel_core.c
+++ b/drivers/iio/accel/st_accel_core.c
@@ -1255,13 +1255,9 @@ int st_accel_common_probe(struct iio_dev *indio_dev)
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &accel_info;
 
-	err = st_sensors_power_enable(indio_dev);
-	if (err)
-		return err;
-
 	err = st_sensors_verify_id(indio_dev);
 	if (err < 0)
-		goto st_accel_power_off;
+		return err;
 
 	adata->num_data_channels = ST_ACCEL_NUMBER_DATA_CHANNELS;
 	indio_dev->num_channels = ST_SENSORS_NUMBER_ALL_CHANNELS;
@@ -1270,10 +1266,8 @@ int st_accel_common_probe(struct iio_dev *indio_dev)
 	channels = devm_kmemdup(&indio_dev->dev,
 				adata->sensor_settings->ch,
 				channels_size, GFP_KERNEL);
-	if (!channels) {
-		err = -ENOMEM;
-		goto st_accel_power_off;
-	}
+	if (!channels)
+		return -ENOMEM;
 
 	if (apply_acpi_orientation(indio_dev, channels))
 		dev_warn(&indio_dev->dev,
@@ -1288,11 +1282,11 @@ int st_accel_common_probe(struct iio_dev *indio_dev)
 
 	err = st_sensors_init_sensor(indio_dev, pdata);
 	if (err < 0)
-		goto st_accel_power_off;
+		return err;
 
 	err = st_accel_allocate_ring(indio_dev);
 	if (err < 0)
-		goto st_accel_power_off;
+		return err;
 
 	if (adata->irq > 0) {
 		err = st_sensors_allocate_trigger(indio_dev,
@@ -1315,9 +1309,6 @@ st_accel_device_register_error:
 		st_sensors_deallocate_trigger(indio_dev);
 st_accel_probe_trigger_error:
 	st_accel_deallocate_ring(indio_dev);
-st_accel_power_off:
-	st_sensors_power_disable(indio_dev);
-
 	return err;
 }
 EXPORT_SYMBOL(st_accel_common_probe);
@@ -1326,8 +1317,6 @@ void st_accel_common_remove(struct iio_dev *indio_dev)
 {
 	struct st_sensor_data *adata = iio_priv(indio_dev);
 
-	st_sensors_power_disable(indio_dev);
-
 	iio_device_unregister(indio_dev);
 	if (adata->irq > 0)
 		st_sensors_deallocate_trigger(indio_dev);
diff --git a/drivers/iio/accel/st_accel_i2c.c b/drivers/iio/accel/st_accel_i2c.c
index 360e16f2cadb9..95e305b88d5ed 100644
--- a/drivers/iio/accel/st_accel_i2c.c
+++ b/drivers/iio/accel/st_accel_i2c.c
@@ -174,16 +174,29 @@ static int st_accel_i2c_probe(struct i2c_client *client)
 	if (ret < 0)
 		return ret;
 
+	ret = st_sensors_power_enable(indio_dev);
+	if (ret)
+		return ret;
+
 	ret = st_accel_common_probe(indio_dev);
 	if (ret < 0)
-		return ret;
+		goto st_accel_power_off;
 
 	return 0;
+
+st_accel_power_off:
+	st_sensors_power_disable(indio_dev);
+
+	return ret;
 }
 
 static int st_accel_i2c_remove(struct i2c_client *client)
 {
-	st_accel_common_remove(i2c_get_clientdata(client));
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+
+	st_sensors_power_disable(indio_dev);
+
+	st_accel_common_remove(indio_dev);
 
 	return 0;
 }
diff --git a/drivers/iio/accel/st_accel_spi.c b/drivers/iio/accel/st_accel_spi.c
index 568ff1bae0eee..83d3308ce5ccc 100644
--- a/drivers/iio/accel/st_accel_spi.c
+++ b/drivers/iio/accel/st_accel_spi.c
@@ -123,16 +123,29 @@ static int st_accel_spi_probe(struct spi_device *spi)
 	if (err < 0)
 		return err;
 
+	err = st_sensors_power_enable(indio_dev);
+	if (err)
+		return err;
+
 	err = st_accel_common_probe(indio_dev);
 	if (err < 0)
-		return err;
+		goto st_accel_power_off;
 
 	return 0;
+
+st_accel_power_off:
+	st_sensors_power_disable(indio_dev);
+
+	return err;
 }
 
 static int st_accel_spi_remove(struct spi_device *spi)
 {
-	st_accel_common_remove(spi_get_drvdata(spi));
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+
+	st_sensors_power_disable(indio_dev);
+
+	st_accel_common_remove(indio_dev);
 
 	return 0;
 }
diff --git a/drivers/iio/gyro/st_gyro_core.c b/drivers/iio/gyro/st_gyro_core.c
index c8aa051995d3b..8c87f85f20bd1 100644
--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -466,13 +466,9 @@ int st_gyro_common_probe(struct iio_dev *indio_dev)
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &gyro_info;
 
-	err = st_sensors_power_enable(indio_dev);
-	if (err)
-		return err;
-
 	err = st_sensors_verify_id(indio_dev);
 	if (err < 0)
-		goto st_gyro_power_off;
+		return err;
 
 	gdata->num_data_channels = ST_GYRO_NUMBER_DATA_CHANNELS;
 	indio_dev->channels = gdata->sensor_settings->ch;
@@ -485,11 +481,11 @@ int st_gyro_common_probe(struct iio_dev *indio_dev)
 
 	err = st_sensors_init_sensor(indio_dev, pdata);
 	if (err < 0)
-		goto st_gyro_power_off;
+		return err;
 
 	err = st_gyro_allocate_ring(indio_dev);
 	if (err < 0)
-		goto st_gyro_power_off;
+		return err;
 
 	if (gdata->irq > 0) {
 		err = st_sensors_allocate_trigger(indio_dev,
@@ -512,9 +508,6 @@ st_gyro_device_register_error:
 		st_sensors_deallocate_trigger(indio_dev);
 st_gyro_probe_trigger_error:
 	st_gyro_deallocate_ring(indio_dev);
-st_gyro_power_off:
-	st_sensors_power_disable(indio_dev);
-
 	return err;
 }
 EXPORT_SYMBOL(st_gyro_common_probe);
@@ -523,8 +516,6 @@ void st_gyro_common_remove(struct iio_dev *indio_dev)
 {
 	struct st_sensor_data *gdata = iio_priv(indio_dev);
 
-	st_sensors_power_disable(indio_dev);
-
 	iio_device_unregister(indio_dev);
 	if (gdata->irq > 0)
 		st_sensors_deallocate_trigger(indio_dev);
diff --git a/drivers/iio/gyro/st_gyro_i2c.c b/drivers/iio/gyro/st_gyro_i2c.c
index 8190966e6ff0a..a25cc0379e163 100644
--- a/drivers/iio/gyro/st_gyro_i2c.c
+++ b/drivers/iio/gyro/st_gyro_i2c.c
@@ -86,16 +86,29 @@ static int st_gyro_i2c_probe(struct i2c_client *client,
 	if (err < 0)
 		return err;
 
+	err = st_sensors_power_enable(indio_dev);
+	if (err)
+		return err;
+
 	err = st_gyro_common_probe(indio_dev);
 	if (err < 0)
-		return err;
+		goto st_gyro_power_off;
 
 	return 0;
+
+st_gyro_power_off:
+	st_sensors_power_disable(indio_dev);
+
+	return err;
 }
 
 static int st_gyro_i2c_remove(struct i2c_client *client)
 {
-	st_gyro_common_remove(i2c_get_clientdata(client));
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+
+	st_sensors_power_disable(indio_dev);
+
+	st_gyro_common_remove(indio_dev);
 
 	return 0;
 }
diff --git a/drivers/iio/gyro/st_gyro_spi.c b/drivers/iio/gyro/st_gyro_spi.c
index efb862763ca3d..18d6a2aeda45a 100644
--- a/drivers/iio/gyro/st_gyro_spi.c
+++ b/drivers/iio/gyro/st_gyro_spi.c
@@ -90,16 +90,29 @@ static int st_gyro_spi_probe(struct spi_device *spi)
 	if (err < 0)
 		return err;
 
+	err = st_sensors_power_enable(indio_dev);
+	if (err)
+		return err;
+
 	err = st_gyro_common_probe(indio_dev);
 	if (err < 0)
-		return err;
+		goto st_gyro_power_off;
 
 	return 0;
+
+st_gyro_power_off:
+	st_sensors_power_disable(indio_dev);
+
+	return err;
 }
 
 static int st_gyro_spi_remove(struct spi_device *spi)
 {
-	st_gyro_common_remove(spi_get_drvdata(spi));
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+
+	st_sensors_power_disable(indio_dev);
+
+	st_gyro_common_remove(indio_dev);
 
 	return 0;
 }
diff --git a/drivers/iio/magnetometer/st_magn_core.c b/drivers/iio/magnetometer/st_magn_core.c
index 79de721e60159..0fc38f17dbe04 100644
--- a/drivers/iio/magnetometer/st_magn_core.c
+++ b/drivers/iio/magnetometer/st_magn_core.c
@@ -494,13 +494,9 @@ int st_magn_common_probe(struct iio_dev *indio_dev)
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &magn_info;
 
-	err = st_sensors_power_enable(indio_dev);
-	if (err)
-		return err;
-
 	err = st_sensors_verify_id(indio_dev);
 	if (err < 0)
-		goto st_magn_power_off;
+		return err;
 
 	mdata->num_data_channels = ST_MAGN_NUMBER_DATA_CHANNELS;
 	indio_dev->channels = mdata->sensor_settings->ch;
@@ -511,11 +507,11 @@ int st_magn_common_probe(struct iio_dev *indio_dev)
 
 	err = st_sensors_init_sensor(indio_dev, NULL);
 	if (err < 0)
-		goto st_magn_power_off;
+		return err;
 
 	err = st_magn_allocate_ring(indio_dev);
 	if (err < 0)
-		goto st_magn_power_off;
+		return err;
 
 	if (mdata->irq > 0) {
 		err = st_sensors_allocate_trigger(indio_dev,
@@ -538,9 +534,6 @@ st_magn_device_register_error:
 		st_sensors_deallocate_trigger(indio_dev);
 st_magn_probe_trigger_error:
 	st_magn_deallocate_ring(indio_dev);
-st_magn_power_off:
-	st_sensors_power_disable(indio_dev);
-
 	return err;
 }
 EXPORT_SYMBOL(st_magn_common_probe);
@@ -549,8 +542,6 @@ void st_magn_common_remove(struct iio_dev *indio_dev)
 {
 	struct st_sensor_data *mdata = iio_priv(indio_dev);
 
-	st_sensors_power_disable(indio_dev);
-
 	iio_device_unregister(indio_dev);
 	if (mdata->irq > 0)
 		st_sensors_deallocate_trigger(indio_dev);
diff --git a/drivers/iio/magnetometer/st_magn_i2c.c b/drivers/iio/magnetometer/st_magn_i2c.c
index c6bb4ce775943..7a7ab27379fc1 100644
--- a/drivers/iio/magnetometer/st_magn_i2c.c
+++ b/drivers/iio/magnetometer/st_magn_i2c.c
@@ -78,16 +78,28 @@ static int st_magn_i2c_probe(struct i2c_client *client,
 	if (err < 0)
 		return err;
 
+	err = st_sensors_power_enable(indio_dev);
+	if (err)
+		return err;
+
 	err = st_magn_common_probe(indio_dev);
 	if (err < 0)
-		return err;
+		goto st_magn_power_off;
 
 	return 0;
+
+st_magn_power_off:
+	st_sensors_power_disable(indio_dev);
+
+	return err;
 }
 
 static int st_magn_i2c_remove(struct i2c_client *client)
 {
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+
+	st_sensors_power_disable(indio_dev);
+
 	st_magn_common_remove(indio_dev);
 
 	return 0;
diff --git a/drivers/iio/magnetometer/st_magn_spi.c b/drivers/iio/magnetometer/st_magn_spi.c
index 3d08d74c367da..ee352f083c020 100644
--- a/drivers/iio/magnetometer/st_magn_spi.c
+++ b/drivers/iio/magnetometer/st_magn_spi.c
@@ -72,16 +72,28 @@ static int st_magn_spi_probe(struct spi_device *spi)
 	if (err < 0)
 		return err;
 
+	err = st_sensors_power_enable(indio_dev);
+	if (err)
+		return err;
+
 	err = st_magn_common_probe(indio_dev);
 	if (err < 0)
-		return err;
+		goto st_magn_power_off;
 
 	return 0;
+
+st_magn_power_off:
+	st_sensors_power_disable(indio_dev);
+
+	return err;
 }
 
 static int st_magn_spi_remove(struct spi_device *spi)
 {
 	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+
+	st_sensors_power_disable(indio_dev);
+
 	st_magn_common_remove(indio_dev);
 
 	return 0;
diff --git a/drivers/iio/pressure/st_pressure_core.c b/drivers/iio/pressure/st_pressure_core.c
index 789a2928504a7..7912b5a683955 100644
--- a/drivers/iio/pressure/st_pressure_core.c
+++ b/drivers/iio/pressure/st_pressure_core.c
@@ -689,13 +689,9 @@ int st_press_common_probe(struct iio_dev *indio_dev)
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &press_info;
 
-	err = st_sensors_power_enable(indio_dev);
-	if (err)
-		return err;
-
 	err = st_sensors_verify_id(indio_dev);
 	if (err < 0)
-		goto st_press_power_off;
+		return err;
 
 	/*
 	 * Skip timestamping channel while declaring available channels to
@@ -718,11 +714,11 @@ int st_press_common_probe(struct iio_dev *indio_dev)
 
 	err = st_sensors_init_sensor(indio_dev, pdata);
 	if (err < 0)
-		goto st_press_power_off;
+		return err;
 
 	err = st_press_allocate_ring(indio_dev);
 	if (err < 0)
-		goto st_press_power_off;
+		return err;
 
 	if (press_data->irq > 0) {
 		err = st_sensors_allocate_trigger(indio_dev,
@@ -745,9 +741,6 @@ st_press_device_register_error:
 		st_sensors_deallocate_trigger(indio_dev);
 st_press_probe_trigger_error:
 	st_press_deallocate_ring(indio_dev);
-st_press_power_off:
-	st_sensors_power_disable(indio_dev);
-
 	return err;
 }
 EXPORT_SYMBOL(st_press_common_probe);
@@ -756,8 +749,6 @@ void st_press_common_remove(struct iio_dev *indio_dev)
 {
 	struct st_sensor_data *press_data = iio_priv(indio_dev);
 
-	st_sensors_power_disable(indio_dev);
-
 	iio_device_unregister(indio_dev);
 	if (press_data->irq > 0)
 		st_sensors_deallocate_trigger(indio_dev);
diff --git a/drivers/iio/pressure/st_pressure_i2c.c b/drivers/iio/pressure/st_pressure_i2c.c
index 09c6903f99b87..f0a5af314ceb8 100644
--- a/drivers/iio/pressure/st_pressure_i2c.c
+++ b/drivers/iio/pressure/st_pressure_i2c.c
@@ -98,16 +98,29 @@ static int st_press_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
+	ret = st_sensors_power_enable(indio_dev);
+	if (ret)
+		return ret;
+
 	ret = st_press_common_probe(indio_dev);
 	if (ret < 0)
-		return ret;
+		goto st_press_power_off;
 
 	return 0;
+
+st_press_power_off:
+	st_sensors_power_disable(indio_dev);
+
+	return ret;
 }
 
 static int st_press_i2c_remove(struct i2c_client *client)
 {
-	st_press_common_remove(i2c_get_clientdata(client));
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+
+	st_sensors_power_disable(indio_dev);
+
+	st_press_common_remove(indio_dev);
 
 	return 0;
 }
diff --git a/drivers/iio/pressure/st_pressure_spi.c b/drivers/iio/pressure/st_pressure_spi.c
index b5ee3ec2764ff..b48cf7d01cd74 100644
--- a/drivers/iio/pressure/st_pressure_spi.c
+++ b/drivers/iio/pressure/st_pressure_spi.c
@@ -82,16 +82,29 @@ static int st_press_spi_probe(struct spi_device *spi)
 	if (err < 0)
 		return err;
 
+	err = st_sensors_power_enable(indio_dev);
+	if (err)
+		return err;
+
 	err = st_press_common_probe(indio_dev);
 	if (err < 0)
-		return err;
+		goto st_press_power_off;
 
 	return 0;
+
+st_press_power_off:
+	st_sensors_power_disable(indio_dev);
+
+	return err;
 }
 
 static int st_press_spi_remove(struct spi_device *spi)
 {
-	st_press_common_remove(spi_get_drvdata(spi));
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+
+	st_sensors_power_disable(indio_dev);
+
+	st_press_common_remove(indio_dev);
 
 	return 0;
 }
-- 
2.33.0



