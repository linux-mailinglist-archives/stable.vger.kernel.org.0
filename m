Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420522FC8FA
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbhATC3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730082AbhATB2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7379323357;
        Wed, 20 Jan 2021 01:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106016;
        bh=xdzNkLEH3zCwrxG009T3Crurf4ry+SI4WtpFGzT8TkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0Hwy9l0/mxT1mMl0hIURsg2ZuSGcki6Snidhowl5MsRgFS5AOlcgDYwVQOqusVYm
         CDIuK9Az7prJA5M/K7FJeHzmKDdUoQ7WJrS/+Ougy6assO26/0c1i4aIx1/gNb4i6L
         Kkv2EVApctFO2tLr3aiwyAdmix1wFTHOFjzGuxS/5aVCrLAb4fK6+hO3n0HMMgaYGb
         p9vcy/pzPwwui5QgATcV7w+NBTx8dDqKGo+Xy+3RrZ3ULm8j/hwiHfbcRhIzycqSsd
         bPmUw2NbHSZUkZxBtAMAyxR7ZU9DOnN7kYpWgeUkOMWlZUzzaKQ1iIHreakmMmOicq
         UfKv1+YlWmWCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 41/45] io_uring: flush timeouts that should already have expired
Date:   Tue, 19 Jan 2021 20:25:58 -0500
Message-Id: <20210120012602.769683-41-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Diop-Gonzalez <marcelo827@gmail.com>

[ Upstream commit f010505b78a4fa8d5b6480752566e7313fb5ca6e ]

Right now io_flush_timeouts() checks if the current number of events
is equal to ->timeout.target_seq, but this will miss some timeouts if
there have been more than 1 event added since the last time they were
flushed (possible in io_submit_flush_completions(), for example). Fix
it by recording the last sequence at which timeouts were flushed so
that the number of events seen can be compared to the number of events
needed without overflow.

Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4833b68f1a1cc..7e7103c57ec26 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -353,6 +353,7 @@ struct io_ring_ctx {
 		unsigned		cq_entries;
 		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
+		unsigned		cq_last_tm_flush;
 		unsigned long		cq_check_overflow;
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
@@ -1519,19 +1520,38 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 
 static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	while (!list_empty(&ctx->timeout_list)) {
+	u32 seq;
+
+	if (list_empty(&ctx->timeout_list))
+		return;
+
+	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+
+	do {
+		u32 events_needed, events_got;
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
 						struct io_kiocb, timeout.list);
 
 		if (io_is_timeout_noseq(req))
 			break;
-		if (req->timeout.target_seq != ctx->cached_cq_tail
-					- atomic_read(&ctx->cq_timeouts))
+
+		/*
+		 * Since seq can easily wrap around over time, subtract
+		 * the last seq at which timeouts were flushed before comparing.
+		 * Assuming not more than 2^31-1 events have happened since,
+		 * these subtractions won't have wrapped, so we can check if
+		 * target is in [last_seq, current_seq] by comparing the two.
+		 */
+		events_needed = req->timeout.target_seq - ctx->cq_last_tm_flush;
+		events_got = seq - ctx->cq_last_tm_flush;
+		if (events_got < events_needed)
 			break;
 
 		list_del_init(&req->timeout.list);
 		io_kill_timeout(req);
-	}
+	} while (!list_empty(&ctx->timeout_list));
+
+	ctx->cq_last_tm_flush = seq;
 }
 
 static void io_commit_cqring(struct io_ring_ctx *ctx)
@@ -5580,6 +5600,12 @@ static int io_timeout(struct io_kiocb *req)
 	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 	req->timeout.target_seq = tail + off;
 
+	/* Update the last seq here in case io_flush_timeouts() hasn't.
+	 * This is safe because ->completion_lock is held, and submissions
+	 * and completions are never mixed in the same ->completion_lock section.
+	 */
+	ctx->cq_last_tm_flush = tail;
+
 	/*
 	 * Insertion sort, ensuring the first entry in the list is always
 	 * the one we need first.
-- 
2.27.0

