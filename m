Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB362180FA
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 09:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgGHHVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 03:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729340AbgGHHVa (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 8 Jul 2020 03:21:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77EFD206E2;
        Wed,  8 Jul 2020 07:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594192890;
        bh=ZJukO1xQ7tQO3w5sN4dpFvqDoCTnZ8YNDB767EkqG5g=;
        h=Subject:To:From:Date:From;
        b=pjcogBGIE/B8z+ozeszhAvqwNlJfNYwxC25kaUNXh4srHh5nnP/voBRX9I/sc+lbC
         us4dKZ3b19urFBpn8yUMsllS+gZ1tN2G7U5QAGinbpTp3eU2W9PzTpp6B2R/O51mPO
         b3uWMqc7TnNTzxN2iD6q5CZkm2hNiwAkWKnhh6Bk=
Subject: patch "iio:health:afe4403 Fix timestamp alignment and prevent data leak." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org, afd@ti.com,
        lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Jul 2020 09:21:26 +0200
Message-ID: <1594192886179106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:health:afe4403 Fix timestamp alignment and prevent data leak.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3f9c6d38797e9903937b007a341dad0c251765d6 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 17 May 2020 18:29:56 +0100
Subject: iio:health:afe4403 Fix timestamp alignment and prevent data leak.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 32 byte array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc so no
data can leak appart from previous readings.

Fixes: eec96d1e2d31 ("iio: health: Add driver for the TI AFE4403 heart monitor")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Andrew F. Davis <afd@ti.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/health/afe4403.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
index e9f87e42ff4f..a3507624b30f 100644
--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -65,6 +65,7 @@ static const struct reg_field afe4403_reg_fields[] = {
  * @regulator: Pointer to the regulator for the IC
  * @trig: IIO trigger for this device
  * @irq: ADC_RDY line interrupt number
+ * @buffer: Used to construct data layout to push into IIO buffer.
  */
 struct afe4403_data {
 	struct device *dev;
@@ -74,6 +75,8 @@ struct afe4403_data {
 	struct regulator *regulator;
 	struct iio_trigger *trig;
 	int irq;
+	/* Ensure suitable alignment for timestamp */
+	s32 buffer[8] __aligned(8);
 };
 
 enum afe4403_chan_id {
@@ -309,7 +312,6 @@ static irqreturn_t afe4403_trigger_handler(int irq, void *private)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct afe4403_data *afe = iio_priv(indio_dev);
 	int ret, bit, i = 0;
-	s32 buffer[8];
 	u8 tx[4] = {AFE440X_CONTROL0, 0x0, 0x0, AFE440X_CONTROL0_READ};
 	u8 rx[3];
 
@@ -326,7 +328,7 @@ static irqreturn_t afe4403_trigger_handler(int irq, void *private)
 		if (ret)
 			goto err;
 
-		buffer[i++] = get_unaligned_be24(&rx[0]);
+		afe->buffer[i++] = get_unaligned_be24(&rx[0]);
 	}
 
 	/* Disable reading from the device */
@@ -335,7 +337,8 @@ static irqreturn_t afe4403_trigger_handler(int irq, void *private)
 	if (ret)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, afe->buffer,
+					   pf->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
 
-- 
2.27.0


