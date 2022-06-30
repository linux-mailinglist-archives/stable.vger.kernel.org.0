Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14EC561A2B
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 14:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbiF3MRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 08:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiF3MRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 08:17:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3952A734
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 05:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74ECEB82A3C
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 12:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879ADC34115;
        Thu, 30 Jun 2022 12:17:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="oiMl6aZG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656591424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VYAGY2nlp1dTW2pLJaJmBF+Am0fEbMM+b5F3DfJDWco=;
        b=oiMl6aZGbFHghd89Q95SvIzDW8phh416yu9EHlcQMaRbud7/vQ/iQK9kqZ3SMDq2r7QM9k
        ThadeeiuEJhcwdxoI6KlCyYDFYR4ayzXLl1ZSjVYbH6Ssf2Ueh8Kbvleaudv3q5vR1moYB
        LfDt4CwYAuMz9x81c2Wp4zdHGts03Ew=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dddd032e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jun 2022 12:17:04 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        sachinp@linux.ibm.com
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] powerpc/powernv: delay rng of node creation until later in boot
Date:   Thu, 30 Jun 2022 14:16:54 +0200
Message-Id: <20220630121654.1939181-1-Jason@zx2c4.com>
In-Reply-To: <Yr2PQSZWVtr+Y7a2@zx2c4.com>
References: <Yr2PQSZWVtr+Y7a2@zx2c4.com>
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

The of node for the rng must be created much later in boot. Otherwise it
tries to connect to a parent that doesn't yet exist, resulting on this
splat:

[    0.000478] kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_get() is being called.
[    0.002925] [c000000002a0fb30] [c00000000073b0bc] kobject_get+0x8c/0x100 (unreliable)
[    0.003071] [c000000002a0fba0] [c00000000087e464] device_add+0xf4/0xb00
[    0.003194] [c000000002a0fc80] [c000000000a7f6e4] of_device_add+0x64/0x80
[    0.003321] [c000000002a0fcb0] [c000000000a800d0] of_platform_device_create_pdata+0xd0/0x1b0
[    0.003476] [c000000002a0fd00] [c00000000201fa44] pnv_get_random_long_early+0x240/0x2e4
[    0.003623] [c000000002a0fe20] [c000000002060c38] random_init+0xc0/0x214

This patch fixes the issue by doing the of node creation inside of
machine_subsys_initcall.

Fixes: f3eac426657d ("powerpc/powernv: wire up rng during setup_arch")
Cc: stable@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/powerpc/platforms/powernv/rng.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
index 463c78c52cc5..bd5ad5f351c2 100644
--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -176,12 +176,8 @@ static int __init pnv_get_random_long_early(unsigned long *v)
 		    NULL) != pnv_get_random_long_early)
 		return 0;
 
-	for_each_compatible_node(dn, NULL, "ibm,power-rng") {
-		if (rng_create(dn))
-			continue;
-		/* Create devices for hwrng driver */
-		of_platform_device_create(dn, NULL, NULL);
-	}
+	for_each_compatible_node(dn, NULL, "ibm,power-rng")
+		rng_create(dn);
 
 	if (!ppc_md.get_random_seed)
 		return 0;
@@ -205,10 +201,16 @@ void __init pnv_rng_init(void)
 
 static int __init pnv_rng_late_init(void)
 {
+	struct device_node *dn;
 	unsigned long v;
+
 	/* In case it wasn't called during init for some other reason. */
 	if (ppc_md.get_random_seed == pnv_get_random_long_early)
 		pnv_get_random_long_early(&v);
+	if (ppc_md.get_random_seed == powernv_get_random_long) {
+		for_each_compatible_node(dn, NULL, "ibm,power-rng")
+			of_platform_device_create(dn, NULL, NULL);
+	}
 	return 0;
 }
 machine_subsys_initcall(powernv, pnv_rng_late_init);
-- 
2.35.1

