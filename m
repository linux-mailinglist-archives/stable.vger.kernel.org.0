Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D243FDAF8
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343880AbhIAMgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245343AbhIAMeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:34:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76E48610A4;
        Wed,  1 Sep 2021 12:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499579;
        bh=jrHj+f3XSk1zv6wzDmssmcd4Do2C4Ha6n+lf9qiaav4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAjFoHUrHkjp5klZzopeBt/14hBfpWhBoziEAuT3tt79SoPFpkAItCE3bwNiMkJli
         573Ural6kbG/300SUctQfPcdlIMWT8jSlMLr+NBhe3cIrZ/GoyWjlZ0Q6+wqXPKrje
         fnzJBt11rS0y8twnxEJ0R2ElB9/JcpETUBNXt4aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 37/48] btrfs: fix race between marking inode needs to be logged and log syncing
Date:   Wed,  1 Sep 2021 14:28:27 +0200
Message-Id: <20210901122254.619651961@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit bc0939fcfab0d7efb2ed12896b1af3d819954a14 upstream.

We have a race between marking that an inode needs to be logged, either
at btrfs_set_inode_last_trans() or at btrfs_page_mkwrite(), and between
btrfs_sync_log(). The following steps describe how the race happens.

1) We are at transaction N;

2) Inode I was previously fsynced in the current transaction so it has:

    inode->logged_trans set to N;

3) The inode's root currently has:

   root->log_transid set to 1
   root->last_log_commit set to 0

   Which means only one log transaction was committed to far, log
   transaction 0. When a log tree is created we set ->log_transid and
   ->last_log_commit of its parent root to 0 (at btrfs_add_log_tree());

4) One more range of pages is dirtied in inode I;

5) Some task A starts an fsync against some other inode J (same root), and
   so it joins log transaction 1.

   Before task A calls btrfs_sync_log()...

6) Task B starts an fsync against inode I, which currently has the full
   sync flag set, so it starts delalloc and waits for the ordered extent
   to complete before calling btrfs_inode_in_log() at btrfs_sync_file();

7) During ordered extent completion we have btrfs_update_inode() called
   against inode I, which in turn calls btrfs_set_inode_last_trans(),
   which does the following:

     spin_lock(&inode->lock);
     inode->last_trans = trans->transaction->transid;
     inode->last_sub_trans = inode->root->log_transid;
     inode->last_log_commit = inode->root->last_log_commit;
     spin_unlock(&inode->lock);

   So ->last_trans is set to N and ->last_sub_trans set to 1.
   But before setting ->last_log_commit...

8) Task A is at btrfs_sync_log():

   - it increments root->log_transid to 2
   - starts writeback for all log tree extent buffers
   - waits for the writeback to complete
   - writes the super blocks
   - updates root->last_log_commit to 1

   It's a lot of slow steps between updating root->log_transid and
   root->last_log_commit;

9) The task doing the ordered extent completion, currently at
   btrfs_set_inode_last_trans(), then finally runs:

     inode->last_log_commit = inode->root->last_log_commit;
     spin_unlock(&inode->lock);

   Which results in inode->last_log_commit being set to 1.
   The ordered extent completes;

10) Task B is resumed, and it calls btrfs_inode_in_log() which returns
    true because we have all the following conditions met:

    inode->logged_trans == N which matches fs_info->generation &&
    inode->last_subtrans (1) <= inode->last_log_commit (1) &&
    inode->last_subtrans (1) <= root->last_log_commit (1) &&
    list inode->extent_tree.modified_extents is empty

    And as a consequence we return without logging the inode, so the
    existing logged version of the inode does not point to the extent
    that was written after the previous fsync.

It should be impossible in practice for one task be able to do so much
progress in btrfs_sync_log() while another task is at
btrfs_set_inode_last_trans() right after it reads root->log_transid and
before it reads root->last_log_commit. Even if kernel preemption is enabled
we know the task at btrfs_set_inode_last_trans() can not be preempted
because it is holding the inode's spinlock.

