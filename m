Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4113C8B31
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 20:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbhGNSu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 14:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240084AbhGNSu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 14:50:26 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7609C061766
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 11:47:33 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id j184so2616659qkd.6
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 11:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nfMkZOCop8rCTuWPUwcOk31VcZ9PT/ircxMz2xSNZAU=;
        b=IwiHhNV3l/UEgD9whti5lVVACGaczf1jo57Ss1JEf3gSmq0fhgqReJcT3LMVOP1a9L
         lumz/2SOxWy7+pAU7AVONMuRzgBkU+qpEpFp336RHsjA705cFqCsObOJxJNG4WORfCzI
         Y9Jd3+ZP7rCivrNHg0SW7cgYuijke9k5I01AqBITHKHOU9WW0ZwgZ71XRZA1a1qq2okP
         Q+UUjI9aLsqQeM1wcafqZMHApQS1YxcqZiq9qpoVMWjijKYcHhRtokCWppuSpTMe4Xwb
         v1Juv5gZdvWte8tjA2dgMMwlMdQOcSTlptb9sSE0Td2TkI0DrRq+0xsgAJ8U2JUAVTAV
         rdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nfMkZOCop8rCTuWPUwcOk31VcZ9PT/ircxMz2xSNZAU=;
        b=IAbXxLmrNv9YDtmkxgwai4G/jdEm+W3OdeT+xQlGVjlu4bnrD4qtNiVyZiePzvDdSz
         PL0u9lEFNV+3Yt6LOcYMucInKD087QyztrxNTzMe9/zLCIJaq1xHs4VyEFzYwuelgLfP
         MURzuimO8so/kP+M961No++/yqTQK/kRATkGiyMKA8Ppq/sTxvFLztwbzqG3p0xdcS+z
         bLgH0LPx4xGOQUqfJ0Pl5c+kxe1AhdUC4qJKkf5pWs1dKVN4kaaZ5aJR9ve3WfYEXi8I
         PLX43Kt4I6okJ5fypdMqXzHcjr/mBqNkRsJy0JMYkkTAbcfODA35uvr9Z46hJJkWWGcP
         ClVw==
X-Gm-Message-State: AOAM532m+dfht/ecOEtzOKsBnW/2emI9gghiwHWCIW5tG1XOiPo3vQni
        KhR5YZq9POqyTx7zgRx1b/iFlg==
X-Google-Smtp-Source: ABdhPJyhvidQvC8DnXNrL68MUooA9iRV9+8wJnjGK5T+vZpH7D5dEeEfPxYsoYVtQ73vues3H30gqQ==
X-Received: by 2002:a37:4685:: with SMTP id t127mr11397515qka.384.1626288452995;
        Wed, 14 Jul 2021 11:47:32 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id k24sm1397062qkk.25.2021.07.14.11.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 11:47:32 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fsdevel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v3 4/9] btrfs: handle shrink_delalloc pages calculation differently
Date:   Wed, 14 Jul 2021 14:47:20 -0400
Message-Id: <725c04f4a0f9d495e0ba56b7fe1276c6bc4bc9a1.1626288241.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1626288241.git.josef@toxicpanda.com>
References: <cover.1626288241.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h             |  9 ++++----
 fs/btrfs/space-info.c        | 40 +++++++++++++++++++++++++-----------
 include/trace/events/btrfs.h |  1 +
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d7ef4d7d2c1a..232ff1a49ca6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2783,10 +2783,11 @@ enum btrfs_flush_state {
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
index af161eb808a2..1a7e44dd0ba7 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -494,6 +494,11 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
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
@@ -501,22 +506,21 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
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
@@ -596,8 +600,11 @@ static void flush_space(struct btrfs_fs_info *fs_info,
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
@@ -907,6 +914,14 @@ static void btrfs_async_reclaim_metadata_space(struct work_struct *work)
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
@@ -1070,7 +1085,7 @@ static void btrfs_preempt_reclaim_metadata_space(struct work_struct *work)
  *   so if we now have space to allocate do the force chunk allocation.
  */
 static const enum btrfs_flush_state data_flush_states[] = {
-	FLUSH_DELALLOC_WAIT,
+	FLUSH_DELALLOC_FULL,
 	RUN_DELAYED_IPUTS,
 	COMMIT_TRANS,
 	ALLOC_CHUNK_FORCE,
@@ -1159,6 +1174,7 @@ static const enum btrfs_flush_state evict_flush_states[] = {
 	FLUSH_DELAYED_REFS,
 	FLUSH_DELALLOC,
 	FLUSH_DELALLOC_WAIT,
+	FLUSH_DELALLOC_FULL,
 	ALLOC_CHUNK,
 	COMMIT_TRANS,
 };
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d754c6ec1797..e21744a3cdb6 100644
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

