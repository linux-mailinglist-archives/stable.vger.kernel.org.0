Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCF937CC15
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242944AbhELQkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242262AbhELQd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB72D61CB3;
        Wed, 12 May 2021 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835142;
        bh=CtQP8pOVtkC1dYoinZxsGKfQxqk82X9VzBPh5nG9Gnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgE9pSm9gTEjC6acW3bY23aIpnxjSXVdGNq65/t1zTmz91QaaPzFWX3Xkavcfy9YT
         x53WsM01Zwp5WdOyc2QEffyOorRLgJpDGxs5Kc8o+rDLKgJQy+aDB339bNFkPFO0zO
         NX7X4IypGAd5T6GsUMcSUhxQJCDK1mH/E2EO4qxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nuno Sa <nuno.sa@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 190/677] iio: adis16480: fix pps mode sampling frequency math
Date:   Wed, 12 May 2021 16:43:56 +0200
Message-Id: <20210512144843.561204561@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 0463e60f087069adf25a815cd88753946aca2565 ]

When using PPS mode, the input clock needs to be scaled so that we have
an IMU sample rate between (optimally) 4000 and 4250. After this, we can
use the decimation filter to lower the sampling rate in order to get what
the user wants. Optimally, the user sample rate is a multiple of both the
IMU sample rate and the input clock. Hence, calculating the sync_scale
dynamically gives us better chances of achieving a perfect/integer value
for DEC_RATE. The math here is:
 1. lcm of the input clock and the desired output rate.
 2. get the highest multiple of the previous result lower than the adis
    max rate.
 3. The last result becomes the IMU sample rate. Use that to calculate
    SYNC_SCALE and DEC_RATE (to get the user output rate).

Fixes: 326e2357553d3 ("iio: imu: adis16480: Add support for external clock")

Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210218114039.216091-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16480.c | 128 ++++++++++++++++++++++++++----------
 1 file changed, 94 insertions(+), 34 deletions(-)

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index dfe86c589325..c41b8ef1e250 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -10,6 +10,7 @@
 #include <linux/of_irq.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/math.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -17,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/module.h>
+#include <linux/lcm.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
@@ -170,6 +172,11 @@ static const char * const adis16480_int_pin_names[4] = {
 	[ADIS16480_PIN_DIO4] = "DIO4",
 };
 
