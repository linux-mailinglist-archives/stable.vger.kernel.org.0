Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692AB40DF0A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhIPQGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240670AbhIPQGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B29761241;
        Thu, 16 Sep 2021 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808279;
        bh=rBUMzl3onosp598T5s5G9TA9eIJrYtyHlU6jND7CCzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0p8l5h1jEgQGUGH5HO5crTg8f7T4fCyQwU2fLlnA7CUDZRu475rtGKN6bhIMA40CH
         rH1xaJczOzgtaaX+knRT3FEZRSBQja2KCe1P3PB4fWgYkjZjIxc9sZBrGRJTp6lvh1
         1+Tm03rVwCOAu6hzhqjMyLkvRxR+540x0GEgXb+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Drew Fustini <drew@pdp7.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 028/306] iio: ltc2983: fix device probe
Date:   Thu, 16 Sep 2021 17:56:13 +0200
Message-Id: <20210916155754.901625624@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit b76d26d69ecc97ebb24aaf40427a13c808a4f488 upstream.

There is no reason to assume that the IRQ rising edge (indicating that
the device start up phase is done) will happen after we request the IRQ.
If the device is already up by the time we request it, the call to
'wait_for_completion_timeout()' will timeout and we will fail the device
probe even though there's nothing wrong.

Fix it by just polling the status register until we get the indication that
the device is up and running. As a side effect of this fix, requesting the
IRQ is also moved to after the setup function.

Fixes: f110f3188e563 ("iio: temperature: Add support for LTC2983")
Reported-and-tested-by: Drew Fustini <drew@pdp7.com>
Reviewed-by: Drew Fustini <drew@pdp7.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210811133220.190264-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/ltc2983.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -89,6 +89,8 @@
 
 #define	LTC2983_STATUS_START_MASK	BIT(7)
 #define	LTC2983_STATUS_START(x)		FIELD_PREP(LTC2983_STATUS_START_MASK, x)
+#define	LTC2983_STATUS_UP_MASK		GENMASK(7, 6)
+#define	LTC2983_STATUS_UP(reg)		FIELD_GET(LTC2983_STATUS_UP_MASK, reg)
 
 #define	LTC2983_STATUS_CHAN_SEL_MASK	GENMASK(4, 0)
 #define	LTC2983_STATUS_CHAN_SEL(x) \
@@ -1362,17 +1364,16 @@ put_child:
 
 static int ltc2983_setup(struct ltc2983_data *st, bool assign_iio)
 {
-	u32 iio_chan_t = 0, iio_chan_v = 0, chan, iio_idx = 0;
+	u32 iio_chan_t = 0, iio_chan_v = 0, chan, iio_idx = 0, status;
 	int ret;
-	unsigned long time;
-
-	/* make sure the device is up */
-	time = wait_for_completion_timeout(&st->completion,
-					    msecs_to_jiffies(250));
 
-	if (!time) {
+	/* make sure the device is up: start bit (7) is 0 and done bit (6) is 1 */
+	ret = regmap_read_poll_timeout(st->regmap, LTC2983_STATUS_REG, status,
+				       LTC2983_STATUS_UP(status) == 1, 25000,
+				       25000 * 10);
+	if (ret) {
 		dev_err(&st->spi->dev, "Device startup timed out\n");
-		return -ETIMEDOUT;
+		return ret;
 	}
 
 	st->iio_chan = devm_kzalloc(&st->spi->dev,
@@ -1492,10 +1493,11 @@ static int ltc2983_probe(struct spi_devi
 	ret = ltc2983_parse_dt(st);
 	if (ret)
 		return ret;
-	/*
-	 * let's request the irq now so it is used to sync the device
-	 * startup in ltc2983_setup()
-	 */
+
+	ret = ltc2983_setup(st, true);
+	if (ret)
+		return ret;
+
 	ret = devm_request_irq(&spi->dev, spi->irq, ltc2983_irq_handler,
 			       IRQF_TRIGGER_RISING, name, st);
 	if (ret) {
@@ -1503,10 +1505,6 @@ static int ltc2983_probe(struct spi_devi
 		return ret;
 	}
 
-	ret = ltc2983_setup(st, true);
-	if (ret)
-		return ret;
-
 	indio_dev->name = name;
 	indio_dev->num_channels = st->iio_channels;
 	indio_dev->channels = st->iio_chan;


