Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EAC551CA6
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347424AbiFTNo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347578AbiFTNnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:43:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149212B1A3;
        Mon, 20 Jun 2022 06:15:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61272B811BF;
        Mon, 20 Jun 2022 13:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A6AC3411B;
        Mon, 20 Jun 2022 13:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730918;
        bh=czisw9s9rd7774SpqVctDxyPwpD9v2mswm6ClPlHMQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cjh9IeH/VNJa2WqLK8xM3H2uYyJZ+WF/oKGGUMMYyPIX81DD6wmPc1n3Uxl7cnFl9
         wynsEocM1dXkTc5Ww9rXx0ZXAUEJfAy2A2JvryKEqIcvcMwOe5Ks7xXhs18lgcclGE
         yseHQRFRxsjMzgbkITyPpVHya2+mdBsf87AX9BdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 095/240] random: group entropy extraction functions
Date:   Mon, 20 Jun 2022 14:49:56 +0200
Message-Id: <20220620124741.766916464@linuxfoundation.org>
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

commit a5ed7cb1a7732ef11959332d507889fbc39ebbb4 upstream.

This pulls all of the entropy extraction-focused functions into the
third labeled section.

No functional changes.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  216 +++++++++++++++++++++++++-------------------------
 1 file changed, 109 insertions(+), 107 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -890,23 +890,36 @@ size_t __must_check get_random_bytes_arc
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
+
+/**********************************************************************
+ *
+ * Entropy accumulation and extraction routines.
+ *
+ * Callers may add entropy via:
+ *
+ *     static void mix_pool_bytes(const void *in, size_t nbytes)
+ *
+ * After which, if added entropy should be credited:
+ *
+ *     static void credit_entropy_bits(size_t nbits)
+ *
+ * Finally, extract entropy via these two, with the latter one
+ * setting the entropy count to zero and extracting only if there
+ * is POOL_MIN_BITS entropy credited prior:
+ *
+ *     static void extract_entropy(void *buf, size_t nbytes)
+ *     static bool drain_entropy(void *buf, size_t nbytes)
+ *
+ **********************************************************************/
+
 enum {
 	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
 	POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
 };
 
