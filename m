Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F69272CB2
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgIUQeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728729AbgIUQeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:34:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 297202396F;
        Mon, 21 Sep 2020 16:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706056;
        bh=Jc1usuQYePYwelIwFEz7MACswEmum+bY+dZXAThvxyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dW1qotIVlz6GL/CIoiIgV2cfinti/p6+v9HkubWHYODh6iTggBvkwzm8Oae3Dxb4P
         T7yIi5TlEzfR+UrrAU8XDoco0EkSDsNJibhWwi9bgBjMqyFpPeL9bdFPrriR+ISYco
         T0z2CPO5X3zTfrPsA9jSP0hOa/wvVcZO2y2/o9YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sandhya Bankar <bankarsandhya512@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 4.9 22/70] drivers: iio: magnetometer: Fix sparse endianness warnings cast to restricted __be16
Date:   Mon, 21 Sep 2020 18:27:22 +0200
Message-Id: <20200921162036.137321132@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandhya Bankar <bankarsandhya512@gmail.com>

commit 69c72ec9c80bbd206c6fac73874d73e69cc623b4 upstream.

Fix the following sparse endianness warnings:

drivers/iio/magnetometer/ak8975.c:716:16: warning: cast to restricted __le16
drivers/iio/magnetometer/ak8975.c:837:19: warning: cast to restricted __le16
drivers/iio/magnetometer/ak8975.c:838:19: warning: cast to restricted __le16
drivers/iio/magnetometer/ak8975.c:839:19: warning: cast to restricted __le16

Signed-off-by: Sandhya Bankar <bankarsandhya512@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/magnetometer/ak8975.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -690,6 +690,7 @@ static int ak8975_read_axis(struct iio_d
 	struct ak8975_data *data = iio_priv(indio_dev);
 	const struct i2c_client *client = data->client;
 	const struct ak_def *def = data->def;
+	__le16 rval;
 	u16 buff;
 	int ret;
 
@@ -703,7 +704,7 @@ static int ak8975_read_axis(struct iio_d
 
 	ret = i2c_smbus_read_i2c_block_data_or_emulated(
 			client, def->data_regs[index],
-			sizeof(buff), (u8*)&buff);
+			sizeof(rval), (u8*)&rval);
 	if (ret < 0)
 		goto exit;
 
@@ -713,7 +714,7 @@ static int ak8975_read_axis(struct iio_d
 	pm_runtime_put_autosuspend(&data->client->dev);
 
 	/* Swap bytes and convert to valid range. */
-	buff = le16_to_cpu(buff);
+	buff = le16_to_cpu(rval);
 	*val = clamp_t(s16, buff, -def->range, def->range);
 	return IIO_VAL_INT;
 
@@ -813,6 +814,7 @@ static void ak8975_fill_buffer(struct ii
 	const struct ak_def *def = data->def;
 	int ret;
 	s16 buff[8]; /* 3 x 16 bits axis values + 1 aligned 64 bits timestamp */
+	__le16 fval[3];
 
 	mutex_lock(&data->lock);
 
@@ -826,17 +828,17 @@ static void ak8975_fill_buffer(struct ii
 	 */
 	ret = i2c_smbus_read_i2c_block_data_or_emulated(client,
 							def->data_regs[0],
-							3 * sizeof(buff[0]),
-							(u8 *)buff);
+							3 * sizeof(fval[0]),
+							(u8 *)fval);
 	if (ret < 0)
 		goto unlock;
 
 	mutex_unlock(&data->lock);
 
 	/* Clamp to valid range. */
-	buff[0] = clamp_t(s16, le16_to_cpu(buff[0]), -def->range, def->range);
-	buff[1] = clamp_t(s16, le16_to_cpu(buff[1]), -def->range, def->range);
-	buff[2] = clamp_t(s16, le16_to_cpu(buff[2]), -def->range, def->range);
+	buff[0] = clamp_t(s16, le16_to_cpu(fval[0]), -def->range, def->range);
+	buff[1] = clamp_t(s16, le16_to_cpu(fval[1]), -def->range, def->range);
+	buff[2] = clamp_t(s16, le16_to_cpu(fval[2]), -def->range, def->range);
 
 	iio_push_to_buffers_with_timestamp(indio_dev, buff,
 					   iio_get_time_ns(indio_dev));


