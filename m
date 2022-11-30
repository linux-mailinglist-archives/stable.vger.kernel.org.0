Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAF063DBFC
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 18:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiK3Rbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 12:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiK3Rbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 12:31:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3088725E9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 09:31:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E28C7B81C4C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 17:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE5CC433D6;
        Wed, 30 Nov 2022 17:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669829507;
        bh=pyD6eYLxiAIkn+TDHzomeYMp+VVGa4bn1RqrFMgHadg=;
        h=Subject:To:Cc:From:Date:From;
        b=G9US9vX4FRqaxBe7W9pbX8D1B26HQP1B8h4k4V0ow2OtARmDjTNzTTBi1yBpS/EAm
         49xtIKKRNpgLH+g8D3ljwREFwvsIj0FoQPU3nshdOKgLUtoocEcnOFZjExwSKQa+gA
         yLh2N2GrS2ZALBSLlt0T6poWAE4oTauI2EAzTFug=
Subject: FAILED: patch "[PATCH] btrfs: qgroup: fix sleep from invalid context bug in" failed to apply to 4.9-stable tree
To:     chenxiaosong2@huawei.com, dsterba@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 18:31:32 +0100
Message-ID: <1669829492123254@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f7e942b5bb35 ("btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()")
e562a8bdf652 ("btrfs: introduce BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN")
db5df2541200 ("btrfs: move QUOTA_ENABLED check to rescan_should_stop from btrfs_qgroup_rescan_worker")
8949b9a11401 ("btrfs: fix lock inversion problem when doing qgroup extent tracing")
f3a84ccd28d0 ("btrfs: move the tree mod log code into its own file")
dbcc7d57bffc ("btrfs: fix race when cloning extent buffer during rewind of an old root")
cac06d843f25 ("btrfs: introduce the skeleton of btrfs_subpage structure")
cb13eea3b490 ("btrfs: fix transaction leak and crash after RO remount caused by qgroup rescan")
1b7ec85ef490 ("btrfs: pass root owner to read_tree_block")
bfb484d922a3 ("btrfs: cleanup extent buffer readahead")
ac5887c8e013 ("btrfs: locking: remove all the blocking helpers")
196d59ab9ccc ("btrfs: switch extent buffer tree lock to rw_semaphore")
bf77467a93bd ("btrfs: introduce BTRFS_NESTING_LEFT/BTRFS_NESTING_RIGHT")
9631e4cc1a03 ("btrfs: introduce BTRFS_NESTING_COW for cow'ing blocks")
fd7ba1c1202d ("btrfs: add nesting tags to the locking helpers")
51899412dd95 ("btrfs: introduce btrfs_path::recurse")
329ced799be8 ("btrfs: rename extent_buffer::lock_nested to extent_buffer::lock_recursed")
d16c702fe4f2 ("btrfs: ctree: check key order before merging tree blocks")
d3beaa253fd6 ("btrfs: set the lockdep class for log tree extent buffers")
ad24466588ab ("btrfs: set the correct lockdep class for new nodes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f7e942b5bb35d8e3af54053d19a6bf04143a3955 Mon Sep 17 00:00:00 2001
From: ChenXiaoSong <chenxiaosong2@huawei.com>
Date: Wed, 16 Nov 2022 22:23:54 +0800
Subject: [PATCH] btrfs: qgroup: fix sleep from invalid context bug in
 btrfs_qgroup_inherit()

Syzkaller reported BUG as follows:

  BUG: sleeping function called from invalid context at
       include/linux/sched/mm.h:274
  Call Trace:
   <TASK>
   dump_stack_lvl+0xcd/0x134
   __might_resched.cold+0x222/0x26b
   kmem_cache_alloc+0x2e7/0x3c0
   update_qgroup_limit_item+0xe1/0x390
   btrfs_qgroup_inherit+0x147b/0x1ee0
   create_subvol+0x4eb/0x1710
   btrfs_mksubvol+0xfe5/0x13f0
   __btrfs_ioctl_snap_create+0x2b0/0x430
   btrfs_ioctl_snap_create_v2+0x25a/0x520
   btrfs_ioctl+0x2a1c/0x5ce0
   __x64_sys_ioctl+0x193/0x200
   do_syscall_64+0x35/0x80

Fix this by calling qgroup_dirty() on @dstqgroup, and update limit item in
btrfs_run_qgroups() later outside of the spinlock context.

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9334c3157c22..b74105a10f16 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2951,14 +2951,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
 		dstgroup->rsv_excl = inherit->lim.rsv_excl;
 
-		ret = update_qgroup_limit_item(trans, dstgroup);
-		if (ret) {
-			qgroup_mark_inconsistent(fs_info);
-			btrfs_info(fs_info,
-				   "unable to update quota limit for %llu",
-				   dstgroup->qgroupid);
-			goto unlock;
-		}
+		qgroup_dirty(fs_info, dstgroup);
 	}
 
 	if (srcid) {

