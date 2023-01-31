Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82AF68298D
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjAaJw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjAaJwz (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:52:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C008AF
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:52:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D534BB81AC8
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EC8C433D2;
        Tue, 31 Jan 2023 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158768;
        bh=CZUgddo5B701+5i69/dsZegxxzOmzwL1Ud+728AzoyU=;
        h=Subject:To:From:Date:From;
        b=cMzKTxF4didlinbMIHlwWjTjI9mOQF1aqcqnsuEEE+MopSqWhSgz2mk+3ofaF1xC4
         tyxMf2G9l9tbPlujcQUyce18zJlnUZGiQm7P9JWVDJqcmxaW9l4em2XZxeWjSKixJ6
         wEGmdC+ITr83z38wuwQrdS0hYvabX2mT8qecLPkA=
Subject: patch "iio:adc:twl6030: Enable measurements of VUSB, VBAT and others" added to char-misc-linus
To:     andreas@kemnade.info, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:38 +0100
Message-ID: <1675158758241125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:adc:twl6030: Enable measurements of VUSB, VBAT and others

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f804bd0dc28683a93a60f271aaefb2fc5b0853dd Mon Sep 17 00:00:00 2001
From: Andreas Kemnade <andreas@kemnade.info>
Date: Thu, 1 Dec 2022 19:16:35 +0100
Subject: iio:adc:twl6030: Enable measurements of VUSB, VBAT and others

Some inputs need to be wired up to produce proper measurements,
without this change only near zero values are reported.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Fixes: 1696f36482e70 ("iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver")
Link: https://lore.kernel.org/r/20221201181635.3522962-1-andreas@kemnade.info
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/twl6030-gpadc.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index f53e8558b560..40438e5b4970 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -57,6 +57,18 @@
 #define TWL6030_GPADCS				BIT(1)
 #define TWL6030_GPADCR				BIT(0)
 
+#define USB_VBUS_CTRL_SET			0x04
+#define USB_ID_CTRL_SET				0x06
+
+#define TWL6030_MISC1				0xE4
+#define VBUS_MEAS				0x01
+#define ID_MEAS					0x01
+
+#define VAC_MEAS                0x04
+#define VBAT_MEAS               0x02
+#define BB_MEAS                 0x01
+
+
 /**
  * struct twl6030_chnl_calib - channel calibration
  * @gain:		slope coefficient for ideal curve
@@ -927,6 +939,26 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = twl_i2c_write_u8(TWL_MODULE_USB, VBUS_MEAS, USB_VBUS_CTRL_SET);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
+	ret = twl_i2c_write_u8(TWL_MODULE_USB, ID_MEAS, USB_ID_CTRL_SET);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID0,
+				VBAT_MEAS | BB_MEAS | BB_MEAS,
+				TWL6030_MISC1);
+	if (ret < 0) {
+		dev_err(dev, "failed to wire up inputs\n");
+		return ret;
+	}
+
 	indio_dev->name = DRIVER_NAME;
 	indio_dev->info = &twl6030_gpadc_iio_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;
-- 
2.39.1


