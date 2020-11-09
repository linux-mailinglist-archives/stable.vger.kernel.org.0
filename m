Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9D12ABCD1
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgKINjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:39:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730670AbgKINDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:03:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A480E22202;
        Mon,  9 Nov 2020 13:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926977;
        bh=/y7H92Kxy/9wo+t0QSJYuIYPw2TgRjpkBGgOFB+T/No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iu9o33Sx1m5JquLxP2nBc//Lj8AGQrEy+IpauGD3IOF2e0mJJTzDTqkjzKfdlQaFp
         0slAdUIFZ0x+TLEyTopoLCS3N6/RZynLGe7rn3i7l7wT7LSQkptpI6y1CxeTunEQri
         WMXKe6ElMrbcJlI9MUTcsNHCj1qQI+UXptJlsSKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.9 068/117] iio:gyro:itg3200: Fix timestamp alignment and prevent data leak.
Date:   Mon,  9 Nov 2020 13:54:54 +0100
Message-Id: <20201109125028.902266505@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 10ab7cfd5522f0041028556dac864a003e158556 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte array of smaller elements on the stack.
This is fixed by using an explicit c structure. As there are no
holes in the structure, there is no possiblity of data leakage
in this case.

The explicit alignment of ts is not strictly necessary but potentially
makes the code slightly less fragile.  It also removes the possibility
of this being cut and paste into another driver where the alignment
isn't already true.

Fixes: 36e0371e7764 ("iio:itg3200: Use iio_push_to_buffers_with_timestamp()")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200722155103.979802-6-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/gyro/itg3200_buffer.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/iio/gyro/itg3200_buffer.c
+++ b/drivers/iio/gyro/itg3200_buffer.c
@@ -49,13 +49,20 @@ static irqreturn_t itg3200_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct itg3200 *st = iio_priv(indio_dev);
-	__be16 buf[ITG3200_SCAN_ELEMENTS + sizeof(s64)/sizeof(u16)];
+	/*
+	 * Ensure correct alignment and padding including for the
+	 * timestamp that may be inserted.
+	 */
+	struct {
+		__be16 buf[ITG3200_SCAN_ELEMENTS];
+		s64 ts __aligned(8);
+	} scan;
 
-	int ret = itg3200_read_all_channels(st->i2c, buf);
+	int ret = itg3200_read_all_channels(st->i2c, scan.buf);
 	if (ret < 0)
 		goto error_ret;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, &scan, pf->timestamp);
 
 	iio_trigger_notify_done(indio_dev->trig);
 


