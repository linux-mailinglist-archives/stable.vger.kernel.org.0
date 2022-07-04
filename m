Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC655565239
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 12:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiGDK0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 06:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiGDKZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 06:25:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CC611465
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 03:24:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D258B80E89
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 10:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49224C3411E;
        Mon,  4 Jul 2022 10:24:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TJRM4YgS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656930260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2DAF4fRKflJ2NNxtdn7vyy+7AgpaIrxqBbqn/M/hAM0=;
        b=TJRM4YgS/L+AkPp/mqAVhlYXA06Xq7YkdsTXk5MfRe7HFrNYKmKhquvOyHspfb2YXwjBnt
        GP1GZJ4T6q44lABd+doDdELO3juHOUlFvGA0d3UHlZtPD/gX34UCGWO7qFtVrwb3kU1RMl
        I4XfHB48I2L2HPE4cMqKZSQMXEIjgVI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5a577380 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 4 Jul 2022 10:24:20 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Ingo Franzki <ifranzki@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH stable 5.4 4.19] s390/archrandom: simplify back to earlier design and initialize earlier
Date:   Mon,  4 Jul 2022 12:24:16 +0200
Message-Id: <20220704102416.326257-1-Jason@zx2c4.com>
In-Reply-To: <16569202321345@kroah.com>
References: <16569202321345@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e4f74400308cb8abde5fdc9cad609c2aba32110c upstream.

s390x appears to present two RNG interfaces:
- a "TRNG" that gathers entropy using some hardware function; and
- a "DRBG" that takes in a seed and expands it.

Previously, the TRNG was wired up to arch_get_random_{long,int}(), but
it was observed that this was being called really frequently, resulting
in high overhead. So it was changed to be wired up to arch_get_random_
seed_{long,int}(), which was a reasonable decision. Later on, the DRBG
was then wired up to arch_get_random_{long,int}(), with a complicated
buffer filling thread, to control overhead and rate.

Fortunately, none of the performance issues matter much now. The RNG
always attempts to use arch_get_random_seed_{long,int}() first, which
means a complicated implementation of arch_get_random_{long,int}() isn't
really valuable or useful to have around. And it's only used when
reseeding, which means it won't hit the high throughput complications
that were faced before.

So this commit returns to an earlier design of just calling the TRNG in
arch_get_random_seed_{long,int}(), and returning false in arch_get_
random_{long,int}().

Part of what makes the simplification possible is that the RNG now seeds
itself using the TRNG at bootup. But this only works if the TRNG is
detected early in boot, before random_init() is called. So this commit
also causes that check to happen in setup_arch().

Cc: stable@vger.kernel.org
Cc: Harald Freudenberger <freude@linux.ibm.com>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Juergen Christ <jchrist@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20220610222023.378448-1-Jason@zx2c4.com
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/s390/crypto/arch_random.c     | 111 +----------------------------
 arch/s390/include/asm/archrandom.h |  21 +++---
 arch/s390/kernel/setup.c           |   5 ++
 3 files changed, 18 insertions(+), 119 deletions(-)

diff --git a/arch/s390/crypto/arch_random.c b/arch/s390/crypto/arch_random.c
index 4cbb4b6d85a8..1f2d40993c4d 100644
--- a/arch/s390/crypto/arch_random.c
+++ b/arch/s390/crypto/arch_random.c
@@ -2,126 +2,17 @@
 /*
  * s390 arch random implementation.
  *
- * Copyright IBM Corp. 2017, 2018
+ * Copyright IBM Corp. 2017, 2020
  * Author(s): Harald Freudenberger
- *
- * The s390_arch_random_generate() function may be called from random.c
- * in interrupt context. So this implementation does the best to be very
- * fast. There is a buffer of random data which is asynchronously checked
- * and filled by a workqueue thread.
- * If there are enough bytes in the buffer the s390_arch_random_generate()
- * just delivers these bytes. Otherwise false is returned until the
- * worker thread refills the buffer.
- * The worker fills the rng buffer by pulling fresh entropy from the
- * high quality (but slow) true hardware random generator. This entropy
- * is then spread over the buffer with an pseudo random generator PRNG.
- * As the arch_get_random_seed_long() fetches 8 bytes and the calling
- * function add_interrupt_randomness() counts this as 1 bit entropy the
- * distribution needs to make sure there is in fact 1 bit entropy contained
- * in 8 bytes of the buffer. The current values pull 32 byte entropy
- * and scatter this into a 2048 byte buffer. So 8 byte in the buffer
- * will contain 1 bit of entropy.
- * The worker thread is rescheduled based on the charge level of the
- * buffer but at least with 500 ms delay to avoid too much CPU consumption.
- * So the max. amount of rng data delivered via arch_get_random_seed is
- * limited to 4k bytes per second.
  */
 
 #include <linux/kernel.h>
 #include <linux/atomic.h>
 #include <linux/random.h>
-#include <linux/slab.h>
 #include <linux/static_key.h>
-#include <linux/workqueue.h>
 #include <asm/cpacf.h>
 
 DEFINE_STATIC_KEY_FALSE(s390_arch_random_available);
 
 atomic64_t s390_arch_random_counter = ATOMIC64_INIT(0);
 EXPORT_SYMBOL(s390_arch_random_counter);
