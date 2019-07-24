Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F31A73E69
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbfGXTkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390039AbfGXTkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:40:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F246C20665;
        Wed, 24 Jul 2019 19:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997235;
        bh=nVQ1M0dbv2cOYIrNGrKn3lrQsBhUZGa8T2INGbV6e4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNXxMZmijC15wszZ07g3clv7RkIE8j0cpRLVeBvTeCrDzhYiFjpqs8lacNmk05OcN
         GnXfcnnZzs2CJBFAokSG+l2cHcA61sjULG/TyseK+MSEjE+0xsDEKf7LsMwIbQ6Nm9
         ILS99oztSDI/VJozXT4+EXQVuj2JziLjLuwlxZOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.2 368/413] Btrfs: fix data loss after inode eviction, renaming it, and fsync it
Date:   Wed, 24 Jul 2019 21:20:59 +0200
Message-Id: <20190724191801.694153432@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit d1d832a0b51dd9570429bb4b81b2a6c1759e681a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5420,9 +5420,19 @@ log_extents:
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


