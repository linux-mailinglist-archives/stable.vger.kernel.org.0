Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F118A89F
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 22:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfHLUsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 16:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbfHLUsn (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 12 Aug 2019 16:48:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD40720684;
        Mon, 12 Aug 2019 20:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565642922;
        bh=YbirVaVYrd59KNcjW116Oa7bxc83FMhjV/byQmHfmXE=;
        h=Subject:To:From:Date:From;
        b=dLpcsJcPMthQNzhyptKgwk+TobnuV5bMgUyELk5yRaLlh5hBD+a37L2eWSqFSW9O+
         8NDmCg4oq/YUozDjZK7rXJAE0lZZjxxMgH6Mr6JE7Vwo1iW8lf6Xr5QLHYzNX5XFuj
         Xq+gO5rZsmNUrmnmDwNHhoEf/xPPGEY1mmxCm6B4=
Subject: patch "iio: adc: max9611: Fix temperature reading in probe" added to staging-linus
To:     jacopo+renesas@jmondi.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 12 Aug 2019 22:48:32 +0200
Message-ID: <156564291279229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: max9611: Fix temperature reading in probe

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b9ddd5091160793ee9fac10da765cf3f53d2aaf0 Mon Sep 17 00:00:00 2001
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
Date: Mon, 5 Aug 2019 17:55:15 +0200
Subject: iio: adc: max9611: Fix temperature reading in probe

The max9611 driver reads the die temperature at probe time to validate
the communication channel. Use the actual read value to perform the test
instead of the read function return value, which was mistakenly used so
far.

The temperature reading test was only successful because the 0 return
value is in the range of supported temperatures.

Fixes: 69780a3bbc0b ("iio: adc: Add Maxim max9611 ADC driver")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/max9611.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/max9611.c b/drivers/iio/adc/max9611.c
index 0e3c6529fc4c..da073d72f649 100644
--- a/drivers/iio/adc/max9611.c
+++ b/drivers/iio/adc/max9611.c
@@ -480,7 +480,7 @@ static int max9611_init(struct max9611_dev *max9611)
 	if (ret)
 		return ret;
 
-	regval = ret & MAX9611_TEMP_MASK;
+	regval &= MAX9611_TEMP_MASK;
 
 	if ((regval > MAX9611_TEMP_MAX_POS &&
 	     regval < MAX9611_TEMP_MIN_NEG) ||
-- 
2.22.0


