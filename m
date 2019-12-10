Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF88311954F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfLJVT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbfLJVMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AA252077B;
        Tue, 10 Dec 2019 21:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012337;
        bh=M7edHdUXeEqsFb3sSdr70nwnlRnnGnrxPsKmnYo39Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+rKjqggQT7J4/u/a4o+QYE80iVbXC1waG6SPvRqAjQkHODV2YWnRr/A415OQSMo/
         Rgzz6JrsPCJkAfa5KU92mEA7SwnDZrlqBsawW6huGFuI+4OzhTBfEpUrVE7StVG35A
         NzWtt/ySYdIybbacLgePHaAu4cIGyI70QfvbsIkk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 268/350] iio: adis16480: Fix scales factors
Date:   Tue, 10 Dec 2019 16:06:13 -0500
Message-Id: <20191210210735.9077-229-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 49549cb23a2926eba70bb634e361daea0f319794 ]

This patch fixes the scales for the gyroscope, accelerometer and
barometer. The pressure scale was just wrong. For the others, the scale
factors were not taking into account that a 32bit word is being read
from the device.

Fixes: 7abad1063deb ("iio: adis16480: Fix scale factors")
Fixes: 82e7a1b25017 ("iio: imu: adis16480: Add support for ADIS1649x family of devices")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/adis16480.c | 77 ++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/iio/imu/adis16480.c b/drivers/iio/imu/adis16480.c
index 8743b2f376e27..050652b8fee7b 100644
--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -623,9 +623,13 @@ static int adis16480_read_raw(struct iio_dev *indio_dev,
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
@@ -786,13 +790,14 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
@@ -802,9 +807,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
@@ -814,9 +819,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
@@ -826,9 +831,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
@@ -838,9 +843,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
@@ -851,9 +856,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
@@ -864,9 +869,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
@@ -877,9 +882,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
@@ -890,9 +895,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
@@ -903,9 +908,9 @@ static const struct adis16480_chip_info adis16480_chip_info[] = {
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
2.20.1

