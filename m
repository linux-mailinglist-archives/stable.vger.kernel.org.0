Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938C247B603
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 23:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhLTWxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 17:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbhLTWxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 17:53:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68A1C061574;
        Mon, 20 Dec 2021 14:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D83361337;
        Mon, 20 Dec 2021 22:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C45C36AEC;
        Mon, 20 Dec 2021 22:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640040823;
        bh=RpRZvozu/onQgx+G+WE8lozUq8hxY78j5HN9za1ByWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHnhq92rp4xPP1w3j5TlKfq/XXRXMqMOhvEv/TqzNFozx6U3IlVG1U65lnV0mVqZP
         MUlH9Vr6GdS8LoFOa7A/ID6gUPbpPSHc/JuUurnAjXrONGlH9hCKjwRyMtyGlJ8vLr
         NKcVJc0mi7R8wt2QVqD1GYN8g6EdtrzGeFUOVb7FHYK2TBj34/DAgwjP/lEeC7RAnB
         FDcAU/QjUgQ4ld6anULlLUehYttaJcNMQlFxWIcmlGMJby8El9IWdjLHriejWjvDtJ
         LUP6K49R2hTb/aoJmvwAhvdc9HSKXJkdUTYzaRCsZ/ZfodRoGBULYZH+kVPiYUcpbs
         NxocZphdvMINw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>,
        "Jason A . Donenfeld " <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Paul E . McKenney" <paulmck@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] random: fix data race on crng init time
Date:   Mon, 20 Dec 2021 16:41:57 -0600
Message-Id: <20211220224157.111959-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220224157.111959-1-ebiggers@kernel.org>
References: <20211220224157.111959-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

_extract_crng() does plain loads of crng->init_time and
crng_global_init_time, which causes undefined behavior if
crng_reseed() and RNDRESEEDCRNG modify these corrently.

Use READ_ONCE() and WRITE_ONCE() to make the behavior defined.

Don't fix the race on crng->init_time by protecting it with crng->lock,
since it's not a problem for duplicate reseedings to occur.  I.e., the
lockless access with READ_ONCE() is fine.

Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
Fixes: e192be9d9a30 ("random: replace non-blocking pool with a Chacha20-based CRNG")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/char/random.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1294b4527cdd..1a7bb66d6a58 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -980,7 +980,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 		crng->state[i+4] ^= buf.key[i] ^ rv;
 	}
 	memzero_explicit(&buf, sizeof(buf));
-	crng->init_time = jiffies;
+	WRITE_ONCE(crng->init_time, jiffies);
 	spin_unlock_irqrestore(&crng->lock, flags);
 	if (crng == &primary_crng && crng_init < 2) {
 		invalidate_batched_entropy();
@@ -1006,12 +1006,15 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 static void _extract_crng(struct crng_state *crng,
 			  __u8 out[CHACHA_BLOCK_SIZE])
 {
-	unsigned long v, flags;
+	unsigned long v, flags, init_time;
 
-	if (crng_ready() &&
-	    (time_after(crng_global_init_time, crng->init_time) ||
-	     time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL)))
-		crng_reseed(crng, crng == &primary_crng ? &input_pool : NULL);
+	if (crng_ready()) {
+		init_time = READ_ONCE(crng->init_time);
+		if (time_after(READ_ONCE(crng_global_init_time), init_time) ||
+		    time_after(jiffies, init_time + CRNG_RESEED_INTERVAL))
+			crng_reseed(crng, crng == &primary_crng ?
+				    &input_pool : NULL);
+	}
 	spin_lock_irqsave(&crng->lock, flags);
 	if (arch_get_random_long(&v))
 		crng->state[14] ^= v;
@@ -1951,7 +1954,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		if (crng_init < 2)
 			return -ENODATA;
 		crng_reseed(&primary_crng, &input_pool);
-		crng_global_init_time = jiffies - 1;
+		WRITE_ONCE(crng_global_init_time, jiffies - 1);
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.34.1

