Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E77558588
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbiFWR7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236089AbiFWR6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:58:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806FB995DA;
        Thu, 23 Jun 2022 10:16:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47E77B824B4;
        Thu, 23 Jun 2022 17:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85612C341C4;
        Thu, 23 Jun 2022 17:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004565;
        bh=8qXnFh0yU80+R8Mh2kVMrCcRTwcVGvH//4Sl7mjS2fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkjKh1Qk1dOJybalGcwwukOuL7Tnr9P9pigPc1yJTEIGUALgNtK08fKRSRtOLsBU0
         PGMYD/+97XeErkverUhDaCmcMDNX/nGXULqeJsFgRr1n/xk8StadzYBkXimsvmiXhf
         fOzaNtRlU09YdAQxGUj/xJXvA3qbkughecoLDTK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 076/234] random: simplify entropy debiting
Date:   Thu, 23 Jun 2022 18:42:23 +0200
Message-Id: <20220623164345.210209328@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

commit 9c07f57869e90140080cfc282cc628d123e27704 upstream.

Our pool is 256 bits, and we only ever use all of it or don't use it at
all, which is decided by whether or not it has at least 128 bits in it.
So we can drastically simplify the accounting and cmpxchg loop to do
exactly this.  While we're at it, we move the minimum bit size into a
constant so it can be shared between the two places where it matters.

The reason we want any of this is for the case in which an attacker has
compromised the current state, and then bruteforces small amounts of
entropy added to it. By demanding a particular minimum amount of entropy
be present before reseeding, we make that bruteforcing difficult.

Note that this rationale no longer includes anything about /dev/random
blocking at the right moment, since /dev/random no longer blocks (except
for at ~boot), but rather uses the crng. In a former life, /dev/random
was different and therefore required a more nuanced account(), but this
is no longer.

Behaviorally, nothing changes here. This is just a simplification of
the code.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c         |   91 +++++++++---------------------------------
 include/trace/events/random.h |   30 ++-----------
 2 files changed, 27 insertions(+), 94 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -289,12 +289,14 @@
 enum poolinfo {
 	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
 	POOL_BITSHIFT = ilog2(POOL_BITS),
+	POOL_MIN_BITS = POOL_BITS / 2,
 
 	/* To allow fractional bits to be tracked, the entropy_count field is
 	 * denominated in units of 1/8th bits. */
 	POOL_ENTROPY_SHIFT = 3,
 #define POOL_ENTROPY_BITS() (input_pool.entropy_count >> POOL_ENTROPY_SHIFT)
-	POOL_FRACBITS = POOL_BITS << POOL_ENTROPY_SHIFT
+	POOL_FRACBITS = POOL_BITS << POOL_ENTROPY_SHIFT,
+	POOL_MIN_FRACBITS = POOL_MIN_BITS << POOL_ENTROPY_SHIFT
 };
 
 /*
@@ -375,8 +377,7 @@ static struct {
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
 };
 
-static bool extract_entropy(void *buf, size_t nbytes, int min);
-static void _extract_entropy(void *buf, size_t nbytes);
+static void extract_entropy(void *buf, size_t nbytes);
 
 static void crng_reseed(struct crng_state *crng, bool use_input_pool);
 
@@ -467,7 +468,7 @@ static void process_random_ready_list(vo
  */
 static void credit_entropy_bits(int nbits)
 {
-	int entropy_count, entropy_bits, orig;
+	int entropy_count, orig;
 	int nfrac = nbits << POOL_ENTROPY_SHIFT;
 
 	/* Ensure that the multiplication can avoid being 64 bits wide. */
@@ -527,8 +528,7 @@ retry:
 
 	trace_credit_entropy_bits(nbits, entropy_count >> POOL_ENTROPY_SHIFT, _RET_IP_);
 
-	entropy_bits = entropy_count >> POOL_ENTROPY_SHIFT;
-	if (crng_init < 2 && entropy_bits >= 128)
+	if (crng_init < 2 && entropy_count >= POOL_MIN_FRACBITS)
 		crng_reseed(&primary_crng, true);
 }
 
