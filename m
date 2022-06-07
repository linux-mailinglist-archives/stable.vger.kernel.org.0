Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8F853A7B6
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354313AbiFAODD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354746AbiFAOAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C2134BBC;
        Wed,  1 Jun 2022 06:57:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38721CE1C0A;
        Wed,  1 Jun 2022 13:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AEEC385B8;
        Wed,  1 Jun 2022 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091834;
        bh=DDlu5SYryuJhbBYWpBA3QWYaaiqvcDlavCiH1BkdFmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mcmrtnoFVZ+9CmVlSlkcIVtzscEBbDFSnebIQStprSHF1fFWGDcbgtPYlNhgXGm2f
         vAv3TMqJMf9GtdJhoRQSdEtkDSjFC1sv8525/nncETRUmwBYFE7Ff+A1H9FQfxRdRs
         iTF7X1loOp5FfQxlf2BOYPq6qPbZvvbauPvtRv4hRIKwQJrNGsOFoQGurDdUtAnGSy
         pExwYv5OXIm85qT02zTojYiDdWusmGdYUpYxLGU7LP7lb9geZB0X+PtPM8OaHn8oeU
         JnvXyGnzFbrSDiasXtrpjqDj6KOgymkIXJxeLh6IU5tyg7woQ0qkanpGTpb4SYUUC0
         LFq7zI78X8kMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Dufour <ldufour@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        nathanl@linux.ibm.com, rafael.j.wysocki@intel.com,
        adobriyan@gmail.com, sourabhjain@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 24/37] powerpc/rtas: Keep MSR[RI] set when calling RTAS
Date:   Wed,  1 Jun 2022 09:56:09 -0400
Message-Id: <20220601135622.2003939-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit b6b1c3ce06ca438eb24e0f45bf0e63ecad0369f5 ]

RTAS runs in real mode (MSR[DR] and MSR[IR] unset) and in 32-bit big
endian mode (MSR[SF,LE] unset).

The change in MSR is done in enter_rtas() in a relatively complex way,
since the MSR value could be hardcoded.

Furthermore, a panic has been reported when hitting the watchdog interrupt
while running in RTAS, this leads to the following stack trace:

  watchdog: CPU 24 Hard LOCKUP
  watchdog: CPU 24 TB:997512652051031, last heartbeat TB:997504470175378 (15980ms ago)
  ...
  Supported: No, Unreleased kernel
  CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Tainted: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-SP4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
  NIP:  000000001fb41050 LR: 000000001fb4104c CTR: 0000000000000000
  REGS: c00000000fc33d60 TRAP: 0100   Tainted: G            E  X     (5.14.21-150400.71.1.bz196362_2-default)
  MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 48800002  XER: 20040020
  CFAR: 000000000000011c IRQMASK: 1
  GPR00: 0000000000000003 ffffffffffffffff 0000000000000001 00000000000050dc
  GPR04: 000000001ffb6100 0000000000000020 0000000000000001 000000001fb09010
  GPR08: 0000000020000000 0000000000000000 0000000000000000 0000000000000000
  GPR12: 80040000072a40a8 c00000000ff8b680 0000000000000007 0000000000000034
  GPR16: 000000001fbf6e94 000000001fbf6d84 000000001fbd1db0 000000001fb3f008
  GPR20: 000000001fb41018 ffffffffffffffff 000000000000017f fffffffffffff68f
  GPR24: 000000001fb18fe8 000000001fb3e000 000000001fb1adc0 000000001fb1cf40
  GPR28: 000000001fb26000 000000001fb460f0 000000001fb17f18 000000001fb17000
  NIP [000000001fb41050] 0x1fb41050
  LR [000000001fb4104c] 0x1fb4104c
  Call Trace:
  Instruction dump:
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  Oops: Unrecoverable System Reset, sig: 6 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  ...
  Supported: No, Unreleased kernel
  CPU: 24 PID: 87504 Comm: drmgr Kdump: loaded Tainted: G            E  X    5.14.21-150400.71.1.bz196362_2-default #1 SLE15-SP4 (unreleased) 0d821077ef4faa8dfaf370efb5fdca1fa35f4e2c
  NIP:  000000001fb41050 LR: 000000001fb4104c CTR: 0000000000000000
  REGS: c00000000fc33d60 TRAP: 0100   Tainted: G            E  X     (5.14.21-150400.71.1.bz196362_2-default)
  MSR:  8000000002981000 <SF,VEC,VSX,ME>  CR: 48800002  XER: 20040020
  CFAR: 000000000000011c IRQMASK: 1
  GPR00: 0000000000000003 ffffffffffffffff 0000000000000001 00000000000050dc
  GPR04: 000000001ffb6100 0000000000000020 0000000000000001 000000001fb09010
  GPR08: 0000000020000000 0000000000000000 0000000000000000 0000000000000000
  GPR12: 80040000072a40a8 c00000000ff8b680 0000000000000007 0000000000000034
  GPR16: 000000001fbf6e94 000000001fbf6d84 000000001fbd1db0 000000001fb3f008
  GPR20: 000000001fb41018 ffffffffffffffff 000000000000017f fffffffffffff68f
  GPR24: 000000001fb18fe8 000000001fb3e000 000000001fb1adc0 000000001fb1cf40
  GPR28: 000000001fb26000 000000001fb460f0 000000001fb17f18 000000001fb17000
  NIP [000000001fb41050] 0x1fb41050
  LR [000000001fb4104c] 0x1fb4104c
  Call Trace:
  Instruction dump:
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
  ---[ end trace 3ddec07f638c34a2 ]---

