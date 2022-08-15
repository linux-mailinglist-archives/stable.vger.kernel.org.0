Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A399F593932
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244188AbiHOTVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344048AbiHOTTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:19:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F5E5726C;
        Mon, 15 Aug 2022 11:39:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC42861120;
        Mon, 15 Aug 2022 18:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A583AC433D6;
        Mon, 15 Aug 2022 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588788;
        bh=tIJ6+TQwP2JrUVel6DnILhwHXC3k3fA21UUcmj6ctdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxgKrLKkX+nCUIRwcAL2kcLw0iKjM5yYPNXWH49PyAknAu1D7tOUVcDY7TFrnzvSk
         efJVvgHJjOmKINUKpsrY0IxN2AsRJWQbIfMs5ghXBRjic6UqtmhIqMMAroM2QwC1kl
         Dk4jLM8e09HeDb0SBMb6ZkJMp3PSYzrkbTBV49gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 514/779] iio: cros: Register FIFO callback after sensor is registered
Date:   Mon, 15 Aug 2022 20:02:38 +0200
Message-Id: <20220815180359.220571836@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Gwendal Grignou <gwendal@chromium.org>

[ Upstream commit 0b4ae3f6d1210c11f9baf159009c7227eacf90f2 ]

Instead of registering callback to process sensor events right at
initialization time, wait for the sensor to be register in the iio
subsystem.

Events can come at probe time (in case the kernel rebooted abruptly
without switching the sensor off for  instance), and be sent to IIO core
before the sensor is fully registered.

Fixes: aa984f1ba4a4 ("iio: cros_ec: Register to cros_ec_sensorhub when EC supports FIFO")
Reported-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20220711144716.642617-1-gwendal@chromium.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/cros_ec_accel_legacy.c      |  4 +-
 .../cros_ec_sensors/cros_ec_lid_angle.c       |  4 +-
 .../common/cros_ec_sensors/cros_ec_sensors.c  |  6 +-
 .../cros_ec_sensors/cros_ec_sensors_core.c    | 58 ++++++++++++++-----
 drivers/iio/light/cros_ec_light_prox.c        |  6 +-
 drivers/iio/pressure/cros_ec_baro.c           |  6 +-
 .../linux/iio/common/cros_ec_sensors_core.h   |  7 ++-
 7 files changed, 60 insertions(+), 31 deletions(-)

diff --git a/drivers/iio/accel/cros_ec_accel_legacy.c b/drivers/iio/accel/cros_ec_accel_legacy.c
index b6f3471b62dc..3b77fded2dc0 100644
--- a/drivers/iio/accel/cros_ec_accel_legacy.c
+++ b/drivers/iio/accel/cros_ec_accel_legacy.c
@@ -215,7 +215,7 @@ static int cros_ec_accel_legacy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ret = cros_ec_sensors_core_init(pdev, indio_dev, true,
-					cros_ec_sensors_capture, NULL);
+					cros_ec_sensors_capture);
 	if (ret)
 		return ret;
 
@@ -235,7 +235,7 @@ static int cros_ec_accel_legacy_probe(struct platform_device *pdev)
 		state->sign[CROS_EC_SENSOR_Z] = -1;
 	}
 
-	return devm_iio_device_register(dev, indio_dev);
+	return cros_ec_sensors_core_register(dev, indio_dev, NULL);
 }
 
 static struct platform_driver cros_ec_accel_platform_driver = {
diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c b/drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c
index af801e203623..02d3cf36acb0 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c
@@ -97,7 +97,7 @@ static int cros_ec_lid_angle_probe(struct platform_device *pdev)
 	if (!indio_dev)
 		return -ENOMEM;
 
-	ret = cros_ec_sensors_core_init(pdev, indio_dev, false, NULL, NULL);
+	ret = cros_ec_sensors_core_init(pdev, indio_dev, false, NULL);
 	if (ret)
 		return ret;
 
@@ -113,7 +113,7 @@ static int cros_ec_lid_angle_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	return devm_iio_device_register(dev, indio_dev);
+	return cros_ec_sensors_core_register(dev, indio_dev, NULL);
 }
 
 static const struct platform_device_id cros_ec_lid_angle_ids[] = {
diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c
index 376a5b30010a..5cce34fdff02 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c
@@ -235,8 +235,7 @@ static int cros_ec_sensors_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ret = cros_ec_sensors_core_init(pdev, indio_dev, true,
-					cros_ec_sensors_capture,
-					cros_ec_sensors_push_data);
+					cros_ec_sensors_capture);
 	if (ret)
 		return ret;
 
