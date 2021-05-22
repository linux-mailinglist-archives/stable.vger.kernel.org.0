Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A0E38D450
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 09:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhEVHwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 03:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhEVHwB (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 22 May 2021 03:52:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C2A8611ED;
        Sat, 22 May 2021 07:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621669836;
        bh=QabXp73QViezP5LRalRQ+Bz3hPE0hO62WCkGUfUUdvM=;
        h=Subject:To:From:Date:From;
        b=RlgZvrqI9hGz6divwZbbv3RJzNjxgnlQ5AHsFEuh5QO6u5B0aDUu4e3eDHavUiWn3
         bcBDURKncsy+CC92xRq3RzVDZo5disTPo9ezGuIE3N90qtghckO4lC1OY/kGeJchEY
         eOlIn4vU4dQEblvwLr4fEEaDj6i4gAGIlHxT7I34=
Subject: patch "iio: adc: ad7793: Add missing error code in ad7793_setup()" added to staging-linus
To:     yuehaibing@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 May 2021 09:50:21 +0200
Message-ID: <162166982112229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7793: Add missing error code in ad7793_setup()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4ed243b1da169bcbc1ec5507867e56250c5f1ff9 Mon Sep 17 00:00:00 2001
From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 14 May 2021 16:02:54 +0800
Subject: iio: adc: ad7793: Add missing error code in ad7793_setup()

Set error code while device ID query failed.

Fixes: 88bc30548aae ("IIO: ADC: New driver for AD7792/AD7793 3 Channel SPI ADC")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ad7793.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/ad7793.c b/drivers/iio/adc/ad7793.c
index 5e980a06258e..440ef4c7be07 100644
--- a/drivers/iio/adc/ad7793.c
+++ b/drivers/iio/adc/ad7793.c
@@ -279,6 +279,7 @@ static int ad7793_setup(struct iio_dev *indio_dev,
 	id &= AD7793_ID_MASK;
 
 	if (id != st->chip_info->id) {
+		ret = -ENODEV;
 		dev_err(&st->sd.spi->dev, "device ID query failed\n");
 		goto out;
 	}
-- 
2.31.1


