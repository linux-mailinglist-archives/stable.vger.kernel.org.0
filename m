Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C19628D8A0
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 04:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgJNCpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 22:45:17 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46146 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJNCpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 22:45:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09E2j45l139646;
        Wed, 14 Oct 2020 02:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=awm+4lZJcJ248iOANcf3BQVSNBwev7Xrl2/NjJXr238=;
 b=oH4oabE9gHp/MrZ8x/bfQ/EGEqfnVQ6iIeHf37zsCNknXCx6rlsj9ASxu7gvUo5Zy/Yl
 XAMKsZv/gLRzfuF/bFhqXxfkd4ewWVnvC17q2VmQuPNYVuxZOsyA+RFMG8jULSp2faO2
 bp0so7daYNft/vzjDPh9VxLJM+XGQqPIlWXD+XiQrmAMawXWuwyQIvWmnkdeOcbbubVN
 NdGY2dZk/RqZrKZFFrtvs97PolLeICZfERLy1AztVcgtouZotqU0RbbTX8xIHp2w4mj6
 waxqsfl77vTD65YFeJBD3vTL6qa7pAcE9NlBJarTRel4vchvBA0Mp9qTxZjCGxKIZdSJ wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 343pajuu6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Oct 2020 02:45:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09E2ZXE9120553;
        Wed, 14 Oct 2020 02:45:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 344by31yum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 02:45:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09E2j6gq006551;
        Wed, 14 Oct 2020 02:45:06 GMT
Received: from localhost.localdomain (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 19:45:05 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, nborisov@suse.com, wqu@suse.com,
        jthumshirn@suse.de, josef@toxicpanda.com, dsterba@suse.com,
        anand.jain@oracle.com
Subject: [PATCH stable-5.4 2/2] btrfs: take overcommit into account in inc_block_group_ro
Date:   Wed, 14 Oct 2020 10:44:47 +0800
Message-Id: <554463ecab12303aecf5af8dff1c9575fdb7d060.1602243895.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1602243894.git.anand.jain@oracle.com>
References: <cover.1602243894.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=2 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=2
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140018
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit a30a3d2067536cbcce26c055e70cc3a6ae4fd45c upstream

inc_block_group_ro does a calculation to see if we have enough room left
over if we mark this block group as read only in order to see if it's ok
to mark the block group as read only.

The problem is this calculation _only_ works for data, where our used is
always less than our total.  For metadata we will overcommit, so this
will almost always fail for metadata.

Fix this by exporting btrfs_can_overcommit, and then see if we have
enough space to remove the remaining free space in the block group we
are trying to mark read only.  If we do then we can mark this block
group as read only.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/block-group.c | 38 ++++++++++++++++++++++++++------------
 fs/btrfs/space-info.c  | 18 ++++++++++--------
 fs/btrfs/space-info.h  |  3 +++
 3 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index b167649f5f5d..ace49a999ece 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1186,7 +1186,6 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
 	u64 num_bytes;
-	u64 sinfo_used;
 	u64 min_allocable_bytes;
 	int ret = -ENOSPC;
 
@@ -1213,20 +1212,38 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 
 	num_bytes = cache->key.offset - cache->reserved - cache->pinned -
 		    cache->bytes_super - btrfs_block_group_used(&cache->item);
-	sinfo_used = btrfs_space_info_used(sinfo, true);
 
 	/*
-	 * sinfo_used + num_bytes should always <= sinfo->total_bytes.
-	 *
-	 * Here we make sure if we mark this bg RO, we still have enough
-	 * free space as buffer (if min_allocable_bytes is not 0).
+	 * Data never overcommits, even in mixed mode, so do just the straight
+	 * check of left over space in how much we have allocated.
 	 */
-	if (sinfo_used + num_bytes + min_allocable_bytes <=
-	    sinfo->total_bytes) {
+	if (force) {
+		ret = 0;
+	} else if (sinfo->flags & BTRFS_BLOCK_GROUP_DATA) {
+		u64 sinfo_used = btrfs_space_info_used(sinfo, true);
+
+		/*
+		 * Here we make sure if we mark this bg RO, we still have enough
+		 * free space as buffer.
+		 */
+		if (sinfo_used + num_bytes <= sinfo->total_bytes)
+			ret = 0;
+	} else {
+		/*
+		 * We overcommit metadata, so we need to do the
+		 * btrfs_can_overcommit check here, and we need to pass in
+		 * BTRFS_RESERVE_NO_FLUSH to give ourselves the most amount of
+		 * leeway to allow us to mark this block group as read only.
+		 */
+		if (btrfs_can_overcommit(cache->fs_info, sinfo, num_bytes,
+					 BTRFS_RESERVE_NO_FLUSH))
+			ret = 0;
+	}
+
+	if (!ret) {
 		sinfo->bytes_readonly += num_bytes;
 		cache->ro++;
 		list_add_tail(&cache->ro_list, &sinfo->ro_bgs);
-		ret = 0;
 	}
 out:
 	spin_unlock(&cache->lock);
@@ -1235,9 +1252,6 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 		btrfs_info(cache->fs_info,
 			"unable to make block group %llu ro",
 			cache->key.objectid);
-		btrfs_info(cache->fs_info,
-			"sinfo_used=%llu bg_num_bytes=%llu min_allocable=%llu",
-			sinfo_used, num_bytes, min_allocable_bytes);
 		btrfs_dump_space_info(cache->fs_info, cache->space_info, 0, 0);
 	}
 	return ret;
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index e19e538d05f9..90500b6c41fc 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -160,9 +160,9 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
 	return (global->size << 1);
 }
 
