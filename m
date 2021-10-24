Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC12D438870
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhJXLLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhJXLLy (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66C4060F45;
        Sun, 24 Oct 2021 11:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635073773;
        bh=5gLOYMiJuuDoqqlj24U3tAM8xZAIbJaFaq31Uzqj0no=;
        h=Subject:To:From:Date:From;
        b=JkFBP2r3r/GolizUQ+D6pUqlBs2SSHVgp3m4RPQ+esjkR/6l5gWEOujVFnddyBYv2
         ujxZjOu8+r6eyzgcW0/1pQjxpfCggScLHsWBRW5mI4kjuR6PiiXbKYnAOuyNL58Phf
         18+mWFoEHT9VWC8jG0UBJyPNo6HZ9opCfDxQfZIQ=
Subject: patch "iio: adc: tsc2046: fix scan interval warning" added to char-misc-testing
To:     o.rempel@pengutronix.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:09:13 +0200
Message-ID: <16350737538131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: tsc2046: fix scan interval warning

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 69b31fd7a61784692db6433c05d46915b1b1a680 Mon Sep 17 00:00:00 2001
From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Thu, 7 Oct 2021 11:30:06 +0200
Subject: iio: adc: tsc2046: fix scan interval warning

Sync if statement with the actual warning.

Fixes: 9504db5765e8 ("iio: adc: tsc2046: fix a warning message in tsc2046_adc_update_scan_mode()")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20211007093007.1466-2-o.rempel@pengutronix.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-tsc2046.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-tsc2046.c b/drivers/iio/adc/ti-tsc2046.c
index 170950d5dd49..d84ae6b008c1 100644
--- a/drivers/iio/adc/ti-tsc2046.c
+++ b/drivers/iio/adc/ti-tsc2046.c
@@ -398,7 +398,7 @@ static int tsc2046_adc_update_scan_mode(struct iio_dev *indio_dev,
 	priv->xfer.len = size;
 	priv->time_per_scan_us = size * 8 * priv->time_per_bit_ns / NSEC_PER_USEC;
 
-	if (priv->scan_interval_us > priv->time_per_scan_us)
+	if (priv->scan_interval_us < priv->time_per_scan_us)
 		dev_warn(&priv->spi->dev, "The scan interval (%d) is less then calculated scan time (%d)\n",
 			 priv->scan_interval_us, priv->time_per_scan_us);
 
-- 
2.33.1


