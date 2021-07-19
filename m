Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED193CDB4C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244613AbhGSOmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343614AbhGSOjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6C1461364;
        Mon, 19 Jul 2021 15:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707949;
        bh=UlxK49/2O/vY7teo2N8gZC7tT53j0N5Z4BzcduEFvcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tN7UPWzAZ8RA2p2vtJSSbmRFSrB0TgNVPWx6t8ks/DKPEYzV24LadqMP8Coh3jdXa
         +5WsLc/c4IV3QC2Wz6phVGGEIz/j4Fv9leg7vS80FkZnLc+7tUsoPEOGzHIwIrPp4Z
         wczwseG9KsdcrgNerY3tiVrWlW0KbIZFaSZ9YWac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 121/315] iio: accel: bma180: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:10 +0200
Message-Id: <20210719144946.847312389@linuxfoundation.org>
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

[ Upstream commit fc36da3131a747a9367a05caf06de19be1bcc972 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of this function.

Fixes: b9a6a237ffc9 ("iio:bma180: Drop _update_scan_mode()")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Peter Meerwald <pmeerw@pmeerw.net>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-2-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma180.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
index 3dec972ca672..dabe4717961f 100644
--- a/drivers/iio/accel/bma180.c
+++ b/drivers/iio/accel/bma180.c
@@ -121,7 +121,11 @@ struct bma180_data {
 	int scale;
 	int bw;
 	bool pmode;
-	u8 buff[16]; /* 3x 16-bit + 8-bit + padding + timestamp */
+	/* Ensure timestamp is naturally aligned */
+	struct {
+		s16 chan[4];
+		s64 timestamp __aligned(8);
+	} scan;
 };
 
 enum bma180_chan {
@@ -668,12 +672,12 @@ static irqreturn_t bma180_trigger_handler(int irq, void *p)
 			mutex_unlock(&data->mutex);
 			goto err;
 		}
-		((s16 *)data->buff)[i++] = ret;
+		data->scan.chan[i++] = ret;
 	}
 
 	mutex_unlock(&data->mutex);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data->buff, time_ns);
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan, time_ns);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
 
-- 
2.30.2



