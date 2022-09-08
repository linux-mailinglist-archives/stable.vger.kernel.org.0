Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161085B188C
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 11:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiIHJXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 05:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIHJXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 05:23:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682EFE1274;
        Thu,  8 Sep 2022 02:21:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4CE9033C49;
        Thu,  8 Sep 2022 09:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662628897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A2VG5vHsiEGP63B0Q9d/H9+HI8Gv3uvL/Hswo6CwJGQ=;
        b=x2I2xbeD82gPqDQRU8uXAAJ01JViY85rQQ7ikjQ7O38aaZWXCfb7IbF4KFtGgdz3LCP/a8
        CzvAM/aY3tTM3yKdK3y5cBOupNS6LaL58CmbK76/4DwHMm5hq6rgROXWtcWV9ZXhq8/+20
        G9OnSRcaS7SBUnzAUI6mMRAi6Lw+sa4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662628897;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A2VG5vHsiEGP63B0Q9d/H9+HI8Gv3uvL/Hswo6CwJGQ=;
        b=m8m7Kn8W/gYj/zoJC3/ZCFbC5SxRAX6uN5/Rq2yJAByT/iRQP9Nke5oU6btCPlRcWoMQYd
        KRyljzUPJk/cfbCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2480F13A6D;
        Thu,  8 Sep 2022 09:21:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TlLnCCG0GWO9RAAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 08 Sep 2022 09:21:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 29E1DA0686; Thu,  8 Sep 2022 11:21:36 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 5/5] ext4: Use buckets for cr 1 block scan instead of rbtree
Date:   Thu,  8 Sep 2022 11:21:28 +0200
Message-Id: <20220908092136.11770-5-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220908091301.147-1-jack@suse.cz>
References: <20220908091301.147-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=19385; h=from:subject; bh=2CijO5Ioc5mygSaBAHtc2c3Bj+0ufzq5vi7M+QwZpC4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjGbQXSMxipUGSvkAnDjTqCmzPAMsFbDiTzXiWy+Ia mPr6R5mJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYxm0FwAKCRCcnaoHP2RA2ZF5B/ 9/FjaRaJ17ZO34aFA+cmc+kgngvxSrNwDv8h7w+vpP0OA71ui+FnFLU9Ykxit/7D9hEtkD2ezhcKjQ /8Vll0m80D8ydXM+7IVvTUXhGIb3eR3M6Sa956Yn2d9cZy4ng5XP18qxwzNaLJ/9VAKvLviDUGJQH5 vcflOAddAWHpmE2WSVv49euXz82CCPvn3pqCWeCHatIRxZtwhvImp2XsYU/n5Y/tDi4l4ji6nmEHdt wSLrI7igf+ZtCnvblmB7fHKPnPLkkdCt6KKN4Tz/k/rTjZ74foRqIZtViHJHAUtbCCbKFmd5M9/Nwa DnLP8AzFH1HF+ZfEfdWiNSyQVyaU3+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Using rbtree for sorting groups by average fragment size is relatively
expensive (needs rbtree update on every block freeing or allocation) and
leads to wide spreading of allocations because selection of block group
is very sentitive both to changes in free space and amount of blocks
allocated. Furthermore selecting group with the best matching average
fragment size is not necessary anyway, even more so because the
variability of fragment sizes within a group is likely large so average
is not telling much. We just need a group with large enough average
fragment size so that we have high probability of finding large enough
free extent and we don't want average fragment size to be too big so
that we are likely to find free extent only somewhat larger than what we
need.

So instead of maintaing rbtree of groups sorted by fragment size keep
bins (lists) or groups where average fragment size is in the interval
[2^i, 2^(i+1)). This structure requires less updates on block allocation
/ freeing, generally avoids chaotic spreading of allocations into block
groups, and still is able to quickly (even faster that the rbtree)
provide a block group which is likely to have a suitably sized free
space extent.

