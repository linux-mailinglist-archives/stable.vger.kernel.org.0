Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7D66DEE5E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjDLIlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjDLIkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0112C7AA0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 886FC62FEC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BE9C433EF;
        Wed, 12 Apr 2023 08:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288787;
        bh=xWk1h18EfxcKdu5sTPBRA2maN3Mp567bmN25uJlqPh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJsjLKTVAbN0uX9LXlC++0vPmfQLg0fLIyeIHnouRXWxr8SGbJFfgGibrS8riRVGW
         E8+e7RBFVaXBfxXjzj4/5QRtILX+VFNizOZjtTMfgySpiZfmPmoNaIH6NRWY3SilX7
         Q23H1T3LDIbLhjxzcquZa43Ji/W92WI4mDa1Ryfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/164] KVM: arm64: PMU: Sanitise PMCR_EL0.LP on first vcpu run
Date:   Wed, 12 Apr 2023 10:32:09 +0200
Message-Id: <20230412082837.112227124@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 64d6820d64c0a206e744bd8945374d563a76c16c ]

Userspace can play some dirty tricks on us by selecting a given
PMU version (such as PMUv3p5), restore a PMCR_EL0 value that
has PMCR_EL0.LP set, and then switch the PMU version to PMUv3p1,
for example. In this situation, we end-up with PMCR_EL0.LP being
set and spreading havoc in the PMU emulation.

This is specially hard as the first two step can be done on
one vcpu and the third step on another, meaning that we need
to sanitise *all* vcpus when the PMU version is changed.

In orer to avoid a pretty complicated locking situation,
defer the sanitisation of PMCR_EL0 to the point where the
vcpu is actually run for the first tine, using the existing
KVM_REQ_RELOAD_PMU request that calls into kvm_pmu_handle_pmcr().

There is still an obscure corner case where userspace could
do the above trick, and then save the VM without running it.
They would then observe an inconsistent state (PMUv3.1 + LP set),
but that state will be fixed on the first run anyway whenever
the guest gets restored on a host.

Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Stable-dep-of: f6da81f650fa ("KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 2 ++
 arch/arm64/kvm/sys_regs.c | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index c146417b8178b..50b6ba593a10b 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -511,6 +511,8 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
+	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bfe4f17232b3e..1f80e17a64608 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -697,13 +697,15 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return false;
 
 	if (p->is_write) {
-		/* Only update writeable bits of PMCR */
+		/*
+		 * Only update writeable bits of PMCR (continuing into
+		 * kvm_pmu_handle_pmcr() as well)
+		 */
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
-		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
 		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
-- 
2.39.2