However there is another place where we do the same without holding the
spinlock, which is in the memory mapped write path at:

  vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
  {
     (...)
     BTRFS_I(inode)->last_trans = fs_info->generation;
     BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
     BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
     (...)

So with preemption happening after setting ->last_sub_trans and before
setting ->last_log_commit, it is less of a stretch to have another task
do enough progress at btrfs_sync_log() such that the task doing the memory
mapped write ends up with ->last_sub_trans and ->last_log_commit set to
the same value. It is still a big stretch to get there, as the task doing
btrfs_sync_log() has to start writeback, wait for its completion and write
the super blocks.

So fix this in two different ways:

1) For btrfs_set_inode_last_trans(), simply set ->last_log_commit to the
   value of ->last_sub_trans minus 1;

2) For btrfs_page_mkwrite() only set the inode's ->last_sub_trans, just
   like we do for buffered and direct writes at btrfs_file_write_iter(),
   which is all we need to make sure multiple writes and fsyncs to an
   inode in the same transaction never result in an fsync missing that
   the inode changed and needs to be logged. Turn this into a helper
   function and use it both at btrfs_page_mkwrite() and at
   btrfs_file_write_iter() - this also fixes the problem that at
   btrfs_page_mkwrite() we were setting those fields without the
   protection of the inode's spinlock.

This is an extremely unlikely race to happen in practice.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/btrfs_inode.h |   15 +++++++++++++++
 fs/btrfs/file.c        |   10 ++--------
 fs/btrfs/inode.c       |    4 +---
 fs/btrfs/transaction.h |    2 +-
 4 files changed, 19 insertions(+), 12 deletions(-)

--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -268,6 +268,21 @@ static inline void btrfs_mod_outstanding
 						  mod);
 }
 
+/*
+ * Called every time after doing a buffered, direct IO or memory mapped write.
+ *
+ * This is to ensure that if we write to a file that was previously fsynced in
+ * the current transaction, then try to fsync it again in the same transaction,
+ * we will know that there were changes in the file and that it needs to be
+ * logged.
+ */
+static inline void btrfs_set_inode_last_sub_trans(struct btrfs_inode *inode)
+{
+	spin_lock(&inode->lock);
+	inode->last_sub_trans = inode->root->log_transid;
+	spin_unlock(&inode->lock);
+}
+
 static inline int btrfs_inode_in_log(struct btrfs_inode *inode, u64 generation)
 {
 	int ret = 0;
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2004,14 +2004,8 @@ static ssize_t btrfs_file_write_iter(str
 
 	inode_unlock(inode);
 
-	/*
-	 * We also have to set last_sub_trans to the current log transid,
-	 * otherwise subsequent syncs to a file that's been synced in this
-	 * transaction will appear to have already occurred.
-	 */
-	spin_lock(&BTRFS_I(inode)->lock);
-	BTRFS_I(inode)->last_sub_trans = root->log_transid;
-	spin_unlock(&BTRFS_I(inode)->lock);
+	btrfs_set_inode_last_sub_trans(BTRFS_I(inode));
+
 	if (num_written > 0)
 		num_written = generic_write_sync(iocb, num_written);
 
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9250,9 +9250,7 @@ again:
 	set_page_dirty(page);
 	SetPageUptodate(page);
 
-	BTRFS_I(inode)->last_trans = fs_info->generation;
-	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
-	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
+	btrfs_set_inode_last_sub_trans(BTRFS_I(inode));
 
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -160,7 +160,7 @@ static inline void btrfs_set_inode_last_
 	spin_lock(&BTRFS_I(inode)->lock);
 	BTRFS_I(inode)->last_trans = trans->transaction->transid;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
-	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
+	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->last_sub_trans - 1;
 	spin_unlock(&BTRFS_I(inode)->lock);
 }
 


