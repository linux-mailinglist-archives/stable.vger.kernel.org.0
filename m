Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD82DF902
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 06:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgLUF5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 00:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgLUF5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 00:57:15 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88545C0613D3;
        Sun, 20 Dec 2020 21:56:34 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g185so9768254wmf.3;
        Sun, 20 Dec 2020 21:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bAr93S7XxzBhRyTRLedeIC+1dK6qMEq1sl4Ck9Ycn1A=;
        b=hyzkl7LXfRZEIGQUwGQuH0hYBMD9FpeI88IreSQQnmA2nLd3mzjflNiB2uppU4UrPi
         /rq3GCupXKbtPjTHRkN0DRoy2GAm49HUvSlIDZURVJnTFjy1gJB9V5ggsUJXAS1q8uHC
         W6YLGBBcNsUjcEIzkWCsMbv/qyPA8MAOjAlJYVIK+llvCQDyPsdVNeFJ1VVU2oy8O24n
         2tBuZ9Cv9vtnEzqb4IIEuNDfcNyccTCyr7Ycst1TwpHneD/p6dTVaDY4604S9X8eQ07t
         Uy4Plk5yq55vBfjowCk0E19Tj9rk5ZVnx0LdPbAc3uAyP0rtnTqTLbdK2pUQvgnr69SW
         RivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bAr93S7XxzBhRyTRLedeIC+1dK6qMEq1sl4Ck9Ycn1A=;
        b=iuaHIaQWex+dK92hOLB8stw7HmHkxSfnV4GkzeLViMO9ROYm/3vCv0kckpsrK38uiz
         aND3yNDXU4JcMGZQUSdpoMk5I/lFoJ+dMy2Bk1v1YU2ojYXdtkvcoFw2ihmmHHkMjfqP
         dAOCZyklmzjPCfDa4//BTgaRdhNxVwWXz+t/WregWtvisQhxadBykTwvRW5XnDHPKKV3
         GPxCgLFvItyTbulRIdYVSsS/ZTBry7inXht3G5QlPrucbtURiuJROUvkXaQshfFFe0Dw
         5gtvcZ1Jek2ijjJkwXy27hQ8A36q/L2vrmx3sDzd9iYuErvcQxF3YoMm0YvJsofYWwJK
         PmKA==
X-Gm-Message-State: AOAM5303hvHQj3NZJMGdJj3cWi9vNVnWnJXR+vFQENxQIkwtQDjtYdUe
        fAlIQww1Yp9N34AWOE4mGnxJvpxl/JF6Xg==
X-Google-Smtp-Source: ABdhPJxqIw8Bz+R+tvjwAXw1klZC9IKrduF0JNuK6wr28d81Xm7gCUSykybSx+BxY1NF3tSIpO3I0Q==
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr13539506wmi.45.1608491814848;
        Sun, 20 Dec 2020 11:16:54 -0800 (PST)
Received: from localhost.localdomain ([85.255.237.164])
        by smtp.gmail.com with ESMTPSA id n14sm20577295wmi.1.2020.12.20.11.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 11:16:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, Josef <josef.grieb@gmail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH 1/1] io_uring: actively cancel poll/timeouts on exit
Date:   Sun, 20 Dec 2020 19:13:12 +0000
Message-Id: <ea52c20eba8ab65ce1e716fe8627a1938a354268.1608491503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If io_ring_ctx_wait_and_kill() haven't killed all requests on the first
attempt, new timeouts or requests enqueued for polling may appear. They
won't be ever cancelled by io_ring_exit_work() unless we specifically
handle that case. That hangs of the exit work locking up grabbed by
io_uring resources.

Cc: <stable@vger.kernel.org> # 5.5+
Cc: Josef <josef.grieb@gmail.com>
Reported-by: Dmitry Kadashev <dkadashev@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 55 +++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fbf747803dbc..c1acc668fe96 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8620,6 +8620,32 @@ static int io_remove_personalities(int id, void *p, void *data)
 	return 0;
 }
 
+static void io_cancel_defer_files(struct io_ring_ctx *ctx,
+				  struct task_struct *task,
+				  struct files_struct *files)
+{
+	struct io_defer_entry *de = NULL;
+	LIST_HEAD(list);
+
+	spin_lock_irq(&ctx->completion_lock);
+	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
+		if (io_match_task(de->req, task, files)) {
+			list_cut_position(&list, &ctx->defer_list, &de->list);
+			break;
+		}
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+
+	while (!list_empty(&list)) {
+		de = list_first_entry(&list, struct io_defer_entry, list);
+		list_del_init(&de->list);
+		req_set_fail_links(de->req);
+		io_put_req(de->req);
+		io_req_complete(de->req, -ECANCELED);
+		kfree(de);
+	}
+}
+
 static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
@@ -8633,6 +8659,8 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		io_iopoll_try_reap_events(ctx);
+		io_poll_remove_all(ctx, NULL, NULL);
+		io_kill_timeouts(ctx, NULL, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
@@ -8654,6 +8682,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
+	io_cancel_defer_files(ctx, NULL, NULL);
 	io_kill_timeouts(ctx, NULL, NULL);
 	io_poll_remove_all(ctx, NULL, NULL);
 
@@ -8716,32 +8745,6 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	return ret;
 }
 
-static void io_cancel_defer_files(struct io_ring_ctx *ctx,
-				  struct task_struct *task,
-				  struct files_struct *files)
-{
-	struct io_defer_entry *de = NULL;
-	LIST_HEAD(list);
-
-	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_task(de->req, task, files)) {
-			list_cut_position(&list, &ctx->defer_list, &de->list);
-			break;
-		}
-	}
-	spin_unlock_irq(&ctx->completion_lock);
-
-	while (!list_empty(&list)) {
-		de = list_first_entry(&list, struct io_defer_entry, list);
-		list_del_init(&de->list);
-		req_set_fail_links(de->req);
-		io_put_req(de->req);
-		io_req_complete(de->req, -ECANCELED);
-		kfree(de);
-	}
-}
-
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
-- 
2.24.0

