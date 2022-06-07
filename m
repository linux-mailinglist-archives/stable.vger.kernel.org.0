Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368515360CE
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351978AbiE0Lxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352316AbiE0LuS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA85614D7AC;
        Fri, 27 May 2022 04:44:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C643D61D50;
        Fri, 27 May 2022 11:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4468C385A9;
        Fri, 27 May 2022 11:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651865;
        bh=83qPZrUT7KuXEJvnScy3SjQdm61FaH6D0xV56qBfN7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jHWd52UtV53K2eclaLedCPAXJh6MTALUNOWFaotbu95Hi71CPIxUz4iw8sz7VkOs
         TuiMREQboAmvYF/oYkXr634LwmT+a3U2mbTjekzBwFxTtGY+ogaShGe0VoQoV4IDBd
         MibQpktCfS1YWQDuzrJH1pghe0gwAlVSB4njkN5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 058/163] random: use linear min-entropy accumulation crediting
Date:   Fri, 27 May 2022 10:48:58 +0200
Message-Id: <20220527084836.185252776@linuxfoundation.org>
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

commit c570449094844527577c5c914140222cb1893e3f upstream.

30e37ec516ae ("random: account for entropy loss due to overwrites")
assumed that adding new entropy to the LFSR pool probabilistically
cancelled out old entropy there, so entropy was credited asymptotically,
approximating Shannon entropy of independent sources (rather than a
stronger min-entropy notion) using 1/8th fractional bits and replacing
a constant 2-2/√𝑒 term (~0.786938) with 3/4 (0.75) to slightly
underestimate it. This wasn't superb, but it was perhaps better than
nothing, so that's what was done. Which entropy specifically was being
cancelled out and how much precisely each time is hard to tell, though
as I showed with the attack code in my previous commit, a motivated
adversary with sufficient information can actually cancel out
everything.

Since we're no longer using an LFSR for entropy accumulation, this
probabilistic cancellation is no longer relevant. Rather, we're now
using a computational hash function as the accumulator and we've
switched to working in the random oracle model, from which we can now
revisit the question of min-entropy accumulation, which is done in
detail in <https://eprint.iacr.org/2019/198>.

Consider a long input bit string that is built by concatenating various
smaller independent input bit strings. Each one of these inputs has a
designated min-entropy, which is what we're passing to
credit_entropy_bits(h). When we pass the concatenation of these to a
random oracle, it means that an adversary trying to receive back the
same reply as us would need to become certain about each part of the
concatenated bit string we passed in, which means becoming certain about
all of those h values. That means we can estimate the accumulation by
simply adding up the h values in calls to credit_entropy_bits(h);
there's no probabilistic cancellation at play like there was said to be
for the LFSR. Incidentally, this is also what other entropy accumulators
based on computational hash functions do as well.

So this commit replaces credit_entropy_bits(h) with essentially `total =
min(POOL_BITS, total + h)`, done with a cmpxchg loop as before.

What if we're wrong and the above is nonsense? It's not, but let's
assume we don't want the actual _behavior_ of the code to change much.
Currently that behavior is not extracting from the input pool until it
has 128 bits of entropy in it. With the old algorithm, we'd hit that
magic 128 number after roughly 256 calls to credit_entropy_bits(1). So,
we can retain more or less the old behavior by waiting to extract from
the input pool until it hits 256 bits of entropy using the new code. For
people concerned about this change, it means that there's not that much
practical behavioral change. And for folks actually trying to model
the behavior rigorously, it means that we have an even higher margin
against attacks.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  114 ++++++++------------------------------------------
 1 file changed, 20 insertions(+), 94 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -286,17 +286,9 @@
 
 /* #define ADD_INTERRUPT_BENCH */
 
