Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1030551BD5
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347101AbiFTNkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348930AbiFTNj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5218B29C8F;
        Mon, 20 Jun 2022 06:14:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 685AF60C1A;
        Mon, 20 Jun 2022 13:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6038EC3411B;
        Mon, 20 Jun 2022 13:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730882;
        bh=04Pz+fF0w/7kWMaXUXaQSnSuQMtY6Y5I1iVKp9GXD5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=po4qyEmkriMo2g385Sm0cy7TUWnmVdmLmWex/5BOVm9bQF8HDSfKJmw44Rwux+0+O
         OFq/VBjUbI7eYMvgwD3U/bIejwl3YpyWarwUbyPrOgwqjzr95OLW3GwZUadp9xaDAs
         /iiz4RjLtvk0jrAVt7tmNo3TvBwRdEtAbQnHza5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 085/240] random: tie batched entropy generation to base_crng generation
Date:   Mon, 20 Jun 2022 14:49:46 +0200
Message-Id: <20220620124741.407728341@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
@@ -428,8 +428,6 @@ static DEFINE_PER_CPU(struct crng, crngs
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
-static void invalidate_batched_entropy(void);
-
 /*
  * crng_fast_load() can be called by code in the interrupt service
  * path.  So we can't afford to dilly-dally. Returns the number of
@@ -452,7 +450,7 @@ static size_t crng_fast_load(const void
 		src++; crng_init_cnt++; len--; ret++;
 	}
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
-		invalidate_batched_entropy();
+		++base_crng.generation;
 		crng_init = 1;
 	}
 	spin_unlock_irqrestore(&base_crng.lock, flags);
@@ -529,7 +527,6 @@ static void crng_reseed(void)
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
 	if (crng_init < 2) {
-		invalidate_batched_entropy();
 		crng_init = 2;
 		finalize_init = true;
 	}
@@ -1254,8 +1251,9 @@ int __init rand_initialize(void)
 	mix_pool_bytes(utsname(), sizeof(*(utsname())));
 
 	extract_entropy(base_crng.key, sizeof(base_crng.key));
+	++base_crng.generation;
+
 	if (arch_init && trust_cpu && crng_init < 2) {
-		invalidate_batched_entropy();
 		crng_init = 2;
 		pr_notice("crng init done (trusting CPU's manufacturer)\n");
 	}
@@ -1595,8 +1593,6 @@ struct ctl_table random_table[] = {
 };
 #endif	/* CONFIG_SYSCTL */
 
-static atomic_t batch_generation = ATOMIC_INIT(0);
-
 struct batched_entropy {
 	union {
 		/*
@@ -1609,8 +1605,8 @@ struct batched_entropy {
 		u64 entropy_u64[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
 		u32 entropy_u32[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
 	};
+	unsigned long generation;
 	unsigned int position;
-	int generation;
 };
 
 /*
@@ -1629,14 +1625,14 @@ u64 get_random_u64(void)
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
@@ -1662,14 +1658,14 @@ u32 get_random_u32(void)
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
@@ -1685,15 +1681,6 @@ u32 get_random_u32(void)
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


