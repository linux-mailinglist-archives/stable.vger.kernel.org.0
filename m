Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83E569BBAC
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 20:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBRTyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 14:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBRTyn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 14:54:43 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1E212F28
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:54:42 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id m8so318547plg.3
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FnrzaKuAaJeCKdwoYWIY/KSbSLxkEgxa5s3Nkss+IQM=;
        b=iBc7TNTDjFp573mk12CNcc+ikEIGxtKhHj1uWW2LLhgK8HjtR2Iawn7wh7yjuL+Dl8
         2PjD/vwUW5N76lcGnqOxoRnDcedIulB7azd4lFUuoIvQKkkchwprYS04WQ/54s43FqnX
         1lBoyoBBKUqp2el9q5d7GGBGSlQIUR4N+wPvcdxt+pnwAZ0h6HAKiJ7Dmd8ANOWMBVm7
         Z3W4slj/LtkR2Y8KXtLBvrkFQ1U8R6T5FSqcaGLsn4AFooWMjzWQdTBZd9LVs8uobdxr
         ttXG3RZ7emigUV8ereC8IYG0mplfk4SFpJ3T8TMQXAHrmq9daNZIU2QD0up21VsmSdXS
         jjCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FnrzaKuAaJeCKdwoYWIY/KSbSLxkEgxa5s3Nkss+IQM=;
        b=iKgIH6Fmykfbdlv8KImsPKbelYyzwKq+22PKjiOxkOxljr6y3rVzfesfFI2LABtfOl
         X/Rcxxovi19h1HxZB1FkNSUpZRW3l1HsoWMbcEwemVTzw8OLGXje+UitZHDPIkH9Hwk6
         mYb7tKdU7SwuJNQHeHmPSs75tOI71tQ+kLAALHijHprOc027/uoPYJ/X+qJkmd9N+cyT
         sT7j+/PtCkT9EPN5WkFO1icJlidfc6rT8C+Gp1zAgJ2nRPu44Rt7iS3pQ6vd6TX78gWv
         juysqaueJKvETXigEa6bRveS8Ol4Jev4kfnX4nEJaSO+lNkzx4+8ioGCyKH2VWSbtkd3
         QGag==
X-Gm-Message-State: AO0yUKUcEMXd3QEg/sLtKHE9b/TeqrsXFXNYCJTRVpoOLJRh5Y8+WiVV
        cl8ysEso30aUgMOsQMB3Cx8=
X-Google-Smtp-Source: AK7set/5X8HJH8ZGn+03joTr5A2XLzg5ZOxHDQr+CTImaYtrxSdnA0Zdz680uWYQ2haHm7fQe3djcQ==
X-Received: by 2002:a17:902:e545:b0:19a:a305:e367 with SMTP id n5-20020a170902e54500b0019aa305e367mr1429659plf.30.1676750081383;
        Sat, 18 Feb 2023 11:54:41 -0800 (PST)
Received: from carrot.. (i121-118-78-205.s42.a014.ap.plala.or.jp. [121.118.78.205])
        by smtp.gmail.com with ESMTPSA id x1-20020a1709029a4100b0019a97a4324dsm5011529plv.5.2023.02.18.11.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 11:54:40 -0800 (PST)
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        syzbot+f0c4082ce5ebebdac63b@syzkaller.appspotmail.com
Subject: [PATCH 4.14 4.19 5.4] nilfs2: fix underflow in second superblock position calculations
Date:   Sun, 19 Feb 2023 04:53:57 +0900
Message-Id: <20230218195357.3789-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <167670733166142@kroah.com>
References: <167670733166142@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 99b9402a36f0799f25feee4465bfa4b8dfa74b4d upstream.

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
Please apply this patch to the above stable trees instead of the patch
that could not be applied to them last time.

This replaces bdev_nr_bytes() and nilfs_err() with their equivalents since
they don't yet exist in these kernels.  With these tweaks, this patch is
applicable from v4.8 to v5.8.  Also, this patch has been tested against
the title stable trees.

 fs/nilfs2/ioctl.c     | 7 +++++++
 fs/nilfs2/super.c     | 9 +++++++++
 fs/nilfs2/the_nilfs.c | 8 +++++++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 91b9dac6b2cc..262783cd79cc 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1130,7 +1130,14 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 
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
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 049768a22388..b1015e97f37b 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -403,6 +403,15 @@ int nilfs_resize_fs(struct super_block *sb, __u64 newsize)
 	if (newsize > devsize)
 		goto out;
 
+	/*
+	 * Prevent underflow in second superblock position calculation.
+	 * The exact minimum size check is done in nilfs_sufile_resize().
+	 */
+	if (newsize < 4096) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
 	/*
 	 * Write lock is required to protect some functions depending
 	 * on the number of segments, the number of reserved segments,
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 74ef3d313686..6541e29a8b20 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -517,9 +517,15 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 {
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct buffer_head **sbh = nilfs->ns_sbh;
-	u64 sb2off = NILFS_SB2_OFFSET_BYTES(nilfs->ns_bdev->bd_inode->i_size);
+	u64 sb2off, devsize = nilfs->ns_bdev->bd_inode->i_size;
 	int valid[2], swp = 0;
 
+	if (devsize < NILFS_SEG_MIN_BLOCKS * NILFS_MIN_BLOCK_SIZE + 4096) {
+		nilfs_msg(sb, KERN_ERR, "device size too small");
+		return -EINVAL;
+	}
+	sb2off = NILFS_SB2_OFFSET_BYTES(devsize);
+
 	sbp[0] = nilfs_read_super_block(sb, NILFS_SB_OFFSET_BYTES, blocksize,
 					&sbh[0]);
 	sbp[1] = nilfs_read_super_block(sb, sb2off, blocksize, &sbh[1]);
-- 
2.31.1

