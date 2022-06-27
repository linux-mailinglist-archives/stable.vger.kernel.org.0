Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B955C756
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbiF0JMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 05:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbiF0JMU (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 27 Jun 2022 05:12:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FBD2667
        for <Stable@vger.kernel.org>; Mon, 27 Jun 2022 02:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71B0B611D4
        for <Stable@vger.kernel.org>; Mon, 27 Jun 2022 09:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1AAC3411D;
        Mon, 27 Jun 2022 09:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656321138;
        bh=v0AhbztpEXLAKiwCp1B8y7gEXW5euvbNlxlm5YEY+sc=;
        h=Subject:To:Cc:From:Date:From;
        b=uC4S5aUSzqI82SUPlCB+y3MMMno1NJXNhP5XV33/5mCiNNZOGqCEkxdaAJnx8sv9r
         nr0PvA6h0wxBby3eT4cJ/AmT2kHuEPeNTQbSfFBKC4vE5wVS2p9HRghw5cE+AHXTJE
         h5l6hAy1xeOQ38rratNmrtVhaErxeK5DVZvZzWt8=
Subject: FAILED: patch "[PATCH] iio:accel:kxcjk-1013: rearrange iio trigger get and register" failed to apply to 4.9-stable tree
To:     DDRokosov@sberdevices.ru, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, andy.shevchenko@gmail.com,
        ddrokosov@sberdevices.ru
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 11:12:02 +0200
Message-ID: <1656321122208121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ed302925d708f2f97ae5e9fd6c56c16bb34f6629 Mon Sep 17 00:00:00 2001
From: Dmitry Rokosov <DDRokosov@sberdevices.ru>
Date: Tue, 24 May 2022 18:14:42 +0000
Subject: [PATCH] iio:accel:kxcjk-1013: rearrange iio trigger get and register

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

