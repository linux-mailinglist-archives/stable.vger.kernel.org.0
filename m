Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC279565494
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 14:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiGDMLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 08:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiGDMLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 08:11:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC7010DD
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 05:09:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 118A5CE1269
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 12:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31A8C3411E;
        Mon,  4 Jul 2022 12:09:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dVJSr/u+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656936580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yii4z5Z7Jh/zSsIA42uFyxSDSTEwZC3AglMs7RNlgj4=;
        b=dVJSr/u++GrVbyD66rsRo+xlTTZDz4jGdSxTmIEuf5yIimywRTujl0Nq+wYhpXsvgXwDT0
        98vuiwzOWg4dJUuj5YqWioLWT5jKmb94NptWjJAtOs2DLxIjg3ZcGP6kK/bbHlTeL0pEL2
        3ZAxDfVpoN2LsFW4PEjH5v4Fzffj6tg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 257d3553 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 4 Jul 2022 12:09:40 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH stable 4.9] powerpc/powernv: wire up rng during setup_arch
Date:   Mon,  4 Jul 2022 14:09:02 +0200
Message-Id: <20220704120902.64412-1-Jason@zx2c4.com>
In-Reply-To: <1656322983223152@kroah.com>
References: <1656322983223152@kroah.com>
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

commit f3eac426657d985b97c92fa5f7ae1d43f04721f3 upstream.

The platform's RNG must be available before random_init() in order to be
useful for initial seeding, which in turn means that it needs to be
called from setup_arch(), rather than from an init call.

Complicating things, however, is that POWER8 systems need some per-cpu
state and kmalloc, which isn't available at this stage. So we split
things up into an early phase and a later opportunistic phase. This
commit also removes some noisy log messages that don't add much.

Fixes: a4da0d50b2a0 ("powerpc: Implement arch_get_random_long/int() for powernv")
Cc: stable@vger.kernel.org # v3.13+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Add of_node_put(), use pnv naming, minor change log editing]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220621140849.127227-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/include/asm/ppc-opcode.h    |  4 ++
 arch/powerpc/platforms/powernv/powernv.h |  2 +
 arch/powerpc/platforms/powernv/rng.c     | 91 ++++++++++++++++++++----
 arch/powerpc/platforms/powernv/setup.c   |  2 +
 4 files changed, 85 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index b7067590f15c..8cb3c929641a 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -134,6 +134,7 @@
 #define PPC_INST_COPY			0x7c00060c
 #define PPC_INST_COPY_FIRST		0x7c20060c
 #define PPC_INST_CP_ABORT		0x7c00068c
+#define PPC_INST_DARN			0x7c0005e6
 #define PPC_INST_DCBA			0x7c0005ec
 #define PPC_INST_DCBA_MASK		0xfc0007fe
 #define PPC_INST_DCBAL			0x7c2005ec
@@ -328,6 +329,9 @@
 
 /* Deal with instructions that older assemblers aren't aware of */
 #define	PPC_CP_ABORT		stringify_in_c(.long PPC_INST_CP_ABORT)
+#define PPC_DARN(t, l)		stringify_in_c(.long PPC_INST_DARN |  \
+						___PPC_RT(t)	   |  \
+						(((l) & 0x3) << 16))
 #define	PPC_DCBAL(a, b)		stringify_in_c(.long PPC_INST_DCBAL | \
 					__PPC_RA(a) | __PPC_RB(b))
 #define	PPC_DCBZL(a, b)		stringify_in_c(.long PPC_INST_DCBZL | \
diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
index da7c843ac7f1..e98e14a5db4d 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -27,4 +27,6 @@ extern void opal_event_shutdown(void);
 
 bool cpu_core_split_required(void);
 
+void pnv_rng_init(void);
+
 #endif /* _POWERNV_H */
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index 5dcbdea1afac..dc13ed3f6c2b 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -16,11 +16,14 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <asm/archrandom.h>
+#include <asm/cputable.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/smp.h>
+#include "powernv.h"
 
