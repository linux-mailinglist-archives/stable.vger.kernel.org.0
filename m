Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68CE498F6B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351555AbiAXTwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:52:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37244 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356567AbiAXTql (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:46:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 930DDB81229;
        Mon, 24 Jan 2022 19:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5A9C340E7;
        Mon, 24 Jan 2022 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053599;
        bh=GSPw2tC2/aZH08CgCYUriKjqTe1XdPeZhekrHeV1OJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgE7S6a8Z6NGVc9R2SfmGrjYos9ly1WslKonY0uKj3cuE4+JhOjeQqIXlCordyxHM
         h6OrBSaBXsWI6ERYpryvLd87AJ5zemirUbX2+D5f9lBo0ThfqOL5oKQJKUGn6GSe4V
         SM6JGiieQPIYovwE1NDIOXj30zzCYg9dCHPQtTUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        =?UTF-8?q?Petr=20Bene=C5=A1?= <petr.benes@ysoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/563] thermal/drivers/imx: Implement runtime PM support
Date:   Mon, 24 Jan 2022 19:38:02 +0100
Message-Id: <20220124184028.461979914@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 4cf2ddf16e175ee18c5c29865c32da7d6269cf44 ]

Starting with commit d92ed2c9d3ff ("thermal: imx: Use driver's local
data to decide whether to run a measurement") this driver stared using
irq_enabled flag to make decision to power on/off the thermal
core. This triggered a regression, where after reaching critical
temperature, alarm IRQ handler set irq_enabled to false, disabled
thermal core and was not able read temperature and disable cooling
sequence.

In case the cooling device is "CPU/GPU freq", the system will run with
reduce performance until next reboot.

To solve this issue, we need to move all parts implementing hand made
runtime power management and let it handle actual runtime PM framework.

Fixes: d92ed2c9d3ff ("thermal: imx: Use driver's local data to decide whether to run a measurement")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Tested-by: Petr Beneš <petr.benes@ysoft.com>
Link: https://lore.kernel.org/r/20211117103426.81813-1-o.rempel@pengutronix.de
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx_thermal.c | 145 +++++++++++++++++++++-------------
 1 file changed, 91 insertions(+), 54 deletions(-)

diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 2c7473d86a59b..16663373b6829 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -15,6 +15,7 @@
 #include <linux/regmap.h>
 #include <linux/thermal.h>
 #include <linux/nvmem-consumer.h>
+#include <linux/pm_runtime.h>
 
 #define REG_SET		0x4
 #define REG_CLR		0x8
@@ -194,6 +195,7 @@ static struct thermal_soc_data thermal_imx7d_data = {
 };
 
 struct imx_thermal_data {
+	struct device *dev;
 	struct cpufreq_policy *policy;
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
@@ -252,44 +254,15 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 	const struct thermal_soc_data *soc_data = data->socdata;
 	struct regmap *map = data->tempmon;
 	unsigned int n_meas;
-	bool wait, run_measurement;
 	u32 val;
+	int ret;
 
-	run_measurement = !data->irq_enabled;
-	if (!run_measurement) {
-		/* Check if a measurement is currently in progress */
-		regmap_read(map, soc_data->temp_data, &val);
-		wait = !(val & soc_data->temp_valid_mask);
-	} else {
-		/*
-		 * Every time we measure the temperature, we will power on the
-		 * temperature sensor, enable measurements, take a reading,
-		 * disable measurements, power off the temperature sensor.
-		 */
-		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
-			    soc_data->power_down_mask);
-		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
-			    soc_data->measure_temp_mask);
-
-		wait = true;
-	}
-
-	/*
-	 * According to the temp sensor designers, it may require up to ~17us
-	 * to complete a measurement.
-	 */
-	if (wait)
-		usleep_range(20, 50);
+	ret = pm_runtime_resume_and_get(data->dev);
+	if (ret < 0)
+		return ret;
 
 	regmap_read(map, soc_data->temp_data, &val);
 
-	if (run_measurement) {
-		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
-			     soc_data->measure_temp_mask);
-		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
-			     soc_data->power_down_mask);
-	}
-
 	if ((val & soc_data->temp_valid_mask) == 0) {
 		dev_dbg(&tz->device, "temp measurement never finished\n");
 		return -EAGAIN;
@@ -328,6 +301,8 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 		enable_irq(data->irq);
 	}
 
+	pm_runtime_put(data->dev);
+
 	return 0;
 }
 
