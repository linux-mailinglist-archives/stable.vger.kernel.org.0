Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D56303B82
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 12:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392247AbhAZLXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 06:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392345AbhAZLW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 06:22:58 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DF8C061794
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:10 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a10so22415175ejg.10
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 03:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H8jaeSNFaDfrMbH20xY2YYq+yl/M/sDJfXI3SIGJV/o=;
        b=ZbfN9DWroEUtEy3ihgHVbEqXlOTQBU4J48JMU+nDkBEUJQbIkmULtnVO5dE8xOo0jd
         qCTFPSWpwVVz96P6yvVnaNg5A+u0Wv2ruBZGQA/69n77h4lU6EQzXYRwkmRU8fa174zV
         T/QhPdp6x1ip0pwlxiGCFBcM+c72mtICJBiofvPL5VZ8PIXsv1BJ6ZMOtNCAT3joseTL
         6nTRZgQSRRUHaF8n+lx2/xuLp7SvHTnzabgNKV8twjC6GVl1cWzRn2rUoUTacp4DSXQT
         YWoDdnWQ6iKFxMuotsw28hqEVU639oJg4EbGt9zuFgsT+O4UXy9yCKaKuptrELBsVwf/
         T79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H8jaeSNFaDfrMbH20xY2YYq+yl/M/sDJfXI3SIGJV/o=;
        b=eEL0s0nyE3TSt5FUaYCvsEuXak8eE+bhgAI86YdcVeEkleiVgGjp9m1O5VUBKS6dIM
         CoqwYzky2Xzvq3UufVedlzQk1DrzIs29JcoYGMGZ9sb9D0i0fK7iWd0Uyccqp6e49+j+
         SijmWhixH9BDJeTt/Y0Y6Hd4awCXP9sMDTxjw5TYrb8k7HF7iftyd7vrYb4Y4ZhPFe04
         0JySE/uwmBj5T12BmcUdVto9hfXp4ousFIkkoSU7jtNLSTq7blW2rZLw+MTOBGbjLg5m
         X8ywTKf6I8zeeEnyejXGH6pU2FX7WcwbDGVSYFyV8wXcqACDWwqqsGKW2MTANbkrvnXr
         cenw==
X-Gm-Message-State: AOAM530mEll4ycmBeSivxL/ZaEQyt0iXXuWMGp6IYVV72R3o2os44rld
        EskKhM+VvjOx2KxkqpGdM03Is9jUTAuXHA==
X-Google-Smtp-Source: ABdhPJziU1O5y5pkltAF7hnarhkEP3bGfusLW4eecujstGW+0LZsUPYjL4J7sHCd2bY7AhiMzBH/Eg==
X-Received: by 2002:a17:906:25db:: with SMTP id n27mr3182414ejb.552.1611660068557;
        Tue, 26 Jan 2021 03:21:08 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o17sm12167128edr.17.2021.01.26.03.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:21:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Abaci <abaci@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH stable 11/11] io_uring: fix sleeping under spin in __io_clean_op
Date:   Tue, 26 Jan 2021 11:17:10 +0000
Message-Id: <61e93a6403ea6cc28764e7508cd877ca30345371.1611659564.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611659564.git.asml.silence@gmail.com>
References: <cover.1611659564.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9d5c8190683a462dbc787658467a0da17011ea5f ]

[   27.629441] BUG: sleeping function called from invalid context
	at fs/file.c:402
[   27.631317] in_atomic(): 1, irqs_disabled(): 1, non_block: 0,
	pid: 1012, name: io_wqe_worker-0
[   27.633220] 1 lock held by io_wqe_worker-0/1012:
[   27.634286]  #0: ffff888105e26c98 (&ctx->completion_lock)
	{....}-{2:2}, at: __io_req_complete.part.102+0x30/0x70
[   27.649249] Call Trace:
[   27.649874]  dump_stack+0xac/0xe3
[   27.650666]  ___might_sleep+0x284/0x2c0
[   27.651566]  put_files_struct+0xb8/0x120
[   27.652481]  __io_clean_op+0x10c/0x2a0
[   27.653362]  __io_cqring_fill_event+0x2c1/0x350
[   27.654399]  __io_req_complete.part.102+0x41/0x70
[   27.655464]  io_openat2+0x151/0x300
[   27.656297]  io_issue_sqe+0x6c/0x14e0
[   27.660991]  io_wq_submit_work+0x7f/0x240
[   27.662890]  io_worker_handle_work+0x501/0x8a0
[   27.664836]  io_wqe_worker+0x158/0x520
[   27.667726]  kthread+0x134/0x180
[   27.669641]  ret_from_fork+0x1f/0x30

Instead of cleaning files on overflow, return back overflow cancellation
into io_uring_cancel_files(). Previously it was racy to clean
REQ_F_OVERFLOW flag, but we got rid of it, and can do it through
repetitive attempts targeting all matching requests.

Cc: stable@vger.kernel.org # 5.9+
Reported-by: Abaci <abaci@linux.alibaba.com>
Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1c5d71829bf5..f77821626a92 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -970,6 +970,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force);
+static void io_req_drop_files(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -990,8 +991,7 @@ EXPORT_SYMBOL(io_uring_get_socket);
 
 static inline void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
-			  REQ_F_INFLIGHT))
+	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
 		__io_clean_op(req);
 }
 
@@ -1255,6 +1255,8 @@ static void io_req_clean_work(struct io_kiocb *req)
 			free_fs_struct(fs);
 		req->work.flags &= ~IO_WQ_WORK_FS;
 	}
+	if (req->flags & REQ_F_INFLIGHT)
+		io_req_drop_files(req);
 
 	io_put_identity(req->task->io_uring, req);
 }
@@ -5929,9 +5931,6 @@ static void __io_clean_op(struct io_kiocb *req)
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
-
-	if (req->flags & REQ_F_INFLIGHT)
-		io_req_drop_files(req);
 }
 
 static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
@@ -8669,6 +8668,8 @@ static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
 			break;
 		/* cancel this request, or head link requests */
 		io_attempt_cancel(ctx, cancel_req);
+		io_cqring_overflow_flush(ctx, true, task, files);
+
 		io_put_req(cancel_req);
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
-- 
2.24.0

