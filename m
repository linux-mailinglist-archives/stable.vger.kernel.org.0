Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A509F6EBA63
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 18:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjDVQhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 12:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDVQhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 12:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90688198B
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 09:37:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11113619EF
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B9AC433EF;
        Sat, 22 Apr 2023 16:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682181456;
        bh=7ZnJK7yCovLcpMOHY48oBfOtFx6EvwwMoo1290xUQZQ=;
        h=Subject:To:Cc:From:Date:From;
        b=Asf+V64AhVmlRG6UcRyY2NfYffdYYH6Pv3G4sCCGFNT1ebMoLgsCC2RjTrHL8QQsJ
         Mtft+w4Gi5SvOuRQNQwbsxyii74ublgiAyunW7ah//uJpwFegJioG4nqaqJI2cSzgM
         O5h8DQ54y5DPLtscqd1b6vpzJEY7RBFPes/VtNXI=
Subject: FAILED: patch "[PATCH] writeback, cgroup: fix null-ptr-deref write in" failed to apply to 4.14-stable tree
To:     libaokun1@huawei.com, adilger.kernel@dilger.ca,
        akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
        dennis@kernel.org, houtao1@huawei.com, jack@suse.cz,
        stable@vger.kernel.org, tj@kernel.org, viro@zeniv.linux.org.uk,
        yangerkun@huawei.com, yi.zhang@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Apr 2023 18:37:29 +0200
Message-ID: <2023042229-enchilada-cheddar-abb9@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 1ba1199ec5747f475538c0d25a32804e5ba1dfde
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023042229-enchilada-cheddar-abb9@gregkh' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

