Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821723E53F6
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 08:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbhHJG4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 02:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhHJG4K (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 10 Aug 2021 02:56:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 534CD61052;
        Tue, 10 Aug 2021 06:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628578548;
        bh=RVZtgBllZILs8j0Ee1WWG8An+MwVcPIPGAHRkW6Bwi8=;
        h=Subject:To:From:Date:From;
        b=I/ZwCI0r30YtKyo7BlHGX+fMsSfdNm1mjVRS2s7UrOsOMP44kvNIlNH/Zu/zS4B8l
         zU4fnVzK7ZtYFG7gzbxUDLsn5rT+jUnQt2PygNcx2jthq0QboyiWw5hmgFUOoeINX3
         1hyUFrejkMBxTj+Ow5Da0MxBR3VlHn794dL1pB44=
Subject: patch "iio: humidity: hdc100x: Add margin to the conversion time" added to staging-linus
To:     chris.lesiak@licor.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, matt.ranostay@konsulko.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Aug 2021 08:55:33 +0200
Message-ID: <162857853312928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: humidity: hdc100x: Add margin to the conversion time

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 84edec86f449adea9ee0b4912a79ab8d9d65abb7 Mon Sep 17 00:00:00 2001
From: Chris Lesiak <chris.lesiak@licor.com>
Date: Mon, 14 Jun 2021 09:18:20 -0500
Subject: iio: humidity: hdc100x: Add margin to the conversion time

The datasheets have the following note for the conversion time
specification: "This parameter is specified by design and/or
characterization and it is not tested in production."

Parts have been seen that require more time to do 14-bit conversions for
the relative humidity channel.  The result is ENXIO due to the address
phase of a transfer not getting an ACK.

Delay an additional 1 ms per conversion to allow for additional margin.

Fixes: 4839367d99e3 ("iio: humidity: add HDC100x support")
Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Link: https://lore.kernel.org/r/20210614141820.2034827-1-chris.lesiak@licor.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/humidity/hdc100x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/humidity/hdc100x.c b/drivers/iio/humidity/hdc100x.c
index 2a957f19048e..9e0fce917ce4 100644
--- a/drivers/iio/humidity/hdc100x.c
+++ b/drivers/iio/humidity/hdc100x.c
@@ -25,6 +25,8 @@
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/triggered_buffer.h>
 
+#include <linux/time.h>
+
 #define HDC100X_REG_TEMP			0x00
 #define HDC100X_REG_HUMIDITY			0x01
 
@@ -166,7 +168,7 @@ static int hdc100x_get_measurement(struct hdc100x_data *data,
 				   struct iio_chan_spec const *chan)
 {
 	struct i2c_client *client = data->client;
-	int delay = data->adc_int_us[chan->address];
+	int delay = data->adc_int_us[chan->address] + 1*USEC_PER_MSEC;
 	int ret;
 	__be16 val;
 
@@ -316,7 +318,7 @@ static irqreturn_t hdc100x_trigger_handler(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct hdc100x_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
-	int delay = data->adc_int_us[0] + data->adc_int_us[1];
+	int delay = data->adc_int_us[0] + data->adc_int_us[1] + 2*USEC_PER_MSEC;
 	int ret;
 
 	/* dual read starts at temp register */
-- 
2.32.0


