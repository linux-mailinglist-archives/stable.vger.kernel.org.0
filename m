Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5643A4265A6
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 10:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhJHIQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 04:16:06 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:58430 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhJHIQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 04:16:04 -0400
Received: from vokac-Latitude-7410.ysoft.local (unknown [10.0.30.12])
        by uho.ysoft.cz (Postfix) with ESMTP id ECF18A0476;
        Fri,  8 Oct 2021 10:14:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1633680847;
        bh=qw2VKvhxkkddHr4x1O/5STvAL5zyVtYEtbsNsc3vo8M=;
        h=From:To:Cc:Subject:Date:From;
        b=WtjqWVdmLRCsTAUKy7z1FzcyZs69BEz9VGC1gY5LhhCbkg4LcwUY1/wZ0JuLcWRuI
         RuBp1tAmcCGtCtK3eMFPgMNvGQuvC9qQHPD07GnXBWYvJVmAzle8+Irs2moQBeCO1a
         5wIm6YfunyMhWSGMk5FUvktnBRyltNJinft6VCW4=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Amit Kucheria <amitk@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Petr=20Bene=C5=A1?= <petr.benes@ysoft.com>,
        petrben@gmail.com, stable@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
Subject: [PATCH] thermal: imx: Fix temperature measurements on i.MX6 after alarm
Date:   Fri,  8 Oct 2021 10:11:37 +0200
Message-Id: <20211008081137.1948848-1-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Beneš <petr.benes@ysoft.com>

SoC temperature readout may not work after thermal alarm fires interrupt.
This harms userspace as well as CPU cooling device.

Two issues with the logic involved. First, there is no protection against
concurent measurements, hence one can switch the sensor off while
the other one tries to read temperature later. Second, the interrupt path
usually fails. At the end the sensor is powered off and thermal IRQ is
disabled. One has to reenable the thermal zone by the sysfs interface.

Most of troubles come from commit d92ed2c9d3ff ("thermal: imx: Use
driver's local data to decide whether to run a measurement")

It uses data->irq_enabled as the "local data". Indeed, its value is
related to the state of the sensor loosely under normal operation and,
frankly, gets unleashed when the thermal interrupt arrives.

Current patch adds the "local data" (new member sensor_on in
imx_thermal_data) and sets its value in controlled manner.

Fixes: d92ed2c9d3ff ("thermal: imx: Use driver's local data to decide whether to run a measurement")
Cc: petrben@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Petr Beneš <petr.benes@ysoft.com>
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
 drivers/thermal/imx_thermal.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 2c7473d86a59..df5658e21828 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -209,6 +209,8 @@ struct imx_thermal_data {
 	struct clk *thermal_clk;
 	const struct thermal_soc_data *socdata;
 	const char *temp_grade;
+	struct mutex sensor_lock;
+	bool sensor_on;
 };
 
 static void imx_set_panic_temp(struct imx_thermal_data *data,
@@ -252,11 +254,12 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 	const struct thermal_soc_data *soc_data = data->socdata;
 	struct regmap *map = data->tempmon;
 	unsigned int n_meas;
-	bool wait, run_measurement;
+	bool wait;
 	u32 val;
 
-	run_measurement = !data->irq_enabled;
-	if (!run_measurement) {
+	mutex_lock(&data->sensor_lock);
+
+	if (data->sensor_on) {
 		/* Check if a measurement is currently in progress */
 		regmap_read(map, soc_data->temp_data, &val);
 		wait = !(val & soc_data->temp_valid_mask);
@@ -283,13 +286,15 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
 
 	regmap_read(map, soc_data->temp_data, &val);
 
-	if (run_measurement) {
+	if (!data->sensor_on) {
 		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
 			     soc_data->measure_temp_mask);
 		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
 			     soc_data->power_down_mask);
 	}
 
+	mutex_unlock(&data->sensor_lock);
+
 	if ((val & soc_data->temp_valid_mask) == 0) {
 		dev_dbg(&tz->device, "temp measurement never finished\n");
 		return -EAGAIN;
@@ -339,20 +344,26 @@ static int imx_change_mode(struct thermal_zone_device *tz,
 	const struct thermal_soc_data *soc_data = data->socdata;
 
 	if (mode == THERMAL_DEVICE_ENABLED) {
+		mutex_lock(&data->sensor_lock);
 		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
 			     soc_data->power_down_mask);
 		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
 			     soc_data->measure_temp_mask);
+		data->sensor_on = true;
+		mutex_unlock(&data->sensor_lock);
 
 		if (!data->irq_enabled) {
 			data->irq_enabled = true;
 			enable_irq(data->irq);
 		}
 	} else {
+		mutex_lock(&data->sensor_lock);
 		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
 			     soc_data->measure_temp_mask);
 		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
 			     soc_data->power_down_mask);
+		data->sensor_on = false;
+		mutex_unlock(&data->sensor_lock);
 
 		if (data->irq_enabled) {
 			disable_irq(data->irq);
@@ -728,6 +739,8 @@ static int imx_thermal_probe(struct platform_device *pdev)
 	}
 
 	/* Make sure sensor is in known good state for measurements */
+	mutex_init(&data->sensor_lock);
+	mutex_lock(&data->sensor_lock);
 	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
 		     data->socdata->power_down_mask);
 	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
@@ -739,6 +752,8 @@ static int imx_thermal_probe(struct platform_device *pdev)
 			IMX6_MISC0_REFTOP_SELBIASOFF);
 	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
 		     data->socdata->power_down_mask);
+	data->sensor_on = false;
+	mutex_unlock(&data->sensor_lock);
 
 	ret = imx_thermal_register_legacy_cooling(data);
 	if (ret)
@@ -796,10 +811,13 @@ static int imx_thermal_probe(struct platform_device *pdev)
 	if (data->socdata->version == TEMPMON_IMX6SX)
 		imx_set_panic_temp(data, data->temp_critical);
 
+	mutex_lock(&data->sensor_lock);
 	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
 		     data->socdata->power_down_mask);
 	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
 		     data->socdata->measure_temp_mask);
+	data->sensor_on = true;
+	mutex_unlock(&data->sensor_lock);
 
 	data->irq_enabled = true;
 	ret = thermal_zone_device_enable(data->tz);
@@ -832,8 +850,12 @@ static int imx_thermal_remove(struct platform_device *pdev)
 	struct regmap *map = data->tempmon;
 
 	/* Disable measurements */
+	mutex_lock(&data->sensor_lock);
 	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
 		     data->socdata->power_down_mask);
+	data->sensor_on = false;
+	mutex_unlock(&data->sensor_lock);
+
 	if (!IS_ERR(data->thermal_clk))
 		clk_disable_unprepare(data->thermal_clk);
 
-- 
2.25.1