This happens because MSR[RI] is unset when entering RTAS but there is no
valid reason to not set it here.

RTAS is expected to be called with MSR[RI] as specified in PAPR+ section
"7.2.1 Machine State":

  R1–7.2.1–9. If called with MSR[RI] equal to 1, then RTAS must protect
  its own critical regions from recursion by setting the MSR[RI] bit to
  0 when in the critical regions.

Fixing this by reviewing the way MSR is compute before calling RTAS. Now a
hardcoded value meaning real mode, 32 bits big endian mode and Recoverable
Interrupt is loaded. In the case MSR[S] is set, it will remain set while
entering RTAS as only urfid can unset it (thanks Fabiano).

In addition a check is added in do_enter_rtas() to detect calls made with
MSR[RI] unset, as we are forcing it on later.

This patch has been tested on the following machines:
Power KVM Guest
  P8 S822L (host Ubuntu kernel 5.11.0-49-generic)
PowerVM LPAR
  P8 9119-MME (FW860.A1)
  p9 9008-22L (FW950.00)
  P10 9080-HEX (FW1010.00)

Suggested-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220504101244.12107-1-ldufour@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/entry_64.S | 24 ++++++++++++------------
 arch/powerpc/kernel/rtas.c     |  9 +++++++++
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 70cff7b49e17..07a1448146e2 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -330,22 +330,22 @@ _GLOBAL(enter_rtas)
 	clrldi	r4,r4,2			/* convert to realmode address */
        	mtlr	r4
 
-	li	r0,0
-	ori	r0,r0,MSR_EE|MSR_SE|MSR_BE|MSR_RI
-	andc	r0,r6,r0
-	
-        li      r9,1
-        rldicr  r9,r9,MSR_SF_LG,(63-MSR_SF_LG)
-	ori	r9,r9,MSR_IR|MSR_DR|MSR_FE0|MSR_FE1|MSR_FP|MSR_RI|MSR_LE
-	andc	r6,r0,r9
-
 __enter_rtas:
-	sync				/* disable interrupts so SRR0/1 */
-	mtmsrd	r0			/* don't get trashed */
-
 	LOAD_REG_ADDR(r4, rtas)
 	ld	r5,RTASENTRY(r4)	/* get the rtas->entry value */
 	ld	r4,RTASBASE(r4)		/* get the rtas->base value */
+
+	/*
+	 * RTAS runs in 32-bit big endian real mode, but leave MSR[RI] on as we
+	 * may hit NMI (SRESET or MCE) while in RTAS. RTAS should disable RI in
+	 * its critical regions (as specified in PAPR+ section 7.2.1). MSR[S]
+	 * is not impacted by RFI_TO_KERNEL (only urfid can unset it). So if
+	 * MSR[S] is set, it will remain when entering RTAS.
+	 */
+	LOAD_REG_IMMEDIATE(r6, MSR_ME | MSR_RI)
+
+	li      r0,0
+	mtmsrd  r0,1                    /* disable RI before using SRR0/1 */
 	
 	mtspr	SPRN_SRR0,r5
 	mtspr	SPRN_SRR1,r6
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index e18a725a8e5d..3f5814037035 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -49,6 +49,15 @@ void enter_rtas(unsigned long);
 
 static inline void do_enter_rtas(unsigned long args)
 {
+	unsigned long msr;
+
+	/*
+	 * Make sure MSR[RI] is currently enabled as it will be forced later
+	 * in enter_rtas.
+	 */
+	msr = mfmsr();
+	BUG_ON(!(msr & MSR_RI));
+
 	enter_rtas(args);
 
 	srr_regs_clobbered(); /* rtas uses SRRs, invalidate */
-- 
2.35.1

