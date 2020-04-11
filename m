Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F41A1A5004
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgDKMNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727848AbgDKMNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:13:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC4321556;
        Sat, 11 Apr 2020 12:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607216;
        bh=Iu3IkTSv4RF2KHmNDVO62v3zlxWEmjAbUzzfnO8vjc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3HIyDSGrDJIl3D89WcrygHQNzHl+4bK+WRKmtWG9GhSo+/qCtAH2WY7TzfifeOh5
         871jvXwVGfAHqP+7RotFfME2ZYzxUxmAcFE6uvHZuXhpSPZXUY2O0CZ81X+8jL5emU
         j2lNHUcbQr4qY2fHpTLa68DnxZGSHJYV1A/EFegs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 21/38] random: always use batched entropy for get_random_u{32,64}
Date:   Sat, 11 Apr 2020 14:09:05 +0200
Message-Id: <20200411115440.160085978@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115437.795556138@linuxfoundation.org>
References: <20200411115437.795556138@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 69efea712f5b0489e67d07565aad5c94e09a3e52 upstream.

It turns out that RDRAND is pretty slow. Comparing these two
constructions:

  for (i = 0; i < CHACHA_BLOCK_SIZE; i += sizeof(ret))
    arch_get_random_long(&ret);

and

  long buf[CHACHA_BLOCK_SIZE / sizeof(long)];
  extract_crng((u8 *)buf);

it amortizes out to 352 cycles per long for the top one and 107 cycles
per long for the bottom one, on Coffee Lake Refresh, Intel Core i9-9880H.

And importantly, the top one has the drawback of not benefiting from the
real rng, whereas the bottom one has all the nice benefits of using our
own chacha rng. As get_random_u{32,64} gets used in more places (perhaps
beyond what it was originally intended for when it was introduced as
get_random_{int,long} back in the md5 monstrosity era), it seems like it
might be a good thing to strengthen its posture a tiny bit. Doing this
should only be stronger and not any weaker because that pool is already
initialized with a bunch of rdrand data (when available). This way, we
get the benefits of the hardware rng as well as our own rng.

Another benefit of this is that we no longer hit pitfalls of the recent
stream of AMD bugs in RDRAND. One often used code pattern for various
things is:

  do {
  	val = get_random_u32();
  } while (hash_table_contains_key(val));

That recent AMD bug rendered that pattern useless, whereas we're really
very certain that chacha20 output will give pretty distributed numbers,
no matter what.

So, this simplification seems better both from a security perspective
and from a performance perspective.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20200221201037.30231-1-Jason@zx2c4.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2193,11 +2193,11 @@ struct batched_entropy {
 
 /*
  * Get a random word for internal kernel use only. The quality of the random
- * number is either as good as RDRAND or as good as /dev/urandom, with the
- * goal of being quite fast and not depleting entropy. In order to ensure
+ * number is good as /dev/urandom, but there is no backtrack protection, with
+ * the goal of being quite fast and not depleting entropy. In order to ensure
  * that the randomness provided by this function is okay, the function
- * wait_for_random_bytes() should be called and return 0 at least once
- * at any point prior.
+ * wait_for_random_bytes() should be called and return 0 at least once at any
+ * point prior.
  */
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
 	.batch_lock	= __SPIN_LOCK_UNLOCKED(batched_entropy_u64.lock),
@@ -2210,15 +2210,6 @@ u64 get_random_u64(void)
 	struct batched_entropy *batch;
 	static void *previous;
 
-#if BITS_PER_LONG == 64
-	if (arch_get_random_long((unsigned long *)&ret))
-		return ret;
-#else
-	if (arch_get_random_long((unsigned long *)&ret) &&
-	    arch_get_random_long((unsigned long *)&ret + 1))
-	    return ret;
-#endif
-
 	warn_unseeded_randomness(&previous);
 
 	batch = raw_cpu_ptr(&batched_entropy_u64);
@@ -2243,9 +2234,6 @@ u32 get_random_u32(void)
 	struct batched_entropy *batch;
 	static void *previous;
 
-	if (arch_get_random_int(&ret))
-		return ret;
-
 	warn_unseeded_randomness(&previous);
 
 	batch = raw_cpu_ptr(&batched_entropy_u32);


