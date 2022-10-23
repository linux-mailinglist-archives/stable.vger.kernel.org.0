Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEA060949A
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 18:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiJWQHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 12:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiJWQHF (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 23 Oct 2022 12:07:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F7B5BC93
        for <Stable@vger.kernel.org>; Sun, 23 Oct 2022 09:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1F37B80DB2
        for <Stable@vger.kernel.org>; Sun, 23 Oct 2022 16:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF52C433C1;
        Sun, 23 Oct 2022 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666541221;
        bh=g/mLngcdlsKK8+wUlmzX72H4bD9737qt8FgPdn6qnCY=;
        h=Subject:To:From:Date:From;
        b=tRHRpyCOb1vm+C/FqhbaNuQS2ymC6qwKyBdtM7PT4NoTuexDifMWRX05qsX/cb2i7
         dSBIOOLQzfGXTQ10LoRtnS4PaUiYOEoUgWROm5MFpd2BqveTYA9/hyxOHCQTwA2Z3x
         KXZTPU/Gkghwx/TRycgIrUqVsGhL7w5WC1lGrMUY=
Subject: patch "iio: adxl367: Fix unsafe buffer attributes" added to char-misc-linus
To:     mazziesaccount@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Oct 2022 18:06:28 +0200
Message-ID: <166654118822474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adxl367: Fix unsafe buffer attributes

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5e23b33d1e84f04c80da6f1d89cbb3d3a3f81e01 Mon Sep 17 00:00:00 2001
From: Matti Vaittinen <mazziesaccount@gmail.com>
Date: Mon, 3 Oct 2022 11:10:29 +0300
Subject: iio: adxl367: Fix unsafe buffer attributes

The devm_iio_kfifo_buffer_setup_ext() was changed by
commit 15097c7a1adc ("iio: buffer: wrap all buffer attributes into iio_dev_attr")
to silently expect that all attributes given in buffer_attrs array are
device-attributes. This expectation was not forced by the API - and some
drivers did register attributes created by IIO_CONST_ATTR().

The added attribute "wrapping" does not copy the pointer to stored
string constant and when the sysfs file is read the kernel will access
to invalid location.

Change the IIO_CONST_ATTRs from the driver to IIO_DEVICE_ATTR in order
to prevent the invalid memory access.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 15097c7a1adc ("iio: buffer: wrap all buffer attributes into iio_dev_attr")
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/2e2d9ec34fb1df8ab8e2749199822db8cc91d302.1664782676.git.mazziesaccount@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/adxl367.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/adxl367.c b/drivers/iio/accel/adxl367.c
index 47feb375b70b..7c7d78040793 100644
--- a/drivers/iio/accel/adxl367.c
+++ b/drivers/iio/accel/adxl367.c
@@ -1185,17 +1185,30 @@ static ssize_t adxl367_get_fifo_watermark(struct device *dev,
 	return sysfs_emit(buf, "%d\n", fifo_watermark);
 }
 
-static IIO_CONST_ATTR(hwfifo_watermark_min, "1");
-static IIO_CONST_ATTR(hwfifo_watermark_max,
-		      __stringify(ADXL367_FIFO_MAX_WATERMARK));
+static ssize_t hwfifo_watermark_min_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return sysfs_emit(buf, "%s\n", "1");
+}
+
+static ssize_t hwfifo_watermark_max_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return sysfs_emit(buf, "%s\n", __stringify(ADXL367_FIFO_MAX_WATERMARK));
+}
+
+static IIO_DEVICE_ATTR_RO(hwfifo_watermark_min, 0);
+static IIO_DEVICE_ATTR_RO(hwfifo_watermark_max, 0);
 static IIO_DEVICE_ATTR(hwfifo_watermark, 0444,
 		       adxl367_get_fifo_watermark, NULL, 0);
 static IIO_DEVICE_ATTR(hwfifo_enabled, 0444,
 		       adxl367_get_fifo_enabled, NULL, 0);
 
 static const struct attribute *adxl367_fifo_attributes[] = {
-	&iio_const_attr_hwfifo_watermark_min.dev_attr.attr,
-	&iio_const_attr_hwfifo_watermark_max.dev_attr.attr,
+	&iio_dev_attr_hwfifo_watermark_min.dev_attr.attr,
+	&iio_dev_attr_hwfifo_watermark_max.dev_attr.attr,
 	&iio_dev_attr_hwfifo_watermark.dev_attr.attr,
 	&iio_dev_attr_hwfifo_enabled.dev_attr.attr,
 	NULL,
-- 
2.38.1


