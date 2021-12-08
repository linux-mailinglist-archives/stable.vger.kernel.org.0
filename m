Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48B946D3C4
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhLHM5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbhLHM5j (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:57:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2D6C0617A1
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 04:54:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74048CE1FAC
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18302C00446;
        Wed,  8 Dec 2021 12:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968043;
        bh=U98fo+Zl6o5EeMiR5MbcoCU922T/HpCEWe0vmbAhqXw=;
        h=Subject:To:From:Date:From;
        b=qrhbRvNRZBkFMQXOO75yNiw6KdkCIy8cdYz4MZ83B3fhaUdCcefk02CnMGo1jYefW
         TdeTrD1qtolYVxxhNjASeD0iN+E1m/aRERnnbD6bUtu1ga1Eww0GgWdGWg8Amoccji
         7P7d3fw1yfoflPuKXHToOwkqW8hPZoV1GmvKzaSk=
Subject: patch "iio: kxsd9: Don't return error code in trigger handler" added to char-misc-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, linus.walleij@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:52 +0100
Message-ID: <163896803248171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: kxsd9: Don't return error code in trigger handler

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 45febe0d63917ee908198c5be08511c64ee1790a Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Sun, 24 Oct 2021 19:12:50 +0200
Subject: iio: kxsd9: Don't return error code in trigger handler

IIO trigger handlers need to return one of the irqreturn_t values.
Returning an error code is not supported.

The kxsd9 interrupt handler returns an error code if reading the data
registers fails. In addition when exiting due to an error the trigger
handler does not call `iio_trigger_notify_done()`. Which when not done
keeps the triggered disabled forever.

Modify the code so that the function returns a valid irqreturn_t value as
well as calling `iio_trigger_notify_done()` on all exit paths.

Since we can't return the error code make sure to at least log it as part
of the error message.

Fixes: 0427a106a98a ("iio: accel: kxsd9: Add triggered buffer handling")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20211024171251.22896-2-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/kxsd9.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/accel/kxsd9.c b/drivers/iio/accel/kxsd9.c
index 2faf85ca996e..552eba5e8b4f 100644
--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -224,14 +224,14 @@ static irqreturn_t kxsd9_trigger_handler(int irq, void *p)
 			       hw_values.chan,
 			       sizeof(hw_values.chan));
 	if (ret) {
-		dev_err(st->dev,
-			"error reading data\n");
-		return ret;
+		dev_err(st->dev, "error reading data: %d\n", ret);
+		goto out;
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev,
 					   &hw_values,
 					   iio_get_time_ns(indio_dev));
+out:
 	iio_trigger_notify_done(indio_dev->trig);
 
 	return IRQ_HANDLED;
-- 
2.34.1


