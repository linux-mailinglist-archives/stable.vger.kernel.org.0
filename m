Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769C523D223
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgHEUJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgHEQce (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:32:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC79C23381;
        Wed,  5 Aug 2020 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642771;
        bh=9eqeHaXXxvNSQcYF6qWdkE1vtAU2WTfRrddMU2qDtjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZndgFwHuat+CaNMAnBsa+RGffR/GphHwk+MC6oj75/3fIsz4vaO7CZ8BzEgzZJrRq
         5gb/fxdDMIz3gjLDOMm2ArbrV3icXcPVqiBLqur0cwNH/DOKRaQWxqddZLpnFVCvN/
         3/hGH+wjOsRBz6Bp9+tY8UYT/qWldL5vxulRGujQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 5/9] random32: move the pseudo-random 32-bit definitions to prandom.h
Date:   Wed,  5 Aug 2020 17:52:42 +0200
Message-Id: <20200805153507.308201463@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805153507.053638231@linuxfoundation.org>
References: <20200805153507.053638231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit c0842fbc1b18c7a044e6ff3e8fa78bfa822c7d1a upstream.

The addition of percpu.h to the list of includes in random.h revealed
some circular dependencies on arm64 and possibly other platforms.  This
include was added solely for the pseudo-random definitions, which have
nothing to do with the rest of the definitions in this file but are
still there for legacy reasons.

This patch moves the pseudo-random parts to linux/prandom.h and the
percpu.h include with it, which is now guarded by _LINUX_PRANDOM_H and
protected against recursive inclusion.

A further cleanup step would be to remove this from <linux/random.h>
entirely, and make people who use the prandom infrastructure include
just the new header file.  That's a bit of a churn patch, but grepping
for "prandom_" and "next_pseudo_random32" "struct rnd_state" should
catch most users.

But it turns out that that nice cleanup step is fairly painful, because
a _lot_ of code currently seems to depend on the implicit include of
<linux/random.h>, which can currently come in a lot of ways, including
such fairly core headfers as <linux/net.h>.

So the "nice cleanup" part may or may never happen.

Fixes: 1c9df907da83 ("random: fix circular include dependency on arm64 after addition of percpu.h")
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/prandom.h |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h  |   66 ++--------------------------------------
 2 files changed, 82 insertions(+), 62 deletions(-)

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
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -9,7 +9,6 @@
 
 #include <linux/list.h>
 #include <linux/once.h>
-#include <asm/percpu.h>
 
 #include <uapi/linux/random.h>
 
@@ -109,63 +108,12 @@ declare_get_random_var_wait(long)
 
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
-DECLARE_PER_CPU(struct rnd_state, net_rand_state);
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
- */
-static inline u32 __seed(u32 x, u32 m)
-{
-	return (x < m) ? x + m : x;
-}
-
-/**
- * prandom_seed_state - set seed for prandom_u32_state().
- * @state: pointer to state structure to receive the seed.
- * @seed: arbitrary 64-bit value to use as a seed.
+ * This is designed to be standalone for just prandom
+ * users, but for now we include it from <linux/random.h>
+ * for legacy reasons.
  */
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
@@ -196,10 +144,4 @@ static inline bool arch_has_random_seed(
 }
 #endif
 
-/* Pseudo random number generator from numerical recipes. */
-static inline u32 next_pseudo_random32(u32 seed)
-{
-	return seed * 1664525 + 1013904223;
-}
-
 #endif /* _LINUX_RANDOM_H */


