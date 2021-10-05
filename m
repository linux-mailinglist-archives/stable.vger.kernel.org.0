Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DB342222C
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhJEJXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233779AbhJEJXp (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D724A610C9;
        Tue,  5 Oct 2021 09:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425715;
        bh=GQb9rROPzu1AEArYN1mklIdfBkua0lHUGEsxo+EWyRw=;
        h=Subject:To:From:Date:From;
        b=raKBlylmhXtJQSZCiIrWiBvv44GFIdE8SsiecKMk5EUTQyFVqlfLH/GBbPJtRPvf+
         hA9UhNTCW4NWJ7Dn7uUyJ2SPo509flHTL2/4IYTd4In+aXYp8etX+sr6jtReYVtHYr
         h/jL6qdLsGlSsWCyHTBVxxaqCRgGOmMuDDAqzjH4=
Subject: patch "iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED" added to staging-linus
To:     hui.liu@mediatek.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:26 +0200
Message-ID: <163342568617522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c2980c64c7fd4585d684574c92d1624d44961edd Mon Sep 17 00:00:00 2001
From: Hui Liu <hui.liu@mediatek.com>
Date: Sun, 26 Sep 2021 15:30:28 +0800
Subject: iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED

The previous driver does't apply the necessary scaling to take the
voltage range into account.
We change readback value from raw data to input voltage to fix case
IIO_CHAN_INFO_PROCESSED.

Fixes: ace4cdfe67be ("iio: adc: mt2701: Add Mediatek auxadc driver for mt2701.")
Signed-off-by: Hui Liu <hui.liu@mediatek.com>
Link: https://lore.kernel.org/r/20210926073028.11045-2-hui.liu@mediatek.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/mt6577_auxadc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

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
-- 
2.33.0


