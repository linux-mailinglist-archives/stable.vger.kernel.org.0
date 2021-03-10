Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23186333B8A
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhCJLf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbhCJLfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:35:15 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1B9C061764
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:56 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id w11so22932297wrr.10
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pJP+2SES5veTHN1w2o+EooIOS5gGA8fO2YFXyg3pw3k=;
        b=bJJXB6Vym4PhGlvMEU0Tjth09CDe/RIr/A0zbOvzEvdo3pR5H/4xsCbT+l+5scb1Fu
         HXn8Lf7jdhwycWH2zRq2m9ghenosD6K3bnYazuCQLp3ZqVoWuuNTtiQWLOp8o3jdxvV1
         jovwJRsJdfCKDEPGuKLlhQly35eTqh7v0Vmg8JQ7vyshCHVIyzla9YizFSwD/HGr4/f/
         vCkEAKB1fHUYD5Bw623OQELT/VTYRFvXcUIcFMeTpuly5CrOWt1FXMbNBro+y08IOrMh
         iuajUvQ65Lwr1nEoGZ2wA69OafNEBwmY66yszDrRhIe6i4CKgRj7sXTQYRNge3wgGG+d
         XS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pJP+2SES5veTHN1w2o+EooIOS5gGA8fO2YFXyg3pw3k=;
        b=KwSnfgpy7SIk4AZ638D4ZrHC9rRvII6q/9xiaLw5V9RICWM334wRqDDTycHNzvh+0Y
         DPBxrtxE7oZQFiqJF198+fNcgB/pmBP6OdPtjXfyYt8t1BYi0Q2MC3MjpkXXOn+bTgWs
         nT9oTtfiagCPzpKcGC3dEAWUXWEPnrrauL5pzw45+fBa9SanrxzE4o6Ca3HdNPGHcZLD
         A1k5oTh26TWLOAIf1zFz7xippqGvkhRaGLpys24hBXzxLrkdYo1aC0W31p8Q7Pg0/S/o
         s0S10LM5o5bNg3lY7eY6Qru3FCwyWbUZPr7v6F5S3N0nwdQhkyRUWsfY7wvcFK+1RKqV
         TUZw==
X-Gm-Message-State: AOAM5316WP18a4o1WwZEk3lTQJTUnsTuEuhPQueD8vvdnw3WFn8xib+J
        EPvxH+7yK7bmZ9ijrqCZVbD030ADKa0lpw==
X-Google-Smtp-Source: ABdhPJxYjuE8Fe7YtbTYNGICQhvp76DOZ/+erhK6IPt7moLD9MuojIaEjBaeKtjUnUsxPoliiCNPkw==
X-Received: by 2002:adf:90c2:: with SMTP id i60mr3031463wri.75.1615376094477;
        Wed, 10 Mar 2021 03:34:54 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id s18sm25179078wrr.27.2021.03.10.03.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 03:34:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/9] io_uring: deduplicate failing task_work_add
Date:   Wed, 10 Mar 2021 11:30:40 +0000
Message-Id: <5ad81cd57c41877a4667ea8dd5397987af6cce41.1615375332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit eab30c4d20dc761d463445e5130421863ff81505 upstream

When io_req_task_work_add() fails, the request will be cancelled by
enqueueing via task_works of io-wq. Extract a function for that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 842a7c017296..bc76929e0031 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2172,6 +2172,16 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	return ret;
 }
 
+static void io_req_task_work_add_fallback(struct io_kiocb *req,
+					  void (*cb)(struct callback_head *))
+{
+	struct task_struct *tsk = io_wq_get_task(req->ctx->io_wq);
+
+	init_task_work(&req->task_work, cb);
+	task_work_add(tsk, &req->task_work, TWA_NONE);
+	wake_up_process(tsk);
+}
+
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2229,14 +2239,8 @@ static void io_req_task_queue(struct io_kiocb *req)
 	percpu_ref_get(&req->ctx->refs);
 
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		init_task_work(&req->task_work, io_req_task_cancel);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
-	}
+	if (unlikely(ret))
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
 }
 
 static inline void io_queue_next(struct io_kiocb *req)
@@ -2354,13 +2358,8 @@ static void io_free_req_deferred(struct io_kiocb *req)
 
 	init_task_work(&req->task_work, io_put_req_deferred_cb);
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
-	}
+	if (unlikely(ret))
+		io_req_task_work_add_fallback(req, io_put_req_deferred_cb);
 }
 
 static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
@@ -3439,15 +3438,8 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
 	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		/* queue just for cancelation */
-		init_task_work(&req->task_work, io_req_task_cancel);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
-	}
+	if (unlikely(ret))
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
 	return 1;
 }
 
@@ -5159,12 +5151,8 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 */
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
 		WRITE_ONCE(poll->canceled, true);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, TWA_NONE);
-		wake_up_process(tsk);
+		io_req_task_work_add_fallback(req, func);
 	}
 	return 1;
 }
-- 
2.24.0

