Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA80240FF0
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgHJT03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729401AbgHJTLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:11:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8842A22B49;
        Mon, 10 Aug 2020 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086707;
        bh=KfnS8rSZxaFmslx0t3L9hROip2WhK+ZlQd5KilZsheg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIxLOXWbIZ7PdgblWahxF/BosWuHr3cru9Hy8tIApDR0PTt4aCooHn6X1IL00/Qen
         NKTOtPLKA27UP186sFkUYKgXDLEj/GrcTVEVpnVswCEZbGz6jJaLlu9eIZ4zNJVY93
         6X5ABRoSn/dKGQGVxqLLNl1ZT0YXvIrIYCB0adak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 57/60] io_uring: fix racy overflow count reporting
Date:   Mon, 10 Aug 2020 15:10:25 -0400
Message-Id: <20200810191028.3793884-57-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191028.3793884-1-sashal@kernel.org>
References: <20200810191028.3793884-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 80a612d1e12bb..d04fede20acb8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7573,10 +7573,9 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				clear_bit(0, &ctx->sq_check_overflow);
 				clear_bit(0, &ctx->cq_check_overflow);
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

