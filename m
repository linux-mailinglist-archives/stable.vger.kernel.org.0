Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0673BB149
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhGDXLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231430AbhGDXKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07C676162A;
        Sun,  4 Jul 2021 23:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440067;
        bh=ilPjEFfiAZ3jvYkthYuphl5iUL23I3oIJgCJZMgGy+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfndX2eOYN6TPjsV3V00wVCRX8QasqOzQCiFjEUGQ8FhrdlWA20lJgCWcb1rVrmcT
         WKHxmRZS9f3zSrehuo3I7rsguUdDmz5n2wnBb44nqAR1uqR+Y+QISZVqmUHcdsLIfA
         CXs7VBfW/fKAO0TyBDA7frxw38/JNV1oJHnSlnRQtuCudycnJSMmjX6tEgmAhdsfkg
         ajuHSKUkuQHBNxTIIivgxAtmIndfkAk834dGJ0hEUnw/tr5qdlwkeIiRcw6Umqsda8
         XdOL8yOJr4ITXHpyrEqkD+zi/WsX3iU2qTzbIOWvfrPXcBKMErceb7gjLe+VtXRMLW
         4GABtCDdrDoZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 68/80] btrfs: always abort the transaction if we abort a trans handle
Date:   Sun,  4 Jul 2021 19:06:04 -0400
Message-Id: <20210704230616.1489200-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index f43ce82a6aed..8f48553d861e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1498,7 +1498,6 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		       trans->transid, fs_info->generation);
 
 	if (!should_cow_block(trans, root, buf)) {
-		trans->dirty = true;
 		*cow_ret = buf;
 		return 0;
 	}
@@ -2670,10 +2669,8 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
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
index 27c368007481..1cde6f84f145 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4799,7 +4799,6 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		set_extent_dirty(&trans->transaction->dirty_pages, buf->start,
 			 buf->start + buf->len - 1, GFP_NOFS);
 	}
-	trans->dirty = true;
 	/* this returns a buffer locked for blocking */
 	return buf;
 }
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f7a4ad86adee..b3b7f3066cfa 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -273,17 +273,6 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
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
index d56d3e7ca324..9f247a5543de 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2054,14 +2054,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
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

