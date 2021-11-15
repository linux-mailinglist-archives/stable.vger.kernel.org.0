Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906BA451271
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347435AbhKOTjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245041AbhKOTS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8252E6343E;
        Mon, 15 Nov 2021 18:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000841;
        bh=FhDj2qmlp4sEQeKTiBY4rMRGioPgNjfxpCu/e0qgShU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/eodQJ7ghyZiqMm4v/rHA4DgtQ0JiR1Ed6zezkj59iZEPwBvHWPutNz0etAo4tVd
         3VaCo2rJyRSGe8g9cQsIP+zVw67y0BJMNMOmBNRMbiUWQI1SSCxBV3oSXCXDNceXcz
         u+RUvTi3VtH/7BEt1FkSaj6yh5juwl+I1V5WCpaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Black <daniel@mariadb.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 811/849] io-wq: serialize hash clear with wakeup
Date:   Mon, 15 Nov 2021 18:04:54 +0100
Message-Id: <20211115165447.679794362@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit d3e3c102d107bb84251455a298cf475f24bab995 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -401,9 +401,10 @@ static inline unsigned int io_get_work_h
 	return work->flags >> IO_WQ_HASH_SHIFT;
 }
 
-static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
+static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 {
 	struct io_wq *wq = wqe->wq;
+	bool ret = false;
 
 	spin_lock_irq(&wq->hash->wait.lock);
 	if (list_empty(&wqe->wait.entry)) {
@@ -411,9 +412,11 @@ static void io_wait_on_hash(struct io_wq
 		if (!test_bit(hash, &wq->hash->map)) {
 			__set_current_state(TASK_RUNNING);
 			list_del_init(&wqe->wait.entry);
+			ret = true;
 		}
 	}
 	spin_unlock_irq(&wq->hash->wait.lock);
+	return ret;
 }
 
 /*
@@ -474,14 +477,21 @@ static struct io_wq_work *io_get_next_wo
 	}
 
 	if (stall_hash != -1U) {
+		bool unstalled;
+
 		/*
 		 * Set this before dropping the lock to avoid racing with new
 		 * work being added and clearing the stalled bit.
 		 */
 		wqe->flags |= IO_WQE_FLAG_STALLED;
 		raw_spin_unlock(&wqe->lock);
-		io_wait_on_hash(wqe, stall_hash);
+		unstalled = io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
+		if (unstalled) {
+			wqe->flags &= ~IO_WQE_FLAG_STALLED;
+			if (wq_has_sleeper(&wqe->wq->hash->wait))
+				wake_up(&wqe->wq->hash->wait);
+		}
 	}
 
 	return NULL;
@@ -562,11 +572,14 @@ get_next:
 				io_wqe_enqueue(wqe, linked);
 
 			if (hash != -1U && !next_hashed) {
+				/* serialize hash clear with wake_up() */
+				spin_lock_irq(&wq->hash->wait.lock);
 				clear_bit(hash, &wq->hash->map);
+				wqe->flags &= ~IO_WQE_FLAG_STALLED;
+				spin_unlock_irq(&wq->hash->wait.lock);
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
 				raw_spin_lock_irq(&wqe->lock);
-				wqe->flags &= ~IO_WQE_FLAG_STALLED;
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;


