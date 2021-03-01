Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6360D328984
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbhCAR5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:57:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238725AbhCARv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:51:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F9DE650BB;
        Mon,  1 Mar 2021 17:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620519;
        bh=mx6vPhvTek/kyPDSLu1/sdse0OOuYRMxo4Un60gyHpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YY6VC/JdAoGEcX/2t0BxPLH+/dK1lpKtU1d/7opTsshTjRA/3bhxmRKog2gDa+8V2
         oWPNwz2FmGWsRBq5/TVNmVSFGngkpyiEYGfNwsjTTD6wpq0sU+qtMBg85HrndldZQY
         QghpKBmHZm7RtkLgnw35yAftTc8jaKYi9huln6h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 183/775] kcsan: Rewrite kcsan_prandom_u32_max() without prandom_u32_state()
Date:   Mon,  1 Mar 2021 17:05:51 +0100
Message-Id: <20210301161210.674713285@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit 71a076f4a61a6c779794ad286f356b39725edc3b ]

Rewrite kcsan_prandom_u32_max() to not depend on code that might be
instrumented, removing any dependency on lib/random32.c. The rewrite
implements a simple linear congruential generator, that is sufficient
for our purposes (for udelay() and skip_watch counter randomness).

The initial motivation for this was to allow enabling KCSAN for
kernel/sched (remove KCSAN_SANITIZE := n from kernel/sched/Makefile),
with CONFIG_DEBUG_PREEMPT=y. Without this change, we could observe
recursion:

	check_access() [via instrumentation]
	  kcsan_setup_watchpoint()
	    reset_kcsan_skip()
	      kcsan_prandom_u32_max()
	        get_cpu_var()
		  preempt_disable()
		    preempt_count_add() [in kernel/sched/core.c]
		      check_access() [via instrumentation]

Note, while this currently does not affect an unmodified kernel, it'd be
good to keep a KCSAN kernel working when KCSAN_SANITIZE := n is removed
from kernel/sched/Makefile to permit testing scheduler code with KCSAN
if desired.

Fixes: cd290ec24633 ("kcsan: Use tracing-safe version of prandom")
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcsan/core.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index 3994a217bde76..3bf98db9c702d 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -12,7 +12,6 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
-#include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 
@@ -101,7 +100,7 @@ static atomic_long_t watchpoints[CONFIG_KCSAN_NUM_WATCHPOINTS + NUM_SLOTS-1];
 static DEFINE_PER_CPU(long, kcsan_skip);
 
 /* For kcsan_prandom_u32_max(). */
-static DEFINE_PER_CPU(struct rnd_state, kcsan_rand_state);
+static DEFINE_PER_CPU(u32, kcsan_rand_state);
 
 static __always_inline atomic_long_t *find_watchpoint(unsigned long addr,
 						      size_t size,
@@ -275,20 +274,17 @@ should_watch(const volatile void *ptr, size_t size, int type, struct kcsan_ctx *
 }
 
 /*
- * Returns a pseudo-random number in interval [0, ep_ro). See prandom_u32_max()
- * for more details.
- *
- * The open-coded version here is using only safe primitives for all contexts
- * where we can have KCSAN instrumentation. In particular, we cannot use
- * prandom_u32() directly, as its tracepoint could cause recursion.
+ * Returns a pseudo-random number in interval [0, ep_ro). Simple linear
+ * congruential generator, using constants from "Numerical Recipes".
  */
 static u32 kcsan_prandom_u32_max(u32 ep_ro)
 {
-	struct rnd_state *state = &get_cpu_var(kcsan_rand_state);
-	const u32 res = prandom_u32_state(state);
+	u32 state = this_cpu_read(kcsan_rand_state);
+
+	state = 1664525 * state + 1013904223;
+	this_cpu_write(kcsan_rand_state, state);
 
-	put_cpu_var(kcsan_rand_state);
-	return (u32)(((u64) res * ep_ro) >> 32);
+	return state % ep_ro;
 }
 
 static inline void reset_kcsan_skip(void)
@@ -639,10 +635,14 @@ static __always_inline void check_access(const volatile void *ptr, size_t size,
 
 void __init kcsan_init(void)
 {
+	int cpu;
+
 	BUG_ON(!in_task());
 
 	kcsan_debugfs_init();
-	prandom_seed_full_state(&kcsan_rand_state);
+
+	for_each_possible_cpu(cpu)
+		per_cpu(kcsan_rand_state, cpu) = (u32)get_cycles();
 
 	/*
 	 * We are in the init task, and no other tasks should be running;
-- 
2.27.0



