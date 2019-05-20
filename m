Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA45B22CC4
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 09:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfETHQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 03:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbfETHQt (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 May 2019 03:16:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 312CB2081C;
        Mon, 20 May 2019 07:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558336608;
        bh=5X3u9gPiFcRX2N4qlq6sSIrP47BOGxF4x5wZ17Zdxrs=;
        h=Subject:To:From:Date:From;
        b=a18XJiv5yL1WubsZ/cMCkdRCaliOKyW2C374b6eJpt2aXE4ACJ5rI9rKvVdkmVV4F
         T+5a+SHNjXg0hcOmsAE0/mROxq/6i4dMckXC76UE8GiY2XTlqgOGmXDHaKtSOlayNL
         Qs48fT7aC3kulfncm+umWF5pglZYxaC4jOiAE5ZY=
Subject: patch "iio: adc: ti-ads8688: fix timestamp is not updated in buffer" added to staging-linus
To:     sean@geanix.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 09:16:34 +0200
Message-ID: <155833659436@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: ti-ads8688: fix timestamp is not updated in buffer

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e6d12298310fa1dc11f1d747e05b168016057fdd Mon Sep 17 00:00:00 2001
From: Sean Nyekjaer <sean@geanix.com>
Date: Tue, 7 May 2019 10:23:04 +0200
Subject: iio: adc: ti-ads8688: fix timestamp is not updated in buffer

When using the hrtimer iio trigger timestamp isn't updated.
If we use iio_get_time_ns it is updated correctly.

Fixes: 2a86487786b5c ("iio: adc: ti-ads8688: add trigger and buffer support")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ti-ads8688.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads8688.c b/drivers/iio/adc/ti-ads8688.c
index 8b4568edd5cb..7f16c77b99fb 100644
--- a/drivers/iio/adc/ti-ads8688.c
+++ b/drivers/iio/adc/ti-ads8688.c
@@ -397,7 +397,7 @@ static irqreturn_t ads8688_trigger_handler(int irq, void *p)
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev, buffer,
-			pf->timestamp);
+			iio_get_time_ns(indio_dev));
 
 	iio_trigger_notify_done(indio_dev->trig);
 
-- 
2.21.0


