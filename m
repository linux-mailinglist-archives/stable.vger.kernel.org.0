Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF51631F6
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgBRUDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729158AbgBRUDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD1192464E;
        Tue, 18 Feb 2020 20:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056230;
        bh=Gx1VSKNcxi/fkNRFLfAEH+vI9f4N0sq/0PmCBrWWOOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwQce9GP7MzrZkK/lRm8+SPLEqU4bOoN+E9mm8wXQrKi5notT3BPiN71ZQsfTG0CR
         vPo0syfhw0C3zAej26dUApzz9KFwSgWvbq2ETh+4hzBHrHix2PekohsAjVJ7tRzbIo
         pJ6b9xm4vg5590B7yevW8H8/KgwmERP05gdQvQrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 77/80] io-wq: add support for inheriting ->fs
Date:   Tue, 18 Feb 2020 20:55:38 +0100
Message-Id: <20200218190439.111549126@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 9392a27d88b9707145d713654eb26f0c29789e50 ]

Some work items need this for relative path lookup, make it available
like the other inherited credentials/mm/etc.

Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 8 ++++++++
 fs/io-wq.h | 4 +++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5147d2213b019..0dc4bb6de6566 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/rculist_nulls.h>
+#include <linux/fs_struct.h>
 
 #include "io-wq.h"
 
@@ -58,6 +59,7 @@ struct io_worker {
 	struct mm_struct *mm;
 	const struct cred *creds;
 	struct files_struct *restore_files;
+	struct fs_struct *restore_fs;
 };
 
 #if BITS_PER_LONG == 64
@@ -150,6 +152,9 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 		task_unlock(current);
 	}
 
+	if (current->fs != worker->restore_fs)
+		current->fs = worker->restore_fs;
+
 	/*
 	 * If we have an active mm, we need to drop the wq lock before unusing
 	 * it. If we do, return true and let the caller retry the idle loop.
@@ -310,6 +315,7 @@ static void io_worker_start(struct io_wqe *wqe, struct io_worker *worker)
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	worker->restore_files = current->files;
+	worker->restore_fs = current->fs;
 	io_wqe_inc_running(wqe, worker);
 }
 
@@ -456,6 +462,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 		}
 		if (!worker->creds)
 			worker->creds = override_creds(wq->creds);
+		if (work->fs && current->fs != work->fs)
+			current->fs = work->fs;
 		if (test_bit(IO_WQ_BIT_CANCEL, &wq->state))
 			work->flags |= IO_WQ_WORK_CANCEL;
 		if (worker->mm)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 3f5e356de9805..bbab98d1d328b 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -72,6 +72,7 @@ struct io_wq_work {
 	};
 	void (*func)(struct io_wq_work **);
 	struct files_struct *files;
+	struct fs_struct *fs;
 	unsigned flags;
 };
 
@@ -79,8 +80,9 @@ struct io_wq_work {
 	do {						\
 		(work)->list.next = NULL;		\
 		(work)->func = _func;			\
-		(work)->flags = 0;			\
 		(work)->files = NULL;			\
+		(work)->fs = NULL;			\
+		(work)->flags = 0;			\
 	} while (0)					\
 
 typedef void (get_work_fn)(struct io_wq_work *);
-- 
2.20.1



