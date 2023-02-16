Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E7C699FE4
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 23:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjBPWya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 17:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBPWy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 17:54:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3701D38E96;
        Thu, 16 Feb 2023 14:54:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C252F6101A;
        Thu, 16 Feb 2023 22:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1451DC433EF;
        Thu, 16 Feb 2023 22:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676588067;
        bh=03aSbGRVPlazSxPzRXyCLQlBd82XoK1Rp9jXUc7zvws=;
        h=Date:To:From:Subject:From;
        b=PnLguch7cfSabDxGcYFCBmEvSqe9WKGzokUzwqYuapWNsIlXavy8Z8x3ZDrvKi+OL
         +lNLU1IPM26GqiJJz2x8PxYz6WAkWWZm1zCrNLlxEE0oVVM88hY/YpecZowW65YpSy
         NX4Mh1AduesVVgz0P8BZFf3S8TQEh07Ijk8Xn/So=
Date:   Thu, 16 Feb 2023 14:54:26 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+f0c4082ce5ebebdac63b@syzkaller.appspotmail.com,
        stable@vger.kernel.org, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-underflow-in-second-superblock-position-calculations.patch added to mm-hotfixes-unstable branch
Message-Id: <20230216225427.1451DC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: fix underflow in second superblock position calculations
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-underflow-in-second-superblock-position-calculations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-underflow-in-second-superblock-position-calculations.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix underflow in second superblock position calculations
Date: Wed, 15 Feb 2023 07:40:43 +0900

Macro NILFS_SB2_OFFSET_BYTES, which computes the position of the second
superblock, underflows when the argument device size is less than 4096
bytes.  Therefore, when using this macro, it is necessary to check in
advance that the device size is not less than a lower limit, or at least
that underflow does not occur.

The current nilfs2 implementation lacks this check, causing out-of-bound
block access when mounting devices smaller than 4096 bytes:

 I/O error, dev loop0, sector 36028797018963960 op 0x0:(READ) flags 0x0
 phys_seg 1 prio class 2
 NILFS (loop0): unable to read secondary superblock (blocksize = 1024)

In addition, when trying to resize the filesystem to a size below 4096
bytes, this underflow occurs in nilfs_resize_fs(), passing a huge number
of segments to nilfs_sufile_resize(), corrupting parameters such as the
number of segments in superblocks.  This causes excessive loop iterations
in nilfs_sufile_resize() during a subsequent resize ioctl, causing
semaphore ns_segctor_sem to block for a long time and hang the writer
thread:

 INFO: task segctord:5067 blocked for more than 143 seconds.
      Not tainted 6.2.0-rc8-syzkaller-00015-gf6feea56f66d #0
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 task:segctord        state:D stack:23456 pid:5067  ppid:2
 flags:0x00004000
 Call Trace:
  <TASK>
  context_switch kernel/sched/core.c:5293 [inline]
  __schedule+0x1409/0x43f0 kernel/sched/core.c:6606
  schedule+0xc3/0x190 kernel/sched/core.c:6682
  rwsem_down_write_slowpath+0xfcf/0x14a0 kernel/locking/rwsem.c:1190
  nilfs_transaction_lock+0x25c/0x4f0 fs/nilfs2/segment.c:357
  nilfs_segctor_thread_construct fs/nilfs2/segment.c:2486 [inline]
  nilfs_segctor_thread+0x52f/0x1140 fs/nilfs2/segment.c:2570
  kthread+0x270/0x300 kernel/kthread.c:376
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
  </TASK>
 ...
 Call Trace:
  <TASK>
  folio_mark_accessed+0x51c/0xf00 mm/swap.c:515
  __nilfs_get_page_block fs/nilfs2/page.c:42 [inline]
  nilfs_grab_buffer+0x3d3/0x540 fs/nilfs2/page.c:61
  nilfs_mdt_submit_block+0xd7/0x8f0 fs/nilfs2/mdt.c:121
  nilfs_mdt_read_block+0xeb/0x430 fs/nilfs2/mdt.c:176
  nilfs_mdt_get_block+0x12d/0xbb0 fs/nilfs2/mdt.c:251
  nilfs_sufile_get_segment_usage_block fs/nilfs2/sufile.c:92 [inline]
  nilfs_sufile_truncate_range fs/nilfs2/sufile.c:679 [inline]
  nilfs_sufile_resize+0x7a3/0x12b0 fs/nilfs2/sufile.c:777
  nilfs_resize_fs+0x20c/0xed0 fs/nilfs2/super.c:422
  nilfs_ioctl_resize fs/nilfs2/ioctl.c:1033 [inline]
  nilfs_ioctl+0x137c/0x2440 fs/nilfs2/ioctl.c:1301
  ...

This fixes these issues by inserting appropriate minimum device size
checks or anti-underflow checks, depending on where the macro is used.

Link: https://lkml.kernel.org/r/0000000000004e1dfa05f4a48e6b@google.com
Link: https://lkml.kernel.org/r/20230214224043.24141-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: <syzbot+f0c4082ce5ebebdac63b@syzkaller.appspotmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/nilfs2/ioctl.c~nilfs2-fix-underflow-in-second-superblock-position-calculations
+++ a/fs/nilfs2/ioctl.c
@@ -1114,7 +1114,14 @@ static int nilfs_ioctl_set_alloc_range(s
 
 	minseg = range[0] + segbytes - 1;
 	do_div(minseg, segbytes);
+
+	if (range[1] < 4096)
+		goto out;
+
 	maxseg = NILFS_SB2_OFFSET_BYTES(range[1]);
+	if (maxseg < segbytes)
+		goto out;
+
 	do_div(maxseg, segbytes);
 	maxseg--;
 
--- a/fs/nilfs2/super.c~nilfs2-fix-underflow-in-second-superblock-position-calculations
+++ a/fs/nilfs2/super.c
@@ -409,6 +409,15 @@ int nilfs_resize_fs(struct super_block *
 		goto out;
 
 	/*
+	 * Prevent underflow in second superblock position calculation.
+	 * The exact minimum size check is done in nilfs_sufile_resize().
+	 */
+	if (newsize < 4096) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	/*
 	 * Write lock is required to protect some functions depending
 	 * on the number of segments, the number of reserved segments,
 	 * and so forth.
--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-underflow-in-second-superblock-position-calculations
+++ a/fs/nilfs2/the_nilfs.c
@@ -544,9 +544,15 @@ static int nilfs_load_super_block(struct
 {
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct buffer_head **sbh = nilfs->ns_sbh;
-	u64 sb2off = NILFS_SB2_OFFSET_BYTES(bdev_nr_bytes(nilfs->ns_bdev));
+	u64 sb2off, devsize = bdev_nr_bytes(nilfs->ns_bdev);
 	int valid[2], swp = 0;
 
+	if (devsize < NILFS_SEG_MIN_BLOCKS * NILFS_MIN_BLOCK_SIZE + 4096) {
+		nilfs_err(sb, "device size too small");
+		return -EINVAL;
+	}
+	sb2off = NILFS_SB2_OFFSET_BYTES(devsize);
+
 	sbp[0] = nilfs_read_super_block(sb, NILFS_SB_OFFSET_BYTES, blocksize,
 					&sbh[0]);
 	sbp[1] = nilfs_read_super_block(sb, sb2off, blocksize, &sbh[1]);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-underflow-in-second-superblock-position-calculations.patch

