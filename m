Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2CF2E3F4F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392136AbgL1Oi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503624AbgL1Obz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 239712242A;
        Mon, 28 Dec 2020 14:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165899;
        bh=MqYK4bByvyed3WeX+W3EJNVYkbjV7CdwuADB16FkQpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sN1eXa2tWKisNKRjMqTUL9V6Y9PqVnKSFm2juca+9Vw+2sB5doM0FoJVcH+pCeb4V
         K8Ua1hdLwhWDMwy7h4K2GUXwnKS74teuvxRYruhq8yQPXH2io9BrbOlcJcwcFaEcAU
         r68kfjCT+o9vD6Hg8TkGWvMPOpyPF4Q9gaieoukY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Mikko Koivunen <mikko.koivunen@fi.rohmeurope.com>,
        Stable@vger.kernel.org
Subject: [PATCH 5.10 677/717] iio:light:rpr0521: Fix timestamp alignment and prevent data leak.
Date:   Mon, 28 Dec 2020 13:51:15 +0100
Message-Id: <20201228125053.419129991@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit a61817216bcc755eabbcb1cf281d84ccad267ed1 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp() assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses an array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv().
This data is allocated with kzalloc() so no data can leak apart
from previous readings and in this case the status byte from the device.

The forced alignment of ts is not necessary in this case but it
potentially makes the code less fragile.

>From personal communications with Mikko:

We could probably split the reading of the int register, but it
would mean a significant performance cost of 20 i2c clock cycles.

Fixes: e12ffd241c00 ("iio: light: rpr0521 triggered buffer")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Mikko Koivunen <mikko.koivunen@fi.rohmeurope.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200920112742.170751-2-jic23@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/rpr0521.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/iio/light/rpr0521.c
+++ b/drivers/iio/light/rpr0521.c
@@ -194,6 +194,17 @@ struct rpr0521_data {
 	bool pxs_need_dis;
 
 	struct regmap *regmap;
+
+	/*
+	 * Ensure correct naturally aligned timestamp.
+	 * Note that the read will put garbage data into
+	 * the padding but this should not be a problem
+	 */
+	struct {
+		__le16 channels[3];
+		u8 garbage;
+		s64 ts __aligned(8);
+	} scan;
 };
 
 static IIO_CONST_ATTR(in_intensity_scale_available, RPR0521_ALS_SCALE_AVAIL);
@@ -449,8 +460,6 @@ static irqreturn_t rpr0521_trigger_consu
 	struct rpr0521_data *data = iio_priv(indio_dev);
 	int err;
 
-	u8 buffer[16]; /* 3 16-bit channels + padding + ts */
-
 	/* Use irq timestamp when reasonable. */
 	if (iio_trigger_using_own(indio_dev) && data->irq_timestamp) {
 		pf->timestamp = data->irq_timestamp;
@@ -461,11 +470,11 @@ static irqreturn_t rpr0521_trigger_consu
 		pf->timestamp = iio_get_time_ns(indio_dev);
 
 	err = regmap_bulk_read(data->regmap, RPR0521_REG_PXS_DATA,
-		&buffer,
+		data->scan.channels,
 		(3 * 2) + 1);	/* 3 * 16-bit + (discarded) int clear reg. */
 	if (!err)
 		iio_push_to_buffers_with_timestamp(indio_dev,
-						   buffer, pf->timestamp);
+						   &data->scan, pf->timestamp);
 	else
 		dev_err(&data->client->dev,
 			"Trigger consumer can't read from sensor.\n");


