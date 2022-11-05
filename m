Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B7D61D964
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 11:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiKEKdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 06:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEKdD (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sat, 5 Nov 2022 06:33:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A38822B
        for <Stable@vger.kernel.org>; Sat,  5 Nov 2022 03:33:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11E9D60AC7
        for <Stable@vger.kernel.org>; Sat,  5 Nov 2022 10:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A97C433C1;
        Sat,  5 Nov 2022 10:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667644381;
        bh=dnRDOi7SqCcMzCtiYhuzg2cc1G0d3WHhTHHQva705sg=;
        h=Subject:To:From:Date:From;
        b=DtLcPl2p+z0TqW+UMX6QDLls5PT01WZF6jzsPeTrGgvK2P5cujKB+VBST+MQc+umU
         3LP579PPM5iOnMhpVBDSSx3779marm1yA1Q4P1j4+FVFXTVathxE1iMbzmc/5Tmjgr
         LSUeZQcmCVFj7JKT5XR2IHF2E+A0xkF2OqztC4h8=
Subject: patch "iio: trigger: sysfs: fix possible memory leak in" added to char-misc-linus
To:     yangyingliang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Nov 2022 11:32:58 +0100
Message-ID: <1667644378169112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: trigger: sysfs: fix possible memory leak in

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From efa17e90e1711bdb084e3954fa44afb6647331c0 Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Sat, 22 Oct 2022 15:42:12 +0800
Subject: iio: trigger: sysfs: fix possible memory leak in
 iio_sysfs_trig_init()

dev_set_name() allocates memory for name, it need be freed
when device_add() fails, call put_device() to give up the
reference that hold in device_initialize(), so that it can
be freed in kobject_cleanup() when the refcount hit to 0.

Fault injection test can trigger this:

unreferenced object 0xffff8e8340a7b4c0 (size 32):
  comm "modprobe", pid 243, jiffies 4294678145 (age 48.845s)
  hex dump (first 32 bytes):
    69 69 6f 5f 73 79 73 66 73 5f 74 72 69 67 67 65  iio_sysfs_trigge
    72 00 a7 40 83 8e ff ff 00 86 13 c4 f6 ee ff ff  r..@............
  backtrace:
    [<0000000074999de8>] __kmem_cache_alloc_node+0x1e9/0x360
    [<00000000497fd30b>] __kmalloc_node_track_caller+0x44/0x1a0
    [<000000003636c520>] kstrdup+0x2d/0x60
    [<0000000032f84da2>] kobject_set_name_vargs+0x1e/0x90
    [<0000000092efe493>] dev_set_name+0x4e/0x70

Fixes: 1f785681a870 ("staging:iio:trigger sysfs userspace trigger rework.")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221022074212.1386424-1-yangyingliang@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/trigger/iio-trig-sysfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/trigger/iio-trig-sysfs.c b/drivers/iio/trigger/iio-trig-sysfs.c
index d6c5e9644738..6b05eed41612 100644
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -203,9 +203,13 @@ static int iio_sysfs_trigger_remove(int id)
 
 static int __init iio_sysfs_trig_init(void)
 {
+	int ret;
 	device_initialize(&iio_sysfs_trig_dev);
 	dev_set_name(&iio_sysfs_trig_dev, "iio_sysfs_trigger");
-	return device_add(&iio_sysfs_trig_dev);
+	ret = device_add(&iio_sysfs_trig_dev);
+	if (ret)
+		put_device(&iio_sysfs_trig_dev);
+	return ret;
 }
 module_init(iio_sysfs_trig_init);
 
-- 
2.38.1


