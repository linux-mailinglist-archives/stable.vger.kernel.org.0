Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BDB535FD7
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351617AbiE0LnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351627AbiE0Lmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:42:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D758F13C094;
        Fri, 27 May 2022 04:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E7C261C3F;
        Fri, 27 May 2022 11:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E99FC385A9;
        Fri, 27 May 2022 11:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651627;
        bh=xZ9N0in4G15OcftiGqivaOgy9jmbWqCjama5P7l+R9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXqBp9fbgzxZnnqStbGka3zwgjHCA5PFXoCZ4gLqOXfvG7JQ3hPfvCdPBgtXXd4bg
         vyyroVVEZ31uJREamgK/ycBTnUVEIjIKdUOSOqzFcJGeIEnV4OsIcIo8SJ2Fh+TNZ9
         W4e3tYdslEpJLcOW+1Mfc2cnRz5n331ofZyLhhCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 041/163] random: cleanup poolinfo abstraction
Date:   Fri, 27 May 2022 10:48:41 +0200
Message-Id: <20220527084833.782422819@linuxfoundation.org>
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

commit 91ec0fe138f107232cb36bc6112211db37cb5306 upstream.

Now that we're only using one polynomial, we can cleanup its
representation into constants, instead of passing around pointers
dynamically to select different polynomials. This improves the codegen
and makes the code a bit more straightforward.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   67 ++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 37 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -430,14 +430,20 @@ static int random_write_wakeup_bits = 28
  * polynomial which improves the resulting TGFSR polynomial to be
  * irreducible, which we have made here.
  */
