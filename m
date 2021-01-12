Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256042F3148
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389915AbhALM5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389898AbhALM5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9DA423159;
        Tue, 12 Jan 2021 12:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456176;
        bh=t6hn3iAj4nyPAmmxioRCRwnx4oBRPR1LwZj0TXtK6vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPeUQRoH82DFKN8APwrEYsbqKtPCRwffanXdLlVpdVypxWPCXTYdHHg9h0OcwjKft
         mEWfukFLDdUpMKzojbCFUHyKgmaGMuEsB298njx5iZlBG6i0Uliwza0EVMTI+8T4qB
         zAr5lazKKfH4R5AYo/vEfckK5SfM/e0OffUKe6kUyKyzDcNDiD7IRhgf2iON+DO4Fd
         PulA/DsJ4dkCYLBygb6n4R/cXj703v070EtNWUQ4VipytPzutX2ttPNDJDQyHeMDEY
         eUGtlb3NX+YS3QmKrBeeBdXm6cfnEf3wj6z7lBq9hBMc9gvcBNjLK5xiOm+LHQ3cfT
         eKe2Tu++QUM5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 32/51] io_uring: drop file refs after task cancel
Date:   Tue, 12 Jan 2021 07:55:14 -0500
Message-Id: <20210112125534.70280-32-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit de7f1d9e99d8b99e4e494ad8fcd91f0c4c5c9357 ]

io_uring fds marked O_CLOEXEC and we explicitly cancel all requests
before going through exec, so we don't want to leave task's file
references to not our anymore io_uring instances.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f798c5c4213e..aebdbc842a637 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8807,6 +8807,15 @@ static void io_uring_attempt_task_drop(struct file *file)
 		io_uring_del_task_file(file);
 }
 
+static void io_uring_remove_task_files(struct io_uring_task *tctx)
+{
+	struct file *file;
+	unsigned long index;
+
+	xa_for_each(&tctx->xa, index, file)
+		io_uring_del_task_file(file);
+}
+
 void __io_uring_files_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -8815,16 +8824,12 @@ void __io_uring_files_cancel(struct files_struct *files)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-
-	xa_for_each(&tctx->xa, index, file) {
-		struct io_ring_ctx *ctx = file->private_data;
-
-		io_uring_cancel_task_requests(ctx, files);
-		if (files)
-			io_uring_del_task_file(file);
-	}
-
+	xa_for_each(&tctx->xa, index, file)
+		io_uring_cancel_task_requests(file->private_data, files);
 	atomic_dec(&tctx->in_idle);
+
+	if (files)
+		io_uring_remove_task_files(tctx);
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx)
@@ -8887,6 +8892,8 @@ void __io_uring_task_cancel(void)
 
 	finish_wait(&tctx->wait, &wait);
 	atomic_dec(&tctx->in_idle);
+
+	io_uring_remove_task_files(tctx);
 }
 
 static int io_uring_flush(struct file *file, void *data)
-- 
2.27.0

