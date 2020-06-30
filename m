Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C11120FBFB
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 20:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgF3Spc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 14:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgF3Sp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 14:45:28 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60EEBC03E979
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 11:45:28 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x8so7924763plm.10
        for <stable@vger.kernel.org>; Tue, 30 Jun 2020 11:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d7I8pJNhdwZ1WVh11yPP8w2P3ehbAYaUNBi/wYOdLCg=;
        b=HSk0m6OAx02qjZfQmduXnzb3y/Zvo3RqE2TrMcht6FFY5929bole20JFYDkJPGw3bn
         clGaHf63I3JOJ1BFn4RDRVUt8bIjo4uCO13XQKHZ4A4fuopAi6K8wmFC2UYQGOPdmRLs
         le4f0NAps3BnQxaJVEWu21quUgQ5rMAj4zvh4dgSY2a2gdDyr1GTUIuk4TOyoDPUPEf6
         kjwn1mpfFCwql+rYMIJbcQ9zbJW3UykvfMkP3xf5EAVSOPBHBI+u0n2NljT1fTbwlZHs
         P9DjQCDGzkG+c2WLBoM2Bf0liJqD/i8DtX47x81UxGEKZ21NJ3oO6bv/RCaoZ9Ukdutn
         nyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d7I8pJNhdwZ1WVh11yPP8w2P3ehbAYaUNBi/wYOdLCg=;
        b=gTNZ3qX3Z2cAnUX+lmB+i3aCL6wByGqxLD39tI6EXmVpShwfTKb3EHkYGI33DHRfOX
         m5JOQGweDAg54Av9IYWb6ofm8/OaAfSOmmQp5seObWPc/HUzPYA7HyPe6hJv5KnnGiUH
         FmerkkAt6U5qmyid9EEc2Z93jT9uZjUOsBldDsItBRGLxqAmyXByGM53gK2sLC1PKDIG
         fEYOVC4ER64HOjBASDbaXklKuJPTrIrJytxBePCaxEiZx735vtkUNdW6YdfAXnqJqKII
         iqrIbGCqVv5pAx3mugeiInwaLMD2EuhA4s1JphRqixhV/7X4r0p60C1Ym2y4yKDUGskp
         EH0g==
X-Gm-Message-State: AOAM533xVBbStOx8M+OdvumVApo+4zgSFr1GI03Ej1qb+WF7Wp/GfAoq
        qMi5ZYwTlCVfWcmiy9xnayXHoA==
X-Google-Smtp-Source: ABdhPJxr0QgHgqzll8LBSzmH1eUWXWQWL85e5LF5vnDi6zMASgXc9Z3ZRlNOENIQZU56fRYo+kHaaw==
X-Received: by 2002:a17:90a:f2c3:: with SMTP id gt3mr6259782pjb.92.1593542727849;
        Tue, 30 Jun 2020 11:45:27 -0700 (PDT)
Received: from localhost.localdomain ([2605:e000:100e:8c61:4113:50ea:3eb3:a39b])
        by smtp.gmail.com with ESMTPSA id n7sm2898108pjq.22.2020.06.30.11.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 11:45:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     oleg@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: use signal based task_work running
Date:   Tue, 30 Jun 2020 12:45:18 -0600
Message-Id: <20200630184518.696101-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200630184518.696101-1-axboe@kernel.dk>
References: <20200630184518.696101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since 5.7, we've been using task_work to trigger async running of
requests in the context of the original task. This generally works
great, but there's a case where if the task is currently blocked
in the kernel waiting on a condition to become true, it won't process
task_work. Even though the task is woken, it just checks whatever
condition it's waiting on, and goes back to sleep if it's still false.

This is a problem if that very condition only becomes true when that
task_work is run. An example of that is the task registering an eventfd
with io_uring, and it's now blocked waiting on an eventfd read. That
read could depend on a completion event, and that completion event
won't get trigged until task_work has been run.

Use the TWA_SIGNAL notification for task_work, so that we ensure that
the task always runs the work when queued.

Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e507737f044e..476f03b42777 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4072,6 +4072,23 @@ struct io_poll_table {
 	int error;
 };
 
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
+				int notify)
+{
+	const bool is_sqthread = (req->ctx->flags & IORING_SETUP_SQPOLL) != 0;
+	struct task_struct *tsk = req->task;
+	int ret;
+
+	if (is_sqthread)
+		notify = 0;
+
+	ret = task_work_add(tsk, cb, notify);
+
+	if (!ret && is_sqthread)
+		wake_up_process(tsk);
+	return ret;
+}
+
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
@@ -4095,13 +4112,13 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = task_work_add(tsk, &req->task_work, true);
+	ret = io_req_task_work_add(req, &req->task_work, TWA_SIGNAL);
 	if (unlikely(ret)) {
 		WRITE_ONCE(poll->canceled, true);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, true);
+		task_work_add(tsk, &req->task_work, 0);
+		wake_up_process(tsk);
 	}
-	wake_up_process(tsk);
 	return 1;
 }
 
@@ -6182,15 +6199,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
+		/* make sure we run task_work before checking for signals */
 		if (current->task_works)
 			task_work_run();
-		if (io_should_wake(&iowq, false))
-			break;
-		schedule();
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
 		}
+		if (io_should_wake(&iowq, false))
+			break;
+		schedule();
 	} while (1);
 	finish_wait(&ctx->wait, &iowq.wq);
 
-- 
2.27.0

