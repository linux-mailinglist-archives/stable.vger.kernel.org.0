Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0864A397ACB
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 21:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhFATqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 15:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbhFATqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 15:46:54 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D407C061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 12:45:12 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id eb9so62699qvb.6
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 12:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cp0KD1ir/LUiHPd+zeSbTtWqjTcol8MP6KdLYih4sNk=;
        b=ou4S+kDRupA6r2In5fWySlOuAe4DGB1axRhmp8L0PSOnbn0eZQfzCyG2OURIxD6DEb
         aKlaXYAM03Y4snAcmOx6o6pjipVn5bPULgrwaKCEzi+zvsJb8MVyjytgM+rs7hfBt1VT
         QgzdeDO12SOV55ordxzbN1ROnxlVIrRoZJ72xIjnI/fgouufmHkAQgdMpm+to3MFJpxc
         +U5PrOs6jkdzOIbdZl/ddcUrAgdPHq7EfnVE0V0xBKYJ2kM9SXONXyswkdFQU5PkGg2R
         LO/QNH9qyM9ATzt4FoLYtSNWJPuhPG8WFPVTtdCzIAJUOJyni89RfH2Ml7U1wvrt3vXT
         ScVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cp0KD1ir/LUiHPd+zeSbTtWqjTcol8MP6KdLYih4sNk=;
        b=jpGuThncjs/28Oi6YwjFIBYoUUoq98Tk4ErWActgX4bRVSaoHuE3apvM7qu27ASz39
         f1A8COJbLFHmwwob/PCiuGECY0gOsM661gL4mbAYVwhJKC20PGpjZEZDxdrOlRbA+Xrn
         5RCb+Iu5j1x0rMecWh4O7U/4t314kqXHpd6i/QYqvMzvNtcZGbyRjp5YbrMj8Be2prBL
         YnE9eblvNh5BikzdqghJJj+WpyCWQX9OxyFAmxJUQlNbLZF6wlnvLcSCPmY2fZHsHzks
         bfi0Zv4u6eYm5aDovTXndcXcu+tZdSu2lpMdP9sODuBDwhPF89AWKNfhZZlwd6htejPy
         y9GA==
X-Gm-Message-State: AOAM533DsTrlNL1vH+cxVBwBlnQ0h3LJb+ZIKLffuQNH7Kvw14136l0x
        pDDcT5CEc7pUTbKW8EG4AvSl7w==
X-Google-Smtp-Source: ABdhPJxm5YhhSFKrnnSzzdjx1LtzADpDtwhnXoPPshaZH6cmoYvbIrjzeOYoZAVfT16rk3jrOMQRAQ==
X-Received: by 2002:a05:6214:17cb:: with SMTP id cu11mr24467301qvb.27.1622576711138;
        Tue, 01 Jun 2021 12:45:11 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id v17sm10461944qta.77.2021.06.01.12.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 12:45:09 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] btrfs: handle shrink_delalloc pages calculation differently
Date:   Tue,  1 Jun 2021 15:45:08 -0400
Message-Id: <f17b840611935b5f58bfcdbe050a942c33b90a60.1622576697.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have been hitting some early ENOSPC issues in production with more
recent kernels, and I tracked it down to us simply not flushing delalloc
as aggressively as we should be.  With tracing I was seeing us failing
all tickets with all of the block rsvs at or around 0, with very little
pinned space, but still around 120mib of outstanding bytes_may_used.
Upon further investigation I saw that we were flushing around 14 pages
per shrink call for delalloc, despite having around 2gib of delalloc
outstanding.

Consider the example of a 8 way machine, all cpu's trying to create a
file in parallel, which at the time of this commit requires 5 items to
do.  Assuming a 16k leaf size, we have 10mib of total metadata reclaim
size waiting on reservations.  Now assume we have 128mib of delalloc
outstanding.  With our current math we would set items to 20, and then
set to_reclaim to 20 * 256k, or 5mib.

Assuming that we went through this loop all 3 times, for both
FLUSH_DELALLOC and FLUSH_DELALLOC_WAIT, and then did the full loop
twice, we'd only flush 60mib of the 128mib delalloc space.  This could
leave a fair bit of delalloc reservations still hanging around by the
time we go to ENOSPC out all the remaining tickets.

Fix this two ways.  First, change the calculations to be a fraction of
the total delalloc bytes on the system.  Prior to my change we were
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

CC: stable@vger.kernel.org # 5.10
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h             | 11 ++++++-----
 fs/btrfs/space-info.c        | 36 +++++++++++++++++++++++++++---------
 include/trace/events/btrfs.h |  1 +
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5d0398528a7a..20d7121225d9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2788,11 +2788,12 @@ enum btrfs_flush_state {
 	FLUSH_DELAYED_REFS	=	4,
 	FLUSH_DELALLOC		=	5,
 	FLUSH_DELALLOC_WAIT	=	6,
-	ALLOC_CHUNK		=	7,
-	ALLOC_CHUNK_FORCE	=	8,
-	RUN_DELAYED_IPUTS	=	9,
-	COMMIT_TRANS		=	10,
-	FORCE_COMMIT_TRANS	=	11,
+	FLUSH_DELALLOC_FULL	=	7,
+	ALLOC_CHUNK		=	8,
+	ALLOC_CHUNK_FORCE	=	9,
+	RUN_DELAYED_IPUTS	=	10,
+	COMMIT_TRANS		=	11,
+	FORCE_COMMIT_TRANS	=	12,
 };
 
 int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 42d0fa2092d4..fc329aff478f 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -505,6 +505,10 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
 	long time_left;
 	int loops;
 
+	delalloc_bytes = percpu_counter_sum_positive(
+						&fs_info->delalloc_bytes);
+	ordered_bytes = percpu_counter_sum_positive(&fs_info->ordered_bytes);
+
 	/* Calc the number of the pages we need flush for space reservation */
 	if (to_reclaim == U64_MAX) {
 		items = U64_MAX;
@@ -512,19 +516,21 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
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
 	if (delalloc_bytes == 0 && ordered_bytes == 0)
 		return;
 
@@ -710,8 +716,11 @@ static void flush_space(struct btrfs_fs_info *fs_info,
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
@@ -1037,6 +1046,14 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
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
@@ -1219,7 +1236,7 @@ static void btrfs_preempt_reclaim_metadata_space(struct work_struct *work)
  *   so if we now have space to allocate do the force chunk allocation.
  */
 static const enum btrfs_flush_state data_flush_states[] = {
-	FLUSH_DELALLOC_WAIT,
+	FLUSH_DELALLOC_FULL,
 	RUN_DELAYED_IPUTS,
 	FLUSH_DELAYED_REFS,
 	COMMIT_TRANS,
@@ -1309,6 +1326,7 @@ static const enum btrfs_flush_state evict_flush_states[] = {
 	FLUSH_DELAYED_REFS,
 	FLUSH_DELALLOC,
 	FLUSH_DELALLOC_WAIT,
+	FLUSH_DELALLOC_FULL,
 	ALLOC_CHUNK,
 	COMMIT_TRANS,
 };
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 76e0be7e14d0..8144b8e345b5 100644
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
-- 
2.26.3

