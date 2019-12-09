Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E9A116822
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 09:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfLII37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 03:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfLII37 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 9 Dec 2019 03:29:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 323DE2071E;
        Mon,  9 Dec 2019 08:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575880198;
        bh=QuJ5eDnL8kvsBwN6bn7m8vevM0gYJRjpMIG3xkrJe4A=;
        h=Subject:To:From:Date:From;
        b=RAlbw4nZ2XHSFMUKcMCoqTRuxXxV15azPnjBxEcdYkPXisAgDTi7UuvfniIzptJHk
         yGeGrDRbdVi60g+VDoXzrxK3FYPSp1im1xLuGATHui/0vxCIEjFCRFswp2R+7Ydvtb
         IJQaXosqLuAYPCgo5umd3Ztt5TY+0Cz3gOPO6vBY=
Subject: patch "iio: adc: ad7606: fix reading unnecessary data from device" added to staging-linus
To:     beniamin.bia@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, rwoerle@mibtec.de
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Dec 2019 09:29:56 +0100
Message-ID: <1575880196182153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ad7606: fix reading unnecessary data from device

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 341826a065660d1b77d89e6335b6095cd654271c Mon Sep 17 00:00:00 2001
From: Beniamin Bia <beniamin.bia@analog.com>
Date: Mon, 4 Nov 2019 18:26:34 +0200
Subject: iio: adc: ad7606: fix reading unnecessary data from device
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a conversion result is being read from ADC, the driver reads the
number of channels + 1 because it thinks that IIO_CHAN_SOFT_TIMESTAMP
is also a physical channel. This patch fixes this issue.

Fixes: 2985a5d88455 ("staging: iio: adc: ad7606: Move out of staging")
Reported-by: Robert Wörle <rwoerle@mibtec.de>
Signed-off-by: Beniamin Bia <beniamin.bia@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ad7606.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7606.c b/drivers/iio/adc/ad7606.c
index f5ba94c03a8d..e4683a68522a 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -85,7 +85,7 @@ static int ad7606_reg_access(struct iio_dev *indio_dev,
 
 static int ad7606_read_samples(struct ad7606_state *st)
 {
-	unsigned int num = st->chip_info->num_channels;
+	unsigned int num = st->chip_info->num_channels - 1;
 	u16 *data = st->data;
 	int ret;
 
-- 
2.24.0


