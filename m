Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7CF477CF0
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 21:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241179AbhLPUA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 15:00:59 -0500
Received: from www.linuxtv.org ([130.149.80.248]:34482 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241161AbhLPUA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 15:00:59 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mxwvx-005tBR-8h; Thu, 16 Dec 2021 20:00:57 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Thu, 16 Dec 2021 19:54:52 +0000
Subject: [git:media_stage/master] media: ov8865: Disable only enabled regulators on error path
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mxwvx-005tBR-8h@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ov8865: Disable only enabled regulators on error path
Author:  Sakari Ailus <sakari.ailus@linux.intel.com>
Date:    Wed Dec 15 09:38:48 2021 +0100

If powering on the sensor failed, the entire power-off sequence was run
independently of how far the power-on sequence proceeded before the error.
This lead to disabling regulators and/or clock that was not enabled.

Fix this by disabling only clocks and regulators that were enabled
previously.

Fixes: 11c0d8fdccc5 ("media: i2c: Add support for the OV8865 image sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/i2c/ov8865.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

---

diff --git a/drivers/media/i2c/ov8865.c b/drivers/media/i2c/ov8865.c
index ebdb20d3fe9d..d9d016cfa9ac 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2407,27 +2407,27 @@ static int ov8865_sensor_power(struct ov8865_sensor *sensor, bool on)
 		if (ret) {
 			dev_err(sensor->dev,
 				"failed to enable DOVDD regulator\n");
-			goto disable;
+			return ret;
 		}
 
 		ret = regulator_enable(sensor->avdd);
 		if (ret) {
 			dev_err(sensor->dev,
 				"failed to enable AVDD regulator\n");
-			goto disable;
+			goto disable_dovdd;
 		}
 
 		ret = regulator_enable(sensor->dvdd);
 		if (ret) {
 			dev_err(sensor->dev,
 				"failed to enable DVDD regulator\n");
-			goto disable;
+			goto disable_avdd;
 		}
 
 		ret = clk_prepare_enable(sensor->extclk);
 		if (ret) {
 			dev_err(sensor->dev, "failed to enable EXTCLK clock\n");
-			goto disable;
+			goto disable_dvdd;
 		}
 
 		gpiod_set_value_cansleep(sensor->reset, 0);
@@ -2436,14 +2436,16 @@ static int ov8865_sensor_power(struct ov8865_sensor *sensor, bool on)
 		/* Time to enter streaming mode according to power timings. */
 		usleep_range(10000, 12000);
 	} else {
-disable:
 		gpiod_set_value_cansleep(sensor->powerdown, 1);
 		gpiod_set_value_cansleep(sensor->reset, 1);
 
 		clk_disable_unprepare(sensor->extclk);
 
+disable_dvdd:
 		regulator_disable(sensor->dvdd);
+disable_avdd:
 		regulator_disable(sensor->avdd);
+disable_dovdd:
 		regulator_disable(sensor->dovdd);
 	}
 
