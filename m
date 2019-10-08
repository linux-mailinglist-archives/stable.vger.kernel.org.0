Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F9FCFDD2
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfJHPkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:14 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51278 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfJHPkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id 7so3708092wme.1
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X9k/nqOLAylh00xkHgeHzZJoJeH5DmiWZVGTdUdx6Qk=;
        b=PZx2hAK0dMyPpXJk37fFKZsntkGJ+X7KJ/3wlIDhuhXMHoTHJOtmAWTPOYOx0ZrsQn
         F7ULkpC6+VKFX5O0jisCvPKSQ1YXeOGOZ0Srx1BZxajfM0W2Rh9uOG/FxDqz9J5Ejaxk
         QNpo2SF2pfz0xrFQeYRAya4EpRkvO/8ptWDMkZ4oJ+Iy4vjyDxqijIF1vK5KCgpO9hMj
         G5O5aAbtoNeLQMUC/p0/bdd5Ku+9OWyBllf67hEsZuIz28hqV+203WEcR+ek6Xy7HQVM
         R/BlGHMa1YTwBTwgH4NFLgp15KrM0wUSa3vnNQX5w9wGx4sFcOyim5WqQ4G3xvpfgiT/
         zXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X9k/nqOLAylh00xkHgeHzZJoJeH5DmiWZVGTdUdx6Qk=;
        b=hEyOn71gJkfbh0M11TAtT0Pse0K1sI0zDOQXmXWqQDiheSrwXYPooKlPt41DmMn4O2
         1QPhyxiNaakJxvpSF2i5py4Ib4aYwmCAvkZn/vSH5xK+PjbRjrn/7o0iyR5/QBY5jGFr
         JDgdK40C8tW7QpNcODCehIaTAmGzEoVvX9xqHXC8zY3mXJnwVq9n4tOOyVR/rQ4PXEGE
         AujZiL46mUZrzaF7zyGHraFypu7W30i4fT6HPSpl6dE7elRFC+r6j09/TB1ecVRxdTGf
         p+xgCAQ7/XpJUT2x5eau+abJRYZk/VkFvNXrzyllbYSbhgueVP6XLYV99gwNJMY5cuI9
         dsEw==
X-Gm-Message-State: APjAAAV8nbLFuiDY9IZB7Hg2zKJlO6AbhU8ao7SScld8MLFd79nVFZ1a
        S9tSzGw2Pti4MgS+ao5NV/BqgT5+csmHgw==
X-Google-Smtp-Source: APXvYqx9VU98vVPd6rS7kPqp9OunnRa+j0CqfzsTjR3Gh/FSir0+67AM5xQxUluEpigyXVXZskWoTg==
X-Received: by 2002:a1c:ed02:: with SMTP id l2mr4173987wmh.155.1570549211982;
        Tue, 08 Oct 2019 08:40:11 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:10 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 03/16] KVM: arm64: Set SCTLR_EL2.DSSBS if SSBD is forcefully disabled and !vhe
Date:   Tue,  8 Oct 2019 17:39:17 +0200
Message-Id: <20191008153930.15386-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
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
index 6abe4002945f..367b2e0b6d76 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -398,6 +398,8 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 
 DECLARE_PER_CPU(kvm_cpu_context_t, kvm_host_cpu_state);
 
+void __kvm_enable_ssbs(void);
+
 static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 				       unsigned long hyp_stack_ptr,
 				       unsigned long vector_ptr)
@@ -418,6 +420,15 @@ static inline void __cpu_init_hyp_mode(phys_addr_t pgd_ptr,
 	 */
 	BUG_ON(!static_branch_likely(&arm64_const_caps_ready));
 	__kvm_call_hyp((void *)pgd_ptr, hyp_stack_ptr, vector_ptr, tpidr_el2);
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
 
 static inline bool kvm_arch_check_sve_has_vhe(void)
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 963d669ae3a2..7414b76191c2 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -293,3 +293,14 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.sysregs_loaded_on_cpu = false;
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