@@ -618,7 +618,7 @@ static void crng_initialize_secondary(st
 
 static void __init crng_initialize_primary(void)
 {
-	_extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
+	extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
 	if (crng_init_try_arch_early() && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		numa_crng_init();
@@ -788,8 +788,17 @@ static void crng_reseed(struct crng_stat
 	} buf;
 
 	if (use_input_pool) {
-		if (!extract_entropy(&buf, 32, 16))
-			return;
+		int entropy_count;
+		do {
+			entropy_count = READ_ONCE(input_pool.entropy_count);
+			if (entropy_count < POOL_MIN_FRACBITS)
+				return;
+		} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
+		extract_entropy(buf.key, sizeof(buf.key));
+		if (random_write_wakeup_bits) {
+			wake_up_interruptible(&random_write_wait);
+			kill_fasync(&fasync, SIGIO, POLL_OUT);
+		}
 	} else {
 		_extract_crng(&primary_crng, buf.block);
 		_crng_backtrack_protect(&primary_crng, buf.block,
@@ -1115,51 +1124,10 @@ EXPORT_SYMBOL_GPL(add_disk_randomness);
  *********************************************************************/
 
 /*
- * This function decides how many bytes to actually take from the
- * given pool, and also debits the entropy count accordingly.
- */
-static size_t account(size_t nbytes, int min)
-{
-	int entropy_count, orig;
-	size_t ibytes, nfrac;
-
-	BUG_ON(input_pool.entropy_count > POOL_FRACBITS);
-
-	/* Can we pull enough? */
-retry:
-	entropy_count = orig = READ_ONCE(input_pool.entropy_count);
-	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("negative entropy count: count %d\n", entropy_count);
-		entropy_count = 0;
-	}
-
-	/* never pull more than available */
-	ibytes = min_t(size_t, nbytes, entropy_count >> (POOL_ENTROPY_SHIFT + 3));
-	if (ibytes < min)
-		ibytes = 0;
-	nfrac = ibytes << (POOL_ENTROPY_SHIFT + 3);
-	if ((size_t)entropy_count > nfrac)
-		entropy_count -= nfrac;
-	else
-		entropy_count = 0;
-
-	if (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig)
-		goto retry;
-
-	trace_debit_entropy(8 * ibytes);
-	if (ibytes && POOL_ENTROPY_BITS() < random_write_wakeup_bits) {
-		wake_up_interruptible(&random_write_wait);
-		kill_fasync(&fasync, SIGIO, POLL_OUT);
-	}
-
-	return ibytes;
-}
-
-/*
  * This is an HKDF-like construction for using the hashed collected entropy
  * as a PRF key, that's then expanded block-by-block.
  */
-static void _extract_entropy(void *buf, size_t nbytes)
+static void extract_entropy(void *buf, size_t nbytes)
 {
 	unsigned long flags;
 	u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
@@ -1169,6 +1137,8 @@ static void _extract_entropy(void *buf,
 	} block;
 	size_t i;
 
+	trace_extract_entropy(nbytes, POOL_ENTROPY_BITS());
+
 	for (i = 0; i < ARRAY_SIZE(block.rdrand); ++i) {
 		if (!arch_get_random_long(&block.rdrand[i]))
 			block.rdrand[i] = random_get_entropy();
@@ -1200,25 +1170,6 @@ static void _extract_entropy(void *buf,
 	memzero_explicit(&block, sizeof(block));
 }
 
-/*
- * This function extracts randomness from the "entropy pool", and
- * returns it in a buffer.
- *
- * The min parameter specifies the minimum amount we can pull before
- * failing to avoid races that defeat catastrophic reseeding. If we
- * have less than min entropy available, we return false and buf is
- * not filled.
- */
-static bool extract_entropy(void *buf, size_t nbytes, int min)
-{
-	trace_extract_entropy(nbytes, POOL_ENTROPY_BITS(), _RET_IP_);
-	if (account(nbytes, min)) {
-		_extract_entropy(buf, nbytes);
-		return true;
-	}
-	return false;
-}
-
 #define warn_unseeded_randomness(previous) \
 	_warn_unseeded_randomness(__func__, (void *)_RET_IP_, (previous))
 
--- a/include/trace/events/random.h
+++ b/include/trace/events/random.h
@@ -79,22 +79,6 @@ TRACE_EVENT(credit_entropy_bits,
 		  __entry->bits, __entry->entropy_count, (void *)__entry->IP)
 );
 
-TRACE_EVENT(debit_entropy,
-	TP_PROTO(int debit_bits),
-
-	TP_ARGS( debit_bits),
-
-	TP_STRUCT__entry(
-		__field(	  int,	debit_bits		)
-	),
-
-	TP_fast_assign(
-		__entry->debit_bits	= debit_bits;
-	),
-
-	TP_printk("input pool: debit_bits %d", __entry->debit_bits)
-);
-
 TRACE_EVENT(add_input_randomness,
 	TP_PROTO(int input_bits),
 
@@ -161,31 +145,29 @@ DEFINE_EVENT(random__get_random_bytes, g
 );
 
 DECLARE_EVENT_CLASS(random__extract_entropy,
-	TP_PROTO(int nbytes, int entropy_count, unsigned long IP),
+	TP_PROTO(int nbytes, int entropy_count),
 
-	TP_ARGS(nbytes, entropy_count, IP),
+	TP_ARGS(nbytes, entropy_count),
 
 	TP_STRUCT__entry(
 		__field(	  int,	nbytes			)
 		__field(	  int,	entropy_count		)
-		__field(unsigned long,	IP			)
 	),
 
 	TP_fast_assign(
 		__entry->nbytes		= nbytes;
 		__entry->entropy_count	= entropy_count;
-		__entry->IP		= IP;
 	),
 
-	TP_printk("input pool: nbytes %d entropy_count %d caller %pS",
-		  __entry->nbytes, __entry->entropy_count, (void *)__entry->IP)
+	TP_printk("input pool: nbytes %d entropy_count %d",
+		  __entry->nbytes, __entry->entropy_count)
 );
 
 
 DEFINE_EVENT(random__extract_entropy, extract_entropy,
-	TP_PROTO(int nbytes, int entropy_count, unsigned long IP),
+	TP_PROTO(int nbytes, int entropy_count),
 
-	TP_ARGS(nbytes, entropy_count, IP)
+	TP_ARGS(nbytes, entropy_count)
 );
 
 TRACE_EVENT(urandom_read,


