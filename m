Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D5355CC80
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiF0Jn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 05:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiF0Jn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 05:43:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17105F8F
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 02:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB08612A4
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 09:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D099C3411D;
        Mon, 27 Jun 2022 09:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656323004;
        bh=b/7GbIYCu3yWkUoSNLDoNnux1nsvYBXC7AdDe5UZOeI=;
        h=Subject:To:Cc:From:Date:From;
        b=07dC0+53Nr5JkgoKiOAiyO6lyH6MgSb/7cbCZH+4//ZHN3Ch2tfo2flFZEu536erT
         I4eBBwr/84GKmvBvlAL4nCYB+feBLiw+WeERXRy+J4XIXQjVgT4sfviqG+Ya5uaB6W
         i8YsJkukihc1+yL1Z9D/xGe282d4PRKcs1SH19t0=
Subject: FAILED: patch "[PATCH] powerpc/pseries: wire up rng during setup_arch()" failed to apply to 5.18-stable tree
To:     Jason@zx2c4.com, christophe.leroy@csgroup.eu, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 11:43:21 +0200
Message-ID: <165632300131233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e561e472a3d441753bd012333b057f48fef1045b Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat, 11 Jun 2022 17:10:15 +0200
Subject: [PATCH] powerpc/pseries: wire up rng during setup_arch()

The platform's RNG must be available before random_init() in order to be
useful for initial seeding, which in turn means that it needs to be
called from setup_arch(), rather than from an init call. Fortunately,
each platform already has a setup_arch function pointer, which means
it's easy to wire this up. This commit also removes some noisy log
messages that don't add much.

Fixes: a489043f4626 ("powerpc/pseries: Implement arch_get_random_long() based on H_RANDOM")
Cc: stable@vger.kernel.org # v3.13+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220611151015.548325-4-Jason@zx2c4.com

diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index f5c916c839c9..1d75b7742ef0 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -122,4 +122,6 @@ void pseries_lpar_read_hblkrm_characteristics(void);
 static inline void pseries_lpar_read_hblkrm_characteristics(void) { }
 #endif
 
+void pseries_rng_init(void);
+
 #endif /* _PSERIES_PSERIES_H */
diff --git a/arch/powerpc/platforms/pseries/rng.c b/arch/powerpc/platforms/pseries/rng.c
index 6268545947b8..6ddfdeaace9e 100644
--- a/arch/powerpc/platforms/pseries/rng.c
+++ b/arch/powerpc/platforms/pseries/rng.c
@@ -10,6 +10,7 @@
 #include <asm/archrandom.h>
 #include <asm/machdep.h>
 #include <asm/plpar_wrappers.h>
+#include "pseries.h"
 
 
 static int pseries_get_random_long(unsigned long *v)
@@ -24,19 +25,13 @@ static int pseries_get_random_long(unsigned long *v)
 	return 0;
 }
 
-static __init int rng_init(void)
+void __init pseries_rng_init(void)
 {
 	struct device_node *dn;
 
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
index afb074269b42..ee4f1db49515 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -839,6 +839,7 @@ static void __init pSeries_setup_arch(void)
 	}
 
 	ppc_md.pcibios_root_bridge_prepare = pseries_root_bridge_prepare;
+	pseries_rng_init();
 }
 
 static void pseries_panic(char *str)

