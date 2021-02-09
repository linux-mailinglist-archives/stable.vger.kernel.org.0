Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FC43147AE
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhBIEwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhBIEwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:52:30 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9799C06178A
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:47 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jj19so29289158ejc.4
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bXVNAFD9KMUBw3QyyxxDCpWwy1P8wBM7maopwypxrwg=;
        b=UDZFm8JQEK+RwftDBrUi9p1QP/0P6n7XGiupw9wS75/kWUBWENOHE/4T6iYfUisR0r
         sDvTZSBi2iSRyKXcMLswdF9yUrU/SVtFVw+FSx/PkbNpmblfI6QdFTwwpZ4MbxUzD9kF
         5VhH3EaA4IUZ0sty35m8+a+7sFnwH+ZxPlO4kiqjBpy+nCxq7515ojGrbyd22lJfhZxO
         qCmcXttULeKkGCIyuJRtf372GK3QWDgPRbBIn39hZTiiEJpSCaopO9NUBeIl8PLnM0y6
         d72cmfEGWvhXhZBPhsfImkod6LAlrfcZBthlOtcaKNeO/bATpmoPFjcN8XFDUPr+iH7M
         Ku7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bXVNAFD9KMUBw3QyyxxDCpWwy1P8wBM7maopwypxrwg=;
        b=osCyEfyXIX5JKSBnJktsgV7HniXauH6GbFg4ctiohn+f0ovK/jLFd1x7jHxd7v9n1O
         Gkpzi7YoEEufgTX1nvITVEdHmhxwqrIoRPQE+NZBrBPR0TyMdHpYxfm8R+HyHMv9papj
         gg5EoRBIGWFO2DxxguQCghvUBHP/bxjgD9DOmHf7RMJS/DemnRXhzSut4h3b7z4txdZc
         ipWnPyEJx8NvKLheWQW6p+vE6SjtKh4jh+VMphrDZ0Z2BHcAKbHTlPqZeGLEV7gqSxjU
         SlrLxAmGGlyNoCG/AIDPD//D0EvcC/kUB4A6r19zlD6qNtoO4l37lnEdqTMkuvJVmy66
         Idhg==
X-Gm-Message-State: AOAM531p15HWYy83XuUkXk5kSWrYB3Hq55d2Lz7xeDPLXiOU6s150gSV
        ojUCYQ1qLjyb85WHJIVDaKfzZoBGopg=
X-Google-Smtp-Source: ABdhPJz94u01Aqj/i22VI03RyZLULACp6ZUjoKy2H79fc4lY2/014pubd1+G5K+6VxvLPMc/gl2hCw==
X-Received: by 2002:a17:907:78d5:: with SMTP id kv21mr20613382ejc.461.1612846306194;
        Mon, 08 Feb 2021 20:51:46 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/16] io_uring: add a {task,files} pair matching helper
Date:   Tue,  9 Feb 2021 04:47:36 +0000
Message-Id: <4c35bcd30733f049b1b01ff3e87b5d348b75054c.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 08d23634643c239ddae706758f54d3a8e0c24962 ]

Add io_match_task() that matches both task and files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 63 ++++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 510a860f8bdf..71bdd288c396 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -997,6 +997,36 @@ static inline void io_clean_op(struct io_kiocb *req)
 		__io_clean_op(req);
 }
 
+static inline bool __io_match_files(struct io_kiocb *req,
+				    struct files_struct *files)
+{
+	return ((req->flags & REQ_F_WORK_INITIALIZED) &&
+	        (req->work.flags & IO_WQ_WORK_FILES)) &&
+		req->work.identity->files == files;
+}
+
+static bool io_match_task(struct io_kiocb *head,
+			  struct task_struct *task,
+			  struct files_struct *files)
+{
+	struct io_kiocb *link;
+
+	if (task && head->task != task)
+		return false;
+	if (!files)
+		return true;
+	if (__io_match_files(head, files))
+		return true;
+	if (head->flags & REQ_F_LINK_HEAD) {
+		list_for_each_entry(link, &head->link_list, link_list) {
+			if (__io_match_files(link, files))
+				return true;
+		}
+	}
+	return false;
+}
+
+
 static void io_sq_thread_drop_mm(void)
 {
 	struct mm_struct *mm = current->mm;
@@ -1612,32 +1642,6 @@ static void io_cqring_mark_overflow(struct io_ring_ctx *ctx)
 	}
 }
 
-static inline bool __io_match_files(struct io_kiocb *req,
-				    struct files_struct *files)
-{
-	return ((req->flags & REQ_F_WORK_INITIALIZED) &&
-	        (req->work.flags & IO_WQ_WORK_FILES)) &&
-		req->work.identity->files == files;
-}
-
-static bool io_match_files(struct io_kiocb *req,
-			   struct files_struct *files)
-{
-	struct io_kiocb *link;
-
-	if (!files)
-		return true;
-	if (__io_match_files(req, files))
-		return true;
-	if (req->flags & REQ_F_LINK_HEAD) {
-		list_for_each_entry(link, &req->link_list, link_list) {
-			if (__io_match_files(link, files))
-				return true;
-		}
-	}
-	return false;
-}
-
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 				       struct task_struct *tsk,
@@ -1659,9 +1663,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 
 	cqe = NULL;
 	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
-		if (tsk && req->task != tsk)
-			continue;
-		if (!io_match_files(req, files))
+		if (!io_match_task(req, tsk, files))
 			continue;
 
 		cqe = io_get_cqring(ctx);
@@ -8635,8 +8637,7 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_task_match(de->req, task) &&
-		    io_match_files(de->req, files)) {
+		if (io_match_task(de->req, task, files)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
-- 
2.24.0

