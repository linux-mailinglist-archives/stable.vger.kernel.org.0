Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7B0362606
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 18:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbhDPQxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 12:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbhDPQxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 12:53:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF7CC061574;
        Fri, 16 Apr 2021 09:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=xwaZyhGuHVF//stIgQlHvFV7S2mNDzaikOUoLUnlYCU=; b=hvEHoCOegBtEzZ29Q5fkQM2d7k
        WoZcKE7oIkWemXrxUQANxgUpTzHvShoPAA5gT0KCd47RXMuEvAuywOebvr1SntAVPLsLNnbHbwwO7
        SDfHvn3435dcG/F8l+BT0jZvCDbN2e2dCCFH+Zh7ZUeVTYIo+w5CXZ1OmrIE71bDk+8bLZ0wCePvK
        Z8ZhZwu4iC10qJkgGVEVvRz1B5kFV9mmiHlhEZ514zzjWmE4u6r3BafHsORmAvELSyJjHdnnYlTe3
        FnO1NkZCSlmk71191XRotqWcQX+2NclLuaqs7w30HG6DVYl9SXxERmxptExoNSu//mEou7SEWY9Nu
        NbDY4MPA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lXRhO-00AD29-Ea; Fri, 16 Apr 2021 16:52:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5EA3E300212;
        Fri, 16 Apr 2021 18:52:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3AABE20C8DE34; Fri, 16 Apr 2021 18:52:05 +0200 (CEST)
Date:   Fri, 16 Apr 2021 18:52:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ali Saidi <alisaidi@amazon.com>
Cc:     linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        steve.capper@arm.com, benh@kernel.crashing.org,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH v2] locking/qrwlock: Fix ordering in
 queued_write_lock_slowpath
Message-ID: <YHnAtePBSB8YBQNc@hirez.programming.kicks-ass.net>
References: <20210415172711.15480-1-alisaidi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210415172711.15480-1-alisaidi@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



I've edited the thing to look like so. I'll go queue it for
locking/urgent.

---
Subject: locking/qrwlock: Fix ordering in queued_write_lock_slowpath()
From: Ali Saidi <alisaidi@amazon.com>
Date: Thu, 15 Apr 2021 17:27:11 +0000

From: Ali Saidi <alisaidi@amazon.com>

While this code is executed with the wait_lock held, a reader can
acquire the lock without holding wait_lock.  The writer side loops
checking the value with the atomic_cond_read_acquire(), but only truly
acquires the lock when the compare-and-exchange is completed
successfully which isn’t ordered. This exposes the window between the
acquire and the cmpxchg to an A-B-A problem which allows reads
following the lock acquisition to observe values speculatively before
the write lock is truly acquired.

We've seen a problem in epoll where the reader does a xchg while
holding the read lock, but the writer can see a value change out from
under it.

  Writer                                | Reader
  --------------------------------------------------------------------------------
  ep_scan_ready_list()                  |
  |- write_lock_irq()                   |
      |- queued_write_lock_slowpath()   |
	|- atomic_cond_read_acquire()   |
				        | read_lock_irqsave(&ep->lock, flags);
     --> (observes value before unlock) |  chain_epi_lockless()
     |                                  |    epi->next = xchg(&ep->ovflist, epi);
     |                                  | read_unlock_irqrestore(&ep->lock, flags);
     |                                  |
     |     atomic_cmpxchg_relaxed()     |
     |-- READ_ONCE(ep->ovflist);        |

A core can order the read of the ovflist ahead of the
atomic_cmpxchg_relaxed(). Switching the cmpxchg to use acquire
semantics addresses this issue at which point the atomic_cond_read can
be switched to use relaxed semantics.

Fixes: b519b56e378ee ("locking/qrwlock: Use atomic_cond_read_acquire() when spinning in qrwlock")
Signed-off-by: Ali Saidi <alisaidi@amazon.com>
[peterz: use try_cmpxchg()]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steve Capper <steve.capper@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Steve Capper <steve.capper@arm.com>
---
 kernel/locking/qrwlock.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -60,6 +60,8 @@ EXPORT_SYMBOL(queued_read_lock_slowpath)
  */
 void queued_write_lock_slowpath(struct qrwlock *lock)
 {
+	int cnts;
+
 	/* Put the writer into the wait queue */
 	arch_spin_lock(&lock->wait_lock);
 
@@ -73,9 +75,8 @@ void queued_write_lock_slowpath(struct q
 
 	/* When no more readers or writers, set the locked flag */
 	do {
-		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
-	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
-					_QW_LOCKED) != _QW_WAITING);
+		cnts = atomic_cond_read_relaxed(&lock->cnts, VAL == _QW_WAITING);
+	} while (!atomic_try_cmpxchg_acquire(&lock->cnts, &cnts, _QW_LOCKED));
 unlock:
 	arch_spin_unlock(&lock->wait_lock);
 }
