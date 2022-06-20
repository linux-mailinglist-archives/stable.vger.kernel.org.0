Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04F35511D4
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239571AbiFTHvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239570AbiFTHvc (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:51:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D26101EA
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 055F5B80E19
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58075C3411B;
        Mon, 20 Jun 2022 07:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711488;
        bh=cfYNRicHZR5yLMLd170yd2p7zbdkkN7cnD+4nlDfrCc=;
        h=Subject:To:From:Date:From;
        b=lpIwOG5FLynmOmWHqsVQCID6zk8VGhaWMZ7qPK+qDLlVD8RkIjuuqpWcDglkctc4h
         SkM6/i3zQJj0rkLnoK1n5dksHukVY1kn3O3FMFu68syzY6r/CEOOtDIFIGX5GwWX54
         RPVDDiPJpVTPuD5cPjhtw7gNyC6mpIGHBxywsF+s=
Subject: patch "iio:accel:kxcjk-1013: rearrange iio trigger get and register" added to char-misc-linus
To:     DDRokosov@sberdevices.ru, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        ddrokosov@sberdevices.ru
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:45 +0200
Message-ID: <165571144511145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio:accel:kxcjk-1013: rearrange iio trigger get and register

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ed302925d708f2f97ae5e9fd6c56c16bb34f6629 Mon Sep 17 00:00:00 2001
From: Dmitry Rokosov <DDRokosov@sberdevices.ru>
Date: Tue, 24 May 2022 18:14:42 +0000
Subject: iio:accel:kxcjk-1013: rearrange iio trigger get and register

IIO trigger interface function iio_trigger_get() should be called after
iio_trigger_register() (or its devm analogue) strictly, because of
iio_trigger_get() acquires module refcnt based on the trigger->owner
pointer, which is initialized inside iio_trigger_register() to
THIS_MODULE.
If this call order is wrong, the next iio_trigger_put() (from sysfs
callback or "delete module" path) will dereference "default" module
refcnt, which is incorrect behaviour.

Fixes: c1288b833881 ("iio: accel: kxcjk-1013: Increment ref counter for indio_dev->trig")
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220524181150.9240-3-ddrokosov@sberdevices.ru
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/kxcjk-1013.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index ac74cdcd2bc8..748b35c2f0c3 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1554,12 +1554,12 @@ static int kxcjk1013_probe(struct i2c_client *client,
 
 		data->dready_trig->ops = &kxcjk1013_trigger_ops;
 		iio_trigger_set_drvdata(data->dready_trig, indio_dev);
-		indio_dev->trig = data->dready_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = iio_trigger_register(data->dready_trig);
 		if (ret)
 			goto err_poweroff;
 
+		indio_dev->trig = iio_trigger_get(data->dready_trig);
+
 		data->motion_trig->ops = &kxcjk1013_trigger_ops;
 		iio_trigger_set_drvdata(data->motion_trig, indio_dev);
 		ret = iio_trigger_register(data->motion_trig);
-- 
2.36.1


