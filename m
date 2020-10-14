Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04F528D89F
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 04:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgJNCpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 22:45:13 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46126 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJNCpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 22:45:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09E2j4tW139655;
        Wed, 14 Oct 2020 02:45:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=DzSs+SMmwAkILLXuLp2+cq+1F8p05k5F2b4bwqR8iMc=;
 b=ioC/PcE1sG5zputP81+VzaCyd2vcNWLIAMWRC4gkpH5VFDMG6NNxsNNKvgiDYLtX4sB3
 0MNSmkCfIxtAy6PJY0G2J8BBZkXfLPkwPOAMQeOC5PMs6UtmlOkj7PkduEzDMF1FSTHG
 4FTF+tdgccI8bq1Ub1bv2XqHdtChIktAjbOoh8R9Y9nSnhNozfvArMaVQITc3ewG4oqL
 ihoIhBz+3uA5SqQF2w0/clZZaWVeRXd1O+lx8ya8lgogmCBZKXIaqsd7no11cr+Wc3Qx
 VgcUqAkFEqVMdfWqovrotVNdOdmGlxGZlJ8ypOApE7Wu5fAg36FgG7Da4I9Bk0dqZC15 tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 343pajuu6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Oct 2020 02:45:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09E2ZeAs056289;
        Wed, 14 Oct 2020 02:45:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 343php0dfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 02:45:04 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09E2j2Is009734;
        Wed, 14 Oct 2020 02:45:02 GMT
