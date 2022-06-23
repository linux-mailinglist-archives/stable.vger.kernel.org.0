Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC3F5581F4
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiFWRJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbiFWRHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:07:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AE317E11;
        Thu, 23 Jun 2022 09:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56E0160AE7;
        Thu, 23 Jun 2022 16:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B79C3411B;
        Thu, 23 Jun 2022 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003354;
        bh=YxdxAC3LxCpDG3ZTlPg8+JlXYE0R7tBD+1qYYSNHJvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ug2Cml2pAujQjWNwGxCHWx4NPIVts6l7FUtgZx8u4pTwvPFSQsvXV4MdebqUCiFvd
         NvisY/bKnCRGrU0go8hs4iJJ4AVLavP1TJPASEmN7aoE4Y45qH/N1oJTNbOq3nj0/3
         IzBKm+d/q8D3nJY499KTHeIw+1Ta/31LciyAfO04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 209/264] random: move initialization functions out of hot pages
Date:   Thu, 23 Jun 2022 18:43:22 +0200
Message-Id: <20220623164349.985176702@linuxfoundation.org>
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
@@ -110,7 +110,7 @@ bool rng_is_initialized(void)
 }
 EXPORT_SYMBOL(rng_is_initialized);
 
-static void crng_set_ready(struct work_struct *work)
+static void __cold crng_set_ready(struct work_struct *work)
 {
 	static_branch_enable(&crng_is_ready);
 }
@@ -149,7 +149,7 @@ EXPORT_SYMBOL(wait_for_random_bytes);
  * returns: 0 if callback is successfully added
  *	    -EALREADY if pool is already initialised (callback not called)
  */
-int register_random_ready_notifier(struct notifier_block *nb)
+int __cold register_random_ready_notifier(struct notifier_block *nb)
 {
 	unsigned long flags;
 	int ret = -EALREADY;
@@ -168,7 +168,7 @@ EXPORT_SYMBOL(register_random_ready_noti
 /*
  * Delete a previously registered readiness callback function.
  */
-int unregister_random_ready_notifier(struct notifier_block *nb)
+int __cold unregister_random_ready_notifier(struct notifier_block *nb)
 {
 	unsigned long flags;
 	int ret;
@@ -180,7 +180,7 @@ int unregister_random_ready_notifier(str
 }
 EXPORT_SYMBOL(unregister_random_ready_notifier);
 
-static void process_random_ready_list(void)
+static void __cold process_random_ready_list(void)
 {
 	unsigned long flags;
 
@@ -190,15 +190,9 @@ static void process_random_ready_list(vo
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
@@ -612,7 +606,7 @@ EXPORT_SYMBOL(get_random_u32);
  * This function is called when the CPU is coming up, with entry
  * CPUHP_RANDOM_PREPARE, which comes before CPUHP_WORKQUEUE_PREP.
  */
-int random_prepare_cpu(unsigned int cpu)
+int __cold random_prepare_cpu(unsigned int cpu)
 {
 	/*
 	 * When the cpu comes back online, immediately invalidate both
@@ -787,13 +781,15 @@ static void extract_entropy(void *buf, s
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
@@ -972,7 +968,7 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_random
  * Handle random seed passed by bootloader, and credit it if
  * CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  */
-void add_bootloader_randomness(const void *buf, size_t len)
+void __cold add_bootloader_randomness(const void *buf, size_t len)
 {
 	mix_pool_bytes(buf, len);
 	if (trust_bootloader)
@@ -1018,7 +1014,7 @@ static void fast_mix(unsigned long s[4],
  * This function is called when the CPU has just come online, with
  * entry CPUHP_AP_RANDOM_ONLINE, just after CPUHP_AP_WORKQUEUE_ONLINE.
  */
-int random_online_cpu(unsigned int cpu)
+int __cold random_online_cpu(unsigned int cpu)
 {
 	/*
 	 * During CPU shutdown and before CPU onlining, add_interrupt_
@@ -1173,7 +1169,7 @@ static void add_timer_randomness(struct
 	if (in_irq())
 		this_cpu_ptr(&irq_randomness)->count += max(1u, bits * 64) - 1;
 	else
-		credit_init_bits(bits);
+		_credit_init_bits(bits);
 }
 
 void add_input_randomness(unsigned int type, unsigned int code, unsigned int value)
@@ -1201,7 +1197,7 @@ void add_disk_randomness(struct gendisk
 }
 EXPORT_SYMBOL_GPL(add_disk_randomness);
 
-void rand_initialize_disk(struct gendisk *disk)
+void __cold rand_initialize_disk(struct gendisk *disk)
 {
 	struct timer_rand_state *state;
 
@@ -1230,7 +1226,7 @@ void rand_initialize_disk(struct gendisk
  *
  * So the re-arming always happens in the entropy loop itself.
  */
-static void entropy_timer(unsigned long data)
+static void __cold entropy_timer(unsigned long data)
 {
 	credit_init_bits(1);
 }
@@ -1239,7 +1235,7 @@ static void entropy_timer(unsigned long
  * If we have an actual cycle counter, see if we can
  * generate enough entropy with timing noise
  */
-static void try_to_generate_entropy(void)
+static void __cold try_to_generate_entropy(void)
 {
 	struct {
 		unsigned long entropy;


