Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B706B40E50E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349667AbhIPRHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346583AbhIPRFT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:05:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37EE861B27;
        Thu, 16 Sep 2021 16:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810120;
        bh=zO7qqT/ZKbK6ZhWwcN8iVmqa+M931cnf6yv2tC+WJQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCMoyvuPjWYit4hAhSr6Sd10vQ9RmlWZlMgG2XJdkJESZPBP6lpUY/NX54fAF/k/5
         9oqY9M4WoDQo1DwbXX0QjnRrcXP6KdFk6R4hzgDKegeLeNt6qXaFM5QZPzU2yC8QDQ
         ugt1l2Iqyo6Hq3X5ZyW7ap8BYw3HTB14gdTFMHK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 006/432] io-wq: fix wakeup race when adding new work
Date:   Thu, 16 Sep 2021 17:55:55 +0200
Message-Id: <20210916155811.031260657@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 87df7fb922d18e96992aa5e824aa34b2065fef59 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -793,7 +793,7 @@ append:
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
-	int work_flags;
+	bool do_wake;
 	unsigned long flags;
 
 	/*
@@ -806,14 +806,14 @@ static void io_wqe_enqueue(struct io_wqe
 		return;
 	}
 
-	work_flags = work->flags;
 	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
+	do_wake = (work->flags & IO_WQ_WORK_CONCURRENT) ||
+			!atomic_read(&acct->nr_running);
 	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
-	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
-	    !atomic_read(&acct->nr_running))
+	if (do_wake)
 		io_wqe_wake_worker(wqe, acct);
 }
 