+static bool low_rate_allow;
+module_param(low_rate_allow, bool, 0444);
+MODULE_PARM_DESC(low_rate_allow,
+		 "Allow IMU rates below the minimum advisable when external clk is used in PPS mode (default: N)");
+
 #ifdef CONFIG_DEBUG_FS
 
 static ssize_t adis16480_show_firmware_revision(struct file *file,
@@ -312,7 +319,8 @@ static int adis16480_debugfs_init(struct iio_dev *indio_dev)
 static int adis16480_set_freq(struct iio_dev *indio_dev, int val, int val2)
 {
 	struct adis16480 *st = iio_priv(indio_dev);
-	unsigned int t, reg;
+	unsigned int t, sample_rate = st->clk_freq;
+	int ret;
 
 	if (val < 0 || val2 < 0)
 		return -EINVAL;
@@ -321,28 +329,65 @@ static int adis16480_set_freq(struct iio_dev *indio_dev, int val, int val2)
 	if (t == 0)
 		return -EINVAL;
 
+	mutex_lock(&st->adis.state_lock);
 	/*
-	 * When using PPS mode, the rate of data collection is equal to the
-	 * product of the external clock frequency and the scale factor in the
-	 * SYNC_SCALE register.
-	 * When using sync mode, or internal clock, the output data rate is
-	 * equal with  the clock frequency divided by DEC_RATE + 1.
+	 * When using PPS mode, the input clock needs to be scaled so that we have an IMU
+	 * sample rate between (optimally) 4000 and 4250. After this, we can use the
+	 * decimation filter to lower the sampling rate in order to get what the user wants.
+	 * Optimally, the user sample rate is a multiple of both the IMU sample rate and
+	 * the input clock. Hence, calculating the sync_scale dynamically gives us better
+	 * chances of achieving a perfect/integer value for DEC_RATE. The math here is:
+	 *	1. lcm of the input clock and the desired output rate.
+	 *	2. get the highest multiple of the previous result lower than the adis max rate.
+	 *	3. The last result becomes the IMU sample rate. Use that to calculate SYNC_SCALE
+	 *	   and DEC_RATE (to get the user output rate)
 	 */
 	if (st->clk_mode == ADIS16480_CLK_PPS) {
-		t = t / st->clk_freq;
-		reg = ADIS16495_REG_SYNC_SCALE;
-	} else {
-		t = st->clk_freq / t;
-		reg = ADIS16480_REG_DEC_RATE;
+		unsigned long scaled_rate = lcm(st->clk_freq, t);
+		int sync_scale;
+
+		/*
+		 * If lcm is bigger than the IMU maximum sampling rate there's no perfect
+		 * solution. In this case, we get the highest multiple of the input clock
+		 * lower than the IMU max sample rate.
+		 */
+		if (scaled_rate > st->chip_info->int_clk)
+			scaled_rate = st->chip_info->int_clk / st->clk_freq * st->clk_freq;
+		else
+			scaled_rate = st->chip_info->int_clk / scaled_rate * scaled_rate;
+
+		/*
+		 * This is not an hard requirement but it's not advised to run the IMU
+		 * with a sample rate lower than 4000Hz due to possible undersampling
+		 * issues. However, there are users that might really want to take the risk.
+		 * Hence, we provide a module parameter for them. If set, we allow sample
+		 * rates lower than 4KHz. By default, we won't allow this and we just roundup
+		 * the rate to the next multiple of the input clock bigger than 4KHz. This
+		 * is done like this as in some cases (when DEC_RATE is 0) might give
+		 * us the closest value to the one desired by the user...
+		 */
+		if (scaled_rate < 4000000 && !low_rate_allow)
+			scaled_rate = roundup(4000000, st->clk_freq);
+
+		sync_scale = scaled_rate / st->clk_freq;
+		ret = __adis_write_reg_16(&st->adis, ADIS16495_REG_SYNC_SCALE, sync_scale);
+		if (ret)
+			goto error;
+
+		sample_rate = scaled_rate;
 	}
 
+	t = DIV_ROUND_CLOSEST(sample_rate, t);
+	if (t)
+		t--;
+
 	if (t > st->chip_info->max_dec_rate)
 		t = st->chip_info->max_dec_rate;
 
-	if ((t != 0) && (st->clk_mode != ADIS16480_CLK_PPS))
-		t--;
-
-	return adis_write_reg_16(&st->adis, reg, t);
+	ret = __adis_write_reg_16(&st->adis, ADIS16480_REG_DEC_RATE, t);
+error:
+	mutex_unlock(&st->adis.state_lock);
+	return ret;
 }
 
 static int adis16480_get_freq(struct iio_dev *indio_dev, int *val, int *val2)
@@ -350,34 +395,35 @@ static int adis16480_get_freq(struct iio_dev *indio_dev, int *val, int *val2)
 	struct adis16480 *st = iio_priv(indio_dev);
 	uint16_t t;
 	int ret;
-	unsigned int freq;
-	unsigned int reg;
+	unsigned int freq, sample_rate = st->clk_freq;
 
-	if (st->clk_mode == ADIS16480_CLK_PPS)
-		reg = ADIS16495_REG_SYNC_SCALE;
-	else
-		reg = ADIS16480_REG_DEC_RATE;
+	mutex_lock(&st->adis.state_lock);
+
+	if (st->clk_mode == ADIS16480_CLK_PPS) {
+		u16 sync_scale;
+
+		ret = __adis_read_reg_16(&st->adis, ADIS16495_REG_SYNC_SCALE, &sync_scale);
+		if (ret)
+			goto error;
 
-	ret = adis_read_reg_16(&st->adis, reg, &t);
+		sample_rate = st->clk_freq * sync_scale;
+	}
+
+	ret = __adis_read_reg_16(&st->adis, ADIS16480_REG_DEC_RATE, &t);
 	if (ret)
-		return ret;
+		goto error;
 
-	/*
-	 * When using PPS mode, the rate of data collection is equal to the
-	 * product of the external clock frequency and the scale factor in the
-	 * SYNC_SCALE register.
-	 * When using sync mode, or internal clock, the output data rate is
-	 * equal with  the clock frequency divided by DEC_RATE + 1.
-	 */
-	if (st->clk_mode == ADIS16480_CLK_PPS)
-		freq = st->clk_freq * t;
-	else
-		freq = st->clk_freq / (t + 1);
+	mutex_unlock(&st->adis.state_lock);
+
+	freq = DIV_ROUND_CLOSEST(sample_rate, (t + 1));
 
 	*val = freq / 1000;
 	*val2 = (freq % 1000) * 1000;
 
 	return IIO_VAL_INT_PLUS_MICRO;
+error:
+	mutex_unlock(&st->adis.state_lock);
+	return ret;
 }
 
 enum {
@@ -1278,6 +1324,20 @@ static int adis16480_probe(struct spi_device *spi)
 
 		st->clk_freq = clk_get_rate(st->ext_clk);
 		st->clk_freq *= 1000; /* micro */
+		if (st->clk_mode == ADIS16480_CLK_PPS) {
+			u16 sync_scale;
+
+			/*
+			 * In PPS mode, the IMU sample rate is the clk_freq * sync_scale. Hence,
+			 * default the IMU sample rate to the highest multiple of the input clock
+			 * lower than the IMU max sample rate. The internal sample rate is the
+			 * max...
+			 */
+			sync_scale = st->chip_info->int_clk / st->clk_freq;
+			ret = __adis_write_reg_16(&st->adis, ADIS16495_REG_SYNC_SCALE, sync_scale);
+			if (ret)
+				return ret;
+		}
 	} else {
 		st->clk_freq = st->chip_info->int_clk;
 	}
-- 
2.30.2



