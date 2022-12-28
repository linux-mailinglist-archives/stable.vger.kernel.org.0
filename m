Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D32165747B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 10:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbiL1JMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 04:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiL1JMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 04:12:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CA1B1D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 01:12:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F6B261377
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 09:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39522C433D2;
        Wed, 28 Dec 2022 09:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672218757;
        bh=I2a0LZRY7GcYJGEc/4wb2IL1Q2Fn/AeDzBMmBCy9q5o=;
        h=Subject:To:Cc:From:Date:From;
        b=I+6QCJ4R67jG7GvMnXUKEJbSueOE33Oy/T+0biVhsIuwitwvRPtfjljwEzW8q2pcz
         dPm96qEeofhL2it0tUIrTGGRLw4TZ1NBFZqwyYxP/5LNhx+6w3W++3S50601HoC9TR
         hCh3YgLTc9oZnLhLzSBQDGXpdzDecnjtJ3KB/VL0=
Subject: FAILED: patch "[PATCH] loop: Fix the max_loop commandline argument treatment when it" failed to apply to 5.10-stable tree
To:     isaacmanjarres@google.com, axboe@kernel.dk, kenchen@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 10:12:34 +0100
Message-ID: <1672218754169239@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

85c50197716c ("loop: Fix the max_loop commandline argument treatment when it is set to 0")
18d1f200b380 ("loop: move loop_ctl_mutex locking into loop_add")
f9d107644aa4 ("loop: split loop_control_ioctl")
4157fe0b3d16 ("loop: don't call loop_lookup before adding a loop device")
d6da83d072c1 ("loop: remove the l argument to loop_add")
990e78116d38 ("block: loop: fix deadlock between open and remove")
6cc8e7430801 ("loop: scale loop device by introducing per device lock")
aeb2b0b1a3da ("block: drop dead assignments in loop_init()")
8410d38c2552 ("loop: use __register_blkdev to allocate devices on demand")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85c50197716c60fe57f411339c579462e563ac57 Mon Sep 17 00:00:00 2001
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Thu, 8 Dec 2022 13:29:01 -0800
Subject: [PATCH] loop: Fix the max_loop commandline argument treatment when it
 is set to 0

Currently, the max_loop commandline argument can be used to specify how
many loop block devices are created at init time. If it is not
specified on the commandline, CONFIG_BLK_DEV_LOOP_MIN_COUNT loop block
devices will be created.

The max_loop commandline argument can be used to override the value of
CONFIG_BLK_DEV_LOOP_MIN_COUNT. However, when max_loop is set to 0
through the commandline, the current logic treats it as if it had not
been set, and creates CONFIG_BLK_DEV_LOOP_MIN_COUNT devices anyway.

Fix this by starting max_loop off as set to CONFIG_BLK_DEV_LOOP_MIN_COUNT.
This preserves the intended behavior of creating
CONFIG_BLK_DEV_LOOP_MIN_COUNT loop block devices if the max_loop
commandline parameter is not specified, and allowing max_loop to
be respected for all values, including 0.

This allows environments that can create all of their required loop
block devices on demand to not have to unnecessarily preallocate loop
block devices.

Fixes: 732850827450 ("remove artificial software max_loop limit")
Cc: stable@vger.kernel.org
Cc: Ken Chen <kenchen@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Link: https://lore.kernel.org/r/20221208212902.765781-1-isaacmanjarres@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1f8f3b87bdfa..df628e30bca4 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1773,7 +1773,16 @@ static const struct block_device_operations lo_fops = {
 /*
  * And now the modules code and kernel interface.
  */
-static int max_loop;
+
+/*
+ * If max_loop is specified, create that many devices upfront.
+ * This also becomes a hard limit. If max_loop is not specified,
+ * create CONFIG_BLK_DEV_LOOP_MIN_COUNT loop devices at module
+ * init time. Loop devices can be requested on-demand with the
+ * /dev/loop-control interface, or be instantiated by accessing
+ * a 'dead' device node.
+ */
+static int max_loop = CONFIG_BLK_DEV_LOOP_MIN_COUNT;
 module_param(max_loop, int, 0444);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 module_param(max_part, int, 0444);
@@ -2181,7 +2190,7 @@ MODULE_ALIAS("devname:loop-control");
 
 static int __init loop_init(void)
 {
-	int i, nr;
+	int i;
 	int err;
 
 	part_shift = 0;
@@ -2209,19 +2218,6 @@ static int __init loop_init(void)
 		goto err_out;
 	}
 
-	/*
-	 * If max_loop is specified, create that many devices upfront.
-	 * This also becomes a hard limit. If max_loop is not specified,
-	 * create CONFIG_BLK_DEV_LOOP_MIN_COUNT loop devices at module
-	 * init time. Loop devices can be requested on-demand with the
-	 * /dev/loop-control interface, or be instantiated by accessing
-	 * a 'dead' device node.
-	 */
-	if (max_loop)
-		nr = max_loop;
-	else
-		nr = CONFIG_BLK_DEV_LOOP_MIN_COUNT;
-
 	err = misc_register(&loop_misc);
 	if (err < 0)
 		goto err_out;
@@ -2233,7 +2229,7 @@ static int __init loop_init(void)
 	}
 
 	/* pre-create number of devices given by config or max_loop */
-	for (i = 0; i < nr; i++)
+	for (i = 0; i < max_loop; i++)
 		loop_add(i);
 
 	printk(KERN_INFO "loop: module loaded\n");

