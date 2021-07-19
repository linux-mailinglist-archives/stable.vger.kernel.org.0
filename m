Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2C03CDB4B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244275AbhGSOmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343651AbhGSOjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE7F860241;
        Mon, 19 Jul 2021 15:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707967;
        bh=cviDUqqDG7QmjX9/8Elnh1GRGJoM6YwQiehla20UCOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZW/HiwaguQmNrpt5AfEj22epslHjeFix0+ILCdLF9J9rKhCahovx4XfrZls2LPPv8
         OlNojPzWUJazPrDsKIiEnodEomwUPQn+WMZD/81PXQRye390IZcQryikSbFdE9Jajw
         bVDiBVFLmbi3RkKpTZ1DANCDOPDEMNACwQtlMzqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 127/315] iio: adc: ti-ads1015: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:50:16 +0200
Message-Id: <20210719144947.057340399@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit d85d71dd1ab67eaa7351f69fec512d8f09d164e1 ]

To make code more readable, use a structure to express the channel
layout and ensure the timestamp is 8 byte aligned.

Found during an audit of all calls of this function.

Fixes: ecc24e72f437 ("iio: adc: Add TI ADS1015 ADC driver support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel Baluta <daniel.baluta@nxp.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210501170121.512209-9-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads1015.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ti-ads1015.c b/drivers/iio/adc/ti-ads1015.c
index df71c6105353..007898d3b3a9 100644
--- a/drivers/iio/adc/ti-ads1015.c
+++ b/drivers/iio/adc/ti-ads1015.c
@@ -392,10 +392,14 @@ static irqreturn_t ads1015_trigger_handler(int irq, void *p)
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct ads1015_data *data = iio_priv(indio_dev);
-	s16 buf[8]; /* 1x s16 ADC val + 3x s16 padding +  4x s16 timestamp */
+	/* Ensure natural alignment of timestamp */
+	struct {
+		s16 chan;
+		s64 timestamp __aligned(8);
+	} scan;
 	int chan, ret, res;
 
-	memset(buf, 0, sizeof(buf));
+	memset(&scan, 0, sizeof(scan));
 
 	mutex_lock(&data->lock);
 	chan = find_first_bit(indio_dev->active_scan_mask,
@@ -406,10 +410,10 @@ static irqreturn_t ads1015_trigger_handler(int irq, void *p)
 		goto err;
 	}
 
-	buf[0] = res;
+	scan.chan = res;
 	mutex_unlock(&data->lock);
 
-	iio_push_to_buffers_with_timestamp(indio_dev, buf,
+	iio_push_to_buffers_with_timestamp(indio_dev, &scan,
 					   iio_get_time_ns(indio_dev));
 
 err:
-- 
2.30.2



