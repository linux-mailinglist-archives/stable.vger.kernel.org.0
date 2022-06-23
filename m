Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811C05583B1
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbiFWRdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiFWRcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:32:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AC586AEA;
        Thu, 23 Jun 2022 10:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 955E8B824B6;
        Thu, 23 Jun 2022 17:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6711C3411B;
        Thu, 23 Jun 2022 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003933;
        bh=wgBZuM0YgqkDuk+jtG9Ad3gBC9bO4wKsXjCahE36Hog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJhrozld6LWepL0phbyQoMyPLDI+DH+hfFkoVqAVKLeCYrcqYSqiwm4RBM8uhiCsk
         m3DFCMlKun2Fct37SjuFPTlUgZAXAFv8/IDmqrYIn59zwF7yXnm6romVonqFrlEHSW
         jrRtbeRc2/xJeq6uuNngBQwSnOra6sNPJB410lJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 132/237] random: use SipHash as interrupt entropy accumulator
Date:   Thu, 23 Jun 2022 18:42:46 +0200
Message-Id: <20220623164346.952446092@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

commit f5eab0e2db4f881fb2b62b3fdad5b9be673dd7ae upstream.

The current fast_mix() function is a piece of classic mailing list
crypto, where it just sort of sprung up by an anonymous author without a
lot of real analysis of what precisely it was accomplishing. As an ARX
permutation alone, there are some easily searchable differential trails
in it, and as a means of preventing malicious interrupts, it completely
fails, since it xors new data into the entire state every time. It can't
really be analyzed as a random permutation, because it clearly isn't,
and it can't be analyzed as an interesting linear algebraic structure
either, because it's also not that. There really is very little one can
say about it in terms of entropy accumulation. It might diffuse bits,
some of the time, maybe, we hope, I guess. But for the most part, it
fails to accomplish anything concrete.

As a reminder, the simple goal of add_interrupt_randomness() is to
simply accumulate entropy until ~64 interrupts have elapsed, and then
dump it into the main input pool, which uses a cryptographic hash.

It would be nice to have something cryptographically strong in the
interrupt handler itself, in case a malicious interrupt compromises a
per-cpu fast pool within the 64 interrupts / 1 second window, and then
inside of that same window somehow can control its return address and
cycle counter, even if that's a bit far fetched. However, with a very
CPU-limited budget, actually doing that remains an active research
project (and perhaps there'll be something useful for Linux to come out
of it). And while the abundance of caution would be nice, this isn't
*currently* the security model, and we don't yet have a fast enough
solution to make it our security model. Plus there's not exactly a
pressing need to do that. (And for the avoidance of doubt, the actual
cluster of 64 accumulated interrupts still gets dumped into our
cryptographically secure input pool.)

So, for now we are going to stick with the existing interrupt security
model, which assumes that each cluster of 64 interrupt data samples is
mostly non-malicious and not colluding with an infoleaker. With this as
our goal, we have a few more choices, simply aiming to accumulate
entropy, while discarding the least amount of it.

We know from <https://eprint.iacr.org/2019/198> that random oracles,
instantiated as computational hash functions, make good entropy
accumulators and extractors, which is the justification for using
BLAKE2s in the main input pool. As mentioned, we don't have that luxury
here, but we also don't have the same security model requirements,
because we're assuming that there aren't malicious inputs. A
pseudorandom function instance can approximately behave like a random
oracle, provided that the key is uniformly random. But since we're not
concerned with malicious inputs, we can pick a fixed key, which is not
secret, knowing that "nature" won't interact with a sufficiently chosen
fixed key by accident. So we pick a PRF with a fixed initial key, and
accumulate into it continuously, dumping the result every 64 interrupts
into our cryptographically secure input pool.

For this, we make use of SipHash-1-x on 64-bit and HalfSipHash-1-x on
32-bit, which are already in use in the kernel's hsiphash family of
functions and achieve the same performance as the function they replace.
It would be nice to do two rounds, but we don't exactly have the CPU
budget handy for that, and one round alone is already sufficient.