-
-#define ARCH_REFILL_TICKS (HZ/2)
-#define ARCH_PRNG_SEED_SIZE 32
-#define ARCH_RNG_BUF_SIZE 2048
-
-static DEFINE_SPINLOCK(arch_rng_lock);
-static u8 *arch_rng_buf;
-static unsigned int arch_rng_buf_idx;
-
-static void arch_rng_refill_buffer(struct work_struct *);
-static DECLARE_DELAYED_WORK(arch_rng_work, arch_rng_refill_buffer);
-
-bool s390_arch_random_generate(u8 *buf, unsigned int nbytes)
-{
-	/* max hunk is ARCH_RNG_BUF_SIZE */
-	if (nbytes > ARCH_RNG_BUF_SIZE)
-		return false;
-
-	/* lock rng buffer */
-	if (!spin_trylock(&arch_rng_lock))
-		return false;
-
-	/* try to resolve the requested amount of bytes from the buffer */
-	arch_rng_buf_idx -= nbytes;
-	if (arch_rng_buf_idx < ARCH_RNG_BUF_SIZE) {
-		memcpy(buf, arch_rng_buf + arch_rng_buf_idx, nbytes);
-		atomic64_add(nbytes, &s390_arch_random_counter);
-		spin_unlock(&arch_rng_lock);
-		return true;
-	}
-
-	/* not enough bytes in rng buffer, refill is done asynchronously */
-	spin_unlock(&arch_rng_lock);
-
-	return false;
-}
-EXPORT_SYMBOL(s390_arch_random_generate);
-
-static void arch_rng_refill_buffer(struct work_struct *unused)
-{
-	unsigned int delay = ARCH_REFILL_TICKS;
-
-	spin_lock(&arch_rng_lock);
-	if (arch_rng_buf_idx > ARCH_RNG_BUF_SIZE) {
-		/* buffer is exhausted and needs refill */
-		u8 seed[ARCH_PRNG_SEED_SIZE];
-		u8 prng_wa[240];
-		/* fetch ARCH_PRNG_SEED_SIZE bytes of entropy */
-		cpacf_trng(NULL, 0, seed, sizeof(seed));
-		/* blow this entropy up to ARCH_RNG_BUF_SIZE with PRNG */
-		memset(prng_wa, 0, sizeof(prng_wa));
-		cpacf_prno(CPACF_PRNO_SHA512_DRNG_SEED,
-			   &prng_wa, NULL, 0, seed, sizeof(seed));
-		cpacf_prno(CPACF_PRNO_SHA512_DRNG_GEN,
-			   &prng_wa, arch_rng_buf, ARCH_RNG_BUF_SIZE, NULL, 0);
-		arch_rng_buf_idx = ARCH_RNG_BUF_SIZE;
-	}
-	delay += (ARCH_REFILL_TICKS * arch_rng_buf_idx) / ARCH_RNG_BUF_SIZE;
-	spin_unlock(&arch_rng_lock);
-
-	/* kick next check */
-	queue_delayed_work(system_long_wq, &arch_rng_work, delay);
-}
-
-static int __init s390_arch_random_init(void)
-{
-	/* all the needed PRNO subfunctions available ? */
-	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG) &&
-	    cpacf_query_func(CPACF_PRNO, CPACF_PRNO_SHA512_DRNG_GEN)) {
-
-		/* alloc arch random working buffer */
-		arch_rng_buf = kmalloc(ARCH_RNG_BUF_SIZE, GFP_KERNEL);
-		if (!arch_rng_buf)
-			return -ENOMEM;
-
-		/* kick worker queue job to fill the random buffer */
-		queue_delayed_work(system_long_wq,
-				   &arch_rng_work, ARCH_REFILL_TICKS);
-
-		/* enable arch random to the outside world */
-		static_branch_enable(&s390_arch_random_available);
-	}
-
-	return 0;
-}
-arch_initcall(s390_arch_random_init);
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index 9a6835137a16..2c6e1c6ecbe7 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -2,7 +2,7 @@
 /*
  * Kernel interface for the s390 arch_random_* functions
  *
- * Copyright IBM Corp. 2017
+ * Copyright IBM Corp. 2017, 2020
  *
  * Author: Harald Freudenberger <freude@de.ibm.com>
  *
@@ -15,34 +15,37 @@
 
 #include <linux/static_key.h>
 #include <linux/atomic.h>
+#include <asm/cpacf.h>
 
 DECLARE_STATIC_KEY_FALSE(s390_arch_random_available);
 extern atomic64_t s390_arch_random_counter;
 
-bool s390_arch_random_generate(u8 *buf, unsigned int nbytes);
-
-static inline bool arch_get_random_long(unsigned long *v)
+static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
 	return false;
 }
 
-static inline bool arch_get_random_int(unsigned int *v)
+static inline bool __must_check arch_get_random_int(unsigned int *v)
 {
 	return false;
 }
 
-static inline bool arch_get_random_seed_long(unsigned long *v)
+static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
 	if (static_branch_likely(&s390_arch_random_available)) {
-		return s390_arch_random_generate((u8 *)v, sizeof(*v));
+		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
+		atomic64_add(sizeof(*v), &s390_arch_random_counter);
+		return true;
 	}
 	return false;
 }
 
-static inline bool arch_get_random_seed_int(unsigned int *v)
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
 	if (static_branch_likely(&s390_arch_random_available)) {
-		return s390_arch_random_generate((u8 *)v, sizeof(*v));
+		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
+		atomic64_add(sizeof(*v), &s390_arch_random_counter);
+		return true;
 	}
 	return false;
 }
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 9a0316a067a1..dbc2a718d232 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1005,6 +1005,11 @@ static void __init setup_randomness(void)
 	if (stsi(vmms, 3, 2, 2) == 0 && vmms->count)
 		add_device_randomness(&vmms->vm, sizeof(vmms->vm[0]) * vmms->count);
 	memblock_free((unsigned long) vmms, PAGE_SIZE);
+
+#ifdef CONFIG_ARCH_RANDOM
+	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG))
+		static_branch_enable(&s390_arch_random_available);
+#endif
 }
 
 /*
-- 
2.35.1

