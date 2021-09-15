Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E65A40C456
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 13:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbhIOLXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 07:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232586AbhIOLXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 07:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A339860F46;
        Wed, 15 Sep 2021 11:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631704919;
        bh=vxKpSJwXSmrU1zndbaowTxj2xZaMWs3jXyM9b2weRCQ=;
        h=Subject:To:Cc:From:Date:From;
        b=EE7kZd+RBtuXpDnePB7pQWnKaDuC9BoEIKzLJ3m4X+uPhElZi78TXeycizkf+RIhn
         fj++6+2MsUmkrTrromjt+mnMQJPsnIiPtNUNOBJzaWdHO8+6w/xG3GA39SHpjPHQ5j
         Ml8BFNswLKZyBUh0co44hTYoMNlfIVvhOHwCUxms=
Subject: FAILED: patch "[PATCH] btrfs: use delalloc_bytes to determine flush amount for" failed to apply to 5.10-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 13:21:56 +0200
Message-ID: <1631704916153240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 03fe78cc2942c55cc13be5ca42578750f17204a1 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 14 Jul 2021 14:47:20 -0400
Subject: [PATCH] btrfs: use delalloc_bytes to determine flush amount for
 shrink_delalloc

We have been hitting some early ENOSPC issues in production with more
recent kernels, and I tracked it down to us simply not flushing delalloc
as aggressively as we should be.  With tracing I was seeing us failing
all tickets with all of the block rsvs at or around 0, with very little
pinned space, but still around 120MiB of outstanding bytes_may_used.
Upon further investigation I saw that we were flushing around 14 pages
per shrink call for delalloc, despite having around 2GiB of delalloc
outstanding.

Consider the example of a 8 way machine, all CPUs trying to create a
file in parallel, which at the time of this commit requires 5 items to
do.  Assuming a 16k leaf size, we have 10MiB of total metadata reclaim
size waiting on reservations.  Now assume we have 128MiB of delalloc
outstanding.  With our current math we would set items to 20, and then
set to_reclaim to 20 * 256k, or 5MiB.

Assuming that we went through this loop all 3 times, for both
FLUSH_DELALLOC and FLUSH_DELALLOC_WAIT, and then did the full loop
twice, we'd only flush 60MiB of the 128MiB delalloc space.  This could
leave a fair bit of delalloc reservations still hanging around by the
time we go to ENOSPC out all the remaining tickets.

Fix this two ways.  First, change the calculations to be a fraction of
the total delalloc bytes on the system.  Prior to this change we were
calculating based on dirty inodes so our math made more sense, now it's
just completely unrelated to what we're actually doing.

Second add a FLUSH_DELALLOC_FULL state, that we hold off until we've
gone through the flush states at least once.  This will empty the system
of all delalloc so we're sure to be truly out of space when we start
failing tickets.

I'm tagging stable 5.10 and forward, because this is where we started
using the page stuff heavily again.  This affects earlier kernel
versions as well, but would be a pain to backport to them as the
flushing mechanisms aren't the same.

CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3cccf0f05666..fd3084feb4b5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2779,10 +2779,11 @@ enum btrfs_flush_state {
 	FLUSH_DELAYED_REFS	=	4,
 	FLUSH_DELALLOC		=	5,
 	FLUSH_DELALLOC_WAIT	=	6,
-	ALLOC_CHUNK		=	7,
-	ALLOC_CHUNK_FORCE	=	8,
-	RUN_DELAYED_IPUTS	=	9,
-	COMMIT_TRANS		=	10,
+	FLUSH_DELALLOC_FULL	=	7,
+	ALLOC_CHUNK		=	8,
+	ALLOC_CHUNK_FORCE	=	9,
+	RUN_DELAYED_IPUTS	=	10,
+	COMMIT_TRANS		=	11,
 };
 
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index fbd492fe87f9..eb90a262563f 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -493,6 +493,11 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
 	long time_left;
 	int loops;
 
