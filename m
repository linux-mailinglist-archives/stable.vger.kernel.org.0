Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E43CDD7D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245349AbhGSO6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244801AbhGSO5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3855613D2;
        Mon, 19 Jul 2021 15:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708902;
        bh=SYAHmLnYfFi8Sjue7Zq7NtIceETwmVttyjLJP76VGQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBLpsSTbEJGN2spQ9z1SNfGxyuQ/ELUsRjme6nOLnQFJGC20Sl6me2bFVw81UDpO9
         gokqTmnvnunaAr/th+nRWXq3JD0HaJew2vZ28/dMgEZntbMj0vGd8JAhfgdPmIq1QW
         /ee8pLxTd+pSWhdCFk1wxKTBc/i5LIZpe63cnEmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/421] iio: adc: ti-ads1015: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:49:45 +0200
Message-Id: <20210719144952.462559698@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index dc8d859e4b92..b1cccc3eeea6 100644
--- a/drivers/iio/adc/ti-ads1015.c
+++ b/drivers/iio/adc/ti-ads1015.c
@@ -391,10 +391,14 @@ static irqreturn_t ads1015_trigger_handler(int irq, void *p)
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
@@ -405,10 +409,10 @@ static irqreturn_t ads1015_trigger_handler(int irq, void *p)
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