This patch reduces number of block groups used when untarring archive
with medium sized files (size somewhat above 64k which is default
mballoc limit for avoiding locality group preallocation) to about half
and thus improves write speeds for eMMC flash significantly.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@vger.kernel.org
Reported-and-tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |  10 +-
 fs/ext4/mballoc.c | 249 ++++++++++++++++++++--------------------------
 fs/ext4/mballoc.h |   1 -
 3 files changed, 111 insertions(+), 149 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9bca5565547b..3bf9a6926798 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -167,8 +167,6 @@ enum SHIFT_DIRECTION {
 #define EXT4_MB_CR0_OPTIMIZED		0x8000
 /* Avg fragment size rb tree lookup succeeded at least once for cr = 1 */
 #define EXT4_MB_CR1_OPTIMIZED		0x00010000
-/* Perform linear traversal for one group */
-#define EXT4_MB_SEARCH_NEXT_LINEAR	0x00020000
 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
 	struct inode *inode;
@@ -1600,8 +1598,8 @@ struct ext4_sb_info {
 	struct list_head s_discard_list;
 	struct work_struct s_discard_work;
 	atomic_t s_retry_alloc_pending;
-	struct rb_root s_mb_avg_fragment_size_root;
-	rwlock_t s_mb_rb_lock;
+	struct list_head *s_mb_avg_fragment_size;
+	rwlock_t *s_mb_avg_fragment_size_locks;
 	struct list_head *s_mb_largest_free_orders;
 	rwlock_t *s_mb_largest_free_orders_locks;
 
@@ -3413,6 +3411,8 @@ struct ext4_group_info {
 	ext4_grpblk_t	bb_first_free;	/* first free block */
 	ext4_grpblk_t	bb_free;	/* total free blocks */
 	ext4_grpblk_t	bb_fragments;	/* nr of freespace fragments */
+	int		bb_avg_fragment_size_order;	/* order of average
+							   fragment in BG */
 	ext4_grpblk_t	bb_largest_free_order;/* order of largest frag in BG */
 	ext4_group_t	bb_group;	/* Group number */
 	struct          list_head bb_prealloc_list;
@@ -3420,7 +3420,7 @@ struct ext4_group_info {
 	void            *bb_bitmap;
 #endif
 	struct rw_semaphore alloc_sem;
-	struct rb_node	bb_avg_fragment_size_rb;
+	struct list_head bb_avg_fragment_size_node;
 	struct list_head bb_largest_free_order_node;
 	ext4_grpblk_t	bb_counters[];	/* Nr of free power-of-two-block
 					 * regions, index is order.
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index af1e49c3603f..31873af0421b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -140,13 +140,15 @@
  *    number of buddy bitmap orders possible) number of lists. Group-infos are
  *    placed in appropriate lists.
  *
- * 2) Average fragment size rb tree (sbi->s_mb_avg_fragment_size_root)
+ * 2) Average fragment size lists (sbi->s_mb_avg_fragment_size)
  *
- *    Locking: sbi->s_mb_rb_lock (rwlock)
+ *    Locking: sbi->s_mb_avg_fragment_size_locks(array of rw locks)
  *
- *    This is a red black tree consisting of group infos and the tree is sorted
- *    by average fragment sizes (which is calculated as ext4_group_info->bb_free
- *    / ext4_group_info->bb_fragments).
+ *    This is an array of lists where in the i-th list there are groups with
+ *    average fragment size >= 2^i and < 2^(i+1). The average fragment size
+ *    is computed as ext4_group_info->bb_free / ext4_group_info->bb_fragments.
+ *    Note that we don't bother with a special list for completely empty groups
+ *    so we only have MB_NUM_ORDERS(sb) lists.
  *
  * When "mb_optimize_scan" mount option is set, mballoc consults the above data
  * structures to decide the order in which groups are to be traversed for
@@ -160,7 +162,8 @@
  *
  * At CR = 1, we only consider groups where average fragment size > request
  * size. So, we lookup a group which has average fragment size just above or
- * equal to request size using our rb tree (data structure 2) in O(log N) time.
+ * equal to request size using our average fragment size group lists (data
+ * structure 2) in O(1) time.
  *
  * If "mb_optimize_scan" mount option is not set, mballoc traverses groups in
  * linear order which requires O(N) search time for each CR 0 and CR 1 phase.
@@ -802,65 +805,51 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 	}
 }
 
-static void ext4_mb_rb_insert(struct rb_root *root, struct rb_node *new,
-			int (*cmp)(struct rb_node *, struct rb_node *))
+static int mb_avg_fragment_size_order(struct super_block *sb, ext4_grpblk_t len)
 {
-	struct rb_node **iter = &root->rb_node, *parent = NULL;
+	int order;
 
-	while (*iter) {
-		parent = *iter;
-		if (cmp(new, *iter) > 0)
-			iter = &((*iter)->rb_left);
-		else
-			iter = &((*iter)->rb_right);
-	}
-
-	rb_link_node(new, parent, iter);
-	rb_insert_color(new, root);
-}
-
-static int
-ext4_mb_avg_fragment_size_cmp(struct rb_node *rb1, struct rb_node *rb2)
-{
-	struct ext4_group_info *grp1 = rb_entry(rb1,
-						struct ext4_group_info,
-						bb_avg_fragment_size_rb);
-	struct ext4_group_info *grp2 = rb_entry(rb2,
-						struct ext4_group_info,
-						bb_avg_fragment_size_rb);
-	int num_frags_1, num_frags_2;
-
-	num_frags_1 = grp1->bb_fragments ?
-		grp1->bb_free / grp1->bb_fragments : 0;
-	num_frags_2 = grp2->bb_fragments ?
-		grp2->bb_free / grp2->bb_fragments : 0;
-
-	return (num_frags_2 - num_frags_1);
+	/*
+	 * We don't bother with a special lists groups with only 1 block free
+	 * extents and for completely empty groups.
+	 */
+	order = fls(len) - 2;
+	if (order < 0)
+		return 0;
+	if (order == MB_NUM_ORDERS(sb))
+		order--;
+	return order;
 }
 
-/*
- * Reinsert grpinfo into the avg_fragment_size tree with new average
- * fragment size.
- */
+/* Move group to appropriate avg_fragment_size list */
 static void
 mb_update_avg_fragment_size(struct super_block *sb, struct ext4_group_info *grp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int new_order;
 
 	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_free == 0)
 		return;
 
-	write_lock(&sbi->s_mb_rb_lock);
-	if (!RB_EMPTY_NODE(&grp->bb_avg_fragment_size_rb)) {
-		rb_erase(&grp->bb_avg_fragment_size_rb,
-				&sbi->s_mb_avg_fragment_size_root);
-		RB_CLEAR_NODE(&grp->bb_avg_fragment_size_rb);
-	}
+	new_order = mb_avg_fragment_size_order(sb,
+					grp->bb_free / grp->bb_fragments);
+	if (new_order == grp->bb_avg_fragment_size_order)
+		return;
 
-	ext4_mb_rb_insert(&sbi->s_mb_avg_fragment_size_root,
-		&grp->bb_avg_fragment_size_rb,
-		ext4_mb_avg_fragment_size_cmp);
-	write_unlock(&sbi->s_mb_rb_lock);
+	if (grp->bb_avg_fragment_size_order != -1) {
+		write_lock(&sbi->s_mb_avg_fragment_size_locks[
+					grp->bb_avg_fragment_size_order]);
+		list_del(&grp->bb_avg_fragment_size_node);
+		write_unlock(&sbi->s_mb_avg_fragment_size_locks[
+					grp->bb_avg_fragment_size_order]);
+	}
+	grp->bb_avg_fragment_size_order = new_order;
+	write_lock(&sbi->s_mb_avg_fragment_size_locks[
+					grp->bb_avg_fragment_size_order]);
+	list_add_tail(&grp->bb_avg_fragment_size_node,
+		&sbi->s_mb_avg_fragment_size[grp->bb_avg_fragment_size_order]);
+	write_unlock(&sbi->s_mb_avg_fragment_size_locks[
+					grp->bb_avg_fragment_size_order]);
 }
 
 /*
@@ -909,86 +898,56 @@ static void ext4_mb_choose_next_group_cr0(struct ext4_allocation_context *ac,
 		*new_cr = 1;
 	} else {
 		*group = grp->bb_group;
-		ac->ac_last_optimal_group = *group;
 		ac->ac_flags |= EXT4_MB_CR0_OPTIMIZED;
 	}
 }
 
 /*
- * Choose next group by traversing average fragment size tree. Updates *new_cr
- * if cr lvel needs an update. Sets EXT4_MB_SEARCH_NEXT_LINEAR to indicate that
- * the linear search should continue for one iteration since there's lock
- * contention on the rb tree lock.
+ * Choose next group by traversing average fragment size list of suitable
+ * order. Updates *new_cr if cr level needs an update.
  */
 static void ext4_mb_choose_next_group_cr1(struct ext4_allocation_context *ac,
 		int *new_cr, ext4_group_t *group, ext4_group_t ngroups)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
-	int avg_fragment_size, best_so_far;
-	struct rb_node *node, *found;
-	struct ext4_group_info *grp;
-
-	/*
-	 * If there is contention on the lock, instead of waiting for the lock
-	 * to become available, just continue searching lineraly. We'll resume
-	 * our rb tree search later starting at ac->ac_last_optimal_group.
-	 */
-	if (!read_trylock(&sbi->s_mb_rb_lock)) {
-		ac->ac_flags |= EXT4_MB_SEARCH_NEXT_LINEAR;
-		return;
-	}
+	struct ext4_group_info *grp, *iter;
+	int i;
 
 	if (unlikely(ac->ac_flags & EXT4_MB_CR1_OPTIMIZED)) {
 		if (sbi->s_mb_stats)
 			atomic_inc(&sbi->s_bal_cr1_bad_suggestions);
-		/* We have found something at CR 1 in the past */
-		grp = ext4_get_group_info(ac->ac_sb, ac->ac_last_optimal_group);
-		for (found = rb_next(&grp->bb_avg_fragment_size_rb); found != NULL;
-		     found = rb_next(found)) {
-			grp = rb_entry(found, struct ext4_group_info,
-				       bb_avg_fragment_size_rb);
+	}
+
+	for (i = mb_avg_fragment_size_order(ac->ac_sb, ac->ac_g_ex.fe_len);
+	     i < MB_NUM_ORDERS(ac->ac_sb); i++) {
+		if (list_empty(&sbi->s_mb_avg_fragment_size[i]))
+			continue;
+		read_lock(&sbi->s_mb_avg_fragment_size_locks[i]);
+		if (list_empty(&sbi->s_mb_avg_fragment_size[i])) {
+			read_unlock(&sbi->s_mb_avg_fragment_size_locks[i]);
+			continue;
+		}
+		grp = NULL;
+		list_for_each_entry(iter, &sbi->s_mb_avg_fragment_size[i],
+				    bb_avg_fragment_size_node) {
 			if (sbi->s_mb_stats)
 				atomic64_inc(&sbi->s_bal_cX_groups_considered[1]);
-			if (likely(ext4_mb_good_group(ac, grp->bb_group, 1)))
+			if (likely(ext4_mb_good_group(ac, iter->bb_group, 1))) {
+				grp = iter;
 				break;
-		}
-		goto done;
-	}
-
-	node = sbi->s_mb_avg_fragment_size_root.rb_node;
-	best_so_far = 0;
-	found = NULL;
-
-	while (node) {
-		grp = rb_entry(node, struct ext4_group_info,
-			       bb_avg_fragment_size_rb);
-		avg_fragment_size = 0;
-		if (ext4_mb_good_group(ac, grp->bb_group, 1)) {
-			avg_fragment_size = grp->bb_fragments ?
-				grp->bb_free / grp->bb_fragments : 0;
-			if (!best_so_far || avg_fragment_size < best_so_far) {
-				best_so_far = avg_fragment_size;
-				found = node;
 			}
 		}
-		if (avg_fragment_size > ac->ac_g_ex.fe_len)
-			node = node->rb_right;
-		else
-			node = node->rb_left;
+		read_unlock(&sbi->s_mb_avg_fragment_size_locks[i]);
+		if (grp)
+			break;
 	}
 
-done:
-	if (found) {
-		grp = rb_entry(found, struct ext4_group_info,
-			       bb_avg_fragment_size_rb);
+	if (grp) {
 		*group = grp->bb_group;
 		ac->ac_flags |= EXT4_MB_CR1_OPTIMIZED;
 	} else {
 		*new_cr = 2;
 	}
-
-	read_unlock(&sbi->s_mb_rb_lock);
-	ac->ac_last_optimal_group = *group;
 }
 
 static inline int should_optimize_scan(struct ext4_allocation_context *ac)
@@ -1017,11 +976,6 @@ next_linear_group(struct ext4_allocation_context *ac, int group, int ngroups)
 		goto inc_and_return;
 	}
 
-	if (ac->ac_flags & EXT4_MB_SEARCH_NEXT_LINEAR) {
-		ac->ac_flags &= ~EXT4_MB_SEARCH_NEXT_LINEAR;
-		goto inc_and_return;
-	}
-
 	return group;
 inc_and_return:
 	/*
@@ -1152,13 +1106,13 @@ void ext4_mb_generate_buddy(struct super_block *sb,
 					EXT4_GROUP_INFO_BBITMAP_CORRUPT);
 	}
 	mb_set_largest_free_order(sb, grp);
+	mb_update_avg_fragment_size(sb, grp);
 
 	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
 
 	period = get_cycles() - period;
 	atomic_inc(&sbi->s_mb_buddies_generated);
 	atomic64_add(period, &sbi->s_mb_generation_time);
-	mb_update_avg_fragment_size(sb, grp);
 }
 
 /* The buddy information is attached the buddy cache inode
@@ -2711,7 +2665,6 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 		 * from the goal value specified
 		 */
 		group = ac->ac_g_ex.fe_group;
-		ac->ac_last_optimal_group = group;
 		ac->ac_groups_linear_remaining = sbi->s_mb_max_linear_groups;
 		prefetch_grp = group;
 
@@ -2993,9 +2946,7 @@ __acquires(&EXT4_SB(sb)->s_mb_rb_lock)
 	struct super_block *sb = pde_data(file_inode(seq->file));
 	unsigned long position;
 
-	read_lock(&EXT4_SB(sb)->s_mb_rb_lock);
-
-	if (*pos < 0 || *pos >= MB_NUM_ORDERS(sb) + 1)
+	if (*pos < 0 || *pos >= 2*MB_NUM_ORDERS(sb))
 		return NULL;
 	position = *pos + 1;
 	return (void *) ((unsigned long) position);
@@ -3007,7 +2958,7 @@ static void *ext4_mb_seq_structs_summary_next(struct seq_file *seq, void *v, lof
 	unsigned long position;
 
 	++*pos;
-	if (*pos < 0 || *pos >= MB_NUM_ORDERS(sb) + 1)
+	if (*pos < 0 || *pos >= 2*MB_NUM_ORDERS(sb))
 		return NULL;
 	position = *pos + 1;
 	return (void *) ((unsigned long) position);
@@ -3019,29 +2970,22 @@ static int ext4_mb_seq_structs_summary_show(struct seq_file *seq, void *v)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned long position = ((unsigned long) v);
 	struct ext4_group_info *grp;
-	struct rb_node *n;
-	unsigned int count, min, max;
+	unsigned int count;
 
 	position--;
 	if (position >= MB_NUM_ORDERS(sb)) {
-		seq_puts(seq, "fragment_size_tree:\n");
-		n = rb_first(&sbi->s_mb_avg_fragment_size_root);
-		if (!n) {
-			seq_puts(seq, "\ttree_min: 0\n\ttree_max: 0\n\ttree_nodes: 0\n");
-			return 0;
-		}
-		grp = rb_entry(n, struct ext4_group_info, bb_avg_fragment_size_rb);
-		min = grp->bb_fragments ? grp->bb_free / grp->bb_fragments : 0;
-		count = 1;
-		while (rb_next(n)) {
-			count++;
-			n = rb_next(n);
-		}
-		grp = rb_entry(n, struct ext4_group_info, bb_avg_fragment_size_rb);
-		max = grp->bb_fragments ? grp->bb_free / grp->bb_fragments : 0;
+		position -= MB_NUM_ORDERS(sb);
+		if (position == 0)
+			seq_puts(seq, "avg_fragment_size_lists:\n");
 
-		seq_printf(seq, "\ttree_min: %u\n\ttree_max: %u\n\ttree_nodes: %u\n",
-			   min, max, count);
+		count = 0;
+		read_lock(&sbi->s_mb_avg_fragment_size_locks[position]);
+		list_for_each_entry(grp, &sbi->s_mb_avg_fragment_size[position],
+				    bb_avg_fragment_size_node)
+			count++;
+		read_unlock(&sbi->s_mb_avg_fragment_size_locks[position]);
+		seq_printf(seq, "\tlist_order_%u_groups: %u\n",
+					(unsigned int)position, count);
 		return 0;
 	}
 
@@ -3051,9 +2995,11 @@ static int ext4_mb_seq_structs_summary_show(struct seq_file *seq, void *v)
 		seq_puts(seq, "max_free_order_lists:\n");
 	}
 	count = 0;
+	read_lock(&sbi->s_mb_largest_free_orders_locks[position]);
 	list_for_each_entry(grp, &sbi->s_mb_largest_free_orders[position],
 			    bb_largest_free_order_node)
 		count++;
+	read_unlock(&sbi->s_mb_largest_free_orders_locks[position]);
 	seq_printf(seq, "\tlist_order_%u_groups: %u\n",
 		   (unsigned int)position, count);
 
@@ -3061,11 +3007,7 @@ static int ext4_mb_seq_structs_summary_show(struct seq_file *seq, void *v)
 }
 
 static void ext4_mb_seq_structs_summary_stop(struct seq_file *seq, void *v)
-__releases(&EXT4_SB(sb)->s_mb_rb_lock)
 {
-	struct super_block *sb = pde_data(file_inode(seq->file));
-
-	read_unlock(&EXT4_SB(sb)->s_mb_rb_lock);
 }
 
 const struct seq_operations ext4_mb_seq_structs_summary_ops = {
@@ -3178,8 +3120,9 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	init_rwsem(&meta_group_info[i]->alloc_sem);
 	meta_group_info[i]->bb_free_root = RB_ROOT;
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_largest_free_order_node);
-	RB_CLEAR_NODE(&meta_group_info[i]->bb_avg_fragment_size_rb);
+	INIT_LIST_HEAD(&meta_group_info[i]->bb_avg_fragment_size_node);
 	meta_group_info[i]->bb_largest_free_order = -1;  /* uninit */
+	meta_group_info[i]->bb_avg_fragment_size_order = -1;  /* uninit */
 	meta_group_info[i]->bb_group = group;
 
 	mb_group_bb_bitmap_alloc(sb, meta_group_info[i], group);
@@ -3428,7 +3371,24 @@ int ext4_mb_init(struct super_block *sb)
 		i++;
 	} while (i < MB_NUM_ORDERS(sb));
 
-	sbi->s_mb_avg_fragment_size_root = RB_ROOT;
+	sbi->s_mb_avg_fragment_size =
+		kmalloc_array(MB_NUM_ORDERS(sb), sizeof(struct list_head),
+			GFP_KERNEL);
+	if (!sbi->s_mb_avg_fragment_size) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	sbi->s_mb_avg_fragment_size_locks =
+		kmalloc_array(MB_NUM_ORDERS(sb), sizeof(rwlock_t),
+			GFP_KERNEL);
+	if (!sbi->s_mb_avg_fragment_size_locks) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (i = 0; i < MB_NUM_ORDERS(sb); i++) {
+		INIT_LIST_HEAD(&sbi->s_mb_avg_fragment_size[i]);
+		rwlock_init(&sbi->s_mb_avg_fragment_size_locks[i]);
+	}
 	sbi->s_mb_largest_free_orders =
 		kmalloc_array(MB_NUM_ORDERS(sb), sizeof(struct list_head),
 			GFP_KERNEL);
@@ -3447,7 +3407,6 @@ int ext4_mb_init(struct super_block *sb)
 		INIT_LIST_HEAD(&sbi->s_mb_largest_free_orders[i]);
 		rwlock_init(&sbi->s_mb_largest_free_orders_locks[i]);
 	}
