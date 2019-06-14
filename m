Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C3E4528D
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfFNDNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:13:48 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36321 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfFNDNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:13:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id f21so684046pgi.3
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wEbgFQxZMC6fJD33Waf3N1W37Y6IiBDcFwhvI4lbj2Y=;
        b=va81nY0feP5sEouud+fj3TpaKzUjL4h3DIk3Y1b7M7OpENMdls4SqZdkdcWM/bFwol
         cxLfuDhb8rkZnov7C4WnONY4NIS2iZUBmdJzyIrOrMeA8QXLsS/GNl/dISGjNzpzu0hr
         8Xed6r894iT+aS9xp9BCfqgPhVD1T7k2rfUpWPmiPaash2i7Met8Cq76UosREyYjEd6R
         HHdrf8pcUZTbcAAWlUUZMbroQmy4mG2l8UQL1tgi0ueNXZIEclvhTKHT6Qx4knFveG2z
         KvhvLxkLMx7Fj5bYA1GNt/z9CvXFc2HOZ2mmqgFacovro8YrIE3TS5VD1JMmuLw7tlo+
         fHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wEbgFQxZMC6fJD33Waf3N1W37Y6IiBDcFwhvI4lbj2Y=;
        b=YMmP06tP5aNU4809MKENBXQ37Z8Yn6Is98TQ/UquwD09vL3/mXoJrm+y2uVW9e0wkP
         ye+3QPZCBbMIiaFe1AXsYDBHFkWAAAQfc0qRqlbT1tEf/4qQP6lXidKEHybvp1Ji3vhn
         GEsjuX+9Tyf1iPA2NzRPYGmAOxKyZmmMp0qo+nW9dEGTKC+mS0VwxGeTlbznN4iO4RlV
         vEuzLnkFEXrGJdtsqoUV3/PSKI29Jbfs8eRHKwFCUxcYPaLhUNENkGIOlDtMNBL36pZL
         UB/CELeoKtlRG4Vz+e16+PXxEhzQ6i1pqOfSMAH0Asx2VjpTvKZuMFmiyVwCIoB2XIW4
         FxPA==
X-Gm-Message-State: APjAAAWXQZksFMl/60t8TbL4YeE2W6Zxb5m508y7F7sm0evkuZrTQlQr
        IE13q9gk8HiCoMl/Khie3JumqA==
X-Google-Smtp-Source: APXvYqwIjeVWHz26eKFF+ExDvKi2FzjZR9grd3zdwzhujp4QoPdneyQPL2SR38XuS//1pfVyaddkMA==
X-Received: by 2002:a65:4209:: with SMTP id c9mr34466210pgq.111.1560482026653;
        Thu, 13 Jun 2019 20:13:46 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id 188sm1042980pfg.11.2019.06.13.20.13.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:13:46 -0700 (PDT)
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
Subject: [PATCH v4.4 43/45] arm64: Add ARM_SMCCC_ARCH_WORKAROUND_1 BP hardening support
Date:   Fri, 14 Jun 2019 08:38:26 +0530
Message-Id: <fb796e62a7a8f596b2ef1b81c07aefe53245708f.1560480942.git.viresh.kumar@linaro.org>
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

commit b092201e0020614127f495c092e0a12d26a2116e upstream.

Add the detection and runtime code for ARM_SMCCC_ARCH_WORKAROUND_1.
It is lovely. Really.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kernel/bpi.S        | 20 ++++++++++
 arch/arm64/kernel/cpu_errata.c | 68 +++++++++++++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index dec95bd82e31..c72f261f4b64 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -17,6 +17,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/arm-smccc.h>
 
 .macro ventry target
 	.rept 31
@@ -77,3 +78,22 @@ ENTRY(__psci_hyp_bp_inval_start)
 	ldp	x0, x1, [sp, #(16 * 8)]
 	add	sp, sp, #(8 * 18)
 ENTRY(__psci_hyp_bp_inval_end)
+
+.macro smccc_workaround_1 inst
+	sub	sp, sp, #(8 * 4)
+	stp	x2, x3, [sp, #(8 * 0)]
+	stp	x0, x1, [sp, #(8 * 2)]
+	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_1
+	\inst	#0
+	ldp	x2, x3, [sp, #(8 * 0)]
+	ldp	x0, x1, [sp, #(8 * 2)]
+	add	sp, sp, #(8 * 4)
+.endm
+
+ENTRY(__smccc_workaround_1_smc_start)
+	smccc_workaround_1	smc
+ENTRY(__smccc_workaround_1_smc_end)
+
+ENTRY(__smccc_workaround_1_hvc_start)
+	smccc_workaround_1	hvc
+ENTRY(__smccc_workaround_1_hvc_end)
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index da861bf24780..506b339b91bb 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -51,6 +51,10 @@ DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 #ifdef CONFIG_KVM
 extern char __psci_hyp_bp_inval_start[], __psci_hyp_bp_inval_end[];
+extern char __smccc_workaround_1_smc_start[];
+extern char __smccc_workaround_1_smc_end[];
+extern char __smccc_workaround_1_hvc_start[];
+extern char __smccc_workaround_1_hvc_end[];
 
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
@@ -95,6 +99,10 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 #else
 #define __psci_hyp_bp_inval_start	NULL
 #define __psci_hyp_bp_inval_end		NULL
+#define __smccc_workaround_1_smc_start		NULL
+#define __smccc_workaround_1_smc_end		NULL
+#define __smccc_workaround_1_hvc_start		NULL
+#define __smccc_workaround_1_hvc_end		NULL
 
 static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
@@ -121,17 +129,75 @@ static void  install_bp_hardening_cb(const struct arm64_cpu_capabilities *entry,
 	__install_bp_hardening_cb(fn, hyp_vecs_start, hyp_vecs_end);
 }
 
+#include <uapi/linux/psci.h>
+#include <linux/arm-smccc.h>
 #include <linux/psci.h>
 
+static void call_smc_arch_workaround_1(void)
+{
+	arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
+}
+
+static void call_hvc_arch_workaround_1(void)
+{
+	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
+}
+
+static bool check_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
+{
+	bp_hardening_cb_t cb;
+	void *smccc_start, *smccc_end;
+	struct arm_smccc_res res;
+
+	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
+		return false;
+
+	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
+		return false;
+
+	switch (psci_ops.conduit) {
+	case PSCI_CONDUIT_HVC:
+		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+		if (res.a0)
+			return false;
+		cb = call_hvc_arch_workaround_1;
+		smccc_start = __smccc_workaround_1_hvc_start;
+		smccc_end = __smccc_workaround_1_hvc_end;
+		break;
+
+	case PSCI_CONDUIT_SMC:
+		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+		if (res.a0)
+			return false;
+		cb = call_smc_arch_workaround_1;
+		smccc_start = __smccc_workaround_1_smc_start;
+		smccc_end = __smccc_workaround_1_smc_end;
+		break;
+
+	default:
+		return false;
+	}
+
+	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);
+
+	return true;
+}
+
 static int enable_psci_bp_hardening(void *data)
 {
 	const struct arm64_cpu_capabilities *entry = data;
 
-	if (psci_ops.get_version)
+	if (psci_ops.get_version) {
+		if (check_smccc_arch_workaround_1(entry))
+			return 0;
+
 		install_bp_hardening_cb(entry,
 				       (bp_hardening_cb_t)psci_ops.get_version,
 				       __psci_hyp_bp_inval_start,
 				       __psci_hyp_bp_inval_end);
+	}
 
 	return 0;
 }
-- 
2.21.0.rc0.269.g1a574e7a288b

