Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A393A25773B
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgHaK0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgHaK0N (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3D082072D;
        Mon, 31 Aug 2020 10:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869573;
        bh=6HGkKHwIoe5pqhYyUqjtlQs01xPWXhehF1QlkAZvA8M=;
        h=Subject:To:From:Date:From;
        b=2HP9Ha/4YvZvNVnxG6qtf7jQvVdei2s6ttYmKbNVD0mAyGuuVQiZ4LWdBbANsAcNv
         XHX18RqO1+dIjVtGJugv+OlSoyfQleMKj6iT57MQrg/yP+y8eJrPjVSjS449ET+NZG
         CCxZVjHy+r0dxVPNctPxI/bxLKXsfuoMdjE0nJDE=
Subject: patch "iio: accel: kxsd9: Fix alignment of local buffer." added to staging-linus
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        andy.shevchenko@gmail.com, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:14 +0200
Message-ID: <1598869574174167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: kxsd9: Fix alignment of local buffer.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 95ad67577de4ea08eb8e441394e698aa4addcc0b Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Wed, 22 Jul 2020 16:50:37 +0100
Subject: iio: accel: kxsd9: Fix alignment of local buffer.

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
---
 drivers/iio/accel/kxsd9.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/kxsd9.c b/drivers/iio/accel/kxsd9.c
index 66b2e4cf24cf..0e18b92e2099 100644
--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -209,14 +209,20 @@ static irqreturn_t kxsd9_trigger_handler(int irq, void *p)
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
@@ -224,7 +230,7 @@ static irqreturn_t kxsd9_trigger_handler(int irq, void *p)
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev,
-					   hw_values,
+					   &hw_values,
 					   iio_get_time_ns(indio_dev));
 	iio_trigger_notify_done(indio_dev->trig);
 
-- 
2.28.0