-static const struct poolinfo {
-	int poolbitshift, poolwords, poolbytes, poolfracbits;
-#define S(x) ilog2(x)+5, (x), (x)*4, (x) << (ENTROPY_SHIFT+5)
-	int tap1, tap2, tap3, tap4, tap5;
-} poolinfo_table[] = {
-	/* was: x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 */
+enum poolinfo {
+	POOL_WORDS = 128,
+	POOL_WORDMASK = POOL_WORDS - 1,
+	POOL_BYTES = POOL_WORDS * sizeof(u32),
+	POOL_BITS = POOL_BYTES * 8,
+	POOL_BITSHIFT = ilog2(POOL_WORDS) + 5,
+	POOL_FRACBITS = POOL_WORDS << (ENTROPY_SHIFT + 5),
+
 	/* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
-	{ S(128),	104,	76,	51,	25,	1 },
+	POOL_TAP1 = 104,
+	POOL_TAP2 = 76,
+	POOL_TAP3 = 51,
+	POOL_TAP4 = 25,
+	POOL_TAP5 = 1
 };
 
 /*
@@ -503,7 +509,6 @@ MODULE_PARM_DESC(ratelimit_disable, "Dis
 struct entropy_store;
 struct entropy_store {
 	/* read-only data: */
-	const struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
 
@@ -525,7 +530,6 @@ static void crng_reseed(struct crng_stat
 static __u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
 
 static struct entropy_store input_pool = {
-	.poolinfo = &poolinfo_table[0],
 	.name = "input",
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
 	.pool = input_pool_data
@@ -548,33 +552,26 @@ static __u32 const twist_table[8] = {
 static void _mix_pool_bytes(struct entropy_store *r, const void *in,
 			    int nbytes)
 {
-	unsigned long i, tap1, tap2, tap3, tap4, tap5;
+	unsigned long i;
 	int input_rotate;
-	int wordmask = r->poolinfo->poolwords - 1;
 	const unsigned char *bytes = in;
 	__u32 w;
 
-	tap1 = r->poolinfo->tap1;
-	tap2 = r->poolinfo->tap2;
-	tap3 = r->poolinfo->tap3;
-	tap4 = r->poolinfo->tap4;
-	tap5 = r->poolinfo->tap5;
-
 	input_rotate = r->input_rotate;
 	i = r->add_ptr;
 
 	/* mix one byte at a time to simplify size handling and churn faster */
 	while (nbytes--) {
 		w = rol32(*bytes++, input_rotate);
-		i = (i - 1) & wordmask;
+		i = (i - 1) & POOL_WORDMASK;
 
 		/* XOR in the various taps */
 		w ^= r->pool[i];
-		w ^= r->pool[(i + tap1) & wordmask];
-		w ^= r->pool[(i + tap2) & wordmask];
-		w ^= r->pool[(i + tap3) & wordmask];
-		w ^= r->pool[(i + tap4) & wordmask];
-		w ^= r->pool[(i + tap5) & wordmask];
+		w ^= r->pool[(i + POOL_TAP1) & POOL_WORDMASK];
+		w ^= r->pool[(i + POOL_TAP2) & POOL_WORDMASK];
+		w ^= r->pool[(i + POOL_TAP3) & POOL_WORDMASK];
+		w ^= r->pool[(i + POOL_TAP4) & POOL_WORDMASK];
+		w ^= r->pool[(i + POOL_TAP5) & POOL_WORDMASK];
 
 		/* Mix the result back in with a twist */
 		r->pool[i] = (w >> 3) ^ twist_table[w & 7];
@@ -672,7 +669,6 @@ static void process_random_ready_list(vo
 static void credit_entropy_bits(struct entropy_store *r, int nbits)
 {
 	int entropy_count, orig;
-	const int pool_size = r->poolinfo->poolfracbits;
 	int nfrac = nbits << ENTROPY_SHIFT;
 
 	if (!nbits)
@@ -706,25 +702,25 @@ retry:
 		 * turns no matter how large nbits is.
 		 */
 		int pnfrac = nfrac;
-		const int s = r->poolinfo->poolbitshift + ENTROPY_SHIFT + 2;
+		const int s = POOL_BITSHIFT + ENTROPY_SHIFT + 2;
 		/* The +2 corresponds to the /4 in the denominator */
 
 		do {
-			unsigned int anfrac = min(pnfrac, pool_size/2);
+			unsigned int anfrac = min(pnfrac, POOL_FRACBITS/2);
 			unsigned int add =
-				((pool_size - entropy_count)*anfrac*3) >> s;
+				((POOL_FRACBITS - entropy_count)*anfrac*3) >> s;
 
 			entropy_count += add;
 			pnfrac -= anfrac;
-		} while (unlikely(entropy_count < pool_size-2 && pnfrac));
+		} while (unlikely(entropy_count < POOL_FRACBITS-2 && pnfrac));
 	}
 
 	if (WARN_ON(entropy_count < 0)) {
 		pr_warn("negative entropy/overflow: pool %s count %d\n",
 			r->name, entropy_count);
 		entropy_count = 0;
-	} else if (entropy_count > pool_size)
-		entropy_count = pool_size;
+	} else if (entropy_count > POOL_FRACBITS)
+		entropy_count = POOL_FRACBITS;
 	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
@@ -741,13 +737,11 @@ retry:
 
 static int credit_entropy_bits_safe(struct entropy_store *r, int nbits)
 {
-	const int nbits_max = r->poolinfo->poolwords * 32;
-
 	if (nbits < 0)
 		return -EINVAL;
 
 	/* Cap the value to avoid overflows */
-	nbits = min(nbits,  nbits_max);
+	nbits = min(nbits,  POOL_BITS);
 
 	credit_entropy_bits(r, nbits);
 	return 0;
@@ -1343,7 +1337,7 @@ static size_t account(struct entropy_sto
 	int entropy_count, orig, have_bytes;
 	size_t ibytes, nfrac;
 
-	BUG_ON(r->entropy_count > r->poolinfo->poolfracbits);
+	BUG_ON(r->entropy_count > POOL_FRACBITS);
 
 	/* Can we pull enough? */
 retry:
@@ -1409,8 +1403,7 @@ static void extract_buf(struct entropy_s
 
 	/* Generate a hash across the pool */
 	spin_lock_irqsave(&r->lock, flags);
-	blake2s_update(&state, (const u8 *)r->pool,
-		       r->poolinfo->poolwords * sizeof(*r->pool));
+	blake2s_update(&state, (const u8 *)r->pool, POOL_BYTES);
 	blake2s_final(&state, hash); /* final zeros out state */
 
 	/*
@@ -1766,7 +1759,7 @@ static void __init init_std_data(struct
 	unsigned long rv;
 
 	mix_pool_bytes(r, &now, sizeof(now));
-	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
+	for (i = POOL_BYTES; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_seed_long(&rv) &&
 		    !arch_get_random_long(&rv))
 			rv = random_get_entropy();


