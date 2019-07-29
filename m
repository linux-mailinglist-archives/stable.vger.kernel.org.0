Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B2B79472
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfG2Tbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730171AbfG2Tbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:31:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A3C82070B;
        Mon, 29 Jul 2019 19:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428695;
        bh=teYA52SKQAPfFHB3ttDrRt74gQvkiiKl0rrFbTo3XVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UA7s6mdw0ODWmDpm65CSAnBOo1oD3nfzVsmB9lpNgDwKD/yjRIpCO70xfBpuTtS6o
         c1x6wcqTB9nWcx9/m6VfZBjPlqfitXYL+kZo0J+CQLIEzSP1/I6fDGbEbMNxBuDAE/
         A8/MGLYD9UewyAGUVpGUmNBNUFBWDQenKB6l716E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 158/293] Btrfs: fix fsync not persisting dentry deletions due to inode evictions
Date:   Mon, 29 Jul 2019 21:20:49 +0200
Message-Id: <20190729190836.657261298@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 803f0f64d17769071d7287d9e3e3b79a3e1ae937 upstream.

In order to avoid searches on a log tree when unlinking an inode, we check
if the inode being unlinked was logged in the current transaction, as well
as the inode of its parent directory. When any of the inodes are logged,
we proceed to delete directory items and inode reference items from the
log, to ensure that if a subsequent fsync of only the inode being unlinked
or only of the parent directory when the other is not fsync'ed as well,
does not result in the entry still existing after a power failure.

That check however is not reliable when one of the inodes involved (the
one being unlinked or its parent directory's inode) is evicted, since the
logged_trans field is transient, that is, it is not stored on disk, so it
is lost when the inode is evicted and loaded into memory again (which is
set to zero on load). As a consequence the checks currently being done by
btrfs_del_dir_entries_in_log() and btrfs_del_inode_ref_in_log() always
return true if the inode was evicted before, regardless of the inode
having been logged or not before (and in the current transaction), this
results in the dentry being unlinked still existing after a log replay
if after the unlink operation only one of the inodes involved is fsync'ed.

Example:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/dir
  $ touch /mnt/dir/foo
  $ xfs_io -c fsync /mnt/dir/foo

  # Keep an open file descriptor on our directory while we evict inodes.
  # We just want to evict the file's inode, the directory's inode must not
  # be evicted.
  $ ( cd /mnt/dir; while true; do :; done ) &
  $ pid=$!

  # Wait a bit to give time to background process to chdir to our test
  # directory.
  $ sleep 0.5

  # Trigger eviction of the file's inode.
  $ echo 2 > /proc/sys/vm/drop_caches

  # Unlink our file and fsync the parent directory. After a power failure
  # we don't expect to see the file anymore, since we fsync'ed the parent
  # directory.
  $ rm -f $SCRATCH_MNT/dir/foo
  $ xfs_io -c fsync /mnt/dir

  <power failure>

  $ mount /dev/sdb /mnt
  $ ls /mnt/dir
  foo
  $
   --> file still there, unlink not persisted despite explicit fsync on dir

Fix this by checking if the inode has the full_sync bit set in its runtime
flags as well, since that bit is set everytime an inode is loaded from
disk, or for other less common cases such as after a shrinking truncate
or failure to allocate extent maps for holes, and gets cleared after the
first fsync. Also consider the inode as possibly logged only if it was
last modified in the current transaction (besides having the full_fsync
flag set).

Fixes: 3a5f1d458ad161 ("Btrfs: Optimize btree walking while logging inodes")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3153,6 +3153,30 @@ int btrfs_free_log_root_tree(struct btrf
 }
 
 /*
+ * Check if an inode was logged in the current transaction. We can't always rely
+ * on an inode's logged_trans value, because it's an in-memory only field and
+ * therefore not persisted. This means that its value is lost if the inode gets
+ * evicted and loaded again from disk (in which case it has a value of 0, and
+ * certainly it is smaller then any possible transaction ID), when that happens
+ * the full_sync flag is set in the inode's runtime flags, so on that case we
+ * assume eviction happened and ignore the logged_trans value, assuming the
+ * worst case, that the inode was logged before in the current transaction.
+ */
+static bool inode_logged(struct btrfs_trans_handle *trans,
+			 struct btrfs_inode *inode)
+{
+	if (inode->logged_trans == trans->transid)
+		return true;
+
+	if (inode->last_trans == trans->transid &&
+	    test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags) &&
+	    !test_bit(BTRFS_FS_LOG_RECOVERING, &trans->fs_info->flags))
+		return true;
+
+	return false;
+}
+
+/*
  * If both a file and directory are logged, and unlinks or renames are
  * mixed in, we have a few interesting corners:
  *
@@ -3186,7 +3210,7 @@ int btrfs_del_dir_entries_in_log(struct
 	int bytes_del = 0;
 	u64 dir_ino = btrfs_ino(dir);
 
-	if (dir->logged_trans < trans->transid)
+	if (!inode_logged(trans, dir))
 		return 0;
 
 	ret = join_running_log_trans(root);
@@ -3291,7 +3315,7 @@ int btrfs_del_inode_ref_in_log(struct bt
 	u64 index;
 	int ret;
 
-	if (inode->logged_trans < trans->transid)
+	if (!inode_logged(trans, inode))
 		return 0;
 
 	ret = join_running_log_trans(root);


