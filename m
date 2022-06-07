Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956BF53F371
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 03:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiFGBmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 21:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbiFGBmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 21:42:03 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 786F6D029F
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 18:42:01 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id D5E8592009C; Tue,  7 Jun 2022 03:42:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id CFCB092009B
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 02:42:00 +0100 (BST)
Date:   Tue, 7 Jun 2022 02:42:00 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     stable@vger.kernel.org
Subject: [PATCH 5.17] MIPS: IP30: Remove incorrect `cpu_has_fpu' override
Message-ID: <alpine.DEB.2.21.2206070237210.19680@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove unsupported forcing of `cpu_has_fpu' to 1, which makes the `nofpu' 
kernel parameter non-functional, and also causes a link error:

ld: arch/mips/kernel/traps.o: in function `trap_init':
./arch/mips/include/asm/msa.h:(.init.text+0x348): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x354): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x360): undefined reference to `handle_fpe'

where the CONFIG_MIPS_FP_SUPPORT configuration option has been disabled.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
Fixes: 7505576d1c1a ("MIPS: add support for SGI Octane (IP30)")
Cc: stable@vger.kernel.org # v5.5+
---
Hi,

 This is a version of commit f44b3e74c33f for 5.17-stable and before 
(where the preceding `#define cpu_has_tx39_cache 0' line has not been 
removed yet and hence the merge conflict).

 No functional change, just a mechanical update.  Please apply.

  Maciej
---
 arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h |    1 -
 1 file changed, 1 deletion(-)

linux-mips-ip30-cpu-has-fpu.diff
Index: linux-macro/arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h
===================================================================
--- linux-macro.orig/arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h
+++ linux-macro/arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h
@@ -29,7 +29,6 @@
 #define cpu_has_3k_cache		0
 #define cpu_has_4k_cache		1
 #define cpu_has_tx39_cache		0
-#define cpu_has_fpu			1
 #define cpu_has_nofpuex			0
 #define cpu_has_32fpr			1
 #define cpu_has_counter			1
