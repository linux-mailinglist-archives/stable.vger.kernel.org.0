Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E340B272CB7
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgIUQe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728742AbgIUQeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:34:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0782239A1;
        Mon, 21 Sep 2020 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706064;
        bh=6ttQ1q99cwkgnU2fv5srLVz3lazMI9eFX5Ivf1tdbFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hWZQ2XVIw1JPl2lx4okzhHO9VGJWM65FbVbCfr5H5A68mojHVtmuF50hkOC49V/l
         pUO9Iqkhmo0sc2BxE2hnPXW7dIEgy1iumsCu3MGz2yjgM0rNf+nD+5VG78ZikWVmDD
         dhZpigQV2lRKriY//WXsQy71Mqynw7im1830xj6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.9 25/70] iio: accel: kxsd9: Fix alignment of local buffer.
Date:   Mon, 21 Sep 2020 18:27:25 +0200
Message-Id: <20200921162036.263924072@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 95ad67577de4ea08eb8e441394e698aa4addcc0b upstream.

iio_push_to_buffers_with_timestamp assumes 8 byte alignment which
is not guaranteed by an array of smaller elements.

Note that whilst in this particular case the alignment forcing
of the ts element is not strictly necessary it acts as good
documentation.  Doing this where not necessary should cut
down on the number of cut and paste introduced errors elsewhere.

Fixes: 0427a106a98a ("iio: accel: kxsd9: Add triggered buffer handling")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/kxsd9.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -212,14 +212,20 @@ static irqreturn_t kxsd9_trigger_handler
 	const struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct kxsd9_state *st = iio_priv(indio_dev);
+	/*
+	 * Ensure correct positioning and alignment of timestamp.
+	 * No need to zero initialize as all elements written.
+	 */
+	struct {
+		__be16 chan[4];
+		s64 ts __aligned(8);
+	} hw_values;
 	int ret;
-	/* 4 * 16bit values AND timestamp */
-	__be16 hw_values[8];
 
 	ret = regmap_bulk_read(st->map,
 			       KXSD9_REG_X,
-			       &hw_values,
-			       8);
+			       hw_values.chan,
+			       sizeof(hw_values.chan));
 	if (ret) {
 		dev_err(st->dev,
 			"error reading data\n");
@@ -227,7 +233,7 @@ static irqreturn_t kxsd9_trigger_handler
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev,
-					   hw_values,
+					   &hw_values,
 					   iio_get_time_ns(indio_dev));
 	iio_trigger_notify_done(indio_dev->trig);
 


