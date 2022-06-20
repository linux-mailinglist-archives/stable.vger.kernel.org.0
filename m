Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E65A551938
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240774AbiFTMpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238541AbiFTMpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:45:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF2BDFE9;
        Mon, 20 Jun 2022 05:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2611614B0;
        Mon, 20 Jun 2022 12:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A902FC3411B;
        Mon, 20 Jun 2022 12:45:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Bd10BB7n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655729140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2IX05eBKqb4vnKKc2MkH1ad0v14O9oH9GsjOTm7oDzk=;
        b=Bd10BB7nPPAr46mIN//9Vx0qcZnResZwi0ahy4t9BLnm/DiUy7ga6Ezgsc/3ObcfPcuN1r
        kbwMaJIoSnEpP7sw5f2xDEBMj1hBx9fTIQnwIoKjIKU7boA5tWYPRiZLn+1zi0kCI3Cox2
        YlV8J5L+NoHiD+1M3ZfIRE/AWb32s30=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 956417d4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 20 Jun 2022 12:45:39 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v4] powerpc/powernv: wire up rng during setup_arch
Date:   Mon, 20 Jun 2022 14:45:31 +0200
Message-Id: <20220620124531.78075-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9rWkvDDYHPi-TJR-ATts6pLPY6D8LUaYDJ-=7w7qsFCvg@mail.gmail.com>
References: <CAHmME9rWkvDDYHPi-TJR-ATts6pLPY6D8LUaYDJ-=7w7qsFCvg@mail.gmail.com>
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
each platform already has a setup_arch function pointer, which means we
can wire it up that way. Complicating things, however, is that POWER8
systems need some per-cpu state and kmalloc, which isn't available at
this stage. So we split things into an early phase and a late phase,
with the early phase working well enough to seed the RNG with a
spinlock, before later getting fast per-cpu allocations. This commit
also removes some noisy log messages that don't add much.

Cc: stable@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: a4da0d50b2a0 ("powerpc: Implement arch_get_random_long/int() for powernv")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/platforms/powernv/powernv.h |  2 +
 arch/powerpc/platforms/powernv/rng.c     | 68 ++++++++++++++++++------
 arch/powerpc/platforms/powernv/setup.c   |  2 +
 3 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/powernv.h b/arch/powerpc/platforms/powernv/powernv.h
index e297bf4abfcb..fd3f5e1eb10b 100644
--- a/arch/powerpc/platforms/powernv/powernv.h
+++ b/arch/powerpc/platforms/powernv/powernv.h
@@ -42,4 +42,6 @@ ssize_t memcons_copy(struct memcons *mc, char *to, loff_t pos, size_t count);
 u32 __init memcons_get_size(struct memcons *mc);
 struct memcons *__init memcons_init(struct device_node *node, const char *mc_prop_name);
 
+void powernv_rng_init(void);
+
 #endif /* _POWERNV_H */
diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index e3d44b36ae98..c1beced9c32c 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -17,6 +17,7 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/smp.h>
+#include "powernv.h"
 
 #define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
@@ -28,6 +29,12 @@ struct powernv_rng {
 
 static DEFINE_PER_CPU(struct powernv_rng *, powernv_rng);
 
+static struct {
+	struct powernv_rng rng;
+	spinlock_t lock;
+} early_state __initdata = {
+	.lock = __SPIN_LOCK_UNLOCKED(powernv_early_rng)
+};
 
 int powernv_hwrng_present(void)
 {
@@ -84,7 +91,7 @@ static int powernv_get_random_darn(unsigned long *v)
 	return 1;
 }
 
-static int __init initialise_darn(void)
+static int __init initialize_darn(void)
 {
 	unsigned long val;
 	int i;
@@ -98,10 +105,18 @@ static int __init initialise_darn(void)
 			return 0;
 		}
 	}
+	return -EIO;
+}
 
-	pr_warn("Unable to use DARN for get_random_seed()\n");
+static int __init powernv_get_random_long_early(unsigned long *v)
+{
+	unsigned long flags;
 
-	return -EIO;
+	spin_lock_irqsave(&early_state.lock, flags);
+	*v = rng_whiten(&early_state.rng, in_be64(early_state.rng.regs));
+	spin_unlock_irqrestore(&early_state.lock, flags);
+
+	return 1;
 }
 
 int powernv_get_random_long(unsigned long *v)
@@ -163,32 +178,51 @@ static __init int rng_create(struct device_node *dn)
 
 	rng_init_per_cpu(rng, dn);
 
-	pr_info_once("Registering arch random hook.\n");
-
 	ppc_md.get_random_seed = powernv_get_random_long;
 
 	return 0;
 }
 
-static __init int rng_init(void)
+void __init powernv_rng_init(void)
+{
+	struct device_node *dn;
+	struct resource res;
+
+	/* Prefer darn over the rest. */
+	if (!initialize_darn())
+		return;
+
+	dn = of_find_compatible_node(NULL, NULL, "ibm,power-rng");
+	if (!dn)
+		return;
+	if (of_address_to_resource(dn, 0, &res))
+		return;
+	early_state.rng.regs_real = (void __iomem *)res.start;
+	early_state.rng.regs = of_iomap(dn, 0);
+	if (!early_state.rng.regs)
+		return;
+	early_state.rng.mask = in_be64(early_state.rng.regs);
+	ppc_md.get_random_seed = powernv_get_random_long_early;
+}
+
+static __init int powernv_rng_late_init(void)
 {
 	struct device_node *dn;
-	int rc;
+
+	/*
+	 * If this didn't get initialized early on, then we're using darn,
+	 * or this isn't available at all, so return early.
+	 */
+	if (ppc_md.get_random_seed != powernv_get_random_long_early)
+		return 0;
+	ppc_md.get_random_seed = NULL;
 
 	for_each_compatible_node(dn, NULL, "ibm,power-rng") {
-		rc = rng_create(dn);
-		if (rc) {
-			pr_err("Failed creating rng for %pOF (%d).\n",
-				dn, rc);
+		if (rng_create(dn))
 			continue;
-		}
-
 		/* Create devices for hwrng driver */
 		of_platform_device_create(dn, NULL, NULL);
 	}
-
-	initialise_darn();
-
 	return 0;
 }
-machine_subsys_initcall(powernv, rng_init);
+machine_subsys_initcall(powernv, powernv_rng_late_init);
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 824c3ad7a0fa..a5fcb6796b22 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -203,6 +203,8 @@ static void __init pnv_setup_arch(void)
 	pnv_check_guarded_cores();
 
 	/* XXX PMCS */
+
+	powernv_rng_init();
 }
 
 static void __init pnv_init(void)
-- 
2.35.1

