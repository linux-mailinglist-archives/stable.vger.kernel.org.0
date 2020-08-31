Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E19825773D
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgHaK0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgHaK0T (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E374A20936;
        Mon, 31 Aug 2020 10:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869578;
        bh=eGUwc92jKId+mFo13rB8vEs8IsUlTHflT4bSPS182gA=;
        h=Subject:To:From:Date:From;
        b=a3Qbx7SadFMzUEQvRN8SCFSKAldrQJNg5PPA3PXazejL32VLFIo1XD9btw1WjYbur
         fIFuOlpnqRdxMn8s4GuJpOP3cSTiBx5+qtPRRcb4yG9vl1S6yamjy/PG8gyXT3Rs30
         38UQKbtl0MHRquiWqouWeGYqzUmmd3yfTZlp313g=
Subject: patch "iio:accel:bmc150-accel: Fix timestamp alignment and prevent data" added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, lars@metafoo.de,
        srinivas.pandruvada@linux.intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:16 +0200
Message-ID: <159886957690111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:accel:bmc150-accel: Fix timestamp alignment and prevent data

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a6f86f724394de3629da63fe5e1b7a4ab3396efe Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:39 +0100
Subject: iio:accel:bmc150-accel: Fix timestamp alignment and prevent data
 leak.

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
---
 drivers/iio/accel/bmc150-accel-core.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/bmc150-accel-core.c b/drivers/iio/accel/bmc150-accel-core.c
index 24864d9dfab5..48435865fdaf 100644
--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -189,6 +189,14 @@ struct bmc150_accel_data {
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
@@ -922,15 +930,16 @@ static int __bmc150_accel_fifo_flush(struct iio_dev *indio_dev,
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
-- 
2.28.0