+	delalloc_bytes = percpu_counter_sum_positive(&fs_info->delalloc_bytes);
+	ordered_bytes = percpu_counter_sum_positive(&fs_info->ordered_bytes);
+	if (delalloc_bytes == 0 && ordered_bytes == 0)
+		return;
+
 	/* Calc the number of the pages we need flush for space reservation */
 	if (to_reclaim == U64_MAX) {
 		items = U64_MAX;
@@ -500,22 +505,21 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
 		/*
 		 * to_reclaim is set to however much metadata we need to
 		 * reclaim, but reclaiming that much data doesn't really track
-		 * exactly, so increase the amount to reclaim by 2x in order to
-		 * make sure we're flushing enough delalloc to hopefully reclaim
-		 * some metadata reservations.
+		 * exactly.  What we really want to do is reclaim full inode's
+		 * worth of reservations, however that's not available to us
+		 * here.  We will take a fraction of the delalloc bytes for our
+		 * flushing loops and hope for the best.  Delalloc will expand
+		 * the amount we write to cover an entire dirty extent, which
+		 * will reclaim the metadata reservation for that range.  If
+		 * it's not enough subsequent flush stages will be more
+		 * aggressive.
 		 */
+		to_reclaim = max(to_reclaim, delalloc_bytes >> 3);
 		items = calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
-		to_reclaim = items * EXTENT_SIZE_PER_ITEM;
 	}
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 
-	delalloc_bytes = percpu_counter_sum_positive(
-						&fs_info->delalloc_bytes);
-	ordered_bytes = percpu_counter_sum_positive(&fs_info->ordered_bytes);
-	if (delalloc_bytes == 0 && ordered_bytes == 0)
-		return;
-
 	/*
 	 * If we are doing more ordered than delalloc we need to just wait on
 	 * ordered extents, otherwise we'll waste time trying to flush delalloc
@@ -595,8 +599,11 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		break;
 	case FLUSH_DELALLOC:
 	case FLUSH_DELALLOC_WAIT:
+	case FLUSH_DELALLOC_FULL:
+		if (state == FLUSH_DELALLOC_FULL)
+			num_bytes = U64_MAX;
 		shrink_delalloc(fs_info, space_info, num_bytes,
-				state == FLUSH_DELALLOC_WAIT, for_preempt);
+				state != FLUSH_DELALLOC, for_preempt);
 		break;
 	case FLUSH_DELAYED_REFS_NR:
 	case FLUSH_DELAYED_REFS:
@@ -906,6 +913,14 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
 				commit_cycles--;
 		}
 
+		/*
+		 * We do not want to empty the system of delalloc unless we're
+		 * under heavy pressure, so allow one trip through the flushing
+		 * logic before we start doing a FLUSH_DELALLOC_FULL.
+		 */
+		if (flush_state == FLUSH_DELALLOC_FULL && !commit_cycles)
+			flush_state++;
+
 		/*
 		 * We don't want to force a chunk allocation until we've tried
 		 * pretty hard to reclaim space.  Think of the case where we
@@ -1069,7 +1084,7 @@ static void btrfs_preempt_reclaim_metadata_space(struct work_struct *work)
  *   so if we now have space to allocate do the force chunk allocation.
  */
 static const enum btrfs_flush_state data_flush_states[] = {
-	FLUSH_DELALLOC_WAIT,
+	FLUSH_DELALLOC_FULL,
 	RUN_DELAYED_IPUTS,
 	COMMIT_TRANS,
 	ALLOC_CHUNK_FORCE,
@@ -1158,6 +1173,7 @@ static const enum btrfs_flush_state evict_flush_states[] = {
 	FLUSH_DELAYED_REFS,
 	FLUSH_DELALLOC,
 	FLUSH_DELALLOC_WAIT,
+	FLUSH_DELALLOC_FULL,
 	ALLOC_CHUNK,
 	COMMIT_TRANS,
 };
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index c7d19eadecc5..8f58fd95efc7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -94,6 +94,7 @@ struct btrfs_space_info;
 	EM( FLUSH_DELAYED_ITEMS,	"FLUSH_DELAYED_ITEMS")		\
 	EM( FLUSH_DELALLOC,		"FLUSH_DELALLOC")		\
 	EM( FLUSH_DELALLOC_WAIT,	"FLUSH_DELALLOC_WAIT")		\
+	EM( FLUSH_DELALLOC_FULL,	"FLUSH_DELALLOC_FULL")		\
 	EM( FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR")	\
 	EM( FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS")		\
 	EM( ALLOC_CHUNK,		"ALLOC_CHUNK")			\

