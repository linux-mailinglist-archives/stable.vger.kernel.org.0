Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A1426B669
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIPAE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgIOO3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:29:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D65E229F0;
        Tue, 15 Sep 2020 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179681;
        bh=IzvOLuKBuom4AqwMojGTEU28oIpd/oul5A89xgN4JRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BA4PUZroj6Qak47M6qRncdV2IZeuvN2Tpdr0QM5nPapT95qQOhIoLZf2wN7ZUYXxX
         5NCUFPoU3/+d1vscmR26Jb67vcGZD/3l9Mt+XmyY9kZrAO9RZGywylVq9zNxSrdrr/
         SVtRotEychP44t+6AQWGuvlZFtdsY83R8qNzh31Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.4 077/132] iio:light:ltr501 Fix timestamp alignment issue.
Date:   Tue, 15 Sep 2020 16:12:59 +0200
Message-Id: <20200915140647.956961472@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 2684d5003490df5398aeafe2592ba9d4a4653998 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
Here we use a structure on the stack.  The driver already did an
explicit memset so no data leak was possible.

Forced alignment of ts is not strictly necessary but probably makes
the code slightly less fragile.

Note there has been some rework in this driver of the years, so no
way this will apply cleanly all the way back.

Fixes: 2690be905123 ("iio: Add Lite-On ltr501 ambient light / proximity sensor driver")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/ltr501.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1242,13 +1242,16 @@ static irqreturn_t ltr501_trigger_handle
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ltr501_data *data = iio_priv(indio_dev);
-	u16 buf[8];
+	struct {
+		u16 channels[3];
+		s64 ts __aligned(8);
+	} scan;
 	__le16 als_buf[2];
 	u8 mask = 0;
 	int j = 0;
 	int ret, psdata;
 
-	memset(buf, 0, sizeof(buf));
+	memset(&scan, 0, sizeof(scan));
 
 	/* figure out which data needs to be ready */
 	if (test_bit(0, indio_dev->active_scan_mask) ||
@@ -1267,9 +1270,9 @@ static irqreturn_t ltr501_trigger_handle
 		if (ret < 0)
 			return ret;
 		if (test_bit(0, indio_dev->active_scan_mask))
-			buf[j++] = le16_to_cpu(als_buf[1]);
+			scan.channels[j++] = le16_to_cpu(als_buf[1]);
 		if (test_bit(1, indio_dev->active_scan_mask))
-			buf[j++] = le16_to_cpu(als_buf[0]);
+			scan.channels[j++] = le16_to_cpu(als_buf[0]);
 	}
 
 	if (mask & LTR501_STATUS_PS_RDY) {
@@ -1277,10 +1280,10 @@ static irqreturn_t ltr501_trigger_handle
 				       &psdata, 2);
 		if (ret < 0)
 			goto done;
-		buf[j++] = psdata & LTR501_PS_DATA_MASK;
+		scan.channels[j++] = psdata & LTR501_PS_DATA_MASK;
 	}
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, &scan,
 					   iio_get_time_ns(indio_dev));
 
 done:


