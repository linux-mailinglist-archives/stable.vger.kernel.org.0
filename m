Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C89E451371
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbhKOTzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:55:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343949AbhKOTWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07F7B63363;
        Mon, 15 Nov 2021 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002146;
        bh=DdA0QretWp4k5PwhTyCRv9R5py7QCQlDtuhwqxPqFFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8OlW/D6IL9iLtFIKLcVz14EzeaCejiCtOAskAV7Yaz/g+YbwfD2abJsSeMh4MfaT
         3EriCMDHG2hUlX0nW9YwLny4ioT+o6KywT8yTmv/h4h8U+3lMaixbWo44VMmysDnG0
         BDmB0yowAn4SPFUfA7Ayam5RzfOirmEZTX5LnGI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bixuan Cui <cuibixuan@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH 5.15 448/917] io-wq: Remove duplicate code in io_workqueue_create()
Date:   Mon, 15 Nov 2021 17:59:03 +0100
Message-Id: <20211115165443.969728103@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 71e1cef2d794338cc7b979d4c6144e1dc12718b5 ]

While task_work_add() in io_workqueue_create() is true,
then duplicate code is executed:

  -> clear_bit_unlock(0, &worker->create_state);
  -> io_worker_release(worker);
  -> atomic_dec(&acct->nr_running);
  -> io_worker_ref_put(wq);
  -> return false;

  -> clear_bit_unlock(0, &worker->create_state); // back to io_workqueue_create()
  -> io_worker_release(worker);
  -> kfree(worker);

The io_worker_release() and clear_bit_unlock() are executed twice.

Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Link: https://lore.kernel.org/r/20210911085847.34849-1-cuibixuan@huawei.com
Reviwed-by: Hao Xu <haoxu@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 203c0e2a5dfae..5d189b24a8d4b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -359,8 +359,10 @@ static bool io_queue_worker_create(struct io_worker *worker,
 
 	init_task_work(&worker->create_work, func);
 	worker->create_index = acct->index;
-	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
+	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
+		clear_bit_unlock(0, &worker->create_state);
 		return true;
+	}
 	clear_bit_unlock(0, &worker->create_state);
 fail_release:
 	io_worker_release(worker);
@@ -765,11 +767,8 @@ static void io_workqueue_create(struct work_struct *work)
 	struct io_worker *worker = container_of(work, struct io_worker, work);
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 
-	if (!io_queue_worker_create(worker, acct, create_worker_cont)) {
-		clear_bit_unlock(0, &worker->create_state);
-		io_worker_release(worker);
+	if (!io_queue_worker_create(worker, acct, create_worker_cont))
 		kfree(worker);
-	}
 }
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
-- 
2.33.0