@@ -335,24 +310,16 @@ static int imx_change_mode(struct thermal_zone_device *tz,
 			   enum thermal_device_mode mode)
 {
 	struct imx_thermal_data *data = tz->devdata;
-	struct regmap *map = data->tempmon;
-	const struct thermal_soc_data *soc_data = data->socdata;
 
 	if (mode == THERMAL_DEVICE_ENABLED) {
-		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
-			     soc_data->power_down_mask);
-		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
-			     soc_data->measure_temp_mask);
+		pm_runtime_get(data->dev);
 
 		if (!data->irq_enabled) {
 			data->irq_enabled = true;
 			enable_irq(data->irq);
 		}
 	} else {
-		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
-			     soc_data->measure_temp_mask);
-		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
-			     soc_data->power_down_mask);
+		pm_runtime_put(data->dev);
 
 		if (data->irq_enabled) {
 			disable_irq(data->irq);
@@ -393,6 +360,11 @@ static int imx_set_trip_temp(struct thermal_zone_device *tz, int trip,
 			     int temp)
 {
 	struct imx_thermal_data *data = tz->devdata;
+	int ret;
+
+	ret = pm_runtime_resume_and_get(data->dev);
+	if (ret < 0)
+		return ret;
 
 	/* do not allow changing critical threshold */
 	if (trip == IMX_TRIP_CRITICAL)
@@ -406,6 +378,8 @@ static int imx_set_trip_temp(struct thermal_zone_device *tz, int trip,
 
 	imx_set_alarm_temp(data, temp);
 
+	pm_runtime_put(data->dev);
+
 	return 0;
 }
 
@@ -681,6 +655,8 @@ static int imx_thermal_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
+	data->dev = &pdev->dev;
+
 	map = syscon_regmap_lookup_by_phandle(pdev->dev.of_node, "fsl,tempmon");
 	if (IS_ERR(map)) {
 		ret = PTR_ERR(map);
@@ -800,6 +776,16 @@ static int imx_thermal_probe(struct platform_device *pdev)
 		     data->socdata->power_down_mask);
 	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
 		     data->socdata->measure_temp_mask);
+	/* After power up, we need a delay before first access can be done. */
+	usleep_range(20, 50);
+
+	/* the core was configured and enabled just before */
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(data->dev);
+
+	ret = pm_runtime_resume_and_get(data->dev);
+	if (ret < 0)
+		goto disable_runtime_pm;
 
 	data->irq_enabled = true;
 	ret = thermal_zone_device_enable(data->tz);
@@ -814,10 +800,15 @@ static int imx_thermal_probe(struct platform_device *pdev)
 		goto thermal_zone_unregister;
 	}
 
+	pm_runtime_put(data->dev);
+
 	return 0;
 
 thermal_zone_unregister:
 	thermal_zone_device_unregister(data->tz);
+disable_runtime_pm:
+	pm_runtime_put_noidle(data->dev);
+	pm_runtime_disable(data->dev);
 clk_disable:
 	clk_disable_unprepare(data->thermal_clk);
 legacy_cleanup:
@@ -829,13 +820,9 @@ legacy_cleanup:
 static int imx_thermal_remove(struct platform_device *pdev)
 {
 	struct imx_thermal_data *data = platform_get_drvdata(pdev);
-	struct regmap *map = data->tempmon;
 
-	/* Disable measurements */
-	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
-		     data->socdata->power_down_mask);
-	if (!IS_ERR(data->thermal_clk))
-		clk_disable_unprepare(data->thermal_clk);
+	pm_runtime_put_noidle(data->dev);
+	pm_runtime_disable(data->dev);
 
 	thermal_zone_device_unregister(data->tz);
 	imx_thermal_unregister_legacy_cooling(data);
@@ -858,29 +845,79 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
 	ret = thermal_zone_device_disable(data->tz);
 	if (ret)
 		return ret;
+
+	return pm_runtime_force_suspend(data->dev);
+}
+
+static int __maybe_unused imx_thermal_resume(struct device *dev)
+{
+	struct imx_thermal_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	ret = pm_runtime_force_resume(data->dev);
+	if (ret)
+		return ret;
+	/* Enabled thermal sensor after resume */
+	return thermal_zone_device_enable(data->tz);
+}
+
+static int __maybe_unused imx_thermal_runtime_suspend(struct device *dev)
+{
+	struct imx_thermal_data *data = dev_get_drvdata(dev);
+	const struct thermal_soc_data *socdata = data->socdata;
+	struct regmap *map = data->tempmon;
+	int ret;
+
+	ret = regmap_write(map, socdata->sensor_ctrl + REG_CLR,
+			   socdata->measure_temp_mask);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(map, socdata->sensor_ctrl + REG_SET,
+			   socdata->power_down_mask);
+	if (ret)
+		return ret;
+
 	clk_disable_unprepare(data->thermal_clk);
 
 	return 0;
 }
 
-static int __maybe_unused imx_thermal_resume(struct device *dev)
+static int __maybe_unused imx_thermal_runtime_resume(struct device *dev)
 {
 	struct imx_thermal_data *data = dev_get_drvdata(dev);
+	const struct thermal_soc_data *socdata = data->socdata;
+	struct regmap *map = data->tempmon;
 	int ret;
 
 	ret = clk_prepare_enable(data->thermal_clk);
 	if (ret)
 		return ret;
-	/* Enabled thermal sensor after resume */
-	ret = thermal_zone_device_enable(data->tz);
+
+	ret = regmap_write(map, socdata->sensor_ctrl + REG_CLR,
+			   socdata->power_down_mask);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(map, socdata->sensor_ctrl + REG_SET,
+			   socdata->measure_temp_mask);
 	if (ret)
 		return ret;
 
+	/*
+	 * According to the temp sensor designers, it may require up to ~17us
+	 * to complete a measurement.
+	 */
+	usleep_range(20, 50);
+
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(imx_thermal_pm_ops,
-			 imx_thermal_suspend, imx_thermal_resume);
+static const struct dev_pm_ops imx_thermal_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(imx_thermal_suspend, imx_thermal_resume)
+	SET_RUNTIME_PM_OPS(imx_thermal_runtime_suspend,
+			   imx_thermal_runtime_resume, NULL)
+};
 
 static struct platform_driver imx_thermal = {
 	.driver = {
-- 
2.34.1



