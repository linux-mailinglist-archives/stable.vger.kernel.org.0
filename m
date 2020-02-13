Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECD915C5E0
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgBMPZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:25:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728102AbgBMPZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:19 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAEC224691;
        Thu, 13 Feb 2020 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607519;
        bh=OSlvVw44Qhx2hrQj100qel0ozOsHwi4Z0gCH3uBz36o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hcybp1jL271orjjhakLuRfK63fcBgQsri/9PExhm7cH0UE8+J/DoMex+22n3j1ETG
         zqlWc+PDDXY3fSQHpxlUAZ2saH9xxW9drOlv8FbaBJnhcbUhpYlehGQIXNscus8Osa
         tzKBxdA9dmZAi2xvNx5I83suJlCgRRhJioRaVR8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 084/173] KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-v1/L1TF attacks
Date:   Thu, 13 Feb 2020 07:19:47 -0800
Message-Id: <20200213151954.513237244@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

commit 13c5183a4e643cc2b03a22d0e582c8e17bb7457d upstream.

This fixes a Spectre-v1/L1TF vulnerability in the get_gp_pmc() and
get_fixed_pmc() functions.
They both contain index computations based on the (attacker-controlled)
MSR number.

Fixes: 25462f7f5295 ("KVM: x86/vPMU: Define kvm_pmu_ops to support vPMU function dispatch")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/pmu.h |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -2,6 +2,8 @@
 #ifndef __KVM_X86_PMU_H
 #define __KVM_X86_PMU_H
 
+#include <linux/nospec.h>
+
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
@@ -81,8 +83,12 @@ static inline bool pmc_is_enabled(struct
 static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 					 u32 base)
 {
-	if (msr >= base && msr < base + pmu->nr_arch_gp_counters)
-		return &pmu->gp_counters[msr - base];
+	if (msr >= base && msr < base + pmu->nr_arch_gp_counters) {
+		u32 index = array_index_nospec(msr - base,
+					       pmu->nr_arch_gp_counters);
+
+		return &pmu->gp_counters[index];
+	}
 
 	return NULL;
 }
@@ -92,8 +98,12 @@ static inline struct kvm_pmc *get_fixed_
 {
 	int base = MSR_CORE_PERF_FIXED_CTR0;
 
-	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters)
-		return &pmu->fixed_counters[msr - base];
+	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
+		u32 index = array_index_nospec(msr - base,
+					       pmu->nr_arch_fixed_counters);
+
+		return &pmu->fixed_counters[index];
+	}
 
 	return NULL;
 }


