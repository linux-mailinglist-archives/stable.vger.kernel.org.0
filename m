Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA1E341C84
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhCSMVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhCSMU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A489964F6C;
        Fri, 19 Mar 2021 12:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156456;
        bh=1MTkm042vse54eIC6ZhlMiYR+9AAHpZ7IZqZypRxE/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ln85ZeT2fv6GowZk4XOgfbmsjbdXIKsuA1YE/o4f6EVp3Ktuzs5qwRE8QczHtvmnY
         BaNL9KWsvhW9/PyRaOlRl0qCHaA6nnQxFg5EjmPZTZoRO2v56MA+C41z4iRV2JDsAS
         uoJcXSX+cSbHjchEb2jESUmo5XQPLA/nHCi0QwPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 08/31] io_uring: refactor io_cqring_wait
Date:   Fri, 19 Mar 2021 13:19:02 +0100
Message-Id: <20210319121747.475187738@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit eeb60b9ab4000d20261973642dfc9fb0e4b5d073 ]

It's easy to make a mistake in io_cqring_wait() because for all
break/continue clauses we need to watch for prepare/finish_wait to be
used correctly. Extract all those into a new helper
io_cqring_wait_schedule(), and transforming the loop into simple series
of func calls: prepare(); check_and_schedule(); finish();

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3e610ac062a3..7621978e9fc8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7208,6 +7208,25 @@ static int io_run_task_work_sig(void)
 	return -EINTR;
 }
 
+/* when returns >0, the caller should retry */
+static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq,
+					  signed long *timeout)
+{
+	int ret;
+
+	/* make sure we run task_work before checking for signals */
+	ret = io_run_task_work_sig();
+	if (ret || io_should_wake(iowq))
+		return ret;
+	/* let the caller flush overflows, retry */
+	if (test_bit(0, &ctx->cq_check_overflow))
+		return 1;
+
+	*timeout = schedule_timeout(*timeout);
+	return !*timeout ? -ETIME : 1;
+}
+
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
@@ -7264,27 +7283,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		/* make sure we run task_work before checking for signals */
-		ret = io_run_task_work_sig();
-		if (ret > 0) {
-			finish_wait(&ctx->wait, &iowq.wq);
-			continue;
-		}
-		else if (ret < 0)
-			break;
-		if (io_should_wake(&iowq))
-			break;
-		if (test_bit(0, &ctx->cq_check_overflow)) {
-			finish_wait(&ctx->wait, &iowq.wq);
-			continue;
-		}
-		timeout = schedule_timeout(timeout);
-		if (timeout == 0) {
-			ret = -ETIME;
-			break;
-		}
-	} while (1);
-	finish_wait(&ctx->wait, &iowq.wq);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
+		finish_wait(&ctx->wait, &iowq.wq);
+	} while (ret > 0);
 
 	restore_saved_sigmask_unless(ret == -EINTR);
 
-- 
2.30.1



