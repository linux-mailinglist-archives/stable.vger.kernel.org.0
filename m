Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C36272D4C
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgIUQi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729203AbgIUQi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:38:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E423206DC;
        Mon, 21 Sep 2020 16:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706331;
        bh=V+hMxe2Lwr/FAnvCw25sVauwGTJ4DqBLe1JJIdJzaaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Co01a6iQ6mOl9MgewHfDepY12GW0AAOByvQbjHCh/55Tn2p+NThzOrkCMU9h2HEtn
         +2iZZviS5lgAsRVNozShQXhwPDb4hY4wCfTFG+XgDpNgQdieU8/lXtqwbF0721N7S9
         9uL+Sqp/SvgCRG4BjZvv/JEfEMjO/cTC9kpW7o/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.14 27/94] iio:accel:bmc150-accel: Fix timestamp alignment and prevent data leak.
Date:   Mon, 21 Sep 2020 18:27:14 +0200
Message-Id: <20200921162036.806621492@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit a6f86f724394de3629da63fe5e1b7a4ab3396efe upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by moving
to a suitable structure in the iio_priv() data with alignment
ensured by use of an explicit c structure.  This data is allocated
with kzalloc so no data can leak appart from previous readings.

Fixes tag is beyond some major refactoring so likely manual backporting
would be needed to get that far back.

Whilst the force alignment of the ts is not strictly necessary, it
does make the code less fragile.

Fixes: 3bbec9773389 ("iio: bmc150_accel: add support for hardware fifo")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/bmc150-accel-core.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -197,6 +197,14 @@ struct bmc150_accel_data {
 	struct mutex mutex;
 	u8 fifo_mode, watermark;
 	s16 buffer[8];
+	/*
+	 * Ensure there is sufficient space and correct alignment for
+	 * the timestamp if enabled
+	 */
+	struct {
+		__le16 channels[3];
+		s64 ts __aligned(8);
+	} scan;
 	u8 bw_bits;
 	u32 slope_dur;
 	u32 slope_thres;
@@ -933,15 +941,16 @@ static int __bmc150_accel_fifo_flush(str
 	 * now.
 	 */
 	for (i = 0; i < count; i++) {
-		u16 sample[8];
 		int j, bit;
 
 		j = 0;
 		for_each_set_bit(bit, indio_dev->active_scan_mask,
 				 indio_dev->masklength)
-			memcpy(&sample[j++], &buffer[i * 3 + bit], 2);
+			memcpy(&data->scan.channels[j++], &buffer[i * 3 + bit],
+			       sizeof(data->scan.channels[0]));
 
-		iio_push_to_buffers_with_timestamp(indio_dev, sample, tstamp);
+		iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
+						   tstamp);
 
 		tstamp += sample_period;
 	}


