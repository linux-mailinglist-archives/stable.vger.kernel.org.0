Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D0026B677
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIPAFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbgIOO3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:29:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B859122A83;
        Tue, 15 Sep 2020 14:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179684;
        bh=U6sg0ulo525FLOXbhNDlLR1yH2QgYYDk6gs/A4oeoOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMUTAYgu+MSnnXdI7B0oTR1KRjnl8k0SvKem0NsKPTeTX+w4Vhb8fzmyirxya4ISr
         3yIZtLJc6QfLHUJUinhFOzr8ittDroz1v2/t1UAtNriOsPr6H6ThPVcTXWw1u2bh0E
         aagEoaqIow0XEJuavvRaeAqROGTvdRiZlh/gi+bE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Andreas Klinger <ak@it-klinger.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.4 078/132] iio:proximity:mb1232: Fix timestamp alignment and prevent data leak.
Date:   Tue, 15 Sep 2020 16:13:00 +0200
Message-Id: <20200915140648.005413588@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit f60e8bb84282b8e633956cfe74b4f0d64ca73cec upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 16 byte s16 array on the stack   As Lars also noted
this anti pattern can involve a leak of data to userspace and that
indeed can happen here.  We close both issues by moving to
a suitable structure in the iio_priv() data with alignment
ensured by use of an explicit c structure.  This data is allocated
with kzalloc so no data can leak appart from previous readings.

In this case the forced alignment of the ts is necessary to ensure
correct padding on x86_32 where the s64 would only be 4 byte aligned.

Fixes: 16b05261537e ("mb1232.c: add distance iio sensor with i2c")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Andreas Klinger <ak@it-klinger.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/proximity/mb1232.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/iio/proximity/mb1232.c
+++ b/drivers/iio/proximity/mb1232.c
@@ -40,6 +40,11 @@ struct mb1232_data {
 	 */
 	struct completion	ranging;
 	int			irqnr;
+	/* Ensure correct alignment of data to push to IIO buffer */
+	struct {
+		s16 distance;
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static irqreturn_t mb1232_handle_irq(int irq, void *dev_id)
@@ -113,17 +118,13 @@ static irqreturn_t mb1232_trigger_handle
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct mb1232_data *data = iio_priv(indio_dev);
-	/*
-	 * triggered buffer
-	 * 16-bit channel + 48-bit padding + 64-bit timestamp
-	 */
-	s16 buffer[8] = { 0 };
 
-	buffer[0] = mb1232_read_distance(data);
-	if (buffer[0] < 0)
+	data->scan.distance = mb1232_read_distance(data);
+	if (data->scan.distance < 0)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, &data->scan,
+					   pf->timestamp);
 
 err:
 	iio_trigger_notify_done(indio_dev->trig);


