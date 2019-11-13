Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A019FAFB0
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 12:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfKML1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 06:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbfKML1l (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 13 Nov 2019 06:27:41 -0500
Received: from localhost (unknown [61.58.47.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C017222D3;
        Wed, 13 Nov 2019 11:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573644459;
        bh=AWg+W0CIk6H7BkV3Y30WB15zSM59Ftluzh+VlNjxMV0=;
        h=Subject:To:From:Date:From;
        b=zGIe+KRfJBt3X2Y30k5HB3wC0FSWXif3iAgJ/XJwTDimWBTWDxVpDRLPIo/1s+jLP
         5KbHJ9gVcVPTLTJKLaDPRGqSmYPW8S7MKTIeqkkEkgGSd+lGH1n7whsO4WtNQlt7XE
         Ol5Iba3tyV5sB6PqIQS2CSZhcg/JPAAM9uMIgc3A=
Subject: patch "iio: adis16480: Fix scales factors" added to staging-testing
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 13 Nov 2019 19:26:08 +0800
Message-ID: <15736443688327@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adis16480: Fix scales factors

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 49549cb23a2926eba70bb634e361daea0f319794 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Mon, 28 Oct 2019 17:33:48 +0100
Subject: iio: adis16480: Fix scales factors
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch fixes the scales for the gyroscope, accelerometer and
barometer. The pressure scale was just wrong. For the others, the scale
factors were not taking into account that a 32bit word is being read
from the device.

Fixes: 7abad1063deb ("iio: adis16480: Fix scale factors")
Fixes: 82e7a1b25017 ("iio: imu: adis16480: Add support for ADIS1649x family of devices")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/adis16480.c | 77 ++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index c0e7e768be41..f1d52563951c 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -622,9 +622,13 @@ static int adis16480_read_raw(struct iio_dev *indio_dev,
 			*val2 = (st->chip_info->temp_scale % 1000) * 1000;
 			return IIO_VAL_INT_PLUS_MICRO;
 		case IIO_PRESSURE:
-			*val = 0;
-			*val2 = 4000; /* 40ubar = 0.004 kPa */
-			return IIO_VAL_INT_PLUS_MICRO;
+			/*
+			 * max scale is 1310 mbar
+			 * max raw value is 32767 shifted for 32bits
+			 */
+			*val = 131; /* 1310mbar = 131 kPa */
+			*val2 = 32767 << 16;
+			return IIO_VAL_FRACTIONAL;
 		default:
 			return -EINVAL;
 		}
@@ -785,13 +789,14 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
 		/*
-		 * storing the value in rad/degree and the scale in degree
-		 * gives us the result in rad and better precession than
-		 * storing the scale directly in rad.
+		 * Typically we do IIO_RAD_TO_DEGREE in the denominator, which
+		 * is exactly the same as IIO_DEGREE_TO_RAD in numerator, since
+		 * it gives better approximation. However, in this case we
+		 * cannot do it since it would not fit in a 32bit variable.
 		 */
-		.gyro_max_val = IIO_RAD_TO_DEGREE(22887),
-		.gyro_max_scale = 300,
-		.accel_max_val = IIO_M_S_2_TO_G(21973),
+		.gyro_max_val = 22887 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(300),
+		.accel_max_val = IIO_M_S_2_TO_G(21973 << 16),
 		.accel_max_scale = 18,
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
@@ -801,9 +806,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16480] = {
 		.channels = adis16480_channels,
 		.num_channels = ARRAY_SIZE(adis16480_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(22500),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(12500),
+		.gyro_max_val = 22500 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(12500 << 16),
 		.accel_max_scale = 10,
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
@@ -813,9 +818,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16485] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(22500),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(20000),
+		.gyro_max_val = 22500 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(20000 << 16),
 		.accel_max_scale = 5,
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
@@ -825,9 +830,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16488] = {
 		.channels = adis16480_channels,
 		.num_channels = ARRAY_SIZE(adis16480_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(22500),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(22500),
+		.gyro_max_val = 22500 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(22500 << 16),
 		.accel_max_scale = 18,
 		.temp_scale = 5650, /* 5.65 milli degree Celsius */
 		.int_clk = 2460000,
@@ -837,9 +842,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16495_1] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(20000),
-		.gyro_max_scale = 125,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 20000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(125),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 8,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -850,9 +855,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16495_2] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(18000),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 18000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 8,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -863,9 +868,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16495_3] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(20000),
-		.gyro_max_scale = 2000,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 20000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(2000),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 8,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -876,9 +881,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16497_1] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(20000),
-		.gyro_max_scale = 125,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 20000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(125),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 40,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -889,9 +894,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16497_2] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(18000),
-		.gyro_max_scale = 450,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 18000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(450),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 40,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
@@ -902,9 +907,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
 	[ADIS16497_3] = {
 		.channels = adis16485_channels,
 		.num_channels = ARRAY_SIZE(adis16485_channels),
-		.gyro_max_val = IIO_RAD_TO_DEGREE(20000),
-		.gyro_max_scale = 2000,
-		.accel_max_val = IIO_M_S_2_TO_G(32000),
+		.gyro_max_val = 20000 << 16,
+		.gyro_max_scale = IIO_DEGREE_TO_RAD(2000),
+		.accel_max_val = IIO_M_S_2_TO_G(32000 << 16),
 		.accel_max_scale = 40,
 		.temp_scale = 12500, /* 12.5 milli degree Celsius */
 		.int_clk = 4250000,
-- 
2.24.0