+#define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
 struct powernv_rng {
 	void __iomem *regs;
@@ -30,7 +33,6 @@ struct powernv_rng {
 
 static DEFINE_PER_CPU(struct powernv_rng *, powernv_rng);
 
-
 int powernv_hwrng_present(void)
 {
 	struct powernv_rng *rng;
@@ -45,7 +47,11 @@ static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
 	unsigned long parity;
 
 	/* Calculate the parity of the value */
-	asm ("popcntd %0,%1" : "=r" (parity) : "r" (val));
+	asm (".machine push;   \
+	      .machine power7; \
+	      popcntd %0,%1;   \
+	      .machine pop;"
+	     : "=r" (parity) : "r" (val));
 
 	/* xor our value with the previous mask */
 	val ^= rng->mask;
@@ -67,6 +73,38 @@ int powernv_get_random_real_mode(unsigned long *v)
 	return 1;
 }
 
+static int powernv_get_random_darn(unsigned long *v)
+{
+	unsigned long val;
+
+	/* Using DARN with L=1 - 64-bit conditioned random number */
+	asm volatile(PPC_DARN(%0, 1) : "=r"(val));
+
+	if (val == DARN_ERR)
+		return 0;
+
+	*v = val;
+
+	return 1;
+}
+
+static int __init initialise_darn(void)
+{
+	unsigned long val;
+	int i;
+
+	if (!cpu_has_feature(CPU_FTR_ARCH_300))
+		return -ENODEV;
+
+	for (i = 0; i < 10; i++) {
+		if (powernv_get_random_darn(&val)) {
+			ppc_md.get_random_seed = powernv_get_random_darn;
+			return 0;
+		}
+	}
+	return -EIO;
+}
+
 int powernv_get_random_long(unsigned long *v)
 {
 	struct powernv_rng *rng;
@@ -88,7 +126,7 @@ static __init void rng_init_per_cpu(struct powernv_rng *rng,
 
 	chip_id = of_get_ibm_chip_id(dn);
 	if (chip_id == -1)
-		pr_warn("No ibm,chip-id found for %s.\n", dn->full_name);
+		pr_warn("No ibm,chip-id found for %pOF.\n", dn);
 
 	for_each_possible_cpu(cpu) {
 		if (per_cpu(powernv_rng, cpu) == NULL ||
@@ -126,30 +164,55 @@ static __init int rng_create(struct device_node *dn)
 
 	rng_init_per_cpu(rng, dn);
 
-	pr_info_once("Registering arch random hook.\n");
-
 	ppc_md.get_random_seed = powernv_get_random_long;
 
 	return 0;
 }
 
-static __init int rng_init(void)
+static int __init pnv_get_random_long_early(unsigned long *v)
 {
 	struct device_node *dn;
-	int rc;
+
+	if (!slab_is_available())
+		return 0;
+
+	if (cmpxchg(&ppc_md.get_random_seed, pnv_get_random_long_early,
+		    NULL) != pnv_get_random_long_early)
+		return 0;
 
 	for_each_compatible_node(dn, NULL, "ibm,power-rng") {
-		rc = rng_create(dn);
-		if (rc) {
-			pr_err("Failed creating rng for %s (%d).\n",
-				dn->full_name, rc);
+		if (rng_create(dn))
 			continue;
-		}
-
 		/* Create devices for hwrng driver */
 		of_platform_device_create(dn, NULL, NULL);
 	}
 
+	if (!ppc_md.get_random_seed)
+		return 0;
+	return ppc_md.get_random_seed(v);
+}
+
+void __init pnv_rng_init(void)
+{
+	struct device_node *dn;
+
+	/* Prefer darn over the rest. */
+	if (!initialise_darn())
+		return;
+
+	dn = of_find_compatible_node(NULL, NULL, "ibm,power-rng");
+	if (dn)
+		ppc_md.get_random_seed = pnv_get_random_long_early;
+
+	of_node_put(dn);
+}
+
+static int __init pnv_rng_late_init(void)
+{
+	unsigned long v;
+	/* In case it wasn't called during init for some other reason. */
+	if (ppc_md.get_random_seed == pnv_get_random_long_early)
+		pnv_get_random_long_early(&v);
 	return 0;
 }
-machine_subsys_initcall(powernv, rng_init);
+machine_subsys_initcall(powernv, pnv_rng_late_init);
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index b77d5eed9520..e97b714d30d7 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -168,6 +168,8 @@ static void __init pnv_setup_arch(void)
 	powersave_nap = 1;
 
 	/* XXX PMCS */
+
+	pnv_rng_init();
 }
 
 static void __init pnv_init(void)
-- 
2.35.1

