Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21EC609495
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 18:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiJWQG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 12:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiJWQG2 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 23 Oct 2022 12:06:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4035BC93
        for <Stable@vger.kernel.org>; Sun, 23 Oct 2022 09:06:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1DAB80D5C
        for <Stable@vger.kernel.org>; Sun, 23 Oct 2022 16:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124C5C433C1;
        Sun, 23 Oct 2022 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666541185;
        bh=rWhPI3hXdeBrBw5Aye/dRh/hY91hkqiMsxqt52YMdAU=;
        h=Subject:To:From:Date:From;
        b=uWLbj3Ha66lEoKil67ycEfReF4/a07Pd/P7CHnJEM8eW14zxndrj36j6rK5r6GTp2
         REdXFMkZqcm2HlgvRrpHgteek23SJ55s3lLmkpQp8fxXGJTrdD/JB16+r+AJ1vJF7k
         SHu+FGjUFgm9kHK/UUho+fzj0ygV2XFl5YU8hZ3Q=
Subject: patch "iio: light: tsl2583: Fix module unloading" added to char-misc-linus
To:     shreeya.patel@collabora.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Oct 2022 18:06:22 +0200
Message-ID: <166654118299119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: tsl2583: Fix module unloading

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0dec4d2f2636b9e54d9d29f17afc7687c5407f78 Mon Sep 17 00:00:00 2001
From: Shreeya Patel <shreeya.patel@collabora.com>
Date: Fri, 26 Aug 2022 17:53:52 +0530
Subject: iio: light: tsl2583: Fix module unloading

tsl2583 probe() uses devm_iio_device_register() and calling
iio_device_unregister() causes the unregister to occur twice. s
Switch to iio_device_register() instead of devm_iio_device_register()
in probe to avoid the device managed cleanup.

Fixes: 371894f5d1a0 ("iio: tsl2583: add runtime power management support")
Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
Link: https://lore.kernel.org/r/20220826122352.288438-1-shreeya.patel@collabora.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/tsl2583.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/tsl2583.c b/drivers/iio/light/tsl2583.c
index 0a2ca1a8146d..7bcb5c718922 100644
--- a/drivers/iio/light/tsl2583.c
+++ b/drivers/iio/light/tsl2583.c
@@ -858,7 +858,7 @@ static int tsl2583_probe(struct i2c_client *clientp,
 					 TSL2583_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&clientp->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret) {
 		dev_err(&clientp->dev, "%s: iio registration failed\n",
 			__func__);
-- 
2.38.1


