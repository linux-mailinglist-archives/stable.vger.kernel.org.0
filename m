Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12335378525
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhEJK7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhEJKzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68C4661C1B;
        Mon, 10 May 2021 10:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643337;
        bh=ozWJ1bHSMPKF53C6asQdYJAhcF/9E/EAs0vCd0Me7xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQDLNertwu1HgMSNLrvJtdQvvzKDJOjZQaKKtp5ujKfPfTwzYZGSDuwmiD3+sGmFN
         O/59hIpm7w3ynvPVgabLmQ+o6sbqQXteuT1TTRg3zDi2l8VYEjDU2KztktQwvGUtix
         GJ28jLw9N7L9NW4baVD7s/cr2B+u32n+uf+Tlb4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 239/299] powerpc/powernv: Enable HAIL (HV AIL) for ISA v3.1 processors
Date:   Mon, 10 May 2021 12:20:36 +0200
Message-Id: <20210510102012.853309039@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 49c1d07fd04f54eb588c4a1dfcedc8d22c5ffd50 upstream.

Starting with ISA v3.1, LPCR[AIL] no longer controls the interrupt
mode for HV=1 interrupts. Instead, a new LPCR[HAIL] bit is defined
which behaves like AIL=3 for HV interrupts when set.

Set HAIL on bare metal to give us mmu-on interrupts and improve
performance.

This also fixes an scv bug: we don't implement scv real mode (AIL=0)
vectors because they are at an inconvenient location, so we just
disable scv support when AIL can not be set. However powernv assumes
that LPCR[AIL] will enable AIL mode so it enables scv support despite
HV interrupts being AIL=0, which causes scv interrupts to go off into
the weeds.

Fixes: 7fa95f9adaee ("powerpc/64s: system call support for scv/rfscv instructions")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210402024124.545826-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/reg.h |    1 +
 arch/powerpc/kernel/setup_64.c |   19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -444,6 +444,7 @@
 #define   LPCR_VRMA_LP1		ASM_CONST(0x0000800000000000)
 #define   LPCR_RMLS		0x1C000000	/* Implementation dependent RMO limit sel */
 #define   LPCR_RMLS_SH		26
+#define   LPCR_HAIL		ASM_CONST(0x0000000004000000)   /* HV AIL (ISAv3.1) */
 #define   LPCR_ILE		ASM_CONST(0x0000000002000000)   /* !HV irqs set MSR:LE */
 #define   LPCR_AIL		ASM_CONST(0x0000000001800000)	/* Alternate interrupt location */
 #define   LPCR_AIL_0		ASM_CONST(0x0000000000000000)	/* MMU off exception offset 0x0 */
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -231,10 +231,23 @@ static void cpu_ready_for_interrupts(voi
 	 * If we are not in hypervisor mode the job is done once for
 	 * the whole partition in configure_exceptions().
 	 */
-	if (cpu_has_feature(CPU_FTR_HVMODE) &&
-	    cpu_has_feature(CPU_FTR_ARCH_207S)) {
+	if (cpu_has_feature(CPU_FTR_HVMODE)) {
 		unsigned long lpcr = mfspr(SPRN_LPCR);
-		mtspr(SPRN_LPCR, lpcr | LPCR_AIL_3);
+		unsigned long new_lpcr = lpcr;
+
+		if (cpu_has_feature(CPU_FTR_ARCH_31)) {
+			/* P10 DD1 does not have HAIL */
+			if (pvr_version_is(PVR_POWER10) &&
+					(mfspr(SPRN_PVR) & 0xf00) == 0x100)
+				new_lpcr |= LPCR_AIL_3;
+			else
+				new_lpcr |= LPCR_HAIL;
+		} else if (cpu_has_feature(CPU_FTR_ARCH_207S)) {
+			new_lpcr |= LPCR_AIL_3;
+		}
+
+		if (new_lpcr != lpcr)
+			mtspr(SPRN_LPCR, new_lpcr);
 	}
 
 	/*


