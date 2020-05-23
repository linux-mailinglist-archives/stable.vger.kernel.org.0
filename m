Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFFB1DF61B
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 10:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387512AbgEWIr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 04:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387471AbgEWIr6 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 23 May 2020 04:47:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F15320738;
        Sat, 23 May 2020 08:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590223677;
        bh=xFpvs24PZH5GUbWdGGcY+Qz50qEONo+dp+Ly2T9lEmE=;
        h=Subject:To:From:Date:From;
        b=yQcg06xh698tFMs/bJdU53sGPNCBFth0ATMqY+TlG7Ms2yqc32XpDFT9zEoFdBZ/W
         yhGhR7PwBOOpCWlhYoUr49Tw2EsaTTSOHQf8cuOCuCTPBxA4s1ooplwss/Ao9gYE5G
         F2uQrRLsGFBbI9oTtEpzCsx/6nXKFJiF6vSWfajY=
Subject: patch "iio:chemical:sps30: Fix timestamp alignment" added to staging-testing
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        lars@metafoo.de, tomasz.duszynski@octakon.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 May 2020 10:46:49 +0200
Message-ID: <159022360981214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:chemical:sps30: Fix timestamp alignment

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a5bf6fdd19c327bcfd9073a8740fa19ca4525fd4 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 17 May 2020 18:29:59 +0100
Subject: iio:chemical:sps30: Fix timestamp alignment

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.

Fixes: 232e0f6ddeae ("iio: chemical: add support for Sensirion SPS30 sensor")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Acked-by: Tomasz Duszynski <tomasz.duszynski@octakon.com>
---
 drivers/iio/chemical/sps30.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/chemical/sps30.c b/drivers/iio/chemical/sps30.c
index acb9f8ecbb3d..a88c1fb875a0 100644
--- a/drivers/iio/chemical/sps30.c
+++ b/drivers/iio/chemical/sps30.c
@@ -230,15 +230,18 @@ static irqreturn_t sps30_trigger_handler(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct sps30_state *state = iio_priv(indio_dev);
 	int ret;
-	s32 data[4 + 2]; /* PM1, PM2P5, PM4, PM10, timestamp */
+	struct {
+		s32 data[4]; /* PM1, PM2P5, PM4, PM10 */
+		s64 ts;
+	} scan;
 
 	mutex_lock(&state->lock);
-	ret = sps30_do_meas(state, data, 4);
+	ret = sps30_do_meas(state, scan.data, ARRAY_SIZE(scan.data));
 	mutex_unlock(&state->lock);
 	if (ret)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data,
+	iio_push_to_buffers_with_timestamp(indio_dev, &scan,
 					   iio_get_time_ns(indio_dev));
 err:
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.26.2


