Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95E446D3C2
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhLHM5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:57:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47844 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbhLHM5d (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:57:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C3E6CE2163
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AF0C00446;
        Wed,  8 Dec 2021 12:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968037;
        bh=6KsItswNp/Q5Zv8ysgDDb0pKQwv59tphs91Lig/HUAw=;
        h=Subject:To:From:Date:From;
        b=asWQfqM3uuu2QJgaV0YtZTZuMX3uB1VrJadsYUv94C8r1sTtd6F7XrQEo8hfzqndK
         vNhyExE3EJBgORhrXEDxiASx8sHZ2Otp8J91+23OBhJ5kVzRBfkkO6T3+TzQ46W8rg
         0+dc09srfjNniI2kfZBrEgL1VxtSlIzrB6sOMG/4=
Subject: patch "iio: ltr501: Don't return error code in trigger handler" added to char-misc-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:51 +0100
Message-ID: <163896803117495@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ltr501: Don't return error code in trigger handler

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ef9d67fa72c1b149a420587e435a3e888bdbf74f Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Sun, 24 Oct 2021 19:12:49 +0200
Subject: iio: ltr501: Don't return error code in trigger handler

IIO trigger handlers need to return one of the irqreturn_t values.
Returning an error code is not supported.

The ltr501 interrupt handler gets this right for most error paths, but
there is one case where it returns the error code.

In addition for this particular case the trigger handler does not call
`iio_trigger_notify_done()`. Which when not done keeps the triggered
disabled forever.

Modify the code so that the function returns a valid irqreturn_t value as
well as calling `iio_trigger_notify_done()` on all exit paths.

Fixes: 2690be905123 ("iio: Add Lite-On ltr501 ambient light / proximity sensor driver")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211024171251.22896-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/ltr501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 7e51aaac0bf8..b2983b1a9ed1 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1275,7 +1275,7 @@ static irqreturn_t ltr501_trigger_handler(int irq, void *p)
 		ret = regmap_bulk_read(data->regmap, LTR501_ALS_DATA1,
 				       als_buf, sizeof(als_buf));
 		if (ret < 0)
-			return ret;
+			goto done;
 		if (test_bit(0, indio_dev->active_scan_mask))
 			scan.channels[j++] = le16_to_cpu(als_buf[1]);
 		if (test_bit(1, indio_dev->active_scan_mask))
-- 
2.34.1


