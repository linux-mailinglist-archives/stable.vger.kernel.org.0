Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65655810C
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiFWQzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbiFWQuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:50:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A6339BB6;
        Thu, 23 Jun 2022 09:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 353E961F8B;
        Thu, 23 Jun 2022 16:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2095BC36AEF;
        Thu, 23 Jun 2022 16:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002885;
        bh=znReL3Bz7ulJkDtoJgrRc5y3YWvl0l8kpupCwp8fJo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUfpvkSbrCJeVodHQDdbqDzNHjH2lnVKAprssuMLEikcNggwnoCxAKce3j3FNfSwd
         syaRINJfYHKQ5hJmFlPFLM2NaY3A0LIbS0zhhO8tkSJ1cy3W8RgP28DevovcGGgbiM
         Xn+5EfpVr7XHCgBdBvoYnUxcfGAI/BbwQGya8xGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ivan T. Ivanov" <iivanov@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 058/264] random: fix crash on multiple early calls to add_bootloader_randomness()
Date:   Thu, 23 Jun 2022 18:40:51 +0200
Message-Id: <20220623164345.714662107@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   60 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 22 deletions(-)

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
@@ -886,6 +887,38 @@ static void crng_initialize(struct crng_
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
@@ -1091,27 +1124,7 @@ static void crng_reseed(struct crng_stat
 	memzero_explicit(&buf, sizeof(buf));
 	WRITE_ONCE(crng->init_time, jiffies);
 	spin_unlock_irqrestore(&crng->lock, flags);
-	if (crng == &primary_crng && crng_init < 2) {
-		numa_crng_init();
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
@@ -1949,6 +1962,8 @@ int __init rand_initialize(void)
 {
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
+	if (crng_need_final_init)
+		crng_finalize_init(&primary_crng);
 	crng_initialize(&primary_crng);
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {
@@ -2467,7 +2482,8 @@ void add_hwgenerator_randomness(const ch
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			!system_wq || kthread_should_stop() ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);


