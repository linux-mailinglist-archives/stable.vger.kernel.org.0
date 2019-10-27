Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D53E692B
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbfJ0VJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729590AbfJ0VJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:57 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2C42064A;
        Sun, 27 Oct 2019 21:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210596;
        bh=1OvOHMUWN+zQfis1W/kvZd2XpNU2os5/nufc3T6RDOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwMEgEfWIumdONu9y8k3xVKKytxYeR8vkwrjyeDji8MCB4hM40iLdF0ImX1GcM/7C
         lSVJNMQ+PaqJ2i8vY0oRBsedejqHJYep0Olg+JIOQpwoS8J+PGvRwhk6uraqzX6r5i
         UhvLOi97RCbhM83bkIQPkCw+CR9ILv6P6va0IKNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 070/119] KVM: arm64: Set SCTLR_EL2.DSSBS if SSBD is forcefully disabled and !vhe
Date:   Sun, 27 Oct 2019 22:00:47 +0100
Message-Id: <20191027203336.044367544@linuxfoundation.org>
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

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit 7c36447ae5a090729e7b129f24705bb231a07e0b ]

When running without VHE, it is necessary to set SCTLR_EL2.DSSBS if SSBD
has been forcefully disabled on the kernel command-line.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |   11 +++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c    |   11 +++++++++++
 2 files changed, 22 insertions(+)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -356,6 +356,8 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struc
 void __kvm_set_tpidr_el2(u64 tpidr_el2);
 DECLARE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
 
+void __kvm_enable_ssbs(void);
+
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
 				       unsigned long vector_ptr)
@@ -380,6 +382,15 @@ static inline void __cpu_init_hyp_mode(p
 		- (u64)kvm_ksym_ref(kvm_host_cpu_state);
 
 	kvm_call_hyp(__kvm_set_tpidr_el2, tpidr_el2);
+
+	/*
+	 * Disabling SSBD on a non-VHE system requires us to enable SSBS
+	 * at EL2.
+	 */
+	if (!has_vhe() && this_cpu_has_cap(ARM64_SSBS) &&
+	    arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE) {
+		kvm_call_hyp(__kvm_enable_ssbs);
+	}
 }
 
 static inline void kvm_arch_hardware_unsetup(void) {}
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -188,3 +188,14 @@ void __hyp_text __kvm_set_tpidr_el2(u64
 {
 	asm("msr tpidr_el2, %0": : "r" (tpidr_el2));
 }
+
+void __hyp_text __kvm_enable_ssbs(void)
+{
+	u64 tmp;
+
+	asm volatile(
+	"mrs	%0, sctlr_el2\n"
+	"orr	%0, %0, %1\n"
+	"msr	sctlr_el2, %0"
+	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
+}


