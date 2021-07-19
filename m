Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DABA3CDB06
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244450AbhGSOkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343859AbhGSOjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11EEA613AA;
        Mon, 19 Jul 2021 15:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707987;
        bh=QA02mMdXZSWl0ubKkp4Oiy6y8Z2qmOYBGuEpv++eWQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdXCmziLMCuQSZcJwwWcJDJZ/+dH7B7yVVWTNWvrsuoC+w8fruFcQVFKzvpKTT7eV
         ivH5U4x96Il9y4vpltIRqLvdr+uwZKmIVX2JpNKPYqFfJbBU9vI759wvlmBxhHyI8X
         2LLBR3TE7ari02sR3p0RuHFzRPFSD6SnhyoWZark=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 135/315] iio: light: tcs3414: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:24 +0200
Message-Id: <20210719144947.315411748@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit ff08fbc22ab32ccc6690c21b0e5e1d402dcc076f ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: a244e7b57f0f ("iio: Add driver for AMS/TAOS tcs3414 digital color sensor")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-19-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tcs3414.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/tcs3414.c b/drivers/iio/light/tcs3414.c
index a795afb7667b..b51cd43ef824 100644
--- a/drivers/iio/light/tcs3414.c
+++ b/drivers/iio/light/tcs3414.c
@@ -56,7 +56,11 @@ struct tcs3414_data {
 	u8 control;
 	u8 gain;
 	u8 timing;
-	u16 buffer[8]; /* 4x 16-bit + 8 bytes timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u16 chans[4];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 #define TCS3414_CHANNEL(_color, _si, _addr) { \
@@ -212,10 +216,10 @@ static irqreturn_t tcs3414_trigger_handler(int irq, void *p)
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



