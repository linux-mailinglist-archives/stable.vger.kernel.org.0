Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3DB2E99C5
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbhADQDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729060AbhADQDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54DD322525;
        Mon,  4 Jan 2021 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776153;
        bh=WfuIME2z6Gp2ljOyk9vHEyeNlTivkrOPmfy+3WR/rwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOlgx+3iCGiOnOBa11bWF/mrfURRrCPBWvre5xOT2TaX3L1dOx4qUZpUb8/iOFNMX
         FRCtuC6t+g6/q0bEvWi56PvYRuudCKSzW66vj3sYuLpHaE3NqOUzDcQLo6ZIpdMmNv
         09DscFNI4l5HJN/FUL5YX0by/TDS+412/x5YWCWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Light Hsieh <Light.Hsieh@mediatek.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/63] f2fs: avoid race condition for shrinker count
Date:   Mon,  4 Jan 2021 16:57:39 +0100
Message-Id: <20210104155711.049210727@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit a95ba66ac1457b76fe472c8e092ab1006271f16c ]

Light reported sometimes shinker gets nat_cnt < dirty_nat_cnt resulting in
wrong do_shinker work. Let's avoid to return insane overflowed value by adding
single tracking value.

Reported-by: Light Hsieh <Light.Hsieh@mediatek.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c |  2 +-
 fs/f2fs/debug.c      | 11 ++++++-----
 fs/f2fs/f2fs.h       | 10 ++++++++--
 fs/f2fs/node.c       | 29 ++++++++++++++++++-----------
 fs/f2fs/node.h       |  4 ++--
 fs/f2fs/shrinker.c   |  4 +---
 6 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 023462e80e58d..b39bf416d5114 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1600,7 +1600,7 @@ int f2fs_write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 			goto out;
 		}
 
