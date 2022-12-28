Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FAB65747C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 10:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiL1JMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 04:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiL1JMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 04:12:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15212C7E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 01:12:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F7EB612E1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 09:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84065C433D2;
        Wed, 28 Dec 2022 09:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672218767;
        bh=57RcLTXp1z2mjIPtAkfsewJkcDGOm/H2JyqTBTkw4lU=;
        h=Subject:To:Cc:From:Date:From;
        b=zT58h5QnahmWipLDRmTGvuIUzVYekBomYp+8tPl3G7tcGQYxH1aAUbadK48JSJfFv
         /IuLKjBl24vv0jDJXz9dIazWqpYPVgLBU4Q24ROgGtXHX6kjSTetW2mjP893teniWi
         Y/BNJCAvpafCgeAqbHoSZpAsKoTZM6B/VlsEB0qY=
Subject: FAILED: patch "[PATCH] loop: Fix the max_loop commandline argument treatment when it" failed to apply to 5.4-stable tree
To:     isaacmanjarres@google.com, axboe@kernel.dk, kenchen@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 10:12:35 +0100
Message-ID: <1672218755176113@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
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
200f93377220 ("loop: be paranoid on exit and prevent new additions / removals")
62ab466ca881 ("loop: Move loop_set_status_from_info() and friends up")
0c3796c24459 ("loop: Factor out configuring loop from status")
b0bd158dd630 ("loop: Refactor loop_set_status() size calculation")
5795b6f5607f ("loop: Factor out setting loop device size")
083a6a50783e ("loop: Remove sector_t truncation checks")
7c5014b0987a ("loop: Call loop_config_discard() only after new config is applied")

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

