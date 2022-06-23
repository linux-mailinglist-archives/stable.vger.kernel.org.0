Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14ED558036
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiFWQp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiFWQpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:45:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB16C48899;
        Thu, 23 Jun 2022 09:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EA7DB8248F;
        Thu, 23 Jun 2022 16:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACD4C3411B;
        Thu, 23 Jun 2022 16:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002751;
        bh=UJbNQsL86PVWUqz13KC7v/orYDAXFsPseKU0Ve2rG/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9LCBKRY1hy41xFPtuXRH5vqbRxUrCCqO+y4OLkd053m/uDZasZ0zFEVrDaICOg0R
         PC6UjbG+qct8VjWK368KRKAzfAykBJw8RWT0EuLLP9dhEVDUe4oVA+35X6wm5+/Ay6
         4Lk1LvRrS6xPU5BYUkgBZRMjEUbf4LVTuORrLMUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 014/264] random: suppress spammy warnings about unseeded randomness
Date:   Thu, 23 Jun 2022 18:40:07 +0200
Message-Id: <20220623164344.467912888@linuxfoundation.org>
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

From: Theodore Ts'o <tytso@mit.edu>

commit eecabf567422eda02bd179f2707d8fe24f52d888 upstream.

Unfortunately, on some models of some architectures getting a fully
seeded CRNG is extremely difficult, and so this can result in dmesg
getting spammed for a surprisingly long time.  This is really bad from
a security perspective, and so architecture maintainers really need to
do what they can to get the CRNG seeded sooner after the system is
booted.  However, users can't do anything actionble to address this,
and spamming the kernel messages log will only just annoy people.

