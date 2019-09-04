Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE0BA90A5
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389008AbfIDSK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390170AbfIDSKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C2FC23400;
        Wed,  4 Sep 2019 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620654;
        bh=reqK3qDzV0OY1qcf3LHJVujmnjBe/yW+o7i+jB6muVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZGdHn8mdjIWAQY63T0A6/chrIbjfPnQ1yx0kqUFIJoXDD3vdr2EhFBdm85nTsNjbS
         FW/Ou9mTKslh2Mor0DIIH04N7pYHMpSNQiwGazHqN5Pt0rnagrO3Zv34fOLpHM1jND
         6sSTAuW3AEimFrukyvia/i9w+XikFjdRtL6YgouI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jan Stancek <jstancek@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 044/143] lcoking/rwsem: Add missing ACQUIRE to read_slowpath sleep loop
Date:   Wed,  4 Sep 2019 19:53:07 +0200
Message-Id: <20190904175315.793575310@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 99143f82a255e7f054bead8443462fae76dd829e ]

While reviewing another read_slowpath patch, both Will and I noticed
another missing ACQUIRE, namely:

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

Reported-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/rwsem-xadd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 397dedc58432d..385ebcfc31a6d 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -485,8 +485,10 @@ __rwsem_down_read_failed_common(struct rw_semaphore *sem, int state)
 	/* wait to be given the lock */
 	while (true) {
 		set_current_state(state);
-		if (!waiter.task)
+		if (!smp_load_acquire(&waiter.task)) {
+			/* Orders against rwsem_mark_wake()'s smp_store_release() */
 			break;
+		}
 		if (signal_pending_state(state, current)) {
 			raw_spin_lock_irq(&sem->wait_lock);
 			if (waiter.task)
-- 
2.20.1



