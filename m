Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A41558403
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbiFWRjz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiFWRiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:38:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA3B92B68;
        Thu, 23 Jun 2022 10:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76F276159A;
        Thu, 23 Jun 2022 17:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA15C3411B;
        Thu, 23 Jun 2022 17:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004047;
        bh=S6Z2YbLFfMIg2ntUa7Kq61N1Hh/pySifdolHTwUZwt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0JyKvpLiXCrgdQyYCucVle+oYSERRBWM1XeypZRLecPEDeu5QE6UFMfUFAni9Z/wf
         4U5glnWHk9XtfGUq0CxS/bkjT1gGbq7WvBJi0UBfMWVZC/aID/2D0/mZ5rwA4aLzoU
         nLk1LlH0f396TXYKwnym5IfJfC0g+3r6IYMIFpAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 170/237] random: avoid initializing twice in credit race
Date:   Thu, 23 Jun 2022 18:43:24 +0200
Message-Id: <20220623164348.044150513@linuxfoundation.org>
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

commit fed7ef061686cc813b1f3d8d0edc6c35b4d3537b upstream.

Since all changes of crng_init now go through credit_init_bits(), we can
fix a long standing race in which two concurrent callers of
credit_init_bits() have the new bit count >= some threshold, but are
doing so with crng_init as a lower threshold, checked outside of a lock,
resulting in crng_reseed() or similar being called twice.

In order to fix this, we can use the original cmpxchg value of the bit
count, and only change crng_init when the bit count transitions from
below a threshold to meeting the threshold.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   48 ++++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -264,7 +264,6 @@ static void crng_reseed(void)
 	unsigned long flags;
 	unsigned long next_gen;
 	u8 key[CHACHA20_KEY_SIZE];
-	bool finalize_init = false;
 
 	extract_entropy(key, sizeof(key));
 
@@ -281,28 +280,10 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	if (!crng_ready()) {
+	if (!crng_ready())
 		crng_init = CRNG_READY;
-		finalize_init = true;
-	}
 	spin_unlock_irqrestore(&base_crng.lock, flags);
 	memzero_explicit(key, sizeof(key));
-	if (finalize_init) {
-		process_random_ready_list();
-		wake_up_interruptible(&crng_init_wait);
-		kill_fasync(&fasync, SIGIO, POLL_IN);
-		pr_notice("crng init done\n");
-		if (unseeded_warning.missed) {
-			pr_notice("%d get_random_xx warning(s) missed due to ratelimiting\n",
-				  unseeded_warning.missed);
-			unseeded_warning.missed = 0;
-		}
-		if (urandom_warning.missed) {
-			pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
-				  urandom_warning.missed);
-			urandom_warning.missed = 0;
-		}
-	}
 }
 
 /*
@@ -818,7 +799,7 @@ static void extract_entropy(void *buf, s
 
 static void credit_init_bits(size_t nbits)
 {
-	unsigned int init_bits, orig, add;
+	unsigned int new, orig, add;
 	unsigned long flags;
 
 	if (crng_ready() || !nbits)
@@ -828,13 +809,28 @@ static void credit_init_bits(size_t nbit
 
 	do {
 		orig = READ_ONCE(input_pool.init_bits);
-		init_bits = min_t(unsigned int, POOL_BITS, orig + add);
-	} while (cmpxchg(&input_pool.init_bits, orig, init_bits) != orig);
+		new = min_t(unsigned int, POOL_BITS, orig + add);
+	} while (cmpxchg(&input_pool.init_bits, orig, new) != orig);
 
-	if (!crng_ready() && init_bits >= POOL_READY_BITS)
-		crng_reseed();
-	else if (unlikely(crng_init == CRNG_EMPTY && init_bits >= POOL_EARLY_BITS)) {
+	if (orig < POOL_READY_BITS && new >= POOL_READY_BITS) {
+		crng_reseed(); /* Sets crng_init to CRNG_READY under base_crng.lock. */
+		process_random_ready_list();
+		wake_up_interruptible(&crng_init_wait);
+		kill_fasync(&fasync, SIGIO, POLL_IN);
+		pr_notice("crng init done\n");
+		if (unseeded_warning.missed) {
+			pr_notice("%d get_random_xx warning(s) missed due to ratelimiting\n",
+				  unseeded_warning.missed);
+			unseeded_warning.missed = 0;
+		}
+		if (urandom_warning.missed) {
+			pr_notice("%d urandom warning(s) missed due to ratelimiting\n",
+				  urandom_warning.missed);
+			urandom_warning.missed = 0;
+		}
+	} else if (orig < POOL_EARLY_BITS && new >= POOL_EARLY_BITS) {
 		spin_lock_irqsave(&base_crng.lock, flags);
+		/* Check if crng_init is CRNG_EMPTY, to avoid race with crng_reseed(). */
 		if (crng_init == CRNG_EMPTY) {
 			extract_entropy(base_crng.key, sizeof(base_crng.key));
 			crng_init = CRNG_EARLY;


