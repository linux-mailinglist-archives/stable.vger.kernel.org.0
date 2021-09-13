Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8785408A3C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 13:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbhIMLcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 07:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239327AbhIMLcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 07:32:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D6A960ED8;
        Mon, 13 Sep 2021 11:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631532651;
        bh=3rSOnPRqQHYVFIqpbCmgk2AAB5cTsgUsWRMHu/1ktAk=;
        h=Subject:To:Cc:From:Date:From;
        b=ZYsnABsalIyZ9PASLRrx79V3PQdfiYfhH1kNoK4faxNbnBNgJUoDRk/65PdpNYImi
         dIBRNA6qPquL5v2MTCHQKlc/LzcTxlW6FjmAka4Mr+zAn2kE3UR1jNtkfWceGdldMh
         SqXc2Xcgc6hZAZPOtK6ww7lsddrkFdWOFSxRBpBM=
Subject: FAILED: patch "[PATCH] io-wq: fix wakeup race when adding new work" failed to apply to 5.13-stable tree
To:     axboe@kernel.dk, andres@anarazel.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 13:30:41 +0200
Message-ID: <163153264195161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 87df7fb922d18e96992aa5e824aa34b2065fef59 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 30 Aug 2021 07:45:47 -0600
Subject: [PATCH] io-wq: fix wakeup race when adding new work

When new work is added, io_wqe_enqueue() checks if we need to wake or
create a new worker. But that check is done outside the lock that
otherwise synchronizes us with a worker going to sleep, so we can end
up in the following situation:

CPU0				CPU1
lock
insert work
unlock
atomic_read(nr_running) != 0
				lock
				atomic_dec(nr_running)
no wakeup needed

Hold the wqe lock around the "need to wakeup" check. Then we can also get
rid of the temporary work_flags variable, as we know the work will remain
valid as long as we hold the lock.

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 13aeb48a0964..cd9bd095fb1b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -794,7 +794,7 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	int work_flags;
+	bool do_wake;
 
 	/*
 	 * If io-wq is exiting for this task, or if the request has explicitly
@@ -806,14 +806,14 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 		return;
 	}
 
-	work_flags = work->flags;
 	raw_spin_lock(&wqe->lock);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
+	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
+			!atomic_read(&acct->nr_running);
 	raw_spin_unlock(&wqe->lock);
 
-	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
-	    !atomic_read(&acct->nr_running))
+	if (do_wake)
 		io_wqe_wake_worker(wqe, acct);
 }
 

