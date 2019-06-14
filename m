Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804C945286
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfFNDNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:32 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44971 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id t7so366561plr.11
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pEvDH0l3Ogb+ETQluMoz8xjNqG/my4E0M8F+Bzkpfu4=;
        b=WlxYLpJqqc1s7ub+NyoMG89aE24FhTuR1DAGYoyRKrh58s1SM+98OItieICpHHaYKz
         j2XOKW5FhK/BqeAceNAYaH9h0teSC/B9bVUzCHj9RJpo4BWpcOm90NdrPPczDsQzxdpz
         MLP6MnCgpO3fGdk4dtky8QiWa1xxD7FZaLq3M03BgAmDwsK+TzThlwggyJpbYd09+wLA
         f3rJOyNYWL2YEr+nkMmP3eYjQ7SqG+0PAWrQAbIbVYtDa65LiPe0EGfr9oaz8X+P29DU
         ocYxamwYeiQ8R/uyXovL8UosqdJ83KPD5Lmwg57O62ycbsMsKqTE6FISGcyBwvTfKPqu
         jNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pEvDH0l3Ogb+ETQluMoz8xjNqG/my4E0M8F+Bzkpfu4=;
        b=cpN95f1MN27T6/L/24zxuNj9L1WB8+MpeYQl7ZiMW5QX7nLIq5FsR3u1AKsVkjHKc/
         l3MaVxBEK+DDfvEBBxC0FcNkZzloJBtkssDToiaDxGlHQdPHvIZOmkdl9moYnpniY/qg
         p/nfaP15AXLmcfAYH9fEMf8zTB67sV0npK7/6zn9DsALV+uLdm1y+jEeRkLyamqJCagc
         yrAeUEW+7we2AM+29eu48ERkdqZ95PDtByAJRErIsxqiR78nyLS+ovhJbEC/Pce+GYX4
         ydV5jhrsk4vFiHvfr+Z9A7jEA3+YYSK0Gvi0ykfisLjy+0qwWSPvUARbyh/VXnSo4Eg0
         nIbg==
X-Gm-Message-State: APjAAAUkvcKhwGRU3gBWupl4/UMWo1lzPEAF7iB5EiiYDqfOWQmdnol1
        lskbK8u5Nbem+kNo7v5lnNilbQ==
X-Google-Smtp-Source: APXvYqy6meWowRQMg40hWZZjjAJBuSb2HaYYpIb+AwAgullVd1ZnmDwHZoNUBj1FpoAe00C7IEGKvw==
X-Received: by 2002:a17:902:29a7:: with SMTP id h36mr39298958plb.158.1560482011111;
        Thu, 13 Jun 2019 20:13:31 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id x7sm1024288pfm.82.2019.06.13.20.13.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:30 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 37/45] arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP hardening support
Date:   Fri, 14 Jun 2019 08:38:20 +0530
Message-Id: <e79f92083760ecd32cd521e29a3d9d3227737ff2.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 6167ec5c9145cdf493722dfd80a5d48bafc4a18a upstream.

A new feature of SMCCC 1.1 is that it offers firmware-based CPU
workarounds. In particular, SMCCC_ARCH_WORKAROUND_1 provides
BP hardening for CVE-2017-5715.

If the host has some mitigation for this issue, report that
we deal with it using SMCCC_ARCH_WORKAROUND_1, as we apply the
host workaround on every guest exit.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: account for files moved to virt/ upstream ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   | 6 ++++++
 arch/arm/kvm/psci.c               | 9 ++++++++-
 arch/arm64/include/asm/kvm_host.h | 5 +++++
 include/linux/arm-smccc.h         | 5 +++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 6692982c9b57..2009894d9a8a 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -237,4 +237,10 @@ static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
 
+static inline bool kvm_arm_harden_branch_predictor(void)
+{
+	/* No way to detect it yet, pretend it is not there. */
+	return false;
+}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 9abf40734723..747319490268 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -403,13 +403,20 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
 	u32 val = PSCI_RET_NOT_SUPPORTED;
+	u32 feature;
 
 	switch (func_id) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		val = ARM_SMCCC_VERSION_1_1;
 		break;
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
-		/* Nothing supported yet */
+		feature = smccc_get_arg1(vcpu);
+		switch(feature) {
+		case ARM_SMCCC_ARCH_WORKAROUND_1:
+			if (kvm_arm_harden_branch_predictor())
+				val = 0;
+			break;
+		}
 		break;
 	default:
 		return kvm_psci_call(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a35ce7266aac..aca3a7e28777 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -258,4 +258,9 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
 
+static inline bool kvm_arm_harden_branch_predictor(void)
+{
+	return cpus_have_cap(ARM64_HARDEN_BRANCH_PREDICTOR);
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index da9f3916f9a9..1f02e4045a9e 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -73,6 +73,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 1)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_1					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x8000)
+
 #ifndef __ASSEMBLY__
 
 /**
-- 
2.21.0.rc0.269.g1a574e7a288b

