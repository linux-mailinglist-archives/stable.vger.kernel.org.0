Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B87B54738B
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 12:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiFKKFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 06:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiFKKFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 06:05:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485EF1162;
        Sat, 11 Jun 2022 03:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 027CCB83611;
        Sat, 11 Jun 2022 10:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0AEC3411D;
        Sat, 11 Jun 2022 10:05:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PsWskfdF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654941906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mhWBKi7DDw492CEoMKT+q0A6R8rT2bu6t1gopqQtrBU=;
        b=PsWskfdFEBgIR9ivJdzgXPrSdQH8EVyjjyJlDtarIJUzZg7tHcz2ZTUBORwSVoyJqIETOL
        LwcEeyRZ8o0k9Na9HwPf6YmzgNDleR32nskjUTn+lhE1wtuOM2AJXvZNRuh7+4ZMtPZYgU
        ob9BDAHr8NYZ7K+JtQXkUaq8vC3aonk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9d9ce964 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 11 Jun 2022 10:05:06 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v2 1/3] powerpc/microwatt: wire up rng during setup_arch
Date:   Sat, 11 Jun 2022 12:04:45 +0200
Message-Id: <20220611100447.5066-2-Jason@zx2c4.com>
In-Reply-To: <20220611100447.5066-1-Jason@zx2c4.com>
References: <20220611100447.5066-1-Jason@zx2c4.com>
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
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: c25769fddaec ("powerpc/microwatt: Add support for hardware random number generator")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/platforms/microwatt/rng.c   | 9 ++-------
 arch/powerpc/platforms/microwatt/setup.c | 8 ++++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

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
-- 
2.35.1

