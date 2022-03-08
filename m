Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFF14D1D2B
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 17:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbiCHQau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 11:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiCHQau (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 11:30:50 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EF6450447
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 08:29:53 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6ADFB1516;
        Tue,  8 Mar 2022 08:29:53 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CE273FA45;
        Tue,  8 Mar 2022 08:29:52 -0800 (PST)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        james.morse@arm.com
Subject: [stable:PATCH] KVM: arm64: Reset PMC_EL0 to avoid a panic() on systems with no PMU
Date:   Tue,  8 Mar 2022 16:29:39 +0000
Message-Id: <20220308162939.603335-1-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The logic in commit 2a5f1b67ec57 "KVM: arm64: Don't access PMCR_EL0 when no
PMU is available" relies on an empty reset handler being benign.  This was
not the case in earlier kernel versions, so the stable backport of this
patch is causing problems.

KVMs behaviour in this area changed over time. In particular, prior to commit
03fdfb269009 ("KVM: arm64: Don't write junk to sysregs on reset"), an empty
reset handler will trigger a warning, as the guest registers have been
poisoned.
Prior to commit 20589c8cc47d ("arm/arm64: KVM: Don't panic on failure to
properly reset system registers"), this warning was a panic().

Instead of reverting the backport, make it write 0 to the sys_reg[] array.
This keeps the reset logic happy, and the dodgy value can't be seen by
the guest as it can't request the emulation.

The original bug was accessing the PMCR_EL0 register on CPUs that don't
implement that feature. There is no known silicon that does this, but
v4.9's ACPI support is unable to find the PMU, so triggers this code:

| Kernel panic - not syncing: Didn't reset vcpu_sys_reg(24)
| CPU: 1 PID: 3055 Comm: lkvm Not tainted 4.9.302-00032-g64e078a56789 #13476
| Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Jul 30 2018
| Call trace:
| [<ffff00000808b4b0>] dump_backtrace+0x0/0x1a0
| [<ffff00000808b664>] show_stack+0x14/0x20
| [<ffff0000088f0e18>] dump_stack+0x98/0xb8
| [<ffff0000088eef08>] panic+0x118/0x274
| [<ffff0000080b50e0>] access_actlr+0x0/0x20
| [<ffff0000080b2620>] kvm_reset_vcpu+0x5c/0xac
| [<ffff0000080ac688>] kvm_arch_vcpu_ioctl+0x3e4/0x490
| [<ffff0000080a382c>] kvm_vcpu_ioctl+0x5b8/0x720
| [<ffff000008201e44>] do_vfs_ioctl+0x2f4/0x884
| [<ffff00000820244c>] SyS_ioctl+0x78/0x9c
| [<ffff000008083a9c>] __sys_trace_return+0x0/0x4

Cc: <stable@vger.kernel.org> # < v5.3 with 2a5f1b67ec57 backported
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 10d80456f38f..8d548fdbb6b2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -451,8 +451,10 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	u64 pmcr, val;
 
 	/* No PMU available, PMCR_EL0 may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
+	if (!kvm_arm_support_pmu_v3()) {
+		vcpu_sys_reg(vcpu, PMCR_EL0) = 0;
 		return;
+	}
 
 	pmcr = read_sysreg(pmcr_el0);
 	/*
-- 
2.30.2

