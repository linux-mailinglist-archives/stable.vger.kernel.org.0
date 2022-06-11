Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F630547392
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 12:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiFKKFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 06:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiFKKFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 06:05:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323F91162;
        Sat, 11 Jun 2022 03:05:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC478B83610;
        Sat, 11 Jun 2022 10:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F036C34116;
        Sat, 11 Jun 2022 10:05:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gguJbPAu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654941909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C9JEGD/T94874e2WQF0vvmCHKGBmTtNF2+fOXO/TMAY=;
        b=gguJbPAuUbQTPdt/YwAUtZcmUJRay7cAzE/0jzDFDjQdJ+GZLeAB3i3PJZTtc6cxiYfMvN
        AfL78on8rWVrbMkCAmyZZSZ0l+Dy0wOOb9geL1VP6+peK+MNGplk/hx06X9camcsNzlh1P
        7q1UIq51Obw2DPhnaRKI3KU8btu6oNs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b7a67809 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 10:05:08 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v2 2/3] powerpc/powernv: wire up rng during setup_arch
Date:   Sat, 11 Jun 2022 12:04:46 +0200
Message-Id: <20220611100447.5066-3-Jason@zx2c4.com>
In-Reply-To: <20220611100447.5066-1-Jason@zx2c4.com>
References: <20220611100447.5066-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The platform's RNG must be available before random_init() in order to be
useful for initial seeding, which in turn means that it needs to be
called from setup_arch(), rather than from an init call. Fortunately,
each platform already has a setup_arch function pointer, which means
it's easy to wire this up for each of the three platforms that have an
RNG. This commit also removes some noisy log messages that don't add
much.

Cc: stable@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: a4da0d50b2a0 ("powerpc: Implement arch_get_random_long/int() for powernv")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/platforms/powernv/rng.c   | 17 ++++-------------
 arch/powerpc/platforms/powernv/setup.c |  4 ++++
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index e3d44b36ae98..ef24e72a1b69 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -84,24 +84,20 @@ static int powernv_get_random_darn(unsigned long *v)
 	return 1;
 }
 
-static int __init initialise_darn(void)
+static void __init initialise_darn(void)
 {
 	unsigned long val;
 	int i;
 
 	if (!cpu_has_feature(CPU_FTR_ARCH_300))
-		return -ENODEV;
+		return;
 
 	for (i = 0; i < 10; i++) {
 		if (powernv_get_random_darn(&val)) {
 			ppc_md.get_random_seed = powernv_get_random_darn;
-			return 0;
+			return;
 		}
 	}
-
-	pr_warn("Unable to use DARN for get_random_seed()\n");
-
-	return -EIO;
 }
 
 int powernv_get_random_long(unsigned long *v)
@@ -163,14 +159,12 @@ static __init int rng_create(struct device_node *dn)
 
 	rng_init_per_cpu(rng, dn);
 
-	pr_info_once("Registering arch random hook.\n");
-
 	ppc_md.get_random_seed = powernv_get_random_long;
 
 	return 0;
 }
 
-static __init int rng_init(void)
+__init void powernv_rng_init(void)
 {
 	struct device_node *dn;
 	int rc;
@@ -188,7 +182,4 @@ static __init int rng_init(void)
 	}
 
 	initialise_darn();
-
-	return 0;
 }
-machine_subsys_initcall(powernv, rng_init);
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 824c3ad7a0fa..a0c5217bc5c0 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -184,6 +184,8 @@ static void __init pnv_check_guarded_cores(void)
 	}
 }
 
+__init void powernv_rng_init(void);
+
 static void __init pnv_setup_arch(void)
 {
 	set_arch_panic_timeout(10, ARCH_PANIC_TIMEOUT);
@@ -203,6 +205,8 @@ static void __init pnv_setup_arch(void)
 	pnv_check_guarded_cores();
 
 	/* XXX PMCS */
+
+	powernv_rng_init();
 }
 
 static void __init pnv_init(void)
-- 
2.35.1

