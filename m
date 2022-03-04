Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00AE54CDE50
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 21:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiCDUTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 15:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiCDUSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 15:18:36 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4058134DF1;
        Fri,  4 Mar 2022 12:16:24 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id E22DE92009C; Fri,  4 Mar 2022 21:16:23 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id DCD4C92009B;
        Fri,  4 Mar 2022 20:16:23 +0000 (GMT)
Date:   Fri, 4 Mar 2022 20:16:23 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     Jan-Benedict Glaw <jbglaw@lug-owl.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] DEC: Limit PMAX memory probing to R3k systems
Message-ID: <alpine.DEB.2.21.2203041838380.47558@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,HDRS_LCASE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recent tightening of the opcode table in binutils so as to consistently 
disallow the assembly or disassembly of CP0 instructions not supported 
by the processor architecture chosen has caused a regression like below:

arch/mips/dec/prom/locore.S: Assembler messages:
arch/mips/dec/prom/locore.S:29: Error: opcode not supported on this processor: r4600 (mips3) `rfe'

in a piece of code used to probe for memory with PMAX DECstation models, 
which have non-REX firmware.  Those computers always have an R2000 CPU 
and consequently the exception handler used in memory probing uses the 
RFE instruction, which those processors use.

While adding 64-bit support this code was correctly excluded for 64-bit 
configurations, however it should have also been excluded for irrelevant 
32-bit configurations.  Do this now then, and only enable PMAX memory 
probing for R3k systems.

Reported-by: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org # v2.6.12+
---
Hi,

 I'm assuming this won't go back beyond commit 2a11c8ea20bf ("kconfig: 
Introduce IS_ENABLED(), IS_BUILTIN() and IS_MODULE()") or any backport 
will have to be rewritten to avoid IS_ENABLED.

 The original actual change named to fix ought to be commit dd82ef87e4c9 
("PROM interface rework to support a 64-bit kernel.") from the LMO repo: 
<https://git.kernel.org/pub/scm/linux/kernel/git/ralf/linux.git/commit/?id=dd82ef87e4c9>, 
which introduced the `prom_is_rex' macro, which guards this code.  Said 
commit predates the history of our main repository though.

 This change has actually been verified at runtime with a PMIN system 
(effectively a PMAX, but with a slower R2000 CPU) and a 4MAX+ system (an 
R4400SC-based machine), and naturally throughout the three possible build 
configurations: R3k, R4k/32-bit, R4k/64-bit.

 It took longer than expected, but oh well...  Sorry for the inconvenience 
caused.

 Please apply,

  Maciej
---
 arch/mips/dec/prom/Makefile      |    2 +-
 arch/mips/include/asm/dec/prom.h |   15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

linux-dec-locore-r3000.diff
Index: linux-macro/arch/mips/dec/prom/Makefile
===================================================================
--- linux-macro.orig/arch/mips/dec/prom/Makefile
+++ linux-macro/arch/mips/dec/prom/Makefile
@@ -6,4 +6,4 @@
 
 lib-y			+= init.o memory.o cmdline.o identify.o console.o
 
-lib-$(CONFIG_32BIT)	+= locore.o
+lib-$(CONFIG_CPU_R3000)	+= locore.o
Index: linux-macro/arch/mips/include/asm/dec/prom.h
===================================================================
--- linux-macro.orig/arch/mips/include/asm/dec/prom.h
+++ linux-macro/arch/mips/include/asm/dec/prom.h
@@ -43,16 +43,11 @@
  */
 #define REX_PROM_MAGIC		0x30464354
 
-#ifdef CONFIG_64BIT
-
-#define prom_is_rex(magic)	1	/* KN04 and KN05 are REX PROMs.  */
-
-#else /* !CONFIG_64BIT */
-
-#define prom_is_rex(magic)	((magic) == REX_PROM_MAGIC)
-
-#endif /* !CONFIG_64BIT */
-
+/* KN04 and KN05 are REX PROMs, so only do the check for R3k systems.  */
+static inline bool prom_is_rex(u32 magic)
+{
+	return !IS_ENABLED(CONFIG_CPU_R3000) || magic == REX_PROM_MAGIC;
+}
 
 /*
  * 3MIN/MAXINE PROM entry points for DS5000/1xx's, DS5000/xx's and
