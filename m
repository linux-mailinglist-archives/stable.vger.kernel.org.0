Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19F33C550E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhGLIJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348849AbhGLH6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9DF761970;
        Mon, 12 Jul 2021 07:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076386;
        bh=/fZB758hzdnvPo1+bhTptTyXJxF5I2XIqp4VRtP9a1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXGPpj8PfTyHaFT3OGO1ITHzJlgzRVcqMS6pgrVU2lWelHmehtlnHScFegFYRZ9zT
         sMbbfF/J/rEzMNwqc9rm12psanHxPW13UjWWo1NYQpNrjfCtGP01FHXGAdV8qSSQkm
         M1LKjmzRgfBB9gVphvAnJtlS5KoSUWp8B+GJa528=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 622/800] iio: accel: stk8ba50: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:45 +0200
Message-Id: <20210712061033.449794851@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 334883894bc1e145a1e0f5de1b0d1b6a1133f0e6 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of this function.

Fixes: db6a19b8251f ("iio: accel: Add trigger support for STK8BA50")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-8-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/stk8ba50.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/accel/stk8ba50.c b/drivers/iio/accel/stk8ba50.c
index 7cf9cb7e8666..eb9daa4e623a 100644
--- a/drivers/iio/accel/stk8ba50.c
+++ b/drivers/iio/accel/stk8ba50.c
@@ -91,12 +91,11 @@ struct stk8ba50_data {
 	u8 sample_rate_idx;
 	struct iio_trigger *dready_trig;
 	bool dready_trigger_on;
-	/*
-	 * 3 x 16-bit channels (10-bit data, 6-bit padding) +
-	 * 1 x 16 padding +
-	 * 4 x 16 64-bit timestamp
-	 */
-	s16 buffer[8];
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chans[3];
+		s64 timetamp __aligned(8);
+	} scan;
 };
 
 #define STK8BA50_ACCEL_CHANNEL(index, reg, axis) {			\
@@ -324,7 +323,7 @@ static irqreturn_t stk8ba50_trigger_handler(int irq, void *p)
 		ret = i2c_smbus_read_i2c_block_data(data->client,
 						    STK8BA50_REG_XOUT,
 						    STK8BA50_ALL_CHANNEL_SIZE,
-						    (u8 *)data->buffer);
+						    (u8 *)data->scan.chans);
 		if (ret < STK8BA50_ALL_CHANNEL_SIZE) {
 			dev_err(&data->client->dev, "register read failed\n");
 			goto err;
@@ -337,10 +336,10 @@ static irqreturn_t stk8ba50_trigger_handler(int irq, void *p)
 			if (ret < 0)
 				goto err;
 
-			data->buffer[i++] = ret;
+			data->scan.chans[i++] = ret;
 		}
 	}
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	mutex_unlock(&data->lock);
-- 
2.30.2



