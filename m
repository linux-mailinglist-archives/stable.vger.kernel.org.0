Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A1A53607F
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiE0LwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352798AbiE0Lux (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260FF1157DC;
        Fri, 27 May 2022 04:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6EF761D5C;
        Fri, 27 May 2022 11:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B99C385A9;
        Fri, 27 May 2022 11:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651928;
        bh=juTMfNnHEkEI/4BATlKimk/kcIE2Ppl9SYmbPPmO7cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnKR8p7h/hT9fQQ6j1LPd5EyK50mCq3TnL1D0naK0zfJ0mHNIYBM50g/VUwkYRYGV
         wPW3WE7rQgzuCEUjhYS6BFFpKAub2zKbbTlfJYoU8gV5UoJr8GNCQ9ECtLvXQTVHMg
         LYzGigc0rs1kEz3SG6oUPDWLnqloUHAb3bP/pg2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 058/145] random: tie batched entropy generation to base_crng generation
Date:   Fri, 27 May 2022 10:49:19 +0200
Message-Id: <20220527084857.700085331@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084850.364560116@linuxfoundation.org>
References: <20220527084850.364560116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 0791e8b655cc373718f0f58800fdc625a3447ac5 upstream.

Now that we have an explicit base_crng generation counter, we don't need
a separate one for batched entropy. Rather, we can just move the
generation forward every time we change crng_init state or update the
base_crng key.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -430,8 +430,6 @@ static DEFINE_PER_CPU(struct crng, crngs
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
-static void invalidate_batched_entropy(void);
-
 /*
  * crng_fast_load() can be called by code in the interrupt service
  * path.  So we can't afford to dilly-dally. Returns the number of
@@ -454,7 +452,7 @@ static size_t crng_fast_load(const void
 		src++; crng_init_cnt++; len--; ret++;
 	}
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
-		invalidate_batched_entropy();
+		++base_crng.generation;
 		crng_init = 1;
 	}
 	spin_unlock_irqrestore(&base_crng.lock, flags);
@@ -531,7 +529,6 @@ static void crng_reseed(void)
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
 	if (crng_init < 2) {
-		invalidate_batched_entropy();
 		crng_init = 2;
 		finalize_init = true;
 	}
@@ -1256,8 +1253,9 @@ int __init rand_initialize(void)
 	mix_pool_bytes(utsname(), sizeof(*(utsname())));
 
 	extract_entropy(base_crng.key, sizeof(base_crng.key));
+	++base_crng.generation;
+
 	if (arch_init && trust_cpu && crng_init < 2) {
-		invalidate_batched_entropy();
 		crng_init = 2;
 		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
@@ -1597,8 +1595,6 @@ struct ctl_table random_table[] = {
 };
 #endif	/* CONFIG_SYSCTL */
 
-static atomic_t batch_generation = ATOMIC_INIT(0);
-
 struct batched_entropy {
 	union {
 		/*
@@ -1612,8 +1608,8 @@ struct batched_entropy {
 		u32 entropy_u32[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
 	};
 	local_lock_t lock;
+	unsigned long generation;
 	unsigned int position;
-	int generation;
 };
 
 /*
@@ -1633,14 +1629,14 @@ u64 get_random_u64(void)
 	unsigned long flags;
 	struct batched_entropy *batch;
 	static void *previous;
-	int next_gen;
+	unsigned long next_gen;
 
 	warn_unseeded_randomness(&previous);
 
 	local_lock_irqsave(&batched_entropy_u64.lock, flags);
 	batch = raw_cpu_ptr(&batched_entropy_u64);
 
-	next_gen = atomic_read(&batch_generation);
+	next_gen = READ_ONCE(base_crng.generation);
 	if (batch->position >= ARRAY_SIZE(batch->entropy_u64) ||
 	    next_gen != batch->generation) {
 		_get_random_bytes(batch->entropy_u64, sizeof(batch->entropy_u64));
@@ -1667,14 +1663,14 @@ u32 get_random_u32(void)
 	unsigned long flags;
 	struct batched_entropy *batch;
 	static void *previous;
-	int next_gen;
+	unsigned long next_gen;
 
 	warn_unseeded_randomness(&previous);
 
 	local_lock_irqsave(&batched_entropy_u32.lock, flags);
 	batch = raw_cpu_ptr(&batched_entropy_u32);
 
-	next_gen = atomic_read(&batch_generation);
+	next_gen = READ_ONCE(base_crng.generation);
 	if (batch->position >= ARRAY_SIZE(batch->entropy_u32) ||
 	    next_gen != batch->generation) {
 		_get_random_bytes(batch->entropy_u32, sizeof(batch->entropy_u32));
@@ -1690,15 +1686,6 @@ u32 get_random_u32(void)
 }
 EXPORT_SYMBOL(get_random_u32);
 
-/* It's important to invalidate all potential batched entropy that might
- * be stored before the crng is initialized, which we can do lazily by
- * bumping the generation counter.
- */
-static void invalidate_batched_entropy(void)
-{
-	atomic_inc(&batch_generation);
-}
-
 /**
  * randomize_page - Generate a random, page aligned address
  * @start:	The smallest acceptable address the caller will take.


