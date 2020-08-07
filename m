Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D41823E8AD
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 10:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgHGIPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 04:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgHGIPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 04:15:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 839D4221E5;
        Fri,  7 Aug 2020 08:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596788121;
        bh=mSUNnUQw1zp1SRfb0o1xtLqTuy2gHbNKh0uaKWFAcCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1LumktAcOQ0tnQ+AMFYJRaHpJZpOirLI2AGE/NtPxI5W6JQC/9FoLn2v9kyywGeq
         DsklhWNuRu+r0JeQObcxSl6vsVuf7n1DjAksO+JvfCldF2M4wHMqvpJAatHLJxSIuj
         yr30OTTnoVhYLY9azho9gEzUXIkPds3c9WEtuLzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.138
Date:   Fri,  7 Aug 2020 10:15:26 +0200
Message-Id: <159678812525348@kroah.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <159678812524753@kroah.com>
References: <159678812524753@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index edf1799c08d2..daaa8ab2f550 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 137
+SUBLEVEL = 138
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
index a89b4076cde4..72821b4721ad 100644
--- a/arch/arm/include/asm/percpu.h
+++ b/arch/arm/include/asm/percpu.h
@@ -16,6 +16,8 @@
 #ifndef _ASM_ARM_PERCPU_H_
 #define _ASM_ARM_PERCPU_H_
 
+#include <asm/thread_info.h>
+
 /*
  * Same as asm-generic/percpu.h, except that we store the per cpu offset
  * in the TPIDRPRW. TPIDRPRW only exists on V6K and V7
diff --git a/drivers/char/random.c b/drivers/char/random.c
index d5f970d039bb..6a5d4dfafc47 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1257,6 +1257,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 
 	fast_mix(fast_pool);
 	add_interrupt_bench(cycles);
+	this_cpu_add(net_rand_state.s1, fast_pool->pool[cycles & 3]);
 
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3b1a7597af15..cd833f4e64ef 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3848,6 +3848,11 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 	struct inode *inode = mapping->host;
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
+	loff_t offset = iocb->ki_pos;
+	loff_t size = i_size_read(inode);
+
+	if (offset >= size)
+		return 0;
 
 	/*
 	 * Shared inode_lock is enough for us - it protects against concurrent
diff --git a/include/linux/prandom.h b/include/linux/prandom.h
new file mode 100644
index 000000000000..aa16e6468f91
--- /dev/null
+++ b/include/linux/prandom.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * include/linux/prandom.h
+ *
+ * Include file for the fast pseudo-random 32-bit
+ * generation.
+ */
+#ifndef _LINUX_PRANDOM_H
+#define _LINUX_PRANDOM_H
+
+#include <linux/types.h>
+#include <linux/percpu.h>
+
+u32 prandom_u32(void);
+void prandom_bytes(void *buf, size_t nbytes);
+void prandom_seed(u32 seed);
+void prandom_reseed_late(void);
+
+struct rnd_state {
+	__u32 s1, s2, s3, s4;
+};
+
+DECLARE_PER_CPU(struct rnd_state, net_rand_state);
+
+u32 prandom_u32_state(struct rnd_state *state);
+void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
+void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
+
+#define prandom_init_once(pcpu_state)			\
+	DO_ONCE(prandom_seed_full_state, (pcpu_state))
+
+/**
+ * prandom_u32_max - returns a pseudo-random number in interval [0, ep_ro)
+ * @ep_ro: right open interval endpoint
+ *
+ * Returns a pseudo-random number that is in interval [0, ep_ro). Note
+ * that the result depends on PRNG being well distributed in [0, ~0U]
+ * u32 space. Here we use maximally equidistributed combined Tausworthe
+ * generator, that is, prandom_u32(). This is useful when requesting a
+ * random index of an array containing ep_ro elements, for example.
+ *
+ * Returns: pseudo-random number in interval [0, ep_ro)
+ */
+static inline u32 prandom_u32_max(u32 ep_ro)
+{
+	return (u32)(((u64) prandom_u32() * ep_ro) >> 32);
+}
+
+/*
+ * Handle minimum values for seeds
+ */
+static inline u32 __seed(u32 x, u32 m)
+{
+	return (x < m) ? x + m : x;
+}
+
+/**
+ * prandom_seed_state - set seed for prandom_u32_state().
+ * @state: pointer to state structure to receive the seed.
+ * @seed: arbitrary 64-bit value to use as a seed.
+ */
+static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
+{
+	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
+
+	state->s1 = __seed(i,   2U);
+	state->s2 = __seed(i,   8U);
+	state->s3 = __seed(i,  16U);
+	state->s4 = __seed(i, 128U);
+}
+
+/* Pseudo random number generator from numerical recipes. */
+static inline u32 next_pseudo_random32(u32 seed)
+{
+	return seed * 1664525 + 1013904223;
+}
+
+#endif
diff --git a/include/linux/random.h b/include/linux/random.h
index 445a0ea4ff49..37209b3b22ae 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -106,61 +106,12 @@ declare_get_random_var_wait(long)
 
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
-u32 prandom_u32(void);
-void prandom_bytes(void *buf, size_t nbytes);
-void prandom_seed(u32 seed);
-void prandom_reseed_late(void);
-
-struct rnd_state {
-	__u32 s1, s2, s3, s4;
-};
-
-u32 prandom_u32_state(struct rnd_state *state);
-void prandom_bytes_state(struct rnd_state *state, void *buf, size_t nbytes);
-void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
-
-#define prandom_init_once(pcpu_state)			\
-	DO_ONCE(prandom_seed_full_state, (pcpu_state))
-
-/**
- * prandom_u32_max - returns a pseudo-random number in interval [0, ep_ro)
- * @ep_ro: right open interval endpoint
- *
- * Returns a pseudo-random number that is in interval [0, ep_ro). Note
- * that the result depends on PRNG being well distributed in [0, ~0U]
- * u32 space. Here we use maximally equidistributed combined Tausworthe
- * generator, that is, prandom_u32(). This is useful when requesting a
- * random index of an array containing ep_ro elements, for example.
- *
- * Returns: pseudo-random number in interval [0, ep_ro)
- */
-static inline u32 prandom_u32_max(u32 ep_ro)
-{
-	return (u32)(((u64) prandom_u32() * ep_ro) >> 32);
-}
-
 /*
- * Handle minimum values for seeds
+ * This is designed to be standalone for just prandom
+ * users, but for now we include it from <linux/random.h>
+ * for legacy reasons.
  */
