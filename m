Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7E91BFD82
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgD3Nux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbgD3Nuw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:50:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CBC42082E;
        Thu, 30 Apr 2020 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254651;
        bh=GGkKolB6djd+U08nwmIRdHQEeCeGc/19vG9CHNZeoqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKLT2SatG1ZwR1txEpLZgZNr2FYUOY9pFGyWxloT1mufEDHca40YR3MktdjGb/YRu
         NIOwYkq7M1oGOfmpHs2zdKQfaqs0UH62r9wJseiLXOSfLE0CyMZF8fagFfIQF+xxHT
         IINKVT4ISdcwV22T6MnKJ77kcUBps9RgKmYpQKvc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 06/79] iio: imu: st_lsm6dsx: specify slave odr in slv_odr
Date:   Thu, 30 Apr 2020 09:49:30 -0400
Message-Id: <20200430135043.19851-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 76551a3c3df151750a842b003c6899e9c62e0fd2 ]

Introduce slv_odr in ext_info data structure in order to distinguish
between sensor hub trigger (accel sensor) odr and i2c slave odr and
properly compute samples in FIFO pattern

Fixes: e485e2a2cfd6 ("iio: imu: st_lsm6dsx: enable sensor-hub support for lsm6dsm")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h      |  1 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c | 29 +++++++++++++++-----
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index b8ed6c900c457..84b27b6241495 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -357,6 +357,7 @@ struct st_lsm6dsx_sensor {
 
 	struct {
 		const struct st_lsm6dsx_ext_dev_settings *settings;
+		u32 slv_odr;
 		u8 addr;
 	} ext_info;
 };
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
index 95ddd19d1aa7c..64ef07a307263 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -421,7 +421,8 @@ int st_lsm6dsx_shub_set_enable(struct st_lsm6dsx_sensor *sensor, bool enable)
 
 	settings = sensor->ext_info.settings;
 	if (enable) {
-		err = st_lsm6dsx_shub_set_odr(sensor, sensor->odr);
+		err = st_lsm6dsx_shub_set_odr(sensor,
+					      sensor->ext_info.slv_odr);
 		if (err < 0)
 			return err;
 	} else {
@@ -459,7 +460,7 @@ st_lsm6dsx_shub_read_oneshot(struct st_lsm6dsx_sensor *sensor,
 	if (err < 0)
 		return err;
 
-	delay = 1000000000 / sensor->odr;
+	delay = 1000000000 / sensor->ext_info.slv_odr;
 	usleep_range(delay, 2 * delay);
 
 	len = min_t(int, sizeof(data), ch->scan_type.realbits >> 3);
@@ -500,8 +501,8 @@ st_lsm6dsx_shub_read_raw(struct iio_dev *iio_dev,
 		iio_device_release_direct_mode(iio_dev);
 		break;
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		*val = sensor->odr / 1000;
-		*val2 = (sensor->odr % 1000) * 1000;
+		*val = sensor->ext_info.slv_odr / 1000;
+		*val2 = (sensor->ext_info.slv_odr % 1000) * 1000;
 		ret = IIO_VAL_INT_PLUS_MICRO;
 		break;
 	case IIO_CHAN_INFO_SCALE:
@@ -535,8 +536,20 @@ st_lsm6dsx_shub_write_raw(struct iio_dev *iio_dev,
 
 		val = val * 1000 + val2 / 1000;
 		err = st_lsm6dsx_shub_get_odr_val(sensor, val, &data);
-		if (!err)
-			sensor->odr = val;
+		if (!err) {
+			struct st_lsm6dsx_hw *hw = sensor->hw;
+			struct st_lsm6dsx_sensor *ref_sensor;
+			u8 odr_val;
+			int odr;
+
+			ref_sensor = iio_priv(hw->iio_devs[ST_LSM6DSX_ID_ACC]);
+			odr = st_lsm6dsx_check_odr(ref_sensor, val, &odr_val);
+			if (odr < 0)
+				return odr;
+
+			sensor->ext_info.slv_odr = val;
+			sensor->odr = odr;
+		}
 		break;
 	}
 	default:
@@ -613,6 +626,7 @@ st_lsm6dsx_shub_alloc_iiodev(struct st_lsm6dsx_hw *hw,
 			     const struct st_lsm6dsx_ext_dev_settings *info,
 			     u8 i2c_addr, const char *name)
 {
+	enum st_lsm6dsx_sensor_id ref_id = ST_LSM6DSX_ID_ACC;
 	struct iio_chan_spec *ext_channels;
 	struct st_lsm6dsx_sensor *sensor;
 	struct iio_dev *iio_dev;
@@ -628,7 +642,8 @@ st_lsm6dsx_shub_alloc_iiodev(struct st_lsm6dsx_hw *hw,
 	sensor = iio_priv(iio_dev);
 	sensor->id = id;
 	sensor->hw = hw;
-	sensor->odr = info->odr_table.odr_avl[0].milli_hz;
+	sensor->odr = hw->settings->odr_table[ref_id].odr_avl[0].milli_hz;
+	sensor->ext_info.slv_odr = info->odr_table.odr_avl[0].milli_hz;
 	sensor->gain = info->fs_table.fs_avl[0].gain;
 	sensor->ext_info.settings = info;
 	sensor->ext_info.addr = i2c_addr;
-- 
2.20.1

