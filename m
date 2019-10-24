Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849ADE32EC
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbfJXMtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40122 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502118AbfJXMtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id o28so25924413wro.7
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YBSRDE2HlafucilzgQX4Q1fEbsVPghL4W0cV3TTSJqc=;
        b=dvZKYkJdPeJYXQ4P1gMlHvVbwUwzM9mDXXUIb9S1dH27VoYQU2MIYOnFc47WbgkptI
         iencj8m0t+NXFGMnupQfKN9r3YRawEeYXMfDZdfmp8p+fYYhrXEcgtXSTNCpZtbCyHM5
         szKF+1uiripN2Vj9loJDEDVAq65fIDQ+EOYrkOaEC7STxPfHMZqjO0d5q3ujrUmhzyfA
         UzD7M0PRSht1IArTivhVcQghfEGyvtbcjzw3f4WqFu3kIMjgSeX5DJYUCt/2z1/5H9hi
         wSaTWQRVD/j3ZyqfCjFga08UTMCotc2hty/910Gk820W36H8HiIRBj1E69a3DOUM0BoO
         yBpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YBSRDE2HlafucilzgQX4Q1fEbsVPghL4W0cV3TTSJqc=;
        b=RJXkIv8IDy6sQXQZraaMn13Y+Oj4IZKGHhK1neW5ZsEe2tL88b53W1S0gEZDgnRczM
         Vk0mPCQIl8GsGgznqV25YFXXXlxSFnvh059KYfXEx5dYTJ78vTms4TXNkuzWO0Iiydzh
         G36hrCPuQzYPMXR7O3LD/p6b4rH7BctcxZa1Ee1N0MsoDdBUEWnYc180+a1EWkeQ6/ww
         P6y/7nWcvoHRpY9SY486PW9sgOHe/o5Ovx8hho/1pGguxHy1+TdxdTl+5OXFDE71fVtx
         X1Y0k3+iXuTOse2RnVa1zPyDmuir5dN2XYJdllAgr7goAzl51aL/HWAzYFjzXb8tMrAD
         7oyg==
X-Gm-Message-State: APjAAAVvpJCeV08T0M3ats3FA3B1bXhlnY2Lpi2+IWHlRp2EKb9Vajpn
        IldTnwyfcKb7emiFWbqDX9njXWEwaAcux8Dm
X-Google-Smtp-Source: APXvYqzaGaHKl7PS5gLWzcrcyk+Cd4RNHWfGpaCVQWJS2D7p8ZLshIhBcySzlmKSNkwpin8/R6hhgA==
X-Received: by 2002:adf:d846:: with SMTP id k6mr3805324wrl.178.1571921382814;
        Thu, 24 Oct 2019 05:49:42 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:41 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH for-stable-4.14 34/48] KVM: arm64: Set SCTLR_EL2.DSSBS if SSBD is forcefully disabled and !vhe
Date:   Thu, 24 Oct 2019 14:48:19 +0200
Message-Id: <20191024124833.4158-35-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
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
---
 arch/arm64/include/asm/kvm_host.h | 11 +++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c    | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b01ad3489bd8..f982c9d1d10b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -356,6 +356,8 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 void __kvm_set_tpidr_el2(u64 tpidr_el2);
 DECLARE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
 
+void __kvm_enable_ssbs(void);
+
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
 				       unsigned long vector_ptr)
@@ -380,6 +382,15 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
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
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index e19d89cabf2a..3773311ffcd0 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -188,3 +188,14 @@ void __hyp_text __kvm_set_tpidr_el2(u64 tpidr_el2)
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
-- 
2.20.1

