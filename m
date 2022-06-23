Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F719558519
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbiFWRyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiFWRxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:53:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E87156C32;
        Thu, 23 Jun 2022 10:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA09961D18;
        Thu, 23 Jun 2022 17:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98838C3411B;
        Thu, 23 Jun 2022 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004436;
        bh=3tkh22Re/afsFv7a8hSMRkq5aRZJpKzulIY4E5amcmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HxzD7LXCkoqrKxvEkKooa1KG7pkX3qXxBEBro+Wvr08WjGC5smSEyAm/OUV4e7P5
         wXCLnhmHNTvn2SR3gbNPNwNurQ+2UOJot9yroN3T1qd2Ph06/D4+RvQ9dw9SsZ/+tR
         PKVlmtg5zrONdkILc0ggWtHJUPj75IpvE1WQisFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 006/234] random: move rand_initialize() earlier
Date:   Thu, 23 Jun 2022 18:41:13 +0200
Message-Id: <20220623164343.233243132@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit d55535232c3dbde9a523a9d10d68670f5fe5dec3 upstream.

Right now rand_initialize() is run as an early_initcall(), but it only
depends on timekeeping_init() (for mixing ktime_get_real() into the
pools). However, the call to boot_init_stack_canary() for stack canary
initialization runs earlier, which triggers a warning at boot:

random: get_random_bytes called from start_kernel+0x357/0x548 with crng_init=0

Instead, this moves rand_initialize() to after timekeeping_init(), and moves
canary initialization here as well.

Note that this warning may still remain for machines that do not have
UEFI RNG support (which initializes the RNG pools during setup_arch()),
or for x86 machines without RDRAND (or booting without "random.trust=on"
or CONFIG_RANDOM_TRUST_CPU=y).

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |    5 ++---
 include/linux/random.h |    1 +
 init/main.c            |   21 ++++++++++++++-------
 3 files changed, 17 insertions(+), 10 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1852,7 +1852,7 @@ EXPORT_SYMBOL(get_random_bytes_arch);
  * data into the pool to prepare it for use. The pool is not cleared
  * as that can only decrease the entropy in the pool.
  */
-static void init_std_data(struct entropy_store *r)
+static void __init init_std_data(struct entropy_store *r)
 {
 	int i;
 	ktime_t now = ktime_get_real();
@@ -1879,7 +1879,7 @@ static void init_std_data(struct entropy
  * take care not to overwrite the precious per platform data
  * we were given.
  */
-static int rand_initialize(void)
+int __init rand_initialize(void)
 {
 	init_std_data(&input_pool);
 	init_std_data(&blocking_pool);
@@ -1891,7 +1891,6 @@ static int rand_initialize(void)
 	}
 	return 0;
 }
-early_initcall(rand_initialize);
 
 #ifdef CONFIG_BLOCK
 void rand_initialize_disk(struct gendisk *disk)
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -36,6 +36,7 @@ extern void add_interrupt_randomness(int
 
 extern void get_random_bytes(void *buf, int nbytes);
 extern int wait_for_random_bytes(void);
+extern int __init rand_initialize(void);
 extern bool rng_is_initialized(void);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
--- a/init/main.c
+++ b/init/main.c
@@ -549,13 +549,6 @@ asmlinkage __visible void __init start_k
 	page_address_init();
 	pr_notice("%s", linux_banner);
 	setup_arch(&command_line);
-	/*
-	 * Set up the the initial canary and entropy after arch
-	 * and after adding latent and command line entropy.
-	 */
-	add_latent_entropy();
-	add_device_randomness(command_line, strlen(command_line));
-	boot_init_stack_canary();
 	mm_init_cpumask(&init_mm);
 	setup_command_line(command_line);
 	setup_nr_cpu_ids();
@@ -640,6 +633,20 @@ asmlinkage __visible void __init start_k
 	hrtimers_init();
 	softirq_init();
 	timekeeping_init();
+
+	/*
+	 * For best initial stack canary entropy, prepare it after:
+	 * - setup_arch() for any UEFI RNG entropy and boot cmdline access
+	 * - timekeeping_init() for ktime entropy used in rand_initialize()
+	 * - rand_initialize() to get any arch-specific entropy like RDRAND
+	 * - add_latent_entropy() to get any latent entropy
+	 * - adding command line entropy
+	 */
+	rand_initialize();
+	add_latent_entropy();
+	add_device_randomness(command_line, strlen(command_line));
+	boot_init_stack_canary();
+
 	time_init();
 	perf_event_init();
 	profile_init();


