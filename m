Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B4B522090
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 18:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244413AbiEJQIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 12:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347065AbiEJQFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 12:05:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8E33E5E1
        for <stable@vger.kernel.org>; Tue, 10 May 2022 08:58:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so2370179pjb.3
        for <stable@vger.kernel.org>; Tue, 10 May 2022 08:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q2u/bnbbl0Q/GQ62x/7qIcB9U4RVaqfJQxslmuTA+Lg=;
        b=KZSc9bU5KhxovsWIo7v5hajRwEmU3W5cbuYt+4+PzGu73Eynkta1JqzduNlJxhhUtO
         72xqLrtSykvFuwfEfYMpT+new0gcD71OTVPl+rhQrYzLxUMZ3ryYNEILJTv49MNYwv1v
         qJtrbmcU3+Uvp/cWCz04pZPvl0b8zs4zAlqVo8KJEG4iiR0tNmveM4npyTeG3Ap/p9Pz
         vamQQQpLDZ3wcrsiVYhPnJpAZCaFUX/pTXu5isK8FZul57OKzAAtuT+ktpMs3QQSLBnK
         jgWxCNbafoHe6GVvUv2QjRRiLnP05kP6gzcPDqV/y249OeAST/C7i/m487lG1xS7Th5p
         9dAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q2u/bnbbl0Q/GQ62x/7qIcB9U4RVaqfJQxslmuTA+Lg=;
        b=tmOXEVQVP2RN1y63AqAuahsLitzsAzklmR3dyihFRAynJ7rLtAdArODRWtGNQrK2hP
         TtkjnHOWNTqbpxWoh1TA6r2yuh7NfUYdHolDPfhbOUhLX1Yyk7eEJsmK2iVQ1mVrXK2m
         zu59qLT1VIYLobk5FLjbq2bDcPe4/vZPrr/06/fAjfnbeXhizuge97B5rQ/m8XJ1NymP
         0gyGomeMKO4M4Ip4zM0SNOMKV5cR8vRHzBKEq21c0p/GKFKCyIMoQn5Z4vAcwD5/qcMs
         iMU0WlG0I8p84De5Ndk7BX7OknETXANzEtFFII580RTQtpWa/PMj2hgN9/qzp36mUJkR
         uNrg==
X-Gm-Message-State: AOAM531PcNvGmhHXs4UFu1r4NyZFEAtbxqJi3SDB6TAawptpfRvT5xqK
        pD4oBLF31a3h6fitk7VnxenrYERHBDuJSg==
X-Google-Smtp-Source: ABdhPJzmQrNBi5IGCKYXDsJc4ESMWjQoZV+6UN9criamp/b8atW4OXxxaphUV0a3tGSIsezTTfat0w==
X-Received: by 2002:a17:90a:dd46:b0:1b8:8:7303 with SMTP id u6-20020a17090add4600b001b800087303mr604350pjv.197.1652198296408;
        Tue, 10 May 2022 08:58:16 -0700 (PDT)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902c1c400b0015e8d4eb237sm2257144plc.129.2022.05.10.08.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:58:15 -0700 (PDT)
From:   Kyle Huey <me@kylehuey.com>
X-Google-Original-From: Kyle Huey <khuey@kylehuey.com>
To:     stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.4] KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
Date:   Tue, 10 May 2022 08:58:14 -0700
Message-Id: <20220510155814.40457-1-khuey@kylehuey.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
[Backport to 5.4: kvm_x86_ops is a pointer here]
Signed-off-by: Kyle Huey <me@kylehuey.com>]
---
 arch/x86/kvm/pmu.c           | 8 +-------
 arch/x86/kvm/pmu.h           | 3 +--
 arch/x86/kvm/pmu_amd.c       | 8 ++++----
 arch/x86/kvm/vmx/pmu_intel.c | 9 +++++----
 4 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e0e3776059af..32561431acde 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -143,7 +143,6 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	unsigned config, type = PERF_TYPE_RAW;
-	u8 event_select, unit_mask;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	int i;
@@ -175,17 +174,12 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
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
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 3fc98afd72a8..b63859e340e4 100644
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
diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
index 6bc656abbe66..f843c6bbcd31 100644
--- a/arch/x86/kvm/pmu_amd.c
+++ b/arch/x86/kvm/pmu_amd.c
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
@@ -300,7 +300,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops = {
-	.find_arch_event = amd_find_arch_event,
+	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
 	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 181e352d38de..395566018ba9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -64,10 +64,11 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
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
@@ -374,7 +375,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops = {
-	.find_arch_event = intel_find_arch_event,
+	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
-- 
2.36.0