-	rwlock_init(&sbi->s_mb_rb_lock);
 
 	spin_lock_init(&sbi->s_md_lock);
 	sbi->s_mb_free_pending = 0;
@@ -3518,6 +3477,8 @@ int ext4_mb_init(struct super_block *sb)
 	free_percpu(sbi->s_locality_groups);
 	sbi->s_locality_groups = NULL;
 out:
+	kfree(sbi->s_mb_avg_fragment_size);
+	kfree(sbi->s_mb_avg_fragment_size_locks);
 	kfree(sbi->s_mb_largest_free_orders);
 	kfree(sbi->s_mb_largest_free_orders_locks);
 	kfree(sbi->s_mb_offsets);
@@ -3584,6 +3545,8 @@ int ext4_mb_release(struct super_block *sb)
 		kvfree(group_info);
 		rcu_read_unlock();
 	}
+	kfree(sbi->s_mb_avg_fragment_size);
+	kfree(sbi->s_mb_avg_fragment_size_locks);
 	kfree(sbi->s_mb_largest_free_orders);
 	kfree(sbi->s_mb_largest_free_orders_locks);
 	kfree(sbi->s_mb_offsets);
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 39da92ceabf8..dcda2a943cee 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -178,7 +178,6 @@ struct ext4_allocation_context {
 	/* copy of the best found extent taken before preallocation efforts */
 	struct ext4_free_extent ac_f_ex;
 
-	ext4_group_t ac_last_optimal_group;
 	__u32 ac_groups_considered;
 	__u32 ac_flags;		/* allocation hints */
 	__u16 ac_groups_scanned;
-- 
2.35.3

