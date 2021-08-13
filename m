Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62733EB8BF
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242658AbhHMPQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242662AbhHMPOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B773E61107;
        Fri, 13 Aug 2021 15:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867647;
        bh=5ehD2IoYWNumMPb/FyXJKqAbEmbxgtibNhXNgEeQaBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VypMtNsJ9ELNKrlyWu19BdDiTKP4g+jT/QU9ZoL6kaiImlgw5qcCOcZEMW3dekfTF
         ZKCgQAT4lbY/KHxnK+a3eOaOE2aQtcEItRCRAx46QHyZ0XIqHDCQfr0T8c11paglXo
         ZRGwno5s0LZ48wReJEQHFF24UQlsEfR6ctDaCpg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 27/27] btrfs: dont flush from btrfs_delayed_inode_reserve_metadata
Date:   Fri, 13 Aug 2021 17:07:25 +0200
Message-Id: <20210813150524.289234540@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 4d14c5cde5c268a2bc26addecf09489cb953ef64 upstream

Calling btrfs_qgroup_reserve_meta_prealloc from
btrfs_delayed_inode_reserve_metadata can result in flushing delalloc
while holding a transaction and delayed node locks. This is deadlock
prone. In the past multiple commits:

 * ae5e070eaca9 ("btrfs: qgroup: don't try to wait flushing if we're
already holding a transaction")

 * 6f23277a49e6 ("btrfs: qgroup: don't commit transaction when we already
 hold the handle")

Tried to solve various aspects of this but this was always a
whack-a-mole game. Unfortunately those 2 fixes don't solve a deadlock
scenario involving btrfs_delayed_node::mutex. Namely, one thread
can call btrfs_dirty_inode as a result of reading a file and modifying
its atime:

  PID: 6963   TASK: ffff8c7f3f94c000  CPU: 2   COMMAND: "test"
  #0  __schedule at ffffffffa529e07d
  #1  schedule at ffffffffa529e4ff
  #2  schedule_timeout at ffffffffa52a1bdd
  #3  wait_for_completion at ffffffffa529eeea             <-- sleeps with delayed node mutex held
  #4  start_delalloc_inodes at ffffffffc0380db5
  #5  btrfs_start_delalloc_snapshot at ffffffffc0393836
  #6  try_flush_qgroup at ffffffffc03f04b2
  #7  __btrfs_qgroup_reserve_meta at ffffffffc03f5bb6     <-- tries to reserve space and starts delalloc inodes.
  #8  btrfs_delayed_update_inode at ffffffffc03e31aa      <-- acquires delayed node mutex
  #9  btrfs_update_inode at ffffffffc0385ba8
 #10  btrfs_dirty_inode at ffffffffc038627b               <-- TRANSACTIION OPENED
 #11  touch_atime at ffffffffa4cf0000
 #12  generic_file_read_iter at ffffffffa4c1f123
 #13  new_sync_read at ffffffffa4ccdc8a
 #14  vfs_read at ffffffffa4cd0849
 #15  ksys_read at ffffffffa4cd0bd1
 #16  do_syscall_64 at ffffffffa4a052eb
 #17  entry_SYSCALL_64_after_hwframe at ffffffffa540008c

This will cause an asynchronous work to flush the delalloc inodes to
happen which can try to acquire the same delayed_node mutex:

  PID: 455    TASK: ffff8c8085fa4000  CPU: 5   COMMAND: "kworker/u16:30"
  #0  __schedule at ffffffffa529e07d
  #1  schedule at ffffffffa529e4ff
  #2  schedule_preempt_disabled at ffffffffa529e80a
  #3  __mutex_lock at ffffffffa529fdcb                    <-- goes to sleep, never wakes up.
  #4  btrfs_delayed_update_inode at ffffffffc03e3143      <-- tries to acquire the mutex
  #5  btrfs_update_inode at ffffffffc0385ba8              <-- this is the same inode that pid 6963 is holding
  #6  cow_file_range_inline.constprop.78 at ffffffffc0386be7
  #7  cow_file_range at ffffffffc03879c1
  #8  btrfs_run_delalloc_range at ffffffffc038894c
  #9  writepage_delalloc at ffffffffc03a3c8f
 #10  __extent_writepage at ffffffffc03a4c01
 #11  extent_write_cache_pages at ffffffffc03a500b
 #12  extent_writepages at ffffffffc03a6de2
 #13  do_writepages at ffffffffa4c277eb
 #14  __filemap_fdatawrite_range at ffffffffa4c1e5bb
 #15  btrfs_run_delalloc_work at ffffffffc0380987         <-- starts running delayed nodes
 #16  normal_work_helper at ffffffffc03b706c
 #17  process_one_work at ffffffffa4aba4e4
 #18  worker_thread at ffffffffa4aba6fd
 #19  kthread at ffffffffa4ac0a3d
 #20  ret_from_fork at ffffffffa54001ff

To fully address those cases the complete fix is to never issue any
flushing while holding the transaction or the delayed node lock. This
patch achieves it by calling qgroup_reserve_meta directly which will
either succeed without flushing or will fail and return -EDQUOT. In the
latter case that return value is going to be propagated to
btrfs_dirty_inode which will fallback to start a new transaction. That's
fine as the majority of time we expect the inode will have
BTRFS_DELAYED_NODE_INODE_DIRTY flag set which will result in directly
copying the in-memory state.

Fixes: c53e9653605d ("btrfs: qgroup: try to flush qgroup space when we get -EDQUOT")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-inode.c |    3 ++-
 fs/btrfs/inode.c         |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -627,7 +627,8 @@ static int btrfs_delayed_inode_reserve_m
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
 			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
-		ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
+		ret = btrfs_qgroup_reserve_meta(root, num_bytes,
+					  BTRFS_QGROUP_RSV_META_PREALLOC, true);
 		if (ret < 0)
 			return ret;
 		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes,
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6375,7 +6375,7 @@ static int btrfs_dirty_inode(struct inod
 		return PTR_ERR(trans);
 
 	ret = btrfs_update_inode(trans, root, inode);
-	if (ret && ret == -ENOSPC) {
+	if (ret && (ret == -ENOSPC || ret == -EDQUOT)) {
 		/* whoops, lets try again with the full transaction */
 		btrfs_end_transaction(trans);
 		trans = btrfs_start_transaction(root, 1);


