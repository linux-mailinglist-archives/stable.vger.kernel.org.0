Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17B595132
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbiHPEwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiHPEvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:51:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610D619F4BC;
        Mon, 15 Aug 2022 13:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD7FEB8113E;
        Mon, 15 Aug 2022 20:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A0EC433C1;
        Mon, 15 Aug 2022 20:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596522;
        bh=dKpsUjoQlrAZnpBF4F5UQj6kOe4rpK9ydyr0Zx2ZhH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsW6wLjmW30STG5vqXQ/JqVllgYvIjwAqaQICSN3ihNI5+OYLg3zpMmN4606vF9wk
         P4FLtWGAI35C50N1gEIELDqm89ZhDPBd+XpUxw42hNK4Y80T8pDstRRwpPP8i6vIe6
         BfvPds98H1YcaZZdmDVLzW6f3eGKc5S7q3wkotqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1106/1157] Revert "KVM: x86/pmu: Accept 0 for absent PMU MSRs when host-initiated if !enable_pmu"
Date:   Mon, 15 Aug 2022 20:07:42 +0200
Message-Id: <20220815180524.516213846@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 5d4283df5a0fc8299fba9443c33d219939eccc2d ]

Eating reads and writes to all "PMU" MSRs when there is no PMU is wildly
broken as it results in allowing accesses to _any_ MSR on Intel CPUs
as intel_is_valid_msr() returns true for all host_initiated accesses.

A revert of commit d1c88a402056 ("KVM: x86: always allow host-initiated
writes to PMU MSRs") will soon follow.

This reverts commit 8e6a58e28b34e8d247e772159b8fa8f6bae39192.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220611005755.753273-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c     |  8 --------
 arch/x86/kvm/svm/pmu.c | 11 +----------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2334ddfbbab2..3f868fed9114 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -433,19 +433,11 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	if (msr_info->host_initiated && !vcpu->kvm->arch.enable_pmu) {
-		msr_info->data = 0;
-		return 0;
-	}
-
 	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	if (msr_info->host_initiated && !vcpu->kvm->arch.enable_pmu)
-		return !!msr_info->data;
-
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
 	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
 }
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index d93ecb25fe17..136039fc6d01 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -232,16 +232,7 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
 	/* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
-	if (!host_initiated)
-		return false;
-
-	switch (msr) {
-	case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
-	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		return true;
-	default:
-		return false;
-	}
+	return false;
 }
 
 static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
-- 
2.35.1



