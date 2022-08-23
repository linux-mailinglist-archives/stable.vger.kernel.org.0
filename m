Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD3759D679
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348378AbiHWJJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347940AbiHWJIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:08:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D918670C;
        Tue, 23 Aug 2022 01:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C272B81C5C;
        Tue, 23 Aug 2022 08:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492FBC433D6;
        Tue, 23 Aug 2022 08:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243347;
        bh=TI0UbaW7/8QW7VrTlNHKdtAt6eyn/rO/fXGq4LAa7hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ks6Fh0wk4LCojkhybjxoPXpDAjJe7k3CAi+NHWAqVy+Ac5RCcrcmGkbJWbkmqPZz9
         jwt21GJ3SuL2grDwGlKRzJ/5kMi7W4zaj/f3xFIzm/BoFHWRUmhe6UVXO4E71L/yg/
         KZmFxXdNu0vTzEC4p4aBcY+NJWorkTW+slqCHGig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 249/365] KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
Date:   Tue, 23 Aug 2022 10:02:30 +0200
Message-Id: <20220823080128.610558623@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit f3c6efc72f3b20ec23566e768979802f0a398f04 ]

KVM does not support AArch32 on asymmetric systems. To that end, enforce
AArch64-only behavior on PMCR_EL1.LC when on an asymmetric system.

Fixes: 2122a833316f ("arm64: Allow mismatched 32-bit EL0 support")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220816192554.1455559-2-oliver.upton@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/arm.c              | 3 +--
 arch/arm64/kvm/sys_regs.c         | 4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index de32152cea04..7aaf75577096 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -838,6 +838,10 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	(system_supports_mte() &&				\
 	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
 
+#define kvm_supports_32bit_el0()				\
+	(system_supports_32bit_el0() &&				\
+	 !static_branch_unlikely(&arm64_mismatched_32bit_el0))
+
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 83a7f61354d3..e21b24574118 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -751,8 +751,7 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 	if (likely(!vcpu_mode_is_32bit(vcpu)))
 		return false;
 
-	return !system_supports_32bit_el0() ||
-		static_branch_unlikely(&arm64_mismatched_32bit_el0);
+	return !kvm_supports_32bit_el0();
 }
 
 /**
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c06c0477fab5..be7edd21537f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -692,7 +692,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	 */
 	val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
-	if (!system_supports_32bit_el0())
+	if (!kvm_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
 	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
@@ -741,7 +741,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
-		if (!system_supports_32bit_el0())
+		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
-- 
2.35.1



