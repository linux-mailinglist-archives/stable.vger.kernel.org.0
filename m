Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44EE3AB994
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 18:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFQQ3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 12:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbhFQQ3Y (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 17 Jun 2021 12:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04417613D5;
        Thu, 17 Jun 2021 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623947235;
        bh=K13GVFYXVxfRqv/wucybG6Sm7agVr5vJa+fKnzznDzc=;
        h=Subject:To:From:Date:From;
        b=rASKzyt3IMUbIk+oC/jAXpTiWkHoO2Urq1el6Meht72O2Hx2Xlvzo/42gwkRPxNHf
         Wk7uPbfyGfHET5A+y3QYwATiF7BxwBQCWqJWiUFcRGIr1uDD356HAU+Tk6pgMUKIbj
         Rs35140EcaFmjaW4zR/z3gb0p3mW1pa5nqBlUaic=
Subject: patch "iio: light: tcs3472: do not free unallocated IRQ" added to staging-testing
To:     frank@zago.net, Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Jun 2021 18:25:06 +0200
Message-ID: <162394710614611@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: tcs3472: do not free unallocated IRQ

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 7cd04c863f9e1655d607705455e7714f24451984 Mon Sep 17 00:00:00 2001
From: frank zago <frank@zago.net>
Date: Mon, 26 Apr 2021 21:20:17 -0500
Subject: iio: light: tcs3472: do not free unallocated IRQ

Allocating an IRQ is conditional to the IRQ existence, but freeing it
was not. If no IRQ was allocate, the driver would still try to free
IRQ 0. Add the missing checks.

This fixes the following trace when the driver is removed:

[  100.667788] Trying to free already-free IRQ 0
[  100.667793] WARNING: CPU: 0 PID: 2315 at kernel/irq/manage.c:1826 free_irq+0x1fd/0x370
...
[  100.667914] Call Trace:
[  100.667920]  tcs3472_remove+0x3a/0x90 [tcs3472]
[  100.667927]  i2c_device_remove+0x2b/0xa0

Signed-off-by: frank zago <frank@zago.net>
Link: https://lore.kernel.org/r/20210427022017.19314-2-frank@zago.net
Fixes: 9d2f715d592e ("iio: light: tcs3472: support out-of-threshold events")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/tcs3472.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/tcs3472.c b/drivers/iio/light/tcs3472.c
index 90dc3fef59e6..371c6a39a165 100644
--- a/drivers/iio/light/tcs3472.c
+++ b/drivers/iio/light/tcs3472.c
@@ -535,7 +535,8 @@ static int tcs3472_probe(struct i2c_client *client,
 	return 0;
 
 free_irq:
-	free_irq(client->irq, indio_dev);
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 	return ret;
@@ -563,7 +564,8 @@ static int tcs3472_remove(struct i2c_client *client)
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
 
 	iio_device_unregister(indio_dev);
-	free_irq(client->irq, indio_dev);
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	tcs3472_powerdown(iio_priv(indio_dev));
 
-- 
2.32.0


