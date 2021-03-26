Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E62534B150
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 22:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhCZV2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 17:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCZV2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Mar 2021 17:28:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1A4C0613AA
        for <stable@vger.kernel.org>; Fri, 26 Mar 2021 14:28:38 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so3075795pjg.5
        for <stable@vger.kernel.org>; Fri, 26 Mar 2021 14:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5V8iAlwvsAzldY1s3tib/9Q19sEa+gv4KTAqeL8Na8=;
        b=iiM1ds9oT4j/H6CFJvCKMAUT3iEPPg5pJpMR7KPd1vcYZ5+pKIWbHXmsZvbXAz9yTl
         U0vK3sZ/J3U/SwBz2pjmVOd9CKKw7z2KtaYVOpgXOPWO2Lu7rofOHbh0B7f9gFha6oV7
         HWrz4YsC19Fs+ki9qE9euaD9RkC16x5t+OqbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5V8iAlwvsAzldY1s3tib/9Q19sEa+gv4KTAqeL8Na8=;
        b=ZqxgotQCfFZOjHzV5W2+YVS0gefnWYCYmlBQ1fOgiUqHtvwmSInWdL6BfG+Ijwnz0B
         2L2mU/IOvCYwdONDp6hpVMTFe0Jl0oVJhe1hv3WdS+ozV5XuXCQS0HpPZgB6Y2MlgKmG
         EkqX7F53jTQpL3XUfeY2wI5c+lbeCNH7AxmgkZ+gZE/breaW/r8lx1Xc2M3BLPF2sMfh
         xXCGmJus8fP5KN0L8eEmWeub8ssxDcRG3GrUyROlvelyLm9lMq/Ioh14brlGmF7N18q3
         2Lse+2c2ppgkQ0Az29iECeeEVbBK3IZa96m2aY7zjSGaPM9jywk9cwCOHrMrAi5MIQwI
         EUAg==
X-Gm-Message-State: AOAM533hlIAUnqftmdc9LEU1LD/Q7CyaBCR+5LFEh0USBQGK7uUaEJnZ
        W5xdftBoT+H+gZtAzhVCNfAJpfI0MbOMpw==
X-Google-Smtp-Source: ABdhPJxtk2gHlNfG4W1vgUmxbXTwVsAxnsj+gA1s8MwMGZ8oCUH7JhlegGnF2xC+fp09eoffDEgv/w==
X-Received: by 2002:a17:902:8482:b029:e6:325b:5542 with SMTP id c2-20020a1709028482b02900e6325b5542mr17357424plo.70.1616794117587;
        Fri, 26 Mar 2021 14:28:37 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:e071:1f4b:7e7:f3c7])
        by smtp.gmail.com with UTF8SMTPSA id i22sm9024742pjz.56.2021.03.26.14.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 14:28:36 -0700 (PDT)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     Jonathan.Cameron@huawei.com, ardeleanalex@gmail.com,
        andy.shevchenko@gmail.com, groeck@chromium.org
Cc:     linux-iio@vger.kernel.org, stable@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH] Revert "iio: cros_ec: unify hw fifo attributes into the core file"
Date:   Fri, 26 Mar 2021 14:28:23 -0700
Message-Id: <20210326212823.386611-1-gwendal@chromium.org>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 2e2366c2d14193d3b95bab1fb484a9377224962b.

In linux 5.10, commit 2e2366c2d141 ("iio: cros_ec: unify hw fifo attributes into the core file")
centralizes iio_buffer_set_attrs() calls at one location
(cros_ec_sensors_core_init()) to simplify removal of that function in
subsequent commits (commit 165aea80e2e2 ("iio: cros_ec: use devm_iio_triggered_buffer_setup_ext()")
and commit 21232b4456ba ("iio: buffer: remove iio_buffer_set_attrs() helper")).

However the commit is not right as it set buffer extended attributes
at the wrong place.

Given the subsequent commits are not in 5.10 (only 5.12 and later) and
they are part of an overhaul that is unlikely to be back-ported in
-stable, it is safe to revert the commit.

