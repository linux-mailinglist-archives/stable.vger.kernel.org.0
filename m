Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF3F55CF59
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiF0L3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbiF0L2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:28:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5747C65B7;
        Mon, 27 Jun 2022 04:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 183F5B81120;
        Mon, 27 Jun 2022 11:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B66C341CB;
        Mon, 27 Jun 2022 11:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329254;
        bh=E01gtDYA+DLamTvwTd/8qIBpMQTy5fBElgZmB4vlylI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3r4DwOAHfyz/MXe+IYDvbQaI+k+kOhkaNSIRYvTFa7fC04KCBM8PazGHF1OPbN+G
         hbWJ7wxxhbL/ba3qAeQzFf6K4cvkEL2a9VdB2ZKgotnMOznAS0vKC0vVO2RGnCzJdz
         fHUt1SUSSs481pbbTB8eF50nnvLPS0GjT3D2kK9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 102/102] powerpc/pseries: wire up rng during setup_arch()
Date:   Mon, 27 Jun 2022 13:21:53 +0200
Message-Id: <20220627111936.491194994@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/pseries.h |    2 ++
 arch/powerpc/platforms/pseries/rng.c     |   11 +++--------
 arch/powerpc/platforms/pseries/setup.c   |    2 ++
 3 files changed, 7 insertions(+), 8 deletions(-)

--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -114,4 +114,6 @@ int dlpar_workqueue_init(void);
 void pseries_setup_security_mitigations(void);
 void pseries_lpar_read_hblkrm_characteristics(void);
 
+void pseries_rng_init(void);
+
 #endif /* _PSERIES_PSERIES_H */
--- a/arch/powerpc/platforms/pseries/rng.c
+++ b/arch/powerpc/platforms/pseries/rng.c
@@ -10,6 +10,7 @@
 #include <asm/archrandom.h>
 #include <asm/machdep.h>
 #include <asm/plpar_wrappers.h>
+#include "pseries.h"
 
 
 static int pseries_get_random_long(unsigned long *v)
@@ -24,19 +25,13 @@ static int pseries_get_random_long(unsig
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
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -824,6 +824,8 @@ static void __init pSeries_setup_arch(vo
 
 	if (swiotlb_force == SWIOTLB_FORCE)
 		ppc_swiotlb_enable = 1;
+
+	pseries_rng_init();
 }
 
 static void pseries_panic(char *str)


