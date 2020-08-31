Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCB3257748
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 12:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgHaK0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 06:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHaK0p (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 31 Aug 2020 06:26:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EA302072D;
        Mon, 31 Aug 2020 10:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598869605;
        bh=NJemT7FJDiFkl0oE15OtkoMnAORAK6QydTOsjBJJus8=;
        h=Subject:To:From:Date:From;
        b=Aktkitkbciawbw9JH3cQGigLPmdsxkT+d90UK7zZshxrsCFyBcw2Pa/GBIsAe2x0k
         Wkaweyb2Zb7TdCguCVFy1V6coqo7yjb1+1LJdj3V+9RwiGHpWYJaLHRiAScQDAKDzA
         2J5vMnUVAE9H/OYOuwl0M2D1x0iuBYON1ieH/bnI=
Subject: patch "iio: adc: mcp3422: fix locking scope" added to staging-linus
To:     angelo.compagnucci@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 12:26:27 +0200
Message-ID: <1598869587143166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: mcp3422: fix locking scope

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3f1093d83d7164e4705e4232ccf76da54adfda85 Mon Sep 17 00:00:00 2001
From: Angelo Compagnucci <angelo.compagnucci@gmail.com>
Date: Wed, 19 Aug 2020 09:55:25 +0200
Subject: iio: adc: mcp3422: fix locking scope

Locking should be held for the entire reading sequence involving setting
the channel, waiting for the channel switch and reading from the
channel.
If not, reading from a channel can result mixing with the reading from
another channel.

Fixes: 07914c84ba30 ("iio: adc: Add driver for Microchip MCP3422/3/4 high resolution ADC")
Signed-off-by: Angelo Compagnucci <angelo.compagnucci@gmail.com>
Link: https://lore.kernel.org/r/20200819075525.1395248-1-angelo.compagnucci@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/mcp3422.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/mcp3422.c b/drivers/iio/adc/mcp3422.c
index 5f1706d1c3c0..219adac2384b 100644
--- a/drivers/iio/adc/mcp3422.c
+++ b/drivers/iio/adc/mcp3422.c
@@ -96,16 +96,12 @@ static int mcp3422_update_config(struct mcp3422 *adc, u8 newconfig)
 {
 	int ret;
 
-	mutex_lock(&adc->lock);
-
 	ret = i2c_master_send(adc->i2c, &newconfig, 1);
 	if (ret > 0) {
 		adc->config = newconfig;
 		ret = 0;
 	}
 
-	mutex_unlock(&adc->lock);
-
 	return ret;
 }
 
@@ -138,6 +134,8 @@ static int mcp3422_read_channel(struct mcp3422 *adc,
 	u8 config;
 	u8 req_channel = channel->channel;
 
+	mutex_lock(&adc->lock);
+
 	if (req_channel != MCP3422_CHANNEL(adc->config)) {
 		config = adc->config;
 		config &= ~MCP3422_CHANNEL_MASK;
@@ -150,7 +148,11 @@ static int mcp3422_read_channel(struct mcp3422 *adc,
 		msleep(mcp3422_read_times[MCP3422_SAMPLE_RATE(adc->config)]);
 	}
 
-	return mcp3422_read(adc, value, &config);
+	ret = mcp3422_read(adc, value, &config);
+
+	mutex_unlock(&adc->lock);
+
+	return ret;
 }
 
 static int mcp3422_read_raw(struct iio_dev *iio,
-- 
2.28.0


