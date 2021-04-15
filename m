Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B92F36111A
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 19:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhDOR2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 13:28:21 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:32430 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhDOR2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 13:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1618507678; x=1650043678;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h6nyQCQiH/sJBYBieZaGVxNQkuHLEIB52xWGhkpFXi8=;
  b=mBPlGx6MKbRBes0ySiQOEZ6vtQHNx/hmb2l0u+3uBaDmn0T1tMvIR0k/
   d9+4VC7CkqXSZHBg63pJqbMRTvjrOH+eBw6c8OxAYfYeuZ5U6c4ACknOd
   T7xQ11+ViuEhKryLpNTXp4zaVzMO4lK2aApQIquB+vmX9F/KXG/xaCPII
   A=;
X-IronPort-AV: E=Sophos;i="5.82,225,1613433600"; 
   d="scan'208";a="118783787"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 15 Apr 2021 17:27:57 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 98A15A258B;
        Thu, 15 Apr 2021 17:27:54 +0000 (UTC)
Received: from EX13D02UWC003.ant.amazon.com (10.43.162.199) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 15 Apr 2021 17:27:52 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC003.ant.amazon.com (10.43.162.199) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 15 Apr 2021 17:27:52 +0000
Received: from dev-dsk-alisaidi-i31e-9f3421fe.us-east-1.amazon.com
 (10.200.138.153) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 15 Apr 2021 17:27:52 +0000
Received: by dev-dsk-alisaidi-i31e-9f3421fe.us-east-1.amazon.com (Postfix, from userid 5131138)
        id 27122228E4; Thu, 15 Apr 2021 17:27:51 +0000 (UTC)
From:   Ali Saidi <alisaidi@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <alisaidi@amazon.com>, <catalin.marinas@arm.com>,
        <steve.capper@arm.com>, <benh@kernel.crashing.org>,
        <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH v2] locking/qrwlock: Fix ordering in queued_write_lock_slowpath
Date:   Thu, 15 Apr 2021 17:27:11 +0000
Message-ID: <20210415172711.15480-1-alisaidi@amazon.com>
X-Mailer: git-send-email 2.24.4.AMZN
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While this code is executed with the wait_lock held, a reader can
acquire the lock without holding wait_lock.  The writer side loops
checking the value with the atomic_cond_read_acquire(), but only truly
acquires the lock when the compare-and-exchange is completed
successfully which isn’t ordered. This exposes the window between the
acquire and the cmpxchg to an A-B-A problem which allows reads following
the lock acquisition to observe values speculatively before the write
lock is truly acquired.

We've seen a problem in epoll where the reader does a xchg while
holding the read lock, but the writer can see a value change out from under it.

Writer                               | Reader 2
--------------------------------------------------------------------------------
ep_scan_ready_list()                 |
|- write_lock_irq()                  |
    |- queued_write_lock_slowpath()  |
      |- atomic_cond_read_acquire()  |
                                     | read_lock_irqsave(&ep->lock, flags);
   --> (observes value before unlock)|  chain_epi_lockless()
   |                                 |    epi->next = xchg(&ep->ovflist, epi);
   |                                 | read_unlock_irqrestore(&ep->lock, flags);
   |                                 |
   |     atomic_cmpxchg_relaxed()    |
   |-- READ_ONCE(ep->ovflist);       |

A core can order the read of the ovflist ahead of the
atomic_cmpxchg_relaxed(). Switching the cmpxchg to use acquire semantics
addresses this issue at which point the atomic_cond_read can be switched
to use relaxed semantics.

Fixes: b519b56e378ee ("locking/qrwlock: Use atomic_cond_read_acquire() when spinning in qrwlock")
Signed-off-by: Ali Saidi <alisaidi@amazon.com>
Cc: stable@vger.kernel.org
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Steve Capper <steve.capper@arm.com>
Reviewed-by: Steve Capper <steve.capper@arm.com>

---
 kernel/locking/qrwlock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index 4786dd271b45..10770f6ac4d9 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -73,8 +73,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
 
 	/* When no more readers or writers, set the locked flag */
 	do {
-		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
-	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
+		atomic_cond_read_relaxed(&lock->cnts, VAL == _QW_WAITING);
+	} while (atomic_cmpxchg_acquire(&lock->cnts, _QW_WAITING,
 					_QW_LOCKED) != _QW_WAITING);
 unlock:
 	arch_spin_unlock(&lock->wait_lock);
-- 
2.24.4.AMZN

