Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB262D07A9
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 23:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgLFW1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 17:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbgLFW05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 17:26:57 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9954AC0613D3;
        Sun,  6 Dec 2020 14:26:16 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id r3so10943531wrt.2;
        Sun, 06 Dec 2020 14:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R1puTOoeitudJFFNKlVi61XHZNTGXHFCWqgDCd/4paY=;
        b=XwuW2sClPIiwbB8nEwoPcK5n76AS/nJhmQfhHETGyk84PoIAHAvcSF5Vv1lcqRz/EX
         3v8la0XTwOZJHyRF0C7p4fPZf5zDAI4OTvYuwOfVS6fXyROcbI1daNU1VojDdk/l+YkH
         kgPmiybYb1suR5TYQ85GkJIW+3135oaAi5CwIHE9Uea31VXiWtt84bqZHg/edljScCvC
         1UgYyEyNDzSxDgktFRokpB+Z0s3zOy9Wozy/qRUM2bXcBy9wF6brFD6RMQEHlsz1CgVj
         65+YzYJJfXeGCn/uENek8IWWQCOFMyz1l6ZtSF4Niw+ijksoreQH/gWVTyhYJtwC0ob0
         G1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R1puTOoeitudJFFNKlVi61XHZNTGXHFCWqgDCd/4paY=;
        b=pltAjHFkyMKEKVsa35xMLKiI0PnSCvNl4KJ4uNfu8SdhGpKS50GhkrruWA2ujIjiqX
         IHdAd2eDm+bek/ZMHn0qWfxwyb8PWn111v6ibaY6pYLYdZ9KRoD0DrtWYEucVi6cxHrW
         DcHeeJZT1hf7VAjkblXPN5RWCcmNW2Mcdhv5tFxZv0/ORXOPEquRsEKCmBVHiUpYe45P
         1z7KuUwk3GwjL7yr9ZGcs3KXsVlMvifUEpG2FRlJwFmVG+SVxPNlppSMDDauAKuOTENK
         gVKk1MDaHPobDxiPzkymtuHfQbMnTeghoPrXD6s46eMsvxRnecI7TnAgz1ZxRW3tHTtE
         QHpw==
X-Gm-Message-State: AOAM533HkFi2wyeTZjDFyW5Q81tNj8sUzbIICwLs7MOV/mnycq9DAfWY
        aUmbGX7x7gJ/YF2qttxWwSs=
X-Google-Smtp-Source: ABdhPJyzi59Eoo/wBBzVt79pgjkgGds44qyzBsu9woxRNZw/L/iphnE12UOIxaoeYjKCnH3EhWKH1w==
X-Received: by 2002:adf:b647:: with SMTP id i7mr16544414wre.241.1607293575369;
        Sun, 06 Dec 2020 14:26:15 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.92])
        by smtp.gmail.com with ESMTPSA id h20sm11284917wmb.29.2020.12.06.14.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 14:26:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 5.10 3/5] io_uring: fix racy IOPOLL flush overflow
Date:   Sun,  6 Dec 2020 22:22:44 +0000
Message-Id: <54043d0489ded8e883a9800a82cf66fc9c0cded5.1607293068.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607293068.git.asml.silence@gmail.com>
References: <cover.1607293068.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's not safe to call io_cqring_overflow_flush() for IOPOLL mode without
hodling uring_lock, because it does synchronisation differently. Make
sure we have it.

As for io_ring_exit_work(), we don't even need it there because
io_ring_ctx_wait_and_kill() already set force flag making all overflowed
requests to be dropped.

Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4fac02ea5f4c..b1ba9a738315 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8393,8 +8393,6 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		if (ctx->rings)
-			io_cqring_overflow_flush(ctx, true, NULL, NULL);
 		io_iopoll_try_reap_events(ctx);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
@@ -8404,6 +8402,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
+	if (ctx->rings)
+		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL);
@@ -8413,8 +8413,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_wq_cancel_all(ctx->io_wq);
 
 	/* if we failed setting up the ctx, we might not have any rings */
-	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	io_iopoll_try_reap_events(ctx);
 	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
 
@@ -8691,7 +8689,9 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	else
 		io_cancel_defer_files(ctx, task, NULL);
 
+	io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 	io_cqring_overflow_flush(ctx, true, task, files);
+	io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 
 	while (__io_uring_cancel_task_requests(ctx, task, files)) {
 		io_run_task_work();
@@ -8993,8 +8993,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 		if (!list_empty_careful(&ctx->cq_overflow_list))
 			io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)
-- 
2.24.0

