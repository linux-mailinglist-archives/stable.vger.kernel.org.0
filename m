Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FF129C087
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818004AbgJ0RQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752431AbgJ0O4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A8402071A;
        Tue, 27 Oct 2020 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810558;
        bh=dJ3fNlQSX287lMDmGhOcisuzfVUzMlbKOCTzBkDUBjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2UtAhv1eJyoAIM8xPdqy+QR6Lx+mMCY32h2Fj67TgSDRMCvZRlGaQlUl0vg+F4/F
         J5t95t6awnZq1YiPWD64tArO+cbwsjhaGVfW003nen9l3YvSgiO+fxLnYXhwmF5JCr
         zaclGVN9QreGtau4HjicJu13BqqYaIhrc//6D9D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 150/633] hwmon: (bt1-pvt) Cache current update timeout
Date:   Tue, 27 Oct 2020 14:48:13 +0100
Message-Id: <20201027135529.731212616@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 0015503e5f6357f286bef34d039e43359fa4efd4 ]

Instead of converting the update timeout data to the milliseconds each
time on the read procedure let's preserve the currently set timeout in the
dedicated driver private data cache. The cached value will be then used in
the timeout read method and in the alarm-less data conversion to prevent
the caller task hanging up in case if the PVT sensor is suddenly powered
down.

Fixes: 87976ce2825d ("hwmon: Add Baikal-T1 PVT sensor driver")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20200920110924.19741-3-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/bt1-pvt.c | 85 ++++++++++++++++++++++-------------------
 drivers/hwmon/bt1-pvt.h |  3 ++
 2 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/drivers/hwmon/bt1-pvt.c b/drivers/hwmon/bt1-pvt.c
index f4b7353c078a8..2600426a3b21c 100644
--- a/drivers/hwmon/bt1-pvt.c
+++ b/drivers/hwmon/bt1-pvt.c
@@ -655,44 +655,16 @@ static int pvt_write_trim(struct pvt_hwmon *pvt, long val)
 
 static int pvt_read_timeout(struct pvt_hwmon *pvt, long *val)
 {
-	unsigned long rate;
-	ktime_t kt;
-	u32 data;
-
-	rate = clk_get_rate(pvt->clks[PVT_CLOCK_REF].clk);
-	if (!rate)
-		return -ENODEV;
-
-	/*
-	 * Don't bother with mutex here, since we just read data from MMIO.
-	 * We also have to scale the ticks timeout up to compensate the
-	 * ms-ns-data translations.
-	 */
-	data = readl(pvt->regs + PVT_TTIMEOUT) + 1;
+	int ret;
 
-	/*
-	 * Calculate ref-clock based delay (Ttotal) between two consecutive
-	 * data samples of the same sensor. So we first must calculate the
-	 * delay introduced by the internal ref-clock timer (Tref * Fclk).
-	 * Then add the constant timeout cuased by each conversion latency
-	 * (Tmin). The basic formulae for each conversion is following:
-	 *   Ttotal = Tref * Fclk + Tmin
-	 * Note if alarms are enabled the sensors are polled one after
-	 * another, so in order to have the delay being applicable for each
-	 * sensor the requested value must be equally redistirbuted.
-	 */
-#if defined(CONFIG_SENSORS_BT1_PVT_ALARMS)
-	kt = ktime_set(PVT_SENSORS_NUM * (u64)data, 0);
-	kt = ktime_divns(kt, rate);
-	kt = ktime_add_ns(kt, PVT_SENSORS_NUM * PVT_TOUT_MIN);
-#else
-	kt = ktime_set(data, 0);
-	kt = ktime_divns(kt, rate);
-	kt = ktime_add_ns(kt, PVT_TOUT_MIN);
-#endif
+	ret = mutex_lock_interruptible(&pvt->iface_mtx);
+	if (ret)
+		return ret;
 
 	/* Return the result in msec as hwmon sysfs interface requires. */
-	*val = ktime_to_ms(kt);
+	*val = ktime_to_ms(pvt->timeout);
+
+	mutex_unlock(&pvt->iface_mtx);
 
 	return 0;
 }
