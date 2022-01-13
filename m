Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE8D48DD80
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 19:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbiAMSNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 13:13:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49256 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiAMSNk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 13:13:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51AC06184A
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 18:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373A3C36AEB;
        Thu, 13 Jan 2022 18:13:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="F5LRimFo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642097617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQOnqbiSRKHxa9wmT0v9I4EaGB/q6D10rHn9gPLIC30=;
        b=F5LRimFoainW/L7MNbzN0SMj0TxgNWHvUnjCJqEInPOsbuGAE0BIC03GMNz3b3GMbsp+k+
        4tiP1sPFcJ8JvLhAbXTSdLolnm//0fY+64JfcTewQ6zo8Kqg4wxge5oTEk9bV8jL8MmyE8
        tCSaT4yh14M2sUnkJ/G6psMzjkaGGUA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 887f9545 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 13 Jan 2022 18:13:37 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux@dominikbrodowski.net, iivanov@suse.de,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH stable 5.4.y] random: fix crash on multiple early calls to add_bootloader_randomness()
Date:   Thu, 13 Jan 2022 19:13:29 +0100
Message-Id: <20220113181329.69371-1-Jason@zx2c4.com>
In-Reply-To: <164209692229178@kroah.com>
References: <164209692229178@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Brodowski <linux@dominikbrodowski.net>

commit f7e67b8e803185d0aabe7f29d25a35c8be724a78 upstream.

Currently, if CONFIG_RANDOM_TRUST_BOOTLOADER is enabled, multiple calls
to add_bootloader_randomness() are broken and can cause a NULL pointer
dereference, as noted by Ivan T. Ivanov. This is not only a hypothetical
problem, as qemu on arm64 may provide bootloader entropy via EFI and via
devicetree.

On the first call to add_hwgenerator_randomness(), crng_fast_load() is
executed, and if the seed is long enough, crng_init will be set to 1.
On subsequent calls to add_bootloader_randomness() and then to
add_hwgenerator_randomness(), crng_fast_load() will be skipped. Instead,
wait_event_interruptible() and then credit_entropy_bits() will be called.
If the entropy count for that second seed is large enough, that proceeds
to crng_reseed().

However, both wait_event_interruptible() and crng_reseed() depends
(at least in numa_crng_init()) on workqueues. Therefore, test whether
system_wq is already initialized, which is a sufficient indicator that
workqueue_init_early() has progressed far enough.

If we wind up hitting the !system_wq case, we later want to do what
would have been done there when wqs are up, so set a flag, and do that
work later from the rand_initialize() call.

Reported-by: Ivan T. Ivanov <iivanov@suse.de>
Fixes: 18b915ac6b0a ("efi/random: Treat EFI_RNG_PROTOCOL output as bootloader randomness")
Cc: stable@vger.kernel.org
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
[Jason: added crng_need_done state and related logic.]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 59 ++++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ffd61aadb761..de2822694474 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -497,6 +497,7 @@ static struct crng_state primary_crng = {
  * its value (from 0->1->2).
  */
 static int crng_init = 0;
+static bool crng_need_final_init = false;
 #define crng_ready() (likely(crng_init > 1))
 static int crng_init_cnt = 0;
 static unsigned long crng_global_init_time = 0;
@@ -889,6 +890,38 @@ static void crng_initialize(struct crng_state *crng)
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
+static void crng_finalize_init(struct crng_state *crng)
+{
+	if (crng != &primary_crng || crng_init >= 2)
+		return;
+	if (!system_wq) {
+		/* We can't call numa_crng_init until we have workqueues,
+		 * so mark this for processing later. */
+		crng_need_final_init = true;
+		return;
+	}
+
+	invalidate_batched_entropy();
+	numa_crng_init();
+	crng_init = 2;
+	process_random_ready_list();
+	wake_up_interruptible(&crng_init_wait);
+	kill_fasync(&fasync, SIGIO, POLL_IN);
+	pr_notice("crng init done\n");
+	if (unseeded_warning.missed) {
+		pr_notice("random: %d get_random_xx warning(s) missed "
+			  "due to ratelimiting\n",
+			  unseeded_warning.missed);
+		unseeded_warning.missed = 0;
+	}
+	if (urandom_warning.missed) {
+		pr_notice("random: %d urandom warning(s) missed "
+			  "due to ratelimiting\n",
+			  urandom_warning.missed);
+		urandom_warning.missed = 0;
+	}
+}
+
 #ifdef CONFIG_NUMA
 static void do_numa_crng_init(struct work_struct *work)
 {
@@ -1026,26 +1059,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	memzero_explicit(&buf, sizeof(buf));
 	crng->init_time = jiffies;
 	spin_unlock_irqrestore(&crng->lock, flags);
-	if (crng == &primary_crng && crng_init < 2) {
-		invalidate_batched_entropy();
-		numa_crng_init();
-		crng_init = 2;
-		process_random_ready_list();
-		wake_up_interruptible(&crng_init_wait);
-		pr_notice("random: crng init done\n");
-		if (unseeded_warning.missed) {
-			pr_notice("random: %d get_random_xx warning(s) missed "
-				  "due to ratelimiting\n",
-				  unseeded_warning.missed);
-			unseeded_warning.missed = 0;
-		}
-		if (urandom_warning.missed) {
-			pr_notice("random: %d urandom warning(s) missed "
-				  "due to ratelimiting\n",
-				  urandom_warning.missed);
-			urandom_warning.missed = 0;
-		}
-	}
+	crng_finalize_init(crng);
 }
 
 static void _extract_crng(struct crng_state *crng,
@@ -1957,6 +1971,8 @@ int __init rand_initialize(void)
 {
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
+	if (crng_need_final_init)
+		crng_finalize_init(&primary_crng);
 	crng_initialize(&primary_crng);
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {
@@ -2488,7 +2504,8 @@ void add_hwgenerator_randomness(const char *buffer, size_t count,
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			!system_wq || kthread_should_stop() ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);
-- 
2.34.1