Received: from localhost.localdomain (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 19:45:01 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, nborisov@suse.com, wqu@suse.com,
        jthumshirn@suse.de, josef@toxicpanda.com, dsterba@suse.com,
        anand.jain@oracle.com
Subject: [PATCH stable-5.4 1/2] btrfs: don't pass system_chunk into can_overcommit
Date:   Wed, 14 Oct 2020 10:44:46 +0800
Message-Id: <67cc50617cfdd543c879734d0c5c5b7d848ddccd.1602243895.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1602243894.git.anand.jain@oracle.com>
References: <cover.1602243894.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010140017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1011 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140018
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 9f246926b4d5db4c5e8c78e4897757de26c95be6 upstream

We have the space_info, we can just check its flags to see if it's the
system chunk space info.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/space-info.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 6f484f0d347e..e19e538d05f9 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -162,8 +162,7 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
 
 static int can_overcommit(struct btrfs_fs_info *fs_info,
 			  struct btrfs_space_info *space_info, u64 bytes,
-			  enum btrfs_reserve_flush_enum flush,
-			  bool system_chunk)
+			  enum btrfs_reserve_flush_enum flush)
 {
 	u64 profile;
 	u64 avail;
@@ -174,7 +173,7 @@ static int can_overcommit(struct btrfs_fs_info *fs_info,
 	if (space_info->flags & BTRFS_BLOCK_GROUP_DATA)
 		return 0;
 
-	if (system_chunk)
+	if (space_info->flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		profile = btrfs_system_alloc_profile(fs_info);
 	else
 		profile = btrfs_metadata_alloc_profile(fs_info);
@@ -228,8 +227,7 @@ void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
 
 		/* Check and see if our ticket can be satisified now. */
 		if ((used + ticket->bytes <= space_info->total_bytes) ||
-		    can_overcommit(fs_info, space_info, ticket->bytes, flush,
-				   false)) {
+		    can_overcommit(fs_info, space_info, ticket->bytes, flush)) {
 			btrfs_space_info_update_bytes_may_use(fs_info,
 							      space_info,
 							      ticket->bytes);
@@ -634,8 +632,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 
 static inline u64
 btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
-				 struct btrfs_space_info *space_info,
-				 bool system_chunk)
+				 struct btrfs_space_info *space_info)
 {
 	struct reserve_ticket *ticket;
 	u64 used;
@@ -651,13 +648,12 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 
 	to_reclaim = min_t(u64, num_online_cpus() * SZ_1M, SZ_16M);
 	if (can_overcommit(fs_info, space_info, to_reclaim,
-			   BTRFS_RESERVE_FLUSH_ALL, system_chunk))
+			   BTRFS_RESERVE_FLUSH_ALL))
 		return 0;
 
 	used = btrfs_space_info_used(space_info, true);
 
-	if (can_overcommit(fs_info, space_info, SZ_1M,
-			   BTRFS_RESERVE_FLUSH_ALL, system_chunk))
+	if (can_overcommit(fs_info, space_info, SZ_1M, BTRFS_RESERVE_FLUSH_ALL))
 		expected = div_factor_fine(space_info->total_bytes, 95);
 	else
 		expected = div_factor_fine(space_info->total_bytes, 90);
@@ -673,7 +669,7 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 
 static inline int need_do_async_reclaim(struct btrfs_fs_info *fs_info,
 					struct btrfs_space_info *space_info,
-					u64 used, bool system_chunk)
+					u64 used)
 {
 	u64 thresh = div_factor_fine(space_info->total_bytes, 98);
 
@@ -681,8 +677,7 @@ static inline int need_do_async_reclaim(struct btrfs_fs_info *fs_info,
 	if ((space_info->bytes_used + space_info->bytes_reserved) >= thresh)
 		return 0;
 
-	if (!btrfs_calc_reclaim_metadata_size(fs_info, space_info,
-					      system_chunk))
+	if (!btrfs_calc_reclaim_metadata_size(fs_info, space_info))
 		return 0;
 
 	return (used >= thresh && !btrfs_fs_closing(fs_info) &&
@@ -805,8 +800,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 	space_info = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
 
 	spin_lock(&space_info->lock);
-	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info,
-						      false);
+	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info);
 	if (!to_reclaim) {
 		space_info->flush = 0;
 		spin_unlock(&space_info->lock);
@@ -825,8 +819,7 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 			return;
 		}
 		to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info,
-							      space_info,
-							      false);
+							      space_info);
 		if (last_tickets_id == space_info->tickets_id) {
 			flush_state++;
 		} else {
@@ -898,8 +891,7 @@ static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 	int flush_state;
 
 	spin_lock(&space_info->lock);
-	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info,
-						      false);
+	to_reclaim = btrfs_calc_reclaim_metadata_size(fs_info, space_info);
 	if (!to_reclaim) {
 		spin_unlock(&space_info->lock);
 		return;
@@ -1031,8 +1023,7 @@ static int handle_reserve_ticket(struct btrfs_fs_info *fs_info,
 static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 				    struct btrfs_space_info *space_info,
 				    u64 orig_bytes,
-				    enum btrfs_reserve_flush_enum flush,
-				    bool system_chunk)
+				    enum btrfs_reserve_flush_enum flush)
 {
 	struct reserve_ticket ticket;
 	u64 used;
@@ -1054,8 +1045,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 */
 	if (!pending_tickets &&
 	    ((used + orig_bytes <= space_info->total_bytes) ||
-	     can_overcommit(fs_info, space_info, orig_bytes, flush,
-			   system_chunk))) {
+	     can_overcommit(fs_info, space_info, orig_bytes, flush))) {
 		btrfs_space_info_update_bytes_may_use(fs_info, space_info,
 						      orig_bytes);
 		ret = 0;
@@ -1097,8 +1087,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 		 * the async reclaim as we will panic.
 		 */
 		if (!test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags) &&
-		    need_do_async_reclaim(fs_info, space_info,
-					  used, system_chunk) &&
+		    need_do_async_reclaim(fs_info, space_info, used) &&
 		    !work_busy(&fs_info->async_reclaim_work)) {
 			trace_btrfs_trigger_flush(fs_info, space_info->flags,
 						  orig_bytes, flush, "preempt");
@@ -1135,10 +1124,9 @@ int btrfs_reserve_metadata_bytes(struct btrfs_root *root,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	int ret;
-	bool system_chunk = (root == fs_info->chunk_root);
 
 	ret = __reserve_metadata_bytes(fs_info, block_rsv->space_info,
-				       orig_bytes, flush, system_chunk);
+				       orig_bytes, flush);
 	if (ret == -ENOSPC &&
 	    unlikely(root->orphan_cleanup_state == ORPHAN_CLEANUP_STARTED)) {
 		if (block_rsv != global_rsv &&
-- 
2.18.4