As mentioned, we start with a fixed initial key (zeros is fine), and
allow SipHash's symmetry breaking constants to turn that into a useful
starting point. Also, since we're dumping the result (or half of it on
64-bit so as to tax our hash function the same amount on all platforms)
into the cryptographically secure input pool, there's no point in
finalizing SipHash's output, since it'll wind up being finalized by
something much stronger. This means that all we need to do is use the
ordinary round function word-by-word, as normal SipHash does.
Simplified, the flow is as follows:

Initialize:

    siphash_state_t state;
    siphash_init(&state, key={0, 0, 0, 0});

Update (accumulate) on interrupt:

    siphash_update(&state, interrupt_data_and_timing);

Dump into input pool after 64 interrupts:

    blake2s_update(&input_pool, &state, sizeof(state) / 2);

The result of all of this is that the security model is unchanged from
before -- we assume non-malicious inputs -- yet we now implement that
model with a stronger argument. I would like to emphasize, again, that
the purpose of this commit is to improve the existing design, by making
it analyzable, without changing any fundamental assumptions. There may
well be value down the road in changing up the existing design, using
something cryptographically strong, or simply using a ring buffer of
samples rather than having a fast_mix() at all, or changing which and
how much data we collect each interrupt so that we can use something
linear, or a variety of other ideas. This commit does not invalidate the
potential for those in the future.

