Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA2E5EAD75
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiIZRCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiIZRB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:01:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA1F719A5;
        Mon, 26 Sep 2022 09:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BA3160F5D;
        Mon, 26 Sep 2022 16:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017D2C433C1;
        Mon, 26 Sep 2022 16:03:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jRwrglaR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664208228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yC+mB8++NWbTwnc+d81VMyIZBYjffDEwBYgx9F3GGyE=;
        b=jRwrglaRu5ykOLvLE4Xq5zQryp+KcB8K2Qp26r+DDqUwVf/bAE2ntajHWYKSg7qAMxxJhR
        jEpCyduA9O5dsEVC18tn/7kg/Bq7mtd9WITm650SygWJpeUkRnILRMvP4NuSDRXYDRSFhU
        3KCcg33Tjgv2Y0qJGnnDy0hYF/4nmjw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 579c2f2c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 26 Sep 2022 16:03:48 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] random: split initialization into early arch step and later non-arch step
Date:   Mon, 26 Sep 2022 18:03:32 +0200
Message-Id: <20220926160332.1473462-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The full RNG initialization relies on some timestamps, made possible
with general functions like time_init() and timekeeping_init(). However,
these are only available rather late in initialization. Meanwhile, other
things, such as memory allocator functions, make use of the RNG much
earlier.

So split RNG initialization into two phases. We can give arch randomness
very early on, and then later, after timekeeping and such are available,
initialize the rest.

This ensures that, for example, slabs are properly randomized if RDRAND
is available. Another positive consequence is that on systems with
RDRAND, running with CONFIG_WARN_ALL_UNSEEDED_RANDOM=y results in no
warnings at all.

Cc: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
I intend to take this through the random.git tree, but reviews/acks
would be appreciated, given that I'm touching init/main.c.

 drivers/char/random.c  | 47 ++++++++++++++++++++++++------------------
 include/linux/random.h |  3 ++-
 init/main.c            | 17 +++++++--------
 3 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a90d96f4b3bb..1cb53495e8f7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -772,18 +772,13 @@ static int random_pm_notification(struct notifier_block *nb, unsigned long actio
 static struct notifier_block pm_notifier = { .notifier_call = random_pm_notification };
 
 /*
- * The first collection of entropy occurs at system boot while interrupts
- * are still turned off. Here we push in latent entropy, RDSEED, a timestamp,
- * utsname(), and the command line. Depending on the above configuration knob,
- * RDSEED may be considered sufficient for initialization. Note that much
- * earlier setup may already have pushed entropy into the input pool by the
- * time we get here.
+ * This is called extremely early, before time keeping functionality is
+ * available, but arch randomness is. Interrupts are not yet enabled.
  */
-int __init random_init(const char *command_line)
+void __init random_init_early(const char *command_line)
 {
-	ktime_t now = ktime_get_real();
-	size_t i, longs, arch_bits;
 	unsigned long entropy[BLAKE2S_BLOCK_SIZE / sizeof(long)];
+	size_t i, longs, arch_bits;
 
 #if defined(LATENT_ENTROPY_PLUGIN)
 	static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
@@ -803,34 +798,46 @@ int __init random_init(const char *command_line)
 			i += longs;
 			continue;
 		}
-		entropy[0] = random_get_entropy();
-		_mix_pool_bytes(entropy, sizeof(*entropy));
 		arch_bits -= sizeof(*entropy) * 8;
 		++i;
 	}
-	_mix_pool_bytes(&now, sizeof(now));
-	_mix_pool_bytes(utsname(), sizeof(*(utsname())));
+
 	_mix_pool_bytes(command_line, strlen(command_line));
+
+	if (trust_cpu)
+		credit_init_bits(arch_bits);
+}
+
+/*
+ * This is called a little bit after the prior function, and now there is
+ * access to timestamps counters. Interrupts are not yet enabled.
+ */
+void __init random_init(void)
+{
+	unsigned long entropy = random_get_entropy();
+	ktime_t now = ktime_get_real();
+
+	_mix_pool_bytes(utsname(), sizeof(*(utsname())));
+	_mix_pool_bytes(&now, sizeof(now));
+	_mix_pool_bytes(&entropy, sizeof(entropy));
 	add_latent_entropy();
 
 	/*
-	 * If we were initialized by the bootloader before jump labels are
-	 * initialized, then we should enable the static branch here, where
+	 * If we were initialized by the cpu or bootloader before jump labels
+	 * are initialized, then we should enable the static branch here, where
 	 * it's guaranteed that jump labels have been initialized.
 	 */
 	if (!static_branch_likely(&crng_is_ready) && crng_init >= CRNG_READY)
 		crng_set_ready(NULL);
 
+	/* Reseed if already seeded by earlier phases. */
 	if (crng_ready())
 		crng_reseed();
-	else if (trust_cpu)
-		_credit_init_bits(arch_bits);
 
 	WARN_ON(register_pm_notifier(&pm_notifier));
 
-	WARN(!random_get_entropy(), "Missing cycle counter and fallback timer; RNG "
-				    "entropy collection will consequently suffer.");
-	return 0;
+	WARN(!entropy, "Missing cycle counter and fallback timer; RNG "
+		       "entropy collection will consequently suffer.");
 }
 
 /*
diff --git a/include/linux/random.h b/include/linux/random.h
index 3fec206487f6..a9e6e16f9774 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -72,7 +72,8 @@ static inline unsigned long get_random_canary(void)
 	return get_random_long() & CANARY_MASK;
 }
 
-int __init random_init(const char *command_line);
+void __init random_init_early(const char *command_line);
+void __init random_init(void);
 bool rng_is_initialized(void);
 int wait_for_random_bytes(void);
 
diff --git a/init/main.c b/init/main.c
index 1fe7942f5d4a..611886430e28 100644
--- a/init/main.c
+++ b/init/main.c
@@ -976,6 +976,9 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 		parse_args("Setting extra init args", extra_init_args,
 			   NULL, 0, -1, -1, NULL, set_init_arg);
 
+	/* Call before any memory or allocators are initialized */
+	random_init_early(command_line);
+
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
@@ -1035,17 +1038,13 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	hrtimers_init();
 	softirq_init();
 	timekeeping_init();
-	kfence_init();
 	time_init();
 
-	/*
-	 * For best initial stack canary entropy, prepare it after:
-	 * - setup_arch() for any UEFI RNG entropy and boot cmdline access
-	 * - timekeeping_init() for ktime entropy used in random_init()
-	 * - time_init() for making random_get_entropy() work on some platforms
-	 * - random_init() to initialize the RNG from from early entropy sources
-	 */
-	random_init(command_line);
+	/* This must be after timekeeping is initialized */
+	random_init();
+
+	/* These make use of the initialized randomness */
+	kfence_init();
 	boot_init_stack_canary();
 
 	perf_event_init();
-- 
2.37.3

