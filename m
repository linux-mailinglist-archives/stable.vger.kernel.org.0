Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF38E3C2CC4
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhGJCUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGJCUo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:20:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A315F613B5;
        Sat, 10 Jul 2021 02:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883479;
        bh=+o29IpIqPYmROl/IxSVXDwx7aDMgXMAWBS0+4qGNjTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSl3MXVSAFm+mI4awEJpS06WYW3j2hr5SG39UXRQjxerZspNMg637l6k6woRi0tqJ
         tZPwQLDCDLm/s534tWeQz7Sh0boLnN4sh38QrxXX3ZXoMS3fqiTSVEHY+lQmCy93+8
         8J9nRgwB/favPX0oX46bOy/OEP4W6SJOqOlIU2QlMv8pOk3UIr7Wmbip9ZP2ZnF9hK
         w+/vD+iDSY8DhxN0FHOLLDuGkzlH6ziagqm3WKKrDl+018h/c7Hg7BPO17KWheELTr
         lytnavN5XqGFFfNoGpWO4R/ucML2psEsoJM1qxAhT9jT0wySyevWNSvlNj0C0KdYe/
         JvgKd6W9vcXqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        syzbot+dde0cc33951735441301@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>,
        syzbot+88e4f02896967fe1ab0d@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 007/114] rcu: Reject RCU_LOCKDEP_WARN() false positives
Date:   Fri,  9 Jul 2021 22:16:01 -0400
Message-Id: <20210710021748.3167666-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

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
index 9455476c5ba2..1199ffd305d1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -315,7 +315,7 @@ static inline int rcu_read_lock_any_held(void)
 #define RCU_LOCKDEP_WARN(c, s)						\
 	do {								\
 		static bool __section(".data.unlikely") __warned;	\
-		if (debug_lockdep_rcu_enabled() && !__warned && (c)) {	\
+		if ((c) && debug_lockdep_rcu_enabled() && !__warned) {	\
 			__warned = true;				\
 			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
 		}							\
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index b95ae86c40a7..dd94a602a6d2 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -277,7 +277,7 @@ EXPORT_SYMBOL_GPL(rcu_callback_map);
 
 noinstr int notrace debug_lockdep_rcu_enabled(void)
 {
-	return rcu_scheduler_active != RCU_SCHEDULER_INACTIVE && debug_locks &&
+	return rcu_scheduler_active != RCU_SCHEDULER_INACTIVE && READ_ONCE(debug_locks) &&
 	       current->lockdep_recursion == 0;
 }
 EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
-- 
2.30.2

