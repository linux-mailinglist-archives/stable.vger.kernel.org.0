Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533604BE0A3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiBUJNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:13:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349537AbiBUJMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:12:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95EC2C645;
        Mon, 21 Feb 2022 01:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B087CE0E7C;
        Mon, 21 Feb 2022 09:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA43CC340E9;
        Mon, 21 Feb 2022 09:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434323;
        bh=2gClyzrWK6NT1eMjFKpuvNZ4b5dSQKJ35HjkRtsKoX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ew083B+OvD5n8dNwsy6Bohc864Qi/r6SCZa2TS02BYNI4Rqxk3Er3FOYK/A12par/
         6AA0p5i79YkJdxakk7M+dwrhZ9/nUBxdJD2GP1QiQGulRCm35ROZPW2opg3WteUgtj
         +rCaf6Ur52SUgIAtaOY/eHFBO7SYrbOnnQnI0p1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/121] KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
Date:   Mon, 21 Feb 2022 09:49:40 +0100
Message-Id: <20220221084924.183045969@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Like Xu <likexu@tencent.com>

[ Upstream commit 7c174f305cbee6bdba5018aae02b84369e7ab995 ]

The find_arch_event() returns a "unsigned int" value,
which is used by the pmc_reprogram_counter() to
program a PERF_TYPE_HARDWARE type perf_event.

The returned value is actually the kernel defined generic
perf_hw_id, let's rename it to pmc_perf_hw_id() with simpler
incoming parameters for better self-explanation.

Signed-off-by: Like Xu <likexu@tencent.com>
Message-Id: <20211130074221.93635-3-likexu@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c           | 8 +-------
 arch/x86/kvm/pmu.h           | 3 +--
 arch/x86/kvm/svm/pmu.c       | 8 ++++----
 arch/x86/kvm/vmx/pmu_intel.c | 9 +++++----
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 67741d2a03085..20092a56de8b0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -171,7 +171,6 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	unsigned config, type = PERF_TYPE_RAW;
-	u8 event_select, unit_mask;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	int i;
@@ -203,17 +202,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	if (!allow_event)
 		return;
 
-	event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
-	unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
-
 	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
 			  ARCH_PERFMON_EVENTSEL_INV |
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
 			  HSW_IN_TX_CHECKPOINTED))) {
-		config = kvm_x86_ops.pmu_ops->find_arch_event(pmc_to_pmu(pmc),
-						      event_select,
-						      unit_mask);
+		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 067fef51760c4..1a44e29e73330 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -24,8 +24,7 @@ struct kvm_event_hw_type_mapping {
 };
 
 struct kvm_pmu_ops {
-	unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
-				    u8 unit_mask);
+	unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
 	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 5a5c165a30ed1..4e7093bcb64b6 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -126,10 +126,10 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return &pmu->gp_counters[msr_to_index(msr)];
 }
 
-static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
-				    u8 event_select,
-				    u8 unit_mask)
+static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
+	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
+	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
@@ -312,7 +312,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops = {
-	.find_arch_event = amd_find_arch_event,
+	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
 	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index cdf5f34518f43..bd70c1d7f3458 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,10 +68,11 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 		reprogram_counter(pmu, bit);
 }
 
-static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
-				      u8 event_select,
-				      u8 unit_mask)
+static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
+	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
@@ -432,7 +433,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
-	.find_arch_event = intel_find_arch_event,
+	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
-- 
2.34.1



