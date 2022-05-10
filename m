Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB2852184B
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243449AbiEJNeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243806AbiEJNcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738552CFEAD;
        Tue, 10 May 2022 06:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1033761663;
        Tue, 10 May 2022 13:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB47C385A6;
        Tue, 10 May 2022 13:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188934;
        bh=RIK5MElVo47bD1tsF8v3qbeY9yUwA6PQltPBj+Q7u+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KoJM/tSuFemB3qPpN5mcQNPdtUWd+LO9SzfwkJcL7DJMEddeGyL7AG1JC6AnE+z+
         otUY7DyDy5bpY/1D15HNcaZELm5P35RpxCI3am86fqs2HFXrPyriwLwfVFcwiAG3MX
         8TNRfypxRv51SEO02Vf/DEjgbVs8vDK/s6Uz9Moc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 01/52] MIPS: Fix CP0 counter erratum detection for R4k CPUs
Date:   Tue, 10 May 2022 15:07:30 +0200
Message-Id: <20220510130729.896527846@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit f0a6c68f69981214cb7858738dd2bc81475111f7 upstream.

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


[1] "MIPS R4000PC/SC Errata, Processor Revision 2.2 and 3.0", MIPS
    Technologies Inc., May 10, 1994, Erratum 53, p.13

[2] "MIPS R4400PC/SC Errata, Processor Revision 1.0", MIPS Technologies
    Inc., February 9, 1994, Erratum 21, p.4

[3] "MIPS R4400PC/SC Errata, Processor Revision 2.0 & 3.0", MIPS
    Technologies Inc., January 24, 1995, Erratum 14, p.3

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: ce202cbb9e0b ("[MIPS] Assume R4000/R4400 newer than 3.0 don't have the mfc0 count bug")
Cc: stable@vger.kernel.org # v2.6.24+
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/timex.h |    8 ++++----
 arch/mips/kernel/time.c       |   11 +++--------
 2 files changed, 7 insertions(+), 12 deletions(-)

--- a/arch/mips/include/asm/timex.h
+++ b/arch/mips/include/asm/timex.h
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
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -141,15 +141,10 @@ static __init int cpu_has_mfc0_count_bug
 	case CPU_R4400MC:
 		/*
 		 * The published errata for the R4400 up to 3.0 say the CPU
-		 * has the mfc0 from count bug.
+		 * has the mfc0 from count bug.  This seems the last version
+		 * produced.
 		 */
-		if ((current_cpu_data.processor_id & 0xff) <= 0x30)
-			return 1;
-
-		/*
-		 * we assume newer revisions are ok
-		 */
-		return 0;
+		return 1;
 	}
 
 	return 0;


