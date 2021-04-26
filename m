Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2D236AE94
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbhDZHpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233841AbhDZHoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80D3D613EA;
        Mon, 26 Apr 2021 07:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422851;
        bh=dQOG0laoapLFxO2rFa+JWZVS/IKfrplnybk3BUCUjbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOK23njsvY1ziOjoJcWtd0aF2Tz970btc6i9xc4vfI5PzzhwHBH88AG0pxR//tOgd
         G9v8DV3lHkLxS1J4+pSBtJh6FjP+P/2/HGorsY/nhSR876QwgfA4MC4HzC4kpItpvQ
         IvIpQLnNCRytukGv5CJw5z6vclZe+/hzpVjwjCdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ali Saidi <alisaidi@amazon.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 17/41] locking/qrwlock: Fix ordering in queued_write_lock_slowpath()
Date:   Mon, 26 Apr 2021 09:30:04 +0200
Message-Id: <20210426072820.270963381@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ali Saidi <alisaidi@amazon.com>

[ Upstream commit 84a24bf8c52e66b7ac89ada5e3cfbe72d65c1896 ]

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
Acked-by: Waiman Long <longman@redhat.com>
Tested-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/qrwlock.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index fe9ca92faa2a..909b0bf22a1e 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -61,6 +61,8 @@ EXPORT_SYMBOL(queued_read_lock_slowpath);
  */
 void queued_write_lock_slowpath(struct qrwlock *lock)
 {
+	int cnts;
+
 	/* Put the writer into the wait queue */
 	arch_spin_lock(&lock->wait_lock);
 
@@ -74,9 +76,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
 
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
-- 
2.30.2



