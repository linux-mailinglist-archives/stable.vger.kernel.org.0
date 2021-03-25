Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683AC348F1C
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCYL0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230208AbhCYLZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE12D61A2F;
        Thu, 25 Mar 2021 11:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671532;
        bh=3aAwiDJbJWjKzu648+e+dshbpvG3suX0di5uBb7EySo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8i9ol8Pvi9RWccc9w50F6pULrAkjp3ERVmzu+BKy+6lLsva13G7EgY1pjfKV7Qvv
         NqnDD0ey+Kr90UGd4YIz4Qh0TWJpIj1CH7EiTDDXiIb6nkdxhrt6XPHvEj6zoRL3Y5
         bFvExQVgnm6CgajGeRcsCKIQWY3vY7P5p0OoFtIKnMuiFgwEG5zJE6RnDv+bML2j5f
         TyiQzO8MTwzx5trwg8to1FOOONHy6PAsuYG4bBvmvM06VYiMmyrOhVv8/vh6Gt5ET4
         8sOtpv12dUSd7gJh0+WuWm9eJheM3PrBdPksn8cWs/0dznYzt/UYoe2wm/oZnaITH1
         RMODYmqko2PzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 25/44] io_uring: halt SQO submission on ctx exit
Date:   Thu, 25 Mar 2021 07:24:40 -0400
Message-Id: <20210325112459.1926846-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit f6d54255f4235448d4bbe442362d4caa62da97d5 ]

io_sq_thread_finish() is called in io_ring_ctx_free(), so SQPOLL task is
potentially running submitting new requests. It's not a disaster because
of using a "try" variant of percpu_ref_get, but is far from nice.

Remove ctx from the sqd ctx list earlier, before cancellation loop, so
SQPOLL can't find it and so won't submit new requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b82fe753a6d0..8e45331d1fed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8797,6 +8797,14 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
+	/* prevent SQPOLL from submitting new requests */
+	if (ctx->sq_data) {
+		io_sq_thread_park(ctx->sq_data);
+		list_del_init(&ctx->sqd_list);
+		io_sqd_update_thread_idle(ctx->sq_data);
+		io_sq_thread_unpark(ctx->sq_data);
+	}
+
 	io_kill_timeouts(ctx, NULL, NULL);
 	io_poll_remove_all(ctx, NULL, NULL);
 
-- 
2.30.1

