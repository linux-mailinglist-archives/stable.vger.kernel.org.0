Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309E11F444D
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733002AbgFISDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732985AbgFIRxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:53:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C61B0207C3;
        Tue,  9 Jun 2020 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725183;
        bh=tJ7i3gI0/ijEe7QVglU/MZNhpV1Jc+al4aF2FGTCKJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvI099iCC1Xomkd3DHQmrDXKnJaHLRREPrTNFQLCXpyWSo9KRwMUuhthmMDWygIhw
         pYuUAUvTungBGmQ1wCinnwgrZlycNuRMixnNvWAgSwsg2Ih6wN4t0rpoqh29jtmh3j
         aJYL6Md/eWrSb/Te/vrZ11/YFQLaQxkY81kEhXbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org,
        Tomasz Duszynski <tomasz.duszynski@octakon.com>
Subject: [PATCH 5.4 18/34] iio:chemical:pms7003: Fix timestamp alignment and prevent data leak.
Date:   Tue,  9 Jun 2020 19:45:14 +0200
Message-Id: <20200609174054.904245534@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
References: <20200609174052.628006868@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 13e945631c2ffb946c0af342812a3cd39227de6e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/chemical/pms7003.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

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
@@ -104,7 +109,6 @@ static irqreturn_t pms7003_trigger_handl
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct pms7003_state *state = iio_priv(indio_dev);
 	struct pms7003_frame *frame = &state->frame;
-	u16 data[3 + 1 + 4]; /* PM1, PM2P5, PM10, padding, timestamp */
 	int ret;
 
 	mutex_lock(&state->lock);
@@ -114,12 +118,15 @@ static irqreturn_t pms7003_trigger_handl
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


