Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6885A1AC454
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506774AbgDPN5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506765AbgDPN5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:57:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E704420786;
        Thu, 16 Apr 2020 13:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045471;
        bh=HMkyFOAwE2LMU7wi/koqtjzzkjzWeV+5+pYzeCTOIaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joNl7O6tuJdzOQ3QsL1OhLppT1K5W/ZG8Y5312N3tVSoIU47xW9V4QHF+swZQypma
         xG8oCPqYYQr8HaazJ+alE55NQdkcV/f2IzA7osW6LLRyMBKNBAha9k0pu/vDmpsDnr
         quTNba2gIGSvVBMfUd/9uyCwfj+lj0OtPc/Qbl8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.6 149/254] btrfs: fix btrfs_calc_reclaim_metadata_size calculation
Date:   Thu, 16 Apr 2020 15:23:58 +0200
Message-Id: <20200416131345.212451956@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit fa121a26b2ceabce613e0b4cfc7498cfde73fe8d upstream.

I noticed while running my snapshot torture test that we were getting a
lot of metadata chunks allocated with very little actually used.
Digging into this we would commit the transaction, still not have enough
space, and then force a chunk allocation.

I noticed that we were barely flushing any delalloc at all, despite the
fact that we had around 13gib of outstanding delalloc reservations.  It
turns out this is because of our btrfs_calc_reclaim_metadata_size()
calculation.  It _only_ takes into account the outstanding ticket sizes,
which isn't the whole story.  In this particular workload we're slowly
filling up the disk, which means our overcommit space will suddenly
become a lot less, and our outstanding reservations will be well more
than what we can handle.  However we are only flushing based on our
ticket size, which is much less than we need to actually reclaim.

So fix btrfs_calc_reclaim_metadata_size() to take into account the
overage in the case that we've gotten less available space suddenly.
This makes it so we attempt to reclaim a lot more delalloc space, which
allows us to make our reservations and we no longer are allocating a
bunch of needless metadata chunks.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/space-info.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -159,25 +159,19 @@ static inline u64 calc_global_rsv_need_s
 	return (global->size << 1);
 }
 
-int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
-			 struct btrfs_space_info *space_info, u64 bytes,
-			 enum btrfs_reserve_flush_enum flush)
+static u64 calc_available_free_space(struct btrfs_fs_info *fs_info,
+			  struct btrfs_space_info *space_info,
+			  enum btrfs_reserve_flush_enum flush)
 {
 	u64 profile;
 	u64 avail;
-	u64 used;
 	int factor;
 
-	/* Don't overcommit when in mixed mode. */
-	if (space_info->flags & BTRFS_BLOCK_GROUP_DATA)
-		return 0;
-
 	if (space_info->flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		profile = btrfs_system_alloc_profile(fs_info);
 	else
 		profile = btrfs_metadata_alloc_profile(fs_info);
 
-	used = btrfs_space_info_used(space_info, true);
 	avail = atomic64_read(&fs_info->free_chunk_space);
 
 	/*
@@ -198,6 +192,22 @@ int btrfs_can_overcommit(struct btrfs_fs
 		avail >>= 3;
 	else
 		avail >>= 1;
+	return avail;
+}
+
+int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
+			 struct btrfs_space_info *space_info, u64 bytes,
+			 enum btrfs_reserve_flush_enum flush)
+{
+	u64 avail;
+	u64 used;
+
+	/* Don't overcommit when in mixed mode */
+	if (space_info->flags & BTRFS_BLOCK_GROUP_DATA)
+		return 0;
+
+	used = btrfs_space_info_used(space_info, true);
+	avail = calc_available_free_space(fs_info, space_info, flush);
 
 	if (used + bytes < space_info->total_bytes + avail)
 		return 1;
@@ -629,6 +639,7 @@ btrfs_calc_reclaim_metadata_size(struct
 {
 	struct reserve_ticket *ticket;
 	u64 used;
+	u64 avail;
 	u64 expected;
 	u64 to_reclaim = 0;
 
@@ -636,6 +647,20 @@ btrfs_calc_reclaim_metadata_size(struct
 		to_reclaim += ticket->bytes;
 	list_for_each_entry(ticket, &space_info->priority_tickets, list)
 		to_reclaim += ticket->bytes;
+
+	avail = calc_available_free_space(fs_info, space_info,
+					  BTRFS_RESERVE_FLUSH_ALL);
+	used = btrfs_space_info_used(space_info, true);
+
+	/*
+	 * We may be flushing because suddenly we have less space than we had
+	 * before, and now we're well over-committed based on our current free
+	 * space.  If that's the case add in our overage so we make sure to put
+	 * appropriate pressure on the flushing state machine.
+	 */
+	if (space_info->total_bytes + avail < used)
+		to_reclaim += used - (space_info->total_bytes + avail);
+
 	if (to_reclaim)
 		return to_reclaim;
 


