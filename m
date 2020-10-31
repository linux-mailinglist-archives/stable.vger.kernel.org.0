Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145A72A15ED
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgJaLkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgJaLkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F8C52074F;
        Sat, 31 Oct 2020 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144414;
        bh=VFaFGd3h3JyUjMpL0pMtIwJE+mENgbAWKc9v02u+WM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dq61QceaXXGPraKtBYBnoz1k6rUAqWVsuU/jfn485hInbe3lVY6A7XCrI15JFu6pJ
         s8XC8H1ukNADgzCrDsRycdWL+Ecpjjw7cBoKw/QMUrQBimcrNBjEu2GsSS8vcIEpYL
         cdu+hhLUQosCmEKO1b1P3HgnZOJNQNMxXDF1QsC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 10/70] io_uring: reference ->nsproxy for file table commands
Date:   Sat, 31 Oct 2020 12:35:42 +0100
Message-Id: <20201031113459.993297757@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 9b8284921513fc1ea57d87777283a59b05862f03 upstream.

If we don't get and assign the namespace for the async work, then certain
paths just don't work properly (like /dev/stdin, /proc/mounts, etc).
Anything that references the current namespace of the given task should
be assigned for async work on behalf of that task.

Cc: stable@vger.kernel.org # v5.5+
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c    |    4 ++++
 fs/io-wq.h    |    1 +
 fs/io_uring.c |    3 +++
 3 files changed, 8 insertions(+)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -60,6 +60,7 @@ struct io_worker {
 	const struct cred *cur_creds;
 	const struct cred *saved_creds;
 	struct files_struct *restore_files;
+	struct nsproxy *restore_nsproxy;
 	struct fs_struct *restore_fs;
 };
 
@@ -153,6 +154,7 @@ static bool __io_worker_unuse(struct io_
 
 		task_lock(current);
 		current->files = worker->restore_files;
+		current->nsproxy = worker->restore_nsproxy;
 		task_unlock(current);
 	}
 
@@ -318,6 +320,7 @@ static void io_worker_start(struct io_wq
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	worker->restore_files = current->files;
+	worker->restore_nsproxy = current->nsproxy;
 	worker->restore_fs = current->fs;
 	io_wqe_inc_running(wqe, worker);
 }
@@ -454,6 +457,7 @@ static void io_impersonate_work(struct i
 	if (work->files && current->files != work->files) {
 		task_lock(current);
 		current->files = work->files;
+		current->nsproxy = work->nsproxy;
 		task_unlock(current);
 	}
 	if (work->fs && current->fs != work->fs)
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -88,6 +88,7 @@ struct io_wq_work {
 	struct files_struct *files;
 	struct mm_struct *mm;
 	const struct cred *creds;
+	struct nsproxy *nsproxy;
 	struct fs_struct *fs;
 	unsigned flags;
 };
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1456,6 +1456,7 @@ static void io_req_drop_files(struct io_
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
 	put_files_struct(req->work.files);
+	put_nsproxy(req->work.nsproxy);
 	req->work.files = NULL;
 }
 
@@ -5685,6 +5686,8 @@ static int io_grab_files(struct io_kiocb
 		return 0;
 
 	req->work.files = get_files_struct(current);
+	get_nsproxy(current->nsproxy);
+	req->work.nsproxy = current->nsproxy;
 	req->flags |= REQ_F_INFLIGHT;
 
 	spin_lock_irq(&ctx->inflight_lock);