@@ -700,7 +672,7 @@ static int pvt_read_timeout(struct pvt_hwmon *pvt, long *val)
 static int pvt_write_timeout(struct pvt_hwmon *pvt, long val)
 {
 	unsigned long rate;
-	ktime_t kt;
+	ktime_t kt, cache;
 	u32 data;
 	int ret;
 
@@ -713,7 +685,7 @@ static int pvt_write_timeout(struct pvt_hwmon *pvt, long val)
 	 * between all available sensors to have the requested delay
 	 * applicable to each individual sensor.
 	 */
-	kt = ms_to_ktime(val);
+	cache = kt = ms_to_ktime(val);
 #if defined(CONFIG_SENSORS_BT1_PVT_ALARMS)
 	kt = ktime_divns(kt, PVT_SENSORS_NUM);
 #endif
@@ -742,6 +714,7 @@ static int pvt_write_timeout(struct pvt_hwmon *pvt, long val)
 		return ret;
 
 	pvt_set_tout(pvt, data);
+	pvt->timeout = cache;
 
 	mutex_unlock(&pvt->iface_mtx);
 
@@ -1018,10 +991,17 @@ static int pvt_check_pwr(struct pvt_hwmon *pvt)
 	return ret;
 }
 
-static void pvt_init_iface(struct pvt_hwmon *pvt)
+static int pvt_init_iface(struct pvt_hwmon *pvt)
 {
+	unsigned long rate;
 	u32 trim, temp;
 
+	rate = clk_get_rate(pvt->clks[PVT_CLOCK_REF].clk);
+	if (!rate) {
+		dev_err(pvt->dev, "Invalid reference clock rate\n");
+		return -ENODEV;
+	}
+
 	/*
 	 * Make sure all interrupts and controller are disabled so not to
 	 * accidentally have ISR executed before the driver data is fully
@@ -1036,12 +1016,37 @@ static void pvt_init_iface(struct pvt_hwmon *pvt)
 	pvt_set_mode(pvt, pvt_info[pvt->sensor].mode);
 	pvt_set_tout(pvt, PVT_TOUT_DEF);
 
+	/*
+	 * Preserve the current ref-clock based delay (Ttotal) between the
+	 * sensors data samples in the driver data so not to recalculate it
+	 * each time on the data requests and timeout reads. It consists of the
+	 * delay introduced by the internal ref-clock timer (N / Fclk) and the
+	 * constant timeout caused by each conversion latency (Tmin):
+	 *   Ttotal = N / Fclk + Tmin
+	 * If alarms are enabled the sensors are polled one after another and
+	 * in order to get the next measurement of a particular sensor the
+	 * caller will have to wait for at most until all the others are
+	 * polled. In that case the formulae will look a bit different:
+	 *   Ttotal = 5 * (N / Fclk + Tmin)
+	 */
+#if defined(CONFIG_SENSORS_BT1_PVT_ALARMS)
+	pvt->timeout = ktime_set(PVT_SENSORS_NUM * PVT_TOUT_DEF, 0);
+	pvt->timeout = ktime_divns(pvt->timeout, rate);
+	pvt->timeout = ktime_add_ns(pvt->timeout, PVT_SENSORS_NUM * PVT_TOUT_MIN);
+#else
+	pvt->timeout = ktime_set(PVT_TOUT_DEF, 0);
+	pvt->timeout = ktime_divns(pvt->timeout, rate);
+	pvt->timeout = ktime_add_ns(pvt->timeout, PVT_TOUT_MIN);
+#endif
+
 	trim = PVT_TRIM_DEF;
 	if (!of_property_read_u32(pvt->dev->of_node,
 	     "baikal,pvt-temp-offset-millicelsius", &temp))
 		trim = pvt_calc_trim(temp);
 
 	pvt_set_trim(pvt, trim);
+
+	return 0;
 }
 
 static int pvt_request_irq(struct pvt_hwmon *pvt)
@@ -1149,7 +1154,9 @@ static int pvt_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	pvt_init_iface(pvt);
+	ret = pvt_init_iface(pvt);
+	if (ret)
+		return ret;
 
 	ret = pvt_request_irq(pvt);
 	if (ret)
diff --git a/drivers/hwmon/bt1-pvt.h b/drivers/hwmon/bt1-pvt.h
index 5eac73e948854..93b8dd5e7c944 100644
--- a/drivers/hwmon/bt1-pvt.h
+++ b/drivers/hwmon/bt1-pvt.h
@@ -10,6 +10,7 @@
 #include <linux/completion.h>
 #include <linux/hwmon.h>
 #include <linux/kernel.h>
+#include <linux/ktime.h>
 #include <linux/mutex.h>
 #include <linux/seqlock.h>
 
@@ -201,6 +202,7 @@ struct pvt_cache {
  *	       if alarms are disabled).
  * @sensor: current PVT sensor the data conversion is being performed for.
  * @cache: data cache descriptor.
+ * @timeout: conversion timeout cache.
  */
 struct pvt_hwmon {
 	struct device *dev;
@@ -214,6 +216,7 @@ struct pvt_hwmon {
 	struct mutex iface_mtx;
 	enum pvt_sensor_type sensor;
 	struct pvt_cache cache[PVT_SENSORS_NUM];
+	ktime_t timeout;
 };
 
 /*
-- 
2.25.1



