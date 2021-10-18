Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82A4431E4E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhJRN76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234340AbhJRN55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AFC261A05;
        Mon, 18 Oct 2021 13:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564479;
        bh=FTq9aKxtvC9DABeHCnl/DgR+38H1FTLYtm0hVD7HkYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8+PmlVVOyZEBl9tEwbvM9Xa4jety/r5aCB7TnNTq+P0w9OfgIrdrSK1q6f9oQ9JM
         8gAbMJgHkzkXVhirX+LH3PKlUff7tEhw91hsSE6wmJFTG49g8jb0hdKxdkSJ2oli0A
         sD5U3qN3reQgT91H0SrNUwgobepQ1/72K0faqJUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 071/151] iio: adis16480: fix devices that do not support sleep mode
Date:   Mon, 18 Oct 2021 15:24:10 +0200
Message-Id: <20211018132342.994281537@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit ea1945c2f72d7bd253e2ebaa97cdd8d9ffcde076 upstream.

Not all devices supported by this driver support being put to sleep
mode. For those devices, when calling 'adis16480_stop_device()' on the
unbind path, we where actually writing in the SYNC_SCALE register.

Fixes: 80cbc848c4fa0 ("iio: imu: adis16480: Add support for ADIS16490")
Fixes: 82e7a1b250170 ("iio: imu: adis16480: Add support for ADIS1649x family of devices")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210903141423.517028-6-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16480.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -144,6 +144,7 @@ struct adis16480_chip_info {
 	unsigned int max_dec_rate;
 	const unsigned int *filter_freqs;
 	bool has_pps_clk_mode;
+	bool has_sleep_cnt;
 	const struct adis_data adis_data;
 };
 
@@ -939,6 +940,7 @@ static const struct adis16480_chip_info
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
 		.max_dec_rate = 2048,
+		.has_sleep_cnt = true,
 		.filter_freqs = adis16480_def_filter_freqs,
 		.adis_data = ADIS16480_DATA(16375, &adis16485_timeouts, 0),
 	},
@@ -952,6 +954,7 @@ static const struct adis16480_chip_info
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
 		.max_dec_rate = 2048,
+		.has_sleep_cnt = true,
 		.filter_freqs = adis16480_def_filter_freqs,
 		.adis_data = ADIS16480_DATA(16480, &adis16480_timeouts, 0),
 	},
@@ -965,6 +968,7 @@ static const struct adis16480_chip_info
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
 		.max_dec_rate = 2048,
+		.has_sleep_cnt = true,
 		.filter_freqs = adis16480_def_filter_freqs,
 		.adis_data = ADIS16480_DATA(16485, &adis16485_timeouts, 0),
 	},
@@ -978,6 +982,7 @@ static const struct adis16480_chip_info
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
 		.max_dec_rate = 2048,
+		.has_sleep_cnt = true,
 		.filter_freqs = adis16480_def_filter_freqs,
 		.adis_data = ADIS16480_DATA(16488, &adis16485_timeouts, 0),
 	},
@@ -1425,9 +1430,12 @@ static int adis16480_probe(struct spi_de
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


