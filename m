Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352F5535C76
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350235AbiE0I6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 04:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350242AbiE0I5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 04:57:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCD9111BB0;
        Fri, 27 May 2022 01:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79ABA61CB7;
        Fri, 27 May 2022 08:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF56C385A9;
        Fri, 27 May 2022 08:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641678;
        bh=u1UqmCTFtjAEx/jrfzp+B7WVcH5ZjcmJTpDVL3lfdJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aoa5rqJogxNfERAUIL77HqqLA6Q13Fz2V06N0tiMZR2rX7YjVLfdgPiZ8fAKgJ92y
         SNOgrkwwSe4jLDJMVrHetCFh1qLvDdF4voQ9eckXcAx6wVAsjLUbg1IPYTdwU3rxmy
         CFrK8FGiaq6vCOewq8pRX83cibZeu9h7FGq0fQ7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.18 33/47] random: handle latent entropy and command line from random_init()
Date:   Fri, 27 May 2022 10:50:13 +0200
Message-Id: <20220527084806.884481906@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084801.223648383@linuxfoundation.org>
References: <20220527084801.223648383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 2f14062bb14b0fcfcc21e6dc7d5b5c0d25966164 upstream.

Currently, start_kernel() adds latent entropy and the command line to
the entropy bool *after* the RNG has been initialized, deferring when
it's actually used by things like stack canaries until the next time
the pool is seeded. This surely is not intended.

Rather than splitting up which entropy gets added where and when between
start_kernel() and random_init(), just do everything in random_init(),
which should eliminate these kinds of bugs in the future.

While we're at it, rename the awkwardly titled "rand_initialize()" to
the more standard "random_init()" nomenclature.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |   17 ++++++++++-------
 include/linux/random.h |   15 +++++++--------
 init/main.c            |   10 +++-------
 3 files changed, 20 insertions(+), 22 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -891,12 +891,13 @@ early_param("random.trust_bootloader", p
 
 /*
  * The first collection of entropy occurs at system boot while interrupts
- * are still turned off. Here we push in RDSEED, a timestamp, and utsname().
- * Depending on the above configuration knob, RDSEED may be considered
- * sufficient for initialization. Note that much earlier setup may already
- * have pushed entropy into the input pool by the time we get here.
+ * are still turned off. Here we push in latent entropy, RDSEED, a timestamp,
+ * utsname(), and the command line. Depending on the above configuration knob,
+ * RDSEED may be considered sufficient for initialization. Note that much
+ * earlier setup may already have pushed entropy into the input pool by the
+ * time we get here.
  */
-int __init rand_initialize(void)
+int __init random_init(const char *command_line)
 {
 	size_t i;
 	ktime_t now = ktime_get_real();
@@ -918,6 +919,8 @@ int __init rand_initialize(void)
 	}
 	_mix_pool_bytes(&now, sizeof(now));
 	_mix_pool_bytes(utsname(), sizeof(*(utsname())));
+	_mix_pool_bytes(command_line, strlen(command_line));
+	add_latent_entropy();
 
 	if (crng_ready())
 		crng_reseed();
@@ -1637,8 +1640,8 @@ static struct ctl_table random_table[] =
 };
 
 /*
- * rand_initialize() is called before sysctl_init(),
- * so we cannot call register_sysctl_init() in rand_initialize()
+ * random_init() is called before sysctl_init(),
+ * so we cannot call register_sysctl_init() in random_init()
  */
 static int __init random_sysctls_init(void)
 {
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -14,22 +14,21 @@ struct notifier_block;
 
 extern void add_device_randomness(const void *, size_t);
 extern void add_bootloader_randomness(const void *, size_t);
+extern void add_input_randomness(unsigned int type, unsigned int code,
+				 unsigned int value) __latent_entropy;
+extern void add_interrupt_randomness(int irq) __latent_entropy;
+extern void add_hwgenerator_randomness(const void *buffer, size_t count,
+				       size_t entropy);
 
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
 {
-	add_device_randomness((const void *)&latent_entropy,
-			      sizeof(latent_entropy));
+	add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
 }
 #else
 static inline void add_latent_entropy(void) {}
 #endif
 
-extern void add_input_randomness(unsigned int type, unsigned int code,
-				 unsigned int value) __latent_entropy;
-extern void add_interrupt_randomness(int irq) __latent_entropy;
-extern void add_hwgenerator_randomness(const void *buffer, size_t count,
-				       size_t entropy);
 #if IS_ENABLED(CONFIG_VMGENID)
 extern void add_vmfork_randomness(const void *unique_vm_id, size_t size);
 extern int register_random_vmfork_notifier(struct notifier_block *nb);
@@ -41,7 +40,7 @@ static inline int unregister_random_vmfo
 
 extern void get_random_bytes(void *buf, size_t nbytes);
 extern int wait_for_random_bytes(void);
-extern int __init rand_initialize(void);
+extern int __init random_init(const char *command_line);
 extern bool rng_is_initialized(void);
 extern int register_random_ready_notifier(struct notifier_block *nb);
 extern int unregister_random_ready_notifier(struct notifier_block *nb);
--- a/init/main.c
+++ b/init/main.c
@@ -1040,15 +1040,11 @@ asmlinkage __visible void __init __no_sa
 	/*
 	 * For best initial stack canary entropy, prepare it after:
 	 * - setup_arch() for any UEFI RNG entropy and boot cmdline access
-	 * - timekeeping_init() for ktime entropy used in rand_initialize()
+	 * - timekeeping_init() for ktime entropy used in random_init()
 	 * - time_init() for making random_get_entropy() work on some platforms
-	 * - rand_initialize() to get any arch-specific entropy like RDRAND
-	 * - add_latent_entropy() to get any latent entropy
-	 * - adding command line entropy
+	 * - random_init() to initialize the RNG from from early entropy sources
 	 */
-	rand_initialize();
-	add_latent_entropy();
-	add_device_randomness(command_line, strlen(command_line));
+	random_init(command_line);
 	boot_init_stack_canary();
 
 	perf_event_init();


