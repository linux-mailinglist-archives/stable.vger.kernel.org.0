Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 373EB9E0CE
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731883AbfH0IGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729743AbfH0IGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:06:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1806D2173E;
        Tue, 27 Aug 2019 08:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893168;
        bh=FBRDtcqFIDVcWQpAbDY2o0oMur4mGzeQE00WfLqTOIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arfo72LPQPMSx9SKfdnUinqXI0Je52OZE0diukftF4q1g9ybuhfZc3KyGs5/uUjPM
         MK/rGtKRaH9PSfhUq941xFgpPQKEMNlQwt8tDKVko8gSiWa6tbdeKMFk9/PORe8fzZ
         MGIv8x0Kk5R7vJLV56ncpHAo00BY9zM8yxvbkqBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 107/162] KVM: arm64: Dont write junk to sysregs on reset
Date:   Tue, 27 Aug 2019 09:50:35 +0200
Message-Id: <20190827072742.050613533@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 03fdfb2690099c19160a3f2c5b77db60b3afeded ]

At the moment, the way we reset system registers is mildly insane:
We write junk to them, call the reset functions, and then check that
we have something else in them.

The "fun" thing is that this can happen while the guest is running
(PSCI, for example). If anything in KVM has to evaluate the state
of a system register while junk is in there, bad thing may happen.

Let's stop doing that. Instead, we track that we have called a
reset function for that register, and assume that the reset
function has done something. This requires fixing a couple of
sysreg refinition in the trap table.

In the end, the very need of this reset check is pretty dubious,
as it doesn't check everything (a lot of the sysregs leave outside of
the sys_regs[] array). It may well be axed in the near future.

Tested-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ce933f2960496..5b7085ca213df 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -632,7 +632,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	 */
 	val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
 
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
@@ -981,13 +981,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
-	  trap_bvr, reset_bvr, n, 0, get_bvr, set_bvr },		\
+	  trap_bvr, reset_bvr, 0, 0, get_bvr, set_bvr },		\
 	{ SYS_DESC(SYS_DBGBCRn_EL1(n)),					\
-	  trap_bcr, reset_bcr, n, 0, get_bcr, set_bcr },		\
+	  trap_bcr, reset_bcr, 0, 0, get_bcr, set_bcr },		\
 	{ SYS_DESC(SYS_DBGWVRn_EL1(n)),					\
-	  trap_wvr, reset_wvr, n, 0,  get_wvr, set_wvr },		\
+	  trap_wvr, reset_wvr, 0, 0,  get_wvr, set_wvr },		\
 	{ SYS_DESC(SYS_DBGWCRn_EL1(n)),					\
-	  trap_wcr, reset_wcr, n, 0,  get_wcr, set_wcr }
+	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
@@ -1540,7 +1540,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 
-	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, },
+	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, PMCR_EL0 },
 	{ SYS_DESC(SYS_PMCNTENSET_EL0), access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
 	{ SYS_DESC(SYS_PMCNTENCLR_EL0), access_pmcnten, NULL, PMCNTENSET_EL0 },
 	{ SYS_DESC(SYS_PMOVSCLR_EL0), access_pmovs, NULL, PMOVSSET_EL0 },
@@ -2254,13 +2254,19 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 }
 
 static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
-			      const struct sys_reg_desc *table, size_t num)
+				const struct sys_reg_desc *table, size_t num,
+				unsigned long *bmap)
 {
 	unsigned long i;
 
 	for (i = 0; i < num; i++)
-		if (table[i].reset)
+		if (table[i].reset) {
+			int reg = table[i].reg;
+
 			table[i].reset(vcpu, &table[i]);
+			if (reg > 0 && reg < NR_SYS_REGS)
+				set_bit(reg, bmap);
+		}
 }
 
 /**
@@ -2774,18 +2780,16 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 {
 	size_t num;
 	const struct sys_reg_desc *table;
-
-	/* Catch someone adding a register without putting in reset entry. */
-	memset(&vcpu->arch.ctxt.sys_regs, 0x42, sizeof(vcpu->arch.ctxt.sys_regs));
+	DECLARE_BITMAP(bmap, NR_SYS_REGS) = { 0, };
 
 	/* Generic chip reset first (so target could override). */
-	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
+	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs), bmap);
 
 	table = get_target_table(vcpu->arch.target, true, &num);
-	reset_sys_reg_descs(vcpu, table, num);
+	reset_sys_reg_descs(vcpu, table, num, bmap);
 
 	for (num = 1; num < NR_SYS_REGS; num++) {
-		if (WARN(__vcpu_sys_reg(vcpu, num) == 0x4242424242424242,
+		if (WARN(!test_bit(num, bmap),
 			 "Didn't reset __vcpu_sys_reg(%zi)\n", num))
 			break;
 	}
-- 
2.20.1



