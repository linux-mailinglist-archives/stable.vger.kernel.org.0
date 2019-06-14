Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9273945285
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfFNDN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:29 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46323 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDN3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:29 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so362564pls.13
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ciH+Cy/cnjaV+iKRh72NhJx15MiI+P9rVJovcPRWoV0=;
        b=zCj6UOkk9rYxjGZ76Celb+F4P6OxrLaT+sclkYVehSDNSu0d3hzajx04mK0DZZfSEQ
         vDvFo25Jg/ib3RMKhnrEqeIxgYSGrX2tKBBxSJNNc9SOelWDPYolRRdEBqvLnhUACalH
         11zfuSBeyOZyNrXcL3xld8rwkwpKoT6a2T6EmzQVJl+EwwwOxYfhPdZ4fmL2CZ3Esq4s
         sr1vf56kZhY7Rp1oXoB39fzJ/m0MdsABjb3Q+rlB5RXEKVJuv+ELEZnSmXPtr96D2lgI
         qflaeiBy5vRwtZhLlfqThBj3abiDuudnqZ5WLGRPoDpWYiMlTytnrqxuB1FQrL0LFBRw
         UvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ciH+Cy/cnjaV+iKRh72NhJx15MiI+P9rVJovcPRWoV0=;
        b=Ri+9snRT55L6U8567aR0qGNdTkuF3ZY6GiyXmduADv5aJNm+RNBIFRjglMxAhwBt+r
         aaCzplnfpDYdU9BoM4/zpL0NDwAO99EhJGJAOyz0tQmP+j23dwxLWlxqxQOJhWyDdIKy
         IRfa2qdr2z6nhyegr06+oE8KgpF4k53cO7CrATlm/ow4Hy7XQ2FSwOeuIprxo+PSSmxj
         Hzddwt1V1VekMpGa//o/fWpXYg42NoHwvFDxnlxOkCUh/EOXII1xctv3F9nJedlykiuB
         AgjQluBuVUfXJP9jXij44XSltyFQLMBDFJhsmtZ/7RnuPN0gRc18OOryhDnZMQyAkqtb
         nvqA==
X-Gm-Message-State: APjAAAWkfnoAA/D9CWf6XkNUIxQ5VSP34/1GgLo95cNnLkW7u/UdfvyP
        bfjkPpXUqFtfXR5MMv91ErHYxw==
X-Google-Smtp-Source: APXvYqzdSrwX7zpx4mVVNZDCkgcqlYmaMymBCeJxs0WBFABZ+RRjkEeu1ROtPUwmdF1tTRVtN5gq8g==
X-Received: by 2002:a17:902:54d:: with SMTP id 71mr88735600plf.140.1560482008787;
        Thu, 13 Jun 2019 20:13:28 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id n7sm1105325pff.59.2019.06.13.20.13.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:28 -0700 (PDT)
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
Subject: [PATCH v4.4 36/45] arm/arm64: KVM: Turn kvm_psci_version into a static inline
Date:   Fri, 14 Jun 2019 08:38:19 +0530
Message-Id: <2ea4ac93fe2fdb5faad8e80347747673cb89d93e.1560480942.git.viresh.kumar@linaro.org>
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

commit a4097b351118e821841941a79ec77d3ce3f1c5d9 upstream.

We're about to need kvm_psci_version in HYP too. So let's turn it
into a static inline, and pass the kvm structure as a second
parameter (so that HYP can do a kern_hyp_va on it).

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: account for files moved to virt/ upstream and drop switch.c
	changes ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kvm/psci.c    | 12 ++----------
 include/kvm/arm_psci.h | 21 ++++++++++++++++++++-
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 76821adf4fde..9abf40734723 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -120,7 +120,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
 	if (!vcpu->arch.power_off) {
-		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
+		if (kvm_psci_version(source_vcpu, kvm) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
 			return PSCI_RET_INVALID_PARAMS;
@@ -230,14 +230,6 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
 }
 
-int kvm_psci_version(struct kvm_vcpu *vcpu)
-{
-	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features))
-		return KVM_ARM_PSCI_LATEST;
-
-	return KVM_ARM_PSCI_0_1;
-}
-
 static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -395,7 +387,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  */
 static int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
-	switch (kvm_psci_version(vcpu)) {
+	switch (kvm_psci_version(vcpu, vcpu->kvm)) {
 	case KVM_ARM_PSCI_1_0:
 		return kvm_psci_1_0_call(vcpu);
 	case KVM_ARM_PSCI_0_2:
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index ed1dd8088f1c..e518e4e3dfb5 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -18,6 +18,7 @@
 #ifndef __KVM_ARM_PSCI_H__
 #define __KVM_ARM_PSCI_H__
 
+#include <linux/kvm_host.h>
 #include <uapi/linux/psci.h>
 
 #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
@@ -26,7 +27,25 @@
 
 #define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
 
-int kvm_psci_version(struct kvm_vcpu *vcpu);
+/*
+ * We need the KVM pointer independently from the vcpu as we can call
+ * this from HYP, and need to apply kern_hyp_va on it...
+ */
+static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
+{
+	/*
+	 * Our PSCI implementation stays the same across versions from
+	 * v0.2 onward, only adding the few mandatory functions (such
+	 * as FEATURES with 1.0) that are required by newer
+	 * revisions. It is thus safe to return the latest.
+	 */
+	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features))
+		return KVM_ARM_PSCI_LATEST;
+
+	return KVM_ARM_PSCI_0_1;
+}
+
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_ARM_PSCI_H__ */
-- 
2.21.0.rc0.269.g1a574e7a288b

