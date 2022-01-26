Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C0449D1E7
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiAZSlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiAZSlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 13:41:04 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A02C06161C;
        Wed, 26 Jan 2022 10:41:04 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jx6so651714ejb.0;
        Wed, 26 Jan 2022 10:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eTBZW5zsYuJD2A4yD4/Czs3pes/Ju/EwqHkjm2EiVQk=;
        b=ALasHIlLcer5vn2BZtOPd1MC94zWtOzT2dHbaww4iu7YUSVfOlBR2T1HBZBY3/rkfD
         1EUQJpFlX59ET6isyF3yWla3+f6u9nO3eQIqqqfMXifbRSU49dvRtJCOE7mSy86e6ahf
         EqQSj58e7YrlZv8bHEeBBavW/rJmpdw/dBdQALxiPFcP2+JupRqkKLL75soxQ+0114yI
         vJKAr9gEGZ3UKtNoHp3nyAuha3mpIanfmjSXTJXi9V6KK7TVAsciVnCW2Nb7+CnpX9vu
         +64/+mXJ1FEhbxP9scNU2G5yFYJSbZJcE2j5AG8ONvA0XC8k5X9HGj1lUIHKr4/tLh6v
         OSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eTBZW5zsYuJD2A4yD4/Czs3pes/Ju/EwqHkjm2EiVQk=;
        b=NocdDteiEdzAxgGTmhnQGpMBDOvtCtn9pEsdYh2AApmTnR2fgQgNU58TdJAbt+lXHV
         gDxjkSjvCR4KAVB10m8j4ZcsC4rjvrEmOub/UICrungKFeXkEOjdTnHeTeo8tkXGAA3Z
         KCDqkVkviu5D+34GxREaZBKu4ThhPOB6aEUbqjs/N8F0ts/GnszFLRWWrNDOP0fL8x7r
         Fb5P16slOy/kdOMlHSvOAk7eyYk8Bl6nRugpB0kibYp1XRl2vTm8ywCkBW9KKG16L/Nx
         HmV3jqge9fHF2jPJK9qb8so7SofeejXUNHRMms9nbuUM4ikuvO3MG5wIKoy8bEvICNTm
         JIzg==
X-Gm-Message-State: AOAM532VqZXnm09Fe2qf0bk1jkV9o7/bF5jJg1dvbJMufUm69HrmvHZU
        gN+9dJ/zEnX+ZurUjGZEVketItBcNbg=
X-Google-Smtp-Source: ABdhPJyEkTozEsq5NrppS0LRP7o5TKLo/Pnu4wo7bANSePqXkQ5NFd1tyVKolRvhHptig5VGmHroJw==
X-Received: by 2002:a17:907:9620:: with SMTP id gb32mr70346ejc.436.1643222462436;
        Wed, 26 Jan 2022 10:41:02 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id lc22sm7783031ejc.74.2022.01.26.10.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 10:41:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH stable-5.16] io_uring: fix not released cached task refs
Date:   Wed, 26 Jan 2022 18:41:00 +0000
Message-Id: <562c76e037f77a17401327b9c953cd53744a5c7d.1643221940.git.asml.silence@gmail.com>
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
index fb2a0cb4aaf8..9cab29b6f579 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1830,6 +1830,18 @@ static inline void io_get_task_refs(int nr)
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
 				     s32 res, u32 cflags)
 {
@@ -2250,6 +2262,10 @@ static void tctx_task_work(struct callback_head *cb)
 	}
 
 	ctx_flush_and_put(ctx, &locked);
+
+	/* relaxed read is enough as only the task itself sets ->in_idle */
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		io_uring_drop_tctx_refs(current);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req)
@@ -9814,18 +9830,6 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
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
@@ -9883,10 +9887,14 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
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

