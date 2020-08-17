Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916BA2476E2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgHQTmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729339AbgHQPYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:24:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA19233E2;
        Mon, 17 Aug 2020 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677863;
        bh=Jptlc0QXE/ISLzp4b1//9H8rIqEhyvUeWJqL+PW7trA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0khGRhWu5P60XRiaLyb26j0xB+QPHRNX9fq2JjbY3AaC67rYU4jfRiwlEBUolbWzL
         i0BSCssfNF3r/I1PN742uJQO3WtQ3jyJ5KhpqR6yLS+R14lg1Ras96ZNokjYjefCRZ
         Z2fb+qNum6qjIfrpCx7Gu/phmz4EAaEH04oLqihg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 136/464] io_uring: fix racy overflow count reporting
Date:   Mon, 17 Aug 2020 17:11:29 +0200
Message-Id: <20200817143840.330114797@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit b2bd1cf99f3e7c8fbf12ea07af2c6998e1209e25 ]

All ->cq_overflow modifications should be under completion_lock,
otherwise it can report a wrong number to the userspace. Fix it in
io_uring_cancel_files().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d732566955d37..1d8761a9f3b88 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7536,10 +7536,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				clear_bit(0, &ctx->cq_check_overflow);
 				ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
 			}
-			spin_unlock_irq(&ctx->completion_lock);
-
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
+			spin_unlock_irq(&ctx->completion_lock);
 
 			/*
 			 * Put inflight ref and overflow ref. If that's
-- 
2.25.1



