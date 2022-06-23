Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1D755839B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiFWRcJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbiFWRaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926FC81246;
        Thu, 23 Jun 2022 10:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0259261CDC;
        Thu, 23 Jun 2022 17:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDB9C3411B;
        Thu, 23 Jun 2022 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003894;
        bh=dLvSZy6A7IPOKxdoZEFBBudOAiA7vgYayXov2WD+wBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZAKk3XX1apaLg/KaYIGBFRxS1Mm2gDIzNmlMkR7DYSklNI90cpsXlGI7Tpr/VgLU
         zchMFFoKRMtABVHmdeAChNVMwFjoaxCaBg1L2fBaJLchrUSP9gj2MJ2Lkrw0M3agjG
         4Pw2oCqO/6DnhTJiLEiQn2w85cQRVYVsVTYc24eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 120/237] random: unify early init crng load accounting
Date:   Thu, 23 Jun 2022 18:42:34 +0200
Message-Id: <20220623164346.607259192@linuxfoundation.org>
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

commit da792c6d5f59a76c10a310c5d4c93428fd18f996 upstream.

crng_fast_load() and crng_slow_load() have different semantics:

- crng_fast_load() xors and accounts with crng_init_cnt.
- crng_slow_load() hashes and doesn't account.

However add_hwgenerator_randomness() can afford to hash (it's called
from a kthread), and it should account. Additionally, ones that can
afford to hash don't need to take a trylock but can take a normal lock.
So, we combine these into one function, crng_pre_init_inject(), which
allows us to control these in a uniform way. This will make it simpler
later to simplify this all down when the time comes for that.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  114 +++++++++++++++++++++++++-------------------------
 1 file changed, 59 insertions(+), 55 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -384,7 +384,7 @@ static void crng_make_state(u32 chacha_s
 	 * For the fast path, we check whether we're ready, unlocked first, and
 	 * then re-check once locked later. In the case where we're really not
 	 * ready, we do fast key erasure with the base_crng directly, because
-	 * this is what crng_{fast,slow}_load mutate during early init.
+	 * this is what crng_pre_init_inject() mutates during early init.
 	 */
 	if (unlikely(!crng_ready())) {
 		bool ready;
@@ -435,72 +435,75 @@ static void crng_make_state(u32 chacha_s
 }
 
 /*
- * This function is for crng_init == 0 only.
+ * This function is for crng_init == 0 only. It loads entropy directly
+ * into the crng's key, without going through the input pool. It is,
+ * generally speaking, not very safe, but we use this only at early
+ * boot time when it's better to have something there rather than
+ * nothing.
+ *
+ * There are two paths, a slow one and a fast one. The slow one
+ * hashes the input along with the current key. The fast one simply
+ * xors it in, and should only be used from interrupt context.
+ *
+ * If account is set, then the crng_init_cnt counter is incremented.
+ * This shouldn't be set by functions like add_device_randomness(),
+ * where we can't trust the buffer passed to it is guaranteed to be
+ * unpredictable (so it might not have any entropy at all).
  *
- * crng_fast_load() can be called by code in the interrupt service
- * path.  So we can't afford to dilly-dally. Returns the number of
- * bytes processed from cp.
+ * Returns the number of bytes processed from input, which is bounded
+ * by CRNG_INIT_CNT_THRESH if account is true.
  */
-static size_t crng_fast_load(const void *cp, size_t len)
+static size_t crng_pre_init_inject(const void *input, size_t len,
+				   bool fast, bool account)
 {
 	static int crng_init_cnt = 0;
 	unsigned long flags;
-	const u8 *src = (const u8 *)cp;
-	size_t ret = 0;
 
-	if (!spin_trylock_irqsave(&base_crng.lock, flags))
-		return 0;
+	if (fast) {
+		if (!spin_trylock_irqsave(&base_crng.lock, flags))
+			return 0;
+	} else {
+		spin_lock_irqsave(&base_crng.lock, flags);
+	}
+
 	if (crng_init != 0) {
 		spin_unlock_irqrestore(&base_crng.lock, flags);
 		return 0;
 	}
-	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
-		base_crng.key[crng_init_cnt % sizeof(base_crng.key)] ^= *src;
-		src++; crng_init_cnt++; len--; ret++;
-	}
-	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
-		++base_crng.generation;
-		crng_init = 1;
-	}
-	spin_unlock_irqrestore(&base_crng.lock, flags);
-	if (crng_init == 1)
-		pr_notice("fast init done\n");
-	return ret;
-}
 
