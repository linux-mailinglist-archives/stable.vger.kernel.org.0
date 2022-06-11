Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D3C5472CA
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 10:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiFKILZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 04:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiFKILX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 04:11:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01761D0EC;
        Sat, 11 Jun 2022 01:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BAA161216;
        Sat, 11 Jun 2022 08:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295ADC34116;
        Sat, 11 Jun 2022 08:11:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="h+8trSs6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654935079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JhE9QV1bIqPw2urSYw+/iYLr0eUuZ5Re2c1gfvfbv5E=;
        b=h+8trSs6BSUBjfcUc3USmvwUUElptBvOObS+NJYTCuXivUasQP+rq7vks3W3Hn/QkQYQxj
        Dq+LADDqdzoRHFjAjJAteEdtOe2CTO3BQ0zBox050twqW6TqN+685aDbZ/EV0GWNBuWvJA
        GZkJalKoSsWBZSz4rXKvAQuT0ZrcSDQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 88227a06 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 08:11:19 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH] powerpc/rng: wire up during setup_arch
Date:   Sat, 11 Jun 2022 10:11:14 +0200
Message-Id: <20220611081114.449165-1-Jason@zx2c4.com>
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
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/platforms/microwatt/rng.c   |  9 ++-------
 arch/powerpc/platforms/microwatt/setup.c |  8 ++++++++
 arch/powerpc/platforms/powernv/rng.c     | 17 ++++-------------
 arch/powerpc/platforms/powernv/setup.c   |  4 ++++
 arch/powerpc/platforms/pseries/rng.c     | 11 ++---------
 arch/powerpc/platforms/pseries/setup.c   |  3 +++
 6 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/platforms/microwatt/rng.c b/arch/powerpc/platforms/microwatt/rng.c
index 7bc4d1cbfaf0..d13f656910ad 100644
--- a/arch/powerpc/platforms/microwatt/rng.c
+++ b/arch/powerpc/platforms/microwatt/rng.c
@@ -29,7 +29,7 @@ static int microwatt_get_random_darn(unsigned long *v)
 	return 1;
 }
 
-static __init int rng_init(void)
+__init void microwatt_rng_init(void)
 {
 	unsigned long val;
 	int i;
@@ -37,12 +37,7 @@ static __init int rng_init(void)
 	for (i = 0; i < 10; i++) {
 		if (microwatt_get_random_darn(&val)) {
 			ppc_md.get_random_seed = microwatt_get_random_darn;
-			return 0;
+			return;
 		}
 	}
-
-	pr_warn("Unable to use DARN for get_random_seed()\n");
-
-	return -EIO;
 }
-machine_subsys_initcall(, rng_init);
diff --git a/arch/powerpc/platforms/microwatt/setup.c b/arch/powerpc/platforms/microwatt/setup.c
index 0b02603bdb74..23c996dcc870 100644
--- a/arch/powerpc/platforms/microwatt/setup.c
+++ b/arch/powerpc/platforms/microwatt/setup.c
@@ -32,10 +32,18 @@ static int __init microwatt_populate(void)
 }
 machine_arch_initcall(microwatt, microwatt_populate);
 
+__init void microwatt_rng_init(void);
+
+static void __init microwatt_setup_arch(void)
+{
+	microwatt_rng_init();
+}
+
 define_machine(microwatt) {
 	.name			= "microwatt",
 	.probe			= microwatt_probe,
 	.init_IRQ		= microwatt_init_IRQ,
+	.setup_arch		= microwatt_setup_arch,
 	.progress		= udbg_progress,
 	.calibrate_decr		= generic_calibrate_decr,
 };
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
diff --git a/arch/powerpc/platforms/pseries/rng.c b/arch/powerpc/platforms/pseries/rng.c
index 6268545947b8..d39bfce39aa1 100644
--- a/arch/powerpc/platforms/pseries/rng.c
+++ b/arch/powerpc/platforms/pseries/rng.c
@@ -24,19 +24,12 @@ static int pseries_get_random_long(unsigned long *v)
 	return 0;
 }
 
-static __init int rng_init(void)
+__init void pseries_rng_init(void)
 {
 	struct device_node *dn;
-
 	dn = of_find_compatible_node(NULL, NULL, "ibm,random");
 	if (!dn)
-		return -ENODEV;
-
-	pr_info("Registering arch random hook.\n");
-
+		return;
 	ppc_md.get_random_seed = pseries_get_random_long;
-
 	of_node_put(dn);
-	return 0;
 }
-machine_subsys_initcall(pseries, rng_init);
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index afb074269b42..7f3ee2658163 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -779,6 +779,8 @@ static resource_size_t pseries_pci_iov_resource_alignment(struct pci_dev *pdev,
 }
 #endif
 
+__init void pseries_rng_init(void);
+
 static void __init pSeries_setup_arch(void)
 {
 	set_arch_panic_timeout(10, ARCH_PANIC_TIMEOUT);
@@ -839,6 +841,7 @@ static void __init pSeries_setup_arch(void)
 	}
 
 	ppc_md.pcibios_root_bridge_prepare = pseries_root_bridge_prepare;
+	pseries_rng_init();
 }
 
 static void pseries_panic(char *str)
-- 
2.35.1

