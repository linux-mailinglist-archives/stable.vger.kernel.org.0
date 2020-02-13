Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FD515C340
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgBMP26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729273AbgBMP25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:57 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C91024676;
        Thu, 13 Feb 2020 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607737;
        bh=AyhCAYMCFmAmAbmoLSWttuf0ENfoysuc6lyikTyu6s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TjEin74rZgL7SeWlt6qbwcxVap4y6x97kY5y/hqDvd/IQYQXHiyrRlMpKu3CkUd1
         32oyzQREaiz4jL6EtSJ97RJmsKllemy8Tnrq4m03fa1oycQNJVWYc3r4rga4IpruBZ
         h1BpXQNv6UdpUkEFNuNnnNBiUa1mgMKdi/1rXCHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.5 089/120] KVM: arm64: pmu: Fix chained SW_INCR counters
Date:   Thu, 13 Feb 2020 07:21:25 -0800
Message-Id: <20200213151931.193247078@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

commit aa76829171e98bd75a0cc00b6248eca269ac7f4f upstream.

At the moment a SW_INCR counter always overflows on 32-bit
boundary, independently on whether the n+1th counter is
programmed as CHAIN.

Check whether the SW_INCR counter is a 64b counter and if so,
implement the 64b logic.

Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200124142535.29386-4-eric.auger@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/pmu.c |   43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -480,28 +480,45 @@ static void kvm_pmu_perf_overflow(struct
  */
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 {
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	int i;
-	u64 type, enable, reg;
-
-	if (val == 0)
-		return;
 
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
 		return;
 
-	enable = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+	/* Weed out disabled counters */
+	val &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+
 	for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
+		u64 type, reg;
+
 		if (!(val & BIT(i)))
 			continue;
-		type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i)
-		       & ARMV8_PMU_EVTYPE_EVENT;
-		if ((type == ARMV8_PMUV3_PERFCTR_SW_INCR)
-		    && (enable & BIT(i))) {
-			reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
+
+		/* PMSWINC only applies to ... SW_INC! */
+		type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+		type &= ARMV8_PMU_EVTYPE_EVENT;
+		if (type != ARMV8_PMUV3_PERFCTR_SW_INCR)
+			continue;
+
+		/* increment this even SW_INC counter */
+		reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
+		reg = lower_32_bits(reg);
+		__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
+
+		if (reg) /* no overflow on the low part */
+			continue;
+
+		if (kvm_pmu_pmc_is_chained(&pmu->pmc[i])) {
+			/* increment the high counter */
+			reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) + 1;
 			reg = lower_32_bits(reg);
-			__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
-			if (!reg)
-				__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
+			__vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) = reg;
+			if (!reg) /* mark overflow on the high counter */
+				__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i + 1);
+		} else {
+			/* mark overflow on low counter */
+			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
 		}
 	}
 }


