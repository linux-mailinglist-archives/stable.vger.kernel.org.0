Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8767B2A5184
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbgKCUld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:41:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgKCUlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:41:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C89B2224E;
        Tue,  3 Nov 2020 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436091;
        bh=VUGwMPfZGW+1mMj7jlP06cHUXqmzfN8zHnrsmoHawts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYhUsM4Co788fVCCnvBv4N1oyxReOomjLLdZCbUbM8xlfvZrT2nkibh+s5qpgYiaK
         gfFjTkE7GWA4i77zv54lvkoUzozIB3o2OFOpy86uS7RkNHhAWJH0o1ME63I6UuTS3q
         /4pPAsKYBuXxsAGeUNYUQucip88HPCNPmL4yh6pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 061/391] powerpc/64s: handle ISA v3.1 local copy-paste context switches
Date:   Tue,  3 Nov 2020 21:31:52 +0100
Message-Id: <20201103203351.480716817@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit dc462267d2d7aacffc3c1d99b02d7a7c59db7c66 ]

The ISA v3.1 the copy-paste facility has a new memory move functionality
which allows the copy buffer to be pasted to domestic memory (RAM) as
opposed to foreign memory (accelerator).

This means the POWER9 trick of avoiding the cp_abort on context switch if
the process had not mapped foreign memory does not work on POWER10. Do the
cp_abort unconditionally there.

KVM must also cp_abort on guest exit to prevent copy buffer state leaking
between contexts.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200825075535.224536-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/process.c           | 16 +++++++++-------
 arch/powerpc/kvm/book3s_hv.c            |  7 +++++++
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  8 ++++++++
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 73a57043ee662..3f2dc0675ea7a 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1256,15 +1256,17 @@ struct task_struct *__switch_to(struct task_struct *prev,
 		restore_math(current->thread.regs);
 
 		/*
-		 * The copy-paste buffer can only store into foreign real
-		 * addresses, so unprivileged processes can not see the
-		 * data or use it in any way unless they have foreign real
-		 * mappings. If the new process has the foreign real address
-		 * mappings, we must issue a cp_abort to clear any state and
-		 * prevent snooping, corruption or a covert channel.
+		 * On POWER9 the copy-paste buffer can only paste into
+		 * foreign real addresses, so unprivileged processes can not
+		 * see the data or use it in any way unless they have
+		 * foreign real mappings. If the new process has the foreign
+		 * real address mappings, we must issue a cp_abort to clear
+		 * any state and prevent snooping, corruption or a covert
+		 * channel. ISA v3.1 supports paste into local memory.
 		 */
 		if (current->mm &&
-			atomic_read(&current->mm->context.vas_windows))
+			(cpu_has_feature(CPU_FTR_ARCH_31) ||
+			atomic_read(&current->mm->context.vas_windows)))
 			asm volatile(PPC_CP_ABORT);
 	}
 #endif /* CONFIG_PPC_BOOK3S_64 */
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4ba06a2a306cf..3bd3118c76330 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3530,6 +3530,13 @@ static int kvmhv_load_hv_regs_and_go(struct kvm_vcpu *vcpu, u64 time_limit,
 	 */
 	asm volatile("eieio; tlbsync; ptesync");
 
+	/*
+	 * cp_abort is required if the processor supports local copy-paste
+	 * to clear the copy buffer that was under control of the guest.
+	 */
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		asm volatile(PPC_CP_ABORT);
+
 	mtspr(SPRN_LPID, vcpu->kvm->arch.host_lpid);	/* restore host LPID */
 	isync();
 
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 799d6d0f4eade..cd9995ee84419 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1830,6 +1830,14 @@ END_FTR_SECTION_IFSET(CPU_FTR_P9_RADIX_PREFETCH_BUG)
 2:
 #endif /* CONFIG_PPC_RADIX_MMU */
 
+	/*
+	 * cp_abort is required if the processor supports local copy-paste
+	 * to clear the copy buffer that was under control of the guest.
+	 */
+BEGIN_FTR_SECTION
+	PPC_CP_ABORT
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_31)
+
 	/*
 	 * POWER7/POWER8 guest -> host partition switch code.
 	 * We don't have to lock against tlbies but we do
-- 
2.27.0



