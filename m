Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887025581D7
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiFWRGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiFWRGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:06:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D84651E50;
        Thu, 23 Jun 2022 09:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 652D560B20;
        Thu, 23 Jun 2022 16:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37980C341C4;
        Thu, 23 Jun 2022 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003342;
        bh=1F6bZmAY5p4rpGT2E+2Q05yqO5+1LoIQ4CxLrpbvRZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKlEzYrMCMwIOvdTs9Vh03qF6pNq6SGDOH0OOxPEV7/aygUL9Of6l2YynQhUTdgTj
         SRdeVJ6laaaq598lT9ZfflPnzy6d35AQ7hu4yr1Bx0nNnOI13W1D8XWkTwS5THblQJ
         U382m1QcSqbCToFqCFsXjCnL08Jr5V5qhBzbRSL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 206/264] random: use static branch for crng_ready()
Date:   Thu, 23 Jun 2022 18:43:19 +0200
Message-Id: <20220623164349.899829694@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

commit f5bda35fba615ace70a656d4700423fa6c9bebee upstream.

Since crng_ready() is only false briefly during initialization and then
forever after becomes true, we don't need to evaluate it after, making
it a prime candidate for a static branch.

One complication, however, is that it changes state in a particular call
to credit_init_bits(), which might be made from atomic context, which
means we must kick off a workqueue to change the static key. Further
complicating things, credit_init_bits() may be called sufficiently early
on in system initialization such that system_wq is NULL.

Fortunately, there exists the nice function execute_in_process_context(),
which will immediately execute the function if !in_interrupt(), and
otherwise defer it to a workqueue. During early init, before workqueues
are available, in_interrupt() is always false, because interrupts
haven't even been enabled yet, which means the function in that case
executes immediately. Later on, after workqueues are available,
in_interrupt() might be true, but in that case, the work is queued in
system_wq and all goes well.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -78,8 +78,9 @@ static enum {
 	CRNG_EMPTY = 0, /* Little to no entropy collected */
 	CRNG_EARLY = 1, /* At least POOL_EARLY_BITS collected */
 	CRNG_READY = 2  /* Fully initialized with POOL_READY_BITS collected */
-} crng_init = CRNG_EMPTY;
-#define crng_ready() (likely(crng_init >= CRNG_READY))
+} crng_init __read_mostly = CRNG_EMPTY;
+static DEFINE_STATIC_KEY_FALSE(crng_is_ready);
+#define crng_ready() (static_branch_likely(&crng_is_ready) || crng_init >= CRNG_READY)
 /* Various types of waiters for crng_init->CRNG_READY transition. */
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 static struct fasync_struct *fasync;
@@ -109,6 +110,11 @@ bool rng_is_initialized(void)
 }
 EXPORT_SYMBOL(rng_is_initialized);
 
+static void crng_set_ready(struct work_struct *work)
+{
+	static_branch_enable(&crng_is_ready);
+}
+
 /* Used by wait_for_random_bytes(), and considered an entropy collector, below. */
 static void try_to_generate_entropy(void);
 
@@ -268,7 +274,7 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	if (!crng_ready())
+	if (!static_branch_likely(&crng_is_ready))
 		crng_init = CRNG_READY;
 	spin_unlock_irqrestore(&base_crng.lock, flags);
 	memzero_explicit(key, sizeof(key));
@@ -783,6 +789,7 @@ static void extract_entropy(void *buf, s
 
 static void credit_init_bits(size_t nbits)
 {
+	static struct execute_work set_ready;
 	unsigned int new, orig, add;
 	unsigned long flags;
 
@@ -798,6 +805,7 @@ static void credit_init_bits(size_t nbit
 
 	if (orig < POOL_READY_BITS && new >= POOL_READY_BITS) {
 		crng_reseed(); /* Sets crng_init to CRNG_READY under base_crng.lock. */
+		execute_in_process_context(crng_set_ready, &set_ready);
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
@@ -1307,7 +1315,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 	if (count > INT_MAX)
 		count = INT_MAX;
 
-	if (!(flags & GRND_INSECURE) && !crng_ready()) {
+	if (!crng_ready() && !(flags & GRND_INSECURE)) {
 		int ret;
 
 		if (flags & GRND_NONBLOCK)


