Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4230957DBDA
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 10:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiGVILk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 04:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiGVILj (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 22 Jul 2022 04:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A939CE04
        for <Stable@vger.kernel.org>; Fri, 22 Jul 2022 01:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E1F9B827AA
        for <Stable@vger.kernel.org>; Fri, 22 Jul 2022 08:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D86C341C7;
        Fri, 22 Jul 2022 08:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658477496;
        bh=ub6Ybq+J1HHd+Id/SNV47hyRFcAobu7y/r//CDHf6N4=;
        h=Subject:To:From:Date:From;
        b=Ia/6+1t0hzhVWkI4wZV3bcJaDDXK4c7ufJAa1bZoCPboIAvSfPxWee2R+CITz+/3A
         l3HDF73XdJi34y0phsiwHfa6TvfTwcAYfK9TREat60EGk3uz/Fn1jPrwjbAOt5DIT/
         idLw1Fk3ee7P74aJPjx4iE+8kuX8gtou1o7/y6a4=
Subject: patch "iio: light: isl29028: Fix the warning in isl29028_remove()" added to char-misc-testing
To:     zheyuma97@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 22 Jul 2022 10:03:35 +0200
Message-ID: <165847701594252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: isl29028: Fix the warning in isl29028_remove()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 06674fc7c003b9d0aa1d37fef7ab2c24802cc6ad Mon Sep 17 00:00:00 2001
From: Zheyu Ma <zheyuma97@gmail.com>
Date: Sun, 17 Jul 2022 08:42:41 +0800
Subject: iio: light: isl29028: Fix the warning in isl29028_remove()

The driver use the non-managed form of the register function in
isl29028_remove(). To keep the release order as mirroring the ordering
in probe, the driver should use non-managed form in probe, too.

The following log reveals it:

[   32.374955] isl29028 0-0010: remove
[   32.376861] general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN PTI
[   32.377676] KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
[   32.379432] RIP: 0010:kernfs_find_and_get_ns+0x28/0xe0
[   32.385461] Call Trace:
[   32.385807]  sysfs_unmerge_group+0x59/0x110
[   32.386110]  dpm_sysfs_remove+0x58/0xc0
[   32.386391]  device_del+0x296/0xe50
[   32.386959]  cdev_device_del+0x1d/0xd0
[   32.387231]  devm_iio_device_unreg+0x27/0xb0
[   32.387542]  devres_release_group+0x319/0x3d0
[   32.388162]  i2c_device_remove+0x93/0x1f0

Fixes: 2db5054ac28d ("staging: iio: isl29028: add runtime power management support")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Link: https://lore.kernel.org/r/20220717004241.2281028-1-zheyuma97@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/isl29028.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/isl29028.c b/drivers/iio/light/isl29028.c
index 4dde9707a52d..ff5996d77818 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -625,7 +625,7 @@ static int isl29028_probe(struct i2c_client *client,
 					 ISL29028_POWER_OFF_DELAY_MS);
 	pm_runtime_use_autosuspend(&client->dev);
 
-	ret = devm_iio_device_register(indio_dev->dev.parent, indio_dev);
+	ret = iio_device_register(indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev,
 			"%s(): iio registration failed with error %d\n",
-- 
2.37.1


