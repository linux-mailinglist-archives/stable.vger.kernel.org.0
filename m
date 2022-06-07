Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1161353602E
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbiE0LrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352491AbiE0LqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:46:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A45C149A8E;
        Fri, 27 May 2022 04:42:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C29C261D2B;
        Fri, 27 May 2022 11:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AEAC385A9;
        Fri, 27 May 2022 11:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651761;
        bh=XJZV81fg0CvvUE8NFLqOOC7gPN7yHPArlxoOH4nRArk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8JkpePSe0r+di6KmAbE5X0x6ibZNx/2FR3/XMe8liAum5WyjabIOFY4FAJJsDJYW
         r4TdCnUjJtbLV4m9Ic613gC9vu6Hi1tM/gahHX0/0t31fc+NGzV3W+ydF+yt6HeKnD
         7whKz/UjOjOwRpgIe/sQAYWxVNdTD49/qiUz5fNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 056/163] random: use computational hash for entropy extraction
Date:   Fri, 27 May 2022 10:48:56 +0200
Message-Id: <20220527084835.841288742@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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

commit 6e8ec2552c7d13991148e551e3325a624d73fac6 upstream.

The current 4096-bit LFSR used for entropy collection had a few
desirable attributes for the context in which it was created. For
example, the state was huge, which meant that /dev/random would be able
to output quite a bit of accumulated entropy before blocking. It was
also, in its time, quite fast at accumulating entropy byte-by-byte,
which matters given the varying contexts in which mix_pool_bytes() is
called. And its diffusion was relatively high, which meant that changes
would ripple across several words of state rather quickly.

However, it also suffers from a few security vulnerabilities. In
particular, inputs learned by an attacker can be undone, but moreover,
if the state of the pool leaks, its contents can be controlled and
entirely zeroed out. I've demonstrated this attack with this SMT2
script, <https://xn--4db.cc/5o9xO8pb>, which Boolector/CaDiCal solves in
a matter of seconds on a single core of my laptop, resulting in little
proof of concept C demonstrators such as <https://xn--4db.cc/jCkvvIaH/c>.

For basically all recent formal models of RNGs, these attacks represent
a significant cryptographic flaw. But how does this manifest
practically? If an attacker has access to the system to such a degree
that he can learn the internal state of the RNG, arguably there are
other lower hanging vulnerabilities -- side-channel, infoleak, or
otherwise -- that might have higher priority. On the other hand, seed
files are frequently used on systems that have a hard time generating
much entropy on their own, and these seed files, being files, often leak
or are duplicated and distributed accidentally, or are even seeded over
the Internet intentionally, where their contents might be recorded or
tampered with. Seen this way, an otherwise quasi-implausible
vulnerability is a bit more practical than initially thought.

Another aspect of the current mix_pool_bytes() function is that, while
its performance was arguably competitive for the time in which it was
created, it's no longer considered so. This patch improves performance
significantly: on a high-end CPU, an i7-11850H, it improves performance
of mix_pool_bytes() by 225%, and on a low-end CPU, a Cortex-A7, it
improves performance by 103%.

This commit replaces the LFSR of mix_pool_bytes() with a straight-
forward cryptographic hash function, BLAKE2s, which is already in use
for pool extraction. Universal hashing with a secret seed was considered
too, something along the lines of <https://eprint.iacr.org/2013/338>,
but the requirement for a secret seed makes for a chicken & egg problem.
Instead we go with a formally proven scheme using a computational hash
function, described in sections 5.1, 6.4, and B.1.8 of
<https://eprint.iacr.org/2019/198>.

BLAKE2s outputs 256 bits, which should give us an appropriate amount of
min-entropy accumulation, and a wide enough margin of collision
resistance against active attacks. mix_pool_bytes() becomes a simple
call to blake2s_update(), for accumulation, while the extraction step
becomes a blake2s_final() to generate a seed, with which we can then do
a HKDF-like or BLAKE2X-like expansion, the first part of which we fold
back as an init key for subsequent blake2s_update()s, and the rest we
produce to the caller. This then is provided to our CRNG like usual. In
that expansion step, we make opportunistic use of 32 bytes of RDRAND
output, just as before. We also always reseed the crng with 32 bytes,
unconditionally, or not at all, rather than sometimes with 16 as before,
as we don't win anything by limiting beyond the 16 byte threshold.

