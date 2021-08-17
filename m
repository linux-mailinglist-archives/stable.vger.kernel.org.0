Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F2F3EF117
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 19:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhHQRt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 13:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230311AbhHQRt5 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 17 Aug 2021 13:49:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E756360FD7;
        Tue, 17 Aug 2021 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629222564;
        bh=SS9Zq8ZnLu+g76roGFuSqAb1eGJnBA/fbxnDtB/qrU8=;
        h=Subject:To:From:Date:From;
        b=HPpbPylfi8bwpjkD2T53KiM0svX2LiSjjYXUJM7biRn7TL0AkSPgg81TjTROKzYjy
         4n0glQnaK6ZtuVdN9hCrnVg6hjaW1GCHtVB0M99J2GrNZQzlBphIbfZ4fpfmn/kKMN
         1i/dlgFAJz27fAL2SZgPIv5tYxFY5JtIOZT/WuxI=
Subject: patch "iio: ltc2983: fix device probe" added to staging-testing
To:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com, drew@pdp7.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Aug 2021 19:49:08 +0200
Message-ID: <16292225485621@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ltc2983: fix device probe

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From b76d26d69ecc97ebb24aaf40427a13c808a4f488 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Date: Wed, 11 Aug 2021 15:32:20 +0200
Subject: iio: ltc2983: fix device probe
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
---
 drivers/iio/temperature/ltc2983.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/iio/temperature/ltc2983.c b/drivers/iio/temperature/ltc2983.c
index 3b5ba26d7d86..3b4a0e60e605 100644
--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -89,6 +89,8 @@
 
 #define	LTC2983_STATUS_START_MASK	BIT(7)
 #define	LTC2983_STATUS_START(x)		FIELD_PREP(LTC2983_STATUS_START_MASK, x)
+#define	LTC2983_STATUS_UP_MASK		GENMASK(7, 6)
+#define	LTC2983_STATUS_UP(reg)		FIELD_GET(LTC2983_STATUS_UP_MASK, reg)
 
 #define	LTC2983_STATUS_CHAN_SEL_MASK	GENMASK(4, 0)
 #define	LTC2983_STATUS_CHAN_SEL(x) \
@@ -1362,17 +1364,16 @@ static int ltc2983_parse_dt(struct ltc2983_data *st)
 
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
@@ -1492,10 +1493,11 @@ static int ltc2983_probe(struct spi_device *spi)
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
@@ -1503,10 +1505,6 @@ static int ltc2983_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	ret = ltc2983_setup(st, true);
-	if (ret)
-		return ret;
-
 	indio_dev->name = name;
 	indio_dev->num_channels = st->iio_channels;
 	indio_dev->channels = st->iio_chan;
-- 
2.32.0


