Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E64717A5
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387437AbfGWMCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:02:14 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:37051 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728418AbfGWMCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:02:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 16B7444D;
        Tue, 23 Jul 2019 08:02:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UknJW/
        q8zW5UJXcCCu6oAjWR65UhdaWOGZkHhCxV01E=; b=rMktKj8kauE7eHE2d69X2Z
        URKoLAslhU9M9NGBE1HF7Ob2ak/SeYIxKGx6L9lqvhGB0mxuuZNrSCGw9954wLJk
        zG7GW4nHDDOvyDCn+8dIAEyzCFAtinZeuetW0VeJPz56H+VroeqrO0npeUEyIWlK
        tmoO0pju4wrhQukG9/HAKV/a6+K0PgO1BL/kahOokvVqtZy+74nfaBwFhAc9cVKp
        13ETSTfK2lSIQCWd81INqNFh+5Rr4tmdotbvl60qkC9g3slmufK6+KGTlbVfEZbl
        0W00dQRA5KlMy+h+XBC7eRnx6CaNb1K/ineaM7C7n3TvaJKOeb6Y5vpF2L4+I+qA
        ==
X-ME-Sender: <xms:RPc2XaSAixK5nawkQ1IWxsTlddMUo3X6bxzFdANpuhN2BlXFfEmYMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinheplhhoghdrmhhvpdgtohhmmhhithdrtggunecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:RPc2XRfNdu_iiBToXSTQ1E-D8gjVB8WQTukSWsQc55JZ6Qpl3BAMyw>
    <xmx:RPc2XXSiliTByN9JCVJRxWZw4dp1NnZSrbEcVLBxeXVOHAMJll4uvQ>
    <xmx:RPc2XfoYZoosJsiwko0vcOsuOoNup1wWDSeML39YLTrBL872PU9V2A>
    <xmx:RPc2XWh-XUzg8wJy026uyoJmr7dOqqnMvIo1Daz8mZS-1wIRkOGHpg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 38C3B380079;
        Tue, 23 Jul 2019 08:02:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: fix data loss after inode eviction, renaming it, and" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:02:11 +0200
Message-ID: <15638833317473@kroah.com>
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

From d1d832a0b51dd9570429bb4b81b2a6c1759e681a Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Fri, 7 Jun 2019 11:25:24 +0100
Subject: [PATCH] Btrfs: fix data loss after inode eviction, renaming it, and
 fsync it

When we log an inode, regardless of logging it completely or only that it
exists, we always update it as logged (logged_trans and last_log_commit
fields of the inode are updated). This is generally fine and avoids future
attempts to log it from having to do repeated work that brings no value.

However, if we write data to a file, then evict its inode after all the
dealloc was flushed (and ordered extents completed), rename the file and
fsync it, we end up not logging the new extents, since the rename may
result in logging that the inode exists in case the parent directory was
logged before. The following reproducer shows and explains how this can
happen:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/dir
  $ touch /mnt/dir/foo
  $ touch /mnt/dir/bar

  # Do a direct IO write instead of a buffered write because with a
  # buffered write we would need to make sure dealloc gets flushed and
  # complete before we do the inode eviction later, and we can not do that
  # from user space with call to things such as sync(2) since that results
  # in a transaction commit as well.
  $ xfs_io -d -c "pwrite -S 0xd3 0 4K" /mnt/dir/bar

  # Keep the directory dir in use while we evict inodes. We want our file
  # bar's inode to be evicted but we don't want our directory's inode to
  # be evicted (if it were evicted too, we would not be able to reproduce
  # the issue since the first fsync below, of file foo, would result in a
  # transaction commit.
  $ ( cd /mnt/dir; while true; do :; done ) &
  $ pid=$!

  # Wait a bit to give time for the background process to chdir.
  $ sleep 0.1

  # Evict all inodes, except the inode for the directory dir because it is
  # currently in use by our background process.
  $ echo 2 > /proc/sys/vm/drop_caches

  # fsync file foo, which ends up persisting information about the parent
  # directory because it is a new inode.
  $ xfs_io -c fsync /mnt/dir/foo

  # Rename bar, this results in logging that this inode exists (inode item,
  # names, xattrs) because the parent directory is in the log.
  $ mv /mnt/dir/bar /mnt/dir/baz

  # Now fsync baz, which ends up doing absolutely nothing because of the
  # rename operation which logged that the inode exists only.
  $ xfs_io -c fsync /mnt/dir/baz

  <power failure>

  $ mount /dev/sdb /mnt
  $ od -t x1 -A d /mnt/dir/baz
  0000000

    --> Empty file, data we wrote is missing.

Fix this by not updating last_sub_trans of an inode when we are logging
only that it exists and the inode was not yet logged since it was loaded
from disk (full_sync bit set), this is enough to make btrfs_inode_in_log()
return false for this scenario and make us log the inode. The logged_trans
of the inode is still always setsince that alone is used to track if names
need to be deleted as part of unlink operations.

Fixes: 257c62e1bce03e ("Btrfs: avoid tree log commit when there are no changes")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3fc8d854d7fb..4a04659fded7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5420,9 +5420,19 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		}
 	}
 
+	/*
+	 * Don't update last_log_commit if we logged that an inode exists after
+	 * it was loaded to memory (full_sync bit set).
+	 * This is to prevent data loss when we do a write to the inode, then
+	 * the inode gets evicted after all delalloc was flushed, then we log
+	 * it exists (due to a rename for example) and then fsync it. This last
+	 * fsync would do nothing (not logging the extents previously written).
+	 */
 	spin_lock(&inode->lock);
 	inode->logged_trans = trans->transid;
-	inode->last_log_commit = inode->last_sub_trans;
+	if (inode_only != LOG_INODE_EXISTS ||
+	    !test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags))
+		inode->last_log_commit = inode->last_sub_trans;
 	spin_unlock(&inode->lock);
 out_unlock:
 	mutex_unlock(&inode->log_mutex);

