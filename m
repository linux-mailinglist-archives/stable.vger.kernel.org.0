Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18793CDD83
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245549AbhGSO62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244938AbhGSO5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A9A4613B7;
        Mon, 19 Jul 2021 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708909;
        bh=twwYrvORNFO2Sab2YTa6Ids59JHOYQ8T2qEyxeF+ZFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvDef0soHJeV7XT75Da/BCy3Za3h54bTSzfapt/vFbPhu6NDgcJ+4E/dfpL94n98P
         dLhccjvv3JmrUWbxSXKKiRcKLyehdr5JiB1uhc8M5XvDl+nr0bePU+0h6Jj3KfAC3c
         DdfU7tHR1JPt2d+Qeroe8S7UWs3kEiCz2iFHvvK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/421] iio: humidity: am2315: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:49:48 +0200
Message-Id: <20210719144952.573522843@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit f4ca2e2595d9fee65d5ce0d218b22ce00e5b2915 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: 0d96d5ead3f7 ("iio: humidity: Add triggered buffer support for AM2315")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-12-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/humidity/am2315.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/humidity/am2315.c b/drivers/iio/humidity/am2315.c
index 7d8669dc6547..b09bd0b39c9c 100644
--- a/drivers/iio/humidity/am2315.c
+++ b/drivers/iio/humidity/am2315.c
@@ -36,7 +36,11 @@
 struct am2315_data {
 	struct i2c_client *client;
 	struct mutex lock;
-	s16 buffer[8]; /* 2x16-bit channels + 2x16 padding + 4x16 timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chans[2];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 struct am2315_sensor_data {
@@ -170,20 +174,20 @@ static irqreturn_t am2315_trigger_handler(int irq, void *p)
 
 	mutex_lock(&data->lock);
 	if (*(indio_dev->active_scan_mask) == AM2315_ALL_CHANNEL_MASK) {
-		data->buffer[0] = sensor_data.hum_data;
-		data->buffer[1] = sensor_data.temp_data;
+		data->scan.chans[0] = sensor_data.hum_data;
+		data->scan.chans[1] = sensor_data.temp_data;
 	} else {
 		i = 0;
 		for_each_set_bit(bit, indio_dev->active_scan_mask,
 				 indio_dev->masklength) {
-			data->buffer[i] = (bit ? sensor_data.temp_data :
-						 sensor_data.hum_data);
+			data->scan.chans[i] = (bit ? sensor_data.temp_data :
+					       sensor_data.hum_data);
 			i++;
 		}
 	}
 	mutex_unlock(&data->lock);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.30.2



