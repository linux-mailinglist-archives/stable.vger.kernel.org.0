Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F2C38F73
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbfFGPlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730416AbfFGPlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:41:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA912146F;
        Fri,  7 Jun 2019 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922112;
        bh=hO+iJNCTBJCz8VaO3uLkaVy+9FLTW41H5opJfB9VlKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohOnnKrDzqwx+g3FhWEJJj0iWySgPvhn2K/d7QGIc99P5Tcw9wH5R76VNMfnDLQEy
         NAKKx8m4d37ChKArlm6RyugA8qPNC/DnNaK6YbYXPEVjLWdNLCs3FIjcpqgnWZ8Oxj
         QDRbMQcku2rpk1K7sW1WMTrBINB0zYx2t2ChCVSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 39/69] Btrfs: fix wrong ctime and mtime of a directory after log replay
Date:   Fri,  7 Jun 2019 17:39:20 +0200
Message-Id: <20190607153853.181498665@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 5338e43abbab13791144d37fd8846847062351c6 upstream.

When replaying a log that contains a new file or directory name that needs
to be added to its parent directory, we end up updating the mtime and the
ctime of the parent directory to the current time after we have set their
values to the correct ones (set at fsync time), efectivelly losing them.

Sample reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/dir
  $ touch /mnt/dir/file

  # fsync of the directory is optional, not needed
  $ xfs_io -c fsync /mnt/dir
  $ xfs_io -c fsync /mnt/dir/file

  $ stat -c %Y /mnt/dir
  1557856079

  <power failure>

  $ sleep 3
  $ mount /dev/sdb /mnt
  $ stat -c %Y /mnt/dir
  1557856082

    --> should have been 1557856079, the mtime is updated to the current
        time when replaying the log

Fix this by not updating the mtime and ctime to the current time at
btrfs_add_link() when we are replaying a log tree.

This could be triggered by my recent fsync fuzz tester for fstests, for
which an fstests patch exists titled "fstests: generic, fsync fuzz tester
with fsstress".

Fixes: e02119d5a7b43 ("Btrfs: Add a write ahead tree log to optimize synchronous operations")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6580,8 +6580,18 @@ int btrfs_add_link(struct btrfs_trans_ha
 	btrfs_i_size_write(parent_inode, parent_inode->vfs_inode.i_size +
 			   name_len * 2);
 	inode_inc_iversion(&parent_inode->vfs_inode);
-	parent_inode->vfs_inode.i_mtime = parent_inode->vfs_inode.i_ctime =
-		current_time(&parent_inode->vfs_inode);
+	/*
+	 * If we are replaying a log tree, we do not want to update the mtime
+	 * and ctime of the parent directory with the current time, since the
+	 * log replay procedure is responsible for setting them to their correct
+	 * values (the ones it had when the fsync was done).
+	 */
+	if (!test_bit(BTRFS_FS_LOG_RECOVERING, &root->fs_info->flags)) {
+		struct timespec64 now = current_time(&parent_inode->vfs_inode);
+
+		parent_inode->vfs_inode.i_mtime = now;
+		parent_inode->vfs_inode.i_ctime = now;
+	}
 	ret = btrfs_update_inode(trans, root, &parent_inode->vfs_inode);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);