-static int can_overcommit(struct btrfs_fs_info *fs_info,
-			  struct btrfs_space_info *space_info, u64 bytes,
-			  enum btrfs_reserve_flush_enum flush)
+int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
+			 struct btrfs_space_info *space_info, u64 bytes,
+			 enum btrfs_reserve_flush_enum flush)
 {
 	u64 profile;
 	u64 avail;
@@ -227,7 +227,8 @@ void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
 
 		/* Check and see if our ticket can be satisified now. */
 		if ((used + ticket->bytes <= space_info->total_bytes) ||
-		    can_overcommit(fs_info, space_info, ticket->bytes, flush)) {
+		    btrfs_can_overcommit(fs_info, space_info, ticket->bytes,
+					 flush)) {
 			btrfs_space_info_update_bytes_may_use(fs_info,
 							      space_info,
 							      ticket->bytes);
@@ -647,13 +648,14 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 		return to_reclaim;
 
 	to_reclaim = min_t(u64, num_online_cpus() * SZ_1M, SZ_16M);
-	if (can_overcommit(fs_info, space_info, to_reclaim,
-			   BTRFS_RESERVE_FLUSH_ALL))
+	if (btrfs_can_overcommit(fs_info, space_info, to_reclaim,
+				 BTRFS_RESERVE_FLUSH_ALL))
 		return 0;
 
 	used = btrfs_space_info_used(space_info, true);
 
-	if (can_overcommit(fs_info, space_info, SZ_1M, BTRFS_RESERVE_FLUSH_ALL))
+	if (btrfs_can_overcommit(fs_info, space_info, SZ_1M,
+				 BTRFS_RESERVE_FLUSH_ALL))
 		expected = div_factor_fine(space_info->total_bytes, 95);
 	else
 		expected = div_factor_fine(space_info->total_bytes, 90);
@@ -1045,7 +1047,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 */
 	if (!pending_tickets &&
 	    ((used + orig_bytes <= space_info->total_bytes) ||
-	     can_overcommit(fs_info, space_info, orig_bytes, flush))) {
+	     btrfs_can_overcommit(fs_info, space_info, orig_bytes, flush))) {
 		btrfs_space_info_update_bytes_may_use(fs_info, space_info,
 						      orig_bytes);
 		ret = 0;
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index 8b9a1d8fefcb..b9cffc62cafa 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -129,6 +129,9 @@ int btrfs_reserve_metadata_bytes(struct btrfs_root *root,
 				 enum btrfs_reserve_flush_enum flush);
 void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
 				struct btrfs_space_info *space_info);
+int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
+			 struct btrfs_space_info *space_info, u64 bytes,
+			 enum btrfs_reserve_flush_enum flush);
 
 static inline void btrfs_space_info_free_bytes_may_use(
 				struct btrfs_fs_info *fs_info,
-- 
2.18.4

