Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AEB4314B7
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhJRKOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhJRKO1 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 18 Oct 2021 06:14:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 824E560E90;
        Mon, 18 Oct 2021 10:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634551936;
        bh=QiSaMSvw1vZps5/Z1mY1oDj9rDgvOikPYHhYB8n9GaM=;
        h=Subject:To:Cc:From:Date:From;
        b=q9ubdDWjSt1uiT3ePGep9p5/HU/bbpze1HXGeTRlc4iKU0rNlEnSEwa1XdcHl6j2X
         L0Rm1/IoUl6+thlA6vhq6xY+n+cZoKysnSKPR/+OU7ScIcfY9EEN7nONgA8fLeFXmA
         5QhIGgqmMZUkY7nsodiF74okcX/lsGdqFxPBh6bM=
Subject: FAILED: patch "[PATCH] iio: adis16480: fix devices that do not support sleep mode" failed to apply to 5.10-stable tree
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 12:12:12 +0200
Message-ID: <163455193221417@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ea1945c2f72d7bd253e2ebaa97cdd8d9ffcde076 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Fri, 3 Sep 2021 16:14:23 +0200
Subject: [PATCH] iio: adis16480: fix devices that do not support sleep mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Not all devices supported by this driver support being put to sleep
mode. For those devices, when calling 'adis16480_stop_device()' on the
unbind path, we where actually writing in the SYNC_SCALE register.

Fixes: 80cbc848c4fa0 ("iio: imu: adis16480: Add support for ADIS16490")
Fixes: 82e7a1b250170 ("iio: imu: adis16480: Add support for ADIS1649x family of devices")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210903141423.517028-6-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index a869a6e52a16..ed129321a14d 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -144,6 +144,7 @@ struct adis16480_chip_info {
 	unsigned int max_dec_rate;
 	const unsigned int *filter_freqs;
 	bool has_pps_clk_mode;
+	bool has_sleep_cnt;
 	const struct adis_data adis_data;
 };
 
@@ -939,6 +940,7 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
 		.max_dec_rate = 2048,
+		.has_sleep_cnt = true,
 		.filter_freqs = adis16480_def_filter_freqs,
 		.adis_data = ADIS16480_DATA(16375, &adis16485_timeouts, 0),
 	},
@@ -952,6 +954,7 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
 		.max_dec_rate = 2048,
+		.has_sleep_cnt = true,
 		.filter_freqs = adis16480_def_filter_freqs,
 		.adis_data = ADIS16480_DATA(16480, &adis16480_timeouts, 0),
 	},
@@ -965,6 +968,7 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
 		.max_dec_rate = 2048,
+		.has_sleep_cnt = true,
 		.filter_freqs = adis16480_def_filter_freqs,
 		.adis_data = ADIS16480_DATA(16485, &adis16485_timeouts, 0),
 	},
@@ -978,6 +982,7 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
 		.max_dec_rate = 2048,
+		.has_sleep_cnt = true,
 		.filter_freqs = adis16480_def_filter_freqs,
 		.adis_data = ADIS16480_DATA(16488, &adis16485_timeouts, 0),
 	},
@@ -1425,9 +1430,12 @@ static int adis16480_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(&spi->dev, adis16480_stop, indio_dev);
-	if (ret)
-		return ret;
+	if (st->chip_info->has_sleep_cnt) {
+		ret = devm_add_action_or_reset(&spi->dev, adis16480_stop,
+					       indio_dev);
+		if (ret)
+			return ret;
+	}
 
 	ret = adis16480_config_irq_pin(spi->dev.of_node, st);
 	if (ret)

