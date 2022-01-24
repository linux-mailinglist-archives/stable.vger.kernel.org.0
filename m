Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C57D499DD1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586271AbiAXW0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583158AbiAXWRW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FE4C04A2DC;
        Mon, 24 Jan 2022 12:45:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0763C60B03;
        Mon, 24 Jan 2022 20:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBFBC340E7;
        Mon, 24 Jan 2022 20:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057145;
        bh=TrEyxXScUQN2ndIprFfTUzN2MsbyjUrfc//izk3BMCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYOujBuujJl99A4mpLSdo69f3fKDc6r5x2WnJdDlbEKOSmezOgAgJv/Ra9uJUhT/Z
         0Mh6Gv8KCy9vgAVTNmjiN7WIEQqUl576szQU8RY4o7gYEuJCwKCly/YZRNPjxyPRYh
         QeevktjLs6NSwMS6WDXwf/PAUcbiRU+j8GkeLpGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunguang Xu <brookxu@tencent.com>,
        kernel test robot <lkp@intel.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.15 715/846] ext4: fix a possible ABBA deadlock due to busy PA
Date:   Mon, 24 Jan 2022 19:43:52 +0100
Message-Id: <20220124184125.683654791@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

commit 8c80fb312d7abf8bcd66cca1d843a80318a2c522 upstream.

We found on older kernel (3.10) that in the scenario of insufficient
disk space, system may trigger an ABBA deadlock problem, it seems that
this problem still exists in latest kernel, try to fix it here. The
main process triggered by this problem is that task A occupies the PA
and waits for the jbd2 transaction finish, the jbd2 transaction waits
for the completion of task B's IO (plug_list), but task B waits for
the release of PA by task A to finish discard, which indirectly forms
an ABBA deadlock. The related calltrace is as follows:

    Task A
    vfs_write
    ext4_mb_new_blocks()
    ext4_mb_mark_diskspace_used()       JBD2
    jbd2_journal_get_write_access()  -> jbd2_journal_commit_transaction()
  ->schedule()                          filemap_fdatawait()
 |                                              |
 | Task B                                       |
 | do_unlinkat()                                |
 | ext4_evict_inode()                           |
 | jbd2_journal_begin_ordered_truncate()        |
 | filemap_fdatawrite_range()                   |
 | ext4_mb_new_blocks()                         |
  -ext4_mb_discard_group_preallocations() <-----

Here, try to cancel ext4_mb_discard_group_preallocations() internal
retry due to PA busy, and do a limited number of retries inside
ext4_mb_discard_preallocations(), which can circumvent the above
problems, but also has some advantages:

1. Since the PA is in a busy state, if other groups have free PAs,
   keeping the current PA may help to reduce fragmentation.
2. Continue to traverse forward instead of waiting for the current
   group PA to be released. In most scenarios, the PA discard time
   can be reduced.

However, in the case of smaller free space, if only a few groups have
space, then due to multiple traversals of the group, it may increase
CPU overhead. But in contrast, I feel that the overall benefit is
better than the cost.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/1637630277-23496-1-git-send-email-brookxu.cn@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4814,7 +4814,7 @@ ext4_mb_release_group_pa(struct ext4_bud
  */
 static noinline_for_stack int
 ext4_mb_discard_group_preallocations(struct super_block *sb,
-					ext4_group_t group, int needed)
+				     ext4_group_t group, int *busy)
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 	struct buffer_head *bitmap_bh = NULL;
@@ -4822,8 +4822,7 @@ ext4_mb_discard_group_preallocations(str
 	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
-	int busy = 0;
-	int free, free_total = 0;
+	int free = 0;
 
 	mb_debug(sb, "discard preallocation for group %u\n", group);
 	if (list_empty(&grp->bb_prealloc_list))
@@ -4846,19 +4845,14 @@ ext4_mb_discard_group_preallocations(str
 		goto out_dbg;
 	}
 
-	if (needed == 0)
-		needed = EXT4_CLUSTERS_PER_GROUP(sb) + 1;
-
 	INIT_LIST_HEAD(&list);
-repeat:
-	free = 0;
 	ext4_lock_group(sb, group);
 	list_for_each_entry_safe(pa, tmp,
 				&grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
 		if (atomic_read(&pa->pa_count)) {
 			spin_unlock(&pa->pa_lock);
-			busy = 1;
+			*busy = 1;
 			continue;
 		}
 		if (pa->pa_deleted) {
@@ -4898,22 +4892,13 @@ repeat:
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
 
-	free_total += free;
-
-	/* if we still need more blocks and some PAs were used, try again */
-	if (free_total < needed && busy) {
-		ext4_unlock_group(sb, group);
-		cond_resched();
-		busy = 0;
-		goto repeat;
-	}
 	ext4_unlock_group(sb, group);
 	ext4_mb_unload_buddy(&e4b);
 	put_bh(bitmap_bh);
 out_dbg:
 	mb_debug(sb, "discarded (%d) blocks preallocated for group %u bb_free (%d)\n",
-		 free_total, group, grp->bb_free);
-	return free_total;
+		 free, group, grp->bb_free);
+	return free;
 }
 
 /*
@@ -5455,13 +5440,24 @@ static int ext4_mb_discard_preallocation
 {
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
 	int ret;
-	int freed = 0;
+	int freed = 0, busy = 0;
+	int retry = 0;
 
 	trace_ext4_mb_discard_preallocations(sb, needed);
+
+	if (needed == 0)
+		needed = EXT4_CLUSTERS_PER_GROUP(sb) + 1;
+ repeat:
 	for (i = 0; i < ngroups && needed > 0; i++) {
-		ret = ext4_mb_discard_group_preallocations(sb, i, needed);
+		ret = ext4_mb_discard_group_preallocations(sb, i, &busy);
 		freed += ret;
 		needed -= ret;
+		cond_resched();
+	}
+
+	if (needed > 0 && busy && ++retry < 3) {
+		busy = 0;
+		goto repeat;
 	}
 
 	return freed;


