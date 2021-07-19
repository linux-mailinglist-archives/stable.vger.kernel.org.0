Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505B13CE45B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347194AbhGSPnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346190AbhGSPik (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC14260E0C;
        Mon, 19 Jul 2021 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711514;
        bh=euNVsQczHH08fRdHiWeAn7inWfpEXgXy04b321J2LD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klMzZExL1BrwqNakPHo/gxwDr1QT1uTEfNoBw4tgTlvM3UsaxL/OUiUwZgt36/rum
         cGJcTFItgfuac0hD4bzFMPmTawY3B1djex9LUlmjBM9QF/xir73alVpKdQ18QVllvN
         c7F759FKWEX8kcL5Vgsm5nHhsNOWOYBngjJjqnCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.12 030/292] io_uring: put link timeout req consistently
Date:   Mon, 19 Jul 2021 16:51:32 +0200
Message-Id: <20210719144943.520945560@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit df9727affa058f4f18e388b30247650f8ae13cd8 upstream.

Don't put linked timeout req in io_async_find_and_cancel() but do it in
io_link_timeout_fn(), so we have only one point for that and won't have
to do it differently as it's now (put vs put_deferred). Btw, improve a
bit io_async_find_and_cancel()'s locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d75b70957f245275ab7cba83e0ac9c1b86aae78a.1617287883.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5727,12 +5727,9 @@ static void io_async_find_and_cancel(str
 	int ret;
 
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	if (ret != -ENOENT) {
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		goto done;
-	}
-
 	spin_lock_irqsave(&ctx->completion_lock, flags);
+	if (ret != -ENOENT)
+		goto done;
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	if (ret != -ENOENT)
 		goto done;
@@ -5747,7 +5744,6 @@ done:
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	io_put_req(req);
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -6310,8 +6306,8 @@ static enum hrtimer_restart io_link_time
 		io_put_req_deferred(req, 1);
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
-		io_put_req_deferred(req, 1);
 	}
+	io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 


