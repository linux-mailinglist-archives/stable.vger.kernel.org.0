Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF54E51689E
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 00:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378471AbiEAWRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 18:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378175AbiEAWRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 18:17:52 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F8D42DFC;
        Sun,  1 May 2022 15:14:23 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id C187592009E; Mon,  2 May 2022 00:14:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id BB3CB92009B;
        Sun,  1 May 2022 23:14:22 +0100 (BST)
Date:   Sun, 1 May 2022 23:14:22 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     Joshua Kinard <kumba@gentoo.org>,
        Stephen Zhang <starzhangzsd@gmail.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3 2/2] MIPS: IP30: Remove incorrect `cpu_has_fpu' override
In-Reply-To: <alpine.DEB.2.21.2205012307310.9383@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2205012311470.9383@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2205012307310.9383@angie.orcam.me.uk>
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
Changes from v2:

- Give credit to Stephen for reporting the issue.

Changes from v1:

- s/chosen/disabled/ in the change description.
---
 arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h |    1 -
 1 file changed, 1 deletion(-)

linux-mips-ip30-cpu-has-fpu.diff
Index: linux-macro/arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h
===================================================================
--- linux-macro.orig/arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h
+++ linux-macro/arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h
@@ -28,7 +28,6 @@
 #define cpu_has_4kex			1
 #define cpu_has_3k_cache		0
 #define cpu_has_4k_cache		1
-#define cpu_has_fpu			1
 #define cpu_has_nofpuex			0
 #define cpu_has_32fpr			1
 #define cpu_has_counter			1
