Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59FA46D3CA
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhLHM54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhLHM54 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:57:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A18C061746
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 04:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E972B81F7E
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7796C00446;
        Wed,  8 Dec 2021 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968062;
        bh=3j+RAzJEH8PiODHDyPIOdjbusHtCK/uyWFemb4bfOyg=;
        h=Subject:To:From:Date:From;
        b=ljgADuxiBJj3dnqMUPOEsBtYbauIOAd4YwFyUnQt5MZRe27XVEu55RYf3z62FD5sa
         xA8CcVd3HxCnYPNztRhe/VgWJvx16QeUX5GnQn0V8qN3ZIxsP/rKBxwxdHqTBHUcB7
         YFYsgBssxfPC5U/P7WD4fjNcBkuJosYRiD9m0Dts=
Subject: patch "iio: itg3200: Call iio_trigger_notify_done() on error" added to char-misc-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:56 +0100
Message-ID: <163896803648241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: itg3200: Call iio_trigger_notify_done() on error

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 67fe29583e72b2103abb661bb58036e3c1f00277 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Mon, 1 Nov 2021 15:40:54 +0100
Subject: iio: itg3200: Call iio_trigger_notify_done() on error

IIO trigger handlers must call iio_trigger_notify_done() when done. This
must be done even when an error occurred. Otherwise the trigger will be
seen as busy indefinitely and the trigger handler will never be called
again.

The itg3200 driver neglects to call iio_trigger_notify_done() when there is
an error reading the gyro data. Fix this by making sure that
iio_trigger_notify_done() is included in the error exit path.

Fixes: 9dbf091da080 ("iio: gyro: Add itg3200")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211101144055.13858-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/gyro/itg3200_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/gyro/itg3200_buffer.c b/drivers/iio/gyro/itg3200_buffer.c
index 04dd6a7969ea..4cfa0d439560 100644
--- a/drivers/iio/gyro/itg3200_buffer.c
+++ b/drivers/iio/gyro/itg3200_buffer.c
@@ -61,9 +61,9 @@ static irqreturn_t itg3200_trigger_handler(int irq, void *p)
 
 	iio_push_to_buffers_with_timestamp(indio_dev, &scan, pf->timestamp);
 
+error_ret:
 	iio_trigger_notify_done(indio_dev->trig);
 
-error_ret:
 	return IRQ_HANDLED;
 }
 
-- 
2.34.1


