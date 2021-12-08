Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DACC46D3C3
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhLHM5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:57:36 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47868 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhLHM5f (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:57:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61649CE2163
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EB5C00446;
        Wed,  8 Dec 2021 12:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968040;
        bh=O0Nrs3D0IK00CYDc8HtxU0PfYgNb8Y/qxjzYYE0S9N0=;
        h=Subject:To:From:Date:From;
        b=igRFRwIj5uBIYny8bywJ1URqYN1Sk5Jcrf0/4YPLpbhbzQ2E+OP+a2bDitB3TdVHG
         qxJS+JEycLhD8+dxbolYixN+OfJH6wXN4/X1+0yulTcAT+iyMNY18XuD7CwYqdRWyY
         QMnBdF+FC0F0h3WWURgFimr0MujC9cEaXb7mO/7o=
Subject: patch "iio: stk3310: Don't return error code in interrupt handler" added to char-misc-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:52 +0100
Message-ID: <16389680327812@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: stk3310: Don't return error code in interrupt handler

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8e1eeca5afa7ba84d885987165dbdc5decf15413 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Sun, 24 Oct 2021 19:12:51 +0200
Subject: iio: stk3310: Don't return error code in interrupt handler

Interrupt handlers must return one of the irqreturn_t values. Returning a
error code is not supported.

The stk3310 event interrupt handler returns an error code when reading the
flags register fails.

Fix the implementation to always return an irqreturn_t value.

Fixes: 3dd477acbdd1 ("iio: light: Add threshold interrupt support for STK3310")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211024171251.22896-3-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/stk3310.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/stk3310.c b/drivers/iio/light/stk3310.c
index 07e91846307c..fc63856ed54d 100644
--- a/drivers/iio/light/stk3310.c
+++ b/drivers/iio/light/stk3310.c
@@ -546,9 +546,8 @@ static irqreturn_t stk3310_irq_event_handler(int irq, void *private)
 	mutex_lock(&data->lock);
 	ret = regmap_field_read(data->reg_flag_nf, &dir);
 	if (ret < 0) {
-		dev_err(&data->client->dev, "register read failed\n");
-		mutex_unlock(&data->lock);
-		return ret;
+		dev_err(&data->client->dev, "register read failed: %d\n", ret);
+		goto out;
 	}
 	event = IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY, 1,
 				     IIO_EV_TYPE_THRESH,
@@ -560,6 +559,7 @@ static irqreturn_t stk3310_irq_event_handler(int irq, void *private)
 	ret = regmap_field_write(data->reg_flag_psint, 0);
 	if (ret < 0)
 		dev_err(&data->client->dev, "failed to reset interrupts\n");
+out:
 	mutex_unlock(&data->lock);
 
 	return IRQ_HANDLED;
-- 
2.34.1


