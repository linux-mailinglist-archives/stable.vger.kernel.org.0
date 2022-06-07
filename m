Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C565361B9
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345337AbiE0MHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353658AbiE0MGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:06:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2541166888;
        Fri, 27 May 2022 04:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B48AEB8091D;
        Fri, 27 May 2022 11:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29336C385A9;
        Fri, 27 May 2022 11:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652509;
        bh=a1325iiTRt3uoSvhs7UFiDu+NUMt3odXV5Q1QN3rOtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfR8JU2ZqoC5DuDQKD67F6Wa4fn80cgKgbnlFgI9OTWRYjL/IUrS4+dXpi2KP1I6K
         iHxFlOB/lofnL2HH7YTTq+vEI+ELLoRCCQ1NrMwq+Pwrhbbic2JIcnnw5WsJyB5xha
         vb2FMsfV+x5YAjwgsK5/KoUxsG07RFRnK+fMLRHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 158/163] random: unify batched entropy implementations
Date:   Fri, 27 May 2022 10:50:38 +0200
Message-Id: <20220527084850.181828523@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 3092adcef3ffd2ef59634998297ca8358461ebce upstream.

There are currently two separate batched entropy implementations, for
u32 and u64, with nearly identical code, with the goal of avoiding
unaligned memory accesses and letting the buffers be used more
efficiently. Having to maintain these two functions independently is a
bit of a hassle though, considering that they always need to be kept in
sync.

This commit factors them out into a type-generic macro, so that the
expansion produces the same code as before, such that diffing the
assembly shows no differences. This will also make it easier in the
future to add u16 and u8 batches.

This was initially tested using an always_inline function and letting
gcc constant fold the type size in, but the code gen was less efficient,
and in general it was more verbose and harder to follow. So this patch
goes with the boring macro solution, similar to what's already done for
the _wait functions in random.h.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  145 ++++++++++++++++++--------------------------------
 1 file changed, 54 insertions(+), 91 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -511,99 +511,62 @@ out_zero_chacha:
  * provided by this function is okay, the function wait_for_random_bytes()
  * should be called and return 0 at least once at any point prior.
  */
-struct batched_entropy {
-	union {
-		/*
-		 * We make this 1.5x a ChaCha block, so that we get the
-		 * remaining 32 bytes from fast key erasure, plus one full
-		 * block from the detached ChaCha state. We can increase
-		 * the size of this later if needed so long as we keep the
-		 * formula of (integer_blocks + 0.5) * CHACHA_BLOCK_SIZE.
-		 */
-		u64 entropy_u64[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
-		u32 entropy_u32[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
-	};
-	local_lock_t lock;
-	unsigned long generation;
-	unsigned int position;
-};
 
+#define DEFINE_BATCHED_ENTROPY(type)						\
+struct batch_ ##type {								\
+	/*									\
+	 * We make this 1.5x a ChaCha block, so that we get the			\
+	 * remaining 32 bytes from fast key erasure, plus one full		\
+	 * block from the detached ChaCha state. We can increase		\
+	 * the size of this later if needed so long as we keep the		\
+	 * formula of (integer_blocks + 0.5) * CHACHA_BLOCK_SIZE.		\
+	 */									\
+	type entropy[CHACHA_BLOCK_SIZE * 3 / (2 * sizeof(type))];		\
+	local_lock_t lock;							\
+	unsigned long generation;						\
+	unsigned int position;							\
+};										\
+										\
+static DEFINE_PER_CPU(struct batch_ ##type, batched_entropy_ ##type) = {	\
+	.lock = INIT_LOCAL_LOCK(batched_entropy_ ##type.lock),			\
+	.position = UINT_MAX							\
+};										\
+										\
+type get_random_ ##type(void)							\
+{										\
+	type ret;								\
+	unsigned long flags;							\
+	struct batch_ ##type *batch;						\
+	unsigned long next_gen;							\
+										\
+	warn_unseeded_randomness();						\
+										\
+	if  (!crng_ready()) {							\
+		_get_random_bytes(&ret, sizeof(ret));				\
+		return ret;							\
+	}									\
+										\
+	local_lock_irqsave(&batched_entropy_ ##type.lock, flags);		\
+	batch = raw_cpu_ptr(&batched_entropy_##type);				\
+										\
+	next_gen = READ_ONCE(base_crng.generation);				\
+	if (batch->position >= ARRAY_SIZE(batch->entropy) ||			\
+	    next_gen != batch->generation) {					\
+		_get_random_bytes(batch->entropy, sizeof(batch->entropy));	\
+		batch->position = 0;						\
+		batch->generation = next_gen;					\
+	}									\
+										\
+	ret = batch->entropy[batch->position];					\
+	batch->entropy[batch->position] = 0;					\
+	++batch->position;							\
+	local_unlock_irqrestore(&batched_entropy_ ##type.lock, flags);		\
+	return ret;								\
+}										\
+EXPORT_SYMBOL(get_random_ ##type);
 
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
-	.lock = INIT_LOCAL_LOCK(batched_entropy_u64.lock),
-	.position = UINT_MAX
-};
-
-u64 get_random_u64(void)
-{
-	u64 ret;
-	unsigned long flags;
-	struct batched_entropy *batch;
-	unsigned long next_gen;
-
-	warn_unseeded_randomness();
-
-	if  (!crng_ready()) {
-		_get_random_bytes(&ret, sizeof(ret));
-		return ret;
-	}
-
-	local_lock_irqsave(&batched_entropy_u64.lock, flags);
-	batch = raw_cpu_ptr(&batched_entropy_u64);
-
-	next_gen = READ_ONCE(base_crng.generation);
-	if (batch->position >= ARRAY_SIZE(batch->entropy_u64) ||
-	    next_gen != batch->generation) {
-		_get_random_bytes(batch->entropy_u64, sizeof(batch->entropy_u64));
-		batch->position = 0;
-		batch->generation = next_gen;
-	}
-
-	ret = batch->entropy_u64[batch->position];
-	batch->entropy_u64[batch->position] = 0;
-	++batch->position;
-	local_unlock_irqrestore(&batched_entropy_u64.lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(get_random_u64);
-
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
-	.lock = INIT_LOCAL_LOCK(batched_entropy_u32.lock),
-	.position = UINT_MAX
-};
-
-u32 get_random_u32(void)
-{
-	u32 ret;
-	unsigned long flags;
-	struct batched_entropy *batch;
-	unsigned long next_gen;
-
-	warn_unseeded_randomness();
-
-	if  (!crng_ready()) {
-		_get_random_bytes(&ret, sizeof(ret));
-		return ret;
-	}
-
-	local_lock_irqsave(&batched_entropy_u32.lock, flags);
-	batch = raw_cpu_ptr(&batched_entropy_u32);
-
-	next_gen = READ_ONCE(base_crng.generation);
-	if (batch->position >= ARRAY_SIZE(batch->entropy_u32) ||
-	    next_gen != batch->generation) {
-		_get_random_bytes(batch->entropy_u32, sizeof(batch->entropy_u32));
-		batch->position = 0;
-		batch->generation = next_gen;
-	}
-
-	ret = batch->entropy_u32[batch->position];
-	batch->entropy_u32[batch->position] = 0;
-	++batch->position;
-	local_unlock_irqrestore(&batched_entropy_u32.lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(get_random_u32);
+DEFINE_BATCHED_ENTROPY(u64)
+DEFINE_BATCHED_ENTROPY(u32)
 
 #ifdef CONFIG_SMP
 /*


