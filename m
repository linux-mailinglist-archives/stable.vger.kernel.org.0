Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538153788DF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhEJLYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233167AbhEJLL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB48161936;
        Mon, 10 May 2021 11:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644978;
        bh=8shmzH3c7GFcFL5Qasds/vY2HEu2lXqyzngt3B4fMto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhiHz0vZ7bhcnf4CPkbon99Z2XPp7HowcYGJCtJiJqW6cUTU8+Nu6SWQul2hI2yAp
         G1qanUstPTqbNxRu1oH5Iq3HDON5JZsPY1MSGvUdBl3H7Q+qukIG9tD3GLEM2EjStd
         i0ugwExikc56sX7FjFvMoqJ/nI341a5rhdP54hdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 266/384] io_uring: safer sq_creds putting
Date:   Mon, 10 May 2021 12:20:55 +0200
Message-Id: <20210510102023.619191141@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 07db298a1c96bdba2102d60ad51fcecb961177c9 ]

Put sq_creds as a part of io_ring_ctx_free(), it's easy to miss doing it
in io_sq_thread_finish(), especially considering past mistakes related
to ring creation failures.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3becb1866467a1de82a97345a0a90d7fb8ff875e.1618916549.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dff34975d86b..0bc4727e8a90 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7200,8 +7200,6 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 
 		io_put_sq_data(sqd);
 		ctx->sq_data = NULL;
-		if (ctx->sq_creds)
-			put_cred(ctx->sq_creds);
 	}
 }
 
@@ -8469,6 +8467,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
+	if (ctx->sq_creds)
+		put_cred(ctx->sq_creds);
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
-- 
2.30.2



