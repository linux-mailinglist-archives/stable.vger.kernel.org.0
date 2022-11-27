Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC13639B4C
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiK0ONh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiK0ONg (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 09:13:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E915F7E
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 06:13:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10EA2B80B04
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 14:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5382EC433D6;
        Sun, 27 Nov 2022 14:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669558412;
        bh=5E3gq9XJSWedQei0B3E/fi++zFxoqa0ggIm1DbOpVeA=;
        h=Subject:To:From:Date:From;
        b=2P+RCwcDzgEd2cP+9HMgDc3W3xNtgf4patC1nvXmRwfSr6o2oq1jdjB1qV41zF4Ix
         alQoj8oRtDCq6TdnEBJzNQ7eI7bl+Ps2Y7bWCdlDKBSV3F8mvopJSPCMldIjjPREqb
         AJX9+UzrdMknSBC0T7YL9bxmEdLmhVzvNpTUMIk0=
Subject: patch "iio: fix memory leak in iio_device_register_eventset()" added to char-misc-next
To:     zengheng4@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 15:06:12 +0100
Message-ID: <166955797225589@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: fix memory leak in iio_device_register_eventset()

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 86fdd15e10e404e70ecb2a3bff24d70356d42b36 Mon Sep 17 00:00:00 2001
From: Zeng Heng <zengheng4@huawei.com>
Date: Tue, 15 Nov 2022 10:37:12 +0800
Subject: iio: fix memory leak in iio_device_register_eventset()

When iio_device_register_sysfs_group() returns failed,
iio_device_register_eventset() needs to free attrs array.

Otherwise, kmemleak would scan & report memory leak as below:

unreferenced object 0xffff88810a1cc3c0 (size 32):
  comm "100-i2c-vcnl302", pid 728, jiffies 4295052307 (age 156.027s)
  backtrace:
    __kmalloc+0x46/0x1b0
    iio_device_register_eventset at drivers/iio/industrialio-event.c:541
    __iio_device_register at drivers/iio/industrialio-core.c:1959
    __devm_iio_device_register at drivers/iio/industrialio-core.c:2040

Fixes: 32f171724e5c ("iio: core: rework iio device group creation")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20221115023712.3726854-1-zengheng4@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/industrialio-event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index 3d78da2531a9..727e2ef66aa4 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -556,7 +556,7 @@ int iio_device_register_eventset(struct iio_dev *indio_dev)
 
 	ret = iio_device_register_sysfs_group(indio_dev, &ev_int->group);
 	if (ret)
-		goto error_free_setup_event_lines;
+		goto error_free_group_attrs;
 
 	ev_int->ioctl_handler.ioctl = iio_event_ioctl;
 	iio_device_ioctl_handler_register(&iio_dev_opaque->indio_dev,
@@ -564,6 +564,8 @@ int iio_device_register_eventset(struct iio_dev *indio_dev)
 
 	return 0;
 
+error_free_group_attrs:
+	kfree(ev_int->group.attrs);
 error_free_setup_event_lines:
 	iio_free_chan_devattr_list(&ev_int->dev_attr_list);
 	kfree(ev_int);
-- 
2.38.1


