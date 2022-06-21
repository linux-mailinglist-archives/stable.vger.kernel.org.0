Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01518553434
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 16:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350675AbiFUOI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 10:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350568AbiFUOI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 10:08:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EBC20BD8;
        Tue, 21 Jun 2022 07:08:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D10D61637;
        Tue, 21 Jun 2022 14:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0367CC3411C;
        Tue, 21 Jun 2022 14:08:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZIfwWxWI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655820532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o1gYjl7KPX16iqAFGXtFcntDw+PS97kgCGFtyPRPPLo=;
        b=ZIfwWxWIQEmwVtW3nHnpJPrV1JhXCM3H6T73nFa9Orxl03gLbNcGwTgZWNqMIB04R74HTB
        MmHpVWV8jgq/gPd5e90TsQjjA9r6dyshfYdN2QRp+mbEx10dklm9rUW8mN3MxIFmX+JusS
        UzTV6slWEX/oURVmprW5R+kfjcANeiE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 528b99a0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 21 Jun 2022 14:08:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v5] powerpc/powernv: wire up rng during setup_arch
Date:   Tue, 21 Jun 2022 16:08:49 +0200
Message-Id: <20220621140849.127227-1-Jason@zx2c4.com>
In-Reply-To: <20220620124531.78075-1-Jason@zx2c4.com>
References: <20220620124531.78075-1-Jason@zx2c4.com>
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
this stage. So we split things up into an early phase and a later
opportunistic phase. This commit also removes some noisy log messages
that don't add much.

Cc: stable@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: a4da0d50b2a0 ("powerpc: Implement arch_get_random_long/int() for powernv")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/platforms/powernv/powernv.h |  2 +
 arch/powerpc/platforms/powernv/rng.c     | 47 ++++++++++++++++--------
 arch/powerpc/platforms/powernv/setup.c   |  2 +
 3 files changed, 35 insertions(+), 16 deletions(-)

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
index e3d44b36ae98..e332e72e1857 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -17,6 +17,7 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/smp.h>
+#include "powernv.h"
 
 #define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
@@ -28,7 +29,6 @@ struct powernv_rng {
 
 static DEFINE_PER_CPU(struct powernv_rng *, powernv_rng);
 
-
 int powernv_hwrng_present(void)
 {
 	struct powernv_rng *rng;
@@ -98,9 +98,6 @@ static int __init initialise_darn(void)
 			return 0;
 		}
 	}
-
-	pr_warn("Unable to use DARN for get_random_seed()\n");
-
 	return -EIO;
 }
 
@@ -163,32 +160,50 @@ static __init int rng_create(struct device_node *dn)
 
 	rng_init_per_cpu(rng, dn);
 
-	pr_info_once("Registering arch random hook.\n");
-
 	ppc_md.get_random_seed = powernv_get_random_long;
 
 	return 0;
 }
 
-static __init int rng_init(void)
+static int __init powernv_get_random_long_early(unsigned long *v)
 {
 	struct device_node *dn;
-	int rc;
+
+	if (!slab_is_available())
+		return 0;
+
+	if (cmpxchg(&ppc_md.get_random_seed, powernv_get_random_long_early,
+		    NULL) != powernv_get_random_long_early)
+		return 0;
 
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
 
-	initialise_darn();
+	if (!ppc_md.get_random_seed)
+		return 0;
+	return ppc_md.get_random_seed(v);
+}
+
+void __init powernv_rng_init(void)
+{
+	/* Prefer darn over the rest. */
+	if (!initialise_darn())
+		return;
+
+	if (of_find_compatible_node(NULL, NULL, "ibm,power-rng"))
+		ppc_md.get_random_seed = powernv_get_random_long_early;
+}
 
+static int __init powernv_rng_late_init(void)
+{
+	unsigned long v;
+	/* In case it wasn't called during init for some other reason. */
+	if (ppc_md.get_random_seed == powernv_get_random_long_early)
+		powernv_get_random_long_early(&v);
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

