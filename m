Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D9442222B
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhJEJXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233372AbhJEJXn (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4D1F61165;
        Tue,  5 Oct 2021 09:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425713;
        bh=FfP9l2r1ZM6W+JGZvlCv6D23iBbWAIN7i19WiNbhtp4=;
        h=Subject:To:From:Date:From;
        b=G5F3KLWIfu6fXHErWrG135FzCNHnQx8qw7IX0TRF/Bx4i7o9GqJQgzUkL7sOxZhh7
         QxpyZRnnwWU0e68Koq3Y3XmnHSIkwdKLfZyWlt14Y/FhKfCZfa/fy1IomsXA7TKuiQ
         SghG6HGVLGNByJHzD+QtcFHpNdp/XHC9IJzOHAyo=
Subject: patch "iio: adis16480: fix devices that do not support sleep mode" added to staging-linus
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:26 +0200
Message-ID: <163342568652130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adis16480: fix devices that do not support sleep mode

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ea1945c2f72d7bd253e2ebaa97cdd8d9ffcde076 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Fri, 3 Sep 2021 16:14:23 +0200
Subject: iio: adis16480: fix devices that do not support sleep mode
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
---
 drivers/iio/imu/adis16480.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

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
-- 
2.33.0


