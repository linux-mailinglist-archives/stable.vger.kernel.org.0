Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602493C4720
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhGLGb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235321AbhGLG2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:28:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D73961185;
        Mon, 12 Jul 2021 06:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071112;
        bh=Q+2LZT1Bcn55z2F0p8tlrUYi85vixn6XUe+WHNy1wws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlppsT4PtqD9UauOnJWRRLTeqhEytQ4ZmfMuzbU+fPgYLosRlQu6ixvOlGzTdp5Hw
         DVLNrd39g4EqflUjv7MoM7MKlvoGoJrXtccYITWd+5VbYc5VVF0abgnX5wyIYhi/za
         zKroHxKz27yMVyOvNaXSuIlh6lusPhrNRMg+GRPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 279/348] iio: light: tcs3472: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:11:03 +0200
Message-Id: <20210712060740.679100501@linuxfoundation.org>
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
index a30ad151653f..9ea543c5cf5e 100644
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



