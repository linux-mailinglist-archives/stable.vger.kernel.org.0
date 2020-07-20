Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD79226402
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgGTPlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729910AbgGTPlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:41:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E4362064B;
        Mon, 20 Jul 2020 15:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259692;
        bh=6TvSZAHBNwIOER1p9mZeazrQSDICKsX8iOf9RBznyvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pg7tdM2HIwnQuaBhFJnmOovFaSHeZaralRH/jbpShcDyEJr1N4x/OgRr6iI+WczIo
         OUJx7pKhxDgL5YAIk0JJXm9ONKFYecf/qCoveACL09YBwy1G9phcRxPl7lkTbjRZ4t
         FP6iwzVOlHw2gWXp4tn86GmZNYUxn+xf2udl4cG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Andrew F. Davis" <afd@ti.com>, Stable@vger.kernel.org
Subject: [PATCH 4.9 46/86] iio:health:afe4403 Fix timestamp alignment and prevent data leak.
Date:   Mon, 20 Jul 2020 17:36:42 +0200
Message-Id: <20200720152755.478243355@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit 3f9c6d38797e9903937b007a341dad0c251765d6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/health/afe4403.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -71,6 +71,7 @@ static const struct reg_field afe4403_re
  * @regulator: Pointer to the regulator for the IC
  * @trig: IIO trigger for this device
  * @irq: ADC_RDY line interrupt number
+ * @buffer: Used to construct data layout to push into IIO buffer.
  */
 struct afe4403_data {
 	struct device *dev;
@@ -80,6 +81,8 @@ struct afe4403_data {
 	struct regulator *regulator;
 	struct iio_trigger *trig;
 	int irq;
+	/* Ensure suitable alignment for timestamp */
+	s32 buffer[8] __aligned(8);
 };
 
 enum afe4403_chan_id {
@@ -318,7 +321,6 @@ static irqreturn_t afe4403_trigger_handl
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct afe4403_data *afe = iio_priv(indio_dev);
 	int ret, bit, i = 0;
-	s32 buffer[8];
 	u8 tx[4] = {AFE440X_CONTROL0, 0x0, 0x0, AFE440X_CONTROL0_READ};
 	u8 rx[3];
 
@@ -335,9 +337,9 @@ static irqreturn_t afe4403_trigger_handl
 		if (ret)
 			goto err;
 
-		buffer[i++] = (rx[0] << 16) |
-				(rx[1] << 8) |
-				(rx[2]);
+		afe->buffer[i++] = (rx[0] << 16) |
+				   (rx[1] << 8) |
+				   (rx[2]);
 	}
 
 	/* Disable reading from the device */
@@ -346,7 +348,8 @@ static irqreturn_t afe4403_trigger_handl
 	if (ret)
 		goto err;
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buffer, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(indio_dev, afe->buffer,
+					   pf->timestamp);
 err:
 	iio_trigger_notify_done(indio_dev->trig);
 