@@ -297,7 +296,8 @@ static int cros_ec_sensors_probe(struct platform_device *pdev)
 	else
 		state->core.read_ec_sensors_data = cros_ec_sensors_read_cmd;
 
-	return devm_iio_device_register(dev, indio_dev);
+	return cros_ec_sensors_core_register(dev, indio_dev,
+			cros_ec_sensors_push_data);
 }
 
 static const struct platform_device_id cros_ec_sensors_ids[] = {
diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
index 28bde13003b7..b0c1dc8cc4c5 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
@@ -234,21 +234,18 @@ static void cros_ec_sensors_core_clean(void *arg)
 
 /**
  * cros_ec_sensors_core_init() - basic initialization of the core structure
- * @pdev:		platform device created for the sensors
+ * @pdev:		platform device created for the sensor
  * @indio_dev:		iio device structure of the device
  * @physical_device:	true if the device refers to a physical device
  * @trigger_capture:    function pointer to call buffer is triggered,
  *    for backward compatibility.
- * @push_data:          function to call when cros_ec_sensorhub receives
- *    a sample for that sensor.
  *
  * Return: 0 on success, -errno on failure.
  */
 int cros_ec_sensors_core_init(struct platform_device *pdev,
 			      struct iio_dev *indio_dev,
 			      bool physical_device,
-			      cros_ec_sensors_capture_t trigger_capture,
-			      cros_ec_sensorhub_push_data_cb_t push_data)
+			      cros_ec_sensors_capture_t trigger_capture)
 {
 	struct device *dev = &pdev->dev;
 	struct cros_ec_sensors_core_state *state = iio_priv(indio_dev);
@@ -339,17 +336,6 @@ int cros_ec_sensors_core_init(struct platform_device *pdev,
 			if (ret)
 				return ret;
 
-			ret = cros_ec_sensorhub_register_push_data(
-					sensor_hub, sensor_platform->sensor_num,
-					indio_dev, push_data);
-			if (ret)
-				return ret;
-
-			ret = devm_add_action_or_reset(
-					dev, cros_ec_sensors_core_clean, pdev);
-			if (ret)
-				return ret;
-
 			/* Timestamp coming from FIFO are in ns since boot. */
 			ret = iio_device_set_clock(indio_dev, CLOCK_BOOTTIME);
 			if (ret)
@@ -371,6 +357,46 @@ int cros_ec_sensors_core_init(struct platform_device *pdev,
 }
 EXPORT_SYMBOL_GPL(cros_ec_sensors_core_init);
 
+/**
+ * cros_ec_sensors_core_register() - Register callback to FIFO and IIO when
+ * sensor is ready.
+ * It must be called at the end of the sensor probe routine.
+ * @dev:		device created for the sensor
+ * @indio_dev:		iio device structure of the device
+ * @push_data:          function to call when cros_ec_sensorhub receives
+ *    a sample for that sensor.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int cros_ec_sensors_core_register(struct device *dev,
+				  struct iio_dev *indio_dev,
+				  cros_ec_sensorhub_push_data_cb_t push_data)
+{
+	struct cros_ec_sensor_platform *sensor_platform = dev_get_platdata(dev);
+	struct cros_ec_sensorhub *sensor_hub = dev_get_drvdata(dev->parent);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct cros_ec_dev *ec = sensor_hub->ec;
+	int ret;
+
+	ret = devm_iio_device_register(dev, indio_dev);
+	if (ret)
+		return ret;
+
+	if (!push_data ||
+	    !cros_ec_check_features(ec, EC_FEATURE_MOTION_SENSE_FIFO))
+		return 0;
+
+	ret = cros_ec_sensorhub_register_push_data(
+			sensor_hub, sensor_platform->sensor_num,
+			indio_dev, push_data);
+	if (ret)
+		return ret;
+
+	return devm_add_action_or_reset(
+			dev, cros_ec_sensors_core_clean, pdev);
+}
+EXPORT_SYMBOL_GPL(cros_ec_sensors_core_register);
+
 /**
  * cros_ec_motion_send_host_cmd() - send motion sense host command
  * @state:		pointer to state information for device
diff --git a/drivers/iio/light/cros_ec_light_prox.c b/drivers/iio/light/cros_ec_light_prox.c
index de472f23d1cb..16b893bae388 100644
--- a/drivers/iio/light/cros_ec_light_prox.c
+++ b/drivers/iio/light/cros_ec_light_prox.c
@@ -181,8 +181,7 @@ static int cros_ec_light_prox_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ret = cros_ec_sensors_core_init(pdev, indio_dev, true,
-					cros_ec_sensors_capture,
-					cros_ec_sensors_push_data);
+					cros_ec_sensors_capture);
 	if (ret)
 		return ret;
 
@@ -240,7 +239,8 @@ static int cros_ec_light_prox_probe(struct platform_device *pdev)
 
 	state->core.read_ec_sensors_data = cros_ec_sensors_read_cmd;
 
-	return devm_iio_device_register(dev, indio_dev);
+	return cros_ec_sensors_core_register(dev, indio_dev,
+					     cros_ec_sensors_push_data);
 }
 
 static const struct platform_device_id cros_ec_light_prox_ids[] = {
diff --git a/drivers/iio/pressure/cros_ec_baro.c b/drivers/iio/pressure/cros_ec_baro.c
index 2f882e109423..0511edbf868d 100644
--- a/drivers/iio/pressure/cros_ec_baro.c
+++ b/drivers/iio/pressure/cros_ec_baro.c
@@ -138,8 +138,7 @@ static int cros_ec_baro_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ret = cros_ec_sensors_core_init(pdev, indio_dev, true,
-					cros_ec_sensors_capture,
-					cros_ec_sensors_push_data);
+					cros_ec_sensors_capture);
 	if (ret)
 		return ret;
 
@@ -186,7 +185,8 @@ static int cros_ec_baro_probe(struct platform_device *pdev)
 
 	state->core.read_ec_sensors_data = cros_ec_sensors_read_cmd;
 
-	return devm_iio_device_register(dev, indio_dev);
+	return cros_ec_sensors_core_register(dev, indio_dev,
+					     cros_ec_sensors_push_data);
 }
 
 static const struct platform_device_id cros_ec_baro_ids[] = {
diff --git a/include/linux/iio/common/cros_ec_sensors_core.h b/include/linux/iio/common/cros_ec_sensors_core.h
index c582e1a14232..7b5dbd749995 100644
--- a/include/linux/iio/common/cros_ec_sensors_core.h
+++ b/include/linux/iio/common/cros_ec_sensors_core.h
@@ -95,8 +95,11 @@ int cros_ec_sensors_read_cmd(struct iio_dev *indio_dev, unsigned long scan_mask,
 struct platform_device;
 int cros_ec_sensors_core_init(struct platform_device *pdev,
 			      struct iio_dev *indio_dev, bool physical_device,
-			      cros_ec_sensors_capture_t trigger_capture,
-			      cros_ec_sensorhub_push_data_cb_t push_data);
+			      cros_ec_sensors_capture_t trigger_capture);
+
+int cros_ec_sensors_core_register(struct device *dev,
+				  struct iio_dev *indio_dev,
+				  cros_ec_sensorhub_push_data_cb_t push_data);
 
 irqreturn_t cros_ec_sensors_capture(int irq, void *p);
 int cros_ec_sensors_push_data(struct iio_dev *indio_dev,
-- 
2.35.1



