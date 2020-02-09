Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB66156A7C
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgBINHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:07:24 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44191 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:07:23 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D638521EA0;
        Sun,  9 Feb 2020 08:07:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:07:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2qCdUb
        baPp5NGhjR3YeKVSyl3Z2layUM1mvuNWCDCwE=; b=Nzr9c9H9hQJUV+0LBrMzWE
        opJqjLmfmul1Yqnn1OeliIAMOGw4UYjtstpXmAD30vFTLERINGdbGIgA9vbSlSkN
        8DzsaBfXsq7lTqyjDORA7Ft+Y+0E/jxms95D+hOWw+IsZ8HARGrLS4Z5VLOujv2s
        aOjg1joJ0zM4SoJ6PbXm+vROZmKgPQAejmYIV39u696MKJgnxX2BsoY9ktegdTwM
        yz328N4BaDDbVE8LYNMY8//zTwZ5GOmki93YSMsHz8RxnTPkOJ8fyXmTqssjaGdB
        R4wWPBGhOXOxVDfRPN/5sB3STya3NH2ux0meVtUk6zjQ/cU5Yvo3LJG63996B/mw
        ==
X-ME-Sender: <xms:CgRAXqlCEoPvyNUhWSVpKE6U6PXGsWDkbz2vnSWyR1KFz68RafEZkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepuddtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:CgRAXkLO2ORgnX1kRX-BcqqqD4vzzmgDoE_olDOtO-6lAUNK6RBVhg>
    <xmx:CgRAXnZFIsdWw1dD7Bej91n9EFM7JTK-qT-xx__h7ktCdzzHOAxwqg>
    <xmx:CgRAXowDV_q0sAvQ-EXZg5hWG_-pZR1EY3BVKl_Yz4DDGbsPpMGTew>
    <xmx:CgRAXtMNlg1O8n1iah4jB9o0xxERlr2avCnJUtC9HR1wcXsJzBfsKg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4865A328005A;
        Sun,  9 Feb 2020 08:07:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks" failed to apply to 4.9-stable tree
To:     pomonis@google.com, ahonig@google.com, jmattson@google.com,
        nifi@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:56:11 +0100
Message-ID: <1581249371155199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 66061740f1a487f4ed54fde75e724709f805da53 Mon Sep 17 00:00:00 2001
From: Marios Pomonis <pomonis@google.com>
Date: Wed, 11 Dec 2019 12:47:53 -0800
Subject: [PATCH] KVM: x86: Protect pmu_intel.c from Spectre-v1/L1TF attacks

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

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7023138b1cb0..34a3a17bb6d7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -86,10 +86,14 @@ static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 
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
@@ -130,16 +134,20 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
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

