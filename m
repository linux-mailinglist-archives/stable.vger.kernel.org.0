Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92873CE026
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345838AbhGSPOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345862AbhGSPNQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:13:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6876C61357;
        Mon, 19 Jul 2021 15:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709987;
        bh=U91rBxFsL8oQzdmejrHhFXwgBag5ZQgq4NYXjr0cSU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yieDXVvtdRr9wgzmqokLQrjdfLDPfIQacJDEWMblYHjA2OjW9jzQUhCM4g4yLcg3g
         /pq4wVxs91H+JV2baGCZGBm9vw26rG6QAtR9VHdhXKlpRRbbhfGenNP9FUfT7YijGf
         iQleurG8nJ7CNFg02MaR//tkwUqFJz8ugE57X7uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+dde0cc33951735441301@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>,
        syzbot+88e4f02896967fe1ab0d@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/243] rcu: Reject RCU_LOCKDEP_WARN() false positives
Date:   Mon, 19 Jul 2021 16:50:57 +0200
Message-Id: <20210719144941.832890632@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 3066820034b5dd4e89bd74a7739c51c2d6f5e554 ]

If another lockdep report runs concurrently with an RCU lockdep report
from RCU_LOCKDEP_WARN(), the following sequence of events can occur:

1.	debug_lockdep_rcu_enabled() sees that lockdep is enabled
	when called from (say) synchronize_rcu().

2.	Lockdep is disabled by a concurrent lockdep report.

3.	debug_lockdep_rcu_enabled() evaluates its lockdep-expression
	argument, for example, lock_is_held(&rcu_bh_lock_map).

4.	Because lockdep is now disabled, lock_is_held() plays it safe and
	returns the constant 1.

5.	But in this case, the constant 1 is not safe, because invoking
	synchronize_rcu() under rcu_read_lock_bh() is disallowed.

6.	debug_lockdep_rcu_enabled() wrongly invokes lockdep_rcu_suspicious(),
	resulting in a false-positive splat.

This commit therefore changes RCU_LOCKDEP_WARN() to check
debug_lockdep_rcu_enabled() after checking the lockdep expression,
so that any "safe" returns from lock_is_held() are rejected by
debug_lockdep_rcu_enabled().  This requires memory ordering, which is
supplied by READ_ONCE(debug_locks).  The resulting volatile accesses
prevent the compiler from reordering and the fact that only one variable
is being accessed prevents the underlying hardware from reordering.
The combination works for IA64, which can reorder reads to the same
location, but this is defeated by the volatile accesses, which compile
to load instructions that provide ordering.

Reported-by: syzbot+dde0cc33951735441301@syzkaller.appspotmail.com
Reported-by: Matthew Wilcox <willy@infradead.org>
Reported-by: syzbot+88e4f02896967fe1ab0d@syzkaller.appspotmail.com
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 2 +-
 kernel/rcu/update.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c5adba5e79e7..7d12c76e8fa4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -308,7 +308,7 @@ static inline int rcu_read_lock_any_held(void)
 #define RCU_LOCKDEP_WARN(c, s)						\
 	do {								\
 		static bool __section(".data.unlikely") __warned;	\
-		if (debug_lockdep_rcu_enabled() && !__warned && (c)) {	\
+		if ((c) && debug_lockdep_rcu_enabled() && !__warned) {	\
 			__warned = true;				\
 			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
 		}							\
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 39334d2d2b37..849f0aa99333 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -275,7 +275,7 @@ EXPORT_SYMBOL_GPL(rcu_callback_map);
 
 noinstr int notrace debug_lockdep_rcu_enabled(void)
 {
-	return rcu_scheduler_active != RCU_SCHEDULER_INACTIVE && debug_locks &&
+	return rcu_scheduler_active != RCU_SCHEDULER_INACTIVE && READ_ONCE(debug_locks) &&
 	       current->lockdep_recursion == 0;
 }
 EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
-- 
2.30.2



