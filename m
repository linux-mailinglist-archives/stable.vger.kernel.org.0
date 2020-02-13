Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D469C15C748
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgBMQI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgBMPW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:56 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E17D424693;
        Thu, 13 Feb 2020 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607376;
        bh=+V6wOVz7zFBfof8YKwW0BDDWKuDOOzIDKz838KA5wws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14XfUr8cTA6hDVHOawNBWvb7ODhFb9OSXbe7zxxL/KUALD0ONxXaYkuw5LotvzPgO
         oF5vWHIFaEgT3l+ZwGMnwtbooUs6WCwheLG3vKvRq5bb7ls3o3HLsIqhXihR4gH+sT
         s/xFesZNEsuCGpHMur7eFFLTURmy6WhNnsryD1ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Finco <nifi@google.com>,
        Marios Pomonis <pomonis@google.com>,
        Andrew Honig <ahonig@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 70/91] KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks
Date:   Thu, 13 Feb 2020 07:20:27 -0800
Message-Id: <20200213151849.342756999@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Pomonis <pomonis@google.com>

[ Upstream commit 66061740f1a487f4ed54fde75e724709f805da53 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu_intel.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu_intel.c b/arch/x86/kvm/pmu_intel.c
index 8fc07ea23344e..822829f005902 100644
--- a/arch/x86/kvm/pmu_intel.c
+++ b/arch/x86/kvm/pmu_intel.c
@@ -87,10 +87,14 @@ static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 
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
 
 /* check if a PMC is enabled by comparising it with globl_ctrl bits. */
@@ -131,15 +135,19 @@ static struct kvm_pmc *intel_msr_idx_to_pmc(struct kvm_vcpu *vcpu,
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
-
-	return &counters[idx];
+	return &counters[array_index_nospec(idx, num_counters)];
 }
 
 static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
-- 
2.20.1



