Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0510343FC14
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 14:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhJ2MOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 08:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhJ2MOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 08:14:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B09C061570;
        Fri, 29 Oct 2021 05:12:08 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 192so7120962wme.3;
        Fri, 29 Oct 2021 05:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z5km4ePJJmT+VSH3v6s79Reix9nVhIbsLMT7Uqp6eA8=;
        b=InSg1fFLfOy/jAF1pCD4EzR+6QMrnoa6Q7Oqj/B7mAtx+SNuUMPItKv8G3Wex03QTR
         mVMGnn9zC4rrCFF0rV0PAUGPTz74wxldgNycc5lVhZJGkMXcLKRvepm9nX5M54VVNfwj
         RdYeDtSb+fU/se8wbbmkAitoyI7qVdzhFJXtJo3dCZje1ulRSCIDa9hhlRIjsvf2iwux
         aWqD76SISMD1wpShmHWr40BzGESuc3dOg130Sjs7KnFtAXHoTEcvA7qoZhrRhIoojNRD
         Dh0o4F+MPD9AEAqghvC3efeIKXpYr5IqNetShz2gSWpKgaoUHYlxBjaO/9FPrFiESawv
         J5vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z5km4ePJJmT+VSH3v6s79Reix9nVhIbsLMT7Uqp6eA8=;
        b=u48TcKhq94t8X08rEphklKQMG02Z+thRRgUnoD+44hrgHDa7O/uNKVFNJZQEfZ/rhP
         i0wam3H0A+coVXLNCR1h3jFOPLRd8HKawmMkXjyOYUqd99OS+KMDsx14hHW0Bu6YvFez
         K2s1jaaa2tGOsKd5Oh070yRzqu1j9+P/Zf+jg3SP5LF4lrKeOMeagCb4QLLSowhjnEwv
         c7lAgl6jqCOotb+bu253M8zOoxGU27+YAlkEhuaTA/yjONZi6MSnzB9T8NYgm5nGDGvZ
         chE/4aCid1aIKmSJszp/3LXoUgOZ/iOMzZtSP37JoP7S8ogXOl21p2oZpQFI1xALRd0k
         512w==
X-Gm-Message-State: AOAM530KytnB4kzdmhNjCsmLJ+RnGuQBzzTyysARZewjauK7XsP+Essv
        drTZvV7A3vHHO2znHHp6om4uoAmAaT4=
X-Google-Smtp-Source: ABdhPJy7aZSpETvq27Bhtw/wqKtiPg4jgAAm+xz+e22G1StiHTTmOwUzmm7+yBWQxvv2tF33hPgeNg==
X-Received: by 2002:a05:600c:35c2:: with SMTP id r2mr11264051wmq.26.1635509527093;
        Fri, 29 Oct 2021 05:12:07 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.16])
        by smtp.gmail.com with ESMTPSA id g3sm7041451wri.45.2021.10.29.05.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 05:12:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        stable@vger.kernel.org,
        syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com
Subject: [PATCH] io-wq: remove worker to owner tw dependency
Date:   Fri, 29 Oct 2021 13:11:33 +0100
Message-Id: <142a716f4ed936feae868959059154362bfa8c19.1635509451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

INFO: task iou-wrk-6609:6612 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-wrk-6609    state:D stack:27944 pid: 6612 ppid:  6526 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0xb44/0x5960 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 io_worker_exit fs/io-wq.c:183 [inline]
 io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

io-wq worker may submit a task_work to the master task and upon
io_worker_exit() wait for the tw to get executed. The problem appears
when the master task is waiting in coredump.c:

468                     freezer_do_not_count();
469                     wait_for_completion(&core_state->startup);
470                     freezer_count();

Apparently having some dependency on children threads getting everything
stuck. Workaround it by cancelling the taks_work callback that causes it
before going into io_worker_exit() waiting.

p.s. probably a better option is to not submit tw elevating the refcount
in the first place, but let's leave this excercise for the future.

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 422a7ed6a9bd..8fcac49b7b13 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -140,6 +140,7 @@ static void io_wqe_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
 					struct io_cb_cancel_data *match);
+static void create_worker_cb(struct callback_head *cb);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -174,9 +175,44 @@ static void io_worker_ref_put(struct io_wq *wq)
 		complete(&wq->worker_done);
 }
 
+static void io_worker_cancel_cb(struct io_worker *worker)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+
+	atomic_dec(&acct->nr_running);
+	raw_spin_lock(&worker->wqe->lock);
+	acct->nr_workers--;
+	raw_spin_unlock(&worker->wqe->lock);
+	io_worker_ref_put(wq);
+	clear_bit_unlock(0, &worker->create_state);
+	io_worker_release(worker);
+}
+
+static bool io_task_worker_match(struct callback_head *cb, void *data)
+{
+	struct io_worker *worker;
+
+	if (cb->func != create_worker_cb)
+		return false;
+	worker = container_of(cb, struct io_worker, create_work);
+	return worker == data;
+}
+
 static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
+	struct io_wq *wq = wqe->wq;
+
+	while (1) {
+		struct callback_head *cb = task_work_cancel_match(wq->task,
+						io_task_worker_match, worker);
+
+		if (!cb)
+			break;
+		io_worker_cancel_cb(worker);
+	}
 
 	if (refcount_dec_and_test(&worker->ref))
 		complete(&worker->ref_done);
@@ -1150,17 +1186,9 @@ static void io_wq_exit_workers(struct io_wq *wq)
 
 	while ((cb = task_work_cancel_match(wq->task, io_task_work_match, wq)) != NULL) {
 		struct io_worker *worker;
-		struct io_wqe_acct *acct;
 
 		worker = container_of(cb, struct io_worker, create_work);
-		acct = io_wqe_get_acct(worker);
-		atomic_dec(&acct->nr_running);
-		raw_spin_lock(&worker->wqe->lock);
-		acct->nr_workers--;
-		raw_spin_unlock(&worker->wqe->lock);
-		io_worker_ref_put(wq);
-		clear_bit_unlock(0, &worker->create_state);
-		io_worker_release(worker);
+		io_worker_cancel_cb(worker);
 	}
 
 	rcu_read_lock();
-- 
2.33.1

