Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E325360D4
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351726AbiE0LyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352055AbiE0LtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:49:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6530F13128A;
        Fri, 27 May 2022 04:44:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAEE2B8091D;
        Fri, 27 May 2022 11:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EF1C385A9;
        Fri, 27 May 2022 11:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651838;
        bh=zvNJAXoilwDxTtaE7iGov4VsUnmsvHqf6cJHqz+4f5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqvEu44qxgEJ6hTw4zDBF68UOAEp5rld95SYP6icdqkG6yCSCwEyRRS08WnvPvat2
         jswQtMcywz3RB9gCiuhxLd3h61uSkXsbCoGMC8uNY9vlT8DVQsPPBdn/7nDZotawzW
         kHqOBzAmej97dOS7sVJ6v735E1FR6zeG7SO5yuRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 064/163] random: use RDSEED instead of RDRAND in entropy extraction
Date:   Fri, 27 May 2022 10:49:04 +0200
Message-Id: <20220527084836.940612093@linuxfoundation.org>
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

commit 28f425e573e906a4c15f8392cc2b1561ef448595 upstream.

When /dev/random was directly connected with entropy extraction, without
any expansion stage, extract_buf() was called for every 10 bytes of data
read from /dev/random. For that reason, RDRAND was used rather than
RDSEED. At the same time, crng_reseed() was still only called every 5
minutes, so there RDSEED made sense.

Those olden days were also a time when the entropy collector did not use
a cryptographic hash function, which meant most bets were off in terms
of real preimage resistance. For that reason too it didn't matter
_that_ much whether RDSEED was mixed in before or after entropy
extraction; both choices were sort of bad.

But now we have a cryptographic hash function at work, and with that we
get real preimage resistance. We also now only call extract_entropy()
every 5 minutes, rather than every 10 bytes. This allows us to do two
important things.

First, we can switch to using RDSEED in extract_entropy(), as Dominik
suggested. Second, we can ensure that RDSEED input always goes into the
cryptographic hash function with other things before being used
directly. This eliminates a category of attacks in which the CPU knows
the current state of the crng and knows that we're going to xor RDSEED
into it, and so it computes a malicious RDSEED. By going through our
hash function, it would require the CPU to compute a preimage on the
fly, which isn't going to happen.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Suggested-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -727,13 +727,8 @@ static void crng_reseed(struct crng_stat
 					CHACHA_KEY_SIZE);
 	}
 	spin_lock_irqsave(&crng->lock, flags);
-	for (i = 0; i < 8; i++) {
-		unsigned long rv;
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
-			rv = random_get_entropy();
-		crng->state[i + 4] ^= buf.key[i] ^ rv;
-	}
+	for (i = 0; i < 8; i++)
+		crng->state[i + 4] ^= buf.key[i];
 	memzero_explicit(&buf, sizeof(buf));
 	WRITE_ONCE(crng->init_time, jiffies);
 	spin_unlock_irqrestore(&crng->lock, flags);
@@ -1054,16 +1049,17 @@ static void extract_entropy(void *buf, s
 	unsigned long flags;
 	u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
 	struct {
-		unsigned long rdrand[32 / sizeof(long)];
+		unsigned long rdseed[32 / sizeof(long)];
 		size_t counter;
 	} block;
 	size_t i;
 
 	trace_extract_entropy(nbytes, input_pool.entropy_count);
 
-	for (i = 0; i < ARRAY_SIZE(block.rdrand); ++i) {
-		if (!arch_get_random_long(&block.rdrand[i]))
-			block.rdrand[i] = random_get_entropy();
+	for (i = 0; i < ARRAY_SIZE(block.rdseed); ++i) {
+		if (!arch_get_random_seed_long(&block.rdseed[i]) &&
+		    !arch_get_random_long(&block.rdseed[i]))
+			block.rdseed[i] = random_get_entropy();
 	}
 
 	spin_lock_irqsave(&input_pool.lock, flags);
@@ -1071,7 +1067,7 @@ static void extract_entropy(void *buf, s
 	/* seed = HASHPRF(last_key, entropy_input) */
 	blake2s_final(&input_pool.hash, seed);
 
-	/* next_key = HASHPRF(seed, RDRAND || 0) */
+	/* next_key = HASHPRF(seed, RDSEED || 0) */
 	block.counter = 0;
 	blake2s(next_key, (u8 *)&block, seed, sizeof(next_key), sizeof(block), sizeof(seed));
 	blake2s_init_key(&input_pool.hash, BLAKE2S_HASH_SIZE, next_key, sizeof(next_key));
@@ -1081,7 +1077,7 @@ static void extract_entropy(void *buf, s
 
 	while (nbytes) {
 		i = min_t(size_t, nbytes, BLAKE2S_HASH_SIZE);
-		/* output = HASHPRF(seed, RDRAND || ++counter) */
+		/* output = HASHPRF(seed, RDSEED || ++counter) */
 		++block.counter;
 		blake2s(buf, (u8 *)&block, seed, i, sizeof(block), sizeof(seed));
 		nbytes -= i;


