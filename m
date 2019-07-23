Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304CF717AC
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbfGWMCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:02:42 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:35495 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728240AbfGWMCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:02:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A385A560;
        Tue, 23 Jul 2019 08:02:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=I1yl01
        +swWCTyF8l7HLntLvoSK4SodUuY/yVf07nZog=; b=uc8o2QgwjQGAK+chnaK69b
        wuAb2JCO7OQarjOonWf9/+tDS6UYrLLI+aWThvKCF5PaEIGun3yRpIrmUQjnFeyw
        R9nWtYqApl4UWbJkpVM9FOhmFdJJkNFv/J0Eah6lqqmauH8p1LcJftu8sI4PEW2R
        fHCS+LodI9Ok+zhtetS6VpvAX7EEoztQllT+YwFYsuvH9WpEuSnsGAfs9y6aaGg3
        g/efbXASoaFJnBQNnuSsAgpnuzRoodvb5YbiLYNRPe5cTgEwmxOGWNZAwbwV0zxX
        CKrCXmxzvXeEVKXX6XPjwClQeskcbRbzl/oWd6jlugsXfMmuzlnWs0mkgLwsbzKg
        ==
X-ME-Sender: <xms:Yfc2XSv5hypw7mfLHvUoBIWowMMMJNd0jm2T05NJme0Ygi94LPfIIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepvghvihgtthgvugdrtggunecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Yfc2Xc0WeN5w2ANhtxUuhBMtRhZETyjsa39C7Xwng35jh84TCGeYAA>
    <xmx:Yfc2XaPlvTvpUlM8T2SvKO8nxXq2U869PygalB4O2UZZvxYi0UysLw>
    <xmx:Yfc2XSXKrzyw88_hpXT4YzFBqINWgjbCBJwkE-p2d9vybQ_izli8iw>
    <xmx:Yfc2XRmVOuEeKogXJeQDwXp0hAduTC3LhudlWdMAf_c_zTIOIZWaEw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C28D8380087;
        Tue, 23 Jul 2019 08:02:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix fsync not persisting dentry deletions due to inode" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:02:39 +0200
Message-ID: <156388335950117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 803f0f64d17769071d7287d9e3e3b79a3e1ae937 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 19 Jun 2019 13:05:39 +0100
Subject: [PATCH] Btrfs: fix fsync not persisting dentry deletions due to inode
 evictions

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

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4a04659fded7..6c8297bcfeb7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3322,6 +3322,30 @@ int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+/*
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
 /*
  * If both a file and directory are logged, and unlinks or renames are
  * mixed in, we have a few interesting corners:
@@ -3356,7 +3380,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	int bytes_del = 0;
 	u64 dir_ino = btrfs_ino(dir);
 
-	if (dir->logged_trans < trans->transid)
+	if (!inode_logged(trans, dir))
 		return 0;
 
 	ret = join_running_log_trans(root);
@@ -3460,7 +3484,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 	u64 index;
 	int ret;
 
-	if (inode->logged_trans < trans->transid)
+	if (!inode_logged(trans, inode))
 		return 0;
 
 	ret = join_running_log_trans(root);

