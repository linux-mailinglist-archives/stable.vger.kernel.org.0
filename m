Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A21F69CC30
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjBTNiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjBTNiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:38:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434419765
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:37:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F20E7B80D4A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F9BC4339B;
        Mon, 20 Feb 2023 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900276;
        bh=CCTUfMzG7mhS8tCKJ0v7RdtVumVn6FgmPm+lpGXi61A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XeH72dWHcr2888ejF9G8suhMawKvzMuusdutOed9w3HLs3XoVjDJ45QT5lz52i1YJ
         g0ClgFHnFxwn0qKNcaMrvYdAJGNUnLQ+5VmiVh719Mp8eeL6oQpYXnz+5wMPVIEb14
         RVsFcmLbakhHWEAqKmscZif1EPYeEkNdzF1eIuJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Kemnade <andreas@kemnade.info>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 18/53] iio:adc:twl6030: Enable measurements of VUSB, VBAT and others
Date:   Mon, 20 Feb 2023 14:35:44 +0100
Message-Id: <20230220133548.818151677@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Kemnade <andreas@kemnade.info>

commit f804bd0dc28683a93a60f271aaefb2fc5b0853dd upstream.

Some inputs need to be wired up to produce proper measurements,
without this change only near zero values are reported.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Fixes: 1696f36482e70 ("iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver")
Link: https://lore.kernel.org/r/20221201181635.3522962-1-andreas@kemnade.info
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/twl6030-gpadc.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -71,6 +71,18 @@
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
@@ -943,6 +955,26 @@ static int twl6030_gpadc_probe(struct pl
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
 	indio_dev->dev.parent = dev;
 	indio_dev->info = &twl6030_gpadc_iio_info;


