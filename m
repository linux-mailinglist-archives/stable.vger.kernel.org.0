Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BA24D835D
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbiCNMOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241347AbiCNMNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:13:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2438536E2B;
        Mon, 14 Mar 2022 05:11:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 456F46135F;
        Mon, 14 Mar 2022 12:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9115EC340E9;
        Mon, 14 Mar 2022 12:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259866;
        bh=8wtbnNeUuFbn++QNfVbS9PJIy2zwc+65i1EM+o/9WvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAevZ+D+XV4fQTpzqnV2oh0dANisNW6I8Apq6rksShMeHj20VUZZiuz3WjUJWXZQe
         HJIvtv5EfH5cZtq+SZVCTjMilzZb+nZGch5CucOILLCTcdxyuRZ3+Z/SR9lWdx52Cb
         ctbN3XCjaUu4UKTvU7S168hDNWCnXbQcKvp06GbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.15 106/110] btrfs: make send work with concurrent block group relocation
Date:   Mon, 14 Mar 2022 12:54:48 +0100
Message-Id: <20220314112745.985387896@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit d96b34248c2f4ea8cd09286090f2f6f77102eaab upstream.

We don't allow send and balance/relocation to run in parallel in order
to prevent send failing or silently producing some bad stream. This is
because while send is using an extent (specially metadata) or about to
read a metadata extent and expecting it belongs to a specific parent
node, relocation can run, the transaction used for the relocation is
committed and the extent gets reallocated while send is still using the
extent, so it ends up with a different content than expected. This can
result in just failing to read a metadata extent due to failure of the
validation checks (parent transid, level, etc), failure to find a
backreference for a data extent, and other unexpected failures. Besides
reallocation, there's also a similar problem of an extent getting
discarded when it's unpinned after the transaction used for block group
relocation is committed.

The restriction between balance and send was added in commit 9e967495e0e0
("Btrfs: prevent send failures and crashes due to concurrent relocation"),
kernel 5.3, while the more general restriction between send and relocation
was added in commit 1cea5cf0e664 ("btrfs: ensure relocation never runs
while we have send operations running"), kernel 5.14.

Both send and relocation can be very long running operations. Relocation
because it has to do a lot of IO and expensive backreference lookups in
case there are many snapshots, and send due to read IO when operating on
very large trees. This makes it inconvenient for users and tools to deal
with scheduling both operations.

For zoned filesystem we also have automatic block group relocation, so
send can fail with -EAGAIN when users least expect it or send can end up
delaying the block group relocation for too long. In the future we might
also get the automatic block group relocation for non zoned filesystems.

This change makes it possible for send and relocation to run in parallel.
This is achieved the following way:

1) For all tree searches, send acquires a read lock on the commit root
   semaphore;

2) After each tree search, and before releasing the commit root semaphore,
   the leaf is cloned and placed in the search path (struct btrfs_path);

3) After releasing the commit root semaphore, the changed_cb() callback
   is invoked, which operates on the leaf and writes commands to the pipe
   (or file in case send/receive is not used with a pipe). It's important
   here to not hold a lock on the commit root semaphore, because if we did
   we could deadlock when sending and receiving to the same filesystem
   using a pipe - the send task blocks on the pipe because it's full, the
   receive task, which is the only consumer of the pipe, triggers a
   transaction commit when attempting to create a subvolume or reserve
   space for a write operation for example, but the transaction commit
   blocks trying to write lock the commit root semaphore, resulting in a
   deadlock;

4) Before moving to the next key, or advancing to the next change in case
   of an incremental send, check if a transaction used for relocation was
   committed (or is about to finish its commit). If so, release the search
   path(s) and restart the search, to where we were before, so that we
   don't operate on stale extent buffers. The search restarts are always
   possible because both the send and parent roots are RO, and no one can
   add, remove of update keys (change their offset) in RO trees - the
   only exception is deduplication, but that is still not allowed to run
   in parallel with send;

5) Periodically check if there is contention on the commit root semaphore,
   which means there is a transaction commit trying to write lock it, and
   release the semaphore and reschedule if there is contention, so as to
   avoid causing any significant delays to transaction commits.

This leaves some room for optimizations for send to have less path
releases and re searching the trees when there's relocation running, but
for now it's kept simple as it performs quite well (on very large trees
with resulting send streams in the order of a few hundred gigabytes).

Test case btrfs/187, from fstests, stresses relocation, send and
deduplication attempting to run in parallel, but without verifying if send
succeeds and if it produces correct streams. A new test case will be added
that exercises relocation happening in parallel with send and then checks
that send succeeds and the resulting streams are correct.

