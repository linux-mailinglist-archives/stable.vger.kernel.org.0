Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F4B3837C6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbhEQPrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344641AbhEQPpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F24161D2E;
        Mon, 17 May 2021 14:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262618;
        bh=mzsU1CQrvZHJ0e7CBcbD0RS4Hng9O4NgK9FM1TEF3rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgiBSoVkCJ4G2L+nTfwXw3APZD932BTZ4KCXDEra8RtNAaakxs6pjR9WNkBsnK4ex
         wcMQmjJQ6/VKuWQqALU+UCliTCPZD8Dt4F+9jMwgheGs/Ln4ujnV8mRTtCiCGsGNO/
         cBbXCgziTfSBF+loQpAH4095ij/Bzt8tN0Yd2I5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Deutschmann <whissi@gentoo.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Alexandru Ardelean <aardelean@deviqon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/289] iio: hid-sensors: select IIO_TRIGGERED_BUFFER under HID_SENSOR_IIO_TRIGGER
Date:   Mon, 17 May 2021 16:02:30 +0200
Message-Id: <20210517140312.740260599@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <aardelean@deviqon.com>

[ Upstream commit 7061803522ee7876df1ca18cdd1e1551f761352d ]

During commit 067fda1c065ff ("iio: hid-sensors: move triggered buffer
setup into hid_sensor_setup_trigger"), the
iio_triggered_buffer_{setup,cleanup}() functions got moved under the
hid-sensor-trigger module.

The above change works fine, if any of the sensors get built. However, when
only the common hid-sensor-trigger module gets built (and none of the
drivers), then the IIO_TRIGGERED_BUFFER symbol isn't selected/enforced.

Previously, each driver would enforce/select the IIO_TRIGGERED_BUFFER
symbol. With this change the HID_SENSOR_IIO_TRIGGER (for the
hid-sensor-trigger module) will enforce that IIO_TRIGGERED_BUFFER gets
selected.

All HID sensor drivers select the HID_SENSOR_IIO_TRIGGER symbol. So, this
change removes the IIO_TRIGGERED_BUFFER enforcement from each driver.

Fixes: 067fda1c065ff ("iio: hid-sensors: move triggered buffer setup into hid_sensor_setup_trigger")
Reported-by: Thomas Deutschmann <whissi@gentoo.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Alexandru Ardelean <aardelean@deviqon.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20210414084955.260117-1-aardelean@deviqon.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/Kconfig              | 1 -
 drivers/iio/common/hid-sensors/Kconfig | 1 +
 drivers/iio/gyro/Kconfig               | 1 -
 drivers/iio/humidity/Kconfig           | 1 -
 drivers/iio/light/Kconfig              | 2 --
 drivers/iio/magnetometer/Kconfig       | 1 -
 drivers/iio/orientation/Kconfig        | 2 --
 drivers/iio/pressure/Kconfig           | 1 -
 drivers/iio/temperature/Kconfig        | 1 -
 9 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
index 2e0c62c39155..8acf277b8b25 100644
--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -211,7 +211,6 @@ config DMARD10
 config HID_SENSOR_ACCEL_3D
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID Accelerometers 3D"
diff --git a/drivers/iio/common/hid-sensors/Kconfig b/drivers/iio/common/hid-sensors/Kconfig
index 24d492567336..2a3dd3b907be 100644
--- a/drivers/iio/common/hid-sensors/Kconfig
+++ b/drivers/iio/common/hid-sensors/Kconfig
@@ -19,6 +19,7 @@ config HID_SENSOR_IIO_TRIGGER
 	tristate "Common module (trigger) for all HID Sensor IIO drivers"
 	depends on HID_SENSOR_HUB && HID_SENSOR_IIO_COMMON && IIO_BUFFER
 	select IIO_TRIGGER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build trigger support for HID sensors.
 	  Triggers will be send if all requested attributes were read.
diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
index 5824f2edf975..20b5ac7ab66a 100644
--- a/drivers/iio/gyro/Kconfig
+++ b/drivers/iio/gyro/Kconfig
@@ -111,7 +111,6 @@ config FXAS21002C_SPI
 config HID_SENSOR_GYRO_3D
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID Gyroscope 3D"
diff --git a/drivers/iio/humidity/Kconfig b/drivers/iio/humidity/Kconfig
index 6549fcf6db69..2de5494e7c22 100644
--- a/drivers/iio/humidity/Kconfig
+++ b/drivers/iio/humidity/Kconfig
@@ -52,7 +52,6 @@ config HID_SENSOR_HUMIDITY
 	tristate "HID Environmental humidity sensor"
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	help
diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index 33ad4dd0b5c7..917f9becf9c7 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -256,7 +256,6 @@ config ISL29125
 config HID_SENSOR_ALS
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID ALS"
@@ -270,7 +269,6 @@ config HID_SENSOR_ALS
 config HID_SENSOR_PROX
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID PROX"
diff --git a/drivers/iio/magnetometer/Kconfig b/drivers/iio/magnetometer/Kconfig
index 1697a8c03506..7e9489a35571 100644
--- a/drivers/iio/magnetometer/Kconfig
+++ b/drivers/iio/magnetometer/Kconfig
@@ -95,7 +95,6 @@ config MAG3110
 config HID_SENSOR_MAGNETOMETER_3D
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID Magenetometer 3D"
diff --git a/drivers/iio/orientation/Kconfig b/drivers/iio/orientation/Kconfig
index a505583cc2fd..396cbbb867f4 100644
--- a/drivers/iio/orientation/Kconfig
+++ b/drivers/iio/orientation/Kconfig
@@ -9,7 +9,6 @@ menu "Inclinometer sensors"
 config HID_SENSOR_INCLINOMETER_3D
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID Inclinometer 3D"
@@ -20,7 +19,6 @@ config HID_SENSOR_INCLINOMETER_3D
 config HID_SENSOR_DEVICE_ROTATION
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID Device Rotation"
diff --git a/drivers/iio/pressure/Kconfig b/drivers/iio/pressure/Kconfig
index 689b978db4f9..fc0d3cfca418 100644
--- a/drivers/iio/pressure/Kconfig
+++ b/drivers/iio/pressure/Kconfig
@@ -79,7 +79,6 @@ config DPS310
 config HID_SENSOR_PRESS
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	tristate "HID PRESS"
diff --git a/drivers/iio/temperature/Kconfig b/drivers/iio/temperature/Kconfig
index f1f2a1499c9e..4df60082c1fa 100644
--- a/drivers/iio/temperature/Kconfig
+++ b/drivers/iio/temperature/Kconfig
@@ -45,7 +45,6 @@ config HID_SENSOR_TEMP
 	tristate "HID Environmental temperature sensor"
 	depends on HID_SENSOR_HUB
 	select IIO_BUFFER
-	select IIO_TRIGGERED_BUFFER
 	select HID_SENSOR_IIO_COMMON
 	select HID_SENSOR_IIO_TRIGGER
 	help
-- 
2.30.2



