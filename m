Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B39558245
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiFWRN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFWRLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:11:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AFE18364;
        Thu, 23 Jun 2022 09:51:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C06AA61F62;
        Thu, 23 Jun 2022 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE2FC3411B;
        Thu, 23 Jun 2022 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003070;
        bh=B+p7EtKRj9a5tVfJTGyiXDhd9taRre9xiGKcJXTVWl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faVrZObDdenQTWRpEl9shrcppjtgsEAiZsq5CZp3Npl5bTCIn9Z50djTEQQpiqwdX
         f3hGIYAiFiObvl7A7Bpar+Ptk8CYQBAAWUGMSw8zc0tLkVcB8xaoQlCJpDEqkLcws2
         ylNyprP6kqyixzbCgyWmKhmApnvwL4y/4kJRWn6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 119/264] random: inline leaves of rand_initialize()
Date:   Thu, 23 Jun 2022 18:41:52 +0200
Message-Id: <20220623164347.434462658@linuxfoundation.org>
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

commit 8566417221fcec51346ec164e920dacb979c6b5f upstream.

This is a preparatory commit for the following one. We simply inline the
various functions that rand_initialize() calls that have no other
callers. The compiler was doing this anyway before. Doing this will
allow us to reorganize this after. We can then move the trust_cpu and
parse_trust_cpu definitions a bit closer to where they're actually used,
which makes the code easier to read.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   90 ++++++++++++++++++--------------------------------
 1 file changed, 33 insertions(+), 57 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -477,42 +477,6 @@ static DECLARE_WAIT_QUEUE_HEAD(crng_init
 
 static void invalidate_batched_entropy(void);
 
-static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
-static int __init parse_trust_cpu(char *arg)
-{
-	return kstrtobool(arg, &trust_cpu);
-}
-early_param("random.trust_cpu", parse_trust_cpu);
-
-static bool __init crng_init_try_arch_early(void)
-{
-	int i;
-	bool arch_init = true;
-	unsigned long rv;
-
-	for (i = 4; i < 16; i++) {
-		if (!arch_get_random_seed_long_early(&rv) &&
-		    !arch_get_random_long_early(&rv)) {
-			rv = random_get_entropy();
-			arch_init = false;
-		}
-		primary_crng.state[i] ^= rv;
-	}
-
-	return arch_init;
-}
-
-static void __init crng_initialize(void)
-{
-	extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
-	if (crng_init_try_arch_early() && trust_cpu && crng_init < 2) {
-		invalidate_batched_entropy();
-		crng_init = 2;
-		pr_notice("crng init done (trusting CPU's manufacturer)\n");
-	}
-	primary_crng.init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
-}
-
 /*
  * crng_fast_load() can be called by code in the interrupt service
  * path.  So we can't afford to dilly-dally. Returns the number of
@@ -1272,17 +1236,28 @@ int __must_check get_random_bytes_arch(v
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
+static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
+static int __init parse_trust_cpu(char *arg)
+{
+	return kstrtobool(arg, &trust_cpu);
+}
+early_param("random.trust_cpu", parse_trust_cpu);
+
 /*
- * init_std_data - initialize pool with system data
- *
- * This function clears the pool's entropy count and mixes some system
- * data into the pool to prepare it for use. The pool is not cleared
- * as that can only decrease the entropy in the pool.
+ * Note that setup_arch() may call add_device_randomness()
+ * long before we get here. This allows seeding of the pools
+ * with some platform dependent data very early in the boot
+ * process. But it limits our options here. We must use
+ * statically allocated structures that already have all
+ * initializations complete at compile time. We should also
+ * take care not to overwrite the precious per platform data
+ * we were given.
  */
-static void __init init_std_data(void)
+int __init rand_initialize(void)
 {
 	int i;
 	ktime_t now = ktime_get_real();
+	bool arch_init = true;
 	unsigned long rv;
 
 	mix_pool_bytes(&now, sizeof(now));
@@ -1293,22 +1268,23 @@ static void __init init_std_data(void)
 		mix_pool_bytes(&rv, sizeof(rv));
 	}
 	mix_pool_bytes(utsname(), sizeof(*(utsname())));
-}
 
-/*
- * Note that setup_arch() may call add_device_randomness()
- * long before we get here. This allows seeding of the pools
- * with some platform dependent data very early in the boot
- * process. But it limits our options here. We must use
- * statically allocated structures that already have all
- * initializations complete at compile time. We should also
- * take care not to overwrite the precious per platform data
- * we were given.
- */
-int __init rand_initialize(void)
-{
-	init_std_data();
-	crng_initialize();
+	extract_entropy(&primary_crng.state[4], sizeof(u32) * 12);
+	for (i = 4; i < 16; i++) {
+		if (!arch_get_random_seed_long_early(&rv) &&
+		    !arch_get_random_long_early(&rv)) {
+			rv = random_get_entropy();
+			arch_init = false;
+		}
+		primary_crng.state[i] ^= rv;
+	}
+	if (arch_init && trust_cpu && crng_init < 2) {
+		invalidate_batched_entropy();
+		crng_init = 2;
+		pr_notice("crng init done (trusting CPU's manufacturer)\n");
+	}
+	primary_crng.init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
+
 	if (ratelimit_disable) {
 		urandom_warning.interval = 0;
 		unseeded_warning.interval = 0;


