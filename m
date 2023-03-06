Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D046ACB69
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 18:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCFRx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 12:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCFRxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 12:53:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8083D905
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 09:53:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E48B61086
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 17:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3680C433EF;
        Mon,  6 Mar 2023 17:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678125168;
        bh=HCuxSQBfNaY9nH9fmJwqyhDuKk6F9zzesYbwMZ/VcC4=;
        h=Subject:To:Cc:From:Date:From;
        b=iNQINQmFTvcFv2+EVAUN+5a2DgAIQ8l1U6YoSGLu6jsbK2C/gax1algzP88wQxa1m
         TIjyakf7d9eg11tBtsPdHr/W4yJ5TfyxSE43uc159p2P352Ms5nagiTQn5EbviwpIU
         Gn7CE8CkIi+OQCBd5VehZETwyJtir0uScBoD9gAY=
Subject: FAILED: patch "[PATCH] brd: mark as nowait compatible" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 18:50:00 +0100
Message-ID: <167812500026148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 67205f80be9910207481406c47f7d85e703fb2e9
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167812500026148@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

67205f80be99 ("brd: mark as nowait compatible")
e1528830bd4e ("block/brd: add error handling support for add_disk()")
f7bf35862477 ("brd: reduce the brd_devices_mutex scope")
7f9b348cb5e9 ("brd: convert to blk_alloc_disk/blk_cleanup_disk")
f4be591f1436 ("brd: expose number of allocated pages in debugfs")
7cc178a6b994 ("brd: use __register_blkdev to allocate devices on demand")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 67205f80be9910207481406c47f7d85e703fb2e9 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 15 Feb 2023 16:43:47 -0700
Subject: [PATCH] brd: mark as nowait compatible

By default, non-mq drivers do not support nowait. This causes io_uring
to use a slower path as the driver cannot be trust not to block. brd
can safely set the nowait flag, as worst case all it does is a NOIO
allocation.

For io_uring, this makes a substantial difference. Before:

submitter=0, tid=453, file=/dev/ram0, node=-1
polled=0, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=440.03K, BW=1718MiB/s, IOS/call=32/31
IOPS=428.96K, BW=1675MiB/s, IOS/call=32/32
IOPS=442.59K, BW=1728MiB/s, IOS/call=32/31
IOPS=419.65K, BW=1639MiB/s, IOS/call=32/32
IOPS=426.82K, BW=1667MiB/s, IOS/call=32/31

and after:

submitter=0, tid=354, file=/dev/ram0, node=-1
polled=0, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=3.37M, BW=13.15GiB/s, IOS/call=32/31
IOPS=3.45M, BW=13.46GiB/s, IOS/call=32/31
IOPS=3.43M, BW=13.42GiB/s, IOS/call=32/32
IOPS=3.43M, BW=13.39GiB/s, IOS/call=32/31
IOPS=3.43M, BW=13.38GiB/s, IOS/call=32/31

or about an 8x in difference. Now that brd is prepared to deal with
REQ_NOWAIT reads/writes, mark it as supporting that.

Cc: stable@vger.kernel.org # 5.10+
Link: https://lore.kernel.org/linux-block/20230203103005.31290-1-p.raghav@samsung.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 00f3c5b51a01..740631dcdd0e 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -418,6 +418,7 @@ static int brd_alloc(int i)
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
+	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, disk->queue);
 	err = add_disk(disk);
 	if (err)
 		goto out_cleanup_disk;

