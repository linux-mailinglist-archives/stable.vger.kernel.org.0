Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949B45581E6
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiFWRIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiFWRGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:06:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A85DBC8E;
        Thu, 23 Jun 2022 09:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60303B82490;
        Thu, 23 Jun 2022 16:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D28EC3411B;
        Thu, 23 Jun 2022 16:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003321;
        bh=LWaXKuv9zEovAUhrJ+7iyk44JPUUX7Cfh0gTwOMBGwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fi4/ULKkQCi7XDhB71fOrW6pMfqB6ycsMv5hrdQxYkLV4gcmmHhOiSlQIrWYExCd0
         LZlGGS8Z+kFHpYjwsRUgEQNzNcLFNNBHxMwUdicoztbHUvu8PLyyfwnQBWxRtxn5lN
         6X7wlMbgfAFCq0j4UAOETDRYD7R0wXu1950xkRfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 199/264] siphash: use one source of truth for siphash permutations
Date:   Thu, 23 Jun 2022 18:43:12 +0200
Message-Id: <20220623164349.701721483@linuxfoundation.org>
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

commit e73aaae2fa9024832e1f42e30c787c7baf61d014 upstream.

The SipHash family of permutations is currently used in three places:

- siphash.c itself, used in the ordinary way it was intended.
- random32.c, in a construction from an anonymous contributor.
- random.c, as part of its fast_mix function.

Each one of these places reinvents the wheel with the same C code, same
rotation constants, and same symmetry-breaking constants.

This commit tidies things up a bit by placing macros for the
permutations and constants into siphash.h, where each of the three .c
users can access them. It also leaves a note dissuading more users of
them from emerging.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c   |   30 +++++++-----------------------
 include/linux/prandom.h |   23 +++++++----------------
 include/linux/siphash.h |   28 ++++++++++++++++++++++++++++
 lib/siphash.c           |   32 ++++++++++----------------------
 4 files changed, 52 insertions(+), 61 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -51,6 +51,7 @@
 #include <linux/syscalls.h>
 #include <linux/completion.h>
 #include <linux/uuid.h>
+#include <linux/siphash.h>
 #include <crypto/chacha20.h>
 #include <crypto/blake2s.h>
 #include <asm/processor.h>
@@ -1012,12 +1013,11 @@ struct fast_pool {
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
 #ifdef CONFIG_64BIT
-	/* SipHash constants */
-	.pool = { 0x736f6d6570736575UL, 0x646f72616e646f6dUL,
-		  0x6c7967656e657261UL, 0x7465646279746573UL }
+#define FASTMIX_PERM SIPHASH_PERMUTATION
+	.pool = { SIPHASH_CONST_0, SIPHASH_CONST_1, SIPHASH_CONST_2, SIPHASH_CONST_3 }
 #else
-	/* HalfSipHash constants */
-	.pool = { 0, 0, 0x6c796765U, 0x74656462U }
+#define FASTMIX_PERM HSIPHASH_PERMUTATION
+	.pool = { HSIPHASH_CONST_0, HSIPHASH_CONST_1, HSIPHASH_CONST_2, HSIPHASH_CONST_3 }
 #endif
 };
 
@@ -1029,27 +1029,11 @@ static DEFINE_PER_CPU(struct fast_pool,
  */
 static void fast_mix(unsigned long s[4], unsigned long v1, unsigned long v2)
 {
-#ifdef CONFIG_64BIT
-#define PERM() do { \
-	s[0] += s[1]; s[1] = rol64(s[1], 13); s[1] ^= s[0]; s[0] = rol64(s[0], 32); \
-	s[2] += s[3]; s[3] = rol64(s[3], 16); s[3] ^= s[2]; \
-	s[0] += s[3]; s[3] = rol64(s[3], 21); s[3] ^= s[0]; \
-	s[2] += s[1]; s[1] = rol64(s[1], 17); s[1] ^= s[2]; s[2] = rol64(s[2], 32); \
-} while (0)
-#else
-#define PERM() do { \
-	s[0] += s[1]; s[1] = rol32(s[1],  5); s[1] ^= s[0]; s[0] = rol32(s[0], 16); \
-	s[2] += s[3]; s[3] = rol32(s[3],  8); s[3] ^= s[2]; \
-	s[0] += s[3]; s[3] = rol32(s[3],  7); s[3] ^= s[0]; \
-	s[2] += s[1]; s[1] = rol32(s[1], 13); s[1] ^= s[2]; s[2] = rol32(s[2], 16); \
-} while (0)
-#endif
-
 	s[3] ^= v1;
-	PERM();
+	FASTMIX_PERM(s[0], s[1], s[2], s[3]);
 	s[0] ^= v1;
 	s[3] ^= v2;
-	PERM();
+	FASTMIX_PERM(s[0], s[1], s[2], s[3]);
 	s[0] ^= v2;
 }
 
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -10,6 +10,7 @@
 
 #include <linux/types.h>
 #include <linux/percpu.h>
+#include <linux/siphash.h>
 
 u32 prandom_u32(void);
 void prandom_bytes(void *buf, size_t nbytes);
@@ -21,15 +22,10 @@ void prandom_reseed_late(void);
  * The core SipHash round function.  Each line can be executed in
  * parallel given enough CPU resources.
  */
-#define PRND_SIPROUND(v0, v1, v2, v3) ( \
-	v0 += v1, v1 = rol64(v1, 13),  v2 += v3, v3 = rol64(v3, 16), \
-	v1 ^= v0, v0 = rol64(v0, 32),  v3 ^= v2,                     \
-	v0 += v3, v3 = rol64(v3, 21),  v2 += v1, v1 = rol64(v1, 17), \
-	v3 ^= v0,                      v1 ^= v2, v2 = rol64(v2, 32)  \
-)
+#define PRND_SIPROUND(v0, v1, v2, v3) SIPHASH_PERMUTATION(v0, v1, v2, v3)
 
-#define PRND_K0 (0x736f6d6570736575 ^ 0x6c7967656e657261)
-#define PRND_K1 (0x646f72616e646f6d ^ 0x7465646279746573)
+#define PRND_K0 (SIPHASH_CONST_0 ^ SIPHASH_CONST_2)
+#define PRND_K1 (SIPHASH_CONST_1 ^ SIPHASH_CONST_3)
 
 #elif BITS_PER_LONG == 32
 /*
@@ -37,14 +33,9 @@ void prandom_reseed_late(void);
  * This is weaker, but 32-bit machines are not used for high-traffic
  * applications, so there is less output for an attacker to analyze.
  */
-#define PRND_SIPROUND(v0, v1, v2, v3) ( \
-	v0 += v1, v1 = rol32(v1,  5),  v2 += v3, v3 = rol32(v3,  8), \
-	v1 ^= v0, v0 = rol32(v0, 16),  v3 ^= v2,                     \
-	v0 += v3, v3 = rol32(v3,  7),  v2 += v1, v1 = rol32(v1, 13), \
-	v3 ^= v0,                      v1 ^= v2, v2 = rol32(v2, 16)  \
-)
-#define PRND_K0 0x6c796765
-#define PRND_K1 0x74656462
+#define PRND_SIPROUND(v0, v1, v2, v3) HSIPHASH_PERMUTATION(v0, v1, v2, v3)
+#define PRND_K0 (HSIPHASH_CONST_0 ^ HSIPHASH_CONST_2)
+#define PRND_K1 (HSIPHASH_CONST_1 ^ HSIPHASH_CONST_3)
 
 #else
 #error Unsupported BITS_PER_LONG
--- a/include/linux/siphash.h
+++ b/include/linux/siphash.h
@@ -136,4 +136,32 @@ static inline u32 hsiphash(const void *d
 	return ___hsiphash_aligned(data, len, key);
 }
 
+/*
+ * These macros expose the raw SipHash and HalfSipHash permutations.
+ * Do not use them directly! If you think you have a use for them,
+ * be sure to CC the maintainer of this file explaining why.
+ */
+
+#define SIPHASH_PERMUTATION(a, b, c, d) ( \
+	(a) += (b), (b) = rol64((b), 13), (b) ^= (a), (a) = rol64((a), 32), \
+	(c) += (d), (d) = rol64((d), 16), (d) ^= (c), \
+	(a) += (d), (d) = rol64((d), 21), (d) ^= (a), \
+	(c) += (b), (b) = rol64((b), 17), (b) ^= (c), (c) = rol64((c), 32))
+
+#define SIPHASH_CONST_0 0x736f6d6570736575ULL
+#define SIPHASH_CONST_1 0x646f72616e646f6dULL
+#define SIPHASH_CONST_2 0x6c7967656e657261ULL
+#define SIPHASH_CONST_3 0x7465646279746573ULL
+
+#define HSIPHASH_PERMUTATION(a, b, c, d) ( \
+	(a) += (b), (b) = rol32((b), 5), (b) ^= (a), (a) = rol32((a), 16), \
+	(c) += (d), (d) = rol32((d), 8), (d) ^= (c), \
+	(a) += (d), (d) = rol32((d), 7), (d) ^= (a), \
+	(c) += (b), (b) = rol32((b), 13), (b) ^= (c), (c) = rol32((c), 16))
+
+#define HSIPHASH_CONST_0 0U
+#define HSIPHASH_CONST_1 0U
+#define HSIPHASH_CONST_2 0x6c796765U
+#define HSIPHASH_CONST_3 0x74656462U
+
 #endif /* _LINUX_SIPHASH_H */
--- a/lib/siphash.c
+++ b/lib/siphash.c
@@ -18,19 +18,13 @@
 #include <asm/word-at-a-time.h>
 #endif
 
-#define SIPROUND \
-	do { \
-	v0 += v1; v1 = rol64(v1, 13); v1 ^= v0; v0 = rol64(v0, 32); \
-	v2 += v3; v3 = rol64(v3, 16); v3 ^= v2; \
-	v0 += v3; v3 = rol64(v3, 21); v3 ^= v0; \
-	v2 += v1; v1 = rol64(v1, 17); v1 ^= v2; v2 = rol64(v2, 32); \
-	} while (0)
+#define SIPROUND SIPHASH_PERMUTATION(v0, v1, v2, v3)
 
 #define PREAMBLE(len) \
-	u64 v0 = 0x736f6d6570736575ULL; \
-	u64 v1 = 0x646f72616e646f6dULL; \
-	u64 v2 = 0x6c7967656e657261ULL; \
-	u64 v3 = 0x7465646279746573ULL; \
+	u64 v0 = SIPHASH_CONST_0; \
+	u64 v1 = SIPHASH_CONST_1; \
+	u64 v2 = SIPHASH_CONST_2; \
+	u64 v3 = SIPHASH_CONST_3; \
 	u64 b = ((u64)(len)) << 56; \
 	v3 ^= key->key[1]; \
 	v2 ^= key->key[0]; \
@@ -389,19 +383,13 @@ u32 hsiphash_4u32(const u32 first, const
 }
 EXPORT_SYMBOL(hsiphash_4u32);
 #else
-#define HSIPROUND \
-	do { \
-	v0 += v1; v1 = rol32(v1, 5); v1 ^= v0; v0 = rol32(v0, 16); \
-	v2 += v3; v3 = rol32(v3, 8); v3 ^= v2; \
-	v0 += v3; v3 = rol32(v3, 7); v3 ^= v0; \
-	v2 += v1; v1 = rol32(v1, 13); v1 ^= v2; v2 = rol32(v2, 16); \
-	} while (0)
+#define HSIPROUND HSIPHASH_PERMUTATION(v0, v1, v2, v3)
 
 #define HPREAMBLE(len) \
-	u32 v0 = 0; \
-	u32 v1 = 0; \
-	u32 v2 = 0x6c796765U; \
-	u32 v3 = 0x74656462U; \
+	u32 v0 = HSIPHASH_CONST_0; \
+	u32 v1 = HSIPHASH_CONST_1; \
+	u32 v2 = HSIPHASH_CONST_2; \
+	u32 v3 = HSIPHASH_CONST_3; \
 	u32 b = ((u32)(len)) << 24; \
 	v3 ^= key->key[1]; \
 	v2 ^= key->key[0]; \


