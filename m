Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07734578BB
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfF0AbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbfF0AbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:16 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B21B1216E3;
        Thu, 27 Jun 2019 00:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595475;
        bh=izG3SCuNQy/aSYFelT4kpyUT0lPwO5iH4uBJMSPnCdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7V7HEbC8hcb1yw94wUpZQBl9RLsW5GUT0uvmBBVt4jGhqhS5Yo5FfripmYgJq7xC
         5iZElix+p+XAgK1NMCgUo0qb5eErDKy8iw2bJ1X14kpEH4ggqAj7NUSzOXpW+R4h0J
         98OFsYZatjdg3xnYx/MlQLdOx6yov2/Nt29MrIY0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 17/95] iio: imu: st_lsm6dsx: fix PM support for st_lsm6dsx i2c controller
Date:   Wed, 26 Jun 2019 20:29:02 -0400
Message-Id: <20190627003021.19867-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit bce0d57db388cdb1c1931d0aa7d31c77b590e0f0 ]

Properly suspend/resume i2c slaves connected to st_lsm6dsx master
controller if the CPU goes in suspended state

Fixes: c91c1c844ebd ("imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h      |  2 ++
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 25 +++++++++++++-------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index d1d8d07a0714..83425b7b580c 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -265,6 +265,7 @@ struct st_lsm6dsx_sensor {
  * @conf_lock: Mutex to prevent concurrent FIFO configuration update.
  * @page_lock: Mutex to prevent concurrent memory page configuration.
  * @fifo_mode: FIFO operating mode supported by the device.
+ * @suspend_mask: Suspended sensor bitmask.
  * @enable_mask: Enabled sensor bitmask.
  * @ts_sip: Total number of timestamp samples in a given pattern.
  * @sip: Total number of samples (acc/gyro/ts) in a given pattern.
@@ -282,6 +283,7 @@ struct st_lsm6dsx_hw {
 	struct mutex page_lock;
 
 	enum st_lsm6dsx_fifo_mode fifo_mode;
+	u8 suspend_mask;
 	u8 enable_mask;
 	u8 ts_sip;
 	u8 sip;
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index 12e29dda9b98..96986d84e418 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1023,8 +1023,6 @@ static int __maybe_unused st_lsm6dsx_suspend(struct device *dev)
 {
 	struct st_lsm6dsx_hw *hw = dev_get_drvdata(dev);
 	struct st_lsm6dsx_sensor *sensor;
-	const struct st_lsm6dsx_reg *reg;
-	unsigned int data;
 	int i, err = 0;
 
 	for (i = 0; i < ST_LSM6DSX_ID_MAX; i++) {
@@ -1035,12 +1033,16 @@ static int __maybe_unused st_lsm6dsx_suspend(struct device *dev)
 		if (!(hw->enable_mask & BIT(sensor->id)))
 			continue;
 
-		reg = &st_lsm6dsx_odr_table[sensor->id].reg;
-		data = ST_LSM6DSX_SHIFT_VAL(0, reg->mask);
-		err = st_lsm6dsx_update_bits_locked(hw, reg->addr, reg->mask,
-						    data);
+		if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
+		    sensor->id == ST_LSM6DSX_ID_EXT1 ||
+		    sensor->id == ST_LSM6DSX_ID_EXT2)
+			err = st_lsm6dsx_shub_set_enable(sensor, false);
+		else
+			err = st_lsm6dsx_sensor_set_enable(sensor, false);
 		if (err < 0)
 			return err;
+
+		hw->suspend_mask |= BIT(sensor->id);
 	}
 
 	if (hw->fifo_mode != ST_LSM6DSX_FIFO_BYPASS)
@@ -1060,12 +1062,19 @@ static int __maybe_unused st_lsm6dsx_resume(struct device *dev)
 			continue;
 
 		sensor = iio_priv(hw->iio_devs[i]);
-		if (!(hw->enable_mask & BIT(sensor->id)))
+		if (!(hw->suspend_mask & BIT(sensor->id)))
 			continue;
 
-		err = st_lsm6dsx_set_odr(sensor, sensor->odr);
+		if (sensor->id == ST_LSM6DSX_ID_EXT0 ||
+		    sensor->id == ST_LSM6DSX_ID_EXT1 ||
+		    sensor->id == ST_LSM6DSX_ID_EXT2)
+			err = st_lsm6dsx_shub_set_enable(sensor, true);
+		else
+			err = st_lsm6dsx_sensor_set_enable(sensor, true);
 		if (err < 0)
 			return err;
+
+		hw->suspend_mask &= ~BIT(sensor->id);
 	}
 
 	if (hw->enable_mask)
-- 
2.20.1

