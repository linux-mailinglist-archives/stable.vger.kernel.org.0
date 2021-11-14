Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1E544F87E
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 15:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhKNO3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 09:29:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:60196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231796AbhKNO2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 09:28:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9654A611EE;
        Sun, 14 Nov 2021 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636899956;
        bh=R3pbe+vXVZbTxWOXuB2IBoVziAUmPXGSqeMLkiDFklA=;
        h=Subject:To:Cc:From:Date:From;
        b=OpNqKFYfI7PHkJTRjKYra4W5ANsgnfRyw6uQdSQnDCjFkF6r3IzbfTvWGKr4T8EI0
         DE2EVnci0JmAjjFcvwi1xREuPcjErXfm4eKqyUOObSE5r7cJOQzxt6BqPm2WWeRx9Y
         xYABJyPRB2MBPlGe/uidI1uG57KIkWClc0CuCai4=
Subject: FAILED: patch "[PATCH] io-wq: serialize hash clear with wakeup" failed to apply to 5.14-stable tree
To:     axboe@kernel.dk, daniel@mariadb.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 15:25:53 +0100
Message-ID: <1636899953125228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d3e3c102d107bb84251455a298cf475f24bab995 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 11 Nov 2021 17:32:53 -0700
Subject: [PATCH] io-wq: serialize hash clear with wakeup

We need to ensure that we serialize the stalled and hash bits with the
wait_queue wait handler, or we could be racing with someone modifying
the hashed state after we find it busy, but before we then give up and
wait for it to be cleared. This can cause random delays or stalls when
handling buffered writes for many files, where some of these files cause
hash collisions between the worker threads.

Cc: stable@vger.kernel.org
Reported-by: Daniel Black <daniel@mariadb.org>
Fixes: e941894eae31 ("io-wq: make buffered file write hashed work map per-ctx")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.c b/fs/io-wq.c
index afd955d53db9..88202de519f6 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -423,9 +423,10 @@ static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 	return work->flags >> IO_WQ_HASH_SHIFT;
 }
 
-static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
+static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 {
 	struct io_wq *wq = wqe->wq;
+	bool ret = false;
 
 	spin_lock_irq(&wq->hash->wait.lock);
 	if (list_empty(&wqe->wait.entry)) {
@@ -433,9 +434,11 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 		if (!test_bit(hash, &wq->hash->map)) {
 			__set_current_state(TASK_RUNNING);
 			list_del_init(&wqe->wait.entry);
+			ret = true;
 		}
 	}
 	spin_unlock_irq(&wq->hash->wait.lock);
+	return ret;
 }
 
 static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
@@ -475,14 +478,21 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	}
 
 	if (stall_hash != -1U) {
+		bool unstalled;
+
 		/*
 		 * Set this before dropping the lock to avoid racing with new
 		 * work being added and clearing the stalled bit.
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 		raw_spin_unlock(&wqe->lock);
-		io_wait_on_hash(wqe, stall_hash);
+		unstalled = io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
+		if (unstalled) {
+			clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
+			if (wq_has_sleeper(&wqe->wq->hash->wait))
+				wake_up(&wqe->wq->hash->wait);
+		}
 	}
 
 	return NULL;
@@ -564,8 +574,11 @@ static void io_worker_handle_work(struct io_worker *worker)
 				io_wqe_enqueue(wqe, linked);
 
 			if (hash != -1U && !next_hashed) {
+				/* serialize hash clear with wake_up() */
+				spin_lock_irq(&wq->hash->wait.lock);
 				clear_bit(hash, &wq->hash->map);
 				clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
+				spin_unlock_irq(&wq->hash->wait.lock);
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
 				raw_spin_lock(&wqe->lock);