-static inline u32 __seed(u32 x, u32 m)
-{
-	return (x < m) ? x + m : x;
-}
-
-/**
- * prandom_seed_state - set seed for prandom_u32_state().
- * @state: pointer to state structure to receive the seed.
- * @seed: arbitrary 64-bit value to use as a seed.
- */
-static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
-{
-	u32 i = (seed >> 32) ^ (seed << 10) ^ seed;
-
-	state->s1 = __seed(i,   2U);
-	state->s2 = __seed(i,   8U);
-	state->s3 = __seed(i,  16U);
-	state->s4 = __seed(i, 128U);
-}
+#include <linux/prandom.h>
 
 #ifdef CONFIG_ARCH_RANDOM
 # include <asm/archrandom.h>
@@ -191,10 +142,4 @@ static inline bool arch_has_random_seed(void)
 }
 #endif
 
-/* Pseudo random number generator from numerical recipes. */
-static inline u32 next_pseudo_random32(u32 seed)
-{
-	return seed * 1664525 + 1013904223;
-}
-
 #endif /* _LINUX_RANDOM_H */
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 6c54cf481fde..61e41ea3a96e 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/sched/debug.h>
 #include <linux/slab.h>
 #include <linux/compat.h>
+#include <linux/random.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -1654,6 +1655,13 @@ void update_process_times(int user_tick)
 	scheduler_tick();
 	if (IS_ENABLED(CONFIG_POSIX_TIMERS))
 		run_posix_cpu_timers(p);
+
+	/* The current CPU might make use of net randoms without receiving IRQs
+	 * to renew them often enough. Let's update the net_rand_state from a
+	 * non-constant value that's not affine to the number of calls to make
+	 * sure it's updated when there's some activity (we don't care in idle).
+	 */
+	this_cpu_add(net_rand_state.s1, rol32(jiffies, 24) + user_tick);
 }
 
 /**
diff --git a/lib/random32.c b/lib/random32.c
index 4aaa76404d56..036de0c93e22 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -48,7 +48,7 @@ static inline void prandom_state_selftest(void)
 }
 #endif
 
-static DEFINE_PER_CPU(struct rnd_state, net_rand_state) __latent_entropy;
+DEFINE_PER_CPU(struct rnd_state, net_rand_state);
 
 /**
  *	prandom_u32_state - seeded pseudo-random number generator.
