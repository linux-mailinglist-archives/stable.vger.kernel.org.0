Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0598E304ABE
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730217AbhAZE7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731072AbhAYSuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 955A2229C5;
        Mon, 25 Jan 2021 18:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600579;
        bh=JSqO86IcU7wWeh0jt6MYWgKzZMeT5qwq0pmHSi2cXSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwv6zHoyKz0iBiOscG5UfdPvmfX0StMzI0P0kd98WgZtTb5kbFDUWk0RgFr30wN5B
         hYEjA1IvGQ94ZYytciedgY+AtURxcOIIXVzbCmRPO0tmg1i+zkVpQfIuCEN9fopPKa
         IK5wB2yxfxLwecHeTdbTHrVKsC2CTBUnRH83EonY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/199] io_uring: flush timeouts that should already have expired
Date:   Mon, 25 Jan 2021 19:38:12 +0100
Message-Id: <20210125183219.225369810@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 265aea2cd7bc8..2348104857000 100644
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
@@ -1521,19 +1522,38 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 
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
@@ -5582,6 +5602,12 @@ static int io_timeout(struct io_kiocb *req)
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



