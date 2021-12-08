Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F396746D3C7
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhLHM5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:57:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49494 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbhLHM5q (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:57:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB6D3B81F79
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B493C00446;
        Wed,  8 Dec 2021 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968052;
        bh=+sYDWmv1FzbFCUGkaaCGP6VKEYcon894ah6iIzBwK2M=;
        h=Subject:To:From:Date:From;
        b=fmg/omWQsWSLBS0JDIZWzDydAe0SGm2s34CB+bdHOgl5TX8wS7Kfb+DwG2rUmrG0f
         Dr/sqDBDUEg4hmmDbHLRXX98dJtxKGCLSk4zwVWKrA33i5NhAoAO/QYjFLO61DntNA
         wWpxjo3TK9dwgi78NmZ01jux+W6otWM8R6l3gBB4=
Subject: patch "iio: dln2-adc: Fix lockdep complaint" added to char-misc-linus
To:     noralf@tronnes.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, jackoalan@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:54 +0100
Message-ID: <16389680348282@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: dln2-adc: Fix lockdep complaint

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 59f92868176f191eefde70d284bdfc1ed76a84bc Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
Date: Mon, 18 Oct 2021 13:37:31 +0200
Subject: iio: dln2-adc: Fix lockdep complaint
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When reading the voltage:

$ cat /sys/bus/iio/devices/iio\:device0/in_voltage0_raw

Lockdep complains:

[  153.910616] ======================================================
[  153.916918] WARNING: possible circular locking dependency detected
[  153.923221] 5.14.0+ #5 Not tainted
[  153.926692] ------------------------------------------------------
[  153.932992] cat/717 is trying to acquire lock:
[  153.937525] c2585358 (&indio_dev->mlock){+.+.}-{3:3}, at: iio_device_claim_direct_mode+0x28/0x44
[  153.946541]
               but task is already holding lock:
[  153.952487] c2585860 (&dln2->mutex){+.+.}-{3:3}, at: dln2_adc_read_raw+0x94/0x2bc [dln2_adc]
[  153.961152]
               which lock already depends on the new lock.

Fix this by not calling into the iio core underneath the dln2->mutex lock.

Fixes: 7c0299e879dd ("iio: adc: Add support for DLN2 ADC")
Cc: Jack Andersen <jackoalan@gmail.com>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://lore.kernel.org/r/20211018113731.25723-1-noralf@tronnes.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/dln2-adc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/dln2-adc.c b/drivers/iio/adc/dln2-adc.c
index 16407664182c..6c67192946aa 100644
--- a/drivers/iio/adc/dln2-adc.c
+++ b/drivers/iio/adc/dln2-adc.c
@@ -248,7 +248,6 @@ static int dln2_adc_set_chan_period(struct dln2_adc *dln2,
 static int dln2_adc_read(struct dln2_adc *dln2, unsigned int channel)
 {
 	int ret, i;
-	struct iio_dev *indio_dev = platform_get_drvdata(dln2->pdev);
 	u16 conflict;
 	__le16 value;
 	int olen = sizeof(value);
@@ -257,13 +256,9 @@ static int dln2_adc_read(struct dln2_adc *dln2, unsigned int channel)
 		.chan = channel,
 	};
 
-	ret = iio_device_claim_direct_mode(indio_dev);
-	if (ret < 0)
-		return ret;
-
 	ret = dln2_adc_set_chan_enabled(dln2, channel, true);
 	if (ret < 0)
-		goto release_direct;
+		return ret;
 
 	ret = dln2_adc_set_port_enabled(dln2, true, &conflict);
 	if (ret < 0) {
@@ -300,8 +295,6 @@ static int dln2_adc_read(struct dln2_adc *dln2, unsigned int channel)
 	dln2_adc_set_port_enabled(dln2, false, NULL);
 disable_chan:
 	dln2_adc_set_chan_enabled(dln2, channel, false);
-release_direct:
-	iio_device_release_direct_mode(indio_dev);
 
 	return ret;
 }
@@ -337,10 +330,16 @@ static int dln2_adc_read_raw(struct iio_dev *indio_dev,
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
+		ret = iio_device_claim_direct_mode(indio_dev);
+		if (ret < 0)
+			return ret;
+
 		mutex_lock(&dln2->mutex);
 		ret = dln2_adc_read(dln2, chan->channel);
 		mutex_unlock(&dln2->mutex);
 
+		iio_device_release_direct_mode(indio_dev);
+
 		if (ret < 0)
 			return ret;
 
-- 
2.34.1


