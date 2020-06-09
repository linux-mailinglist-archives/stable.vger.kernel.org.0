Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C135D1F4458
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387940AbgFISDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732916AbgFIRwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:52:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6AAE20774;
        Tue,  9 Jun 2020 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725156;
        bh=9QiSaFPCF+LjbweQTWvY4JtLf48Yd8AZc7D1koPx13M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RN/rp31xaKPWGocFgq6R+seM943Ke/wJhAX2XEsnjJSKLP+oLWrEZuXFFu5o3+MLh
         JDMQt3PeX4TPrvcbfQ6HMV7AmxxC8ENtEF+GUoWJ2H9kfrragxBmkqXJpo9lbMo4CM
         e+Brn6Zpi1p6qMAuLuvbrZjsZv0QTOO/eUS/YNHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org,
        Tomasz Duszynski <tomasz.duszynski@octakon.com>
Subject: [PATCH 5.4 16/34] iio:chemical:sps30: Fix timestamp alignment
Date:   Tue,  9 Jun 2020 19:45:12 +0200
Message-Id: <20200609174054.670448439@linuxfoundation.org>
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

commit a5bf6fdd19c327bcfd9073a8740fa19ca4525fd4 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.

Fixes: 232e0f6ddeae ("iio: chemical: add support for Sensirion SPS30 sensor")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Acked-by: Tomasz Duszynski <tomasz.duszynski@octakon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/chemical/sps30.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/iio/chemical/sps30.c
+++ b/drivers/iio/chemical/sps30.c
@@ -230,15 +230,18 @@ static irqreturn_t sps30_trigger_handler
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


