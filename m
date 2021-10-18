Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF91F4315B9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhJRKSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231736AbhJRKR2 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 18 Oct 2021 06:17:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E6F960E54;
        Mon, 18 Oct 2021 10:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634552116;
        bh=GObAGqZ2hvrL/nRO9gl0VcvqDvc/hE34/bIPAyRon/Q=;
        h=Subject:To:Cc:From:Date:From;
        b=CIXlK2wU4v1r1Am96cvfEXmSo5ZtgOjgZd6cv7vk2+0pb170QKFGDnr4PuTyN8eAr
         EkuS92v/xn3CZ1iTb1bX98oQ7JKvdVQjKORRxtLk0lm8NIGJEn7ZHrSzX01wCXg0/V
         7zUBfjqYuPdgnPqA8tycpHMz8Jg75kxRpUk6xzZE=
Subject: FAILED: patch "[PATCH] iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED" failed to apply to 4.9-stable tree
To:     hui.liu@mediatek.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 12:15:13 +0200
Message-ID: <163455211320827@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c2980c64c7fd4585d684574c92d1624d44961edd Mon Sep 17 00:00:00 2001
From: Hui Liu <hui.liu@mediatek.com>
Date: Sun, 26 Sep 2021 15:30:28 +0800
Subject: [PATCH] iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED

The previous driver does't apply the necessary scaling to take the
voltage range into account.
We change readback value from raw data to input voltage to fix case
IIO_CHAN_INFO_PROCESSED.

Fixes: ace4cdfe67be ("iio: adc: mt2701: Add Mediatek auxadc driver for mt2701.")
Signed-off-by: Hui Liu <hui.liu@mediatek.com>
Link: https://lore.kernel.org/r/20210926073028.11045-2-hui.liu@mediatek.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

diff --git a/drivers/iio/adc/mt6577_auxadc.c b/drivers/iio/adc/mt6577_auxadc.c
index 79c1dd68b909..d4fccd52ef08 100644
--- a/drivers/iio/adc/mt6577_auxadc.c
+++ b/drivers/iio/adc/mt6577_auxadc.c
@@ -82,6 +82,10 @@ static const struct iio_chan_spec mt6577_auxadc_iio_channels[] = {
 	MT6577_AUXADC_CHANNEL(15),
 };
 
+/* For Voltage calculation */
+#define VOLTAGE_FULL_RANGE  1500	/* VA voltage */
+#define AUXADC_PRECISE      4096	/* 12 bits */
+
 static int mt_auxadc_get_cali_data(int rawdata, bool enable_cali)
 {
 	return rawdata;
@@ -191,6 +195,10 @@ static int mt6577_auxadc_read_raw(struct iio_dev *indio_dev,
 		}
 		if (adc_dev->dev_comp->sample_data_cali)
 			*val = mt_auxadc_get_cali_data(*val, true);
+
+		/* Convert adc raw data to voltage: 0 - 1500 mV */
+		*val = *val * VOLTAGE_FULL_RANGE / AUXADC_PRECISE;
+
 		return IIO_VAL_INT;
 
 	default:

