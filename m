Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA965580C7
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbiFWQx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbiFWQvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6884CD57;
        Thu, 23 Jun 2022 09:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E3AE61F99;
        Thu, 23 Jun 2022 16:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383E8C3411B;
        Thu, 23 Jun 2022 16:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002981;
        bh=xF1zfET0DsadiAe917KXbazTNtsjP7wJjr9d42aga+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKTWoVzGXwtHv+3mCIIN0HIH+3d6fH85ijT2uDMtUhQxCxTA6sV73tuT/HfM8ipuG
         mu39Jah8WS63QJ8IdVLYegzcVsoqJ4N6javDtr1nEcKIXnBdqWnQrODLTY0AneGuQP
         kMIABEcH5vbz1wybNpBN3s4USQ03Cw7/hjJx4hZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 083/264] random: use BLAKE2s instead of SHA1 in extraction
Date:   Thu, 23 Jun 2022 18:41:16 +0200
Message-Id: <20220623164346.418938663@linuxfoundation.org>
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

commit 9f9eff85a008b095eafc5f4ecbaf5aca689271c1 upstream.

This commit addresses one of the lower hanging fruits of the RNG: its
usage of SHA1.

BLAKE2s is generally faster, and certainly more secure, than SHA1, which
has [1] been [2] really [3] very [4] broken [5]. Additionally, the
current construction in the RNG doesn't use the full SHA1 function, as
specified, and allows overwriting the IV with RDRAND output in an
undocumented way, even in the case when RDRAND isn't set to "trusted",
which means potential malicious IV choices. And its short length means
that keeping only half of it secret when feeding back into the mixer
gives us only 2^80 bits of forward secrecy. In other words, not only is
the choice of hash function dated, but the use of it isn't really great
either.

This commit aims to fix both of these issues while also keeping the
general structure and semantics as close to the original as possible.
Specifically:

   a) Rather than overwriting the hash IV with RDRAND, we put it into
      BLAKE2's documented "salt" and "personal" fields, which were
      specifically created for this type of usage.
   b) Since this function feeds the full hash result back into the
      entropy collector, we only return from it half the length of the
      hash, just as it was done before. This increases the
      construction's forward secrecy from 2^80 to a much more
      comfortable 2^128.
   c) Rather than using the raw "sha1_transform" function alone, we
      instead use the full proper BLAKE2s function, with finalization.

This also has the advantage of supplying 16 bytes at a time rather than
SHA1's 10 bytes, which, in addition to having a faster compression
function to begin with, means faster extraction in general. On an Intel
i7-11850H, this commit makes initial seeding around 131% faster.

BLAKE2s itself has the nice property of internally being based on the
ChaCha permutation, which the RNG is already using for expansion, so
there shouldn't be any issue with newness, funkiness, or surprising CPU
behavior, since it's based on something already in use.

[1] https://eprint.iacr.org/2005/010.pdf
[2] https://www.iacr.org/archive/crypto2005/36210017/36210017.pdf
[3] https://eprint.iacr.org/2015/967.pdf
[4] https://shattered.io/static/shattered.pdf
[5] https://www.usenix.org/system/files/sec20-leurent.pdf

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   70 +++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 40 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1,8 +1,7 @@
 /*
  * random.c -- A strong random number generator
  *
- * Copyright (C) 2017 Jason A. Donenfeld <Jason@zx2c4.com>. All
- * Rights Reserved.
+ * Copyright (C) 2017-2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  *
  * Copyright Matt Mackall <mpm@selenic.com>, 2003, 2004, 2005
  *
@@ -78,12 +77,12 @@
  * an *estimate* of how many bits of randomness have been stored into
  * the random number generator's internal state.
  *
- * When random bytes are desired, they are obtained by taking the SHA
- * hash of the contents of the "entropy pool".  The SHA hash avoids
+ * When random bytes are desired, they are obtained by taking the BLAKE2s
+ * hash of the contents of the "entropy pool".  The BLAKE2s hash avoids
  * exposing the internal state of the entropy pool.  It is believed to
  * be computationally infeasible to derive any useful information
- * about the input of SHA from its output.  Even if it is possible to
- * analyze SHA in some clever way, as long as the amount of data
+ * about the input of BLAKE2s from its output.  Even if it is possible to
+ * analyze BLAKE2s in some clever way, as long as the amount of data
  * returned from the generator is less than the inherent entropy in
  * the pool, the output data is totally unpredictable.  For this
  * reason, the routine decreases its internal estimate of how many
@@ -93,7 +92,7 @@
  * If this estimate goes to zero, the routine can still generate
  * random numbers; however, an attacker may (at least in theory) be
  * able to infer the future output of the generator from prior
- * outputs.  This requires successful cryptanalysis of SHA, which is
+ * outputs.  This requires successful cryptanalysis of BLAKE2s, which is
  * not believed to be feasible, but there is a remote possibility.
  * Nonetheless, these numbers should be useful for the vast majority
  * of purposes.
@@ -349,6 +348,7 @@
 #include <linux/completion.h>
 #include <linux/uuid.h>
 #include <crypto/chacha20.h>
+#include <crypto/blake2s.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -368,10 +368,7 @@
 #define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
 #define OUTPUT_POOL_SHIFT	10
 #define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
-#define EXTRACT_SIZE		10
-
-
-#define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
+#define EXTRACT_SIZE		(BLAKE2S_HASH_SIZE / 2)
 
 /*
  * To allow fractional bits to be tracked, the entropy_count field is
@@ -407,7 +404,7 @@ static int random_write_wakeup_bits = 28
  * Thanks to Colin Plumb for suggesting this.
  *
  * The mixing operation is much less sensitive than the output hash,
- * where we use SHA-1.  All that we want of mixing operation is that
+ * where we use BLAKE2s.  All that we want of mixing operation is that
  * it be a good non-cryptographic hash; i.e. it not produce collisions
  * when fed "random" data of the sort we expect to see.  As long as
  * the pool state differs for different inputs, we have preserved the
@@ -1449,56 +1446,49 @@ retry:
  */
 static void extract_buf(struct entropy_store *r, __u8 *out)
 {
-	int i;
-	union {
-		__u32 w[5];
-		unsigned long l[LONGS(20)];
-	} hash;
-	__u32 workspace[SHA_WORKSPACE_WORDS];
+	struct blake2s_state state __aligned(__alignof__(unsigned long));
+	u8 hash[BLAKE2S_HASH_SIZE];
+	unsigned long *salt;
 	unsigned long flags;
 
+	blake2s_init(&state, sizeof(hash));
+
 	/*
 	 * If we have an architectural hardware random number
-	 * generator, use it for SHA's initial vector
+	 * generator, use it for BLAKE2's salt & personal fields.
 	 */
-	sha_init(hash.w);
-	for (i = 0; i < LONGS(20); i++) {
+	for (salt = (unsigned long *)&state.h[4];
+	     salt < (unsigned long *)&state.h[8]; ++salt) {
 		unsigned long v;
 		if (!arch_get_random_long(&v))
 			break;
-		hash.l[i] = v;
+		*salt ^= v;
 	}
 
-	/* Generate a hash across the pool, 16 words (512 bits) at a time */
+	/* Generate a hash across the pool */
 	spin_lock_irqsave(&r->lock, flags);
-	for (i = 0; i < r->poolinfo->poolwords; i += 16)
-		sha_transform(hash.w, (__u8 *)(r->pool + i), workspace);
+	blake2s_update(&state, (const u8 *)r->pool,
+		       r->poolinfo->poolwords * sizeof(*r->pool));
+	blake2s_final(&state, hash); /* final zeros out state */
 
 	/*
 	 * We mix the hash back into the pool to prevent backtracking
 	 * attacks (where the attacker knows the state of the pool
 	 * plus the current outputs, and attempts to find previous
-	 * ouputs), unless the hash function can be inverted. By
-	 * mixing at least a SHA1 worth of hash data back, we make
+	 * outputs), unless the hash function can be inverted. By
+	 * mixing at least a hash worth of hash data back, we make
 	 * brute-forcing the feedback as hard as brute-forcing the
 	 * hash.
 	 */
-	__mix_pool_bytes(r, hash.w, sizeof(hash.w));
+	__mix_pool_bytes(r, hash, sizeof(hash));
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	memzero_explicit(workspace, sizeof(workspace));
-
-	/*
-	 * In case the hash function has some recognizable output
-	 * pattern, we fold it in half. Thus, we always feed back
-	 * twice as much data as we output.
+	/* Note that EXTRACT_SIZE is half of hash size here, because above
+	 * we've dumped the full length back into mixer. By reducing the
+	 * amount that we emit, we retain a level of forward secrecy.
 	 */
-	hash.w[0] ^= hash.w[3];
-	hash.w[1] ^= hash.w[4];
-	hash.w[2] ^= rol32(hash.w[2], 16);
-
-	memcpy(out, &hash, EXTRACT_SIZE);
-	memzero_explicit(&hash, sizeof(hash));
+	memcpy(out, hash, EXTRACT_SIZE);
+	memzero_explicit(hash, sizeof(hash));
 }
 
 static ssize_t _extract_entropy(struct entropy_store *r, void *buf,


