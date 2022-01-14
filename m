Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C64048E565
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiANIRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbiANIRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:17:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93390C06174E;
        Fri, 14 Jan 2022 00:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E77CB8243C;
        Fri, 14 Jan 2022 08:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84222C36AEA;
        Fri, 14 Jan 2022 08:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148263;
        bh=KcD0sYL6CVc3BtWUwmc6cDHq9Vg8plJozZ2DfE6d1Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpanQmDuxrtrNQTEZKboxsTHAOJpMszWUCp6F2Gv570qTak2q0g/QV9iElY2jz7+8
         wurBvei6FPYITja9QWx+ly76MPc7yPD+mm7k0pBEGc1NOPdY3/DswzFZYGOQupTNPg
         pT9ehLtcUTc0DUcwK99jItV5KxOnrVxxpSLmntPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ivan T. Ivanov" <iivanov@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 14/18] random: fix crash on multiple early calls to add_bootloader_randomness()
Date:   Fri, 14 Jan 2022 09:16:21 +0100
Message-Id: <20220114081541.952223820@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
References: <20220114081541.465841464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   59 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 21 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -497,6 +497,7 @@ static struct crng_state primary_crng =
  * its value (from 0->1->2).
  */
 static int crng_init = 0;
+static bool crng_need_final_init = false;
 #define crng_ready() (likely(crng_init > 1))
 static int crng_init_cnt = 0;
 static unsigned long crng_global_init_time = 0;
@@ -889,6 +890,38 @@ static void crng_initialize(struct crng_
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
@@ -1044,26 +1077,7 @@ static void crng_reseed(struct crng_stat
 	memzero_explicit(&buf, sizeof(buf));
 	WRITE_ONCE(crng->init_time, jiffies);
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
@@ -1962,6 +1976,8 @@ int __init rand_initialize(void)
 {
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
+	if (crng_need_final_init)
+		crng_finalize_init(&primary_crng);
 	crng_initialize(&primary_crng);
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {
@@ -2493,7 +2509,8 @@ void add_hwgenerator_randomness(const ch
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			!system_wq || kthread_should_stop() ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);


