Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DAA3C551C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353278AbhGLIJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352747AbhGLH7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11C18619B3;
        Mon, 12 Jul 2021 07:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076414;
        bh=FMiubnISiMI2iY0NdN5wTlY0ucMqsT2sp82WSl3hFSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQoxbxxBSlj9DTHUcGBikLaofAX89tcOSit8ldFNfk618GyMDvI3YxJWe+Tfhx0P1
         Iv+cHtwSCAbPNQ7l6agz48SMRSKwWImcJ/8Hs5TiSx7PdqlNFNMmFto2ljK5WOS0oQ
         pHdwk9QazbwHkMFVAHxMWdzHB2bqu5mOISTJ1lwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 633/800] iio: light: tcs3414: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:56 +0200
Message-Id: <20210712061034.498578145@linuxfoundation.org>
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
index 6fe5d46f80d4..0593abd600ec 100644
--- a/drivers/iio/light/tcs3414.c
+++ b/drivers/iio/light/tcs3414.c
@@ -53,7 +53,11 @@ struct tcs3414_data {
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
@@ -209,10 +213,10 @@ static irqreturn_t tcs3414_trigger_handler(int irq, void *p)
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



