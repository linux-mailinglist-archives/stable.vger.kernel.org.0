Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D6E353F82
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbhDEJMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239156AbhDEJM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:12:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3257C61394;
        Mon,  5 Apr 2021 09:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613940;
        bh=LDbmDOYY71KpJWzVmHeSXIW0uzAyNV2Jh/dhT506ZdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ej3cifyBBqY7muSSASAA901WR7KxGyjTFtr+aj7DodL3+T270tlAZfq5bQm5dl2G2
         M8BI922ySSPLWtAT6Ij8w7/fkjHB073axNq4Ivo3nxyc/YMGFwkuKJYWW3n9kSYgrc
         h3PrCY5N//VQsIEk8w4+NkeYNkzuOhIGcuZAcLlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 023/152] io_uring: halt SQO submission on ctx exit
Date:   Mon,  5 Apr 2021 10:52:52 +0200
Message-Id: <20210405085034.997896185@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 381f82ebd282..aaf9b5d49c17 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8800,6 +8800,14 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
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



