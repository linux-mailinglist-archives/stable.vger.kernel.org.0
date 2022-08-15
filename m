Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1E2594CB7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244341AbiHPBAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiHPAy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:54:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB4319D0DB;
        Mon, 15 Aug 2022 13:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EB476126B;
        Mon, 15 Aug 2022 20:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8539AC433C1;
        Mon, 15 Aug 2022 20:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596471;
        bh=PgS+X4waG6qoAFVttaBkxVxkx/Dv9YS9LoA/5cdQop8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdZA1aHtHn1l5e0U5R5nP4iLT//LCr9N0Jf4Urdwxm9l3mEsi+pG45GdiVVObbJV1
         F5lMHK6s93oIB5TxVQSTYNEMCJVLoEj7czBRPxYFzKWNoCyZHbK5REejSazCnaVCRV
         mqxqPP0Eg5BmwUOLDo9+h4mU4HJX/dU9P0Zoe+gg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Roesch <shr@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1091/1157] btrfs: store chunk size in space-info struct
Date:   Mon, 15 Aug 2022 20:07:27 +0200
Message-Id: <20220815180523.838271730@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Roesch <shr@fb.com>

[ Upstream commit f6fca3917b4d99d8c13901738afec35f570a3c2f ]

The chunk size is stored in the btrfs_space_info structure.  It is
initialized at the start and is then used.

A new API is added to update the current chunk size.  This API is used
to be able to expose the chunk_size as a sysfs setting.

Signed-off-by: Stefan Roesch <shr@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ rename and merge helpers, switch atomic type to u64, style fixes ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/space-info.h |  4 ++++
 fs/btrfs/volumes.c    | 28 +++++++++-------------------
 3 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index f301149c7597..51fbfd716623 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -187,6 +187,37 @@ void btrfs_clear_space_info_full(struct btrfs_fs_info *info)
  */
 #define BTRFS_DEFAULT_ZONED_RECLAIM_THRESH			(75)
 
+/*
+ * Calculate chunk size depending on volume type (regular or zoned).
+ */
+static u64 calc_chunk_size(const struct btrfs_fs_info *fs_info, u64 flags)
+{
+	if (btrfs_is_zoned(fs_info))
+		return fs_info->zone_size;
+
+	ASSERT(flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
+
+	if (flags & BTRFS_BLOCK_GROUP_DATA)
+		return SZ_1G;
+	else if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
+		return SZ_32M;
+
+	/* Handle BTRFS_BLOCK_GROUP_METADATA */
+	if (fs_info->fs_devices->total_rw_bytes > 50ULL * SZ_1G)
+		return SZ_1G;
+
+	return SZ_256M;
+}
+
+/*
+ * Update default chunk size.
+ */
+void btrfs_update_space_info_chunk_size(struct btrfs_space_info *space_info,
+					u64 chunk_size)
+{
+	WRITE_ONCE(space_info->chunk_size, chunk_size);
+}
+
 static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 {
 
@@ -208,6 +239,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 	INIT_LIST_HEAD(&space_info->tickets);
 	INIT_LIST_HEAD(&space_info->priority_tickets);
 	space_info->clamp = 1;
+	btrfs_update_space_info_chunk_size(space_info, calc_chunk_size(info, flags));
 
 	if (btrfs_is_zoned(info))
 		space_info->bg_reclaim_threshold = BTRFS_DEFAULT_ZONED_RECLAIM_THRESH;
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index c096695598c1..e7de24a529cf 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -25,6 +25,8 @@ struct btrfs_space_info {
 	u64 max_extent_size;	/* This will hold the maximum extent size of
 				   the space info if we had an ENOSPC in the
 				   allocator. */
+	/* Chunk size in bytes */
+	u64 chunk_size;
 
 	/*
 	 * Once a block group drops below this threshold (percents) we'll
@@ -123,6 +125,8 @@ void btrfs_update_space_info(struct btrfs_fs_info *info, u64 flags,
 			     u64 total_bytes, u64 bytes_used,
 			     u64 bytes_readonly, u64 bytes_zone_unusable,
 			     struct btrfs_space_info **space_info);
+void btrfs_update_space_info_chunk_size(struct btrfs_space_info *space_info,
+					u64 chunk_size);
 struct btrfs_space_info *btrfs_find_space_info(struct btrfs_fs_info *info,
 					       u64 flags);
 u64 __pure btrfs_space_info_used(struct btrfs_space_info *s_info,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9c20049d1fec..9cd9d06f5469 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5071,26 +5071,16 @@ static void init_alloc_chunk_ctl_policy_regular(
 				struct btrfs_fs_devices *fs_devices,
 				struct alloc_chunk_ctl *ctl)
 {
-	u64 type = ctl->type;
+	struct btrfs_space_info *space_info;
 
-	if (type & BTRFS_BLOCK_GROUP_DATA) {
-		ctl->max_stripe_size = SZ_1G;
-		ctl->max_chunk_size = BTRFS_MAX_DATA_CHUNK_SIZE;
-	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
-		/* For larger filesystems, use larger metadata chunks */
-		if (fs_devices->total_rw_bytes > 50ULL * SZ_1G)
-			ctl->max_stripe_size = SZ_1G;
-		else
-			ctl->max_stripe_size = SZ_256M;
-		ctl->max_chunk_size = ctl->max_stripe_size;
-	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		ctl->max_stripe_size = SZ_32M;
-		ctl->max_chunk_size = 2 * ctl->max_stripe_size;
-		ctl->devs_max = min_t(int, ctl->devs_max,
-				      BTRFS_MAX_DEVS_SYS_CHUNK);
-	} else {
-		BUG();
-	}
+	space_info = btrfs_find_space_info(fs_devices->fs_info, ctl->type);
+	ASSERT(space_info);
+
+	ctl->max_chunk_size = READ_ONCE(space_info->chunk_size);
+	ctl->max_stripe_size = ctl->max_chunk_size;
+
+	if (ctl->type & BTRFS_BLOCK_GROUP_SYSTEM)
+		ctl->devs_max = min_t(int, ctl->devs_max, BTRFS_MAX_DEVS_SYS_CHUNK);
 
 	/* We don't want a chunk larger than 10% of writable space */
 	ctl->max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
-- 
2.35.1



