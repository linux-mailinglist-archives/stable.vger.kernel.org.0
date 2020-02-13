Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3705B15C17E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgBMPXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:23:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgBMPXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:42 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56766246B1;
        Thu, 13 Feb 2020 15:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607421;
        bh=KrcVLInCN6Z6I+BQc3e5clvvexlfxB1Z7e9YlM3aRaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QgPY017yJedAHVGOa8y9ef1aq6LbYK75vKPRc1v8VbWjJSgJrgk1dVj8O1XLFCOH
         2sjkSB9q/vG9p03e2GvVrvIKm55i3mXD2ibh6KVM25HscFHaEzmI5RTitGMRZA0XTC
         6AovM7jBmYwZt2N4rw/JGHI8c8kzlQ6JYqZNoKGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 049/116] KVM: x86: Protect MSR-based index computations in pmu.h from Spectre-v1/L1TF attacks
Date:   Thu, 13 Feb 2020 07:19:53 -0800
Message-Id: <20200213151901.759623681@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
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
@@ -1,6 +1,8 @@
 #ifndef __KVM_X86_PMU_H
 #define __KVM_X86_PMU_H
 
+#include <linux/nospec.h>
+
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
@@ -80,8 +82,12 @@ static inline bool pmc_is_enabled(struct
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
@@ -91,8 +97,12 @@ static inline struct kvm_pmc *get_fixed_
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


