Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36953C47A3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhGLGd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234861AbhGLG2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD135610FA;
        Mon, 12 Jul 2021 06:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071081;
        bh=nJsOtoWsL/fl7P58w+c06vgkdftY3UrTr9vD9JiarCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NX7JRPxUE0SSafyIT2aQk6v/bbAwT5W0wtGrx6Id7N1jyebPFjXG9C3+BPdNhZjlT
         xP6XKYZRFToBT6LCfqwKXNSVLLCnaqtq2/UO+K+yZkxKe66ScEA1w0jLcPM4awcxMg
         gJhPD8wYeiQl9UKDN6L1cbv+nJPDVpvk8hWR9+gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 267/348] iio: accel: stk8ba50: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:51 +0200
Message-Id: <20210712060738.862850254@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index c70ddec29eb4..edba3c13a979 100644
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



