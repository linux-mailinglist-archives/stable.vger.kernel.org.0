Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B9F551E8D
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbiFTOC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350868AbiFTNxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC871A079;
        Mon, 20 Jun 2022 06:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E0D5B81157;
        Mon, 20 Jun 2022 13:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41ABC3411B;
        Mon, 20 Jun 2022 13:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731223;
        bh=75vFRHIikGYO/QtNKHB0M5xgdQl5SQfHUhFw9fZ9tHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvZ25zrrzMOoT/Do5KlYK5IavOxrm2wt23xtbXpeoTZPAvwhAJNVWXJUJu40DHcMp
         4vNrFs0OleypBPpPxYszt6iA8LVQbkKrVadWEGECiwc17igvWShgsXYSvcKa6DP6VQ
         uKCcYsZ4jwPo6wC5a0kG0eZav4HKhhEdt+B3bbBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 155/240] random: move initialization out of reseeding hot path
Date:   Mon, 20 Jun 2022 14:50:56 +0200
Message-Id: <20220620124743.501057483@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

commit 68c9c8b192c6dae9be6278e98ee44029d5da2d31 upstream.

Initialization happens once -- by way of credit_init_bits() -- and then
it never happens again. Therefore, it doesn't need to be in
crng_reseed(), which is a hot path that is called multiple times. It
also doesn't make sense to have there, as initialization activity is
better associated with initialization routines.

After the prior commit, crng_reseed() now won't be called by multiple
concurrent callers, which means that we can safely move the
"finialize_init" logic into crng_init_bits() unconditionally.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -264,7 +264,6 @@ static void crng_reseed(void)
 	unsigned long flags;
 	unsigned long next_gen;
 	u8 key[CHACHA_KEY_SIZE];
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
@@ -831,10 +812,25 @@ static void credit_init_bits(size_t nbit
 		new = min_t(unsigned int, POOL_BITS, orig + add);
 	} while (cmpxchg(&input_pool.init_bits, orig, new) != orig);
 
-	if (orig < POOL_READY_BITS && new >= POOL_READY_BITS)
-		crng_reseed();
-	else if (orig < POOL_EARLY_BITS && new >= POOL_EARLY_BITS) {
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


