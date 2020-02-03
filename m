Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2A6150E15
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgBCQss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:48:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbgBCQZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:44 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F37321582;
        Mon,  3 Feb 2020 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747143;
        bh=g/+wUwjKhuioqfJaajiZ0MXi6QiA3adqp7R+cE0Pu58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7PTy/nzpGYtTQy11Xe8mvV87RqUbU6vOygbtIF0jZDlqm1izAIAEOLdrK9FiiCWU
         VWzR5tHFsWvqnS9rkAXcKGTn6WsIhhjLl6ITc8LG7DXClz1Ylt+Kkt53DNKmgjVGWX
         xsRfa7FthJ4IDe+/E1i1QQDlAnxI+pZXGIpKdpmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo.bianconi@st.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 29/68] iio: gyro: st_gyro: fix L3GD20H support
Date:   Mon,  3 Feb 2020 16:19:25 +0000
Message-Id: <20200203161909.808486209@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

[ Upstream commit 45a4e4220bf4927e321e18750e47c576bf62b000 ]

Add proper support for L3GD20H gyroscope sensor. In particular:
- use L3GD20H as device name instead of L3GD20
- fix available full scales
- fix available sample frequencies

Note that the original patch listed first below introduced broken support for
this part.  The second patch drops the support as it didn't work.

This new patch brings in working support.

Fixes: 9444a300c2be (IIO: Add support for L3GD20H gyroscope)
Fixes: a0657716416f ("iio:gyro: bug on L3GD20H gyroscope support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@st.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/gyro/st_gyro.h      |  1 +
 drivers/iio/gyro/st_gyro_core.c | 13 +++++++------
 drivers/iio/gyro/st_gyro_i2c.c  |  5 +++++
 drivers/iio/gyro/st_gyro_spi.c  |  1 +
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/gyro/st_gyro.h b/drivers/iio/gyro/st_gyro.h
index a5c5c4e29addc..48923ae6ac3bd 100644
--- a/drivers/iio/gyro/st_gyro.h
+++ b/drivers/iio/gyro/st_gyro.h
@@ -19,6 +19,7 @@
 #define LSM330DL_GYRO_DEV_NAME		"lsm330dl_gyro"
 #define LSM330DLC_GYRO_DEV_NAME		"lsm330dlc_gyro"
 #define L3GD20_GYRO_DEV_NAME		"l3gd20"
+#define L3GD20H_GYRO_DEV_NAME		"l3gd20h"
 #define L3G4IS_GYRO_DEV_NAME		"l3g4is_ui"
 #define LSM330_GYRO_DEV_NAME		"lsm330_gyro"
 #define LSM9DS0_GYRO_DEV_NAME		"lsm9ds0_gyro"
diff --git a/drivers/iio/gyro/st_gyro_core.c b/drivers/iio/gyro/st_gyro_core.c
index 2a42b3d583e85..e366422e85127 100644
--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -35,6 +35,7 @@
 #define ST_GYRO_DEFAULT_OUT_Z_L_ADDR		0x2c
 
 /* FULLSCALE */
+#define ST_GYRO_FS_AVL_245DPS			245
 #define ST_GYRO_FS_AVL_250DPS			250
 #define ST_GYRO_FS_AVL_500DPS			500
 #define ST_GYRO_FS_AVL_2000DPS			2000
@@ -196,17 +197,17 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 		.wai = 0xd7,
 		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,
 		.sensors_supported = {
-			[0] = L3GD20_GYRO_DEV_NAME,
+			[0] = L3GD20H_GYRO_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
 		.odr = {
 			.addr = 0x20,
 			.mask = 0xc0,
 			.odr_avl = {
-				{ .hz = 95, .value = 0x00, },
-				{ .hz = 190, .value = 0x01, },
-				{ .hz = 380, .value = 0x02, },
-				{ .hz = 760, .value = 0x03, },
+				{ .hz = 100, .value = 0x00, },
+				{ .hz = 200, .value = 0x01, },
+				{ .hz = 400, .value = 0x02, },
+				{ .hz = 800, .value = 0x03, },
 			},
 		},
 		.pw = {
@@ -224,7 +225,7 @@ static const struct st_sensor_settings st_gyro_sensors_settings[] = {
 			.mask = 0x30,
 			.fs_avl = {
 				[0] = {
-					.num = ST_GYRO_FS_AVL_250DPS,
+					.num = ST_GYRO_FS_AVL_245DPS,
 					.value = 0x00,
 					.gain = IIO_DEGREE_TO_RAD(8750),
 				},
diff --git a/drivers/iio/gyro/st_gyro_i2c.c b/drivers/iio/gyro/st_gyro_i2c.c
index 40056b8210364..3f628746cb93e 100644
--- a/drivers/iio/gyro/st_gyro_i2c.c
+++ b/drivers/iio/gyro/st_gyro_i2c.c
@@ -40,6 +40,10 @@ static const struct of_device_id st_gyro_of_match[] = {
 		.compatible = "st,l3gd20-gyro",
 		.data = L3GD20_GYRO_DEV_NAME,
 	},
+	{
+		.compatible = "st,l3gd20h-gyro",
+		.data = L3GD20H_GYRO_DEV_NAME,
+	},
 	{
 		.compatible = "st,l3g4is-gyro",
 		.data = L3G4IS_GYRO_DEV_NAME,
@@ -95,6 +99,7 @@ static const struct i2c_device_id st_gyro_id_table[] = {
 	{ LSM330DL_GYRO_DEV_NAME },
 	{ LSM330DLC_GYRO_DEV_NAME },
 	{ L3GD20_GYRO_DEV_NAME },
+	{ L3GD20H_GYRO_DEV_NAME },
 	{ L3G4IS_GYRO_DEV_NAME },
 	{ LSM330_GYRO_DEV_NAME },
 	{ LSM9DS0_GYRO_DEV_NAME },
diff --git a/drivers/iio/gyro/st_gyro_spi.c b/drivers/iio/gyro/st_gyro_spi.c
index fbf2faed501c8..fa14d8f2170d7 100644
--- a/drivers/iio/gyro/st_gyro_spi.c
+++ b/drivers/iio/gyro/st_gyro_spi.c
@@ -52,6 +52,7 @@ static const struct spi_device_id st_gyro_id_table[] = {
 	{ LSM330DL_GYRO_DEV_NAME },
 	{ LSM330DLC_GYRO_DEV_NAME },
 	{ L3GD20_GYRO_DEV_NAME },
+	{ L3GD20H_GYRO_DEV_NAME },
 	{ L3G4IS_GYRO_DEV_NAME },
 	{ LSM330_GYRO_DEV_NAME },
 	{ LSM9DS0_GYRO_DEV_NAME },
-- 
2.20.1



