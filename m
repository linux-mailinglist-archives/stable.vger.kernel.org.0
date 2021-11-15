Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EC5451414
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348957AbhKOUBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344213AbhKOTYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BDF0633A6;
        Mon, 15 Nov 2021 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002439;
        bh=Pun2I+wOETOE5U02UVJALEiRc2VEEVcsmE1ckW3AD/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nMYpchHVs6Vlm+N+y30UvwN25PLhuW35c7H1DKbLj/YftTt8qJETUMOSpVwk4oRv
         XAqujfALYXdIXRsUDzdrneiokgQ2h1KPU4EECIiui+d1FBaCegVZCBEGp7dPDY3UCd
         Xp40/Hdv29n4twgXpe3kXj9Ejn4iCLEUJJ0Os1oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Denis CIOCCA <denis.ciocca@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alexandru Ardelean <aardelean@deviqon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 568/917] iio: st_sensors: disable regulators after device unregistration
Date:   Mon, 15 Nov 2021 18:01:03 +0100
Message-Id: <20211115165448.047098725@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <aardelean@deviqon.com>

[ Upstream commit 9f0b3e0cc0c88618aa9e5cecef747b1337ae0a5d ]

Up until commit ea7e586bdd331 ("iio: st_sensors: move regulator retrieveal
to core") only the ST pressure driver seems to have had any regulator
disable. After that commit, the regulator handling was moved into the
common st_sensors logic.

In all instances of this regulator handling, the regulators were disabled
before unregistering the IIO device.
This can cause issues where the device would be powered down and still be
available to userspace, allowing it to send invalid/garbage data.

This change moves the st_sensors_power_disable() after the common probe
functions. These common probe functions also handle unregistering the IIO
device.

Fixes: 774487611c949 ("iio: pressure-core: st: Provide support for the Vdd power supply")
Fixes: ea7e586bdd331 ("iio: st_sensors: move regulator retrieveal to core")
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Denis CIOCCA <denis.ciocca@st.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Alexandru Ardelean <aardelean@deviqon.com>
Link: https://lore.kernel.org/r/20210823112204.243255-2-aardelean@deviqon.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/st_accel_i2c.c       | 4 ++--
 drivers/iio/accel/st_accel_spi.c       | 4 ++--
 drivers/iio/gyro/st_gyro_i2c.c         | 4 ++--
 drivers/iio/gyro/st_gyro_spi.c         | 4 ++--
 drivers/iio/magnetometer/st_magn_i2c.c | 4 ++--
 drivers/iio/magnetometer/st_magn_spi.c | 4 ++--
 drivers/iio/pressure/st_pressure_i2c.c | 4 ++--
 drivers/iio/pressure/st_pressure_spi.c | 4 ++--
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/iio/accel/st_accel_i2c.c b/drivers/iio/accel/st_accel_i2c.c
index f711756e41e3d..cba57459e90ab 100644
--- a/drivers/iio/accel/st_accel_i2c.c
+++ b/drivers/iio/accel/st_accel_i2c.c
@@ -193,10 +193,10 @@ static int st_accel_i2c_remove(struct i2c_client *client)
 {
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
 
-	st_sensors_power_disable(indio_dev);
-
 	st_accel_common_remove(indio_dev);
 
+	st_sensors_power_disable(indio_dev);
+
 	return 0;
 }
 
diff --git a/drivers/iio/accel/st_accel_spi.c b/drivers/iio/accel/st_accel_spi.c
index bb45d9ff95b85..5167fae1ee8ec 100644
--- a/drivers/iio/accel/st_accel_spi.c
+++ b/drivers/iio/accel/st_accel_spi.c
@@ -143,10 +143,10 @@ static int st_accel_spi_remove(struct spi_device *spi)
 {
 	struct iio_dev *indio_dev = spi_get_drvdata(spi);
 
-	st_sensors_power_disable(indio_dev);
-
 	st_accel_common_remove(indio_dev);
 
+	st_sensors_power_disable(indio_dev);
+
 	return 0;
 }
 
diff --git a/drivers/iio/gyro/st_gyro_i2c.c b/drivers/iio/gyro/st_gyro_i2c.c
index 3ef86e16ee656..a8164fe48b857 100644
--- a/drivers/iio/gyro/st_gyro_i2c.c
+++ b/drivers/iio/gyro/st_gyro_i2c.c
@@ -106,10 +106,10 @@ static int st_gyro_i2c_remove(struct i2c_client *client)
 {
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
 
-	st_sensors_power_disable(indio_dev);
-
 	st_gyro_common_remove(indio_dev);
 
+	st_sensors_power_disable(indio_dev);
+
 	return 0;
 }
 
diff --git a/drivers/iio/gyro/st_gyro_spi.c b/drivers/iio/gyro/st_gyro_spi.c
index 41d835493347c..9d8916871b4bf 100644
--- a/drivers/iio/gyro/st_gyro_spi.c
+++ b/drivers/iio/gyro/st_gyro_spi.c
@@ -110,10 +110,10 @@ static int st_gyro_spi_remove(struct spi_device *spi)
 {
 	struct iio_dev *indio_dev = spi_get_drvdata(spi);
 
-	st_sensors_power_disable(indio_dev);
-
 	st_gyro_common_remove(indio_dev);
 
+	st_sensors_power_disable(indio_dev);
+
 	return 0;
 }
 
diff --git a/drivers/iio/magnetometer/st_magn_i2c.c b/drivers/iio/magnetometer/st_magn_i2c.c
index 2dfe4ee99591b..fa78f0a3b53ea 100644
--- a/drivers/iio/magnetometer/st_magn_i2c.c
+++ b/drivers/iio/magnetometer/st_magn_i2c.c
@@ -102,10 +102,10 @@ static int st_magn_i2c_remove(struct i2c_client *client)
 {
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
 
-	st_sensors_power_disable(indio_dev);
-
 	st_magn_common_remove(indio_dev);
 
+	st_sensors_power_disable(indio_dev);
+
 	return 0;
 }
 
diff --git a/drivers/iio/magnetometer/st_magn_spi.c b/drivers/iio/magnetometer/st_magn_spi.c
index fba9787963952..ff43cbf61b056 100644
--- a/drivers/iio/magnetometer/st_magn_spi.c
+++ b/drivers/iio/magnetometer/st_magn_spi.c
@@ -96,10 +96,10 @@ static int st_magn_spi_remove(struct spi_device *spi)
 {
 	struct iio_dev *indio_dev = spi_get_drvdata(spi);
 
-	st_sensors_power_disable(indio_dev);
-
 	st_magn_common_remove(indio_dev);
 
+	st_sensors_power_disable(indio_dev);
+
 	return 0;
 }
 
diff --git a/drivers/iio/pressure/st_pressure_i2c.c b/drivers/iio/pressure/st_pressure_i2c.c
index 52fa98f24478d..6215de677017e 100644
--- a/drivers/iio/pressure/st_pressure_i2c.c
+++ b/drivers/iio/pressure/st_pressure_i2c.c
@@ -119,10 +119,10 @@ static int st_press_i2c_remove(struct i2c_client *client)
 {
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
 
-	st_sensors_power_disable(indio_dev);
-
 	st_press_common_remove(indio_dev);
 
+	st_sensors_power_disable(indio_dev);
+
 	return 0;
 }
 
diff --git a/drivers/iio/pressure/st_pressure_spi.c b/drivers/iio/pressure/st_pressure_spi.c
index ee393df54cee8..5001aae8f00b8 100644
--- a/drivers/iio/pressure/st_pressure_spi.c
+++ b/drivers/iio/pressure/st_pressure_spi.c
@@ -102,10 +102,10 @@ static int st_press_spi_remove(struct spi_device *spi)
 {
 	struct iio_dev *indio_dev = spi_get_drvdata(spi);
 
-	st_sensors_power_disable(indio_dev);
-
 	st_press_common_remove(indio_dev);
 
+	st_sensors_power_disable(indio_dev);
+
 	return 0;
 }
 
-- 
2.33.0