1ba1199ec574 ("writeback, cgroup: fix null-ptr-deref write in bdi_split_work_to_wbs")
c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
f3b6a6df38aa ("writeback, cgroup: keep list of inodes attached to bdi_writeback")
29264d92a0f1 ("writeback, cgroup: switch to rcu_work API in inode_switch_wbs()")
8826ee4fe750 ("writeback, cgroup: increment isw_nr_in_flight before grabbing an inode")
4ade5867b4b8 ("writeback, cgroup: do not switch inodes with I_WILL_FREE flag")
e30942859030 ("Merge tag 'writeback_for_v5.9-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ba1199ec5747f475538c0d25a32804e5ba1dfde Mon Sep 17 00:00:00 2001
From: Baokun Li <libaokun1@huawei.com>
Date: Mon, 10 Apr 2023 21:08:26 +0800
Subject: [PATCH] writeback, cgroup: fix null-ptr-deref write in
 bdi_split_work_to_wbs

KASAN report null-ptr-deref:
==================================================================
BUG: KASAN: null-ptr-deref in bdi_split_work_to_wbs+0x5c5/0x7b0
Write of size 8 at addr 0000000000000000 by task sync/943
CPU: 5 PID: 943 Comm: sync Tainted: 6.3.0-rc5-next-20230406-dirty #461
Call Trace:
 <TASK>
 dump_stack_lvl+0x7f/0xc0
 print_report+0x2ba/0x340
 kasan_report+0xc4/0x120
 kasan_check_range+0x1b7/0x2e0
 __kasan_check_write+0x24/0x40
 bdi_split_work_to_wbs+0x5c5/0x7b0
 sync_inodes_sb+0x195/0x630
 sync_inodes_one_sb+0x3a/0x50
 iterate_supers+0x106/0x1b0
 ksys_sync+0x98/0x160
[...]
==================================================================

The race that causes the above issue is as follows:

           cpu1                     cpu2
-------------------------|-------------------------
inode_switch_wbs
 INIT_WORK(&isw->work, inode_switch_wbs_work_fn)
 queue_rcu_work(isw_wq, &isw->work)
 // queue_work async
  inode_switch_wbs_work_fn
   wb_put_many(old_wb, nr_switched)
    percpu_ref_put_many
     ref->data->release(ref)
     cgwb_release
      queue_work(cgwb_release_wq, &wb->release_work)
      // queue_work async
       &wb->release_work
       cgwb_release_workfn
                            ksys_sync
                             iterate_supers
                              sync_inodes_one_sb
                               sync_inodes_sb
                                bdi_split_work_to_wbs
                                 kmalloc(sizeof(*work), GFP_ATOMIC)
                                 // alloc memory failed
        percpu_ref_exit
         ref->data = NULL
         kfree(data)
                                 wb_get(wb)
                                  percpu_ref_get(&wb->refcnt)
                                   percpu_ref_get_many(ref, 1)
                                    atomic_long_add(nr, &ref->data->count)
                                     atomic64_add(i, v)
                                     // trigger null-ptr-deref

bdi_split_work_to_wbs() traverses &bdi->wb_list to split work into all
wbs.  If the allocation of new work fails, the on-stack fallback will be
used and the reference count of the current wb is increased afterwards.
If cgroup writeback membership switches occur before getting the reference
count and the current wb is released as old_wd, then calling wb_get() or
wb_put() will trigger the null pointer dereference above.

This issue was introduced in v4.3-rc7 (see fix tag1).  Both
sync_inodes_sb() and __writeback_inodes_sb_nr() calls to
bdi_split_work_to_wbs() can trigger this issue.  For scenarios called via
sync_inodes_sb(), originally commit 7fc5854f8c6e ("writeback: synchronize
sync(2) against cgroup writeback membership switches") reduced the
possibility of the issue by adding wb_switch_rwsem, but in v5.14-rc1 (see
fix tag2) removed the "inode_io_list_del_locked(inode, old_wb)" from
inode_switch_wbs_work_fn() so that wb->state contains WB_has_dirty_io,
thus old_wb is not skipped when traversing wbs in bdi_split_work_to_wbs(),
and the issue becomes easily reproducible again.

To solve this problem, percpu_ref_exit() is called under RCU protection to
avoid race between cgwb_release_workfn() and bdi_split_work_to_wbs().
Moreover, replace wb_get() with wb_tryget() in bdi_split_work_to_wbs(),
and skip the current wb if wb_tryget() fails because the wb has already
been shutdown.

Link: https://lkml.kernel.org/r/20230410130826.1492525-1-libaokun1@huawei.com
Fixes: b817525a4a80 ("writeback: bdi_writeback iteration must not skip dying ones")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Hou Tao <houtao1@huawei.com>
Cc: yangerkun <yangerkun@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 195dc23e0d83..1db3e3c24b43 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -978,6 +978,16 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 			continue;
 		}
 
+		/*
+		 * If wb_tryget fails, the wb has been shutdown, skip it.
+		 *
+		 * Pin @wb so that it stays on @bdi->wb_list.  This allows
+		 * continuing iteration from @wb after dropping and
+		 * regrabbing rcu read lock.
+		 */
+		if (!wb_tryget(wb))
+			continue;
+
 		/* alloc failed, execute synchronously using on-stack fallback */
 		work = &fallback_work;
 		*work = *base_work;
@@ -986,13 +996,6 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 		work->done = &fallback_work_done;
 
 		wb_queue_work(wb, work);
-
-		/*
-		 * Pin @wb so that it stays on @bdi->wb_list.  This allows
-		 * continuing iteration from @wb after dropping and
-		 * regrabbing rcu read lock.
-		 */
-		wb_get(wb);
 		last_wb = wb;
 
 		rcu_read_unlock();
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index a53b9360b72e..30d2d0386fdb 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -507,6 +507,15 @@ static LIST_HEAD(offline_cgwbs);
 static void cleanup_offline_cgwbs_workfn(struct work_struct *work);
 static DECLARE_WORK(cleanup_offline_cgwbs_work, cleanup_offline_cgwbs_workfn);
 
+static void cgwb_free_rcu(struct rcu_head *rcu_head)
+{
+	struct bdi_writeback *wb = container_of(rcu_head,
+			struct bdi_writeback, rcu);
+
+	percpu_ref_exit(&wb->refcnt);
+	kfree(wb);
+}
+
 static void cgwb_release_workfn(struct work_struct *work)
 {
 	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
@@ -529,11 +538,10 @@ static void cgwb_release_workfn(struct work_struct *work)
 	list_del(&wb->offline_node);
 	spin_unlock_irq(&cgwb_lock);
 
-	percpu_ref_exit(&wb->refcnt);
 	wb_exit(wb);
 	bdi_put(bdi);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
-	kfree_rcu(wb, rcu);
+	call_rcu(&wb->rcu, cgwb_free_rcu);
 }
 
 static void cgwb_release(struct percpu_ref *refcnt)

