Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202E73AB98C
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 18:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbhFQQ2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 12:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbhFQQ2G (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 17 Jun 2021 12:28:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EFBE61249;
        Thu, 17 Jun 2021 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623947158;
        bh=Oc3xVK9MgagfNR4CD+mjGk5+Qgy4sKlKXzru86s48fA=;
        h=Subject:To:From:Date:From;
        b=01zoZibuDmEpJY4yx+9rVKM7cYHapSNeE30B1cTtQFm1F45vLT9ZvurTbLLZ6C9+z
         AL9blsdBbVxV+yToHGEzr0Y1HINgSlyuMTDN3nhRzuTr+TQLPb+se9IwalTo8du91p
         SEV2DDk94/2HFiP0nHD4mTSwajV/WFQICK5kgPQI=
Subject: patch "iio: frequency: adf4350: disable reg and clk on error in" added to staging-testing
To:     yangyingliang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hulkci@huawei.com, linus.walleij@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Jun 2021 18:24:46 +0200
Message-ID: <16239470861999@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: frequency: adf4350: disable reg and clk on error in

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c8cc4cf60b000fb9f4b29bed131fb6cf1fe42d67 Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Tue, 1 Jun 2021 22:26:05 +0800
Subject: iio: frequency: adf4350: disable reg and clk on error in
 adf4350_probe()

Disable reg and clk when devm_gpiod_get_optional() fails in adf4350_probe().

Fixes:4a89d2f47ccd ("iio: adf4350: Convert to use GPIO descriptor")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210601142605.3613605-1-yangyingliang@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/frequency/adf4350.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/frequency/adf4350.c b/drivers/iio/frequency/adf4350.c
index 1462a6a5bc6d..3d9eba716b69 100644
--- a/drivers/iio/frequency/adf4350.c
+++ b/drivers/iio/frequency/adf4350.c
@@ -563,8 +563,10 @@ static int adf4350_probe(struct spi_device *spi)
 
 	st->lock_detect_gpiod = devm_gpiod_get_optional(&spi->dev, NULL,
 							GPIOD_IN);
-	if (IS_ERR(st->lock_detect_gpiod))
-		return PTR_ERR(st->lock_detect_gpiod);
+	if (IS_ERR(st->lock_detect_gpiod)) {
+		ret = PTR_ERR(st->lock_detect_gpiod);
+		goto error_disable_reg;
+	}
 
 	if (pdata->power_up_frequency) {
 		ret = adf4350_set_freq(st, pdata->power_up_frequency);
-- 
2.32.0


