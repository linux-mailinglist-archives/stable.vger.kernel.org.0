Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71B245284
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfFNDN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:27 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32878 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id k187so691002pga.0
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sZ9weVw7RciwPWpWURkguqz3JkcjVDFiI8eMy/XIk6c=;
        b=uBa2Fanuo5OuRV3Tc+G72E7OhAmFpiIcRgunKetzQ2vV71vpUsLFIRdJ32kyLSQ3WO
         Q+kphuNV5TIYTf+aDYD+RCwEOCs9NczgpuHExLd+SZH2SYkAKZK30z9qKogKCzJthNZC
         axQjLiaJ2+cZwfV+bisHNRsG/EUGLH+dP6wwhJ9rx6oWMB406wy4PCLUakdcHMfIXV0s
         BxAeBLVZCFSfFAfUTAVPeVWRt3AlXgDyDzUY3NfjptzjovgjtjgjAmrTPMgzgGtnx+c6
         I+tUU6ycag56hY11F7zYtJWDg8EV7SsOvXU3wHVqliUi/zAhJYqCn9qN76vINNwMd67x
         0vqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sZ9weVw7RciwPWpWURkguqz3JkcjVDFiI8eMy/XIk6c=;
        b=eDv5a2X8GFKwAA8rkV16JFi3hBHUH8yjqHYJKBe/lcHRzJELPPk5ykEFgk03XhK03B
         8DSBrgw295VFwcnJcz0g8D3qErhG4qMj7S+EytzjaOg+4P0NgIZVdBwgc81GOfegrCcY
         91l537771ARib/dAyvq1usRPBQ0VYP4oH5vkAloqc5Giaga+goGAB1igq6n4d2VPBzd0
         xCCn3dCkFYHjEEtxoIarLSM6NAb9g2erURn04gq4iIMVJRY+nMTT07Vov6JeZkBXwqRh
         9rLfFHuyFjlaK7x7WfA9+28jB4F2n0Yocdmt4CZV0jaZ5oLYEbI3O2d0NhG13R3JoNnn
         ZktQ==
X-Gm-Message-State: APjAAAVDyw9WNEFN9RJASkZcKAmA73EHcp+sG6/l7ULFK6eMDJIxV0RT
        9bjXV7vs/5OPJwcW36iiKQLEqw==
X-Google-Smtp-Source: APXvYqyYPUab+C9R03/M6n+YP6AiMroinpBIgD7kqj5kSKV2zeWlxKVc97dROufCbUh1cEm2BkfooA==
X-Received: by 2002:a17:90a:b294:: with SMTP id c20mr8922158pjr.16.1560482006464;
        Thu, 13 Jun 2019 20:13:26 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id e20sm1043011pfi.35.2019.06.13.20.13.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:25 -0700 (PDT)
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
Subject: [PATCH v4.4 35/45] arm/arm64: KVM: Advertise SMCCC v1.1
Date:   Fri, 14 Jun 2019 08:38:18 +0530
Message-Id: <cc0e289588de42a2938932929c3329e238ff19b8.1560480942.git.viresh.kumar@linaro.org>
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

commit 09e6be12effdb33bf7210c8867bbd213b66a499e upstream.

The new SMC Calling Convention (v1.1) allows for a reduced overhead
when calling into the firmware, and provides a new feature discovery
mechanism.

Make it visible to KVM guests.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: account for files moved to virt/ upstream ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/kvm/handle_exit.c   |  2 +-
 arch/arm/kvm/psci.c          | 24 +++++++++++++++++++++++-
 arch/arm64/kvm/handle_exit.c |  2 +-
 include/kvm/arm_psci.h       |  2 +-
 include/linux/arm-smccc.h    | 13 +++++++++++++
 5 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index ed879e3238d3..8d8daa2861f3 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -43,7 +43,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	trace_kvm_hvc(*vcpu_pc(vcpu), *vcpu_reg(vcpu, 0),
 		      kvm_vcpu_hvc_get_imm(vcpu));
 
-	ret = kvm_psci_call(vcpu);
+	ret = kvm_hvc_call_handler(vcpu);
 	if (ret < 0) {
 		vcpu_set_reg(vcpu, 0, ~0UL);
 		return 1;
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 23428a3ac69b..76821adf4fde 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -15,6 +15,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/preempt.h>
 #include <linux/kvm_host.h>
 #include <linux/wait.h>
@@ -337,6 +338,7 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 		case PSCI_0_2_FN_SYSTEM_OFF:
 		case PSCI_0_2_FN_SYSTEM_RESET:
 		case PSCI_1_0_FN_PSCI_FEATURES:
+		case ARM_SMCCC_VERSION_FUNC_ID:
 			val = 0;
 			break;
 		default:
@@ -391,7 +393,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  * Errors:
  * -EINVAL: Unrecognized PSCI function
  */
-int kvm_psci_call(struct kvm_vcpu *vcpu)
+static int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
 	switch (kvm_psci_version(vcpu)) {
 	case KVM_ARM_PSCI_1_0:
@@ -404,3 +406,23 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	};
 }
+
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
+{
+	u32 func_id = smccc_get_function(vcpu);
+	u32 val = PSCI_RET_NOT_SUPPORTED;
+
+	switch (func_id) {
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		val = ARM_SMCCC_VERSION_1_1;
+		break;
+	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+		/* Nothing supported yet */
+		break;
+	default:
+		return kvm_psci_call(vcpu);
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 5b7fb5ab9136..a5fa27980a1d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -43,7 +43,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
 			    kvm_vcpu_hvc_get_imm(vcpu));
 
-	ret = kvm_psci_call(vcpu);
+	ret = kvm_hvc_call_handler(vcpu);
 	if (ret < 0) {
 		vcpu_set_reg(vcpu, 0, ~0UL);
 		return 1;
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 32360432cff5..ed1dd8088f1c 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -27,6 +27,6 @@
 #define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
 
 int kvm_psci_version(struct kvm_vcpu *vcpu);
-int kvm_psci_call(struct kvm_vcpu *vcpu);
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_ARM_PSCI_H__ */
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 611d10580340..da9f3916f9a9 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -60,6 +60,19 @@
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
 #define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
 
+#define ARM_SMCCC_VERSION_1_0		0x10000
+#define ARM_SMCCC_VERSION_1_1		0x10001
+
+#define ARM_SMCCC_VERSION_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0)
+
+#define ARM_SMCCC_ARCH_FEATURES_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 1)
+
 #ifndef __ASSEMBLY__
 
 /**
-- 
2.21.0.rc0.269.g1a574e7a288b

