Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEB055C467
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiF0KCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 06:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiF0KCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 06:02:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABE8642E
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 03:02:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 940FFB80D25
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 10:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B08C3411D;
        Mon, 27 Jun 2022 10:02:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="XuYRVhqU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656324123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BFRBob20rko4qVXdP2ipY+InvVq3UfpBrGlD0g7d7ls=;
        b=XuYRVhqUgZkqE1yh13wPr5x1PQDiOTF+zJOkgPzh7VvFMqx9rvVqmFsRry5K9+9I5jj4YZ
        QD7KxY3P7suHRMJXAaQUKhH0nJiqwpI8C7t7mrxkZV6jn/EV203unmpX6NaGCrefSM3FsZ
        o+m2CbVUQ9+ysgMl9tOoN5cfp2Bv5ZA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5504cd6b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 27 Jun 2022 10:02:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH stable 5.18 5.15 5.10 5.4] powerpc/pseries: wire up rng during setup_arch()
Date:   Mon, 27 Jun 2022 12:01:58 +0200
Message-Id: <20220627100158.526135-1-Jason@zx2c4.com>
In-Reply-To: <165632300131233@kroah.com>
References: <165632300131233@kroah.com>
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

commit e561e472a3d441753bd012333b057f48fef1045b upstream.

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
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/platforms/pseries/pseries.h |  2 ++
 arch/powerpc/platforms/pseries/rng.c     | 11 +++--------
 arch/powerpc/platforms/pseries/setup.c   |  2 ++
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index af162aeeae86..3f9b51298aa3 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -121,4 +121,6 @@ void pseries_lpar_read_hblkrm_characteristics(void);
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
index 955ff8aa1644..f27735f623ba 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -852,6 +852,8 @@ static void __init pSeries_setup_arch(void)
 
 	if (swiotlb_force == SWIOTLB_FORCE)
 		ppc_swiotlb_enable = 1;
+
+	pseries_rng_init();
 }
 
 static void pseries_panic(char *str)
-- 
2.35.1

