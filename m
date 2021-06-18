Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7963AC3F2
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 08:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhFRGev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 02:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhFRGev (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 18 Jun 2021 02:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B195B60C41;
        Fri, 18 Jun 2021 06:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623997962;
        bh=gwxRqUEpTWwUKPAjsnRnoYZ4oCZYC6FRSIl8CB8B6kY=;
        h=Subject:To:From:Date:From;
        b=w/OJ3JmOLI7F34TBp9UQxzib7e4z8vUAp9R6xA+lXJbYWLmTn1X8GQxSgr5p2i7v1
         WJx7HsqjXKPcjuwZMyMxq16HRwEmLkyAzOkh8kZkIj0BBzZoExMlB4qHkPsbujToIV
         K9ZZdZmlBURpovTK3ex820hKRqi+3H45dPoWTFzg=
Subject: patch "iio: frequency: adf4350: disable reg and clk on error in" added to staging-next
To:     yangyingliang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, hulkci@huawei.com, linus.walleij@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Jun 2021 08:31:05 +0200
Message-ID: <1623997865217159@kroah.com>
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
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


