Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CF0A6FFE
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbfICQft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730922AbfICQ1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 412DB238C6;
        Tue,  3 Sep 2019 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528060;
        bh=ZsVtxklk/JzEFceQMjTt/P8EYOL7MvwBNXU5d/AO3OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujWY6HiW4GpGlOspq1d0ui5xjyL3VRz+sVcumWaZE++oXvME+HCMtNbtybq9f83xd
         YRazMsMhFHOq/7EHDV3dVjWARKTKWmQzZ8Zvu7VN8LKlh8cmAJvr5RVFBw9R6NWbLp
         E6kmK3q3BUmd6clepjjemP+NSW0JfCoVCDl6nhsI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Russell Currey <ruscur@russell.cc>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 075/167] powerpc/kvm: Save and restore host AMR/IAMR/UAMOR
Date:   Tue,  3 Sep 2019 12:23:47 -0400
Message-Id: <20190903162519.7136-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit c3c7470c75566a077c8dc71dcf8f1948b8ddfab4 ]

When the hash MMU is active the AMR, IAMR and UAMOR are used for
pkeys. The AMR is directly writable by user space, and the UAMOR masks
those writes, meaning both registers are effectively user register
state. The IAMR is used to create an execute only key.

Also we must maintain the value of at least the AMR when running in
process context, so that any memory accesses done by the kernel on
behalf of the process are correctly controlled by the AMR.

Although we are correctly switching all registers when going into a
guest, on returning to the host we just write 0 into all regs, except
on Power9 where we restore the IAMR correctly.

This could be observed by a user process if it writes the AMR, then
runs a guest and we then return immediately to it without
rescheduling. Because we have written 0 to the AMR that would have the
effect of granting read/write permission to pages that the process was
trying to protect.

In addition, when using the Radix MMU, the AMR can prevent inadvertent
kernel access to userspace data, writing 0 to the AMR disables that
protection.

So save and restore AMR, IAMR and UAMOR.

Fixes: cf43d3b26452 ("powerpc: Enable pkey subsystem")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_rmhandlers.S | 26 ++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 1d14046124a01..5902a60f92268 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -56,6 +56,8 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 #define STACK_SLOT_DAWR		(SFS-56)
 #define STACK_SLOT_DAWRX	(SFS-64)
 #define STACK_SLOT_HFSCR	(SFS-72)
+#define STACK_SLOT_AMR		(SFS-80)
+#define STACK_SLOT_UAMOR	(SFS-88)
 
 /*
  * Call kvmppc_hv_entry in real mode.
@@ -760,11 +762,9 @@ BEGIN_FTR_SECTION
 	mfspr	r5, SPRN_TIDR
 	mfspr	r6, SPRN_PSSCR
 	mfspr	r7, SPRN_PID
-	mfspr	r8, SPRN_IAMR
 	std	r5, STACK_SLOT_TID(r1)
 	std	r6, STACK_SLOT_PSSCR(r1)
 	std	r7, STACK_SLOT_PID(r1)
-	std	r8, STACK_SLOT_IAMR(r1)
 	mfspr	r5, SPRN_HFSCR
 	std	r5, STACK_SLOT_HFSCR(r1)
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
@@ -772,11 +772,18 @@ BEGIN_FTR_SECTION
 	mfspr	r5, SPRN_CIABR
 	mfspr	r6, SPRN_DAWR
 	mfspr	r7, SPRN_DAWRX
+	mfspr	r8, SPRN_IAMR
 	std	r5, STACK_SLOT_CIABR(r1)
 	std	r6, STACK_SLOT_DAWR(r1)
 	std	r7, STACK_SLOT_DAWRX(r1)
+	std	r8, STACK_SLOT_IAMR(r1)
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 
+	mfspr	r5, SPRN_AMR
+	std	r5, STACK_SLOT_AMR(r1)
+	mfspr	r6, SPRN_UAMOR
+	std	r6, STACK_SLOT_UAMOR(r1)
+
 BEGIN_FTR_SECTION
 	/* Set partition DABR */
 	/* Do this before re-enabling PMU to avoid P7 DABR corruption bug */
@@ -1713,22 +1720,25 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
 	mtspr	SPRN_PSPB, r0
 	mtspr	SPRN_WORT, r0
 BEGIN_FTR_SECTION
-	mtspr	SPRN_IAMR, r0
 	mtspr	SPRN_TCSCR, r0
 	/* Set MMCRS to 1<<31 to freeze and disable the SPMC counters */
 	li	r0, 1
 	sldi	r0, r0, 31
 	mtspr	SPRN_MMCRS, r0
 END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
-8:
 
-	/* Save and reset AMR and UAMOR before turning on the MMU */
+	/* Save and restore AMR, IAMR and UAMOR before turning on the MMU */
+	ld	r8, STACK_SLOT_IAMR(r1)
+	mtspr	SPRN_IAMR, r8
+
+8:	/* Power7 jumps back in here */
 	mfspr	r5,SPRN_AMR
 	mfspr	r6,SPRN_UAMOR
 	std	r5,VCPU_AMR(r9)
 	std	r6,VCPU_UAMOR(r9)
-	li	r6,0
-	mtspr	SPRN_AMR,r6
+	ld	r5,STACK_SLOT_AMR(r1)
+	ld	r6,STACK_SLOT_UAMOR(r1)
+	mtspr	SPRN_AMR, r5
 	mtspr	SPRN_UAMOR, r6
 
 	/* Switch DSCR back to host value */
@@ -1897,11 +1907,9 @@ BEGIN_FTR_SECTION
 	ld	r5, STACK_SLOT_TID(r1)
 	ld	r6, STACK_SLOT_PSSCR(r1)
 	ld	r7, STACK_SLOT_PID(r1)
-	ld	r8, STACK_SLOT_IAMR(r1)
 	mtspr	SPRN_TIDR, r5
 	mtspr	SPRN_PSSCR, r6
 	mtspr	SPRN_PID, r7
-	mtspr	SPRN_IAMR, r8
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
 
 #ifdef CONFIG_PPC_RADIX_MMU
-- 
2.20.1

