Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680A650D186
	for <lists+stable@lfdr.de>; Sun, 24 Apr 2022 13:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239309AbiDXLtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 07:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiDXLtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 07:49:25 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BACE1240C0;
        Sun, 24 Apr 2022 04:46:24 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 8EECB92009C; Sun, 24 Apr 2022 13:46:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 80D1492009B;
        Sun, 24 Apr 2022 12:46:23 +0100 (BST)
Date:   Sun, 24 Apr 2022 12:46:23 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: Fix CP0 counter erratum detection for R4k CPUs
Message-ID: <alpine.DEB.2.21.2204240214430.9383@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix the discrepancy between the two places we check for the CP0 counter 
erratum in along with the incorrect comparison of the R4400 revision 
number against 0x30 which matches none and consistently consider all 
R4000 and R4400 processors affected, as documented in processor errata 
publications[1][2][3], following the mapping between CP0 PRId register 
values and processor models:

  PRId   |  Processor Model
---------+--------------------
00000422 | R4000 Revision 2.2
00000430 | R4000 Revision 3.0
00000440 | R4400 Revision 1.0
00000450 | R4400 Revision 2.0
00000460 | R4400 Revision 3.0

No other revision of either processor has ever been spotted.

Contrary to what has been stated in commit ce202cbb9e0b ("[MIPS] Assume 
R4000/R4400 newer than 3.0 don't have the mfc0 count bug") marking the 
CP0 counter as buggy does not preclude it from being used as either a 
clock event or a clock source device.  It just cannot be used as both at 
a time, because in that case clock event interrupts will be occasionally 
lost, and the use as a clock event device takes precedence.

Compare against 0x4ff in `can_use_mips_counter' so that a single machine 
instruction is produced.

References:

[1] "MIPS R4000PC/SC Errata, Processor Revision 2.2 and 3.0", MIPS
    Technologies Inc., May 10, 1994, Erratum 53, p.13

[2] "MIPS R4400PC/SC Errata, Processor Revision 1.0", MIPS Technologies
    Inc., February 9, 1994, Erratum 21, p.4

[3] "MIPS R4400PC/SC Errata, Processor Revision 2.0 & 3.0", MIPS 
    Technologies Inc., January 24, 1995, Erratum 14, p.3

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: ce202cbb9e0b ("[MIPS] Assume R4000/R4400 newer than 3.0 don't have the mfc0 count bug")
Cc: stable@vger.kernel.org # v2.6.24+
---
Thomas,

 Please review the requirements for SNI platforms.  In the case of an 
erratic CP0 timer we give precedence to the use as a clock event rather 
than clock source device; see `time_init' in arch/mips/kernel/time.c. 
Therefore if SNI systems have no alternative timer interrupt source, then 
the CP0 timer is supposed to still do regardless of the erratum.

 Conversely a system can do without a high-precision clock source, in
which case jiffies will be used.  Of course such a system will suffer if 
used for precision timekeeping, but such is the price for broken hardware.  
Don't SNI systems have any alternative timer available, not even the 
venerable 8254?

 Long-term I think this code should be factored out and rewritten so that 
it lives in one place and can take advantage of compile-time constants, 
which will be the case for the majority of platforms.  For the time being 
fix the immediate breakage however.

 With the considerations above in mind, please apply.

  Maciej
---
 arch/mips/include/asm/timex.h |    8 ++++----
 arch/mips/kernel/time.c       |   11 +++--------
 2 files changed, 7 insertions(+), 12 deletions(-)

linux-mips-r4k-count-erratum-prid.diff
Index: linux-macro/arch/mips/include/asm/timex.h
===================================================================
--- linux-macro.orig/arch/mips/include/asm/timex.h
+++ linux-macro/arch/mips/include/asm/timex.h
@@ -40,9 +40,9 @@
 typedef unsigned int cycles_t;
 
 /*
- * On R4000/R4400 before version 5.0 an erratum exists such that if the
- * cycle counter is read in the exact moment that it is matching the
- * compare register, no interrupt will be generated.
+ * On R4000/R4400 an erratum exists such that if the cycle counter is
+ * read in the exact moment that it is matching the compare register,
+ * no interrupt will be generated.
  *
  * There is a suggested workaround and also the erratum can't strike if
  * the compare interrupt isn't being used as the clock source device.
@@ -63,7 +63,7 @@ static inline int can_use_mips_counter(u
 	if (!__builtin_constant_p(cpu_has_counter))
 		asm volatile("" : "=m" (cpu_data[0].options));
 	if (likely(cpu_has_counter &&
-		   prid >= (PRID_IMP_R4000 | PRID_REV_ENCODE_44(5, 0))))
+		   prid > (PRID_IMP_R4000 | PRID_REV_ENCODE_44(15, 15))))
 		return 1;
 	else
 		return 0;
Index: linux-macro/arch/mips/kernel/time.c
===================================================================
--- linux-macro.orig/arch/mips/kernel/time.c
+++ linux-macro/arch/mips/kernel/time.c
@@ -141,15 +141,10 @@ static __init int cpu_has_mfc0_count_bug
 	case CPU_R4400MC:
 		/*
 		 * The published errata for the R4400 up to 3.0 say the CPU
-		 * has the mfc0 from count bug.
-		 */
-		if ((current_cpu_data.processor_id & 0xff) <= 0x30)
-			return 1;
-
-		/*
-		 * we assume newer revisions are ok
+		 * has the mfc0 from count bug.  This seems the last version
+		 * produced.
 		 */
-		return 0;
+		return 1;
 	}
 
 	return 0;
