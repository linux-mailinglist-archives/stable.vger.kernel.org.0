Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B139B23A632
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgHCMpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgHCM11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:27:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D31E207DF;
        Mon,  3 Aug 2020 12:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457646;
        bh=RMz6cKYNxMZuugoaSHv0PdWbqR1GvdDtewVaDPXuXkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAIb90Gbp/tnCH0C6BAaobkhDZm8yAGH2JdrnQ781WICVr6utFj3Li4iV3d84jmpI
         msvaElJ9gyU/a7FisQ5UrW5qNhuXMVnf9q9IO0So981ewUAzun1UAYQTDup7NDUzsy
         KNbGzKQXTWLybG6/fU6JqTTZf7bq/9f/s3OvYO4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Klein <aksecurity@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 5.4 22/90] random32: update the net random state on interrupt and activity
Date:   Mon,  3 Aug 2020 14:18:44 +0200
Message-Id: <20200803121858.692114229@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit f227e3ec3b5cad859ad15666874405e8c1bbc1d4 upstream.

This modifies the first 32 bits out of the 128 bits of a random CPU's
net_rand_state on interrupt or CPU activity to complicate remote
observations that could lead to guessing the network RNG's internal
state.

Note that depending on some network devices' interrupt rate moderation
or binding, this re-seeding might happen on every packet or even almost
never.

In addition, with NOHZ some CPUs might not even get timer interrupts,
leaving their local state rarely updated, while they are running
networked processes making use of the random state.  For this reason, we
also perform this update in update_process_times() in order to at least
update the state when there is user or system activity, since it's the
only case we care about.

Reported-by: Amit Klein <aksecurity@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c  |    1 +
 include/linux/random.h |    3 +++
 kernel/time/timer.c    |    8 ++++++++
 lib/random32.c         |    2 +-
 4 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1330,6 +1330,7 @@ void add_interrupt_randomness(int irq, i
 
 	fast_mix(fast_pool);
 	add_interrupt_bench(cycles);
+	this_cpu_add(net_rand_state.s1, fast_pool->pool[cycles & 3]);
 
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -9,6 +9,7 @@
 
 #include <linux/list.h>
 #include <linux/once.h>
+#include <linux/percpu.h>
 
 #include <uapi/linux/random.h>
 
@@ -117,6 +118,8 @@ struct rnd_state {
 	__u32 s1, s2, s3, s4;
 };
 
+DECLARE_PER_CPU(struct rnd_state, net_rand_state) __latent_entropy;
+
 u32 prandom_u32_state(struct rnd_state *state);
 void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
 void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -43,6 +43,7 @@
 #include <linux/sched/debug.h>
 #include <linux/slab.h>
 #include <linux/compat.h>
+#include <linux/random.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -1742,6 +1743,13 @@ void update_process_times(int user_tick)
 	scheduler_tick();
 	if (IS_ENABLED(CONFIG_POSIX_TIMERS))
 		run_posix_cpu_timers();
+
+	/* The current CPU might make use of net randoms without receiving IRQs
+	 * to renew them often enough. Let's update the net_rand_state from a
+	 * non-constant value that's not affine to the number of calls to make
+	 * sure it's updated when there's some activity (we don't care in idle).
+	 */
+	this_cpu_add(net_rand_state.s1, rol32(jiffies, 24) + user_tick);
 }
 
 /**
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -48,7 +48,7 @@ static inline void prandom_state_selftes
 }
 #endif
 
-static DEFINE_PER_CPU(struct rnd_state, net_rand_state) __latent_entropy;
+DEFINE_PER_CPU(struct rnd_state, net_rand_state) __latent_entropy;
 
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.


