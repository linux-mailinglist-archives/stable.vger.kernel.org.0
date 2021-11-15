Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572B54512CC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347424AbhKOTjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245043AbhKOTS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18268634F6;
        Mon, 15 Nov 2021 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000838;
        bh=L3uN9+P0S+XDR1GSymcw8svx8SwkYmssDHTWKkk9RI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cq1lYdWqjFEA5/TM4aWdDEU4ui+vcg1QCk2xXqBPzJMJeW/xpL4hlEfTdRQsGHC87
         mZXbd9/9jMUZ7kt6tqjM5oLs6R+f9+bMZo9ZL1DBPFxLDk7oZIr0/i0NQhxAGqGsPL
         JKMmkuOFMlXFUvtsLI2rgS5et1/f3wiSIHHPYOCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 810/849] io-wq: fix queue stalling race
Date:   Mon, 15 Nov 2021 18:04:53 +0100
Message-Id: <20211115165447.641713539@linuxfoundation.org>
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

commit 0242f6426ea78fbe3933b44f8c55ae93ec37f6cc upstream.

We need to set the stalled bit early, before we drop the lock for adding
us to the stall hash queue. If not, then we can race with new work being
queued between adding us to the stall hash and io_worker_handle_work()
marking us stalled.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -436,8 +436,7 @@ static bool io_worker_can_run_work(struc
 }
 
 static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
-					   struct io_worker *worker,
-					   bool *stalled)
+					   struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -475,10 +474,14 @@ static struct io_wq_work *io_get_next_wo
 	}
 
 	if (stall_hash != -1U) {
+		/*
+		 * Set this before dropping the lock to avoid racing with new
+		 * work being added and clearing the stalled bit.
+		 */
+		wqe->flags |= IO_WQE_FLAG_STALLED;
 		raw_spin_unlock(&wqe->lock);
 		io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
-		*stalled = true;
 	}
 
 	return NULL;
@@ -518,7 +521,6 @@ static void io_worker_handle_work(struct
 
 	do {
 		struct io_wq_work *work;
-		bool stalled;
 get_next:
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
@@ -527,12 +529,9 @@ get_next:
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		stalled = false;
-		work = io_get_next_work(wqe, worker, &stalled);
+		work = io_get_next_work(wqe, worker);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
-		else if (stalled)
-			wqe->flags |= IO_WQE_FLAG_STALLED;
 
 		raw_spin_unlock_irq(&wqe->lock);
 		if (!work)


