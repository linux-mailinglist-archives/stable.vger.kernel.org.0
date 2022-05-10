Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCD15216A5
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242464AbiEJNQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242465AbiEJNQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:16:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41A144749;
        Tue, 10 May 2022 06:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6955FB81DA4;
        Tue, 10 May 2022 13:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE54C385C2;
        Tue, 10 May 2022 13:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188347;
        bh=eGKVehjnwRCQlSs6dV3Bpvrmr8cNDnLluYxZbJGRHOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mu4YqwEcRiWUyw8wTITuYm6Cbvcoo7VjKnY5iO2oknrcBpKevQaTUGxppNRSln4Ds
         PwumNmwB1i0S2rF4xTfR3xTDtybymB06i91hf4Jrtv3u3vMrxpu4wRpsCmFDnzIejJ
         Xw09yUg3VOPxC05OJY4YuxGX5POlsMrDh99a5bWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.9 43/66] MIPS: Fix CP0 counter erratum detection for R4k CPUs
Date:   Tue, 10 May 2022 15:07:33 +0200
Message-Id: <20220510130731.029472163@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -168,15 +168,10 @@ static __init int cpu_has_mfc0_count_bug
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