For developers who want to work on improving this situation,
CONFIG_WARN_UNSEEDED_RANDOM has been renamed to
CONFIG_WARN_ALL_UNSEEDED_RANDOM.  By default the kernel will always
print the first use of unseeded randomness.  This way, hopefully the
security obsessed will be happy that there is _some_ indication when
the kernel boots there may be a potential issue with that architecture
or subarchitecture.  To see all uses of unseeded randomness,
developers can enable CONFIG_WARN_ALL_UNSEEDED_RANDOM.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   56 ++++++++++++++++++++++++++++++++++----------------
 lib/Kconfig.debug     |   24 ++++++++++++++++-----
 2 files changed, 57 insertions(+), 23 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -438,6 +438,7 @@ static void _extract_crng(struct crng_st
 static void _crng_backtrack_protect(struct crng_state *crng,
 				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used);
 static void process_random_ready_list(void);
+static void _get_random_bytes(void *buf, int nbytes);
 
 static struct ratelimit_state unseeded_warning =
 	RATELIMIT_STATE_INIT("warn_unseeded_randomness", HZ, 3);
@@ -788,7 +789,7 @@ static void crng_initialize(struct crng_
 		_extract_entropy(&input_pool, &crng->state[4],
 				 sizeof(__u32) * 12, 0);
 	else
-		get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
+		_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
 	for (i = 4; i < 16; i++) {
 		if (!arch_get_random_seed_long(&rv) &&
 		    !arch_get_random_long(&rv))
@@ -1535,6 +1536,30 @@ static ssize_t extract_entropy_user(stru
 	return ret;
 }
 
+#define warn_unseeded_randomness(previous) \
+	_warn_unseeded_randomness(__func__, (void *) _RET_IP_, (previous))
+
+static void _warn_unseeded_randomness(const char *func_name, void *caller,
+				      void **previous)
+{
+#ifdef CONFIG_WARN_ALL_UNSEEDED_RANDOM
+	const bool print_once = false;
+#else
+	static bool print_once __read_mostly;
+#endif
+
+	if (print_once ||
+	    crng_ready() ||
+	    (previous && (caller == READ_ONCE(*previous))))
+		return;
+	WRITE_ONCE(*previous, caller);
+#ifndef CONFIG_WARN_ALL_UNSEEDED_RANDOM
+	print_once = true;
+#endif
+	pr_notice("random: %s called from %pF with crng_init=%d\n",
+		  func_name, caller, crng_init);
+}
+
 /*
  * This function is the exported kernel interface.  It returns some
  * number of good random numbers, suitable for key generation, seeding
@@ -1545,15 +1570,10 @@ static ssize_t extract_entropy_user(stru
  * wait_for_random_bytes() should be called and return 0 at least once
  * at any point prior.
  */
-void get_random_bytes(void *buf, int nbytes)
+static void _get_random_bytes(void *buf, int nbytes)
 {
 	__u8 tmp[CHACHA20_BLOCK_SIZE];
 
-#ifdef CONFIG_WARN_UNSEEDED_RANDOM
-	if (!crng_ready())
-		printk(KERN_NOTICE "random: %pF get_random_bytes called "
-		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
-#endif
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
 	while (nbytes >= CHACHA20_BLOCK_SIZE) {
@@ -1570,6 +1590,14 @@ void get_random_bytes(void *buf, int nby
 		crng_backtrack_protect(tmp, CHACHA20_BLOCK_SIZE);
 	memzero_explicit(tmp, sizeof(tmp));
 }
+
+void get_random_bytes(void *buf, int nbytes)
+{
+	static void *previous;
+
+	warn_unseeded_randomness(&previous);
+	_get_random_bytes(buf, nbytes);
+}
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
@@ -2136,6 +2164,7 @@ u64 get_random_u64(void)
 	bool use_lock = READ_ONCE(crng_init) < 2;
 	unsigned long flags = 0;
 	struct batched_entropy *batch;
+	static void *previous;
 
 #if BITS_PER_LONG == 64
 	if (arch_get_random_long((unsigned long *)&ret))
@@ -2146,11 +2175,7 @@ u64 get_random_u64(void)
 	    return ret;
 #endif
 
-#ifdef CONFIG_WARN_UNSEEDED_RANDOM
-	if (!crng_ready())
-		printk(KERN_NOTICE "random: %pF get_random_u64 called "
-		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
-#endif
+	warn_unseeded_randomness(&previous);
 
 	batch = &get_cpu_var(batched_entropy_u64);
 	if (use_lock)
@@ -2174,15 +2199,12 @@ u32 get_random_u32(void)
 	bool use_lock = READ_ONCE(crng_init) < 2;
 	unsigned long flags = 0;
 	struct batched_entropy *batch;
+	static void *previous;
 
 	if (arch_get_random_int(&ret))
 		return ret;
 
-#ifdef CONFIG_WARN_UNSEEDED_RANDOM
-	if (!crng_ready())
-		printk(KERN_NOTICE "random: %pF get_random_u32 called "
-		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
-#endif
+	warn_unseeded_randomness(&previous);
 
 	batch = &get_cpu_var(batched_entropy_u32);
 	if (use_lock)
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1177,10 +1177,9 @@ config STACKTRACE
 	  It is also used by various kernel debugging features that require
 	  stack trace generation.
 
-config WARN_UNSEEDED_RANDOM
-	bool "Warn when kernel uses unseeded randomness"
-	default y
-	depends on DEBUG_KERNEL
+config WARN_ALL_UNSEEDED_RANDOM
+	bool "Warn for all uses of unseeded randomness"
+	default n
 	help
 	  Some parts of the kernel contain bugs relating to their use of
 	  cryptographically secure random numbers before it's actually possible
@@ -1190,8 +1189,21 @@ config WARN_UNSEEDED_RANDOM
 	  are going wrong, so that they might contact developers about fixing
 	  it.
 
-	  Say Y here, unless you simply do not care about using unseeded
-	  randomness and do not want a potential warning message in your logs.
+	  Unfortunately, on some models of some architectures getting
+	  a fully seeded CRNG is extremely difficult, and so this can
+	  result in dmesg getting spammed for a surprisingly long
+	  time.  This is really bad from a security perspective, and
+	  so architecture maintainers really need to do what they can
+	  to get the CRNG seeded sooner after the system is booted.
+	  However, since users can not do anything actionble to
+	  address this, by default the kernel will issue only a single
+	  warning for the first use of unseeded randomness.
+
+	  Say Y here if you want to receive warnings for all uses of
+	  unseeded randomness.  This will be of use primarily for
+	  those developers interersted in improving the security of
+	  Linux kernels running on their architecture (or
+	  subarchitecture).
 
 config DEBUG_KOBJECT
 	bool "kobject debugging"


