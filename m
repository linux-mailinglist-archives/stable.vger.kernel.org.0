Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C872F7A44
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733301AbhAOMr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:47:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387935AbhAOMhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00B03221FA;
        Fri, 15 Jan 2021 12:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714202;
        bh=BxmIAMdG89iHN/38PYDLk++RJW7/+eVVuOjPPnu67ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ft36D8YXkdDXrViYDZv/A+fuQ+zexn3O6RG1ROeDKrY/ljkMwOYKlYOrCEj9lyvIu
         97Ov28yO5t23/yLZjC/kzsMdm+KeLKqR7J22oeqMI2RXp6HNsoRditQX2MlNDpcMFH
         OvqxAbfeq+BTeIY0BbHYvtauzY4amkKrh8UlFUtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/103] io_uring: limit {io|sq}poll submit locking scope
Date:   Fri, 15 Jan 2021 13:26:56 +0100
Message-Id: <20210115122006.218426504@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 89448c47b8452b67c146dc6cad6f737e004c5caf upstream

We don't need to take uring_lock for SQPOLL|IOPOLL to do
io_cqring_overflow_flush() when cq_overflow_list is empty, remove it
from the hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3974b4f124b6a..5ba312ab99786 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9024,10 +9024,13 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
-		if (!list_empty_careful(&ctx->cq_overflow_list))
+		if (!list_empty_careful(&ctx->cq_overflow_list)) {
+			bool needs_lock = ctx->flags & IORING_SETUP_IOPOLL;
+
+			io_ring_submit_lock(ctx, needs_lock);
 			io_cqring_overflow_flush(ctx, false, NULL, NULL);
-		io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
+			io_ring_submit_unlock(ctx, needs_lock);
+		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)
-- 
2.27.0



