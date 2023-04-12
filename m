Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E9A6DEE5D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjDLIle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjDLIkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA3E769F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3C80628C0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A38C4339C;
        Wed, 12 Apr 2023 08:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288784;
        bh=SLYlc8abRYieo9u6Jl0a7c3ssDkoyHzz6d/ZQK6+epo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxlaX0UUDdcpRv9hSvw3eI97vW4JSuXRrfKJiyA/Ck11i4c/zYO1DN84dgVBQxdeI
         nHjgrizjTmk7SPtH3PR7kg2UDx6b1+YqNYkRHClq8I4YSbWEX4GD1vNMCLh8IQAzzV
         AiXwBI8g9sQsPsxIvH8TGVqZU+hRKfqyZfac7fuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/164] KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
Date:   Wed, 12 Apr 2023 10:32:08 +0200
Message-Id: <20230412082837.055675390@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit c82d28cbf1d4f9fe174041b4485c635cb970afa7 ]

The PMU architecture makes a subtle difference between a 64bit
counter and a counter that has a 64bit overflow. This is for example
the case of the cycle counter, which can generate an overflow on
a 32bit boundary if PMCR_EL0.LC==0 despite the accumulation being
done on 64 bits.

Use this distinction in the few cases where it matters in the code,
as we will reuse this with PMUv3p5 long counters.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221113163832.3154370-5-maz@kernel.org
Stable-dep-of: f6da81f650fa ("KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 43 ++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 57765be69bea0..c146417b8178b 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -50,6 +50,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
  * @select_idx: The counter index
  */
 static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
+{
+	return (select_idx == ARMV8_PMU_CYCLE_IDX);
+}
+
+static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
 		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
@@ -57,7 +62,8 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
 
 static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
 {
-	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
+	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX &&
+		!kvm_pmu_idx_has_64bit_overflow(vcpu, idx));
 }
 
 static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
@@ -97,7 +103,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 		counter += perf_event_read_value(pmc->perf_event, &enabled,
 						 &running);
 
-	if (select_idx != ARMV8_PMU_CYCLE_IDX)
+	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
 		counter = lower_32_bits(counter);
 
 	return counter;
@@ -423,6 +429,23 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 	}
 }
 
+/* Compute the sample period for a given counter value */
+static u64 compute_period(struct kvm_vcpu *vcpu, u64 select_idx, u64 counter)
+{
+	u64 val;
+
+	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
+		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx))
+			val = -(counter & GENMASK(31, 0));
+		else
+			val = (-counter) & GENMASK(63, 0);
+	} else {
+		val = (-counter) & GENMASK(31, 0);
+	}
+
+	return val;
+}
+
 /**
  * When the perf event overflows, set the overflow status and inform the vcpu.
  */
@@ -442,10 +465,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 	 * Reset the sample period to the architectural limit,
 	 * i.e. the point where the counter overflows.
 	 */
-	period = -(local64_read(&perf_event->count));
-
-	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
-		period &= GENMASK(31, 0);
+	period = compute_period(vcpu, idx, local64_read(&perf_event->count));
 
 	local64_set(&perf_event->hw.period_left, 0);
 	perf_event->attr.sample_period = period;
@@ -571,14 +591,13 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 
 	/*
 	 * If counting with a 64bit counter, advertise it to the perf
-	 * code, carefully dealing with the initial sample period.
+	 * code, carefully dealing with the initial sample period
+	 * which also depends on the overflow.
 	 */
-	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
+	if (kvm_pmu_idx_is_64bit(vcpu, select_idx))
 		attr.config1 |= PERF_ATTR_CFG1_COUNTER_64BIT;
-		attr.sample_period = (-counter) & GENMASK(63, 0);
-	} else {
-		attr.sample_period = (-counter) & GENMASK(31, 0);
-	}
+
+	attr.sample_period = compute_period(vcpu, select_idx, counter);
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
 						 kvm_pmu_perf_overflow, pmc);
-- 
2.39.2



