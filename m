Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD6A5475ED
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbiFKPKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 11:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbiFKPK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 11:10:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6891D38A6;
        Sat, 11 Jun 2022 08:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4C7C61012;
        Sat, 11 Jun 2022 15:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4952C34116;
        Sat, 11 Jun 2022 15:10:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fi/Fit2A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654960225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WtiQjpbrmFMKm8d6BMUt1LLUM1Fss83aLjhZrpuPa8s=;
        b=fi/Fit2Ac2yfEKIE3LESs5pbpE5Qy0X/dsCadZc398g2mcii6u14EquZ3G+PUeCkNzSrPw
        9ll8uim29ds+8p9hfSOr4pBW4oacKLCFUdjU/aVxRl60a1nm9EUXeGn7pMo3zOKbeByuEp
        qBfMr4kkW2NZQO9oNr/QhqtuW8uA308=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 01cd7939 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 15:10:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v3 1/3] powerpc/microwatt: wire up rng during setup_arch
Date:   Sat, 11 Jun 2022 17:10:13 +0200
Message-Id: <20220611151015.548325-2-Jason@zx2c4.com>
In-Reply-To: <20220611151015.548325-1-Jason@zx2c4.com>
References: <20220611151015.548325-1-Jason@zx2c4.com>
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
it's easy to wire this up. This commit also removes some noisy log
messages that don't add much.

Cc: stable@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: c25769fddaec ("powerpc/microwatt: Add support for hardware random number generator")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/platforms/microwatt/microwatt.h |  7 +++++++
 arch/powerpc/platforms/microwatt/rng.c       | 10 +++-------
 arch/powerpc/platforms/microwatt/setup.c     |  8 ++++++++
 3 files changed, 18 insertions(+), 7 deletions(-)
 create mode 100644 arch/powerpc/platforms/microwatt/microwatt.h

diff --git a/arch/powerpc/platforms/microwatt/microwatt.h b/arch/powerpc/platforms/microwatt/microwatt.h
new file mode 100644
index 000000000000..335417e95e66
--- /dev/null
+++ b/arch/powerpc/platforms/microwatt/microwatt.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MICROWATT_H
+#define _MICROWATT_H
+
+void microwatt_rng_init(void);
+
+#endif /* _MICROWATT_H */
diff --git a/arch/powerpc/platforms/microwatt/rng.c b/arch/powerpc/platforms/microwatt/rng.c
index 7bc4d1cbfaf0..8ece87d005c8 100644
--- a/arch/powerpc/platforms/microwatt/rng.c
+++ b/arch/powerpc/platforms/microwatt/rng.c
@@ -11,6 +11,7 @@
 #include <asm/archrandom.h>
 #include <asm/cputable.h>
 #include <asm/machdep.h>
+#include "microwatt.h"
 
 #define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
@@ -29,7 +30,7 @@ static int microwatt_get_random_darn(unsigned long *v)
 	return 1;
 }
 
-static __init int rng_init(void)
+void __init microwatt_rng_init(void)
 {
 	unsigned long val;
 	int i;
@@ -37,12 +38,7 @@ static __init int rng_init(void)
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
index 0b02603bdb74..6b32539395a4 100644
--- a/arch/powerpc/platforms/microwatt/setup.c
+++ b/arch/powerpc/platforms/microwatt/setup.c
@@ -16,6 +16,8 @@
 #include <asm/xics.h>
 #include <asm/udbg.h>
 
+#include "microwatt.h"
+
 static void __init microwatt_init_IRQ(void)
 {
 	xics_init();
@@ -32,10 +34,16 @@ static int __init microwatt_populate(void)
 }
 machine_arch_initcall(microwatt, microwatt_populate);
 
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
-- 
2.35.1

