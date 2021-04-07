Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2C535662B
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbhDGIMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233700AbhDGIMg (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:12:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E500613A0;
        Wed,  7 Apr 2021 08:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617783146;
        bh=Pm9WLcvjACDWfOsOTHyWSewqUjXCMKmxTaalZQmBcjk=;
        h=Subject:To:From:Date:From;
        b=HAiC6f5mKd9wm0wms056q+VqJYZsQh5lHd6FA6zCPHgTo6JGvN/sIAwhhZkUklVq2
         ypYrzwdWF+EmXJ8bu3swtQX/7mdRgrZtBE2oFQWOLB5tGx+GVPRkAYk5fSICYpKnqv
         x1g4Zqsa0QWJ2nde0rJ7gs4nHJXz0ZVO2L12YZnQ=
Subject: patch "iio:accel:adis16201: Fix wrong axis assignment that prevents loading" added to staging-next
To:     Jonathan.Cameron@huawei.com, Stable@vger.kernel.org,
        ardeleanalex@gmail.com, himanshujha199640@gmail.com,
        nuno.sa@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Apr 2021 10:10:10 +0200
Message-ID: <161778301073206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:accel:adis16201: Fix wrong axis assignment that prevents loading

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 4e102429f3dc62dce546f6107e34a4284634196d Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Sun, 21 Mar 2021 18:29:56 +0000
Subject: iio:accel:adis16201: Fix wrong axis assignment that prevents loading
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Whilst running some basic tests as part of writing up the dt-bindings for
this driver (to follow), it became clear it doesn't actually load
currently.

iio iio:device1: tried to double register : in_incli_x_index
adis16201 spi0.0: Failed to create buffer sysfs interfaces
adis16201: probe of spi0.0 failed with error -16

Looks like a cut and paste / update bug.  Fixes tag obviously not accurate
but we don't want to bother carry thing back to before the driver moved
out of staging.

Fixes: 591298e54cea ("Staging: iio: accel: adis16201: Move adis16201 driver out of staging")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Cc: Himanshu Jha <himanshujha199640@gmail.com>
Cc: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Alexandru Ardelean <ardeleanalex@gmail.com>
Link: https://lore.kernel.org/r/20210321182956.844652-1-jic23@kernel.org
---
 drivers/iio/accel/adis16201.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/adis16201.c b/drivers/iio/accel/adis16201.c
index 3633a4e302c6..fe225990de24 100644
--- a/drivers/iio/accel/adis16201.c
+++ b/drivers/iio/accel/adis16201.c
@@ -215,7 +215,7 @@ static const struct iio_chan_spec adis16201_channels[] = {
 	ADIS_AUX_ADC_CHAN(ADIS16201_AUX_ADC_REG, ADIS16201_SCAN_AUX_ADC, 0, 12),
 	ADIS_INCLI_CHAN(X, ADIS16201_XINCL_OUT_REG, ADIS16201_SCAN_INCLI_X,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
-	ADIS_INCLI_CHAN(X, ADIS16201_YINCL_OUT_REG, ADIS16201_SCAN_INCLI_Y,
+	ADIS_INCLI_CHAN(Y, ADIS16201_YINCL_OUT_REG, ADIS16201_SCAN_INCLI_Y,
 			BIT(IIO_CHAN_INFO_CALIBBIAS), 0, 14),
 	IIO_CHAN_SOFT_TIMESTAMP(7)
 };
-- 
2.31.1


