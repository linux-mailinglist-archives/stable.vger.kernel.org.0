Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1299272D50
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgIUQjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729209AbgIUQi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:38:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 387B8238EE;
        Mon, 21 Sep 2020 16:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706336;
        bh=3Vk8DhUjDeqGv2sAzUL4q2nFrNYxBiAIvpaerKdyjrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JD2OywO7PS1OiT3UV3ZXypOaIoVktBdxLSkGltalznItpP2p7jCGzlX5QBmCkfQQ
         q35g0iEiPTcYSP6xVMjDQglJRo9TLcY8+uXcxjJWQ9foNrxQuxFBsw6x3FLi8OVIjp
         8oimofG6xUQvT6TWgx5f2iXaRj0xce3tocNE9MZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>,
        Marc Titinger <mtitinger@baylibre.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.14 29/94] iio:adc:ina2xx Fix timestamp alignment issue.
Date:   Mon, 21 Sep 2020 18:27:16 +0200
Message-Id: <20200921162036.890795589@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

commit f8cd222feb82ecd82dcf610fcc15186f55f9c2b5 upstream.

One of a class of bugs pointed out by Lars in a recent review.
iio_push_to_buffers_with_timestamp assumes the buffer used is aligned
to the size of the timestamp (8 bytes).  This is not guaranteed in
this driver which uses a 32 byte array of smaller elements on the stack.
As Lars also noted this anti pattern can involve a leak of data to
userspace and that indeed can happen here.  We close both issues by
moving to a suitable structure in the iio_priv() data with alignment
explicitly requested.  This data is allocated with kzalloc so no
data can leak apart from previous readings. The explicit alignment
isn't technically needed here, but it reduced fragility and avoids
cut and paste into drivers where it will be needed.

If we want this in older stables will need manual backport due to
driver reworks.

Fixes: c43a102e67db ("iio: ina2xx: add support for TI INA2xx Power Monitors")
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Stefan Brüns <stefan.bruens@rwth-aachen.de>
Cc: Marc Titinger <mtitinger@baylibre.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ina2xx-adc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/ina2xx-adc.c
+++ b/drivers/iio/adc/ina2xx-adc.c
@@ -133,6 +133,11 @@ struct ina2xx_chip_info {
 	int int_time_vbus; /* Bus voltage integration time uS */
 	int int_time_vshunt; /* Shunt voltage integration time uS */
 	bool allow_async_readout;
+	/* data buffer needs space for channel data and timestamp */
+	struct {
+		u16 chan[4];
+		u64 ts __aligned(8);
+	} scan;
 };
 
 static const struct ina2xx_config ina2xx_config[] = {
@@ -598,7 +603,6 @@ static const struct iio_chan_spec ina219
 static int ina2xx_work_buffer(struct iio_dev *indio_dev)
 {
 	struct ina2xx_chip_info *chip = iio_priv(indio_dev);
-	unsigned short data[8];
 	int bit, ret, i = 0;
 	s64 time_a, time_b;
 	unsigned int alert;
@@ -648,7 +652,7 @@ static int ina2xx_work_buffer(struct iio
 		if (ret < 0)
 			return ret;
 
-		data[i++] = val;
+		chip->scan.chan[i++] = val;
 
 		if (INA2XX_SHUNT_VOLTAGE + bit == INA2XX_POWER)
 			cnvr_need_clear = 0;
@@ -665,8 +669,7 @@ static int ina2xx_work_buffer(struct iio
 
 	time_b = iio_get_time_ns(indio_dev);
 
-	iio_push_to_buffers_with_timestamp(indio_dev,
-					   (unsigned int *)data, time_a);
+	iio_push_to_buffers_with_timestamp(indio_dev, &chip->scan, time_a);
 
 	return (unsigned long)(time_b - time_a) / 1000;
 };


