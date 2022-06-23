Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358285586E9
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbiFWSSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbiFWSQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:16:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2C323BF7;
        Thu, 23 Jun 2022 10:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20A94B824B9;
        Thu, 23 Jun 2022 17:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7313DC3411B;
        Thu, 23 Jun 2022 17:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004994;
        bh=IiaXwayGBRyMv0GG9TEvfsSN5y2GCz9DzDv5Fnqk7zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MII8xRmMMQ4u3fGDHDvt0SJlxxjR6Yqx3AOfSfXxW9cOVvAiOQ8kcUaOnB3xUBaG
         PtFb6AcPFfaW2csGj4H8v6oTRNalhnx9MsR7V7PTGHunnTiaG1c7LLYwYwJMM+eE4V
         xXnktt4Hh6wEUB/C9HlvebyCJzrILX4NxjlqE50M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 165/234] random: move initialization functions out of hot pages
Date:   Thu, 23 Jun 2022 18:43:52 +0200
Message-Id: <20220623164347.723375308@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

commit 560181c27b582557d633ecb608110075433383af upstream.

Much of random.c is devoted to initializing the rng and accounting for
when a sufficient amount of entropy has been added. In a perfect world,
this would all happen during init, and so we could mark these functions
as __init. But in reality, this isn't the case: sometimes the rng only
finishes initializing some seconds after system init is finished.

For this reason, at the moment, a whole host of functions that are only
used relatively close to system init and then never again are intermixed
with functions that are used in hot code all the time. This creates more
cache misses than necessary.

In order to pack the hot code closer together, this commit moves the
initialization functions that can't be marked as __init into
.text.unlikely by way of the __cold attribute.

Of particular note is moving credit_init_bits() into a macro wrapper
that inlines the crng_ready() static branch check. This avoids a
function call to a nop+ret, and most notably prevents extra entropy
arithmetic from being computed in mix_interrupt_randomness().

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
[ Jason: for stable, made sure the printk_deferred was a pr_notice,
  because those caused problems on ≤ 4.19 according to commit logs. ]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -109,7 +109,7 @@ bool rng_is_initialized(void)
 }
 EXPORT_SYMBOL(rng_is_initialized);
 
-static void crng_set_ready(struct work_struct *work)
+static void __cold crng_set_ready(struct work_struct *work)
 {
 	static_branch_enable(&crng_is_ready);
 }
@@ -148,7 +148,7 @@ EXPORT_SYMBOL(wait_for_random_bytes);
  * returns: 0 if callback is successfully added
  *	    -EALREADY if pool is already initialised (callback not called)
  */
-int register_random_ready_notifier(struct notifier_block *nb)
+int __cold register_random_ready_notifier(struct notifier_block *nb)
 {
 	unsigned long flags;
 	int ret = -EALREADY;
@@ -167,7 +167,7 @@ EXPORT_SYMBOL(register_random_ready_noti
 /*
  * Delete a previously registered readiness callback function.
  */
-int unregister_random_ready_notifier(struct notifier_block *nb)
+int __cold unregister_random_ready_notifier(struct notifier_block *nb)
 {
 	unsigned long flags;
 	int ret;
@@ -179,7 +179,7 @@ int unregister_random_ready_notifier(str
 }
 EXPORT_SYMBOL(unregister_random_ready_notifier);
 
-static void process_random_ready_list(void)
+static void __cold process_random_ready_list(void)
 {
 	unsigned long flags;
 
@@ -189,15 +189,9 @@ static void process_random_ready_list(vo
 }
 
 #define warn_unseeded_randomness() \
-	_warn_unseeded_randomness(__func__, (void *)_RET_IP_)
-
-static void _warn_unseeded_randomness(const char *func_name, void *caller)
-{
-	if (!IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM) || crng_ready())
-		return;
-	printk_deferred(KERN_NOTICE "random: %s called from %pS with crng_init=%d\n",
-			func_name, caller, crng_init);
-}
+	if (IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM) && !crng_ready()) \
+		pr_notice("%s called from %pS with crng_init=%d\n", \
+			  __func__, (void *)_RET_IP_, crng_init)
 
 
 /*********************************************************************
@@ -611,7 +605,7 @@ EXPORT_SYMBOL(get_random_u32);
  * This function is called when the CPU is coming up, with entry
  * CPUHP_RANDOM_PREPARE, which comes before CPUHP_WORKQUEUE_PREP.
  */
-int random_prepare_cpu(unsigned int cpu)
+int __cold random_prepare_cpu(unsigned int cpu)
 {
 	/*
 	 * When the cpu comes back online, immediately invalidate both
@@ -786,13 +780,15 @@ static void extract_entropy(void *buf, s
 	memzero_explicit(&block, sizeof(block));
 }
 
-static void credit_init_bits(size_t bits)
+#define credit_init_bits(bits) if (!crng_ready()) _credit_init_bits(bits)
+
+static void __cold _credit_init_bits(size_t bits)
 {
 	static struct execute_work set_ready;
 	unsigned int new, orig, add;
 	unsigned long flags;
 
-	if (crng_ready() || !bits)
+	if (!bits)
 		return;
 
 	add = min_t(size_t, bits, POOL_BITS);
@@ -971,7 +967,7 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_random
  * Handle random seed passed by bootloader, and credit it if
  * CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  */
-void add_bootloader_randomness(const void *buf, size_t len)
+void __cold add_bootloader_randomness(const void *buf, size_t len)
 {
 	mix_pool_bytes(buf, len);
 	if (trust_bootloader)
@@ -1017,7 +1013,7 @@ static void fast_mix(unsigned long s[4],
  * This function is called when the CPU has just come online, with
  * entry CPUHP_AP_RANDOM_ONLINE, just after CPUHP_AP_WORKQUEUE_ONLINE.
  */
-int random_online_cpu(unsigned int cpu)
+int __cold random_online_cpu(unsigned int cpu)
 {
 	/*
 	 * During CPU shutdown and before CPU onlining, add_interrupt_
@@ -1172,7 +1168,7 @@ static void add_timer_randomness(struct
 	if (in_irq())
 		this_cpu_ptr(&irq_randomness)->count += max(1u, bits * 64) - 1;
 	else
-		credit_init_bits(bits);
+		_credit_init_bits(bits);
 }
 
 void add_input_randomness(unsigned int type, unsigned int code, unsigned int value)
@@ -1200,7 +1196,7 @@ void add_disk_randomness(struct gendisk
 }
 EXPORT_SYMBOL_GPL(add_disk_randomness);
 
-void rand_initialize_disk(struct gendisk *disk)
+void __cold rand_initialize_disk(struct gendisk *disk)
 {
 	struct timer_rand_state *state;
 
@@ -1229,7 +1225,7 @@ void rand_initialize_disk(struct gendisk
  *
  * So the re-arming always happens in the entropy loop itself.
  */
-static void entropy_timer(struct timer_list *t)
+static void __cold entropy_timer(struct timer_list *t)
 {
 	credit_init_bits(1);
 }
@@ -1238,7 +1234,7 @@ static void entropy_timer(struct timer_l
  * If we have an actual cycle counter, see if we can
  * generate enough entropy with timing noise
  */
-static void try_to_generate_entropy(void)
+static void __cold try_to_generate_entropy(void)
 {
 	struct {
 		unsigned long entropy;


