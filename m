Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CED55E03A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbiF0Lxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238726AbiF0Lwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1666DB857;
        Mon, 27 Jun 2022 04:45:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9176612AE;
        Mon, 27 Jun 2022 11:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7E3C341CF;
        Mon, 27 Jun 2022 11:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330318;
        bh=ZNgvKeXZtttq9V+DTUA+x2cKls0AD7Igat+A75HaGIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbSoPCuNi/MtglBWipI3F0Wpb98qq6IB8P5zPBRE/DnrSPtzm+cAZmGmYXnmuVvtW
         RS+6mbcHchexjlgWfNSSRgslLyC6CrFlqOOGypl6hatZfb9F8SfsY0nlBjhdechI7a
         +a7phzq/Ju5lHfc4U08+Uxgc6vKda8am83fWz30c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.18 157/181] powerpc/microwatt: wire up rng during setup_arch()
Date:   Mon, 27 Jun 2022 13:22:10 +0200
Message-Id: <20220627111949.237945884@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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

commit 20a9689b3607456d92c6fb764501f6a95950b098 upstream.

The platform's RNG must be available before random_init() in order to be
useful for initial seeding, which in turn means that it needs to be
called from setup_arch(), rather than from an init call. Fortunately,
each platform already has a setup_arch function pointer, which means
it's easy to wire this up. This commit also removes some noisy log
messages that don't add much.

Fixes: c25769fddaec ("powerpc/microwatt: Add support for hardware random number generator")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220611151015.548325-2-Jason@zx2c4.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/microwatt/microwatt.h |    7 +++++++
 arch/powerpc/platforms/microwatt/rng.c       |   10 +++-------
 arch/powerpc/platforms/microwatt/setup.c     |    8 ++++++++
 3 files changed, 18 insertions(+), 7 deletions(-)
 create mode 100644 arch/powerpc/platforms/microwatt/microwatt.h

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
--- a/arch/powerpc/platforms/microwatt/rng.c
+++ b/arch/powerpc/platforms/microwatt/rng.c
@@ -11,6 +11,7 @@
 #include <asm/archrandom.h>
 #include <asm/cputable.h>
 #include <asm/machdep.h>
+#include "microwatt.h"
 
 #define DARN_ERR 0xFFFFFFFFFFFFFFFFul
 
@@ -29,7 +30,7 @@ static int microwatt_get_random_darn(uns
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
@@ -32,10 +34,16 @@ static int __init microwatt_populate(voi
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


