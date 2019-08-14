Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889ED8DA1E
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbfHNRPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731206AbfHNRPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:15:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 538E0214DA;
        Wed, 14 Aug 2019 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802915;
        bh=dE3D+F4skbFjy5hvykzWYLmOKidb7j7vPCxSnfZi97k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbqtHoJBTLoCZgI4y5Gn9XJ/7zYeqzeaYfXaSqwP9Dgw97b5EUNClvxW5zNURSTcJ
         f85pBK/TTGIH1K7cuU8C0NFjm9uGElzHt/epu8yqtH9K1L0vv6FmuAHCNyplevvqj4
         uWisg9g7wm9YNf7PI+aiDPoCcBbYp8o0Xt91TpSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 49/69] tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep loop
Date:   Wed, 14 Aug 2019 19:01:47 +0200
Message-Id: <20190814165748.892413705@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 952041a8639a7a3a73a2b6573cb8aa8518bc39f8 ]

While reviewing rwsem down_slowpath, Will noticed ldsem had a copy of
a bug we just found for rwsem.

  X = 0;

  CPU0			CPU1

  rwsem_down_read()
    for (;;) {
      set_current_state(TASK_UNINTERRUPTIBLE);

                        X = 1;
                        rwsem_up_write();
                          rwsem_mark_wake()
                            atomic_long_add(adjustment, &sem->count);
                            smp_store_release(&waiter->task, NULL);

      if (!waiter.task)
        break;

      ...
    }

  r = X;

Allows 'r == 0'.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 4898e640caf0 ("tty: Add timed, writer-prioritized rw semaphore")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_ldsem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index 5c2cec298816b..c6ce34161281a 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -139,8 +139,7 @@ static void __ldsem_wake_readers(struct ld_semaphore *sem)
 
 	list_for_each_entry_safe(waiter, next, &sem->read_wait, list) {
 		tsk = waiter->task;
-		smp_mb();
-		waiter->task = NULL;
+		smp_store_release(&waiter->task, NULL);
 		wake_up_process(tsk);
 		put_task_struct(tsk);
 	}
@@ -235,7 +234,7 @@ down_read_failed(struct ld_semaphore *sem, long count, long timeout)
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
-		if (!waiter.task)
+		if (!smp_load_acquire(&waiter.task))
 			break;
 		if (!timeout)
 			break;
-- 
2.20.1



