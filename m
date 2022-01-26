Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC6149D1E5
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiAZSkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiAZSkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 13:40:46 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EDEC06161C;
        Wed, 26 Jan 2022 10:40:45 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id u18so439764edt.6;
        Wed, 26 Jan 2022 10:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8fFcvf4lAvd2vovUI6OCWePCunkkWP1m60p4qpL5aeI=;
        b=Hx7OS0afiYcRG39Dr04lMGiSxzr6nn2tg9EvSHlTd9089IeTihWdvP4Qg3dNxh4Jem
         v3kAoCKMgN1AfoVOsOQPAZMWqCqptl8kw5dxIKvSJOYTqsZcSyy6bWZ0jMfutUnRnS/n
         gDHvNXLiyZsa+t055Ok4O7NlgPEIUUlv8TBR+kPh2VAmC9iFeXBxK6+2MXCT2oDh3hkG
         cbeitUF6bfktCL5KnM41r+AKjEJpiaU0ikorFFoGPJshe67j87xfbnd5dTyARDUhkmSv
         b1p3HNyaBN0ELAdiIHSjKkfpr4EgUt2sNs4hSpqBr/ew/O/01uKQCgLcoXzEAZ2lGhDh
         j1Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8fFcvf4lAvd2vovUI6OCWePCunkkWP1m60p4qpL5aeI=;
        b=f+tarGJIp//Jmj3C30HnUQKhcivUSxUQTVYc4KdDh8kOJi7yjGfted2PhnIfGhhTuQ
         Mdg82gY4ZHybRLWmY6bHT4LSIgIE1rf5jG7/W3dCW9vyS8/+rkElBbCQHZBPQdvifSYV
         1D4nMrzMOzspLaBmRGxxK/R6cAZ3O1VIMW5WsOD999zuTe4YTMUlEnfWwD/4Sre9PXUX
         pWy/i4c3HMHWL3KOTd05cqnbxy86QgEsikWXZUXCVwkssbrplwJIVwWVGMLcEWo1SxRt
         IqZw7c5GAiyatApJJHuBT7pkr+zAe3EpzYxkjH2XhLEn6i2LIDNWRw+irioG5GxRmgR3
         llNg==
X-Gm-Message-State: AOAM531w5n9fzPTZPecZHlwSxMf/gulGQvSwNRnE0EG96VImPONgzkCF
        +X+7Il5NWa89kstt5EcriwHP5U6g4SI=
X-Google-Smtp-Source: ABdhPJxKVNcWAyahjAWolINRwJiEn5XWTbpTdUK4gebOcEqN6NgWLTgEJhMPEqR9rhTGogAt9ALOzg==
X-Received: by 2002:a05:6402:134f:: with SMTP id y15mr273840edw.317.1643222443894;
        Wed, 26 Jan 2022 10:40:43 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id c5sm7751055ejz.88.2022.01.26.10.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 10:40:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH stable-5.15] io_uring: fix not released cached task refs
Date:   Wed, 26 Jan 2022 18:40:42 +0000
Message-Id: <a4ac202a5bb88dd8060d3e128b86e020d4d69343.1643222350.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ upstream commit 3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9 ]

tctx_task_work() may get run after io_uring cancellation and so there
will be no one to put cached in tctx task refs that may have been added
back by tw handlers using inline completion infra, Call
io_uring_drop_tctx_refs() at the end of the main tw handler to release
them.

Cc: stable@vger.kernel.org # 5.15+
Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Fixes: e98e49b2bbf7 ("io_uring: extend task put optimisations")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/69f226b35fbdb996ab799a8bbc1c06bf634ccec1.1641688805.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0006fc7479ca..b27a03219d36 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1760,6 +1760,18 @@ static inline void io_get_task_refs(int nr)
 		io_task_refs_refill(tctx);
 }
 
+static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
+{
+	struct io_uring_task *tctx = task->io_uring;
+	unsigned int refs = tctx->cached_refs;
+
+	if (refs) {
+		tctx->cached_refs = 0;
+		percpu_counter_sub(&tctx->inflight, refs);
+		put_task_struct_many(task, refs);
+	}
+}
+
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 				     long res, unsigned int cflags)
 {
@@ -2200,6 +2212,10 @@ static void tctx_task_work(struct callback_head *cb)
 	}
 
 	ctx_flush_and_put(ctx, &locked);
+
+	/* relaxed read is enough as only the task itself sets ->in_idle */
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		io_uring_drop_tctx_refs(current);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req)
@@ -9765,18 +9781,6 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static void io_uring_drop_tctx_refs(struct task_struct *task)
-{
-	struct io_uring_task *tctx = task->io_uring;
-	unsigned int refs = tctx->cached_refs;
-
-	if (refs) {
-		tctx->cached_refs = 0;
-		percpu_counter_sub(&tctx->inflight, refs);
-		put_task_struct_many(task, refs);
-	}
-}
-
 /*
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
  * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
@@ -9833,10 +9837,14 @@ static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-	atomic_dec(&tctx->in_idle);
 
 	io_uring_clean_tctx(tctx);
 	if (cancel_all) {
+		/*
+		 * We shouldn't run task_works after cancel, so just leave
+		 * ->in_idle set for normal exit.
+		 */
+		atomic_dec(&tctx->in_idle);
 		/* for exec all current's requests should be gone, kill tctx */
 		__io_uring_free(current);
 	}
-- 
2.34.1

