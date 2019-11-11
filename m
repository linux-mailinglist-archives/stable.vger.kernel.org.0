Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90241F6E83
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfKKGWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:22:15 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37125 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbfKKGWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:22:15 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2684820F20;
        Mon, 11 Nov 2019 01:22:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:22:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HvrS+s
        DQZpyZLN0fcTiYSzV7vkeRJLL5sVUiJOnPx4o=; b=aKIEmFMu+hHLX+e8lqFUKj
        ORo+Q/Dob2v1W7EPfIO99BYvO8JoMmOTQMOjWTaKh7UEgE1qW+mhKr/LMLaem3tL
        tW43Nchg9NKXXHYiv5mSEou6KIezOtUACqjByb4I0dTHUlp002PTRbg+p5fK6GsH
        6ivSdv33BVdW4VMci10+L6DxWRrx09+Z93jhjI1muXX7relZSjStVqIkk6VjqjOo
        l+x0WSyu8PUwpKGpIUsIeVgXL4FOoDoOBYXaAb+mWO9xS1D4KUL41F1BimVV05iQ
        BkXmuGVRFTYh4duwg47HuHm6mMuJISZM82rQ2MBgByhz7fbkeROS3xnVqR46ip7Q
        ==
X-ME-Sender: <xms:Ff7IXXBEKd_v4fCcGTZttKjvQFrPWxdsPOXpbexncUY24cNPe4634Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Ff7IXVI8Bkdp6CIFRc6B_CxCGYvbniU7nFH4gxiaR1u3jZ9qPoO9xA>
    <xmx:Ff7IXSxiOqUrjbxJjGF_aqYeGUobtKmbdHhA2wyMqKTG8caFbXzV9g>
    <xmx:Ff7IXRw6Yd0dacYSltK9rIqioonJZ0qYblNXig5xJ8p4_NdSP6XHMQ>
    <xmx:Fv7IXUs8C5s3jvM0UZR9yZ5hujKLLPEqvQfRT7XKTPb-ZbV5R2jNtA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7BC8E8005C;
        Mon, 11 Nov 2019 01:22:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050" failed to apply to 4.19-stable tree
To:     JManeyrol@invensense.com, Jonathan.Cameron@huawei.com,
        jmaneyrol@invensense.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 07:22:11 +0100
Message-ID: <15734533311935@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6e82ae6b8d11b948b74e71396efd8e074c415f44 Mon Sep 17 00:00:00 2001
From: Jean-Baptiste Maneyrol <JManeyrol@invensense.com>
Date: Wed, 16 Oct 2019 14:43:28 +0000
Subject: [PATCH] iio: imu: inv_mpu6050: fix no data on MPU6050

Some chips have a fifo overflow bit issue where the bit is always
set. The result is that every data is dropped.

Change fifo overflow management by checking fifo count against
a maximum value.

Add fifo size in chip hardware set of values.

Fixes: f5057e7b2dba ("iio: imu: inv_mpu6050: better fifo overflow handling")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index b17f060b52fc..868281b8adb0 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -114,54 +114,63 @@ static const struct inv_mpu6050_hw hw_info[] = {
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
index db1c6904388b..51235677c534 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -100,12 +100,14 @@ struct inv_mpu6050_chip_config {
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
index 5f9a5de0bab4..72d8c5790076 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -180,9 +180,6 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 			"failed to ack interrupt\n");
 		goto flush_fifo;
 	}
-	/* handle fifo overflow by reseting fifo */
-	if (int_status & INV_MPU6050_BIT_FIFO_OVERFLOW_INT)
-		goto flush_fifo;
 	if (!(int_status & INV_MPU6050_BIT_RAW_DATA_RDY_INT)) {
 		dev_warn(regmap_get_device(st->map),
 			"spurious interrupt with status 0x%x\n", int_status);
@@ -211,6 +208,18 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
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