For example, in the future, if we're able to characterize the data we're
collecting on each interrupt, we may be able to inch toward information
theoretic accumulators. <https://eprint.iacr.org/2021/523> shows that `s
= ror32(s, 7) ^ x` and `s = ror64(s, 19) ^ x` make very good
accumulators for 2-monotone distributions, which would apply to
timestamp counters, like random_get_entropy() or jiffies, but would not
apply to our current combination of the two values, or to the various
function addresses and register values we mix in. Alternatively,
<https://eprint.iacr.org/2021/1002> shows that max-period linear
functions with no non-trivial invariant subspace make good extractors,
used in the form `s = f(s) ^ x`. However, this only works if the input
data is both identical and independent, and obviously a collection of
address values and counters fails; so it goes with theoretical papers.
Future directions here may involve trying to characterize more precisely
what we actually need to collect in the interrupt handler, and building
something specific around that.

However, as mentioned, the morass of data we're gathering at the
interrupt handler presently defies characterization, and so we use
SipHash for now, which works well and performs well.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   94 +++++++++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 39 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1142,48 +1142,51 @@ void add_bootloader_randomness(const voi
 EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
 struct fast_pool {
-	union {
-		u32 pool32[4];
-		u64 pool64[2];
-	};
 	struct work_struct mix;
+	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
 	u16 reg_idx;
 };
 
+static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
+#ifdef CONFIG_64BIT
+	/* SipHash constants */
+	.pool = { 0x736f6d6570736575UL, 0x646f72616e646f6dUL,
+		  0x6c7967656e657261UL, 0x7465646279746573UL }
+#else
+	/* HalfSipHash constants */
+	.pool = { 0, 0, 0x6c796765U, 0x74656462U }
+#endif
+};
+
 /*
- * This is a fast mixing routine used by the interrupt randomness
- * collector. It's hardcoded for an 128 bit pool and assumes that any
- * locks that might be needed are taken by the caller.
+ * This is [Half]SipHash-1-x, starting from an empty key. Because
+ * the key is fixed, it assumes that its inputs are non-malicious,
+ * and therefore this has no security on its own. s represents the
+ * 128 or 256-bit SipHash state, while v represents a 128-bit input.
  */
-static void fast_mix(u32 pool[4])
+static void fast_mix(unsigned long s[4], const unsigned long *v)
 {
-	u32 a = pool[0],	b = pool[1];
-	u32 c = pool[2],	d = pool[3];
-
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 6);	d = rol32(d, 27);
-	d ^= a;			b ^= c;
-
-	a += b;			c += d;
-	b = rol32(b, 16);	d = rol32(d, 14);
-	d ^= a;			b ^= c;
+	size_t i;
 
-	pool[0] = a;  pool[1] = b;
-	pool[2] = c;  pool[3] = d;
+	for (i = 0; i < 16 / sizeof(long); ++i) {
+		s[3] ^= v[i];
+#ifdef CONFIG_64BIT
+		s[0] += s[1]; s[1] = rol64(s[1], 13); s[1] ^= s[0]; s[0] = rol64(s[0], 32);
+		s[2] += s[3]; s[3] = rol64(s[3], 16); s[3] ^= s[2];
+		s[0] += s[3]; s[3] = rol64(s[3], 21); s[3] ^= s[0];
+		s[2] += s[1]; s[1] = rol64(s[1], 17); s[1] ^= s[2]; s[2] = rol64(s[2], 32);
+#else
+		s[0] += s[1]; s[1] = rol32(s[1],  5); s[1] ^= s[0]; s[0] = rol32(s[0], 16);
+		s[2] += s[3]; s[3] = rol32(s[3],  8); s[3] ^= s[2];
+		s[0] += s[3]; s[3] = rol32(s[3],  7); s[3] ^= s[0];
+		s[2] += s[1]; s[1] = rol32(s[1], 13); s[1] ^= s[2]; s[2] = rol32(s[2], 16);
+#endif
+		s[0] ^= v[i];
+	}
 }
 
-static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
-
 #ifdef CONFIG_SMP
 /*
  * This function is called when the CPU has just come online, with
@@ -1225,7 +1228,15 @@ static unsigned long get_reg(struct fast
 static void mix_interrupt_randomness(struct work_struct *work)
 {
 	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
-	u32 pool[4];
+	/*
+	 * The size of the copied stack pool is explicitly 16 bytes so that we
+	 * tax mix_pool_byte()'s compression function the same amount on all
+	 * platforms. This means on 64-bit we copy half the pool into this,
+	 * while on 32-bit we copy all of it. The entropy is supposed to be
+	 * sufficiently dispersed between bits that in the sponge-like
+	 * half case, on average we don't wind up "losing" some.
+	 */
+	u8 pool[16];
 
 	/* Check to see if we're running on the wrong CPU due to hotplug. */
 	local_irq_disable();
@@ -1238,7 +1249,7 @@ static void mix_interrupt_randomness(str
 	 * Copy the pool to the stack so that the mixer always has a
 	 * consistent view, before we reenable irqs again.
 	 */
-	memcpy(pool, fast_pool->pool32, sizeof(pool));
+	memcpy(pool, fast_pool->pool, sizeof(pool));
 	fast_pool->count = 0;
 	fast_pool->last = jiffies;
 	local_irq_enable();
@@ -1262,25 +1273,30 @@ void add_interrupt_randomness(int irq)
 	struct fast_pool *fast_pool = this_cpu_ptr(&irq_randomness);
 	struct pt_regs *regs = get_irq_regs();
 	unsigned int new_count;
+	union {
+		u32 u32[4];
+		u64 u64[2];
+		unsigned long longs[16 / sizeof(long)];
+	} irq_data;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
 
 	if (sizeof(cycles) == 8)
-		fast_pool->pool64[0] ^= cycles ^ rol64(now, 32) ^ irq;
+		irq_data.u64[0] = cycles ^ rol64(now, 32) ^ irq;
 	else {
-		fast_pool->pool32[0] ^= cycles ^ irq;
-		fast_pool->pool32[1] ^= now;
+		irq_data.u32[0] = cycles ^ irq;
+		irq_data.u32[1] = now;
 	}
 
 	if (sizeof(unsigned long) == 8)
-		fast_pool->pool64[1] ^= regs ? instruction_pointer(regs) : _RET_IP_;
+		irq_data.u64[1] = regs ? instruction_pointer(regs) : _RET_IP_;
 	else {
-		fast_pool->pool32[2] ^= regs ? instruction_pointer(regs) : _RET_IP_;
-		fast_pool->pool32[3] ^= get_reg(fast_pool, regs);
+		irq_data.u32[2] = regs ? instruction_pointer(regs) : _RET_IP_;
+		irq_data.u32[3] = get_reg(fast_pool, regs);
 	}
 
-	fast_mix(fast_pool->pool32);
+	fast_mix(fast_pool->pool, irq_data.longs);
 	new_count = ++fast_pool->count;
 
 	if (new_count & MIX_INFLIGHT)


