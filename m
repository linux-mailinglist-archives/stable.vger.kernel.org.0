Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339B649166
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 22:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfFQUcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 16:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbfFQUcy (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 17 Jun 2019 16:32:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B23F920861;
        Mon, 17 Jun 2019 20:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560803573;
        bh=xuQL4t4dZ2DgIwPn3iw1U04YHgGgD1FYPPDmW31V0G8=;
        h=Subject:To:From:Date:From;
        b=RzK6eqRqfFv4JXR8Vr6N0ngiJOAGrhMBGrGsITS67fNHQPd1dA6GA8z0AxuMqPsXn
         xq5iu/oCC5bv8bSFbxxfzYGFjilqNEKSwO9OWejxUVDpEiJicBTrsjGpBBcUFX45Ks
         HeKhL25MxjATA+C0SKoXfYWZ9oeAZfoirR/J2j1k=
Subject: patch "iio: imu: st_lsm6dsx: fix PM support for st_lsm6dsx i2c controller" added to staging-linus
To:     lorenzo@kernel.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Jun 2019 22:32:42 +0200
Message-ID: <1560803562145218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: imu: st_lsm6dsx: fix PM support for st_lsm6dsx i2c controller

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From bce0d57db388cdb1c1931d0aa7d31c77b590e0f0 Mon Sep 17 00:00:00 2001
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sun, 19 May 2019 10:58:23 +0200
Subject: iio: imu: st_lsm6dsx: fix PM support for st_lsm6dsx i2c controller

Properly suspend/resume i2c slaves connected to st_lsm6dsx master
controller if the CPU goes in suspended state

Fixes: c91c1c844ebd ("imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h      |  2 ++
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c | 25 +++++++++++++-------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index 004a8a1a0027..6ef3577234a0 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -271,6 +271,7 @@ struct st_lsm6dsx_sensor {
  * @conf_lock: Mutex to prevent concurrent FIFO configuration update.
  * @page_lock: Mutex to prevent concurrent memory page configuration.
  * @fifo_mode: FIFO operating mode supported by the device.
+ * @suspend_mask: Suspended sensor bitmask.
  * @enable_mask: Enabled sensor bitmask.
  * @ts_sip: Total number of timestamp samples in a given pattern.
  * @sip: Total number of samples (acc/gyro/ts) in a given pattern.
@@ -288,6 +289,7 @@ struct st_lsm6dsx_hw {
 	struct mutex page_lock;
 
 	enum st_lsm6dsx_fifo_mode fifo_mode;
+	u8 suspend_mask;
 	u8 enable_mask;
 	u8 ts_sip;
 	u8 sip;
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index cf82c9049945..be5c87c8266d 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1110,8 +1110,6 @@ static int __maybe_unused st_lsm6dsx_suspend(struct device *dev)
 {
 	struct st_lsm6dsx_hw *hw = dev_get_drvdata(dev);
 	struct st_lsm6dsx_sensor *sensor;
-	const struct st_lsm6dsx_reg *reg;
-	unsigned int data;
 	int i, err = 0;
 
 	for (i = 0; i < ST_LSM6DSX_ID_MAX; i++) {
@@ -1122,12 +1120,16 @@ static int __maybe_unused st_lsm6dsx_suspend(struct device *dev)
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
@@ -1147,12 +1149,19 @@ static int __maybe_unused st_lsm6dsx_resume(struct device *dev)
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
2.22.0


