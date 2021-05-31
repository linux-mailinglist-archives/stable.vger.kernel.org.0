Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3612396172
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhEaOku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233959AbhEaOhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:37:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F82961C56;
        Mon, 31 May 2021 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469123;
        bh=CTOq7VVM7Ni3yi7qRiNv4fNQie3EkSonQ2SRJ0iS4jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFhjsLiuNgUix9kEKjKH+UOtqvf6Orh1UNRzFrxQmnBKh5VZiP3+eTFl5Qma8b0sn
         B2HQaadOuasPyNpLZZ5zjUYG2myIS8Flngo0125OK3AK4gdwBypbhHZfhchDegR6Gj
         E8q6j4TeyIrtlpdflRvpzSexrEpVKLIB1jnbHse8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.12 078/296] iio: adc: ad7768-1: Fix too small buffer passed to iio_push_to_buffers_with_timestamp()
Date:   Mon, 31 May 2021 15:12:13 +0200
Message-Id: <20210531130706.476550184@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit a1caeebab07e9d72eec534489f47964782b93ba9 upstream.

Add space for the timestamp to be inserted.  Also ensure correct
alignment for passing to iio_push_to_buffers_with_timestamp()

Fixes: a5f8c7da3dbe ("iio: adc: Add AD7768-1 ADC basic support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501165314.511954-2-jic23@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7768-1.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -167,6 +167,10 @@ struct ad7768_state {
 	 * transfer buffers to live in their own cache lines.
 	 */
 	union {
+		struct {
+			__be32 chan;
+			s64 timestamp;
+		} scan;
 		__be32 d32;
 		u8 d8[2];
 	} data ____cacheline_aligned;
@@ -469,11 +473,11 @@ static irqreturn_t ad7768_trigger_handle
 
 	mutex_lock(&st->lock);
 
-	ret = spi_read(st->spi, &st->data.d32, 3);
+	ret = spi_read(st->spi, &st->data.scan.chan, 3);
 	if (ret < 0)
 		goto err_unlock;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, &st->data.d32,
+	iio_push_to_buffers_with_timestamp(indio_dev, &st->data.scan,
 					   iio_get_time_ns(indio_dev));
 
 	iio_trigger_notify_done(indio_dev->trig);


