Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C28122013
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfLQAvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35512 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727177AbfLQAvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003N3-Ub; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005aC-0u; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dmitry Korotin" <dkorotin@wavecomp.com>,
        linux-mips@vger.kernel.org, "Paul Burton" <paulburton@kernel.org>
Date:   Tue, 17 Dec 2019 00:47:03 +0000
Message-ID: <lsq.1576543535.646013337@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 089/136] MIPS: tlbex: Fix build_restore_pagemask
 KScratch restore
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Burton <paulburton@kernel.org>

commit b42aa3fd5957e4daf4b69129e5ce752a2a53e7d6 upstream.

build_restore_pagemask() will restore the value of register $1/$at when
its restore_scratch argument is non-zero, and aims to do so by filling a
branch delay slot. Commit 0b24cae4d535 ("MIPS: Add missing EHB in mtc0
-> mfc0 sequence.") added an EHB instruction (Execution Hazard Barrier)
prior to restoring $1 from a KScratch register, in order to resolve a
hazard that can result in stale values of the KScratch register being
observed. In particular, P-class CPUs from MIPS with out of order
execution pipelines such as the P5600 & P6600 are affected.

Unfortunately this EHB instruction was inserted in the branch delay slot
causing the MFC0 instruction which performs the restoration to no longer
execute along with the branch. The result is that the $1 register isn't
actually restored, ie. the TLB refill exception handler clobbers it -
which is exactly the problem the EHB is meant to avoid for the P-class
CPUs.

Similarly build_get_pgd_vmalloc() will restore the value of $1/$at when
its mode argument equals refill_scratch, and suffers from the same
problem.

Fix this by in both cases moving the EHB earlier in the emitted code.
There's no reason it needs to immediately precede the MFC0 - it simply
needs to be between the MTC0 & MFC0.

This bug only affects Cavium Octeon systems which use
build_fast_tlb_refill_handler().

Signed-off-by: Paul Burton <paulburton@kernel.org>
Fixes: 0b24cae4d535 ("MIPS: Add missing EHB in mtc0 -> mfc0 sequence.")
Cc: Dmitry Korotin <dkorotin@wavecomp.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/mm/tlbex.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -652,6 +652,13 @@ static void build_restore_pagemask(u32 *
 				   int restore_scratch)
 {
 	if (restore_scratch) {
+		/*
+		 * Ensure the MFC0 below observes the value written to the
+		 * KScratch register by the prior MTC0.
+		 */
+		if (scratch_reg >= 0)
+			uasm_i_ehb(p);
+
 		/* Reset default page size */
 		if (PM_DEFAULT_MASK >> 16) {
 			uasm_i_lui(p, tmp, PM_DEFAULT_MASK >> 16);
@@ -666,12 +673,10 @@ static void build_restore_pagemask(u32 *
 			uasm_i_mtc0(p, 0, C0_PAGEMASK);
 			uasm_il_b(p, r, lid);
 		}
-		if (scratch_reg >= 0) {
-			uasm_i_ehb(p);
+		if (scratch_reg >= 0)
 			UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-		} else {
+		else
 			UASM_i_LW(p, 1, scratchpad_offset(0), 0);
-		}
 	} else {
 		/* Reset default page size */
 		if (PM_DEFAULT_MASK >> 16) {
@@ -893,6 +898,10 @@ build_get_pgd_vmalloc64(u32 **p, struct
 	}
 	if (mode != not_refill && check_for_high_segbits) {
 		uasm_l_large_segbits_fault(l, *p);
+
+		if (mode == refill_scratch && scratch_reg >= 0)
+			uasm_i_ehb(p);
+
 		/*
 		 * We get here if we are an xsseg address, or if we are
 		 * an xuseg address above (PGDIR_SHIFT+PGDIR_BITS) boundary.
@@ -909,12 +918,10 @@ build_get_pgd_vmalloc64(u32 **p, struct
 		uasm_i_jr(p, ptr);
 
 		if (mode == refill_scratch) {
-			if (scratch_reg >= 0) {
-				uasm_i_ehb(p);
+			if (scratch_reg >= 0)
 				UASM_i_MFC0(p, 1, c0_kscratch(), scratch_reg);
-			} else {
+			else
 				UASM_i_LW(p, 1, scratchpad_offset(0), 0);
-			}
 		} else {
 			uasm_i_nop(p);
 		}