For reference, commit b2871606c9ca9 ("iio: cros: unify hw fifo attributes without API changes")
addresses the issue for the upstream kernel.

Cc: <stable@vger.kernel.org> # 5.10.y
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 drivers/iio/accel/cros_ec_accel_legacy.c              |  2 +-
 .../iio/common/cros_ec_sensors/cros_ec_lid_angle.c    |  3 +--
 drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c  |  5 +++--
 .../iio/common/cros_ec_sensors/cros_ec_sensors_core.c | 11 +++--------
 drivers/iio/light/cros_ec_light_prox.c                |  5 +++--
 drivers/iio/pressure/cros_ec_baro.c                   |  5 +++--
 include/linux/iio/common/cros_ec_sensors_core.h       |  4 ++--
 7 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/iio/accel/cros_ec_accel_legacy.c b/drivers/iio/accel/cros_ec_accel_legacy.c
index 8f1232c38e0d7..b6f3471b62dcf 100644
--- a/drivers/iio/accel/cros_ec_accel_legacy.c
+++ b/drivers/iio/accel/cros_ec_accel_legacy.c
@@ -215,7 +215,7 @@ static int cros_ec_accel_legacy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ret = cros_ec_sensors_core_init(pdev, indio_dev, true,
-					cros_ec_sensors_capture, NULL, false);
+					cros_ec_sensors_capture, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c b/drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c
index 752f59037715b..af801e203623e 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.c
@@ -97,8 +97,7 @@ static int cros_ec_lid_angle_probe(struct platform_device *pdev)
 	if (!indio_dev)
 		return -ENOMEM;
 
-	ret = cros_ec_sensors_core_init(pdev, indio_dev, false, NULL,
-					NULL, false);
+	ret = cros_ec_sensors_core_init(pdev, indio_dev, false, NULL, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c
index dee1191de7528..d71e9064c7896 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors.c
@@ -236,11 +236,12 @@ static int cros_ec_sensors_probe(struct platform_device *pdev)
 
 	ret = cros_ec_sensors_core_init(pdev, indio_dev, true,
 					cros_ec_sensors_capture,
-					cros_ec_sensors_push_data,
-					true);
+					cros_ec_sensors_push_data);
 	if (ret)
 		return ret;
 
