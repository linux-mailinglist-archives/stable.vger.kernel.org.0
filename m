Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4603DE6652
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbfJ0VKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbfJ0VKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:10:43 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 062A02064A;
        Sun, 27 Oct 2019 21:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210642;
        bh=/gWfBVXQDmT55zrCrf1LNT8GyHRiPFyNAtoTtM6/C/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0W1WuVc+oLlB2XAgf/fgUi+uppGdstxA8W6V5MgaOgrEOmrOYcEkhoVDdk8WO5ez
         RpTfqp0qs3xmP6SwnU671qAZj2EuZCBtyclaTbG7dDLMp3ijf5jkr5LdSEwF51V6hs
         WItihrYCazK3C8V/LMns2ynVb1pAcSk0v1apow3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Dmitry Korotin <dkorotin@wavecomp.com>,
        linux-mips@vger.kernel.org
Subject: [PATCH 4.14 085/119] MIPS: tlbex: Fix build_restore_pagemask KScratch restore
Date:   Sun, 27 Oct 2019 22:01:02 +0100
Message-Id: <20191027203346.823276486@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org # v3.15+
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/tlbex.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -658,6 +658,13 @@ static void build_restore_pagemask(u32 *
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
@@ -672,12 +679,10 @@ static void build_restore_pagemask(u32 *
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
@@ -926,6 +931,10 @@ build_get_pgd_vmalloc64(u32 **p, struct
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
@@ -942,12 +951,10 @@ build_get_pgd_vmalloc64(u32 **p, struct
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