A final note is that for now this still leaves the mutual exclusion
between send operations and deduplication on files belonging to a root
used by send operations. A solution for that will be slightly more complex
but it will eventually be built on top of this change.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    9 -
 fs/btrfs/ctree.c       |   98 ++++++++++---
 fs/btrfs/ctree.h       |   14 -
 fs/btrfs/disk-io.c     |    4 
 fs/btrfs/relocation.c  |   13 -
 fs/btrfs/send.c        |  357 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/transaction.c |    4 
 7 files changed, 395 insertions(+), 104 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1491,7 +1491,6 @@ void btrfs_reclaim_bgs_work(struct work_
 		container_of(work, struct btrfs_fs_info, reclaim_bgs_work);
 	struct btrfs_block_group *bg;
 	struct btrfs_space_info *space_info;
-	LIST_HEAD(again_list);
 
 	if (!test_bit(BTRFS_FS_OPEN, &fs_info->flags))
 		return;
@@ -1562,18 +1561,14 @@ void btrfs_reclaim_bgs_work(struct work_
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
-		if (ret && ret != -EAGAIN)
+		if (ret)
 			btrfs_err(fs_info, "error relocating chunk %llu",
 				  bg->start);
 
 next:
+		btrfs_put_block_group(bg);
 		spin_lock(&fs_info->unused_bgs_lock);
-		if (ret == -EAGAIN && list_empty(&bg->bg_list))
-			list_add_tail(&bg->bg_list, &again_list);
-		else
-			btrfs_put_block_group(bg);
 	}
-	list_splice_tail(&again_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 	btrfs_exclop_finish(fs_info);
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1566,32 +1566,13 @@ static struct extent_buffer *btrfs_searc
 							struct btrfs_path *p,
 							int write_lock_level)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *b;
 	int root_lock = 0;
 	int level = 0;
 
 	if (p->search_commit_root) {
-		/*
-		 * The commit roots are read only so we always do read locks,
-		 * and we always must hold the commit_root_sem when doing
-		 * searches on them, the only exception is send where we don't
-		 * want to block transaction commits for a long time, so
-		 * we need to clone the commit root in order to avoid races
-		 * with transaction commits that create a snapshot of one of
-		 * the roots used by a send operation.
-		 */
-		if (p->need_commit_sem) {
-			down_read(&fs_info->commit_root_sem);
-			b = btrfs_clone_extent_buffer(root->commit_root);
-			up_read(&fs_info->commit_root_sem);
-			if (!b)
-				return ERR_PTR(-ENOMEM);
-
-		} else {
-			b = root->commit_root;
-			atomic_inc(&b->refs);
-		}
+		b = root->commit_root;
+		atomic_inc(&b->refs);
 		level = btrfs_header_level(b);
 		/*
 		 * Ensure that all callers have set skip_locking when
@@ -1657,6 +1638,42 @@ out:
 	return b;
 }
 
+/*
+ * Replace the extent buffer at the lowest level of the path with a cloned
+ * version. The purpose is to be able to use it safely, after releasing the
+ * commit root semaphore, even if relocation is happening in parallel, the
+ * transaction used for relocation is committed and the extent buffer is
+ * reallocated in the next transaction.
+ *
+ * This is used in a context where the caller does not prevent transaction
+ * commits from happening, either by holding a transaction handle or holding
+ * some lock, while it's doing searches through a commit root.
+ * At the moment it's only used for send operations.
+ */
+static int finish_need_commit_sem_search(struct btrfs_path *path)
+{
+	const int i = path->lowest_level;
+	const int slot = path->slots[i];
+	struct extent_buffer *lowest = path->nodes[i];
+	struct extent_buffer *clone;
+
+	ASSERT(path->need_commit_sem);
+
+	if (!lowest)
+		return 0;
+
+	lockdep_assert_held_read(&lowest->fs_info->commit_root_sem);
+
+	clone = btrfs_clone_extent_buffer(lowest);
+	if (!clone)
+		return -ENOMEM;
+
+	btrfs_release_path(path);
+	path->nodes[i] = clone;
+	path->slots[i] = slot;
+
+	return 0;
+}
 
 /*
  * btrfs_search_slot - look for a key in a tree and perform necessary
@@ -1693,6 +1710,7 @@ int btrfs_search_slot(struct btrfs_trans
 		      const struct btrfs_key *key, struct btrfs_path *p,
 		      int ins_len, int cow)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *b;
 	int slot;
 	int ret;
@@ -1734,6 +1752,11 @@ int btrfs_search_slot(struct btrfs_trans
 
 	min_write_lock_level = write_lock_level;
 
+	if (p->need_commit_sem) {
+		ASSERT(p->search_commit_root);
+		down_read(&fs_info->commit_root_sem);
+	}
+
 again:
 	prev_cmp = -1;
 	b = btrfs_search_slot_get_root(root, p, write_lock_level);
@@ -1928,6 +1951,16 @@ cow_done:
 done:
 	if (ret < 0 && !p->skip_release_on_error)
 		btrfs_release_path(p);
+
+	if (p->need_commit_sem) {
+		int ret2;
+
+		ret2 = finish_need_commit_sem_search(p);
+		up_read(&fs_info->commit_root_sem);
+		if (ret2)
+			ret = ret2;
+	}
+
 	return ret;
 }
 ALLOW_ERROR_INJECTION(btrfs_search_slot, ERRNO);
@@ -4396,7 +4429,9 @@ int btrfs_next_old_leaf(struct btrfs_roo
 	int level;
 	struct extent_buffer *c;
 	struct extent_buffer *next;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key;
+	bool need_commit_sem = false;
 	u32 nritems;
 	int ret;
 	int i;
@@ -4413,14 +4448,20 @@ again:
 
 	path->keep_locks = 1;
 
-	if (time_seq)
+	if (time_seq) {
 		ret = btrfs_search_old_slot(root, &key, path, time_seq);
-	else
+	} else {
+		if (path->need_commit_sem) {
+			path->need_commit_sem = 0;
+			need_commit_sem = true;
+			down_read(&fs_info->commit_root_sem);
+		}
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	}
 	path->keep_locks = 0;
 
 	if (ret < 0)
-		return ret;
+		goto done;
 
 	nritems = btrfs_header_nritems(path->nodes[0]);
 	/*
@@ -4543,6 +4584,15 @@ again:
 	ret = 0;
 done:
 	unlock_up(path, 0, 1, 0, NULL);
+	if (need_commit_sem) {
+		int ret2;
+
+		path->need_commit_sem = 1;
+		ret2 = finish_need_commit_sem_search(path);
+		up_read(&fs_info->commit_root_sem);
+		if (ret2)
+			ret = ret2;
+	}
 
 	return ret;
 }
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -568,7 +568,6 @@ enum {
 	/*
 	 * Indicate that relocation of a chunk has started, it's set per chunk
 	 * and is toggled between chunks.
-	 * Set, tested and cleared while holding fs_info::send_reloc_lock.
 	 */
 	BTRFS_FS_RELOC_RUNNING,
 
@@ -668,6 +667,12 @@ struct btrfs_fs_info {
 
 	u64 generation;
 	u64 last_trans_committed;
+	/*
+	 * Generation of the last transaction used for block group relocation
+	 * since the filesystem was last mounted (or 0 if none happened yet).
+	 * Must be written and read while holding btrfs_fs_info::commit_root_sem.
+	 */
+	u64 last_reloc_trans;
 	u64 avg_delayed_ref_runtime;
 
 	/*
@@ -997,13 +1002,6 @@ struct btrfs_fs_info {
 
 	struct crypto_shash *csum_shash;
 
-	spinlock_t send_reloc_lock;
-	/*
-	 * Number of send operations in progress.
-	 * Updated while holding fs_info::send_reloc_lock.
-	 */
-	int send_in_progress;
-
 	/* Type of exclusive operation running, protected by super_lock */
 	enum btrfs_exclusive_operation exclusive_operation;
 
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2859,6 +2859,7 @@ static int __cold init_tree_roots(struct
 		/* All successful */
 		fs_info->generation = generation;
 		fs_info->last_trans_committed = generation;
+		fs_info->last_reloc_trans = 0;
 
 		/* Always begin writing backup roots after the one being used */
 		if (backup_index < 0) {
@@ -2992,9 +2993,6 @@ void btrfs_init_fs_info(struct btrfs_fs_
 	spin_lock_init(&fs_info->swapfile_pins_lock);
 	fs_info->swapfile_pins = RB_ROOT;
 
-	spin_lock_init(&fs_info->send_reloc_lock);
-	fs_info->send_in_progress = 0;
-
 	fs_info->bg_reclaim_threshold = BTRFS_DEFAULT_RECLAIM_THRESH;
 	INIT_WORK(&fs_info->reclaim_bgs_work, btrfs_reclaim_bgs_work);
 }
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3854,25 +3854,14 @@ out:
  *   0             success
  *   -EINPROGRESS  operation is already in progress, that's probably a bug
  *   -ECANCELED    cancellation request was set before the operation started
- *   -EAGAIN       can not start because there are ongoing send operations
  */
 static int reloc_chunk_start(struct btrfs_fs_info *fs_info)
 {
-	spin_lock(&fs_info->send_reloc_lock);
-	if (fs_info->send_in_progress) {
-		btrfs_warn_rl(fs_info,
-"cannot run relocation while send operations are in progress (%d in progress)",
-			      fs_info->send_in_progress);
-		spin_unlock(&fs_info->send_reloc_lock);
-		return -EAGAIN;
-	}
 	if (test_and_set_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags)) {
 		/* This should not happen */
-		spin_unlock(&fs_info->send_reloc_lock);
 		btrfs_err(fs_info, "reloc already running, cannot start");
 		return -EINPROGRESS;
 	}
-	spin_unlock(&fs_info->send_reloc_lock);
 
 	if (atomic_read(&fs_info->reloc_cancel_req) > 0) {
 		btrfs_info(fs_info, "chunk relocation canceled on start");
@@ -3894,9 +3883,7 @@ static void reloc_chunk_end(struct btrfs
 	/* Requested after start, clear bit first so any waiters can continue */
 	if (atomic_read(&fs_info->reloc_cancel_req) > 0)
 		btrfs_info(fs_info, "chunk relocation canceled during operation");
-	spin_lock(&fs_info->send_reloc_lock);
 	clear_and_wake_up_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags);
-	spin_unlock(&fs_info->send_reloc_lock);
 	atomic_set(&fs_info->reloc_cancel_req, 0);
 }
 
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -24,6 +24,7 @@
 #include "transaction.h"
 #include "compression.h"
 #include "xattr.h"
+#include "print-tree.h"
 
 /*
  * Maximum number of references an extent can have in order for us to attempt to
@@ -96,6 +97,15 @@ struct send_ctx {
 	struct btrfs_key *cmp_key;
 
 	/*
+	 * Keep track of the generation of the last transaction that was used
+	 * for relocating a block group. This is periodically checked in order
+	 * to detect if a relocation happened since the last check, so that we
+	 * don't operate on stale extent buffers for nodes (level >= 1) or on
+	 * stale disk_bytenr values of file extent items.
+	 */
+	u64 last_reloc_trans;
+
+	/*
 	 * infos of the currently processed inode. In case of deleted inodes,
 	 * these are the values from the deleted inode.
 	 */
@@ -1415,6 +1425,26 @@ static int find_extent_clone(struct send
 	if (ret < 0)
 		goto out;
 
+	down_read(&fs_info->commit_root_sem);
+	if (fs_info->last_reloc_trans > sctx->last_reloc_trans) {
+		/*
+		 * A transaction commit for a transaction in which block group
+		 * relocation was done just happened.
+		 * The disk_bytenr of the file extent item we processed is
+		 * possibly stale, referring to the extent's location before
+		 * relocation. So act as if we haven't found any clone sources
+		 * and fallback to write commands, which will read the correct
+		 * data from the new extent location. Otherwise we will fail
+		 * below because we haven't found our own back reference or we
+		 * could be getting incorrect sources in case the old extent
+		 * was already reallocated after the relocation.
+		 */
+		up_read(&fs_info->commit_root_sem);
+		ret = -ENOENT;
+		goto out;
+	}
+	up_read(&fs_info->commit_root_sem);
+
 	if (!backref_ctx.found_itself) {
 		/* found a bug in backref code? */
 		ret = -EIO;
@@ -6596,6 +6626,50 @@ static int changed_cb(struct btrfs_path
 {
 	int ret = 0;
 
+	/*
+	 * We can not hold the commit root semaphore here. This is because in
+	 * the case of sending and receiving to the same filesystem, using a
+	 * pipe, could result in a deadlock:
+	 *
+	 * 1) The task running send blocks on the pipe because it's full;
+	 *
+	 * 2) The task running receive, which is the only consumer of the pipe,
+	 *    is waiting for a transaction commit (for example due to a space
+	 *    reservation when doing a write or triggering a transaction commit
+	 *    when creating a subvolume);
+	 *
+	 * 3) The transaction is waiting to write lock the commit root semaphore,
+	 *    but can not acquire it since it's being held at 1).
+	 *
+	 * Down this call chain we write to the pipe through kernel_write().
+	 * The same type of problem can also happen when sending to a file that
+	 * is stored in the same filesystem - when reserving space for a write
+	 * into the file, we can trigger a transaction commit.
+	 *
+	 * Our caller has supplied us with clones of leaves from the send and
+	 * parent roots, so we're safe here from a concurrent relocation and
+	 * further reallocation of metadata extents while we are here. Below we
+	 * also assert that the leaves are clones.
+	 */
+	lockdep_assert_not_held(&sctx->send_root->fs_info->commit_root_sem);
+
+	/*
+	 * We always have a send root, so left_path is never NULL. We will not
+	 * have a leaf when we have reached the end of the send root but have
+	 * not yet reached the end of the parent root.
+	 */
+	if (left_path->nodes[0])
+		ASSERT(test_bit(EXTENT_BUFFER_UNMAPPED,
+				&left_path->nodes[0]->bflags));
+	/*
+	 * When doing a full send we don't have a parent root, so right_path is
+	 * NULL. When doing an incremental send, we may have reached the end of
+	 * the parent root already, so we don't have a leaf at right_path.
+	 */
+	if (right_path && right_path->nodes[0])
+		ASSERT(test_bit(EXTENT_BUFFER_UNMAPPED,
+				&right_path->nodes[0]->bflags));
+
 	if (result == BTRFS_COMPARE_TREE_SAME) {
 		if (key->type == BTRFS_INODE_REF_KEY ||
 		    key->type == BTRFS_INODE_EXTREF_KEY) {
@@ -6642,14 +6716,46 @@ out:
 	return ret;
 }
 
+static int search_key_again(const struct send_ctx *sctx,
+			    struct btrfs_root *root,
+			    struct btrfs_path *path,
+			    const struct btrfs_key *key)
+{
+	int ret;
+
+	if (!path->need_commit_sem)
+		lockdep_assert_held_read(&root->fs_info->commit_root_sem);
+
+	/*
+	 * Roots used for send operations are readonly and no one can add,
+	 * update or remove keys from them, so we should be able to find our
+	 * key again. The only exception is deduplication, which can operate on
+	 * readonly roots and add, update or remove keys to/from them - but at
+	 * the moment we don't allow it to run in parallel with send.
+	 */
+	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	ASSERT(ret <= 0);
+	if (ret > 0) {
+		btrfs_print_tree(path->nodes[path->lowest_level], false);
+		btrfs_err(root->fs_info,
+"send: key (%llu %u %llu) not found in %s root %llu, lowest_level %d, slot %d",
+			  key->objectid, key->type, key->offset,
+			  (root == sctx->parent_root ? "parent" : "send"),
+			  root->root_key.objectid, path->lowest_level,
+			  path->slots[path->lowest_level]);
+		return -EUCLEAN;
+	}
+
+	return ret;
+}
+
 static int full_send_tree(struct send_ctx *sctx)
 {
 	int ret;
 	struct btrfs_root *send_root = sctx->send_root;
 	struct btrfs_key key;
+	struct btrfs_fs_info *fs_info = send_root->fs_info;
 	struct btrfs_path *path;
-	struct extent_buffer *eb;
-	int slot;
 
 	path = alloc_path_for_send();
 	if (!path)
@@ -6660,6 +6766,10 @@ static int full_send_tree(struct send_ct
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
+	down_read(&fs_info->commit_root_sem);
+	sctx->last_reloc_trans = fs_info->last_reloc_trans;
+	up_read(&fs_info->commit_root_sem);
+
 	ret = btrfs_search_slot_for_read(send_root, &key, path, 1, 0);
 	if (ret < 0)
 		goto out;
@@ -6667,15 +6777,35 @@ static int full_send_tree(struct send_ct
 		goto out_finish;
 
 	while (1) {
-		eb = path->nodes[0];
-		slot = path->slots[0];
-		btrfs_item_key_to_cpu(eb, &key, slot);
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 
 		ret = changed_cb(path, NULL, &key,
 				 BTRFS_COMPARE_TREE_NEW, sctx);
 		if (ret < 0)
 			goto out;
 
+		down_read(&fs_info->commit_root_sem);
+		if (fs_info->last_reloc_trans > sctx->last_reloc_trans) {
+			sctx->last_reloc_trans = fs_info->last_reloc_trans;
+			up_read(&fs_info->commit_root_sem);
+			/*
+			 * A transaction used for relocating a block group was
+			 * committed or is about to finish its commit. Release
+			 * our path (leaf) and restart the search, so that we
+			 * avoid operating on any file extent items that are
+			 * stale, with a disk_bytenr that reflects a pre
+			 * relocation value. This way we avoid as much as
+			 * possible to fallback to regular writes when checking
+			 * if we can clone file ranges.
+			 */
+			btrfs_release_path(path);
+			ret = search_key_again(sctx, send_root, path, &key);
+			if (ret < 0)
+				goto out;
+		} else {
+			up_read(&fs_info->commit_root_sem);
+		}
+
 		ret = btrfs_next_item(send_root, path);
 		if (ret < 0)
 			goto out;
@@ -6693,6 +6823,20 @@ out:
 	return ret;
 }
 
+static int replace_node_with_clone(struct btrfs_path *path, int level)
+{
+	struct extent_buffer *clone;
+
+	clone = btrfs_clone_extent_buffer(path->nodes[level]);
+	if (!clone)
+		return -ENOMEM;
+
+	free_extent_buffer(path->nodes[level]);
+	path->nodes[level] = clone;
+
+	return 0;
+}
+
 static int tree_move_down(struct btrfs_path *path, int *level, u64 reada_min_gen)
 {
 	struct extent_buffer *eb;
@@ -6702,6 +6846,8 @@ static int tree_move_down(struct btrfs_p
 	u64 reada_max;
 	u64 reada_done = 0;
 
+	lockdep_assert_held_read(&parent->fs_info->commit_root_sem);
+
 	BUG_ON(*level == 0);
 	eb = btrfs_read_node_slot(parent, slot);
 	if (IS_ERR(eb))
@@ -6725,6 +6871,10 @@ static int tree_move_down(struct btrfs_p
 	path->nodes[*level - 1] = eb;
 	path->slots[*level - 1] = 0;
 	(*level)--;
+
+	if (*level == 0)
+		return replace_node_with_clone(path, 0);
+
 	return 0;
 }
 
@@ -6738,8 +6888,10 @@ static int tree_move_next_or_upnext(stru
 	path->slots[*level]++;
 
 	while (path->slots[*level] >= nritems) {
-		if (*level == root_level)
+		if (*level == root_level) {
+			path->slots[*level] = nritems - 1;
 			return -1;
+		}
 
 		/* move upnext */
 		path->slots[*level] = 0;
@@ -6771,14 +6923,20 @@ static int tree_advance(struct btrfs_pat
 	} else {
 		ret = tree_move_down(path, level, reada_min_gen);
 	}
-	if (ret >= 0) {
-		if (*level == 0)
-			btrfs_item_key_to_cpu(path->nodes[*level], key,
-					path->slots[*level]);
-		else
-			btrfs_node_key_to_cpu(path->nodes[*level], key,
-					path->slots[*level]);
-	}
+
+	/*
+	 * Even if we have reached the end of a tree, ret is -1, update the key
+	 * anyway, so that in case we need to restart due to a block group
+	 * relocation, we can assert that the last key of the root node still
+	 * exists in the tree.
+	 */
+	if (*level == 0)
+		btrfs_item_key_to_cpu(path->nodes[*level], key,
+				      path->slots[*level]);
+	else
+		btrfs_node_key_to_cpu(path->nodes[*level], key,
+				      path->slots[*level]);
+
 	return ret;
 }
 
@@ -6808,6 +6966,97 @@ static int tree_compare_item(struct btrf
 }
 
 /*
+ * A transaction used for relocating a block group was committed or is about to
+ * finish its commit. Release our paths and restart the search, so that we are
+ * not using stale extent buffers:
+ *
+ * 1) For levels > 0, we are only holding references of extent buffers, without
+ *    any locks on them, which does not prevent them from having been relocated
+ *    and reallocated after the last time we released the commit root semaphore.
+ *    The exception are the root nodes, for which we always have a clone, see
+ *    the comment at btrfs_compare_trees();
+ *
+ * 2) For leaves, level 0, we are holding copies (clones) of extent buffers, so
+ *    we are safe from the concurrent relocation and reallocation. However they
+ *    can have file extent items with a pre relocation disk_bytenr value, so we
+ *    restart the start from the current commit roots and clone the new leaves so
+ *    that we get the post relocation disk_bytenr values. Not doing so, could
+ *    make us clone the wrong data in case there are new extents using the old
+ *    disk_bytenr that happen to be shared.
+ */
+static int restart_after_relocation(struct btrfs_path *left_path,
+				    struct btrfs_path *right_path,
+				    const struct btrfs_key *left_key,
+				    const struct btrfs_key *right_key,
+				    int left_level,
+				    int right_level,
+				    const struct send_ctx *sctx)
+{
+	int root_level;
+	int ret;
+
+	lockdep_assert_held_read(&sctx->send_root->fs_info->commit_root_sem);
+
+	btrfs_release_path(left_path);
+	btrfs_release_path(right_path);
+
+	/*
+	 * Since keys can not be added or removed to/from our roots because they
+	 * are readonly and we do not allow deduplication to run in parallel
+	 * (which can add, remove or change keys), the layout of the trees should
+	 * not change.
+	 */
+	left_path->lowest_level = left_level;
+	ret = search_key_again(sctx, sctx->send_root, left_path, left_key);
+	if (ret < 0)
+		return ret;
+
+	right_path->lowest_level = right_level;
+	ret = search_key_again(sctx, sctx->parent_root, right_path, right_key);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * If the lowest level nodes are leaves, clone them so that they can be
+	 * safely used by changed_cb() while not under the protection of the
+	 * commit root semaphore, even if relocation and reallocation happens in
+	 * parallel.
+	 */
+	if (left_level == 0) {
+		ret = replace_node_with_clone(left_path, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (right_level == 0) {
+		ret = replace_node_with_clone(right_path, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	/*
+	 * Now clone the root nodes (unless they happen to be the leaves we have
+	 * already cloned). This is to protect against concurrent snapshotting of
+	 * the send and parent roots (see the comment at btrfs_compare_trees()).
+	 */
+	root_level = btrfs_header_level(sctx->send_root->commit_root);
+	if (root_level > 0) {
+		ret = replace_node_with_clone(left_path, root_level);
+		if (ret < 0)
+			return ret;
+	}
+
+	root_level = btrfs_header_level(sctx->parent_root->commit_root);
+	if (root_level > 0) {
+		ret = replace_node_with_clone(right_path, root_level);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
  * This function compares two trees and calls the provided callback for
  * every changed/new/deleted item it finds.
  * If shared tree blocks are encountered, whole subtrees are skipped, making
@@ -6835,10 +7084,10 @@ static int btrfs_compare_trees(struct bt
 	int right_root_level;
 	int left_level;
 	int right_level;
-	int left_end_reached;
-	int right_end_reached;
-	int advance_left;
-	int advance_right;
+	int left_end_reached = 0;
+	int right_end_reached = 0;
+	int advance_left = 0;
+	int advance_right = 0;
 	u64 left_blockptr;
 	u64 right_blockptr;
 	u64 left_gen;
@@ -6906,12 +7155,18 @@ static int btrfs_compare_trees(struct bt
 	down_read(&fs_info->commit_root_sem);
 	left_level = btrfs_header_level(left_root->commit_root);
 	left_root_level = left_level;
+	/*
+	 * We clone the root node of the send and parent roots to prevent races
+	 * with snapshot creation of these roots. Snapshot creation COWs the
+	 * root node of a tree, so after the transaction is committed the old
+	 * extent can be reallocated while this send operation is still ongoing.
+	 * So we clone them, under the commit root semaphore, to be race free.
+	 */
 	left_path->nodes[left_level] =
 			btrfs_clone_extent_buffer(left_root->commit_root);
 	if (!left_path->nodes[left_level]) {
-		up_read(&fs_info->commit_root_sem);
 		ret = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 
 	right_level = btrfs_header_level(right_root->commit_root);
@@ -6919,9 +7174,8 @@ static int btrfs_compare_trees(struct bt
 	right_path->nodes[right_level] =
 			btrfs_clone_extent_buffer(right_root->commit_root);
 	if (!right_path->nodes[right_level]) {
-		up_read(&fs_info->commit_root_sem);
 		ret = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 	/*
 	 * Our right root is the parent root, while the left root is the "send"
@@ -6931,7 +7185,6 @@ static int btrfs_compare_trees(struct bt
 	 * will need to read them at some point.
 	 */
 	reada_min_gen = btrfs_header_generation(right_root->commit_root);
-	up_read(&fs_info->commit_root_sem);
 
 	if (left_level == 0)
 		btrfs_item_key_to_cpu(left_path->nodes[left_level],
@@ -6946,11 +7199,26 @@ static int btrfs_compare_trees(struct bt
 		btrfs_node_key_to_cpu(right_path->nodes[right_level],
 				&right_key, right_path->slots[right_level]);
 
-	left_end_reached = right_end_reached = 0;
-	advance_left = advance_right = 0;
+	sctx->last_reloc_trans = fs_info->last_reloc_trans;
 
 	while (1) {
-		cond_resched();
+		if (need_resched() ||
+		    rwsem_is_contended(&fs_info->commit_root_sem)) {
+			up_read(&fs_info->commit_root_sem);
+			cond_resched();
+			down_read(&fs_info->commit_root_sem);
+		}
+
+		if (fs_info->last_reloc_trans > sctx->last_reloc_trans) {
+			ret = restart_after_relocation(left_path, right_path,
+						       &left_key, &right_key,
+						       left_level, right_level,
+						       sctx);
+			if (ret < 0)
+				goto out_unlock;
+			sctx->last_reloc_trans = fs_info->last_reloc_trans;
+		}
+
 		if (advance_left && !left_end_reached) {
 			ret = tree_advance(left_path, &left_level,
 					left_root_level,
@@ -6959,7 +7227,7 @@ static int btrfs_compare_trees(struct bt
 			if (ret == -1)
 				left_end_reached = ADVANCE;
 			else if (ret < 0)
-				goto out;
+				goto out_unlock;
 			advance_left = 0;
 		}
 		if (advance_right && !right_end_reached) {
@@ -6970,54 +7238,55 @@ static int btrfs_compare_trees(struct bt
 			if (ret == -1)
 				right_end_reached = ADVANCE;
 			else if (ret < 0)
-				goto out;
+				goto out_unlock;
 			advance_right = 0;
 		}
 
 		if (left_end_reached && right_end_reached) {
 			ret = 0;
-			goto out;
+			goto out_unlock;
 		} else if (left_end_reached) {
 			if (right_level == 0) {
+				up_read(&fs_info->commit_root_sem);
 				ret = changed_cb(left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
 						sctx);
 				if (ret < 0)
 					goto out;
+				down_read(&fs_info->commit_root_sem);
 			}
 			advance_right = ADVANCE;
 			continue;
 		} else if (right_end_reached) {
 			if (left_level == 0) {
+				up_read(&fs_info->commit_root_sem);
 				ret = changed_cb(left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
 						sctx);
 				if (ret < 0)
 					goto out;
+				down_read(&fs_info->commit_root_sem);
 			}
 			advance_left = ADVANCE;
 			continue;
 		}
 
 		if (left_level == 0 && right_level == 0) {
+			up_read(&fs_info->commit_root_sem);
 			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
 			if (cmp < 0) {
 				ret = changed_cb(left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
 						sctx);
-				if (ret < 0)
-					goto out;
 				advance_left = ADVANCE;
 			} else if (cmp > 0) {
 				ret = changed_cb(left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
 						sctx);
-				if (ret < 0)
-					goto out;
 				advance_right = ADVANCE;
 			} else {
 				enum btrfs_compare_tree_result result;
@@ -7031,11 +7300,13 @@ static int btrfs_compare_trees(struct bt
 					result = BTRFS_COMPARE_TREE_SAME;
 				ret = changed_cb(left_path, right_path,
 						 &left_key, result, sctx);
-				if (ret < 0)
-					goto out;
 				advance_left = ADVANCE;
 				advance_right = ADVANCE;
 			}
+
+			if (ret < 0)
+				goto out;
+			down_read(&fs_info->commit_root_sem);
 		} else if (left_level == right_level) {
 			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
 			if (cmp < 0) {
@@ -7075,6 +7346,8 @@ static int btrfs_compare_trees(struct bt
 		}
 	}
 
+out_unlock:
+	up_read(&fs_info->commit_root_sem);
 out:
 	btrfs_free_path(left_path);
 	btrfs_free_path(right_path);
@@ -7413,21 +7686,7 @@ long btrfs_ioctl_send(struct file *mnt_f
 	if (ret)
 		goto out;
 
-	spin_lock(&fs_info->send_reloc_lock);
-	if (test_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags)) {
-		spin_unlock(&fs_info->send_reloc_lock);
-		btrfs_warn_rl(fs_info,
-		"cannot run send because a relocation operation is in progress");
-		ret = -EAGAIN;
-		goto out;
-	}
-	fs_info->send_in_progress++;
-	spin_unlock(&fs_info->send_reloc_lock);
-
 	ret = send_subvol(sctx);
-	spin_lock(&fs_info->send_reloc_lock);
-	fs_info->send_in_progress--;
-	spin_unlock(&fs_info->send_reloc_lock);
 	if (ret < 0)
 		goto out;
 
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -163,6 +163,10 @@ static noinline void switch_commit_roots
 	struct btrfs_caching_control *caching_ctl, *next;
 
 	down_write(&fs_info->commit_root_sem);
+
+	if (test_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags))
+		fs_info->last_reloc_trans = trans->transid;
+
 	list_for_each_entry_safe(root, tmp, &cur_trans->switch_commits,
 				 dirty_list) {
 		list_del_init(&root->dirty_list);


