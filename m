Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759B83CDD94
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhGSO6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237756AbhGSO57 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A6A36120C;
        Mon, 19 Jul 2021 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708935;
        bh=KIctiX+qkkb2JGot/CjdDUu0zcaztywjIL1hxxdO7nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yc0P3jZdoWE/e8moGMIzqH0hHRRZ3c5A05rs0+JdEZleuOyXfv+lFNSB9mAIZpfSB
         gHzcdcgk+ZGQKFLd72YkJtIz+K8uWKPo0dbrX7gEk3X2f6jsWZkavH5eZj+0NvbrWz
         bJve63onUtgsP7/YtBj1r13tT9A6NuHSeyUHrOHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 181/421] iio: light: isl29125: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:49:52 +0200
Message-Id: <20210719144952.706487225@linuxfoundation.org>
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

[ Upstream commit 3d4725194de6935dba2ad7c9cc075c885008f747 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: 6c25539cbc46 ("iio: Add Intersil isl29125 digital color light sensor driver")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-18-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/isl29125.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/isl29125.c b/drivers/iio/light/isl29125.c
index ed38edcd5efe..d0f5fd42c0ec 100644
--- a/drivers/iio/light/isl29125.c
+++ b/drivers/iio/light/isl29125.c
@@ -54,7 +54,11 @@
 struct isl29125_data {
 	struct i2c_client *client;
 	u8 conf1;
-	u16 buffer[8]; /* 3x 16-bit, padding, 8 bytes timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u16 chans[3];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 #define ISL29125_CHANNEL(_color, _si) { \
@@ -187,10 +191,10 @@ static irqreturn_t isl29125_trigger_handler(int irq, void *p)
 		if (ret < 0)
 			goto done;
 
-		data->buffer[j++] = ret;
+		data->scan.chans[j++] = ret;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 		iio_get_time_ns(indio_dev));
 
 done:
-- 
2.30.2



