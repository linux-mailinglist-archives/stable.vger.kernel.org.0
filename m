Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62A23CDE37
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242262AbhGSPCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343704AbhGSO7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E9BC61283;
        Mon, 19 Jul 2021 15:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709023;
        bh=kH0ztzjTDpwSK5QeTbad/iCJMkXvG2jh8hJ0rTfdHhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQaZTylOk5gUi553BhmWVS9xFlXX8N4vmM0GM30OvQ09TS/qApS/FdQTJV7+97DpX
         d58hCRtkq9l/LZigkV08XJx9g8XaStWrHtD+lN8Cbg7rmjcGo5QdMQKT54C0rpJ0dP
         3BrrKswYDdvgrsyICTFywJvTiDPsWicvwPiRQipU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/421] iio: prox: as3935: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:49:51 +0200
Message-Id: <20210719144952.666978873@linuxfoundation.org>
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

[ Upstream commit 37eb8d8c64f2ecb3a5521ba1cc1fad973adfae41 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes: 37b1ba2c68cf ("iio: proximity: as3935: fix buffer stack trashing")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-15-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/proximity/as3935.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/proximity/as3935.c b/drivers/iio/proximity/as3935.c
index f130388a16a0..9069eec46093 100644
--- a/drivers/iio/proximity/as3935.c
+++ b/drivers/iio/proximity/as3935.c
@@ -61,7 +61,11 @@ struct as3935_state {
 	unsigned long noise_tripped;
 	u32 tune_cap;
 	u32 nflwdth_reg;
-	u8 buffer[16]; /* 8-bit data + 56-bit padding + 64-bit timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		u8 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 	u8 buf[2] ____cacheline_aligned;
 };
 
@@ -227,8 +231,8 @@ static irqreturn_t as3935_trigger_handler(int irq, void *private)
 	if (ret)
 		goto err_read;
 
-	st->buffer[0] = val & AS3935_DATA_MASK;
-	iio_push_to_buffers_with_timestamp(indio_dev, &st->buffer,
+	st->scan.chan = val & AS3935_DATA_MASK;
+	iio_push_to_buffers_with_timestamp(indio_dev, &st->scan,
 					   iio_get_time_ns(indio_dev));
 err_read:
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.30.2



