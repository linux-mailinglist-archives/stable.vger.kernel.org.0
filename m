Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCEF566B15
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbiGEMEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiGEMB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:01:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8622C183AB;
        Tue,  5 Jul 2022 05:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36B4DB817E0;
        Tue,  5 Jul 2022 12:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933B2C341CF;
        Tue,  5 Jul 2022 12:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022507;
        bh=zn+oj4F3sWLH/khQA3k0ERFN8bPpUeyumgY59Fo0PEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stT6mZ+AVlHAJbjZx3OyV28ztLfDmoPhAXxrqhX0FhJHplGOqY7MN6nOe2rRJAHbA
         guQ+VR3Gf24M+m3v2PdpHptQUC16ejIKZN8qDbB1FLs01qPx0zYXGWMf9OYdNqTa6J
         SF1ileAvYpDv+jFc1/7rhQgD9jcjXLRSDbw39XGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Ingo Franzki <ifranzki@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 4.14 04/29] s390/archrandom: simplify back to earlier design and initialize earlier
Date:   Tue,  5 Jul 2022 13:57:52 +0200
Message-Id: <20220705115606.470285882@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.333669144@linuxfoundation.org>
References: <20220705115606.333669144@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/arch_random.c     |   20 +++-----------------
 arch/s390/include/asm/archrandom.h |   32 ++++++++++++++------------------
 arch/s390/kernel/setup.c           |    5 +++++
 3 files changed, 22 insertions(+), 35 deletions(-)

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
@@ -20,13 +16,3 @@ DEFINE_STATIC_KEY_FALSE(s390_arch_random
 
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
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -853,6 +853,11 @@ static void __init setup_randomness(void
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


