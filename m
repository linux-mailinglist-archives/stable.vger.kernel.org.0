Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D06A3C5519
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352166AbhGLIJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352582AbhGLH7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C7CB61941;
        Mon, 12 Jul 2021 07:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076407;
        bh=Ktf0grcfzbxyC5USj04FzTLhNlEuNC8SKhMXtbgkEEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjc1Ma2OVabSlhTCeHEhg1/E90BC6tszL49TfwsnbiZ1cvFMhuRf56E5TyyZb/6Nw
         RWqNMCpj4IBohLhdLmNyEPgfRH/Qr/n/3RG/gb6T8Pkxqra6guCRJLn/kh3v6kkWqA
         zXmwPPmXhKeXStrXGpnZE5nvFvUR8pHFpXENsVUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 630/800] iio: magn: hmc5843: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:53 +0200
Message-Id: <20210712061034.219022879@linuxfoundation.org>
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

[ Upstream commit 1ef2f51e9fe424ccecca5bb0373d71b900c2cd41 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: 7247645f6865 ("iio: hmc5843: Move hmc5843 out of staging")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-16-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/hmc5843.h      | 8 ++++++--
 drivers/iio/magnetometer/hmc5843_core.c | 4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/magnetometer/hmc5843.h b/drivers/iio/magnetometer/hmc5843.h
index 3f6c0b662941..242f742f2643 100644
--- a/drivers/iio/magnetometer/hmc5843.h
+++ b/drivers/iio/magnetometer/hmc5843.h
@@ -33,7 +33,8 @@ enum hmc5843_ids {
  * @lock:		update and read regmap data
  * @regmap:		hardware access register maps
  * @variant:		describe chip variants
- * @buffer:		3x 16-bit channels + padding + 64-bit timestamp
+ * @scan:		buffer to pack data for passing to
+ *			iio_push_to_buffers_with_timestamp()
  */
 struct hmc5843_data {
 	struct device *dev;
@@ -41,7 +42,10 @@ struct hmc5843_data {
 	struct regmap *regmap;
 	const struct hmc5843_chip_info *variant;
 	struct iio_mount_matrix orientation;
-	__be16 buffer[8];
+	struct {
+		__be16 chans[3];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 int hmc5843_common_probe(struct device *dev, struct regmap *regmap,
diff --git a/drivers/iio/magnetometer/hmc5843_core.c b/drivers/iio/magnetometer/hmc5843_core.c
index 780faea61d82..221563e0c18f 100644
--- a/drivers/iio/magnetometer/hmc5843_core.c
+++ b/drivers/iio/magnetometer/hmc5843_core.c
@@ -446,13 +446,13 @@ static irqreturn_t hmc5843_trigger_handler(int irq, void *p)
 	}
 
 	ret = regmap_bulk_read(data->regmap, HMC5843_DATA_OUT_MSB_REGS,
-			       data->buffer, 3 * sizeof(__be16));
+			       data->scan.chans, sizeof(data->scan.chans));
 
 	mutex_unlock(&data->lock);
 	if (ret < 0)
 		goto done;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buffer,
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
 					   iio_get_time_ns(indio_dev));
 
 done:
-- 
2.30.2



