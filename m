Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9502C3BB099
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhGDXJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231317AbhGDXIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA45B61283;
        Sun,  4 Jul 2021 23:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439958;
        bh=cd9MPVAVcKWtBqmTNc3Xz3ZBF/x7V6C7g63HCoEALkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=US75jrWdIJByQhqhEoTqFW5StrfZEvEss0u2tYuJmqges50BLSmvUoJ/w55omOt2C
         LXcz58BDunCZop6XP27t1xTCcPk8hmzBvKUU6hJxENyn8mNnAeAHUKDsKpaAeiHrKY
         Ygsr/CE3an/z0cIf//sFf7yK1duuuJXtxmz1m6C9/wBQxK54Kpc/c38hF+nhG+Sa1B
         T1Ni45HxMNzBCpIVnclR3vTgyFWetjwpfBbG8HK0iPEXql1lY1mSTbCwNXN27avrGK
         ry6KWZhNermm28Kjxo+5DUwtyfWcTC5wAu0RSKWHxIz9OP2cT8a9L4oL5o600h9tUo
         0xeUFsRVA7TCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 72/85] btrfs: always abort the transaction if we abort a trans handle
Date:   Sun,  4 Jul 2021 19:04:07 -0400
Message-Id: <20210704230420.1488358-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 5963ffcaf383134985a5a2d8a4baa582d3999e0a ]

While stress testing our error handling I noticed that sometimes we
would still commit the transaction even though we had aborted the
transaction.

Currently we track if a trans handle has dirtied any metadata, and if it
hasn't we mark the filesystem as having an error (so no new transactions
can be started), but we will allow the current transaction to complete
as we do not mark the transaction itself as having been aborted.

This sounds good in theory, but we were not properly tracking IO errors
in btrfs_finish_ordered_io, and thus committing the transaction with
bogus free space data.  This isn't necessarily a problem per-se with the
free space cache, as the other guards in place would have kept us from
accepting the free space cache as valid, but highlights a real world
case where we had a bug and could have corrupted the filesystem because
of it.

This "skip abort on empty trans handle" is nice in theory, but assumes
we have perfect error handling everywhere, which we clearly do not.
Also we do not allow further transactions to be started, so all this
does is save the last transaction that was happening, which doesn't
necessarily gain us anything other than the potential for real
corruption.

Remove this particular bit of code, if we decide we need to abort the
transaction then abort the current one and keep us from doing real harm
to the file system, regardless of whether this specific trans handle
dirtied anything or not.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c       |  5 +----
 fs/btrfs/extent-tree.c |  1 -
 fs/btrfs/super.c       | 11 -----------
 fs/btrfs/transaction.c |  8 --------
 fs/btrfs/transaction.h |  1 -
 5 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a484fb72a01f..4bc3ca2cbd7d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -596,7 +596,6 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		       trans->transid, fs_info->generation);
 
 	if (!should_cow_block(trans, root, buf)) {
-		trans->dirty = true;
 		*cow_ret = buf;
 		return 0;
 	}
@@ -1788,10 +1787,8 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			 * then we don't want to set the path blocking,
 			 * so we test it here
 			 */
-			if (!should_cow_block(trans, root, b)) {
-				trans->dirty = true;
+			if (!should_cow_block(trans, root, b))
 				goto cow_done;
-			}
 
 			/*
 			 * must have write locks on this node and the
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d5c35e4cb76..d2f39a122d89 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4784,7 +4784,6 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		set_extent_dirty(&trans->transaction->dirty_pages, buf->start,
 			 buf->start + buf->len - 1, GFP_NOFS);
 	}
-	trans->dirty = true;
 	/* this returns a buffer locked for blocking */
 	return buf;
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4a396c1147f1..bc613218c8c5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -299,17 +299,6 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 
 	WRITE_ONCE(trans->aborted, errno);
-	/* Nothing used. The other threads that have joined this
-	 * transaction may be able to continue. */
-	if (!trans->dirty && list_empty(&trans->new_bgs)) {
-		const char *errstr;
-
-		errstr = btrfs_decode_error(errno);
-		btrfs_warn(fs_info,
-		           "%s:%d: Aborting unused transaction(%s).",
-		           function, line, errstr);
-		return;
-	}
 	WRITE_ONCE(trans->transaction->aborted, errno);
 	/* Wake up anybody who may be waiting on this transaction */
 	wake_up(&fs_info->transaction_wait);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f75de9f6c0ad..e0a82aa7da89 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2074,14 +2074,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	ASSERT(refcount_read(&trans->use_count) == 1);
 
-	/*
-	 * Some places just start a transaction to commit it.  We need to make
-	 * sure that if this commit fails that the abort code actually marks the
-	 * transaction as failed, so set trans->dirty to make the abort code do
-	 * the right thing.
-	 */
-	trans->dirty = true;
-
 	/* Stop the commit early if ->aborted is set */
 	if (TRANS_ABORTED(cur_trans)) {
 		ret = cur_trans->aborted;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 364cfbb4c5c5..c49e2266b28b 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -143,7 +143,6 @@ struct btrfs_trans_handle {
 	bool allocating_chunk;
 	bool can_flush_pending_bgs;
 	bool reloc_reserved;
-	bool dirty;
 	bool in_fsync;
 	struct btrfs_root *root;
 	struct btrfs_fs_info *fs_info;
-- 
2.30.2

