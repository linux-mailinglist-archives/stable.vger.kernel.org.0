Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E5C65D829
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbjADQMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239676AbjADQLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:11:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42943DF5
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:11:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3142B8171C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A8DC433F0;
        Wed,  4 Jan 2023 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848662;
        bh=CFxyeFpt0ClMMeIclY5A7Gr+T0jxAsjGxRe7nPKnROU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFtcLBlU6Ea5ua53umLJuveDu3quePB4/33WZrIaQ09AQLu/GslApazNX0llucfuv
         j3xqrel9WCRFQzJd1nTaR6wVGiwi4ibpoqw54T8FEZIk4Lr+f4LSOHJtk2/CbOzpFy
         o0qlVWKFTJ+utFoFcm1baw6nD+vb9orAwR1SG6EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.1 025/207] random: use rejection sampling for uniform bounded random integers
Date:   Wed,  4 Jan 2023 17:04:43 +0100
Message-Id: <20230104160512.714458062@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit e9a688bcb19348862afe30d7c85bc37c4c293471 upstream.

Until the very recent commits, many bounded random integers were
calculated using `get_random_u32() % max_plus_one`, which not only
incurs the price of a division -- indicating performance mostly was not
a real issue -- but also does not result in a uniformly distributed
output if max_plus_one is not a power of two. Recent commits moved to
using `prandom_u32_max(max_plus_one)`, which replaces the division with
a faster multiplication, but still does not solve the issue with
non-uniform output.

For some users, maybe this isn't a problem, and for others, maybe it is,
but for the majority of users, probably the question has never been
posed and analyzed, and nobody thought much about it, probably assuming
random is random is random. In other words, the unthinking expectation
of most users is likely that the resultant numbers are uniform.

So we implement here an efficient way of generating uniform bounded
random integers. Through use of compile-time evaluation, and avoiding
divisions as much as possible, this commit introduces no measurable
overhead. At least for hot-path uses tested, any potential difference
was lost in the noise. On both clang and gcc, code generation is pretty
small.

The new function, get_random_u32_below(), lives in random.h, rather than
prandom.h, and has a "get_random_xxx" function name, because it is
suitable for all uses, including cryptography.

In order to be efficient, we implement a kernel-specific variant of
Daniel Lemire's algorithm from "Fast Random Integer Generation in an
Interval", linked below. The kernel's variant takes advantage of
constant folding to avoid divisions entirely in the vast majority of
cases, works on both 32-bit and 64-bit architectures, and requests a
minimal amount of bytes from the RNG.

Link: https://arxiv.org/pdf/1805.10941.pdf
Cc: stable@vger.kernel.org # to ease future backports that use this api
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c   |   22 ++++++++++++++++++++++
 include/linux/prandom.h |   18 ++----------------
 include/linux/random.h  |   40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 16 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -160,6 +160,7 @@ EXPORT_SYMBOL(wait_for_random_bytes);
  *	u8 get_random_u8()
  *	u16 get_random_u16()
  *	u32 get_random_u32()
+ *	u32 get_random_u32_below(u32 ceil)
  *	u64 get_random_u64()
  *	unsigned long get_random_long()
  *
@@ -510,6 +511,27 @@ DEFINE_BATCHED_ENTROPY(u16)
 DEFINE_BATCHED_ENTROPY(u32)
 DEFINE_BATCHED_ENTROPY(u64)
 
+u32 __get_random_u32_below(u32 ceil)
+{
+	/*
+	 * This is the slow path for variable ceil. It is still fast, most of
+	 * the time, by doing traditional reciprocal multiplication and
+	 * opportunistically comparing the lower half to ceil itself, before
+	 * falling back to computing a larger bound, and then rejecting samples
+	 * whose lower half would indicate a range indivisible by ceil. The use
+	 * of `-ceil % ceil` is analogous to `2^32 % ceil`, but is computable
+	 * in 32-bits.
+	 */
+	u64 mult = (u64)ceil * get_random_u32();
+	if (unlikely((u32)mult < ceil)) {
+		u32 bound = -ceil % ceil;
+		while (unlikely((u32)mult < bound))
+			mult = (u64)ceil * get_random_u32();
+	}
+	return mult >> 32;
+}
+EXPORT_SYMBOL(__get_random_u32_below);
+
 #ifdef CONFIG_SMP
 /*
  * This function is called when the CPU is coming up, with entry
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -23,24 +23,10 @@ void prandom_seed_full_state(struct rnd_
 #define prandom_init_once(pcpu_state)			\
 	DO_ONCE(prandom_seed_full_state, (pcpu_state))
 
-/**
- * prandom_u32_max - returns a pseudo-random number in interval [0, ep_ro)
- * @ep_ro: right open interval endpoint
- *
- * Returns a pseudo-random number that is in interval [0, ep_ro). This is
- * useful when requesting a random index of an array containing ep_ro elements,
- * for example. The result is somewhat biased when ep_ro is not a power of 2,
- * so do not use this for cryptographic purposes.
- *
- * Returns: pseudo-random number in interval [0, ep_ro)
- */
+/* Deprecated: use get_random_u32_below() instead. */
 static inline u32 prandom_u32_max(u32 ep_ro)
 {
-	if (__builtin_constant_p(ep_ro <= 1U << 8) && ep_ro <= 1U << 8)
-		return (get_random_u8() * ep_ro) >> 8;
-	if (__builtin_constant_p(ep_ro <= 1U << 16) && ep_ro <= 1U << 16)
-		return (get_random_u16() * ep_ro) >> 16;
-	return ((u64)get_random_u32() * ep_ro) >> 32;
+	return get_random_u32_below(ep_ro);
 }
 
 /*
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -51,6 +51,46 @@ static inline unsigned long get_random_l
 #endif
 }
 
+u32 __get_random_u32_below(u32 ceil);
+
+/*
+ * Returns a random integer in the interval [0, ceil), with uniform
+ * distribution, suitable for all uses. Fastest when ceil is a constant, but
+ * still fast for variable ceil as well.
+ */
+static inline u32 get_random_u32_below(u32 ceil)
+{
+	if (!__builtin_constant_p(ceil))
+		return __get_random_u32_below(ceil);
+
+	/*
+	 * For the fast path, below, all operations on ceil are precomputed by
+	 * the compiler, so this incurs no overhead for checking pow2, doing
+	 * divisions, or branching based on integer size. The resultant
+	 * algorithm does traditional reciprocal multiplication (typically
+	 * optimized by the compiler into shifts and adds), rejecting samples
+	 * whose lower half would indicate a range indivisible by ceil.
+	 */
+	BUILD_BUG_ON_MSG(!ceil, "get_random_u32_below() must take ceil > 0");
+	if (ceil <= 1)
+		return 0;
+	for (;;) {
+		if (ceil <= 1U << 8) {
+			u32 mult = ceil * get_random_u8();
+			if (likely(is_power_of_2(ceil) || (u8)mult >= (1U << 8) % ceil))
+				return mult >> 8;
+		} else if (ceil <= 1U << 16) {
+			u32 mult = ceil * get_random_u16();
+			if (likely(is_power_of_2(ceil) || (u16)mult >= (1U << 16) % ceil))
+				return mult >> 16;
+		} else {
+			u64 mult = (u64)ceil * get_random_u32();
+			if (likely(is_power_of_2(ceil) || (u32)mult >= -ceil % ceil))
+				return mult >> 32;
+		}
+	}
+}
+
 /*
  * On 64-bit architectures, protect against non-terminated C string overflows
  * by zeroing out the first byte of the canary; this leaves 56 bits of entropy.


