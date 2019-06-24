Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E705077D
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfFXKH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730288AbfFXKHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:22 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 691772089F;
        Mon, 24 Jun 2019 10:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370840;
        bh=HgDUW2KYUIZYgPutLyj9FZb1NEFdvdEA4TLIBtMBMY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQyX0g0pi19HREIQcA23Fx1tPKNK8axX8Vt9iEtME0jPM/184uGLus2eWQm2bTCC2
         MjCkQnG5M3bVAxMGCDXxx4U0V6DNikcP8rKi2IcjIKgskj1AMV2SD8GiYINWOBjpVo
         sJpiC55ZhCTxKw8KXQ2yOsMYNuwFp2GnUPsVn4ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.1 020/121] iio: imu: st_lsm6dsx: fix PM support for st_lsm6dsx i2c controller
Date:   Mon, 24 Jun 2019 17:55:52 +0800
Message-Id: <20190624092321.669329010@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit bce0d57db388cdb1c1931d0aa7d31c77b590e0f0 upstream.

Properly suspend/resume i2c slaves connected to st_lsm6dsx master
controller if the CPU goes in suspended state

Fixes: c91c1c844ebd ("imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h      |    2 ++
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c |   25 +++++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

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
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1023,8 +1023,6 @@ static int __maybe_unused st_lsm6dsx_sus
 {
 	struct st_lsm6dsx_hw *hw = dev_get_drvdata(dev);
 	struct st_lsm6dsx_sensor *sensor;
-	const struct st_lsm6dsx_reg *reg;
-	unsigned int data;
 	int i, err = 0;
 
 	for (i = 0; i < ST_LSM6DSX_ID_MAX; i++) {
@@ -1035,12 +1033,16 @@ static int __maybe_unused st_lsm6dsx_sus
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
@@ -1060,12 +1062,19 @@ static int __maybe_unused st_lsm6dsx_res
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


