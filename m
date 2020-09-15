Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FAD26A6F3
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 16:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgIOOU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 10:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgIOOTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:19:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF7872222E;
        Tue, 15 Sep 2020 14:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179394;
        bh=0UWIwUObDoXc88RA1kBQm3/Ttdtb0YaBcDx5KmFlTCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SO3+IZLfRjCPzmHNWtNAOGF+GhW0MYQAbGrUU8HQ9JJ75JQjhOJscbS3z/CPbgkTm
         LE2z+8vMhNDhqLNHFVGvxIyzBIsPDa3OqJtpqYG/EOBy6fxWGkIkGXoro+zVWdH61g
         LERAUR5I/sNy5TBQDPhnLndxpssBEG2gmQEFAa0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.19 43/78] iio:accel:bmc150-accel: Fix timestamp alignment and prevent data leak.
Date:   Tue, 15 Sep 2020 16:13:08 +0200
Message-Id: <20200915140635.739533351@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
@@ -915,15 +923,16 @@ static int __bmc150_accel_fifo_flush(str
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


