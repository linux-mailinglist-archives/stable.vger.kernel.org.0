Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CB51A51FB
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgDKM2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727160AbgDKMMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:12:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9342E20787;
        Sat, 11 Apr 2020 12:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607129;
        bh=6MyqpOAQu3smtK6EX+njIZHGLXk6EMSReKmCM7DsUZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUukPzKO+KV6OStw4JVD7I+pJq1VRL4s8D7mBgJpsU9r1nICjb6TMXxDvAcMGfuzq
         1qZPjezTzAQkC9Ufn3JAF1uE5wa2OOUo6LZsi/H2OBt5+RrlNqAmQgTxmwRK4Tw0Rv
         UbRdB54Rf9nxR2LVrAqn0n/31fuhofVfSezZ+Szo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 19/32] random: always use batched entropy for get_random_u{32,64}
Date:   Sat, 11 Apr 2020 14:08:58 +0200
Message-Id: <20200411115421.016701278@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115418.455500023@linuxfoundation.org>
References: <20200411115418.455500023@linuxfoundation.org>
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
 drivers/char/random.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2118,8 +2118,8 @@ struct batched_entropy {
 
 /*
  * Get a random word for internal kernel use only. The quality of the random
- * number is either as good as RDRAND or as good as /dev/urandom, with the
- * goal of being quite fast and not depleting entropy.
+ * number is good as /dev/urandom, but there is no backtrack protection, with
+ * the goal of being quite fast and not depleting entropy.
  */
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_long);
 unsigned long get_random_long(void)
@@ -2127,9 +2127,6 @@ unsigned long get_random_long(void)
 	unsigned long ret;
 	struct batched_entropy *batch;
 
-	if (arch_get_random_long(&ret))
-		return ret;
-
 	batch = &get_cpu_var(batched_entropy_long);
 	if (batch->position % ARRAY_SIZE(batch->entropy_long) == 0) {
 		extract_crng((u8 *)batch->entropy_long);
@@ -2153,9 +2150,6 @@ unsigned int get_random_int(void)
 	unsigned int ret;
 	struct batched_entropy *batch;
 
-	if (arch_get_random_int(&ret))
-		return ret;
-
 	batch = &get_cpu_var(batched_entropy_int);
 	if (batch->position % ARRAY_SIZE(batch->entropy_int) == 0) {
 		extract_crng((u8 *)batch->entropy_int);


