Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452FD318E10
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhBKPUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:20:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230002AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D99E864EE7;
        Thu, 11 Feb 2021 15:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055857;
        bh=AWEhQnvD4wbd7vUfesoDm4gdZDGusryI5Q9W95K/Owo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6FdbuhDPVL3gwKhnvM+D1EUoPRhxqyrixlcyWoxUK2tzBSjGNxOOkBKsrUD+6nX+
         rQ0shrmn7HsTslrum6buT1WHuyF2CtoAvO4ajZ/s5n1Oj/1rTb3wfLHofGO/7wqJvo
         idfYgz0EfRpgREukbQuh5VrX58j+nbNRiuVWZjhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 07/54] io_uring: account io_uring internal files as REQ_F_INFLIGHT
Date:   Thu, 11 Feb 2021 16:01:51 +0100
Message-Id: <20210211150153.199303516@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 02a13674fa0e8dd326de8b9f4514b41b03d99003 ]

We need to actively cancel anything that introduces a potential circular
loop, where io_uring holds a reference to itself. If the file in question
is an io_uring file, then add the request to the inflight list.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1000,6 +1000,9 @@ static inline void io_clean_op(struct io
 static inline bool __io_match_files(struct io_kiocb *req,
 				    struct files_struct *files)
 {
+	if (req->file && req->file->f_op == &io_uring_fops)
+		return true;
+
 	return ((req->flags & REQ_F_WORK_INITIALIZED) &&
 	        (req->work.flags & IO_WQ_WORK_FILES)) &&
 		req->work.identity->files == files;
@@ -1398,11 +1401,14 @@ static bool io_grab_identity(struct io_k
 			return false;
 		atomic_inc(&id->files->count);
 		get_nsproxy(id->nsproxy);
-		req->flags |= REQ_F_INFLIGHT;
 
-		spin_lock_irq(&ctx->inflight_lock);
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		spin_unlock_irq(&ctx->inflight_lock);
+		if (!(req->flags & REQ_F_INFLIGHT)) {
+			req->flags |= REQ_F_INFLIGHT;
+
+			spin_lock_irq(&ctx->inflight_lock);
+			list_add(&req->inflight_entry, &ctx->inflight_list);
+			spin_unlock_irq(&ctx->inflight_lock);
+		}
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
 	if (!(req->work.flags & IO_WQ_WORK_MM) &&
@@ -5886,8 +5892,10 @@ static void io_req_drop_files(struct io_
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
-	put_files_struct(req->work.identity->files);
-	put_nsproxy(req->work.identity->nsproxy);
+	if (req->work.flags & IO_WQ_WORK_FILES) {
+		put_files_struct(req->work.identity->files);
+		put_nsproxy(req->work.identity->nsproxy);
+	}
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
 	list_del(&req->inflight_entry);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
@@ -6159,6 +6167,15 @@ static struct file *io_file_get(struct i
 		file = __io_file_get(state, fd);
 	}
 
+	if (file && file->f_op == &io_uring_fops) {
+		io_req_init_async(req);
+		req->flags |= REQ_F_INFLIGHT;
+
+		spin_lock_irq(&ctx->inflight_lock);
+		list_add(&req->inflight_entry, &ctx->inflight_list);
+		spin_unlock_irq(&ctx->inflight_lock);
+	}
+
 	return file;
 }
 
@@ -8578,8 +8595,7 @@ static void io_uring_cancel_files(struct
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->task != task ||
-			    req->work.identity->files != files)
+			if (!io_match_task(req, task, files))
 				continue;
 			found = true;
 			break;


