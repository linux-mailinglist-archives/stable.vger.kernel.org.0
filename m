Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47783551E1F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349034AbiFTOAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351550AbiFTNy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:54:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC3233343;
        Mon, 20 Jun 2022 06:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BA3760FA2;
        Mon, 20 Jun 2022 13:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5FCC3411B;
        Mon, 20 Jun 2022 13:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731253;
        bh=yxrt/AhYhZ+ptvTBbqTsXTtDDwvi/BZIk1CzdojwcHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSqmC3Zi1cHp3gOXWMFINbAOeJgacGQzyoqmknlUoKFTFXVFP0uFTLXuKKO+GL8fL
         YAALLqnP2CtE7oqlZYe3borjHOhsAtkCJ8/jU/10G8JvmMmdKqACrSBLzXIL5YVice
         8H3os3aWKdyxGs3JAu4J+2cM759mpDGxUWsm+O3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Sultan Alsawaf <sultan@kerneltoast.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 160/240] random: use static branch for crng_ready()
Date:   Mon, 20 Jun 2022 14:51:01 +0200
Message-Id: <20220620124743.643795860@linuxfoundation.org>
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
@@ -77,8 +77,9 @@ static enum {
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
@@ -108,6 +109,11 @@ bool rng_is_initialized(void)
 }
 EXPORT_SYMBOL(rng_is_initialized);
 
+static void crng_set_ready(struct work_struct *work)
+{
+	static_branch_enable(&crng_is_ready);
+}
+
 /* Used by wait_for_random_bytes(), and considered an entropy collector, below. */
 static void try_to_generate_entropy(void);
 
@@ -267,7 +273,7 @@ static void crng_reseed(void)
 		++next_gen;
 	WRITE_ONCE(base_crng.generation, next_gen);
 	WRITE_ONCE(base_crng.birth, jiffies);
-	if (!crng_ready())
+	if (!static_branch_likely(&crng_is_ready))
 		crng_init = CRNG_READY;
 	spin_unlock_irqrestore(&base_crng.lock, flags);
 	memzero_explicit(key, sizeof(key));
@@ -782,6 +788,7 @@ static void extract_entropy(void *buf, s
 
 static void credit_init_bits(size_t nbits)
 {
+	static struct execute_work set_ready;
 	unsigned int new, orig, add;
 	unsigned long flags;
 
@@ -797,6 +804,7 @@ static void credit_init_bits(size_t nbit
 
 	if (orig < POOL_READY_BITS && new >= POOL_READY_BITS) {
 		crng_reseed(); /* Sets crng_init to CRNG_READY under base_crng.lock. */
+		execute_in_process_context(crng_set_ready, &set_ready);
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
@@ -1306,7 +1314,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 	if (count > INT_MAX)
 		count = INT_MAX;
 
-	if (!(flags & GRND_INSECURE) && !crng_ready()) {
+	if (!crng_ready() && !(flags & GRND_INSECURE)) {
 		int ret;
 
 		if (flags & GRND_NONBLOCK)


