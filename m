Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A04246D3CD
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhLHM6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLHM6K (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:58:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E6DC061746
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 04:54:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AB867CE2166
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543FCC00446;
        Wed,  8 Dec 2021 12:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968074;
        bh=2vaOgoYKyF3dZhObMbK1yogNlsQe2SvMOgPImHL12XY=;
        h=Subject:To:From:Date:From;
        b=YAfExH+oT+7Yt0fgy2NKm/7UJk2Hdjz8fLX36hL4KUrrlB13vW3FyQzMjxVo0FIzc
         x32ecr0xQ7A4R06F94uys9sKBwXbztC+u0csl9FvAWdlRhYTLF6tKkxK++bqyJfzoi
         EVTpmdj3sVan2wHmY5lQe/joNan9ytavCJ+Qza9Y=
Subject: patch "iio: ad7768-1: Call iio_trigger_notify_done() on error" added to char-misc-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:57 +0100
Message-ID: <163896803716973@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ad7768-1: Call iio_trigger_notify_done() on error

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6661146427cbbce6d1fe3dbb11ff1c487f55799a Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Mon, 1 Nov 2021 15:40:55 +0100
Subject: iio: ad7768-1: Call iio_trigger_notify_done() on error

IIO trigger handlers must call iio_trigger_notify_done() when done. This
must be done even when an error occurred. Otherwise the trigger will be
seen as busy indefinitely and the trigger handler will never be called
again.

The ad7768-1 driver neglects to call iio_trigger_notify_done() when there
is an error reading the converter data. Fix this by making sure that
iio_trigger_notify_done() is included in the error exit path.

Fixes: a5f8c7da3dbe ("iio: adc: Add AD7768-1 ADC basic support")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211101144055.13858-2-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ad7768-1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 2c5c8a3672b2..aa42ba759fa1 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -480,8 +480,8 @@ static irqreturn_t ad7768_trigger_handler(int irq, void *p)
 	iio_push_to_buffers_with_timestamp(indio_dev, &st->data.scan,
 					   iio_get_time_ns(indio_dev));
 
-	iio_trigger_notify_done(indio_dev->trig);
 err_unlock:
+	iio_trigger_notify_done(indio_dev->trig);
 	mutex_unlock(&st->lock);
 
 	return IRQ_HANDLED;
-- 
2.34.1


