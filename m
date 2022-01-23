Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BBC496F02
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbiAWAPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbiAWAOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:14:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D802C0617BD;
        Sat, 22 Jan 2022 16:13:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75A62CE0AC8;
        Sun, 23 Jan 2022 00:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8E4C004E1;
        Sun, 23 Jan 2022 00:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896775;
        bh=HDcG4XHnKQR2EYsnCiCD99ex1SLaB3RdyJgfkBuuN64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3E86InD6zYCOIr6K+j9jaoX09SevSge1cyz46gMd3SUrkwepACHUq1DurncQ9sMT
         c9aLXGY4Oe26M226BSgsbUoXEyINCj6YiE9cxZs+A6ZuFLIccPhb2u4gslrlQvMXd1
         1sgHIXM32xFItn2Vdwb/6cYAKv+ymsyNxLutGcmu6ZK+NNblym34GU2yUMBUlbXGCD
         /bN9GrIkNPQeiF80fsSyehfuZDBx1ImX5peZG6AtTy/cwGsCVq+35uzEej1yFncDcR
         OnMYXGDxwdaa0vbQoHfQ+xl1c02rhzRlSjxeUjwRgEWClC7i/M89C8j17v/sdn7FC+
         IpZGlCKbuASqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Florian Fischer <florian.fl.fischer@fau.de>,
        Sasha Levin <sashal@kernel.org>, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/16] io_uring: perform poll removal even if async work removal is successful
Date:   Sat, 22 Jan 2022 19:12:14 -0500
Message-Id: <20220123001216.2460383-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001216.2460383-1-sashal@kernel.org>
References: <20220123001216.2460383-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit ccbf726171b7328f800bc98005132fd77eb1a175 ]

An active work can have poll armed, hence it's not enough to just do
the async work removal and return the value if it's different from "not
found". Rather than make poll removal special, just fall through to do
the remaining type lookups and removals.

Reported-by: Florian Fischer <florian.fl.fischer@fau.de>
Link: https://lore.kernel.org/io-uring/20220118151337.fac6cthvbnu7icoc@pasture/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0006fc7479ca3..dbdd8c77774c1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6304,16 +6304,21 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	if (ret != -ENOENT)
-		return ret;
+	/*
+	 * Fall-through even for -EALREADY, as we may have poll armed
+	 * that need unarming.
+	 */
+	if (!ret)
+		return 0;
 
 	spin_lock(&ctx->completion_lock);
+	ret = io_poll_cancel(ctx, sqe_addr, false);
+	if (ret != -ENOENT)
+		goto out;
+
 	spin_lock_irq(&ctx->timeout_lock);
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	spin_unlock_irq(&ctx->timeout_lock);
-	if (ret != -ENOENT)
-		goto out;
-	ret = io_poll_cancel(ctx, sqe_addr, false);
 out:
 	spin_unlock(&ctx->completion_lock);
 	return ret;
-- 
2.34.1

