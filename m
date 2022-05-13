Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1709526432
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378936AbiEMO1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380849AbiEMO1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:27:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD416161E;
        Fri, 13 May 2022 07:27:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E358CB82F64;
        Fri, 13 May 2022 14:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F28C34100;
        Fri, 13 May 2022 14:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452033;
        bh=9uh8S6c2FeFDM/PNy1MSw1czMlOtY7INGH7Ku6JDXN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehxAFX2XFcwMTYYe2fUxRuF5+5q+GrAF0Zn1MQ6s4wxOeKKzq2uv42hMX++S1bU1F
         OgJhd1fNFh81aQsbUiPLW63OiPOBeR9eMspcqDhtcTwGcZM30zg3gGpfjiW9774/gv
         wLpOAe/MyQ7qJae737dg6g7Y7GmFSQKDIjYo/IHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.4 09/18] KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
Date:   Fri, 13 May 2022 16:23:35 +0200
Message-Id: <20220513142229.427408031@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
References: <20220513142229.153291230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

commit 7c174f305cbee6bdba5018aae02b84369e7ab995 upstream.

The find_arch_event() returns a "unsigned int" value,
which is used by the pmc_reprogram_counter() to
program a PERF_TYPE_HARDWARE type perf_event.

The returned value is actually the kernel defined generic
perf_hw_id, let's rename it to pmc_perf_hw_id() with simpler
incoming parameters for better self-explanation.

Signed-off-by: Like Xu <likexu@tencent.com>
Message-Id: <20211130074221.93635-3-likexu@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[Backport to 5.4: kvm_x86_ops is a pointer here]
Signed-off-by: Kyle Huey <me@kylehuey.com>]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/pmu.c           |    8 +-------
 arch/x86/kvm/pmu.h           |    3 +--
 arch/x86/kvm/pmu_amd.c       |    8 ++++----
 arch/x86/kvm/vmx/pmu_intel.c |    9 +++++----
 4 files changed, 11 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -143,7 +143,6 @@ static void pmc_reprogram_counter(struct
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	unsigned config, type = PERF_TYPE_RAW;
-	u8 event_select, unit_mask;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	int i;
@@ -175,17 +174,12 @@ void reprogram_gp_counter(struct kvm_pmc
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
-		config = kvm_x86_ops->pmu_ops->find_arch_event(pmc_to_pmu(pmc),
-						      event_select,
-						      unit_mask);
+		config = kvm_x86_ops->pmu_ops->pmc_perf_hw_id(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -22,8 +22,7 @@ struct kvm_event_hw_type_mapping {
 };
 
 struct kvm_pmu_ops {
-	unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
-				    u8 unit_mask);
+	unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
 	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
@@ -126,10 +126,10 @@ static inline struct kvm_pmc *get_gp_pmc
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
@@ -300,7 +300,7 @@ static void amd_pmu_reset(struct kvm_vcp
 }
 
 struct kvm_pmu_ops amd_pmu_ops = {
-	.find_arch_event = amd_find_arch_event,
+	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
 	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -64,10 +64,11 @@ static void global_ctrl_changed(struct k
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
@@ -374,7 +375,7 @@ static void intel_pmu_reset(struct kvm_v
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
-	.find_arch_event = intel_find_arch_event,
+	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,


