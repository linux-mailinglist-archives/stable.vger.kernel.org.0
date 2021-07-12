Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9FC3C5512
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344697AbhGLIJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352429AbhGLH7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:59:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFF6E613D6;
        Mon, 12 Jul 2021 07:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076393;
        bh=HJtyBbowZ8yR61CU1kIwhtfWAHhQF0Ef5X+1SRF6nR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSO5GTcFM08X0a3EcQBoq7oqSksrOMmzNC7C9lI327ujcL/Kvz33ansxKOSK8e70c
         IA+RlpNFMFDeML9IRDxLbgW5BonTDzF/nNtCrwpcMzXLEE7HrbXEsNw301cXtnBcXT
         fvKTBuCKqVYBRh/sMoLHDNNDDuk6OE+588mJ74a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 625/800] iio: gyro: bmg160: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:48 +0200
Message-Id: <20210712061033.735195814@linuxfoundation.org>
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

[ Upstream commit 06778d881f3798ce93ffbbbf801234292250b598 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: 13426454b649 ("iio: bmg160: Separate i2c and core driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-11-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/gyro/bmg160_core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/gyro/bmg160_core.c b/drivers/iio/gyro/bmg160_core.c
index b11ebd9bb7a4..7bc13ff2c3ac 100644
--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -98,7 +98,11 @@ struct bmg160_data {
 	struct iio_trigger *motion_trig;
 	struct iio_mount_matrix orientation;
 	struct mutex mutex;
-	s16 buffer[8];
+	/* Ensure naturally aligned timestamp */
+	struct {
+		s16 chans[3];
+		s64 timestamp __aligned(8);
+	} scan;
 	u32 dps_range;
 	int ev_enable_state;
 	int slope_thres;
@@ -882,12 +886,12 @@ static irqreturn_t bmg160_trigger_handler(int irq, void *p)
 
 	mutex_lock(&data->mutex);
 	ret = regmap_bulk_read(data->regmap, BMG160_REG_XOUT_L,
-			       data->buffer, AXIS_MAX * 2);
+			       data->scan.chans, AXIS_MAX * 2);
 	mutex_unlock(&data->mutex);
 	if (ret < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   pf->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.30.2



