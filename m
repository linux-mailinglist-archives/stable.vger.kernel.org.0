Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020B03033A8
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbhAZFCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731165AbhAYSvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 110A02067B;
        Mon, 25 Jan 2021 18:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600685;
        bh=j19lPMeMRNJJalpLPNr9zePRXO3jPIrpJiqsFNQVtEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEqU4Zg6/vAx8J7OQn1F/sLRb54I+EfbGisxEdQcHSly3slrSVM9HgMRd0mmW/8qw
         iHba5L8UffIPKoZizSjbPye+SnceIB8IG8iM6KgTrXMAqkRXPzze8ezzGfHTRYUoL9
         9cCZpw3ByRjMqBuYK/VxNKi4buYaJ7iNqywsDtro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 111/199] iio: common: st_sensors: fix possible infinite loop in st_sensors_irq_thread
Date:   Mon, 25 Jan 2021 19:38:53 +0100
Message-Id: <20210125183220.938415186@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 40c48fb79b9798954691f24b8ece1d3a7eb1b353 upstream.

Return a boolean value in st_sensors_new_samples_available routine in
order to avoid an infinite loop in st_sensors_irq_thread if
stat_drdy.addr is not defined or stat_drdy read fails

Fixes: 90efe05562921 ("iio: st_sensors: harden interrupt handling")
Reported-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/c9ec69ed349e7200c779fd7a5bf04c1aaa2817aa.1607438132.git.lorenzo@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/common/st_sensors/st_sensors_trigger.c |   31 +++++++++++----------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/iio/common/st_sensors/st_sensors_trigger.c
+++ b/drivers/iio/common/st_sensors/st_sensors_trigger.c
@@ -23,35 +23,31 @@
  * @sdata: Sensor data.
  *
  * returns:
- * 0 - no new samples available
- * 1 - new samples available
- * negative - error or unknown
+ * false - no new samples available or read error
+ * true - new samples available
  */
-static int st_sensors_new_samples_available(struct iio_dev *indio_dev,
-					    struct st_sensor_data *sdata)
+static bool st_sensors_new_samples_available(struct iio_dev *indio_dev,
+					     struct st_sensor_data *sdata)
 {
 	int ret, status;
 
 	/* How would I know if I can't check it? */
 	if (!sdata->sensor_settings->drdy_irq.stat_drdy.addr)
-		return -EINVAL;
+		return true;
 
 	/* No scan mask, no interrupt */
 	if (!indio_dev->active_scan_mask)
-		return 0;
+		return false;
 
 	ret = regmap_read(sdata->regmap,
 			  sdata->sensor_settings->drdy_irq.stat_drdy.addr,
 			  &status);
 	if (ret < 0) {
 		dev_err(sdata->dev, "error checking samples available\n");
-		return ret;
+		return false;
 	}
 
-	if (status & sdata->sensor_settings->drdy_irq.stat_drdy.mask)
-		return 1;
-
-	return 0;
+	return !!(status & sdata->sensor_settings->drdy_irq.stat_drdy.mask);
 }
 
 /**
@@ -180,9 +176,15 @@ int st_sensors_allocate_trigger(struct i
 
 	/* Tell the interrupt handler that we're dealing with edges */
 	if (irq_trig == IRQF_TRIGGER_FALLING ||
-	    irq_trig == IRQF_TRIGGER_RISING)
+	    irq_trig == IRQF_TRIGGER_RISING) {
+		if (!sdata->sensor_settings->drdy_irq.stat_drdy.addr) {
+			dev_err(&indio_dev->dev,
+				"edge IRQ not supported w/o stat register.\n");
+			err = -EOPNOTSUPP;
+			goto iio_trigger_free;
+		}
 		sdata->edge_irq = true;
-	else
+	} else {
 		/*
 		 * If we're not using edges (i.e. level interrupts) we
 		 * just mask off the IRQ, handle one interrupt, then
@@ -190,6 +192,7 @@ int st_sensors_allocate_trigger(struct i
 		 * interrupt handler top half again and start over.
 		 */
 		irq_trig |= IRQF_ONESHOT;
+	}
 
 	/*
 	 * If the interrupt pin is Open Drain, by definition this


