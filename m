Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B65E2F7396
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 08:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbhAOHR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 02:17:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbhAOHR5 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Fri, 15 Jan 2021 02:17:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 563D322D50;
        Fri, 15 Jan 2021 07:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610695036;
        bh=W8At8HNlAZuRHW3gFruRfCv+lq3ED6/u7dzKGYXboUQ=;
        h=Subject:To:From:Date:From;
        b=IiNa8IJMCpPBH9ahdTX8soWu2+L5OVo1fWOGRMdHK54XJToFPEOV0LjraTpHQ3UMX
         gAlYIskFWx+qgXRTrMqyVJVuUKanTMeMUUvAwcFqmG9xelOei8ScRRfhrkZd4USPTq
         GLRT5n8/FtFpZo9rl6DhmbjmXj4mLQMFxpvJnHNY=
Subject: patch "iio: ad5504: Fix setting power-down state" added to staging-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, alexandru.ardelean@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 08:17:06 +0100
Message-ID: <1610695026164231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ad5504: Fix setting power-down state

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From efd597b2839a9895e8a98fcb0b76d2f545802cd4 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Wed, 9 Dec 2020 11:46:49 +0100
Subject: iio: ad5504: Fix setting power-down state

The power-down mask of the ad5504 is actually a power-up mask. Meaning if
a bit is set the corresponding channel is powered up and if it is not set
the channel is powered down.

The driver currently has this the wrong way around, resulting in the
channel being powered up when requested to be powered down and vice versa.

Fixes: 3bbbf150ffde ("staging:iio:dac:ad5504: Use strtobool for boolean values")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20201209104649.5794-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/dac/ad5504.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/ad5504.c b/drivers/iio/dac/ad5504.c
index 28921b62e642..e9297c25d4ef 100644
--- a/drivers/iio/dac/ad5504.c
+++ b/drivers/iio/dac/ad5504.c
@@ -187,9 +187,9 @@ static ssize_t ad5504_write_dac_powerdown(struct iio_dev *indio_dev,
 		return ret;
 
 	if (pwr_down)
-		st->pwr_down_mask |= (1 << chan->channel);
-	else
 		st->pwr_down_mask &= ~(1 << chan->channel);
+	else
+		st->pwr_down_mask |= (1 << chan->channel);
 
 	ret = ad5504_spi_write(st, AD5504_ADDR_CTRL,
 				AD5504_DAC_PWRDWN_MODE(st->pwr_down_mode) |
-- 
2.30.0


