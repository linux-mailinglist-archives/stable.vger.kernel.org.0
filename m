Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CA96CBDC3
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 13:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjC1LcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 07:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbjC1LcE (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 28 Mar 2023 07:32:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7180586AC
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 04:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1245FB81C13
        for <Stable@vger.kernel.org>; Tue, 28 Mar 2023 11:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B012C433D2;
        Tue, 28 Mar 2023 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680003104;
        bh=pzV7KHZbUadOaD+1jRKbtz1L3mxs678IJ/2ExcqzM6s=;
        h=Subject:To:From:Date:From;
        b=UvkJDWjgGxZXQ6FFoCl1fynIdfqhpHkS9ehsjhJZNDEWEI0+m7ECcwfEN96JiJwA2
         XP77yHRfkZ0PlLT7kFHlqykUNDLodBUOdQEbDiBp/ri3N4HeJfbEwDDmuh4DiuFYLZ
         Cnwm7UGq15TjJ5z6Hb5XjPI7CnHWltgw4cuOJMsU=
Subject: patch "iio: accel: kionix-kx022a: Get the timestamp from the driver's" added to char-misc-linus
To:     mehdi.djait.k@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, mazziesaccount@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 13:31:28 +0200
Message-ID: <168000308810511@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: kionix-kx022a: Get the timestamp from the driver's

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 03fada47311a3e668f73efc9278c4a559e64ee85 Mon Sep 17 00:00:00 2001
From: Mehdi Djait <mehdi.djait.k@gmail.com>
Date: Sat, 18 Feb 2023 14:51:11 +0100
Subject: iio: accel: kionix-kx022a: Get the timestamp from the driver's
 private data in the trigger_handler

The trigger_handler gets called from the IRQ thread handler using
iio_trigger_poll_chained() which will only call the bottom half of the
pollfunc and therefore pf->timestamp will not get set.

Use instead the timestamp from the driver's private data which is always
set in the IRQ handler.

Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Link: https://lore.kernel.org/linux-iio/Y+6QoBLh1k82cJVN@carbian/
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Mehdi Djait <mehdi.djait.k@gmail.com>
Link: https://lore.kernel.org/r/20230218135111.90061-1-mehdi.djait.k@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/kionix-kx022a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/kionix-kx022a.c b/drivers/iio/accel/kionix-kx022a.c
index f866859855cd..1c3a72380fb8 100644
--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -864,7 +864,7 @@ static irqreturn_t kx022a_trigger_handler(int irq, void *p)
 	if (ret < 0)
 		goto err_read;
 
-	iio_push_to_buffers_with_timestamp(idev, data->buffer, pf->timestamp);
+	iio_push_to_buffers_with_timestamp(idev, data->buffer, data->timestamp);
 err_read:
 	iio_trigger_notify_done(idev->trig);
 
-- 
2.40.0


