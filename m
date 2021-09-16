Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0296540E243
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242775AbhIPQgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243388AbhIPQbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB1656139D;
        Thu, 16 Sep 2021 16:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809165;
        bh=4y7d6eNf3CnLHhCIJnoYCZBlbt6It4TOIRU/5cZdg3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mzsg/KwSryV/Twt+uqK+N4QxG2rVnK6xY2unyH9YgYtlfh7kSgSU8pyreCe6hv9zq
         3t/WUtNaBlfg8zFWW2b4KD5D0RQSXj3EJ3B9kNtpWxB0g/iEClPhadi/VTPlVsGpZK
         c7KLAQvkV/pdI8syNvy7QP66INR9zAxbTV5OwYQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 055/380] io-wq: fix race between adding work and activating a free worker
Date:   Thu, 16 Sep 2021 17:56:52 +0200
Message-Id: <20210916155805.859379121@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 94ffb0a282872c2f4b14f757fa1aef2302aeaabb upstream.

The attempt to find and activate a free worker for new work is currently
combined with creating a new one if we don't find one, but that opens
io-wq up to a race where the worker that is found and activated can
put itself to sleep without knowing that it has been selected to perform
this new work.

Fix this by moving the activation into where we add the new work item,
then we can retain it within the wqe->lock scope and elimiate the race
with the worker itself checking inside the lock, but sleeping outside of
it.

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |   50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -237,9 +237,9 @@ static bool io_wqe_activate_free_worker(
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 {
-	bool ret;
+	bool do_create = false, first = false;
 
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -248,25 +248,18 @@ static void io_wqe_wake_worker(struct io
 	if (unlikely(!acct->max_workers))
 		pr_warn_once("io-wq is not configured for unbound workers");
 
-	rcu_read_lock();
-	ret = io_wqe_activate_free_worker(wqe);
-	rcu_read_unlock();
-
-	if (!ret) {
-		bool do_create = false, first = false;
-
-		raw_spin_lock_irq(&wqe->lock);
-		if (acct->nr_workers < acct->max_workers) {
-			atomic_inc(&acct->nr_running);
-			atomic_inc(&wqe->wq->worker_refs);
-			if (!acct->nr_workers)
-				first = true;
-			acct->nr_workers++;
-			do_create = true;
-		}
-		raw_spin_unlock_irq(&wqe->lock);
-		if (do_create)
-			create_io_worker(wqe->wq, wqe, acct->index, first);
+	raw_spin_lock_irq(&wqe->lock);
+	if (acct->nr_workers < acct->max_workers) {
+		if (!acct->nr_workers)
+			first = true;
+		acct->nr_workers++;
+		do_create = true;
+	}
+	raw_spin_unlock_irq(&wqe->lock);
+	if (do_create) {
+		atomic_inc(&acct->nr_running);
+		atomic_inc(&wqe->wq->worker_refs);
+		create_io_worker(wqe->wq, wqe, acct->index, first);
 	}
 }
 
@@ -798,7 +791,8 @@ append:
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	bool do_wake;
+	unsigned work_flags = work->flags;
+	bool do_create;
 	unsigned long flags;
 
 	/*
@@ -814,12 +808,16 @@ static void io_wqe_enqueue(struct io_wqe
 	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
-	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
-			!atomic_read(&acct->nr_running);
+
+	rcu_read_lock();
+	do_create = !io_wqe_activate_free_worker(wqe);
+	rcu_read_unlock();
+
 	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
-	if (do_wake)
-		io_wqe_wake_worker(wqe, acct);
+	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
+	    !atomic_read(&acct->nr_running)))
+		io_wqe_create_worker(wqe, acct);
 }
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)


