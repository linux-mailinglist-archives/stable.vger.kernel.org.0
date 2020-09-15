Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B986226A0A9
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 10:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgIOIXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 04:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgIOIQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 04:16:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03807C061797
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 01:16:16 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id j7so942930plk.11
        for <stable@vger.kernel.org>; Tue, 15 Sep 2020 01:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zsTMso5in9IToE0Sd8Q08atUR2i21AjwGd7fFhxx9VY=;
        b=hBoabkcfBtZExHxA/cGo6upAeOp7PkEdrX2VeOk2P09SaHKt/hhFQxngnUJzsGzHJG
         h7t14IW+yRW1GGB4lUSYF0ddhH8JhL4kqQ2TJpimyM5tBP1V9VTziJOcbfcakF2FxBxA
         D2XO0sBBfbOCMlaa1ID2LHBpHlgdb4UfGau+s3muO71AleMl+/GUf4hT5tzw+xfWWct2
         RKaHgYwtKYggctirL+pp6rN9VWYjwEr48BwqGRfN9S9KD8DoxcR3URFdjrjJ4+s7aNJM
         vaHE9JjunQgwkJawIMW+UckzZCJ9vwmrwIO5I0NkDneuHupgpJF1I4AEyflyOoVHZMrP
         JH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsTMso5in9IToE0Sd8Q08atUR2i21AjwGd7fFhxx9VY=;
        b=UdBsrGw0A5NBDE+lD4+GAhDCCJls6Pvq2dtsLxqcUr79YZ+25Va9mBC6v9lXGBMloT
         Ltgbv+XmByVKA/G9liymgRhal1kHRRosfANNTb0x6994Obbxif4xMbq3+xSI1Kx32MP1
         OV7BDsnLnDyu7atDSJKz077btEuOMRiDUdx0RUeo38tGU0DpPa6lr8TQ2wff2GaxBI+5
         HAIUmWBbm4vMNAcpr999sA2E2S7WcmDaGhF6XJL4H8yQ9OPojzam+pDpa83W5pjj8H9n
         Of+CDhqLmam/iJWnv6xdIXs27zRIy60mq44v3RZS7FGvBR9cYwuyLj/0aKrva9WG/6li
         ZviQ==
X-Gm-Message-State: AOAM533YTpNpPEEizy1GaKUus9EbUggSFiX48E+0aWd2b7uLsTc5uvNV
        oi3P3lkJzfwdulSS+rw0Td+Lig==
X-Google-Smtp-Source: ABdhPJwj7xDMoJMbcYTbqnEyDmlB9T8oja6cKzM2Vg1xGVh51xgSUUs38Uvt5u6qsBbG3zosoVEJhA==
X-Received: by 2002:a17:902:aa0a:b029:d0:89f4:6224 with SMTP id be10-20020a170902aa0ab02900d089f46224mr18289795plb.12.1600157775578;
        Tue, 15 Sep 2020 01:16:15 -0700 (PDT)
Received: from localhost.bytedance.net ([103.136.221.71])
        by smtp.gmail.com with ESMTPSA id x19sm10539429pge.22.2020.09.15.01.16.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 01:16:15 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     axboe@kernel.dk, viro@zeniv.linux.org.uk
Cc:     linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yinyin Zhu <zhuyinyin@bytedance.com>
Subject: [PATCH 1/3] io_uring: Fix resource leaking when kill the process
Date:   Tue, 15 Sep 2020 16:15:49 +0800
Message-Id: <20200915081551.12140-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20200915081551.12140-1-songmuchun@bytedance.com>
References: <20200915081551.12140-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yinyin Zhu <zhuyinyin@bytedance.com>

The commit <1c4404efcf2c0> ("<io_uring: make sure async workqueue is
canceled on exit>") doesn't solve the resource leak problem totally!
When kworker is doing a io task for the io_uring, The process which
submitted the io task has received a SIGKILL signal from the user.
Then the io_cancel_async_work function could have sent a SIGINT
signal to the kworker, but the judging condition is wrong. So it
doesn't send a SIGINT signal to the kworker, then caused the resource
leaking problem. Why the juding condition is wrong? Think that
The process is a multi-threaded process, we call the thread of the
process which has submitted the io task Thread1. So  the req->task
is the current macro of the Thread1. when all the threads of
the process have done exit procedure, the last thread will call the
io_cancel_async_work, but the last thread may not the Thread1,
so the req->task is not equal to the task. so it doesn't
send the SIGINT signal. To fix this bug, we alter the task attribute
of the req with struct files_struct. And the judging condition is
"req->files == files"

Fixes: 1c4404efcf2c0 ("io_uring: make sure async workqueue is canceled on exit")
Signed-off-by: Yinyin Zhu <zhuyinyin@bytedance.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e0200406765c3..de4f7b3a0d789 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -339,7 +339,7 @@ struct io_kiocb {
 	u64			user_data;
 	u32			result;
 	u32			sequence;
-	struct task_struct	*task;
+	struct files_struct	*files;
 
 	struct fs_struct	*fs;
 
@@ -513,7 +513,7 @@ static inline void io_queue_async_work(struct io_ring_ctx *ctx,
 		}
 	}
 
-	req->task = current;
+	req->files = current->files;
 
 	spin_lock_irqsave(&ctx->task_lock, flags);
 	list_add(&req->task_list, &ctx->task_list);
@@ -3708,7 +3708,7 @@ static int io_uring_fasync(int fd, struct file *file, int on)
 }
 
 static void io_cancel_async_work(struct io_ring_ctx *ctx,
-				 struct task_struct *task)
+				 struct files_struct *files)
 {
 	if (list_empty(&ctx->task_list))
 		return;
@@ -3720,7 +3720,7 @@ static void io_cancel_async_work(struct io_ring_ctx *ctx,
 		req = list_first_entry(&ctx->task_list, struct io_kiocb, task_list);
 		list_del_init(&req->task_list);
 		req->flags |= REQ_F_CANCEL;
-		if (req->work_task && (!task || req->task == task))
+		if (req->work_task && (!files || req->files == files))
 			send_sig(SIGINT, req->work_task, 1);
 	}
 	spin_unlock_irq(&ctx->task_lock);
@@ -3745,7 +3745,7 @@ static int io_uring_flush(struct file *file, void *data)
 	struct io_ring_ctx *ctx = file->private_data;
 
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
-		io_cancel_async_work(ctx, current);
+		io_cancel_async_work(ctx, data);
 
 	return 0;
 }
-- 
2.11.0

