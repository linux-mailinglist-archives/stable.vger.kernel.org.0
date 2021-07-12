Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA083C5521
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353444AbhGLIJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352871AbhGLIAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5950D61C1A;
        Mon, 12 Jul 2021 07:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076416;
        bh=4v+nseQdWKDdrAUHjCL5B0ijZTrXt6zOPA7+ThEi7D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIAAhwd03BhsMes8n1yr72NAY9BI6nLjyF2/kyA2fX1VmMzG0PvXKRLWzXxJ1vKtE
         PAhr7wiI2LN7/0qu1jkDoPGCtqxAduA5xHJzaYVc+ABDV0uossfVd55+c+e7h4OXyU
         ufmSDaze0EBWY2+s5xhb8OpAFUROfGj/rVNtVQ3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 634/800] iio: light: tcs3472: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:57 +0200
Message-Id: <20210712061034.592988897@linuxfoundation.org>
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

[ Upstream commit df2f37cffd6ed486d613e7ee22aadc8e49ae2dd3 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp().

Fixes tag is not strictly accurate as prior to that patch there was
potentially an unaligned write.  However, any backport past there will
need to be done manually.

Fixes: 0624bf847dd0 ("iio:tcs3472: Use iio_push_to_buffers_with_timestamp()")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-20-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tcs3472.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/tcs3472.c b/drivers/iio/light/tcs3472.c
index b41068492338..371c6a39a165 100644
--- a/drivers/iio/light/tcs3472.c
+++ b/drivers/iio/light/tcs3472.c
@@ -64,7 +64,11 @@ struct tcs3472_data {
 	u8 control;
 	u8 atime;
 	u8 apers;
-	u16 buffer[8]; /* 4 16-bit channels + 64-bit timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u16 chans[4];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 static const struct iio_event_spec tcs3472_events[] = {
@@ -386,10 +390,10 @@ static irqreturn_t tcs3472_trigger_handler(int irq, void *p)
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



