Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C68F7C8E
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbfKKSrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:47:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbfKKSrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:47:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E52221655;
        Mon, 11 Nov 2019 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498038;
        bh=Qx6rEvYfQ/vz4Rbc+dIQHrZu8mzVfOmIM+BjA2Ep5dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUJ8PNZwqdfKrJfNQAH8j2JkHW7B7UrKTDPTmECKQN9DEPAiPVGbaO/N3QYHyQGa/
         LWzaeqR1p2LqM+yM+sO2RLacuRTJcly34JZ+PDJisyzd/QpaCRilNdi6PUfWXwUpX8
         nw4lSbA6JuBXNnU7kqen0xT8VojBv247NsH9FviE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/125] iio: imu: inv_mpu6050: fix no data on MPU6050
Date:   Mon, 11 Nov 2019 19:29:22 +0100
Message-Id: <20191111181456.142299857@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Baptiste Maneyrol <JManeyrol@invensense.com>

[ Upstream commit 6e82ae6b8d11b948b74e71396efd8e074c415f44 ]

Some chips have a fifo overflow bit issue where the bit is always
set. The result is that every data is dropped.

Change fifo overflow management by checking fifo count against
a maximum value.

Add fifo size in chip hardware set of values.

Fixes: f5057e7b2dba ("iio: imu: inv_mpu6050: better fifo overflow handling")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |  9 +++++++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h  |  2 ++
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c | 15 ++++++++++++---
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index cb80c9e49fc7b..ea099523e0355 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -121,54 +121,63 @@ static const struct inv_mpu6050_hw hw_info[] = {
 		.name = "MPU6050",
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
+		.fifo_size = 1024,
 	},
 	{
 		.whoami = INV_MPU6500_WHOAMI_VALUE,
 		.name = "MPU6500",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_MPU6515_WHOAMI_VALUE,
 		.name = "MPU6515",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_MPU6000_WHOAMI_VALUE,
 		.name = "MPU6000",
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
+		.fifo_size = 1024,
 	},
 	{
 		.whoami = INV_MPU9150_WHOAMI_VALUE,
 		.name = "MPU9150",
 		.reg = &reg_set_6050,
 		.config = &chip_config_6050,
+		.fifo_size = 1024,
 	},
 	{
 		.whoami = INV_MPU9250_WHOAMI_VALUE,
 		.name = "MPU9250",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_MPU9255_WHOAMI_VALUE,
 		.name = "MPU9255",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_ICM20608_WHOAMI_VALUE,
 		.name = "ICM20608",
 		.reg = &reg_set_6500,
 		.config = &chip_config_6050,
+		.fifo_size = 512,
 	},
 	{
 		.whoami = INV_ICM20602_WHOAMI_VALUE,
 		.name = "ICM20602",
 		.reg = &reg_set_icm20602,
 		.config = &chip_config_6050,
+		.fifo_size = 1008,
 	},
 };
 
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
index bdbaf6e01ce3e..e56c1d191ae46 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -108,12 +108,14 @@ struct inv_mpu6050_chip_config {
  *  @name:      name of the chip.
  *  @reg:   register map of the chip.
  *  @config:    configuration of the chip.
+ *  @fifo_size:	size of the FIFO in bytes.
  */
 struct inv_mpu6050_hw {
 	u8 whoami;
 	u8 *name;
 	const struct inv_mpu6050_reg_map *reg;
 	const struct inv_mpu6050_chip_config *config;
+	size_t fifo_size;
 };
 
 /*
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
index 548e042f7b5bd..4f9c2765aa23f 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -188,9 +188,6 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 			"failed to ack interrupt\n");
 		goto flush_fifo;
 	}
-	/* handle fifo overflow by reseting fifo */
-	if (int_status & INV_MPU6050_BIT_FIFO_OVERFLOW_INT)
-		goto flush_fifo;
 	if (!(int_status & INV_MPU6050_BIT_RAW_DATA_RDY_INT)) {
 		dev_warn(regmap_get_device(st->map),
 			"spurious interrupt with status 0x%x\n", int_status);
@@ -216,6 +213,18 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 	if (result)
 		goto end_session;
 	fifo_count = get_unaligned_be16(&data[0]);
+
+	/*
+	 * Handle fifo overflow by resetting fifo.
+	 * Reset if there is only 3 data set free remaining to mitigate
+	 * possible delay between reading fifo count and fifo data.
+	 */
+	nb = 3 * bytes_per_datum;
+	if (fifo_count >= st->hw->fifo_size - nb) {
+		dev_warn(regmap_get_device(st->map), "fifo overflow reset\n");
+		goto flush_fifo;
+	}
+
 	/* compute and process all complete datum */
 	nb = fifo_count / bytes_per_datum;
 	inv_mpu6050_update_period(st, pf->timestamp, nb);
-- 
2.20.1



