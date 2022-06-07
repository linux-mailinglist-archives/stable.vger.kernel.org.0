Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BD0541EBE
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380307AbiFGWdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381781AbiFGWcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:32:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA4B22508;
        Tue,  7 Jun 2022 12:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B9C2CE2478;
        Tue,  7 Jun 2022 19:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FB3C385A2;
        Tue,  7 Jun 2022 19:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629921;
        bh=4EKyYJ2EBnd47zcCCrMDKfdZTmj/kYWTH+AI9gJfgTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyC1SywNpxZ69SVJoNZIKdP53G5ImWEzNJUfyKq7Ccg2O436HjZ86KcA+nRnIXIF4
         h8ipvEzum8hGcPdCtqPdZFpLw2PlgrGU8Tpm9El5qWFDfD7LIW5jdIKXbx9qaKV3uv
         zH3AqyBK9vX6FIBpNaMPsHaZsLTSMGL9/3vtTivI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 866/879] Revert "random: use static branch for crng_ready()"
Date:   Tue,  7 Jun 2022 19:06:24 +0200
Message-Id: <20220607165027.989427675@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

This reverts upstream commit f5bda35fba615ace70a656d4700423fa6c9bebee
from stable. It's not essential and will take some time during 5.19 to
work out properly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -78,8 +78,7 @@ static enum {
 	CRNG_EARLY = 1, /* At least POOL_EARLY_BITS collected */
 	CRNG_READY = 2  /* Fully initialized with POOL_READY_BITS collected */
 } crng_init __read_mostly = CRNG_EMPTY;
-static DEFINE_STATIC_KEY_FALSE(crng_is_ready);
-#define crng_ready() (static_branch_likely(&crng_is_ready) || crng_init >= CRNG_READY)
+#define crng_ready() (likely(crng_init >= CRNG_READY))
 /* Various types of waiters for crng_init->CRNG_READY transition. */
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 static struct fasync_struct *fasync;
@@ -109,11 +108,6 @@ bool rng_is_initialized(void)
 }
 EXPORT_SYMBOL(rng_is_initialized);
 
-static void __cold crng_set_ready(struct work_struct *work)
-{
-	static_branch_enable(&crng_is_ready);
-}
-
 /* Used by wait_for_random_bytes(), and considered an entropy collector, below. */
 static void try_to_generate_entropy(void);
 
@@ -267,7 +261,7 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	if (!static_branch_likely(&crng_is_ready))
+	if (!crng_ready())
 		crng_init = CRNG_READY;
 	spin_unlock_irqrestore(&base_crng.lock, flags);
 	memzero_explicit(key, sizeof(key));
@@ -710,7 +704,6 @@ static void extract_entropy(void *buf, s
 
 static void __cold _credit_init_bits(size_t bits)
 {
-	static struct execute_work set_ready;
 	unsigned int new, orig, add;
 	unsigned long flags;
 
@@ -726,7 +719,6 @@ static void __cold _credit_init_bits(siz
 
 	if (orig < POOL_READY_BITS && new >= POOL_READY_BITS) {
 		crng_reseed(); /* Sets crng_init to CRNG_READY under base_crng.lock. */
-		execute_in_process_context(crng_set_ready, &set_ready);
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);


