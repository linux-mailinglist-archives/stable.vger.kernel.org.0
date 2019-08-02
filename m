Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F857F949
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390346AbfHBN0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394586AbfHBN0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:26:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3420217D6;
        Fri,  2 Aug 2019 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752388;
        bh=6qK9OVy4Pzr/sOJfb0SO2JV/uW04oNG6W7YR1nTxNwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJMBeLXwexeOC7KyVbIpXlK72YHXtys7Xa884vXQWJWLYsTNUmQIeOy9z/OovmxRU
         LAZo3+Ia4sdpeNJR/mYzaxRALWNqDUIrWK5fU61rPghstgQYYcHXiVwTrFUE3GQW1Q
         XendZVKZOyper99Mcr0IRVlB2vzQYyr7D3Hz+OzM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 21/22] tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep loop
Date:   Fri,  2 Aug 2019 09:25:45 -0400
Message-Id: <20190802132547.14517-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132547.14517-1-sashal@kernel.org>
References: <20190802132547.14517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

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
index dbd7ba32caac3..6c5eb99fcfcee 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -137,8 +137,7 @@ static void __ldsem_wake_readers(struct ld_semaphore *sem)
 
 	list_for_each_entry_safe(waiter, next, &sem->read_wait, list) {
 		tsk = waiter->task;
-		smp_mb();
-		waiter->task = NULL;
+		smp_store_release(&waiter->task, NULL);
 		wake_up_process(tsk);
 		put_task_struct(tsk);
 	}
@@ -234,7 +233,7 @@ down_read_failed(struct ld_semaphore *sem, long count, long timeout)
 	for (;;) {
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 
-		if (!waiter.task)
+		if (!smp_load_acquire(&waiter.task))
 			break;
 		if (!timeout)
 			break;
-- 
2.20.1