-/*
- * Static global variables
- */
+/* For notifying userspace should write into /dev/random. */
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 
-/**********************************************************************
- *
- * OS independent entropy store.   Here are the functions which handle
- * storing entropy in an entropy pool.
- *
- **********************************************************************/
-
 static struct {
 	struct blake2s_state hash;
 	spinlock_t lock;
@@ -919,28 +932,106 @@ static struct {
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
 };
 
-static void extract_entropy(void *buf, size_t nbytes);
-static bool drain_entropy(void *buf, size_t nbytes);
-
-static void crng_reseed(void);
+static void _mix_pool_bytes(const void *in, size_t nbytes)
+{
+	blake2s_update(&input_pool.hash, in, nbytes);
+}
 
 /*
  * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
  * credit_entropy_bits if this is appropriate.
  */
-static void _mix_pool_bytes(const void *in, size_t nbytes)
+static void mix_pool_bytes(const void *in, size_t nbytes)
 {
-	blake2s_update(&input_pool.hash, in, nbytes);
+	unsigned long flags;
+
+	spin_lock_irqsave(&input_pool.lock, flags);
+	_mix_pool_bytes(in, nbytes);
+	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
 
-static void mix_pool_bytes(const void *in, size_t nbytes)
+static void credit_entropy_bits(size_t nbits)
+{
+	unsigned int entropy_count, orig, add;
+
+	if (!nbits)
+		return;
+
+	add = min_t(size_t, nbits, POOL_BITS);
+
+	do {
+		orig = READ_ONCE(input_pool.entropy_count);
+		entropy_count = min_t(unsigned int, POOL_BITS, orig + add);
+	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
+
+	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
+		crng_reseed();
+}
+
+/*
+ * This is an HKDF-like construction for using the hashed collected entropy
+ * as a PRF key, that's then expanded block-by-block.
+ */
+static void extract_entropy(void *buf, size_t nbytes)
 {
 	unsigned long flags;
+	u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
+	struct {
+		unsigned long rdseed[32 / sizeof(long)];
+		size_t counter;
+	} block;
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(block.rdseed); ++i) {
+		if (!arch_get_random_seed_long(&block.rdseed[i]) &&
+		    !arch_get_random_long(&block.rdseed[i]))
+			block.rdseed[i] = random_get_entropy();
+	}
 
 	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(in, nbytes);
+
+	/* seed = HASHPRF(last_key, entropy_input) */
+	blake2s_final(&input_pool.hash, seed);
+
+	/* next_key = HASHPRF(seed, RDSEED || 0) */
+	block.counter = 0;
+	blake2s(next_key, (u8 *)&block, seed, sizeof(next_key), sizeof(block), sizeof(seed));
+	blake2s_init_key(&input_pool.hash, BLAKE2S_HASH_SIZE, next_key, sizeof(next_key));
+
 	spin_unlock_irqrestore(&input_pool.lock, flags);
+	memzero_explicit(next_key, sizeof(next_key));
+
+	while (nbytes) {
+		i = min_t(size_t, nbytes, BLAKE2S_HASH_SIZE);
+		/* output = HASHPRF(seed, RDSEED || ++counter) */
+		++block.counter;
+		blake2s(buf, (u8 *)&block, seed, i, sizeof(block), sizeof(seed));
+		nbytes -= i;
+		buf += i;
+	}
+
+	memzero_explicit(seed, sizeof(seed));
+	memzero_explicit(&block, sizeof(block));
+}
+
+/*
+ * First we make sure we have POOL_MIN_BITS of entropy in the pool, and then we
+ * set the entropy count to zero (but don't actually touch any data). Only then
+ * can we extract a new key with extract_entropy().
+ */
+static bool drain_entropy(void *buf, size_t nbytes)
+{
+	unsigned int entropy_count;
+	do {
+		entropy_count = READ_ONCE(input_pool.entropy_count);
+		if (entropy_count < POOL_MIN_BITS)
+			return false;
+	} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
+	extract_entropy(buf, nbytes);
+	wake_up_interruptible(&random_write_wait);
+	kill_fasync(&fasync, SIGIO, POLL_OUT);
+	return true;
 }
 
 struct fast_pool {
@@ -983,24 +1074,6 @@ static void fast_mix(u32 pool[4])
 	pool[2] = c;  pool[3] = d;
 }
 
-static void credit_entropy_bits(size_t nbits)
-{
-	unsigned int entropy_count, orig, add;
-
-	if (!nbits)
-		return;
-
-	add = min_t(size_t, nbits, POOL_BITS);
-
-	do {
-		orig = READ_ONCE(input_pool.entropy_count);
-		entropy_count = min_t(unsigned int, POOL_BITS, orig + add);
-	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
-
-	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
-		crng_reseed();
-}
-
 /*********************************************************************
  *
  * Entropy input management
@@ -1197,77 +1270,6 @@ void add_disk_randomness(struct gendisk
 EXPORT_SYMBOL_GPL(add_disk_randomness);
 #endif
 
-/*********************************************************************
- *
- * Entropy extraction routines
- *
- *********************************************************************/
-
-/*
- * This is an HKDF-like construction for using the hashed collected entropy
- * as a PRF key, that's then expanded block-by-block.
- */
-static void extract_entropy(void *buf, size_t nbytes)
-{
-	unsigned long flags;
-	u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
-	struct {
-		unsigned long rdseed[32 / sizeof(long)];
-		size_t counter;
-	} block;
-	size_t i;
-
-	for (i = 0; i < ARRAY_SIZE(block.rdseed); ++i) {
-		if (!arch_get_random_seed_long(&block.rdseed[i]) &&
-		    !arch_get_random_long(&block.rdseed[i]))
-			block.rdseed[i] = random_get_entropy();
-	}
-
-	spin_lock_irqsave(&input_pool.lock, flags);
-
-	/* seed = HASHPRF(last_key, entropy_input) */
-	blake2s_final(&input_pool.hash, seed);
-
-	/* next_key = HASHPRF(seed, RDSEED || 0) */
-	block.counter = 0;
-	blake2s(next_key, (u8 *)&block, seed, sizeof(next_key), sizeof(block), sizeof(seed));
-	blake2s_init_key(&input_pool.hash, BLAKE2S_HASH_SIZE, next_key, sizeof(next_key));
-
-	spin_unlock_irqrestore(&input_pool.lock, flags);
-	memzero_explicit(next_key, sizeof(next_key));
-
-	while (nbytes) {
-		i = min_t(size_t, nbytes, BLAKE2S_HASH_SIZE);
-		/* output = HASHPRF(seed, RDSEED || ++counter) */
-		++block.counter;
-		blake2s(buf, (u8 *)&block, seed, i, sizeof(block), sizeof(seed));
-		nbytes -= i;
-		buf += i;
-	}
-
-	memzero_explicit(seed, sizeof(seed));
-	memzero_explicit(&block, sizeof(block));
-}
-
-/*
- * First we make sure we have POOL_MIN_BITS of entropy in the pool, and then we
- * set the entropy count to zero (but don't actually touch any data). Only then
- * can we extract a new key with extract_entropy().
- */
-static bool drain_entropy(void *buf, size_t nbytes)
-{
-	unsigned int entropy_count;
-	do {
-		entropy_count = READ_ONCE(input_pool.entropy_count);
-		if (entropy_count < POOL_MIN_BITS)
-			return false;
-	} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
-	extract_entropy(buf, nbytes);
-	wake_up_interruptible(&random_write_wait);
-	kill_fasync(&fasync, SIGIO, POLL_OUT);
-	return true;
-}
-
 /*
  * Each time the timer fires, we expect that we got an unpredictable
  * jump in the cycle counter. Even if the timer is running on another