-enum poolinfo {
+enum {
 	POOL_BITS = BLAKE2S_HASH_SIZE * 8,
-	POOL_BITSHIFT = ilog2(POOL_BITS),
-	POOL_MIN_BITS = POOL_BITS / 2,
-
-	/* To allow fractional bits to be tracked, the entropy_count field is
-	 * denominated in units of 1/8th bits. */
-	POOL_ENTROPY_SHIFT = 3,
-#define POOL_ENTROPY_BITS() (input_pool.entropy_count >> POOL_ENTROPY_SHIFT)
-	POOL_FRACBITS = POOL_BITS << POOL_ENTROPY_SHIFT,
-	POOL_MIN_FRACBITS = POOL_MIN_BITS << POOL_ENTROPY_SHIFT
+	POOL_MIN_BITS = POOL_BITS /* No point in settling for less. */
 };
 
 /*
@@ -309,7 +301,7 @@ static struct fasync_struct *fasync;
  * should wake up processes which are selecting or polling on write
  * access to /dev/random.
  */
-static int random_write_wakeup_bits = POOL_BITS * 3 / 4;
+static int random_write_wakeup_bits = POOL_MIN_BITS;
 
 static DEFINE_SPINLOCK(random_ready_list_lock);
 static LIST_HEAD(random_ready_list);
@@ -469,66 +461,18 @@ static void process_random_ready_list(vo
 static void credit_entropy_bits(int nbits)
 {
 	int entropy_count, orig;
-	int nfrac = nbits << POOL_ENTROPY_SHIFT;
-
-	/* Ensure that the multiplication can avoid being 64 bits wide. */
-	BUILD_BUG_ON(2 * (POOL_ENTROPY_SHIFT + POOL_BITSHIFT) > 31);
 
 	if (!nbits)
 		return;
 
-retry:
-	entropy_count = orig = READ_ONCE(input_pool.entropy_count);
-	if (nfrac < 0) {
-		/* Debit */
-		entropy_count += nfrac;
-	} else {
-		/*
-		 * Credit: we have to account for the possibility of
-		 * overwriting already present entropy.	 Even in the
-		 * ideal case of pure Shannon entropy, new contributions
-		 * approach the full value asymptotically:
-		 *
-		 * entropy <- entropy + (pool_size - entropy) *
-		 *	(1 - exp(-add_entropy/pool_size))
-		 *
-		 * For add_entropy <= pool_size/2 then
-		 * (1 - exp(-add_entropy/pool_size)) >=
-		 *    (add_entropy/pool_size)*0.7869...
-		 * so we can approximate the exponential with
-		 * 3/4*add_entropy/pool_size and still be on the
-		 * safe side by adding at most pool_size/2 at a time.
-		 *
-		 * The use of pool_size-2 in the while statement is to
-		 * prevent rounding artifacts from making the loop
-		 * arbitrarily long; this limits the loop to log2(pool_size)*2
-		 * turns no matter how large nbits is.
-		 */
-		int pnfrac = nfrac;
-		const int s = POOL_BITSHIFT + POOL_ENTROPY_SHIFT + 2;
-		/* The +2 corresponds to the /4 in the denominator */
-
-		do {
-			unsigned int anfrac = min(pnfrac, POOL_FRACBITS / 2);
-			unsigned int add =
-				((POOL_FRACBITS - entropy_count) * anfrac * 3) >> s;
-
-			entropy_count += add;
-			pnfrac -= anfrac;
-		} while (unlikely(entropy_count < POOL_FRACBITS - 2 && pnfrac));
-	}
-
-	if (WARN_ON(entropy_count < 0)) {
-		pr_warn("negative entropy/overflow: count %d\n", entropy_count);
-		entropy_count = 0;
-	} else if (entropy_count > POOL_FRACBITS)
-		entropy_count = POOL_FRACBITS;
-	if (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig)
-		goto retry;
+	do {
+		orig = READ_ONCE(input_pool.entropy_count);
+		entropy_count = min(POOL_BITS, orig + nbits);
+	} while (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig);
 
-	trace_credit_entropy_bits(nbits, entropy_count >> POOL_ENTROPY_SHIFT, _RET_IP_);
+	trace_credit_entropy_bits(nbits, entropy_count, _RET_IP_);
 
-	if (crng_init < 2 && entropy_count >= POOL_MIN_FRACBITS)
+	if (crng_init < 2 && entropy_count >= POOL_MIN_BITS)
 		crng_reseed(&primary_crng, true);
 }
 
@@ -791,7 +735,7 @@ static void crng_reseed(struct crng_stat
 		int entropy_count;
 		do {
 			entropy_count = READ_ONCE(input_pool.entropy_count);
-			if (entropy_count < POOL_MIN_FRACBITS)
+			if (entropy_count < POOL_MIN_BITS)
 				return;
 		} while (cmpxchg(&input_pool.entropy_count, entropy_count, 0) != entropy_count);
 		extract_entropy(buf.key, sizeof(buf.key));
@@ -1014,7 +958,7 @@ void add_input_randomness(unsigned int t
 	last_value = value;
 	add_timer_randomness(&input_timer_state,
 			     (type << 4) ^ code ^ (code >> 4) ^ value);
-	trace_add_input_randomness(POOL_ENTROPY_BITS());
+	trace_add_input_randomness(input_pool.entropy_count);
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
@@ -1112,7 +1056,7 @@ void add_disk_randomness(struct gendisk
 		return;
 	/* first major is 1, so we get >= 0x200 here */
 	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
-	trace_add_disk_randomness(disk_devt(disk), POOL_ENTROPY_BITS());
+	trace_add_disk_randomness(disk_devt(disk), input_pool.entropy_count);
 }
 EXPORT_SYMBOL_GPL(add_disk_randomness);
 #endif
@@ -1137,7 +1081,7 @@ static void extract_entropy(void *buf, s
 	} block;
 	size_t i;
 
-	trace_extract_entropy(nbytes, POOL_ENTROPY_BITS());
+	trace_extract_entropy(nbytes, input_pool.entropy_count);
 
 	for (i = 0; i < ARRAY_SIZE(block.rdrand); ++i) {
 		if (!arch_get_random_long(&block.rdrand[i]))
@@ -1486,9 +1430,9 @@ static ssize_t urandom_read_nowarn(struc
 {
 	int ret;
 
-	nbytes = min_t(size_t, nbytes, INT_MAX >> (POOL_ENTROPY_SHIFT + 3));
+	nbytes = min_t(size_t, nbytes, INT_MAX >> 6);
 	ret = extract_crng_user(buf, nbytes);
-	trace_urandom_read(8 * nbytes, 0, POOL_ENTROPY_BITS());
+	trace_urandom_read(8 * nbytes, 0, input_pool.entropy_count);
 	return ret;
 }
 
@@ -1527,7 +1471,7 @@ static __poll_t random_poll(struct file
 	mask = 0;
 	if (crng_ready())
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (POOL_ENTROPY_BITS() < random_write_wakeup_bits)
+	if (input_pool.entropy_count < random_write_wakeup_bits)
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	return mask;
 }
@@ -1582,8 +1526,7 @@ static long random_ioctl(struct file *f,
 	switch (cmd) {
 	case RNDGETENTCNT:
 		/* inherently racy, no point locking */
-		ent_count = POOL_ENTROPY_BITS();
-		if (put_user(ent_count, p))
+		if (put_user(input_pool.entropy_count, p))
 			return -EFAULT;
 		return 0;
 	case RNDADDTOENTCNT:
@@ -1734,23 +1677,6 @@ static int proc_do_uuid(struct ctl_table
 	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
 }
 
-/*
- * Return entropy available scaled to integral bits
- */
-static int proc_do_entropy(struct ctl_table *table, int write, void *buffer,
-			   size_t *lenp, loff_t *ppos)
-{
-	struct ctl_table fake_table;
-	int entropy_count;
-
-	entropy_count = *(int *)table->data >> POOL_ENTROPY_SHIFT;
-
-	fake_table.data = &entropy_count;
-	fake_table.maxlen = sizeof(entropy_count);
-
-	return proc_dointvec(&fake_table, write, buffer, lenp, ppos);
-}
-
 static int sysctl_poolsize = POOL_BITS;
 extern struct ctl_table random_table[];
 struct ctl_table random_table[] = {
@@ -1763,10 +1689,10 @@ struct ctl_table random_table[] = {
 	},
 	{
 		.procname	= "entropy_avail",
+		.data		= &input_pool.entropy_count,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= proc_do_entropy,
-		.data		= &input_pool.entropy_count,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "write_wakeup_threshold",
@@ -1962,7 +1888,7 @@ void add_hwgenerator_randomness(const ch
 	 */
 	wait_event_interruptible_timeout(random_write_wait,
 			!system_wq || kthread_should_stop() ||
-			POOL_ENTROPY_BITS() <= random_write_wakeup_bits,
+			input_pool.entropy_count <= random_write_wakeup_bits,
 			CRNG_RESEED_INTERVAL);
 	mix_pool_bytes(buffer, count);
 	credit_entropy_bits(entropy);


