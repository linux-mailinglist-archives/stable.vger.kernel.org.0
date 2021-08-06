Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBA13E2556
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243161AbhHFITm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244024AbhHFISS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:18:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C05AE611EF;
        Fri,  6 Aug 2021 08:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237882;
        bh=gDam2yPuJeNbhIfpl/uTCptDWHlUU7MVSIE+t+pDmyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2dgIEujP78sWdXiz0nhYiJU5vUeALAWREO8m9I2zPU8dXkZQzHa6v6iEUFkpu+ry1
         /MIGJToBBGnWmS33uMZdEgCct7vLyCt2r0nXjg26FEBoezzY9pfBVo9PVG10nGEs17
         2b6w9BHRs/Vd2Y3PxhE5bieyNemkjtlYgO1HUQCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/23] btrfs: fix lost inode on log replay after mix of fsync, rename and inode eviction
Date:   Fri,  6 Aug 2021 10:16:36 +0200
Message-Id: <20210806081112.257041336@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081112.104686873@linuxfoundation.org>
References: <20210806081112.104686873@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ecc64fab7d49c678e70bd4c35fe64d2ab3e3d212 ]

When checking if we need to log the new name of a renamed inode, we are
checking if the inode and its parent inode have been logged before, and if
not we don't log the new name. The check however is buggy, as it directly
compares the logged_trans field of the inodes versus the ID of the current
transaction. The problem is that logged_trans is a transient field, only
stored in memory and never persisted in the inode item, so if an inode
was logged before, evicted and reloaded, its logged_trans field is set to
a value of 0, meaning the check will return false and the new name of the
renamed inode is not logged. If the old parent directory was previously
fsynced and we deleted the logged directory entries corresponding to the
old name, we end up with a log that when replayed will delete the renamed
inode.

The following example triggers the problem:

  $ mkfs.btrfs -f /dev/sdc
  $ mount /dev/sdc /mnt

  $ mkdir /mnt/A
  $ mkdir /mnt/B
  $ echo -n "hello world" > /mnt/A/foo

  $ sync

  # Add some new file to A and fsync directory A.
  $ touch /mnt/A/bar
  $ xfs_io -c "fsync" /mnt/A

  # Now trigger inode eviction. We are only interested in triggering
  # eviction for the inode of directory A.
  $ echo 2 > /proc/sys/vm/drop_caches

  # Move foo from directory A to directory B.
  # This deletes the directory entries for foo in A from the log, and
  # does not add the new name for foo in directory B to the log, because
  # logged_trans of A is 0, which is less than the current transaction ID.
  $ mv /mnt/A/foo /mnt/B/foo

  # Now make an fsync to anything except A, B or any file inside them,
  # like for example create a file at the root directory and fsync this
  # new file. This syncs the log that contains all the changes done by
  # previous rename operation.
  $ touch /mnt/baz
  $ xfs_io -c "fsync" /mnt/baz

  <power fail>

  # Mount the filesystem and replay the log.
  $ mount /dev/sdc /mnt

  # Check the filesystem content.
  $ ls -1R /mnt
  /mnt/:
  A
  B
  baz

  /mnt/A:
  bar

  /mnt/B:
  $

  # File foo is gone, it's neither in A/ nor in B/.

Fix this by using the inode_logged() helper at btrfs_log_new_name(), which
safely checks if an inode was logged before in the current transaction.

A test case for fstests will follow soon.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9912b5231bcf..5412361d0c27 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6450,8 +6450,8 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	 * if this inode hasn't been logged and directory we're renaming it
 	 * from hasn't been logged, we don't need to log it
 	 */
-	if (inode->logged_trans < trans->transid &&
-	    (!old_dir || old_dir->logged_trans < trans->transid))
+	if (!inode_logged(trans, inode) &&
+	    (!old_dir || !inode_logged(trans, old_dir)))
 		return;
 
 	btrfs_init_log_ctx(&ctx, &inode->vfs_inode);
-- 
2.30.2