Going for a hash function as an entropy collector is a conservative,
proven approach. The result of all this is a much simpler and much less
bespoke construction than what's there now, which not only plugs a
vulnerability but also improves performance considerably.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  304 +++++++++-----------------------------------------
 1 file changed, 55 insertions(+), 249 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -42,61 +42,6 @@
  */
 
 /*
- * (now, with legal B.S. out of the way.....)
- *
- * This routine gathers environmental noise from device drivers, etc.,
- * and returns good random numbers, suitable for cryptographic use.
- * Besides the obvious cryptographic uses, these numbers are also good
- * for seeding TCP sequence numbers, and other places where it is
- * desirable to have numbers which are not only random, but hard to
- * predict by an attacker.
- *
- * Theory of operation
- * ===================
- *
- * Computers are very predictable devices.  Hence it is extremely hard
- * to produce truly random numbers on a computer --- as opposed to
- * pseudo-random numbers, which can easily generated by using a
- * algorithm.  Unfortunately, it is very easy for attackers to guess
- * the sequence of pseudo-random number generators, and for some
- * applications this is not acceptable.  So instead, we must try to
- * gather "environmental noise" from the computer's environment, which
- * must be hard for outside attackers to observe, and use that to
- * generate random numbers.  In a Unix environment, this is best done
- * from inside the kernel.
- *
- * Sources of randomness from the environment include inter-keyboard
- * timings, inter-interrupt timings from some interrupts, and other
- * events which are both (a) non-deterministic and (b) hard for an
- * outside observer to measure.  Randomness from these sources are
- * added to an "entropy pool", which is mixed using a CRC-like function.
- * This is not cryptographically strong, but it is adequate assuming
- * the randomness is not chosen maliciously, and it is fast enough that
- * the overhead of doing it on every interrupt is very reasonable.
- * As random bytes are mixed into the entropy pool, the routines keep
- * an *estimate* of how many bits of randomness have been stored into
- * the random number generator's internal state.
- *
- * When random bytes are desired, they are obtained by taking the BLAKE2s
- * hash of the contents of the "entropy pool".  The BLAKE2s hash avoids
- * exposing the internal state of the entropy pool.  It is believed to
- * be computationally infeasible to derive any useful information
- * about the input of BLAKE2s from its output.  Even if it is possible to
- * analyze BLAKE2s in some clever way, as long as the amount of data
- * returned from the generator is less than the inherent entropy in
- * the pool, the output data is totally unpredictable.  For this
- * reason, the routine decreases its internal estimate of how many
- * bits of "true randomness" are contained in the entropy pool as it
- * outputs random numbers.
- *
- * If this estimate goes to zero, the routine can still generate
- * random numbers; however, an attacker may (at least in theory) be
- * able to infer the future output of the generator from prior
- * outputs.  This requires successful cryptanalysis of BLAKE2s, which is
- * not believed to be feasible, but there is a remote possibility.
- * Nonetheless, these numbers should be useful for the vast majority
- * of purposes.
- *
  * Exported interfaces ---- output
  * ===============================
  *
@@ -298,23 +243,6 @@
  *
  *	mknod /dev/random c 1 8
  *	mknod /dev/urandom c 1 9
- *
- * Acknowledgements:
- * =================
- *
- * Ideas for constructing this random number generator were derived
- * from Pretty Good Privacy's random number generator, and from private
- * discussions with Phil Karn.  Colin Plumb provided a faster random
- * number generator, which speed up the mixing function of the entropy
- * pool, taken from PGPfone.  Dale Worley has also contributed many
- * useful ideas and suggestions to improve this driver.
- *
- * Any flaws in the design are solely my responsibility, and should
- * not be attributed to the Phil, Colin, or any of authors of PGP.
- *
- * Further background information on this topic may be obtained from
- * RFC 1750, "Randomness Recommendations for Security", by Donald
- * Eastlake, Steve Crocker, and Jeff Schiller.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -358,79 +286,15 @@
 
 /* #define ADD_INTERRUPT_BENCH */
 
