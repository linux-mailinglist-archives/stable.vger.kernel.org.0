Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0210E3147B3
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 05:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBIExQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 23:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhBIExK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 23:53:10 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A65C061794
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 20:51:51 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s26so16132284edt.10
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 20:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6vk8XXvYh9OABFZeI+2WE9M1Hx4UR0ZhAg5PM96i33k=;
        b=hocl0CcnN8Qdiw/jVlb1QDjA9ywm4dNgfARqGO3naVGUJQO8ALHsARrXkBzO5csPOL
         083sn+wuDMSvKJxjQr4ScmT1mkNW4F0doPQqsC54ps2MoS3WFdjuvffzSosS2B61FbBt
         Q5QeOgfGMMg1EMsgDBRm4yIbmWg84ruQj/leNhQhCiLwObzYge04OyDEa0w1ndOTdVmy
         32VigFJsnMsg5jPx7HBXs4cD7qLT6vm1bHWRDShQ+8WCBx5VXmOzKyeO2rzUvdtkjNvS
         aPtgoNunGWMOwvmCaJAb/SQsFs4xIpsvyuAZgMfhyhd9eEWwD0YVkIFxVCg+UKM3k1jq
         9NWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6vk8XXvYh9OABFZeI+2WE9M1Hx4UR0ZhAg5PM96i33k=;
        b=jrBufvg9fKKTnRMUkTJBHAwqpWMRlWKl+2CfecA3e8t4fi0TIGO3Hoh3LE8WYwgJIW
         fXDccJ2cQQSBCEMjMACl7pyCVQYj3QCiHTXo+9jQeBfeuC4UQWkk8ZixZxT/LNTZG4ah
         SAkyufIcHXONEmmAm1SPnEJlxs8P82D8vP25a4WMhzEC5l80t8akuB+5mb/bpeL1jFN8
         bKh3Mavwxb9sO15ymHIsa7wTDeFXen3m8NjvZt1f4Pj391yU0Av18uwLSfIBXgMdQkJI
         5EmXtdBvfoytsGNOaDTIYQsZzGA7Ubho77MMCypMLREaU5EiRmr2/7A0CLe+fhpb0Bwl
         jUwQ==
X-Gm-Message-State: AOAM5319pkgnb6oouOrKckWtyckksMECX5B801yAhqJ8slcqyRNwpSu4
        7TBwpTmMlwN45XI8MrpNtjRKgC0VueU=
X-Google-Smtp-Source: ABdhPJzNi2bBroxNqVcZswMd5oLjaPwq501EDzucsLYHE5kPmULcSItRUiFX8sNEBfrq+7997OyMFw==
X-Received: by 2002:a50:c94b:: with SMTP id p11mr20770798edh.388.1612846310271;
        Mon, 08 Feb 2021 20:51:50 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id g9sm9973445ejp.55.2021.02.08.20.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 20:51:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
Subject: [PATCH 06/16] io_uring: fix files cancellation
Date:   Tue,  9 Feb 2021 04:47:40 +0000
Message-Id: <a868bfa580350805d5562eb215a5e0b903175d17.1612845821.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bee749b187ac57d1faf00b2ab356ff322230fce8 ]

io_uring_cancel_files()'s task check condition mistakenly got flipped.

1. There can't be a request in the inflight list without
IO_WQ_WORK_FILES, kill this check to keep the whole condition simpler.
2. Also, don't call the function for files==NULL to not do such a check,
all that staff is already handled well by its counter part,
__io_uring_cancel_task_requests().

With that just flip the task check.

Also, it iowq-cancels all request of current task there, don't forget to
set right ->files into struct io_task_cancel.

Fixes: c1973b38bf639 ("io_uring: cancel only requests of current task")
Reported-by: syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44b859456ef6..a40ee81e6438 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8571,15 +8571,14 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
+		struct io_task_cancel cancel = { .task = task, .files = files };
 		struct io_kiocb *req;
 		DEFINE_WAIT(wait);
 		bool found = false;
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->task == task &&
-			    (req->work.flags & IO_WQ_WORK_FILES) &&
+			if (req->task != task ||
 			    req->work.identity->files != files)
 				continue;
 			found = true;
@@ -8665,10 +8664,11 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
-	io_uring_cancel_files(ctx, task, files);
 
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
+	else
+		io_uring_cancel_files(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.24.0