-/*
- * This function is for crng_init == 0 only.
- *
- * crng_slow_load() is called by add_device_randomness, which has two
- * attributes.  (1) We can't trust the buffer passed to it is
- * guaranteed to be unpredictable (so it might not have any entropy at
- * all), and (2) it doesn't have the performance constraints of
- * crng_fast_load().
- *
- * So, we simply hash the contents in with the current key. Finally,
- * we do *not* advance crng_init_cnt since buffer we may get may be
- * something like a fixed DMI table (for example), which might very
- * well be unique to the machine, but is otherwise unvarying.
- */
-static void crng_slow_load(const void *cp, size_t len)
-{
-	unsigned long flags;
-	struct blake2s_state hash;
+	if (account)
+		len = min_t(size_t, len, CRNG_INIT_CNT_THRESH - crng_init_cnt);
 
-	blake2s_init(&hash, sizeof(base_crng.key));
-
-	if (!spin_trylock_irqsave(&base_crng.lock, flags))
-		return;
-	if (crng_init != 0) {
-		spin_unlock_irqrestore(&base_crng.lock, flags);
-		return;
+	if (fast) {
+		const u8 *src = input;
+		size_t i;
+
+		for (i = 0; i < len; ++i)
+			base_crng.key[(crng_init_cnt + i) %
+				      sizeof(base_crng.key)] ^= src[i];
+	} else {
+		struct blake2s_state hash;
+
+		blake2s_init(&hash, sizeof(base_crng.key));
+		blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
+		blake2s_update(&hash, input, len);
+		blake2s_final(&hash, base_crng.key);
+	}
+
+	if (account) {
+		crng_init_cnt += len;
+		if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
+			++base_crng.generation;
+			crng_init = 1;
+		}
 	}
 
-	blake2s_update(&hash, base_crng.key, sizeof(base_crng.key));
-	blake2s_update(&hash, cp, len);
-	blake2s_final(&hash, base_crng.key);
-
 	spin_unlock_irqrestore(&base_crng.lock, flags);
+
+	if (crng_init == 1)
+		pr_notice("fast init done\n");
+
+	return len;
 }
 
 static void _get_random_bytes(void *buf, size_t nbytes)
@@ -1013,7 +1016,7 @@ void add_device_randomness(const void *b
 	unsigned long flags;
 
 	if (!crng_ready() && size)
-		crng_slow_load(buf, size);
+		crng_pre_init_inject(buf, size, false, false);
 
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(buf, size);
@@ -1130,7 +1133,7 @@ void add_hwgenerator_randomness(const vo
 				size_t entropy)
 {
 	if (unlikely(crng_init == 0)) {
-		size_t ret = crng_fast_load(buffer, count);
+		size_t ret = crng_pre_init_inject(buffer, count, false, true);
 		mix_pool_bytes(buffer, ret);
 		count -= ret;
 		buffer += ret;
@@ -1293,7 +1296,8 @@ void add_interrupt_randomness(int irq)
 
 	if (unlikely(crng_init == 0)) {
 		if (new_count >= 64 &&
-		    crng_fast_load(fast_pool->pool32, sizeof(fast_pool->pool32)) > 0) {
+		    crng_pre_init_inject(fast_pool->pool32, sizeof(fast_pool->pool32),
+					 true, true) > 0) {
 			atomic_set(&fast_pool->count, 0);
 			fast_pool->last = now;
 			if (spin_trylock(&input_pool.lock)) {


