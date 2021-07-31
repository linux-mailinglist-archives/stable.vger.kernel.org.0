Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375043DC3FD
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 08:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhGaGcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 02:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhGaGcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 02:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 623FF60F48;
        Sat, 31 Jul 2021 06:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627713129;
        bh=+Kjb0CFabFxKRINNLwf8VNnxXNLoqBuCSutNMDquIX4=;
        h=Subject:To:Cc:From:Date:From;
        b=r8nPC5jiiturZzUV0PB6bl17yPwKGNz0gsYrmpAZuhjJt9PtkOXW0RS41Ung/j+7K
         IejIuezHo0X2HWyjE3FBIgOyhzNT38+OGSN4UW1YOW4FuH5k7e6RIu+OUi6+iZXMY0
         LOUv2U6RNa0Y986hnN6hwP0T6eBfHokpFSk//A6k=
Subject: FAILED: patch "[PATCH] btrfs: fix lost inode on log replay after mix of fsync," failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 31 Jul 2021 08:32:06 +0200
Message-ID: <162771312610124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ecc64fab7d49c678e70bd4c35fe64d2ab3e3d212 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Tue, 27 Jul 2021 11:24:43 +0100
Subject: [PATCH] btrfs: fix lost inode on log replay after mix of fsync,
 rename and inode eviction

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

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9fd0348be7f5..e6430ac9bbe8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6503,8 +6503,8 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	 * if this inode hasn't been logged and directory we're renaming it
 	 * from hasn't been logged, we don't need to log it
 	 */
-	if (inode->logged_trans < trans->transid &&
-	    (!old_dir || old_dir->logged_trans < trans->transid))
+	if (!inode_logged(trans, inode) &&
+	    (!old_dir || !inode_logged(trans, old_dir)))
 		return;
 
 	/*

