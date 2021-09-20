Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B645412543
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343554AbhITSml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382497AbhITSka (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38E6261ADF;
        Mon, 20 Sep 2021 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159085;
        bh=3KmBWArWvSZPoI25NiEyxO+KKLFIDhsFSI3XCOiW6u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1sTHXHZN2zYBlC04Wdhjxlz1ytTtltL0qtQHfXCrqZjcec8iLZGEnbXJRtAGMtCJ
         YG1TKtwDSAKcFg1DnVDnX+cGd5cIoaNB/WRrPHYwdPO8CcAWi2AthBQR9GNsybsp7V
         H6pyrbPtFPJwVQXSkdDxcOtNJNf3dXJYiFCpgXFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.14 070/168] KVM: PPC: Book3S HV: Tolerate treclaim. in fake-suspend mode changing registers
Date:   Mon, 20 Sep 2021 18:43:28 +0200
Message-Id: <20210920163923.946189367@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 267cdfa21385d78c794768233678756e32b39ead upstream.

POWER9 DD2.2 and 2.3 hardware implements a "fake-suspend" mode where
certain TM instructions executed in HV=0 mode cause softpatch interrupts
so the hypervisor can emulate them and prevent problematic processor
conditions. In this fake-suspend mode, the treclaim. instruction does
not modify registers.

Unfortunately the rfscv instruction executed by the guest do not
generate softpatch interrupts, which can cause the hypervisor to lose
track of the fake-suspend mode, and it can execute this treclaim. while
not in fake-suspend mode. This modifies GPRs and crashes the hypervisor.

It's not trivial to disable scv in the guest with HFSCR now, because
they assume a POWER9 has scv available. So this fix saves and restores
checkpointed registers across the treclaim.

Fixes: 7854f7545bff ("KVM: PPC: Book3S: Rework TM save/restore code and make it C-callable")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210908101718.118522-2-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   36 ++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2578,7 +2578,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_P9_TM_HV_A
 	/* The following code handles the fake_suspend = 1 case */
 	mflr	r0
 	std	r0, PPC_LR_STKOFF(r1)
-	stdu	r1, -PPC_MIN_STKFRM(r1)
+	stdu	r1, -TM_FRAME_SIZE(r1)
 
 	/* Turn on TM. */
 	mfmsr	r8
@@ -2593,10 +2593,42 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFSET(CPU_FTR_P9_TM_XER_SO_BUG)
 	nop
 
+	/*
+	 * It's possible that treclaim. may modify registers, if we have lost
+	 * track of fake-suspend state in the guest due to it using rfscv.
+	 * Save and restore registers in case this occurs.
+	 */
+	mfspr	r3, SPRN_DSCR
+	mfspr	r4, SPRN_XER
+	mfspr	r5, SPRN_AMR
+	/* SPRN_TAR would need to be saved here if the kernel ever used it */
+	mfcr	r12
+	SAVE_NVGPRS(r1)
+	SAVE_GPR(2, r1)
+	SAVE_GPR(3, r1)
+	SAVE_GPR(4, r1)
+	SAVE_GPR(5, r1)
+	stw	r12, 8(r1)
+	std	r1, HSTATE_HOST_R1(r13)
+
 	/* We have to treclaim here because that's the only way to do S->N */
 	li	r3, TM_CAUSE_KVM_RESCHED
 	TRECLAIM(R3)
 
+	GET_PACA(r13)
+	ld	r1, HSTATE_HOST_R1(r13)
+	REST_GPR(2, r1)
+	REST_GPR(3, r1)
+	REST_GPR(4, r1)
+	REST_GPR(5, r1)
+	lwz	r12, 8(r1)
+	REST_NVGPRS(r1)
+	mtspr	SPRN_DSCR, r3
+	mtspr	SPRN_XER, r4
+	mtspr	SPRN_AMR, r5
+	mtcr	r12
+	HMT_MEDIUM
+
 	/*
 	 * We were in fake suspend, so we are not going to save the
 	 * register state as the guest checkpointed state (since
@@ -2624,7 +2656,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_P9_TM_XER_
 	std	r5, VCPU_TFHAR(r9)
 	std	r6, VCPU_TFIAR(r9)
 
-	addi	r1, r1, PPC_MIN_STKFRM
+	addi	r1, r1, TM_FRAME_SIZE
 	ld	r0, PPC_LR_STKOFF(r1)
 	mtlr	r0
 	blr


