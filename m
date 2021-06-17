Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0713AB993
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhFQQ2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 12:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbhFQQ2q (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 17 Jun 2021 12:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6D5161166;
        Thu, 17 Jun 2021 16:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623947198;
        bh=sG8Wzs5eCUPIoQjT8dcMhWD4T6C/dAjIflSRwwAZYCQ=;
        h=Subject:To:From:Date:From;
        b=aLbtqAcF5+NwYizMKb/atlOByi/vpR/9FmDgAQ0UyqMSalkq5FX74RJw7E+snoYti
         eVPi86g5idTPoiOooRatUy/f84LonP8shsq5tGaqaJnGXGaBeryqmNOaU35m57ak78
         B9gEBqMlz5oqTwq3IMzBhZsPcLhcjyGOg0a+2D7o=
Subject: patch "iio: ltr501: ltr501_read_ps(): add missing endianness conversion" added to staging-testing
To:     Oliver.Lang@gossenmetrawatt.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        mkl@pengutronix.de, nikita@trvn.ru
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Jun 2021 18:24:55 +0200
Message-ID: <1623947095199234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ltr501: ltr501_read_ps(): add missing endianness conversion

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 71b33f6f93ef9462c84560e2236ed22209d26a58 Mon Sep 17 00:00:00 2001
From: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
Date: Thu, 10 Jun 2021 15:46:18 +0200
Subject: iio: ltr501: ltr501_read_ps(): add missing endianness conversion

The PS ADC Channel data is spread over 2 registers in little-endian
form. This patch adds the missing endianness conversion.

Fixes: 2690be905123 ("iio: Add Lite-On ltr501 ambient light / proximity sensor driver")
Signed-off-by: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Nikita Travkin <nikita@trvn.ru> # ltr559
Link: https://lore.kernel.org/r/20210610134619.2101372-4-mkl@pengutronix.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/ltr501.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 79898b72fe73..74ed2d88a3ed 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -409,18 +409,19 @@ static int ltr501_read_als(const struct ltr501_data *data, __le16 buf[2])
 
 static int ltr501_read_ps(const struct ltr501_data *data)
 {
-	int ret, status;
+	__le16 status;
+	int ret;
 
 	ret = ltr501_drdy(data, LTR501_STATUS_PS_RDY);
 	if (ret < 0)
 		return ret;
 
 	ret = regmap_bulk_read(data->regmap, LTR501_PS_DATA,
-			       &status, 2);
+			       &status, sizeof(status));
 	if (ret < 0)
 		return ret;
 
-	return status;
+	return le16_to_cpu(status);
 }
 
 static int ltr501_read_intr_prst(const struct ltr501_data *data,
-- 
2.32.0


