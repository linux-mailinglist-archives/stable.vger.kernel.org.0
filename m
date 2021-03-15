Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4517533C009
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhCOPgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 11:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232792AbhCOPfc (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Mar 2021 11:35:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6F6F64E74;
        Mon, 15 Mar 2021 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615822532;
        bh=mpJGC1tq+aMqikQcS/rifbb3xsHAUd7z5b9NS3VHXg4=;
        h=Subject:To:From:Date:From;
        b=ZGyA8yhgpGI3fILIOSm3qTP/sxGO8rm/1tx0Zgk2nhv4MJE3V+SAyrKqrr2Dud+Z/
         4A4yhUQdJZdK80EA8ylJPY6CF6AFgSTBPk3k57tnKcwD29ewzwwCf1K0Ig5XipADxT
         pdrUlGX8auktG7aT6nFUFq1dycuz0tf7+eX9cDVA=
Subject: patch "iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask" added to staging-linus
To:     wilfried.wessner@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        charles-antoine.couret@essensium.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 16:35:22 +0100
Message-ID: <16158225222918@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f890987fac8153227258121740a9609668c427f3 Mon Sep 17 00:00:00 2001
From: Wilfried Wessner <wilfried.wessner@gmail.com>
Date: Mon, 8 Feb 2021 15:27:05 +0100
Subject: iio: adc: ad7949: fix wrong ADC result due to incorrect bit mask

Fixes a wrong bit mask used for the ADC's result, which was caused by an
improper usage of the GENMASK() macro. The bits higher than ADC's
resolution are undefined and if not masked out correctly, a wrong result
can be given. The GENMASK() macro indexing is zero based, so the mask has
to go from [resolution - 1 , 0].

Fixes: 7f40e0614317f ("iio:adc:ad7949: Add AD7949 ADC driver family")
Signed-off-by: Wilfried Wessner <wilfried.wessner@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Charles-Antoine Couret <charles-antoine.couret@essensium.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210208142705.GA51260@ubuntu
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ad7949.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7949.c b/drivers/iio/adc/ad7949.c
index 5d597e5050f6..1b4b3203e428 100644
--- a/drivers/iio/adc/ad7949.c
+++ b/drivers/iio/adc/ad7949.c
@@ -91,7 +91,7 @@ static int ad7949_spi_read_channel(struct ad7949_adc_chip *ad7949_adc, int *val,
 	int ret;
 	int i;
 	int bits_per_word = ad7949_adc->resolution;
-	int mask = GENMASK(ad7949_adc->resolution, 0);
+	int mask = GENMASK(ad7949_adc->resolution - 1, 0);
 	struct spi_message msg;
 	struct spi_transfer tx[] = {
 		{
-- 
2.30.2


