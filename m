Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B120663A6E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 09:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjAJIFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 03:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjAJIF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 03:05:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26ECBB3
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 00:05:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B4E1B810FE
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5BEC433D2;
        Tue, 10 Jan 2023 08:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673337922;
        bh=1F1DaYjNHbN9DktUHbsnhxrk9lw2flqLCG6fOtibMoM=;
        h=Subject:To:Cc:From:Date:From;
        b=e48WGMVfLOUmkkV/nNSkdPLcuNJwlkGdWORN4Muojo3Fy3kzf+73K+Cu4SHZl7KGs
         5ALjPEr/ipgHY8+m+3iJB7qRLo67sqf4imHQttqVMxdgGAPeUKt6izgw1+2VKixVaC
         ZuhO4cc3z7nkp4T+SzP7o8iX8Gbylnop3d0soOXw=
Subject: FAILED: patch "[PATCH] btrfs: handle case when repair happens with dev-replace" failed to apply to 6.0-stable tree
To:     wqu@suse.com, dsterba@suse.com, nospam@kota.moe
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Jan 2023 09:05:10 +0100
Message-ID: <167333791078177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d73a27b86fc7 ("btrfs: handle case when repair happens with dev-replace")
bacf60e51586 ("btrfs: move repair_io_failure to bio.c")
103c19723c80 ("btrfs: split the bio submission path into a separate file")
cb3e217bdb39 ("btrfs: use btrfs_dev_name() helper to handle missing devices better")
947a629988f1 ("btrfs: move tree block parentness check into validate_extent_buffer()")
789d6a3a876e ("btrfs: concentrate all tree block parentness check parameters into one structure")
ab2072b2921e ("btrfs: change how submit bio callback is passed to btrfs_wq_submit_bio")
7920b773bd8a ("btrfs: drop parameter compression_type from btrfs_submit_dio_repair_bio")
19af6a7d345a ("btrfs: change how repair action is passed to btrfs_repair_one_sector")
a2c8d27e5ee8 ("btrfs: use a structure to pass arguments to backref walking functions")
6ce6ba534418 ("btrfs: use a single argument for extent offset in backref walking functions")
22a3c0ac8ed0 ("btrfs: send: avoid unnecessary backref lookups when finding clone source")
aa5d3003ddee ("btrfs: move orphan prototypes into orphan.h")
7f0add250f82 ("btrfs: move super_block specific helpers into super.h")
c03b22076bd2 ("btrfs: move super prototypes into super.h")
5c11adcc383a ("btrfs: move verity prototypes into verity.h")
77407dc032e2 ("btrfs: move dev-replace prototypes into dev-replace.h")
2fc6822c99d7 ("btrfs: move scrub prototypes into scrub.h")
677074792a1d ("btrfs: move relocation prototypes into relocation.h")
33cf97a7b658 ("btrfs: move acl prototypes into acl.h")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d73a27b86fc722c28a26ec64002e3a7dc86d1c07 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Sun, 1 Jan 2023 09:02:21 +0800
Subject: [PATCH] btrfs: handle case when repair happens with dev-replace
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[BUG]
There is a bug report that a BUG_ON() in btrfs_repair_io_failure()
(originally repair_io_failure() in v6.0 kernel) got triggered when
replacing a unreliable disk:

  BTRFS warning (device sda1): csum failed root 257 ino 2397453 off 39624704 csum 0xb0d18c75 expected csum 0x4dae9c5e mirror 3
  kernel BUG at fs/btrfs/extent_io.c:2380!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 9 PID: 3614331 Comm: kworker/u257:2 Tainted: G           OE      6.0.0-5-amd64 #1  Debian 6.0.10-2
  Hardware name: Micro-Star International Co., Ltd. MS-7C60/TRX40 PRO WIFI (MS-7C60), BIOS 2.70 07/01/2021
  Workqueue: btrfs-endio btrfs_end_bio_work [btrfs]
  RIP: 0010:repair_io_failure+0x24a/0x260 [btrfs]
  Call Trace:
   <TASK>
   clean_io_failure+0x14d/0x180 [btrfs]
   end_bio_extent_readpage+0x412/0x6e0 [btrfs]
   ? __switch_to+0x106/0x420
   process_one_work+0x1c7/0x380
   worker_thread+0x4d/0x380
   ? rescuer_thread+0x3a0/0x3a0
   kthread+0xe9/0x110
   ? kthread_complete_and_exit+0x20/0x20
   ret_from_fork+0x22/0x30

[CAUSE]

Before the BUG_ON(), we got some read errors from the replace target
first, note the mirror number (3, which is beyond RAID1 duplication,
thus it's read from the replace target device).

Then at the BUG_ON() location, we are trying to writeback the repaired
sectors back the failed device.

The check looks like this:

		ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, logical,
				      &map_length, &bioc, mirror_num);
		if (ret)
			goto out_counter_dec;
		BUG_ON(mirror_num != bioc->mirror_num);

But inside btrfs_map_block(), we can modify bioc->mirror_num especially
for dev-replace:

	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
	    !need_full_stripe(op) && dev_replace->tgtdev != NULL) {
		ret = get_extra_mirror_from_replace(fs_info, logical, *length,
						    dev_replace->srcdev->devid,
						    &mirror_num,
					    &physical_to_patch_in_first_stripe);
		patch_the_first_stripe_for_dev_replace = 1;
	}

Thus if we're repairing the replace target device, we're going to
trigger that BUG_ON().

But in reality, the read failure from the replace target device may be
that, our replace hasn't reached the range we're reading, thus we're
reading garbage, but with replace running, the range would be properly
filled later.

Thus in that case, we don't need to do anything but let the replace
routine to handle it.

[FIX]
Instead of a BUG_ON(), just skip the repair if we're repairing the
device replace target device.

Reported-by: 小太 <nospam@kota.moe>
Link: https://lore.kernel.org/linux-btrfs/CACsxjPYyJGQZ+yvjzxA1Nn2LuqkYqTCcUH43S=+wXhyf8S00Ag@mail.gmail.com/
CC: stable@vger.kernel.org # 6.0+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index b8fb7ef6b520..8affc88b0e0a 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -329,7 +329,16 @@ int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 				      &map_length, &bioc, mirror_num);
 		if (ret)
 			goto out_counter_dec;
-		BUG_ON(mirror_num != bioc->mirror_num);
+		/*
+		 * This happens when dev-replace is also running, and the
+		 * mirror_num indicates the dev-replace target.
+		 *
+		 * In this case, we don't need to do anything, as the read
+		 * error just means the replace progress hasn't reached our
+		 * read range, and later replace routine would handle it well.
+		 */
+		if (mirror_num != bioc->mirror_num)
+			goto out_counter_dec;
 	}
 
 	sector = bioc->stripes[bioc->mirror_num - 1].physical >> 9;

