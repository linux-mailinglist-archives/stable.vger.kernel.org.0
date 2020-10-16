Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F085290148
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394742AbgJPJMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405672AbgJPJK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:10:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FA8A20789;
        Fri, 16 Oct 2020 09:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839424;
        bh=htpZi4C5/QUNjqq2BXtW7usav9vgP+fIaq4RjFqn+F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWaw/BjA6lzHOK1yMVr/LpAdPiSaM33UdhVfdNPKHQKsowIKicFBkFPHhX9Ch9uak
         Io+fb1bIVgVWXcNdchdf0ElUpa1x4ps/tvPOZQM9dMBPXndSd63ZLU/KelPlDYxJqh
         dC10NHm5FsewoTuaAKZco6bgAZE+ABcxrwSedjX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/22] btrfs: dont pass system_chunk into can_overcommit
Date:   Fri, 16 Oct 2020 11:07:30 +0200
Message-Id: <20201016090437.429937666@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
References: <20201016090437.308349327@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 6f484f0d347eb..e19e538d05f93 100644
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
2.25.1



