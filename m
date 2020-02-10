Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DA115775A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgBJM7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729896AbgBJMlH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:07 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 472392051A;
        Mon, 10 Feb 2020 12:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338467;
        bh=MkI4Fn1ZQS+DuXc6JBCeYTPbMyJ9HcFdg6Ig2ScxoZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMN4pInGEIfBwrjcA9Ph5aX0KiMhfuuSbTEW8daBvI4uGnPF752RLA8BNRK16EfEE
         tswfTkvW2ltBT2ypqToBjeGmcNcJHipNp8iuHbva0fi2JO2j0bMNx/Mup7VjGULNDN
         cDTAV9TV0u2d0V6e+SgCemELdQVWCHv0fZaF3E4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 229/367] KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks
Date:   Mon, 10 Feb 2020 04:32:22 -0800
Message-Id: <20200210122445.484838003@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

commit 66061740f1a487f4ed54fde75e724709f805da53 upstream.

This fixes Spectre-v1/L1TF vulnerabilities in intel_find_fixed_event()
and intel_rdpmc_ecx_to_pmc().
kvm_rdpmc() (ancestor of intel_find_fixed_event()) and
reprogram_fixed_counter() (ancestor of intel_rdpmc_ecx_to_pmc()) are
exported symbols so KVM should treat them conservatively from a security
perspective.

Fixes: 25462f7f5295 ("KVM: x86/vPMU: Define kvm_pmu_ops to support vPMU function dispatch")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/pmu_intel.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -86,10 +86,14 @@ static unsigned intel_find_arch_event(st
 
 static unsigned intel_find_fixed_event(int idx)
 {
-	if (idx >= ARRAY_SIZE(fixed_pmc_events))
+	u32 event;
+	size_t size = ARRAY_SIZE(fixed_pmc_events);
+
+	if (idx >= size)
 		return PERF_COUNT_HW_MAX;
 
-	return intel_arch_events[fixed_pmc_events[idx]].event_type;
+	event = fixed_pmc_events[array_index_nospec(idx, size)];
+	return intel_arch_events[event].event_type;
 }
 
 /* check if a PMC is enabled by comparing it with globl_ctrl bits. */
@@ -130,16 +134,20 @@ static struct kvm_pmc *intel_rdpmc_ecx_t
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	bool fixed = idx & (1u << 30);
 	struct kvm_pmc *counters;
+	unsigned int num_counters;
 
 	idx &= ~(3u << 30);
-	if (!fixed && idx >= pmu->nr_arch_gp_counters)
-		return NULL;
-	if (fixed && idx >= pmu->nr_arch_fixed_counters)
+	if (fixed) {
+		counters = pmu->fixed_counters;
+		num_counters = pmu->nr_arch_fixed_counters;
+	} else {
+		counters = pmu->gp_counters;
+		num_counters = pmu->nr_arch_gp_counters;
+	}
+	if (idx >= num_counters)
 		return NULL;
-	counters = fixed ? pmu->fixed_counters : pmu->gp_counters;
 	*mask &= pmu->counter_bitmask[fixed ? KVM_PMC_FIXED : KVM_PMC_GP];
-
-	return &counters[idx];
+	return &counters[array_index_nospec(idx, num_counters)];
 }
 
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)


