Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492CB4BDEAC
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350182AbiBUJi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:38:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350644AbiBUJf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:35:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2AE2B1A5;
        Mon, 21 Feb 2022 01:14:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AA0F608C1;
        Mon, 21 Feb 2022 09:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C20C340E9;
        Mon, 21 Feb 2022 09:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434828;
        bh=XmAhL0NxdzEjNI/nq6TPD1t4LhAtneSZm+R8udFq9Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUt95btyn1rc/gcEW/buvGDCjh2c44zJJk592yHrmZIhMs9J8vip5delA0CxRD54q
         C9c9KBzmpGzo/ugeNAnyfDKoeT3xMEmV4lXnprJwkoSs8yI4geMkQFqCB1UAkDTvJD
         pwCM3LPoOlxpFHMgP1urQhzdFcJOF5PT/gXqUx6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/196] KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
Date:   Mon, 21 Feb 2022 09:49:36 +0100
Message-Id: <20220221084935.741289415@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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
index 0772bad9165c5..eec614de9af30 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -174,7 +174,6 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	unsigned config, type = PERF_TYPE_RAW;
-	u8 event_select, unit_mask;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	int i;
@@ -206,17 +205,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
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
index 0e4f2b1fa9fbd..a06d95165ac7c 100644
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
index e152241d1d709..06f8034f62e4f 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -134,10 +134,10 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
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
@@ -320,7 +320,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops = {
-	.find_arch_event = amd_find_arch_event,
+	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
 	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 10cc4f65c4efd..6427d95de01cf 100644
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
@@ -706,7 +707,7 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
-	.find_arch_event = intel_find_arch_event,
+	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
-- 
2.34.1



