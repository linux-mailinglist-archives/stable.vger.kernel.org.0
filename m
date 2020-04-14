Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385C91A7F4F
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 16:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733198AbgDNOOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 10:14:24 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53771 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728815AbgDNOOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 10:14:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 306A6285;
        Tue, 14 Apr 2020 10:14:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 10:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BIWnTB
        Xs8a8dW0f5rA8vbDr0ZeGCE7g8q6d08YaSYKc=; b=2P/FcwDv1rTFtGZpD9TgLU
        Vj7CQN+HeapA3jzq0lsraDTN+hitRGD9x5LzuvrwZvPdQiRrYhaW1CHLZyL9NeXe
        h2ms49pG9ybXG53g9CDuBrvBHCNeRi326y4yYwYFjXyNWoiHIBYs18gzRqdBh1UR
        6CB4eZnK9SdLlTHRM03O8tVU6SESzqzAcledA9nJjSMoRHn2VrVGv75uU9gs6ziZ
        NvwJy3Pc8o58OtD+E+SW3/Keijuoz+6oBwMfqgxCWg4I4yOpn4SlwqWIB6TQujo5
        ltmRoDiF4NroVPJQSA7G3RthfafuQvb/6QCbFG/mFyBzVzZwF0F84qvRNiQDhDug
        ==
X-ME-Sender: <xms:OcWVXpREDE_RvwEHtPWL0iWm6xh9QryMTS1Yj1b3X2jlv9wTla548g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OcWVXnAga98Tn9V177VOTzguHDsDvwyxhzgKwH_GexIXH76xEfZjiQ>
    <xmx:OcWVXp1crCgnwOQyWsCjCW_AYmMS4nIgQ5vIRwZTGCMCzDYTixE3Og>
    <xmx:OcWVXlWGU8I7EIIv9gqBmqo8XReELDRwpQLAYnkUC-H4odEiW8yTFw>
    <xmx:OcWVXh3_iA-vYjLD4Xs2RbJELo1Pt2btmVZCWaV1s5kFtBZgeNWsmg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 143F8328006A;
        Tue, 14 Apr 2020 10:14:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix btrfs_calc_reclaim_metadata_size calculation" failed to apply to 5.5-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 16:14:15 +0200
Message-ID: <158687365524765@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fa121a26b2ceabce613e0b4cfc7498cfde73fe8d Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 21 Feb 2020 16:41:10 -0500
Subject: [PATCH] btrfs: fix btrfs_calc_reclaim_metadata_size calculation

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

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 3b8d8fa8d767..9cb511d8cd9d 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -306,25 +306,19 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
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
@@ -345,6 +339,22 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
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
@@ -776,6 +786,7 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 {
 	struct reserve_ticket *ticket;
 	u64 used;
+	u64 avail;
 	u64 expected;
 	u64 to_reclaim = 0;
 
@@ -783,6 +794,20 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
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
 

