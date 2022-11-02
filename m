Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9725E6164A9
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 15:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiKBONn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 10:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiKBONl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 10:13:41 -0400
X-Greylist: delayed 282 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Nov 2022 07:13:39 PDT
Received: from a27-187.smtp-out.us-west-2.amazonses.com (a27-187.smtp-out.us-west-2.amazonses.com [54.240.27.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB96DFEB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 07:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=kavfeamixyqio744vq7kdfqcdpcfdjcm; d=roku.com; t=1667398137;
        h=Date:Message-Id:To:Cc:From:Reply-To:Subject;
        bh=g5Jj4/psf2qPo/BKWUvksXL/ucMWb5ZVkcmDv7MFSWE=;
        b=Zz8xYjBvxF9rEhOuBbeJmB287sDbUYU+YNXGwQCGRnKmWRkElJk6UZjNqii2EzEf
        vq0aGYj7Jk1PaWS+SOTls3XC9CJs+pDBVSiGcn+4nhddFylT6A6uoFBq11yFDZMVfAs
        spgIwuKP8PfA+vSVpwggWcsos5ou9pQniSEw/Bys=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1667398137;
        h=Date:Message-Id:To:Cc:From:Reply-To:Subject:Feedback-ID;
        bh=g5Jj4/psf2qPo/BKWUvksXL/ucMWb5ZVkcmDv7MFSWE=;
        b=DDixd+zJwI8QDSXOkxN45kTsfyBrt+ICPrf7gVKd8S8D4vZ6y25IpG2JqQzr7cnJ
        dYsX1obv2rg1bFhxP4SXjJK/iNWad4O7gSve+60h8a/OJ76gJivrM1kl0Voxny2VudK
        RMC8p4/FhSljlVhYNbd/7uTyID7VADhfk0k+b5QM=
Date:   Wed, 2 Nov 2022 14:08:56 +0000
Message-ID: <0101018438ac7455-a1733041-0940-4855-905e-2bbb6c95685f-000000@us-west-2.amazonses.com>
To:     bscattergood@roku.com, dmendenhall@roku.com, kcooper@roku.com,
        ksandvik@roku.com, mizhang@roku.com, najain@roku.com,
        pzhang@roku.com, sabellera@roku.com, snahibin@roku.com,
        tparker@roku.com
Cc:     stable@vger.kernel.org
From:   no-reply@roku.com (Automation Account)
Reply-To: no-reply@roku.com ((Automation Account))
Subject: PERFORCE change 3222717: commit 1a55116834aad9a6fe7d3ea03e4a6998150eb2fb
Feedback-ID: 1.us-west-2.J7/CQbUSlVIlOn4fv32wqSnUATrm78Y7YaTj1nfQ4pI=:AmazonSES
X-SES-Outgoing: 2022.11.02-54.240.27.187
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        HEXHASH_WORD,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Change 3222717 by automation@vsergiienko-flipday-internal-rtd1395-nemo on 2022/11/02 14:06:37

	commit 1a55116834aad9a6fe7d3ea03e4a6998150eb2fb
	Author: Manjur Khan <mokhan@roku.com>
	Date:   Mon Oct 31 13:20:42 2022 -0700
	
	    REALTEK-9066 credit-rng to Nemo to fix FW-133531 by improving entropy at boot for WPA3 TLS OpenSSL+, patch-2 applied.
	    From git@gitlab-partner.tools.roku.com:rtd1315x-stark/stark.git
	    From bf8a4000ed271b6772ec4562fa3309ed07bdaf0b
	    From: Dominik Brodowski <linux@dominikbrodowski.net>
	    Date: Wed, 29 Dec 2021 22:10:03 +0100
	    Subject: [PATCH] random: fix crash on multiple early calls to
	     add_bootloader_randomness()
	    
	    Currently, if CONFIG_RANDOM_TRUST_BOOTLOADER is enabled, multiple calls
	    to add_bootloader_randomness() are broken and can cause a NULL pointer
	    dereference, as noted by Ivan T. Ivanov. This is not only a hypothetical
	    problem, as qemu on arm64 may provide bootloader entropy via EFI and via
	    devicetree.
	    
	    On the first call to add_hwgenerator_randomness(), crng_fast_load() is
	    executed, and if the seed is long enough, crng_init will be set to 1.
	    On subsequent calls to add_bootloader_randomness() and then to
	    add_hwgenerator_randomness(), crng_fast_load() will be skipped. Instead,
	    wait_event_interruptible() and then credit_entropy_bits() will be
	    called.
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
	    Fixes: 18b915ac6b0a ("efi/random: Treat EFI_RNG_PROTOCOL output as
	    bootloader randomness")
	    Cc: stable@vger.kernel.org
	    Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
	    [Jason: added crng_need_done state and related logic.]
	    Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Affected files ...

.. //depot/firmware/release/main/port/realtek/rtd1395/platform/software_phoenix/linux-kernel/drivers/char/random.c#3 edit

Differences ...

==== //depot/firmware/release/main/port/realtek/rtd1395/platform/software_phoenix/linux-kernel/drivers/char/random.c#3 (text) ====

@@ -432,6 +432,7 @@
  * its value (from 0->1->2).
  */
 static int crng_init = 0;
+static bool crng_need_final_init = false;
 #define crng_ready() (likely(crng_init > 1))
 static int crng_init_cnt = 0;
 static unsigned long crng_global_init_time = 0;
@@ -860,6 +861,36 @@
 static void numa_crng_init(void) {}
 #endif
 
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
+	numa_crng_init();
+	crng_init = 2;
+	process_random_ready_list();
+	wake_up_interruptible(&crng_init_wait);
+	pr_notice("random: crng init done\n");
+	if (unseeded_warning.missed) {
+		pr_notice("random: %d get_random_xx warning(s) missed "
+				"due to ratelimiting\n",
+				unseeded_warning.missed);
+		unseeded_warning.missed = 0;
+	}
+	if (urandom_warning.missed) {
+		pr_notice("random: %d urandom warning(s) missed "
+				"due to ratelimiting\n",
+				urandom_warning.missed);
+		urandom_warning.missed = 0;
+	}
+}
+
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 {
 	unsigned long	flags;
@@ -888,25 +919,7 @@
 	}
 	memzero_explicit(&buf, sizeof(buf));
 	crng->init_time = jiffies;
-	if (crng == &primary_crng && crng_init < 2) {
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
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
@@ -1717,6 +1730,8 @@
 {
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
+	if (crng_need_final_init)
+		crng_finalize_init(&primary_crng);
 	crng_initialize(&primary_crng);
 	crng_global_init_time = jiffies;
 	if (ratelimit_disable) {
@@ -2216,7 +2231,8 @@
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_interruptible(random_write_wait, kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			!system_wq || kthread_should_stop() ||
 			ENTROPY_BITS(&input_pool) <= random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);
