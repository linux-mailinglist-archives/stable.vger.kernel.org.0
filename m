Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B03C6D98DB
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 16:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbjDFODW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 10:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjDFODV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 10:03:21 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF7749CE;
        Thu,  6 Apr 2023 07:03:19 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Psjmj68qcznb9n;
        Thu,  6 Apr 2023 21:59:49 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 6 Apr
 2023 22:03:16 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-fsdevel@vger.kernel.org>
CC:     <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <tj@kernel.org>,
        <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>, <stable@vger.kernel.org>
Subject: [RFC PATCH] writeback, cgroup: fix null-ptr-deref write in bdi_split_work_to_wbs
Date:   Thu, 6 Apr 2023 22:02:47 +0800
Message-ID: <20230406140247.1936541-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

KASAN report null-ptr-deref:
==================================================================
BUG: KASAN: null-ptr-deref in bdi_split_work_to_wbs+0x6ce/0x6e0
Write of size 8 at addr 0000000000000000 by task syz-executor.3/3514

CPU: 3 PID: 3514 Comm: syz-executor.3 Not tainted 5.10.0-dirty #1
Call Trace:
 dump_stack+0xbe/0xfd
 __kasan_report.cold+0x34/0x84
 kasan_report+0x3a/0x50
 check_memory_region+0xfd/0x1f0
 bdi_split_work_to_wbs+0x6ce/0x6e0
 __writeback_inodes_sb_nr+0x184/0x1f0
 try_to_writeback_inodes_sb+0x7f/0xa0
 ext4_nonda_switch+0x125/0x130
 ext4_da_write_begin+0x126/0x6e0
 generic_perform_write+0x199/0x3a0
 ext4_buffered_write_iter+0x16d/0x2b0
 ext4_file_write_iter+0xea/0x140
 new_sync_write+0x2fa/0x430
 vfs_write+0x4a1/0x570
 ksys_write+0xf6/0x1f0
 do_syscall_64+0x30/0x40
 entry_SYSCALL_64_after_hwframe+0x61/0xc6
RIP: 0033:0x45513d
[...]
==================================================================

Above issue may happen as follows:

            cpu1                        cpu2
----------------------------|----------------------------
ext4_nonda_switch
 try_to_writeback_inodes_sb
  __writeback_inodes_sb_nr
   bdi_split_work_to_wbs
    kmalloc(sizeof(*work), GFP_ATOMIC)  ---> alloc mem failed
                                inode_switch_wbs
                                 inode_switch_wbs_work_fn
                                  wb_put_many
                                   percpu_ref_put_many
                                    ref->data->release(ref)
                                     cgwb_release
                                      &wb->release_work
                                       cgwb_release_workfn
                                        percpu_ref_exit
                                         ref->data = NULL
                                         kfree(data)
    wb_get(wb)
     percpu_ref_get(&wb->refcnt)
      percpu_ref_get_many(ref, 1)
       atomic_long_add(nr, &ref->data->count) ---> ref->data = NULL
        atomic64_add(i, v) ---> trigger null-ptr-deref

bdi_split_work_to_wbs() traverses &bdi->wb_list to split work into all wbs.
If the allocation of new work fails, the on-stack fallback will be used and
the reference count of the current wb is increased afterwards. If cgroup
writeback membership switches occur before getting the reference count and
the current wb is released as old_wd, then calling wb_get() or wb_put()
will trigger the null pointer dereference above.

A similar problem is fixed in commit 7fc5854f8c6e ("writeback: synchronize
sync(2) against cgroup writeback membership switches"), but the patch only
adds locks to sync_inodes_sb() and not to the __writeback_inodes_sb_nr()
function that also calls bdi_split_work_to_wbs() function. So avoid the
above race by adding the same lock to __writeback_inodes_sb_nr() and
expanding the range of wb_switch_rwsem held in inode_switch_wbs_work_fn().

Fixes: b817525a4a80 ("writeback: bdi_writeback iteration must not skip dying ones")
Cc: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/fs-writeback.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 195dc23e0d83..52825aaf549b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -506,13 +506,13 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 
-	up_read(&bdi->wb_switch_rwsem);
-
 	if (nr_switched) {
 		wb_wakeup(new_wb);
 		wb_put_many(old_wb, nr_switched);
 	}
 
+	up_read(&bdi->wb_switch_rwsem);
+
 	for (inodep = isw->inodes; *inodep; inodep++)
 		iput(*inodep);
 	wb_put(new_wb);
@@ -936,6 +936,11 @@ static long wb_split_bdi_pages(struct bdi_writeback *wb, long nr_pages)
  * have dirty inodes.  If @base_work->nr_page isn't %LONG_MAX, it's
  * distributed to the busy wbs according to each wb's proportion in the
  * total active write bandwidth of @bdi.
+ *
+ * Called under &bdi->wb_switch_rwsem, otherwise bdi_split_work_to_wbs()
+ * may race against cgwb (cgroup writeback) membership switches, which may
+ * cause some inodes to fail to write back, or even trigger a null pointer
+ * dereference using a freed wb.
  */
 static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 				  struct wb_writeback_work *base_work,
@@ -2637,8 +2642,11 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
+	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
+	bdi_down_write_wb_switch_rwsem(bdi);
 	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy);
 	wb_wait_for_completion(&done);
+	bdi_up_write_wb_switch_rwsem(bdi);
 }
 
 /**
-- 
2.31.1

