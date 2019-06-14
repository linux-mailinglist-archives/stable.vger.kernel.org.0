Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDC145283
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfFNDNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:25 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34885 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id d126so503961pfd.2
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4cjUvWF1fG1uJf64DV9LIZ2qblEK4Qh4cwDlO2OXHlc=;
        b=sFWQWr9WQVIoODnq13osUci8fXXwEGt2JIkyrqUTrbBm4bd7VB/u8y0UxppVd+BeiR
         UtJXoGi1ehpyDUqs0e+ubar9YWT057q4MMJ/bKxw+xgLk1CyMMDO7hhq1T1pBX5UmLjs
         B5rQdnQ1JEvgyyBHk/Gy2qptGPg2I94HqYxOjVeSouPZN5f/0YJc8VbqPpFuDDEwW3Lt
         aQBgpKRwEs98T1ALDuHy0H2ZWiKHpgj0p91BRIyGEptiEu7RGwz9vWTkk6cvMhx/7lzq
         lBYMXv4P2NwEPJa9GKD61+FgGjo/iIZK/QRSGYBghxS5ZCiizlV5quX9rJ+mM5Fkq6M+
         e5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4cjUvWF1fG1uJf64DV9LIZ2qblEK4Qh4cwDlO2OXHlc=;
        b=ZJrDPzYSB+izyqsOUlKSqeh6AFSI/6IT7BTbEDlDo73GW+fOkHulzHZCcyyW9ydfCq
         IUJhGenpfVqqVxgwMIYuRT9U0c862mMoLJi2X8ywpWklbtdY1vG4XRKHaPEAm7H+K3Bw
         q9fH4dzXlKOuqw3YGh/LwsfsrdmpFL0FuRP6adbsPCLjPV2k4MhVetV8PLYTYLvadZNU
         zT8VoThUavVPu3dAr3hmYzpldvLU5Qap+7n0tToBtoC7rBX/UpAd4oUBeAuve1MieUxJ
         ZVUSNFKWpzPpd8CLimNn3MDVOySw+rMhSFUFrlo+zN9N25OMEvy7x0VjTvPjg8hg0vTI
         WxOQ==
X-Gm-Message-State: APjAAAVKTVvK07rpkJxZGlkHCaXzsn/4pUA9N902G0TFNL1woBJ/Pmx0
        3knUlEC6VKQGIF+OuImREdGgFg==
X-Google-Smtp-Source: APXvYqzlH0OcxsgdIzwPZqpnKGrcfCU430u+ms0DTeK9I3s4ge2lcX/vcnViYs4es5GBTSoBrl9MOA==
X-Received: by 2002:a63:f146:: with SMTP id o6mr32948616pgk.179.1560482003778;
        Thu, 13 Jun 2019 20:13:23 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id m2sm1083791pgq.48.2019.06.13.20.13.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:23 -0700 (PDT)
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
Subject: [PATCH v4.4 34/45] arm/arm64: KVM: Implement PSCI 1.0 support
Date:   Fri, 14 Jun 2019 08:38:17 +0530
Message-Id: <673b7f2b7b85c228bf5136a273da7fc97d43c4d8.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 58e0b2239a4d997094ba63986ef4de29ddc91d87 upstream.

PSCI 1.0 can be trivially implemented by providing the FEATURES
call on top of PSCI 0.2 and returning 1.0 as the PSCI version.

We happily ignore everything else, as they are either optional or
are clarifications that do not require any additional change.

PSCI 1.0 is now the default until we decide to add a userspace
selection API.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: account for files moved to virt/ upstream ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kvm/psci.c    | 45 +++++++++++++++++++++++++++++++++++++++++-
 include/kvm/arm_psci.h |  3 +++
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 7ef6cdd22163..23428a3ac69b 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -232,7 +232,7 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 int kvm_psci_version(struct kvm_vcpu *vcpu)
 {
 	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features))
-		return KVM_ARM_PSCI_0_2;
+		return KVM_ARM_PSCI_LATEST;
 
 	return KVM_ARM_PSCI_0_1;
 }
@@ -311,6 +311,47 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
+{
+	u32 psci_fn = smccc_get_function(vcpu);
+	u32 feature;
+	unsigned long val;
+	int ret = 1;
+
+	switch(psci_fn) {
+	case PSCI_0_2_FN_PSCI_VERSION:
+		val = KVM_ARM_PSCI_1_0;
+		break;
+	case PSCI_1_0_FN_PSCI_FEATURES:
+		feature = smccc_get_arg1(vcpu);
+		switch(feature) {
+		case PSCI_0_2_FN_PSCI_VERSION:
+		case PSCI_0_2_FN_CPU_SUSPEND:
+		case PSCI_0_2_FN64_CPU_SUSPEND:
+		case PSCI_0_2_FN_CPU_OFF:
+		case PSCI_0_2_FN_CPU_ON:
+		case PSCI_0_2_FN64_CPU_ON:
+		case PSCI_0_2_FN_AFFINITY_INFO:
+		case PSCI_0_2_FN64_AFFINITY_INFO:
+		case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
+		case PSCI_0_2_FN_SYSTEM_OFF:
+		case PSCI_0_2_FN_SYSTEM_RESET:
+		case PSCI_1_0_FN_PSCI_FEATURES:
+			val = 0;
+			break;
+		default:
+			val = PSCI_RET_NOT_SUPPORTED;
+			break;
+		}
+		break;
+	default:
+		return kvm_psci_0_2_call(vcpu);
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return ret;
+}
+
 static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -353,6 +394,8 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
 	switch (kvm_psci_version(vcpu)) {
+	case KVM_ARM_PSCI_1_0:
+		return kvm_psci_1_0_call(vcpu);
 	case KVM_ARM_PSCI_0_2:
 		return kvm_psci_0_2_call(vcpu);
 	case KVM_ARM_PSCI_0_1:
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 5659343580a3..32360432cff5 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -22,6 +22,9 @@
 
 #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
 #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
+#define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
+
+#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
 
 int kvm_psci_version(struct kvm_vcpu *vcpu);
 int kvm_psci_call(struct kvm_vcpu *vcpu);
-- 
2.21.0.rc0.269.g1a574e7a288b

