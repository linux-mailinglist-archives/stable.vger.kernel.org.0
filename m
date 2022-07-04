Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102DD565244
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 12:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiGDK2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 06:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiGDK2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 06:28:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C382625
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 03:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5932EB80E88
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 10:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308FAC3411E;
        Mon,  4 Jul 2022 10:28:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cJ9lpNx8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656930505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jaYAzVJFHw3mGNgqBml2eevVUsf6fdNVuJ7utR8GaV0=;
        b=cJ9lpNx8X5ZxA25NepKTlx6xas+V1od2MZGMQEs9WUJ+n5QM2uA5T4IyiuVdy3STgm9i5D
        W58dHZRvtI8Bnw+EMRbucLw9uwUMNoVzcTu1dOAKUYEyroMlZ9qNYcewc3PMKci+U7W+H5
        j1ZKKT/PFXuE4kwGW5VbeSBLDlLI/TI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id be30b0df (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 4 Jul 2022 10:28:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Ingo Franzki <ifranzki@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH stable 4.14] s390/archrandom: simplify back to earlier design and initialize earlier
Date:   Mon,  4 Jul 2022 12:28:19 +0200
Message-Id: <20220704102819.337213-1-Jason@zx2c4.com>
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

commit e4f74400308cb8abde5fdc9cad609c2aba32110c upstream.

s390x appears to present two RNG interfaces:
- a "TRNG" that gathers entropy using some hardware function; and
- a "DRBG" that takes in a seed and expands it.

Previously, the TRNG was wired up to arch_get_random_{long,int}(), but
it was observed that this was being called really frequently, resulting
in high overhead. So it was changed to be wired up to arch_get_random_
seed_{long,int}(), which was a reasonable decision. Later on, the DRBG
was then wired up to arch_get_random_{long,int}(), with a complicated
buffer filling thread, to control overhead and rate.

Fortunately, none of the performance issues matter much now. The RNG
always attempts to use arch_get_random_seed_{long,int}() first, which
means a complicated implementation of arch_get_random_{long,int}() isn't
really valuable or useful to have around. And it's only used when
reseeding, which means it won't hit the high throughput complications
that were faced before.

So this commit returns to an earlier design of just calling the TRNG in
arch_get_random_seed_{long,int}(), and returning false in arch_get_
random_{long,int}().

Part of what makes the simplification possible is that the RNG now seeds
itself using the TRNG at bootup. But this only works if the TRNG is
detected early in boot, before random_init() is called. So this commit
also causes that check to happen in setup_arch().

Cc: stable@vger.kernel.org
Cc: Harald Freudenberger <freude@linux.ibm.com>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Juergen Christ <jchrist@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20220610222023.378448-1-Jason@zx2c4.com
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/s390/crypto/arch_random.c     | 20 +++----------------
 arch/s390/include/asm/archrandom.h | 32 +++++++++++++-----------------
 arch/s390/kernel/setup.c           |  5 +++++
 3 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/arch/s390/crypto/arch_random.c b/arch/s390/crypto/arch_random.c
index 36aefc07d10c..1f2d40993c4d 100644
--- a/arch/s390/crypto/arch_random.c
+++ b/arch/s390/crypto/arch_random.c
@@ -1,13 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * s390 arch random implementation.
  *
- * Copyright IBM Corp. 2017
- * Author(s): Harald Freudenberger <freude@de.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License (version 2 only)
- * as published by the Free Software Foundation.
- *
+ * Copyright IBM Corp. 2017, 2020
+ * Author(s): Harald Freudenberger
  */
 
 #include <linux/kernel.h>
@@ -20,13 +16,3 @@ DEFINE_STATIC_KEY_FALSE(s390_arch_random_available);
 
 atomic64_t s390_arch_random_counter = ATOMIC64_INIT(0);
 EXPORT_SYMBOL(s390_arch_random_counter);
-
-static int __init s390_arch_random_init(void)
-{
-	/* check if subfunction CPACF_PRNO_TRNG is available */
-	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG))
-		static_branch_enable(&s390_arch_random_available);
-
-	return 0;
-}
-arch_initcall(s390_arch_random_init);
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index ddf97715ee53..2c6e1c6ecbe7 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -2,7 +2,7 @@
 /*
  * Kernel interface for the s390 arch_random_* functions
  *
- * Copyright IBM Corp. 2017
+ * Copyright IBM Corp. 2017, 2020
  *
  * Author: Harald Freudenberger <freude@de.ibm.com>
  *
@@ -20,38 +20,34 @@
 DECLARE_STATIC_KEY_FALSE(s390_arch_random_available);
 extern atomic64_t s390_arch_random_counter;
 
-static void s390_arch_random_generate(u8 *buf, unsigned int nbytes)
+static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
-	cpacf_trng(NULL, 0, buf, nbytes);
-	atomic64_add(nbytes, &s390_arch_random_counter);
+	return false;
 }
 
-static inline bool arch_get_random_long(unsigned long *v)
+static inline bool __must_check arch_get_random_int(unsigned int *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
-		s390_arch_random_generate((u8 *)v, sizeof(*v));
-		return true;
-	}
 	return false;
 }
 
-static inline bool arch_get_random_int(unsigned int *v)
+static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
 	if (static_branch_likely(&s390_arch_random_available)) {
-		s390_arch_random_generate((u8 *)v, sizeof(*v));
+		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
+		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;
 	}
 	return false;
 }
 
-static inline bool arch_get_random_seed_long(unsigned long *v)
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
-	return arch_get_random_long(v);
-}
-
-static inline bool arch_get_random_seed_int(unsigned int *v)
-{
-	return arch_get_random_int(v);
+	if (static_branch_likely(&s390_arch_random_available)) {
+		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
+		atomic64_add(sizeof(*v), &s390_arch_random_counter);
+		return true;
+	}
+	return false;
 }
 
 #endif /* CONFIG_ARCH_RANDOM */
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index e9ef093eb676..b3343f093f67 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -853,6 +853,11 @@ static void __init setup_randomness(void)
 	if (stsi(vmms, 3, 2, 2) == 0 && vmms->count)
 		add_device_randomness(&vmms->vm, sizeof(vmms->vm[0]) * vmms->count);
 	memblock_free((unsigned long) vmms, PAGE_SIZE);
+
+#ifdef CONFIG_ARCH_RANDOM
+	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG))
+		static_branch_enable(&s390_arch_random_available);
+#endif
 }
 
 /*
-- 
2.35.1

