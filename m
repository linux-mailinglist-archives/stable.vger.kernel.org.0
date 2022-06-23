Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10089558186
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiFWRBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbiFWRAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BA14F9CA;
        Thu, 23 Jun 2022 09:54:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C98AA61F80;
        Thu, 23 Jun 2022 16:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93864C3411B;
        Thu, 23 Jun 2022 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003245;
        bh=elflPlYwKE7nTCd7Ln5N++pZUgjYlD0Ex/p7ej7GlbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sM9s+Dl3PP99yDKGMnoLTdPgLmK3UV5AN1eBHUvRXQxwUjluXIiwM+X9RykDutlFC
         GLLCENENwOavbwAoFuZ5Sog76wWgEBNsi9x2VXnvXY7Noi4IbbcWXyKQSymoTBIa2+
         +6MJzs+kRe6BTOagiue9Q7dfTrIiq1biqRT9dFk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 126/264] random: tie batched entropy generation to base_crng generation
Date:   Thu, 23 Jun 2022 18:41:59 +0200
Message-Id: <20220623164347.632181959@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -429,8 +429,6 @@ static DEFINE_PER_CPU(struct crng, crngs
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
-static void invalidate_batched_entropy(void);
-
 /*
  * crng_fast_load() can be called by code in the interrupt service
  * path.  So we can't afford to dilly-dally. Returns the number of
@@ -453,7 +451,7 @@ static size_t crng_fast_load(const void
 		src++; crng_init_cnt++; len--; ret++;
 	}
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
-		invalidate_batched_entropy();
+		++base_crng.generation;
 		crng_init = 1;
 	}
 	spin_unlock_irqrestore(&base_crng.lock, flags);
@@ -581,7 +579,6 @@ static void crng_reseed(void)
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
 	if (crng_init < 2) {
-		invalidate_batched_entropy();
 		crng_init = 2;
 		finalize_init = true;
 	}
@@ -1306,8 +1303,9 @@ int __init rand_initialize(void)
 	mix_pool_bytes(utsname(), sizeof(*(utsname())));
 
 	extract_entropy(base_crng.key, sizeof(base_crng.key));
+	++base_crng.generation;
+
 	if (arch_init && trust_cpu && crng_init < 2) {
-		invalidate_batched_entropy();
 		crng_init = 2;
 		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
@@ -1645,8 +1643,6 @@ struct ctl_table random_table[] = {
 };
 #endif	/* CONFIG_SYSCTL */
 
-static atomic_t batch_generation = ATOMIC_INIT(0);
-
 struct batched_entropy {
 	union {
 		/*
@@ -1659,8 +1655,8 @@ struct batched_entropy {
 		u64 entropy_u64[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
 		u32 entropy_u32[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
 	};
+	unsigned long generation;
 	unsigned int position;
-	int generation;
 };
 
 /*
@@ -1679,14 +1675,14 @@ u64 get_random_u64(void)
 	unsigned long flags;
 	struct batched_entropy *batch;
 	static void *previous;
-	int next_gen;
+	unsigned long next_gen;
 
 	warn_unseeded_randomness(&previous);
 
 	local_irq_save(flags);
 	batch = raw_cpu_ptr(&batched_entropy_u64);
 
-	next_gen = atomic_read(&batch_generation);
+	next_gen = READ_ONCE(base_crng.generation);
 	if (batch->position >= ARRAY_SIZE(batch->entropy_u64) ||
 	    next_gen != batch->generation) {
 		_get_random_bytes(batch->entropy_u64, sizeof(batch->entropy_u64));
@@ -1712,14 +1708,14 @@ u32 get_random_u32(void)
 	unsigned long flags;
 	struct batched_entropy *batch;
 	static void *previous;
-	int next_gen;
+	unsigned long next_gen;
 
 	warn_unseeded_randomness(&previous);
 
 	local_irq_save(flags);
 	batch = raw_cpu_ptr(&batched_entropy_u32);
 
-	next_gen = atomic_read(&batch_generation);
+	next_gen = READ_ONCE(base_crng.generation);
 	if (batch->position >= ARRAY_SIZE(batch->entropy_u32) ||
 	    next_gen != batch->generation) {
 		_get_random_bytes(batch->entropy_u32, sizeof(batch->entropy_u32));
@@ -1735,15 +1731,6 @@ u32 get_random_u32(void)
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


