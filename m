Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5953318E34
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhBKPW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhBKPKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:10:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6047A64EC7;
        Thu, 11 Feb 2021 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055820;
        bh=yszjSzXdxmaj7BeEVp5rgPBW+T0Qmzy+mNIOCv68f/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5t4HZAeA5G0c0tHr3F+w2MrOhXzrdCk8cQnuiSqf+xjEo1Fzio4F1skeJeJVj9Rs
         EwGIk42Zragr3t+HTjUYQXKzYqgTNGU8E9HgTpH10Wc8dkJ591bNgyeG96i22o5esS
         85xHsXRihViG7nOfyvnZ/GIz9OxWeGHkANFALzts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 02/54] io_uring: add a {task,files} pair matching helper
Date:   Thu, 11 Feb 2021 16:01:46 +0100
Message-Id: <20210211150152.999277924@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 08d23634643c239ddae706758f54d3a8e0c24962 ]

Add io_match_task() that matches both task and files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   63 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -997,6 +997,36 @@ static inline void io_clean_op(struct io
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
@@ -1612,32 +1642,6 @@ static void io_cqring_mark_overflow(stru
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
@@ -1659,9 +1663,7 @@ static bool __io_cqring_overflow_flush(s
 
 	cqe = NULL;
 	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
-		if (tsk && req->task != tsk)
-			continue;
-		if (!io_match_files(req, files))
+		if (!io_match_task(req, tsk, files))
 			continue;
 
 		cqe = io_get_cqring(ctx);
@@ -8635,8 +8637,7 @@ static void io_cancel_defer_files(struct
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_task_match(de->req, task) &&
-		    io_match_files(de->req, files)) {
+		if (io_match_task(de->req, task, files)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}


