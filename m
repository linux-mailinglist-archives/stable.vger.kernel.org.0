Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BFB1DF610
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 10:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbgEWImz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 04:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387500AbgEWImy (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 23 May 2020 04:42:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95493206C3;
        Sat, 23 May 2020 08:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590223374;
        bh=jdX5E5+p6mdlBbiCVsUcfx3TAeXXpMH2L1PIfgl76xA=;
        h=Subject:To:From:Date:From;
        b=xqqD/VANyyGRLQyarmBwKYLgTATjM+9IIwGMEnNbi53SlAQfB70rfKlfqXWe+9/kW
         nW2ciR2vFwvhawapbfliJWkhUOdenR5BqIr0JbaoPB57/7Sgjj5w+P9FElFRXHG/3F
         cuqmuAU5kVb9SgpgDp7lue5wUdxKFworZI3XfLK4=
Subject: patch "iio:chemical:pms7003: Fix timestamp alignment and prevent data leak." added to staging-next
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        lars@metafoo.de, tomasz.duszynski@octakon.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 May 2020 10:41:41 +0200
Message-ID: <159022330124992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:chemical:pms7003: Fix timestamp alignment and prevent data leak.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 13e945631c2ffb946c0af342812a3cd39227de6e Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 17 May 2020 18:30:00 +0100
Subject: iio:chemical:pms7003: Fix timestamp alignment and prevent data leak.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc so no
data can leak appart from previous readings.

Fixes: a1d642266c14 ("iio: chemical: add support for Plantower PMS7003 sensor")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Acked-by: Tomasz Duszynski <tomasz.duszynski@octakon.com>
---
 drivers/iio/chemical/pms7003.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/chemical/pms7003.c b/drivers/iio/chemical/pms7003.c
index 23c9ab252470..07bb90d72434 100644
--- a/drivers/iio/chemical/pms7003.c
+++ b/drivers/iio/chemical/pms7003.c
@@ -73,6 +73,11 @@ struct pms7003_state {
 	struct pms7003_frame frame;
 	struct completion frame_ready;
 	struct mutex lock; /* must be held whenever state gets touched */
+	/* Used to construct scan to push to the IIO buffer */
+	struct {
+		u16 data[3]; /* PM1, PM2P5, PM10 */
+		s64 ts;
+	} scan;
 };
 
 static int pms7003_do_cmd(struct pms7003_state *state, enum pms7003_cmd cmd)
@@ -104,7 +109,6 @@ static irqreturn_t pms7003_trigger_handler(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct pms7003_state *state = iio_priv(indio_dev);
 	struct pms7003_frame *frame = &state->frame;
-	u16 data[3 + 1 + 4]; /* PM1, PM2P5, PM10, padding, timestamp */
 	int ret;
 
 	mutex_lock(&state->lock);
@@ -114,12 +118,15 @@ static irqreturn_t pms7003_trigger_handler(int irq, void *p)
 		goto err;
 	}
 
-	data[PM1] = pms7003_get_pm(frame->data + PMS7003_PM1_OFFSET);
-	data[PM2P5] = pms7003_get_pm(frame->data + PMS7003_PM2P5_OFFSET);
-	data[PM10] = pms7003_get_pm(frame->data + PMS7003_PM10_OFFSET);
+	state->scan.data[PM1] =
+		pms7003_get_pm(frame->data + PMS7003_PM1_OFFSET);
+	state->scan.data[PM2P5] =
+		pms7003_get_pm(frame->data + PMS7003_PM2P5_OFFSET);
+	state->scan.data[PM10] =
+		pms7003_get_pm(frame->data + PMS7003_PM10_OFFSET);
 	mutex_unlock(&state->lock);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, data,
+	iio_push_to_buffers_with_timestamp(indio_dev, &state->scan,
 					   iio_get_time_ns(indio_dev));
 err:
 	iio_trigger_notify_done(indio_dev->trig);
-- 
2.26.2