+	iio_buffer_set_attrs(indio_dev->buffer, cros_ec_sensor_fifo_attributes);
+
 	indio_dev->info = &ec_sensors_info;
 	state = iio_priv(indio_dev);
 	for (channel = state->channels, i = CROS_EC_SENSOR_X;
diff --git a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
index e3f507771f17e..90c1a1f757b4b 100644
--- a/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
+++ b/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.c
@@ -177,11 +177,12 @@ static ssize_t hwfifo_watermark_max_show(struct device *dev,
 
 static IIO_DEVICE_ATTR_RO(hwfifo_watermark_max, 0);
 
-static const struct attribute *cros_ec_sensor_fifo_attributes[] = {
+const struct attribute *cros_ec_sensor_fifo_attributes[] = {
 	&iio_dev_attr_hwfifo_timeout.dev_attr.attr,
 	&iio_dev_attr_hwfifo_watermark_max.dev_attr.attr,
 	NULL,
 };
+EXPORT_SYMBOL_GPL(cros_ec_sensor_fifo_attributes);
 
 int cros_ec_sensors_push_data(struct iio_dev *indio_dev,
 			      s16 *data,
@@ -240,7 +241,6 @@ static void cros_ec_sensors_core_clean(void *arg)
  *    for backward compatibility.
  * @push_data:          function to call when cros_ec_sensorhub receives
  *    a sample for that sensor.
- * @has_hw_fifo:	Set true if this device has/uses a HW FIFO
  *
  * Return: 0 on success, -errno on failure.
  */
@@ -248,8 +248,7 @@ int cros_ec_sensors_core_init(struct platform_device *pdev,
 			      struct iio_dev *indio_dev,
 			      bool physical_device,
 			      cros_ec_sensors_capture_t trigger_capture,
-			      cros_ec_sensorhub_push_data_cb_t push_data,
-			      bool has_hw_fifo)
+			      cros_ec_sensorhub_push_data_cb_t push_data)
 {
 	struct device *dev = &pdev->dev;
 	struct cros_ec_sensors_core_state *state = iio_priv(indio_dev);
@@ -368,10 +367,6 @@ int cros_ec_sensors_core_init(struct platform_device *pdev,
 					NULL);
 			if (ret)
 				return ret;
-
-			if (has_hw_fifo)
-				iio_buffer_set_attrs(indio_dev->buffer,
-						     cros_ec_sensor_fifo_attributes);
 		}
 	}
 
diff --git a/drivers/iio/light/cros_ec_light_prox.c b/drivers/iio/light/cros_ec_light_prox.c
index 75d6b5fcf2cc4..fed79ba27fda5 100644
--- a/drivers/iio/light/cros_ec_light_prox.c
+++ b/drivers/iio/light/cros_ec_light_prox.c
@@ -182,11 +182,12 @@ static int cros_ec_light_prox_probe(struct platform_device *pdev)
 
 	ret = cros_ec_sensors_core_init(pdev, indio_dev, true,
 					cros_ec_sensors_capture,
-					cros_ec_sensors_push_data,
-					true);
+					cros_ec_sensors_push_data);
 	if (ret)
 		return ret;
 
+	iio_buffer_set_attrs(indio_dev->buffer, cros_ec_sensor_fifo_attributes);
+
 	indio_dev->info = &cros_ec_light_prox_info;
 	state = iio_priv(indio_dev);
 	state->core.type = state->core.resp->info.type;
diff --git a/drivers/iio/pressure/cros_ec_baro.c b/drivers/iio/pressure/cros_ec_baro.c
index aa043cb9ac426..f0938b6fbba07 100644
--- a/drivers/iio/pressure/cros_ec_baro.c
+++ b/drivers/iio/pressure/cros_ec_baro.c
@@ -139,11 +139,12 @@ static int cros_ec_baro_probe(struct platform_device *pdev)
 
 	ret = cros_ec_sensors_core_init(pdev, indio_dev, true,
 					cros_ec_sensors_capture,
-					cros_ec_sensors_push_data,
-					true);
+					cros_ec_sensors_push_data);
 	if (ret)
 		return ret;
 
+	iio_buffer_set_attrs(indio_dev->buffer, cros_ec_sensor_fifo_attributes);
+
 	indio_dev->info = &cros_ec_baro_info;
 	state = iio_priv(indio_dev);
 	state->core.type = state->core.resp->info.type;
diff --git a/include/linux/iio/common/cros_ec_sensors_core.h b/include/linux/iio/common/cros_ec_sensors_core.h
index c9b80be82440f..caa8bb279a346 100644
--- a/include/linux/iio/common/cros_ec_sensors_core.h
+++ b/include/linux/iio/common/cros_ec_sensors_core.h
@@ -96,8 +96,7 @@ struct platform_device;
 int cros_ec_sensors_core_init(struct platform_device *pdev,
 			      struct iio_dev *indio_dev, bool physical_device,
 			      cros_ec_sensors_capture_t trigger_capture,
-			      cros_ec_sensorhub_push_data_cb_t push_data,
-			      bool has_hw_fifo);
+			      cros_ec_sensorhub_push_data_cb_t push_data);
 
 irqreturn_t cros_ec_sensors_capture(int irq, void *p);
 int cros_ec_sensors_push_data(struct iio_dev *indio_dev,
@@ -126,5 +125,6 @@ extern const struct dev_pm_ops cros_ec_sensors_pm_ops;
 
 /* List of extended channel specification for all sensors. */
 extern const struct iio_chan_spec_ext_info cros_ec_sensors_ext_info[];
+extern const struct attribute *cros_ec_sensor_fifo_attributes[];
 
 #endif  /* __CROS_EC_SENSORS_CORE_H */
-- 
2.31.0.291.g576ba9dcdaf-goog

