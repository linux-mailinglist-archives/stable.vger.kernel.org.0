Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF90491AE4
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352491AbiARDAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345654AbiARCs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:48:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E34C061775;
        Mon, 17 Jan 2022 18:39:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 802B4B81243;
        Tue, 18 Jan 2022 02:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9028BC36AEB;
        Tue, 18 Jan 2022 02:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473580;
        bh=vKWSGVyBRIU9roEq5H7rCjwRia1zNgCJtd+b+NSXZ9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUL/yybnWJS6nHVwK8GTZnnBQK5pMUUoe5ZUiyGziThaQsujfyshXI6UQcnxI//TN
         0yU+3lJQZhm7AjByxWzaJUsyIs9jPdWHHbbwy7rEEdzz2QmdjE3r5e6lFJ44mwEmMs
         dEWk6LhqHq00dS0w0iGLnZ/yX1voxv9ZjmqbEYhDyHaxZ2G8GWhpkmpjiSEdKRP7v6
         U81M07PppeDd/0s7UamwTNAuPR3JCOhE4rqk9Fip2mheWIchCZbc/tj8ER2kRXNr8i
         fDXk8QIzTtjoHbMzw3bQ9wkj2ys1Vr/tD56TFQB8J6iD7hyKV4JYNEfJaxdFUXPCX6
         juIPaA8muLoLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>, tytso@mit.edu
Subject: [PATCH AUTOSEL 5.15 179/188] random: do not throw away excess input to crng_fast_load
Date:   Mon, 17 Jan 2022 21:31:43 -0500
Message-Id: <20220118023152.1948105-179-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 73c7733f122e8d0107f88655a12011f68f69e74b ]

When crng_fast_load() is called by add_hwgenerator_randomness(), we
currently will advance to crng_init==1 once we've acquired 64 bytes, and
then throw away the rest of the buffer. Usually, that is not a problem:
When add_hwgenerator_randomness() gets called via EFI or DT during
setup_arch(), there won't be any IRQ randomness. Therefore, the 64 bytes
passed by EFI exactly matches what is needed to advance to crng_init==1.
Usually, DT seems to pass 64 bytes as well -- with one notable exception
being kexec, which hands over 128 bytes of entropy to the kexec'd kernel.
In that case, we'll advance to crng_init==1 once 64 of those bytes are
consumed by crng_fast_load(), but won't continue onward feeding in bytes
to progress to crng_init==2. This commit fixes the issue by feeding
any leftover bytes into the next phase in add_hwgenerator_randomness().

[linux@dominikbrodowski.net: rewrite commit message]
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/random.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 605969ed0f965..9c403bbb21a1f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -863,12 +863,14 @@ static void numa_crng_init(void) {}
 
 /*
  * crng_fast_load() can be called by code in the interrupt service
- * path.  So we can't afford to dilly-dally.
+ * path.  So we can't afford to dilly-dally. Returns the number of
+ * bytes processed from cp.
  */
-static int crng_fast_load(const char *cp, size_t len)
+static size_t crng_fast_load(const char *cp, size_t len)
 {
 	unsigned long flags;
 	char *p;
+	size_t ret = 0;
 
 	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
 		return 0;
@@ -879,7 +881,7 @@ static int crng_fast_load(const char *cp, size_t len)
 	p = (unsigned char *) &primary_crng.state[4];
 	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
 		p[crng_init_cnt % CHACHA_KEY_SIZE] ^= *cp;
-		cp++; crng_init_cnt++; len--;
+		cp++; crng_init_cnt++; len--; ret++;
 	}
 	spin_unlock_irqrestore(&primary_crng.lock, flags);
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
@@ -887,7 +889,7 @@ static int crng_fast_load(const char *cp, size_t len)
 		crng_init = 1;
 		pr_notice("fast init done\n");
 	}
-	return 1;
+	return ret;
 }
 
 /*
@@ -1269,7 +1271,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
 		    crng_fast_load((char *) fast_pool->pool,
-				   sizeof(fast_pool->pool))) {
+				   sizeof(fast_pool->pool)) > 0) {
 			fast_pool->count = 0;
 			fast_pool->last = now;
 		}
@@ -2275,8 +2277,11 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	struct entropy_store *poolp = &input_pool;
 
 	if (unlikely(crng_init == 0)) {
-		crng_fast_load(buffer, count);
-		return;
+		size_t ret = crng_fast_load(buffer, count);
+		count -= ret;
+		buffer += ret;
+		if (!count || crng_init == 0)
+			return;
 	}
 
 	/* Suspend writing if we're above the trickle threshold.
-- 
2.34.1