-/*
- * If the entropy count falls under this number of bits, then we
- * should wake up processes which are selecting or polling on write
- * access to /dev/random.
- */
-static int random_write_wakeup_bits = 28 * (1 << 5);
-
-/*
- * Originally, we used a primitive polynomial of degree .poolwords
- * over GF(2).  The taps for various sizes are defined below.  They
- * were chosen to be evenly spaced except for the last tap, which is 1
- * to get the twisting happening as fast as possible.
- *
- * For the purposes of better mixing, we use the CRC-32 polynomial as
- * well to make a (modified) twisted Generalized Feedback Shift
- * Register.  (See M. Matsumoto & Y. Kurita, 1992.  Twisted GFSR
- * generators.  ACM Transactions on Modeling and Computer Simulation
- * 2(3):179-194.  Also see M. Matsumoto & Y. Kurita, 1994.  Twisted
- * GFSR generators II.  ACM Transactions on Modeling and Computer
- * Simulation 4:254-266)
- *
- * Thanks to Colin Plumb for suggesting this.
- *
- * The mixing operation is much less sensitive than the output hash,
- * where we use BLAKE2s.  All that we want of mixing operation is that
- * it be a good non-cryptographic hash; i.e. it not produce collisions
- * when fed "random" data of the sort we expect to see.  As long as
- * the pool state differs for different inputs, we have preserved the
- * input entropy and done a good job.  The fact that an intelligent
- * attacker can construct inputs that will produce controlled
- * alterations to the pool's state is not important because we don't
- * consider such inputs to contribute any randomness.  The only
- * property we need with respect to them is that the attacker can't
- * increase his/her knowledge of the pool's state.  Since all
- * additions are reversible (knowing the final state and the input,
- * you can reconstruct the initial state), if an attacker has any
- * uncertainty about the initial state, he/she can only shuffle that
- * uncertainty about, but never cause any collisions (which would
- * decrease the uncertainty).
- *
- * Our mixing functions were analyzed by Lacharme, Roeck, Strubel, and
- * Videau in their paper, "The Linux Pseudorandom Number Generator
- * Revisited" (see: http://eprint.iacr.org/2012/251.pdf).  In their
- * paper, they point out that we are not using a true Twisted GFSR,
- * since Matsumoto & Kurita used a trinomial feedback polynomial (that
- * is, with only three taps, instead of the six that we are using).
- * As a result, the resulting polynomial is neither primitive nor
- * irreducible, and hence does not have a maximal period over
- * GF(2**32).  They suggest a slight change to the generator
- * polynomial which improves the resulting TGFSR polynomial to be
- * irreducible, which we have made here.
- */
 enum poolinfo {
-	POOL_WORDS = 128,
-	POOL_WORDMASK = POOL_WORDS - 1,
-	POOL_BYTES = POOL_WORDS * sizeof(u32),
-	POOL_BITS = POOL_BYTES * 8,
+	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
 	POOL_BITSHIFT = ilog2(POOL_BITS),
 
 	/* To allow fractional bits to be tracked, the entropy_count field is
 	 * denominated in units of 1/8th bits. */
 	POOL_ENTROPY_SHIFT = 3,
 #define POOL_ENTROPY_BITS() (input_pool.entropy_count >> POOL_ENTROPY_SHIFT)
-	POOL_FRACBITS = POOL_BITS << POOL_ENTROPY_SHIFT,
-
-	/* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
-	POOL_TAP1 = 104,
-	POOL_TAP2 = 76,
-	POOL_TAP3 = 51,
-	POOL_TAP4 = 25,
-	POOL_TAP5 = 1,
-
-	EXTRACT_SIZE = BLAKE2S_HASH_SIZE / 2
+	POOL_FRACBITS = POOL_BITS << POOL_ENTROPY_SHIFT
 };
 
 /*
@@ -438,6 +302,12 @@ enum poolinfo {
  */
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static struct fasync_struct *fasync;
+/*
+ * If the entropy count falls under this number of bits, then we
+ * should wake up processes which are selecting or polling on write
+ * access to /dev/random.
+ */
+static int random_write_wakeup_bits = POOL_BITS * 3 / 4;
 
 static DEFINE_SPINLOCK(random_ready_list_lock);
 static LIST_HEAD(random_ready_list);
@@ -493,73 +363,31 @@ MODULE_PARM_DESC(ratelimit_disable, "Dis
  *
  **********************************************************************/
 
-static u32 input_pool_data[POOL_WORDS] __latent_entropy;
-
 static struct {
+	struct blake2s_state hash;
 	spinlock_t lock;
-	u16 add_ptr;
-	u16 input_rotate;
 	int entropy_count;
 } input_pool = {
+	.hash.h = { BLAKE2S_IV0 ^ (0x01010000 | BLAKE2S_HASH_SIZE),
+		    BLAKE2S_IV1, BLAKE2S_IV2, BLAKE2S_IV3, BLAKE2S_IV4,
+		    BLAKE2S_IV5, BLAKE2S_IV6, BLAKE2S_IV7 },
+	.hash.outlen = BLAKE2S_HASH_SIZE,
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
 };
 
-static ssize_t extract_entropy(void *buf, size_t nbytes, int min);
-static ssize_t _extract_entropy(void *buf, size_t nbytes);
+static bool extract_entropy(void *buf, size_t nbytes, int min);
+static void _extract_entropy(void *buf, size_t nbytes);
 
 static void crng_reseed(struct crng_state *crng, bool use_input_pool);
 
-static const u32 twist_table[8] = {
-	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
-	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
-
 /*
  * This function adds bytes into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
  * credit_entropy_bits if this is appropriate.
- *
- * The pool is stirred with a primitive polynomial of the appropriate
- * degree, and then twisted.  We twist by three bits at a time because
- * it's cheap to do so and helps slightly in the expected case where
- * the entropy is concentrated in the low-order bits.
  */
 static void _mix_pool_bytes(const void *in, int nbytes)
 {
-	unsigned long i;
-	int input_rotate;
-	const u8 *bytes = in;
-	u32 w;
-
-	input_rotate = input_pool.input_rotate;
-	i = input_pool.add_ptr;
-
-	/* mix one byte at a time to simplify size handling and churn faster */
-	while (nbytes--) {
-		w = rol32(*bytes++, input_rotate);
-		i = (i - 1) & POOL_WORDMASK;
-
-		/* XOR in the various taps */
-		w ^= input_pool_data[i];
-		w ^= input_pool_data[(i + POOL_TAP1) & POOL_WORDMASK];
-		w ^= input_pool_data[(i + POOL_TAP2) & POOL_WORDMASK];
-		w ^= input_pool_data[(i + POOL_TAP3) & POOL_WORDMASK];
-		w ^= input_pool_data[(i + POOL_TAP4) & POOL_WORDMASK];
-		w ^= input_pool_data[(i + POOL_TAP5) & POOL_WORDMASK];
-
-		/* Mix the result back in with a twist */
-		input_pool_data[i] = (w >> 3) ^ twist_table[w & 7];
-
-		/*
-		 * Normally, we add 7 bits of rotation to the pool.
-		 * At the beginning of the pool, add an extra 7 bits
-		 * rotation, so that successive passes spread the
-		 * input bits across the pool evenly.
-		 */
-		input_rotate = (input_rotate + (i ? 7 : 14)) & 31;
-	}
-
-	input_pool.input_rotate = input_rotate;
-	input_pool.add_ptr = i;
+	blake2s_update(&input_pool.hash, in, nbytes);
 }
 
 static void __mix_pool_bytes(const void *in, int nbytes)
@@ -953,15 +781,14 @@ static int crng_slow_load(const u8 *cp,
 static void crng_reseed(struct crng_state *crng, bool use_input_pool)
 {
 	unsigned long flags;
-	int i, num;
+	int i;
 	union {
 		u8 block[CHACHA_BLOCK_SIZE];
 		u32 key[8];
 	} buf;
 
 	if (use_input_pool) {
-		num = extract_entropy(&buf, 32, 16);
-		if (num == 0)
+		if (!extract_entropy(&buf, 32, 16))
 			return;
 	} else {
 		_extract_crng(&primary_crng, buf.block);
@@ -1329,74 +1156,48 @@ retry:
 }
 
 /*
- * This function does the actual extraction for extract_entropy.
- *
- * Note: we assume that .poolwords is a multiple of 16 words.
+ * This is an HKDF-like construction for using the hashed collected entropy
+ * as a PRF key, that's then expanded block-by-block.
  */
-static void extract_buf(u8 *out)
+static void _extract_entropy(void *buf, size_t nbytes)
 {
-	struct blake2s_state state __aligned(__alignof__(unsigned long));
-	u8 hash[BLAKE2S_HASH_SIZE];
-	unsigned long *salt;
 	unsigned long flags;
-
-	blake2s_init(&state, sizeof(hash));
-
-	/*
-	 * If we have an architectural hardware random number
-	 * generator, use it for BLAKE2's salt & personal fields.
-	 */
-	for (salt = (unsigned long *)&state.h[4];
-	     salt < (unsigned long *)&state.h[8]; ++salt) {
-		unsigned long v;
-		if (!arch_get_random_long(&v))
-			break;
-		*salt ^= v;
+	u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
+	struct {
+		unsigned long rdrand[32 / sizeof(long)];
+		size_t counter;
+	} block;
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(block.rdrand); ++i) {
+		if (!arch_get_random_long(&block.rdrand[i]))
+			block.rdrand[i] = random_get_entropy();
 	}
 
-	/* Generate a hash across the pool */
 	spin_lock_irqsave(&input_pool.lock, flags);
-	blake2s_update(&state, (const u8 *)input_pool_data, POOL_BYTES);
-	blake2s_final(&state, hash); /* final zeros out state */
 
-	/*
-	 * We mix the hash back into the pool to prevent backtracking
-	 * attacks (where the attacker knows the state of the pool
-	 * plus the current outputs, and attempts to find previous
-	 * outputs), unless the hash function can be inverted. By
-	 * mixing at least a hash worth of hash data back, we make
-	 * brute-forcing the feedback as hard as brute-forcing the
-	 * hash.
-	 */
-	__mix_pool_bytes(hash, sizeof(hash));
-	spin_unlock_irqrestore(&input_pool.lock, flags);
+	/* seed = HASHPRF(last_key, entropy_input) */
+	blake2s_final(&input_pool.hash, seed);
 
-	/* Note that EXTRACT_SIZE is half of hash size here, because above
-	 * we've dumped the full length back into mixer. By reducing the
-	 * amount that we emit, we retain a level of forward secrecy.
-	 */
-	memcpy(out, hash, EXTRACT_SIZE);
-	memzero_explicit(hash, sizeof(hash));
-}
+	/* next_key = HASHPRF(seed, RDRAND || 0) */
+	block.counter = 0;
+	blake2s(next_key, (u8 *)&block, seed, sizeof(next_key), sizeof(block), sizeof(seed));
+	blake2s_init_key(&input_pool.hash, BLAKE2S_HASH_SIZE, next_key, sizeof(next_key));
 
-static ssize_t _extract_entropy(void *buf, size_t nbytes)
-{
-	ssize_t ret = 0, i;
-	u8 tmp[EXTRACT_SIZE];
+	spin_unlock_irqrestore(&input_pool.lock, flags);
+	memzero_explicit(next_key, sizeof(next_key));
 
 	while (nbytes) {
-		extract_buf(tmp);
-		i = min_t(int, nbytes, EXTRACT_SIZE);
-		memcpy(buf, tmp, i);
+		i = min_t(size_t, nbytes, BLAKE2S_HASH_SIZE);
+		/* output = HASHPRF(seed, RDRAND || ++counter) */
+		++block.counter;
+		blake2s(buf, (u8 *)&block, seed, i, sizeof(block), sizeof(seed));
 		nbytes -= i;
 		buf += i;
-		ret += i;
 	}
 
-	/* Wipe data just returned from memory */
-	memzero_explicit(tmp, sizeof(tmp));
-
-	return ret;
+	memzero_explicit(seed, sizeof(seed));
+	memzero_explicit(&block, sizeof(block));
 }
 
 /*
@@ -1404,13 +1205,18 @@ static ssize_t _extract_entropy(void *bu
  * returns it in a buffer.
  *
  * The min parameter specifies the minimum amount we can pull before
- * failing to avoid races that defeat catastrophic reseeding.
+ * failing to avoid races that defeat catastrophic reseeding. If we
+ * have less than min entropy available, we return false and buf is
+ * not filled.
  */
-static ssize_t extract_entropy(void *buf, size_t nbytes, int min)
+static bool extract_entropy(void *buf, size_t nbytes, int min)
 {
 	trace_extract_entropy(nbytes, POOL_ENTROPY_BITS(), _RET_IP_);
-	nbytes = account(nbytes, min);
-	return _extract_entropy(buf, nbytes);
+	if (account(nbytes, min)) {
+		_extract_entropy(buf, nbytes);
+		return true;
+	}
+	return false;
 }
 
 #define warn_unseeded_randomness(previous) \
@@ -1674,7 +1480,7 @@ static void __init init_std_data(void)
 	unsigned long rv;
 
 	mix_pool_bytes(&now, sizeof(now));
-	for (i = POOL_BYTES; i > 0; i -= sizeof(rv)) {
+	for (i = BLAKE2S_BLOCK_SIZE; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_seed_long(&rv) &&
 		    !arch_get_random_long(&rv))
 			rv = random_get_entropy();


