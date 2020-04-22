Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C08E1B3E59
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbgDVK1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730900AbgDVK1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:27:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A66E20784;
        Wed, 22 Apr 2020 10:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551251;
        bh=FQLCavUo/9H+bwWjXvVXMibQQ4dnU0g9B7kxhkUSxHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqMcL22jA4/vSuvFwGFC4ZX2GLErkaIzwf6ocNofnls8csJFMbTP3J93X6ohqfJpI
         8yYFAuk6ESk61Qi34XZhWWWary7oa61tTi8fjjgN4GMeg6JxAmutlp1qBs6pkUCJIU
         r3kTw1bVFIoZmWD8ECFUNU3R7UuWXmfGQqdg9pCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 120/166] f2fs: fix potential deadlock on compressed quota file
Date:   Wed, 22 Apr 2020 11:57:27 +0200
Message-Id: <20200422095101.496740578@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 466357dc9b5ff555d16b7f9a0ff264eb9d5d908b ]

generic/232 reports below deadlock:

fsstress        D    0 96980  96969 0x00084000
Call Trace:
 schedule+0x4a/0xb0
 io_schedule+0x12/0x40
 __lock_page+0x127/0x1d0
 pagecache_get_page+0x1d8/0x250
 prepare_compress_overwrite+0xe0/0x490 [f2fs]
 f2fs_prepare_compress_overwrite+0x5d/0x80 [f2fs]
 f2fs_write_begin+0x833/0xb90 [f2fs]
 f2fs_quota_write+0x145/0x1e0 [f2fs]
 write_blk+0x36/0x80 [quota_tree]
 do_insert_tree+0x2ac/0x4a0 [quota_tree]
 do_insert_tree+0x26e/0x4a0 [quota_tree]
 qtree_write_dquot+0x70/0x190 [quota_tree]
 v2_write_dquot+0x43/0x90 [quota_v2]
 dquot_acquire+0x77/0x100
 f2fs_dquot_acquire+0x2f/0x60 [f2fs]
 dqget+0x310/0x450
 dquot_transfer+0xb2/0x120
 f2fs_setattr+0x11a/0x4a0 [f2fs]
 notify_change+0x349/0x480
 chown_common+0x168/0x1c0
 do_fchownat+0xbc/0xf0
 __x64_sys_lchown+0x21/0x30
 do_syscall_64+0x5f/0x220
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

  task                        PC stack   pid father
kworker/u256:0  D    0 103444      2 0x80084000
Workqueue: writeback wb_workfn (flush-251:1)
Call Trace:
 schedule+0x4a/0xb0
 schedule_timeout+0x15e/0x2f0
 io_schedule_timeout+0x19/0x40
 congestion_wait+0x7e/0x120
 f2fs_write_multi_pages+0x12a/0x840 [f2fs]
 f2fs_write_cache_pages+0x48f/0x790 [f2fs]
 f2fs_write_data_pages+0x2db/0x330 [f2fs]
 do_writepages+0x1a/0x60
 __writeback_single_inode+0x3d/0x340
 writeback_sb_inodes+0x225/0x4a0
 wb_writeback+0xf7/0x320
 wb_workfn+0xba/0x470
 process_one_work+0x16c/0x3f0
 worker_thread+0x4c/0x440
 kthread+0xf8/0x130
 ret_from_fork+0x35/0x40

fsstress        D    0  5277   5266 0x00084000
Call Trace:
 schedule+0x4a/0xb0
 rwsem_down_write_slowpath+0x29d/0x540
 block_operations+0x105/0x360 [f2fs]
 f2fs_write_checkpoint+0x101/0x1010 [f2fs]
 f2fs_sync_fs+0xa8/0x130 [f2fs]
 f2fs_do_sync_file+0x1ad/0x890 [f2fs]
 do_fsync+0x38/0x60
 __x64_sys_fdatasync+0x13/0x20
 do_syscall_64+0x5f/0x220
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The root cause is there is potential deadlock between quota data
update and writeback.

Kworker					Thread B			Thread C
- f2fs_write_cache_pages
 - lock whole cluster	--- A
 - f2fs_write_multi_pages
  - f2fs_write_raw_pages
   - f2fs_write_single_data_page
    - f2fs_do_write_data_page
					- f2fs_setattr
					 - f2fs_lock_op	--- B
									- f2fs_write_checkpoint
									 - block_operations
									  - f2fs_lock_all --- B
					 - dquot_transfer
					  - f2fs_quota_write
					   - f2fs_prepare_compress_overwrite
					    - pagecache_get_page --- A
     - f2fs_trylock_op failed	--- B
  - congestion_wait
  - goto rewrite

To fix this issue, during quota file writeback, just redirty all pages
left in cluster rather holding pages' lock in cluster and looping retrying
lock cp_rwsem.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index eb84c13c1182c..ad8e25a1fbc26 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -988,6 +988,15 @@ static int f2fs_write_raw_pages(struct compress_ctx *cc,
 				unlock_page(cc->rpages[i]);
 				ret = 0;
 			} else if (ret == -EAGAIN) {
+				/*
+				 * for quota file, just redirty left pages to
+				 * avoid deadlock caused by cluster update race
+				 * from foreground operation.
+				 */
+				if (IS_NOQUOTA(cc->inode)) {
+					err = 0;
+					goto out_err;
+				}
 				ret = 0;
 				cond_resched();
 				congestion_wait(BLK_RW_ASYNC, HZ/50);
@@ -996,16 +1005,12 @@ static int f2fs_write_raw_pages(struct compress_ctx *cc,
 				goto retry_write;
 			}
 			err = ret;
-			goto out_fail;
+			goto out_err;
 		}
 
 		*submitted += _submitted;
 	}
 	return 0;
-
-out_fail:
-	/* TODO: revoke partially updated block addresses */
-	BUG_ON(compr_blocks);
 out_err:
 	for (++i; i < cc->cluster_size; i++) {
 		if (!cc->rpages[i])
-- 
2.20.1