-		if (NM_I(sbi)->dirty_nat_cnt == 0 &&
+		if (NM_I(sbi)->nat_cnt[DIRTY_NAT] == 0 &&
 				SIT_I(sbi)->dirty_sentries == 0 &&
 				prefree_segments(sbi) == 0) {
 			f2fs_flush_sit_entries(sbi, cpc);
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index a8357fd4f5fab..197c914119da8 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -145,8 +145,8 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 		si->node_pages = NODE_MAPPING(sbi)->nrpages;
 	if (sbi->meta_inode)
 		si->meta_pages = META_MAPPING(sbi)->nrpages;
-	si->nats = NM_I(sbi)->nat_cnt;
-	si->dirty_nats = NM_I(sbi)->dirty_nat_cnt;
+	si->nats = NM_I(sbi)->nat_cnt[TOTAL_NAT];
+	si->dirty_nats = NM_I(sbi)->nat_cnt[DIRTY_NAT];
 	si->sits = MAIN_SEGS(sbi);
 	si->dirty_sits = SIT_I(sbi)->dirty_sentries;
 	si->free_nids = NM_I(sbi)->nid_cnt[FREE_NID];
@@ -278,9 +278,10 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 	si->cache_mem += (NM_I(sbi)->nid_cnt[FREE_NID] +
 				NM_I(sbi)->nid_cnt[PREALLOC_NID]) *
 				sizeof(struct free_nid);
-	si->cache_mem += NM_I(sbi)->nat_cnt * sizeof(struct nat_entry);
-	si->cache_mem += NM_I(sbi)->dirty_nat_cnt *
-					sizeof(struct nat_entry_set);
+	si->cache_mem += NM_I(sbi)->nat_cnt[TOTAL_NAT] *
+				sizeof(struct nat_entry);
+	si->cache_mem += NM_I(sbi)->nat_cnt[DIRTY_NAT] *
+				sizeof(struct nat_entry_set);
 	si->cache_mem += si->inmem_pages * sizeof(struct inmem_pages);
 	for (i = 0; i < MAX_INO_ENTRY; i++)
 		si->cache_mem += sbi->im[i].ino_num * sizeof(struct ino_entry);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9a321c52facec..e4344d98a780c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -894,6 +894,13 @@ enum nid_state {
 	MAX_NID_STATE,
 };
 
+enum nat_state {
+	TOTAL_NAT,
+	DIRTY_NAT,
+	RECLAIMABLE_NAT,
+	MAX_NAT_STATE,
+};
+
 struct f2fs_nm_info {
 	block_t nat_blkaddr;		/* base disk address of NAT */
 	nid_t max_nid;			/* maximum possible node ids */
@@ -909,8 +916,7 @@ struct f2fs_nm_info {
 	struct rw_semaphore nat_tree_lock;	/* protect nat_tree_lock */
 	struct list_head nat_entries;	/* cached nat entry list (clean) */
 	spinlock_t nat_list_lock;	/* protect clean nat entry list */
-	unsigned int nat_cnt;		/* the # of cached nat entries */
-	unsigned int dirty_nat_cnt;	/* total num of nat entries in set */
+	unsigned int nat_cnt[MAX_NAT_STATE]; /* the # of cached nat entries */
 	unsigned int nat_blocks;	/* # of nat blocks */
 
 	/* free node ids management */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 42394de6c7eb1..e65d73293a3f6 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -62,8 +62,8 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 				sizeof(struct free_nid)) >> PAGE_SHIFT;
 		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 2);
 	} else if (type == NAT_ENTRIES) {
-		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >>
-							PAGE_SHIFT;
+		mem_size = (nm_i->nat_cnt[TOTAL_NAT] *
+				sizeof(struct nat_entry)) >> PAGE_SHIFT;
 		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 2);
 		if (excess_cached_nats(sbi))
 			res = false;
@@ -177,7 +177,8 @@ static struct nat_entry *__init_nat_entry(struct f2fs_nm_info *nm_i,
 	list_add_tail(&ne->list, &nm_i->nat_entries);
 	spin_unlock(&nm_i->nat_list_lock);
 
-	nm_i->nat_cnt++;
+	nm_i->nat_cnt[TOTAL_NAT]++;
+	nm_i->nat_cnt[RECLAIMABLE_NAT]++;
 	return ne;
 }
 
@@ -207,7 +208,8 @@ static unsigned int __gang_lookup_nat_cache(struct f2fs_nm_info *nm_i,
 static void __del_from_nat_cache(struct f2fs_nm_info *nm_i, struct nat_entry *e)
 {
 	radix_tree_delete(&nm_i->nat_root, nat_get_nid(e));
-	nm_i->nat_cnt--;
+	nm_i->nat_cnt[TOTAL_NAT]--;
+	nm_i->nat_cnt[RECLAIMABLE_NAT]--;
 	__free_nat_entry(e);
 }
 
@@ -253,7 +255,8 @@ static void __set_nat_cache_dirty(struct f2fs_nm_info *nm_i,
 	if (get_nat_flag(ne, IS_DIRTY))
 		goto refresh_list;
 
-	nm_i->dirty_nat_cnt++;
+	nm_i->nat_cnt[DIRTY_NAT]++;
+	nm_i->nat_cnt[RECLAIMABLE_NAT]--;
 	set_nat_flag(ne, IS_DIRTY, true);
 refresh_list:
 	spin_lock(&nm_i->nat_list_lock);
@@ -273,7 +276,8 @@ static void __clear_nat_cache_dirty(struct f2fs_nm_info *nm_i,
 
 	set_nat_flag(ne, IS_DIRTY, false);
 	set->entry_cnt--;
-	nm_i->dirty_nat_cnt--;
+	nm_i->nat_cnt[DIRTY_NAT]--;
+	nm_i->nat_cnt[RECLAIMABLE_NAT]++;
 }
 
 static unsigned int __gang_lookup_nat_set(struct f2fs_nm_info *nm_i,
@@ -2944,14 +2948,17 @@ int f2fs_flush_nat_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	LIST_HEAD(sets);
 	int err = 0;
 
-	/* during unmount, let's flush nat_bits before checking dirty_nat_cnt */
+	/*
+	 * during unmount, let's flush nat_bits before checking
+	 * nat_cnt[DIRTY_NAT].
+	 */
 	if (enabled_nat_bits(sbi, cpc)) {
 		down_write(&nm_i->nat_tree_lock);
 		remove_nats_in_journal(sbi);
 		up_write(&nm_i->nat_tree_lock);
 	}
 
-	if (!nm_i->dirty_nat_cnt)
+	if (!nm_i->nat_cnt[DIRTY_NAT])
 		return 0;
 
 	down_write(&nm_i->nat_tree_lock);
@@ -2962,7 +2969,8 @@ int f2fs_flush_nat_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	 * into nat entry set.
 	 */
 	if (enabled_nat_bits(sbi, cpc) ||
-		!__has_cursum_space(journal, nm_i->dirty_nat_cnt, NAT_JOURNAL))
+		!__has_cursum_space(journal,
+			nm_i->nat_cnt[DIRTY_NAT], NAT_JOURNAL))
 		remove_nats_in_journal(sbi);
 
 	while ((found = __gang_lookup_nat_set(nm_i,
@@ -3086,7 +3094,6 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 						F2FS_RESERVED_NODE_NUM;
 	nm_i->nid_cnt[FREE_NID] = 0;
 	nm_i->nid_cnt[PREALLOC_NID] = 0;
-	nm_i->nat_cnt = 0;
 	nm_i->ram_thresh = DEF_RAM_THRESHOLD;
 	nm_i->ra_nid_pages = DEF_RA_NID_PAGES;
 	nm_i->dirty_nats_ratio = DEF_DIRTY_NAT_RATIO_THRESHOLD;
@@ -3220,7 +3227,7 @@ void f2fs_destroy_node_manager(struct f2fs_sb_info *sbi)
 			__del_from_nat_cache(nm_i, natvec[idx]);
 		}
 	}
-	f2fs_bug_on(sbi, nm_i->nat_cnt);
+	f2fs_bug_on(sbi, nm_i->nat_cnt[TOTAL_NAT]);
 
 	/* destroy nat set cache */
 	nid = 0;
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 69e5859e993cf..f84541b57acbb 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -126,13 +126,13 @@ static inline void raw_nat_from_node_info(struct f2fs_nat_entry *raw_ne,
 
 static inline bool excess_dirty_nats(struct f2fs_sb_info *sbi)
 {
-	return NM_I(sbi)->dirty_nat_cnt >= NM_I(sbi)->max_nid *
+	return NM_I(sbi)->nat_cnt[DIRTY_NAT] >= NM_I(sbi)->max_nid *
 					NM_I(sbi)->dirty_nats_ratio / 100;
 }
 
 static inline bool excess_cached_nats(struct f2fs_sb_info *sbi)
 {
-	return NM_I(sbi)->nat_cnt >= DEF_NAT_CACHE_THRESHOLD;
+	return NM_I(sbi)->nat_cnt[TOTAL_NAT] >= DEF_NAT_CACHE_THRESHOLD;
 }
 
 static inline bool excess_dirty_nodes(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/shrinker.c b/fs/f2fs/shrinker.c
index d66de5999a26d..dd3c3c7a90ec8 100644
--- a/fs/f2fs/shrinker.c
+++ b/fs/f2fs/shrinker.c
@@ -18,9 +18,7 @@ static unsigned int shrinker_run_no;
 
 static unsigned long __count_nat_entries(struct f2fs_sb_info *sbi)
 {
-	long count = NM_I(sbi)->nat_cnt - NM_I(sbi)->dirty_nat_cnt;
-
-	return count > 0 ? count : 0;
+	return NM_I(sbi)->nat_cnt[RECLAIMABLE_NAT];
 }
 
 static unsigned long __count_free_nids(struct f2fs_sb_info *sbi)
-- 
2.27.0



