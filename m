Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633CB39127
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbfFGPnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:43:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbfFGPnh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:43:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9777A21473;
        Fri,  7 Jun 2019 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922216;
        bh=pnU+Lf3kI2WSsZldZdx5XR1IFl4gnqlqMfCRXrD/kqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jo6Q+qRmGc6oaZ60jrZeRlCdJ6xnTQNX9ofIps6bxSeLq7JdHdxYwRnr48r47uQMh
         vSmpTALXXb7WqeECQsSndJnB4fAlQSMmDYh1OaTpL2M+s9/x6RoG1Do8K7jGoguMTb
         XgNfCdI3UqSi6WoJxq9PYglBYvE9gI+5nWiX8NBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 41/69] Btrfs: fix fsync not persisting changed attributes of a directory
Date:   Fri,  7 Jun 2019 17:39:22 +0200
Message-Id: <20190607153853.433360699@linuxfoundation.org>
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

commit 60d9f50308e5df19bc18c2fefab0eba4a843900a upstream.

While logging an inode we follow its ancestors and for each one we mark
it as logged in the current transaction, even if we have not logged it.
As a consequence if we change an attribute of an ancestor, such as the
UID or GID for example, and then explicitly fsync it, we end up not
logging the inode at all despite returning success to user space, which
results in the attribute being lost if a power failure happens after
the fsync.

Sample reproducer:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /mnt

  $ mkdir /mnt/dir
  $ chown 6007:6007 /mnt/dir

  $ sync

  $ chown 9003:9003 /mnt/dir
  $ touch /mnt/dir/file
  $ xfs_io -c fsync /mnt/dir/file

  # fsync our directory after fsync'ing the new file, should persist the
  # new values for the uid and gid.
  $ xfs_io -c fsync /mnt/dir

  <power failure>

  $ mount /dev/sdb /mnt
  $ stat -c %u:%g /mnt/dir
  6007:6007

    --> should be 9003:9003, the uid and gid were not persisted, despite
        the explicit fsync on the directory prior to the power failure

Fix this by not updating the logged_trans field of ancestor inodes when
logging an inode, since we have not logged them. Let only future calls to
btrfs_log_inode() to mark inodes as logged.

This could be triggered by my recent fsync fuzz tester for fstests, for
which an fstests patch exists titled "fstests: generic, fsync fuzz tester
with fsstress".

Fixes: 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5332,7 +5332,6 @@ static noinline int check_parent_dirs_fo
 {
 	int ret = 0;
 	struct dentry *old_parent = NULL;
-	struct btrfs_inode *orig_inode = inode;
 
 	/*
 	 * for regular files, if its inode is already on disk, we don't
@@ -5352,16 +5351,6 @@ static noinline int check_parent_dirs_fo
 	}
 
 	while (1) {
-		/*
-		 * If we are logging a directory then we start with our inode,
-		 * not our parent's inode, so we need to skip setting the
-		 * logged_trans so that further down in the log code we don't
-		 * think this inode has already been logged.
-		 */
-		if (inode != orig_inode)
-			inode->logged_trans = trans->transid;
-		smp_mb();
-
 		if (btrfs_must_commit_transaction(trans, inode)) {
 			ret = 1;
 			break;
@@ -6091,7 +6080,6 @@ void btrfs_record_unlink_dir(struct btrf
 	 * if this directory was already logged any new
 	 * names for this file/dir will get recorded
 	 */
-	smp_mb();
 	if (dir->logged_trans == trans->transid)
 		return;
 


