Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384A88D93D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfHNRGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729717AbfHNRGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:06:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3AF2208C2;
        Wed, 14 Aug 2019 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802401;
        bh=sI1rR7Q0OoFFmyKoxb+1VVO9/zhq4ryum9OVSMrKso4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffaOjDjaIRxzsjVv8eyzeJPfokwvsa8gUo3aCLWhuWA66Jk9CitsvvH5/cUur6UoH
         N5LesV0aOXalxjxdqunjUk+b8EA+B/C1cWQg+8A4VH2MKIRngxP0Zw5WV1+kqb13Tp
         nBha9uLsqIkl4xDFYB6AO6ySu2nMu7FFRGm2VPkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 111/144] tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep loop
Date:   Wed, 14 Aug 2019 19:01:07 +0200
Message-Id: <20190814165804.554716394@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
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
index 717292c1c0dfc..60ff236a3d63d 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -93,8 +93,7 @@ static void __ldsem_wake_readers(struct ld_semaphore *sem)
 
 	list_for_each_entry_safe(waiter, next, &sem->read_wait, list) {
 		tsk = waiter->task;
-		smp_mb();
-		waiter->task = NULL;
+		smp_store_release(&waiter->task, NULL);
 		wake_up_process(tsk);
 		put_task_struct(tsk);
 	}
@@ -194,7 +193,7 @@ down_read_failed(struct ld_semaphore *sem, long count, long timeout)
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
-		if (!waiter.task)
+		if (!smp_load_acquire(&waiter.task))
 			break;
 		if (!timeout)
 			break;
-- 
2.20.1



