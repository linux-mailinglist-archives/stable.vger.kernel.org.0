Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AB388D8E
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfHJUrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:47:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55084 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbfHJUoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDZ-00053u-TS; Sat, 10 Aug 2019 21:44:02 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDL-0003eB-QT; Sat, 10 Aug 2019 21:43:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tejun Heo" <tj@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Frederic Weisbecker" <frederic@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Lai Jiangshan" <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Ingo Molnar" <mingo@kernel.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.807087769@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 083/157] locking/lockdep: Add IRQs disabled/enabled
 assertion APIs: lockdep_assert_irqs_enabled()/disabled()
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

commit f54bb2ec02c839f6bfe3e8d438cd93d30b4809dd upstream.

Checking whether IRQs are enabled or disabled is a very common sanity
check, however not free of overhead especially on fastpath where such
assertion is very common.

Lockdep is a good host for such concurrency correctness check and it
even already tracks down IRQs disablement state. Just reuse its
machinery. This will allow us to get rid of the flags pop and check
overhead from fast path when kernel is built for production.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S . Miller <davem@davemloft.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1509980490-4285-2-git-send-email-frederic@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/lockdep.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -525,9 +525,24 @@ do {									\
 	lock_acquire(&(lock)->dep_map, 0, 0, 1, 1, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
+
+#define lockdep_assert_irqs_enabled()	do {				\
+		WARN_ONCE(debug_locks && !current->lockdep_recursion &&	\
+			  !current->hardirqs_enabled,			\
+			  "IRQs not enabled as expected\n");		\
+	} while (0)
+
+#define lockdep_assert_irqs_disabled()	do {				\
+		WARN_ONCE(debug_locks && !current->lockdep_recursion &&	\
+			  current->hardirqs_enabled,			\
+			  "IRQs not disabled as expected\n");		\
+	} while (0)
+
 #else
 # define might_lock(lock) do { } while (0)
 # define might_lock_read(lock) do { } while (0)
+# define lockdep_assert_irqs_enabled() do { } while (0)
+# define lockdep_assert_irqs_disabled() do { } while (0)
 #endif
 
 #ifdef CONFIG_PROVE_RCU

