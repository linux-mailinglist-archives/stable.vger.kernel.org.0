Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D836B5511DB
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 09:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239567AbiFTHv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 03:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239570AbiFTHv2 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 20 Jun 2022 03:51:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E55101EA
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 00:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1105B80E81
        for <Stable@vger.kernel.org>; Mon, 20 Jun 2022 07:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52547C3411B;
        Mon, 20 Jun 2022 07:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655711485;
        bh=IqgeVu2LUzppkWBmAQDurJN02eHRV9EAJLWiiUYfpTM=;
        h=Subject:To:From:Date:From;
        b=lh8b56/Cqw19024Viv9/DH3khIqihWGBLUN+NRsStOmiWOo26DtI8JXl14omvLZ8H
         0eGstiExY0IhVKoVpxzkL1gt2hzV9Ub9+sFZC1OGc9PhM4AMzNGt1pu3/fo/+XLbz0
         fE0LmYWDKeDyby+jl4kxOOrHS4V9p6J57X1h241U=
Subject: patch "iio:accel:mxc4005: rearrange iio trigger get and register" added to char-misc-linus
To:     DDRokosov@sberdevices.ru, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        ddrokosov@sberdevices.ru
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jun 2022 09:50:45 +0200
Message-ID: <165571144593192@kroah.com>
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

    iio:accel:mxc4005: rearrange iio trigger get and register

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9354c224c9b4f55847a0de3e968cba2ebf15af3b Mon Sep 17 00:00:00 2001
From: Dmitry Rokosov <DDRokosov@sberdevices.ru>
Date: Tue, 24 May 2022 18:14:43 +0000
Subject: iio:accel:mxc4005: rearrange iio trigger get and register

IIO trigger interface function iio_trigger_get() should be called after
iio_trigger_register() (or its devm analogue) strictly, because of
iio_trigger_get() acquires module refcnt based on the trigger->owner
pointer, which is initialized inside iio_trigger_register() to
THIS_MODULE.
If this call order is wrong, the next iio_trigger_put() (from sysfs
callback or "delete module" path) will dereference "default" module
refcnt, which is incorrect behaviour.

Fixes: 47196620c82f ("iio: mxc4005: add data ready trigger for mxc4005")
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20220524181150.9240-4-ddrokosov@sberdevices.ru
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/mxc4005.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/mxc4005.c b/drivers/iio/accel/mxc4005.c
index b3afbf064915..df600d2917c0 100644
--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -456,8 +456,6 @@ static int mxc4005_probe(struct i2c_client *client,
 
 		data->dready_trig->ops = &mxc4005_trigger_ops;
 		iio_trigger_set_drvdata(data->dready_trig, indio_dev);
-		indio_dev->trig = data->dready_trig;
-		iio_trigger_get(indio_dev->trig);
 		ret = devm_iio_trigger_register(&client->dev,
 						data->dready_trig);
 		if (ret) {
@@ -465,6 +463,8 @@ static int mxc4005_probe(struct i2c_client *client,
 				"failed to register trigger\n");
 			return ret;
 		}
+
+		indio_dev->trig = iio_trigger_get(data->dready_trig);
 	}
 
 	return devm_iio_device_register(&client->dev, indio_dev);
-- 
2.36.1


