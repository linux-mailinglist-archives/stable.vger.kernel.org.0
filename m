Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4DA6D3F82
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjDCIzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjDCIzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:55:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E8FCDC4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9569261593
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF0BC433EF;
        Mon,  3 Apr 2023 08:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680512106;
        bh=pgWprhwPz9lJSHYWBA8Pv9FiUZgaTL1KqhMwEq3r9IY=;
        h=Subject:To:Cc:From:Date:From;
        b=WureV0JMwjCHOlRQAOW4V4xOZcavJ+eiJbKTSdvX6AJaBv4v9+x8+gdkN378wtd2W
         HEhSKQZ18EUvrjoQsDlJL+XD9fvynr/U9mY4k5rNJZkaIkgza5k2oiImXTyJKp1ly5
         K5l9oH+gnFKrdmf4IZS11v36pAAsytgEoU/48Xbg=
Subject: FAILED: patch "[PATCH] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the" failed to apply to 4.14-stable tree
To:     reijiw@google.com, maz@kernel.org, oliver.upton@linux.dev
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:54:58 +0200
Message-ID: <2023040358-smite-passover-92f2@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 9228b26194d1cc00449f12f306f53ef2e234a55b
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040358-smite-passover-92f2@gregkh' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

9228b26194d1 ("KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the current value")
0ab410a93d62 ("KVM: arm64: Narrow PMU sysreg reset values to architectural requirements")
11663111cd49 ("KVM: arm64: Hide PMU registers from userspace when not available")
7ccadf23b861 ("KVM: arm64: Add missing reset handlers for PMU emulation")
03fdfb269009 ("KVM: arm64: Don't write junk to sysregs on reset")
20589c8cc47d ("arm/arm64: KVM: Don't panic on failure to properly reset system registers")
8d404c4c2461 ("KVM: arm64: Rewrite system register accessors to read/write functions")
52f6c4f02164 ("KVM: arm64: Change 32-bit handling of VM system registers")
54ceb1bcf8d8 ("KVM: arm64: Move debug dirty flag calculation out of world switch")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9228b26194d1cc00449f12f306f53ef2e234a55b Mon Sep 17 00:00:00 2001
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 12 Mar 2023 20:32:08 -0700
Subject: [PATCH] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to return the
 current value

Have KVM_GET_ONE_REG for vPMU counter (vPMC) registers (PMCCNTR_EL0
and PMEVCNTR<n>_EL0) return the sum of the register value in the sysreg
file and the current perf event counter value.

Values of vPMC registers are saved in sysreg files on certain occasions.
These saved values don't represent the current values of the vPMC
registers if the perf events for the vPMCs count events after the save.
The current values of those registers are the sum of the sysreg file
value and the current perf event counter value.  But, when userspace
reads those registers (using KVM_GET_ONE_REG), KVM returns the sysreg
file value to userspace (not the sum value).

Fix this to return the sum value for KVM_GET_ONE_REG.

Fixes: 051ff581ce70 ("arm64: KVM: Add access handler for event counter register")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Link: https://lore.kernel.org/r/20230313033208.1475499-1-reijiw@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 53749d3a0996..1b2c161120be 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -856,6 +856,22 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 	return true;
 }
 
+static int get_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			  u64 *val)
+{
+	u64 idx;
+
+	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 0)
+		/* PMCCNTR_EL0 */
+		idx = ARMV8_PMU_CYCLE_IDX;
+	else
+		/* PMEVCNTRn_EL0 */
+		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
+
+	*val = kvm_pmu_get_counter_value(vcpu, idx);
+	return 0;
+}
+
 static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			      struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
@@ -1072,7 +1088,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
 	{ PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),				\
-	  .reset = reset_pmevcntr,					\
+	  .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,		\
 	  .access = access_pmu_evcntr, .reg = (PMEVCNTR0_EL0 + n), }
 
 /* Macro to expand the PMEVTYPERn_EL0 register */
@@ -1982,7 +1998,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(SYS_PMCEID1_EL0),
 	  .access = access_pmceid, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMCCNTR_EL0),
-	  .access = access_pmu_evcntr, .reset = reset_unknown, .reg = PMCCNTR_EL0 },
+	  .access = access_pmu_evcntr, .reset = reset_unknown,
+	  .reg = PMCCNTR_EL0, .get_user = get_pmu_evcntr},
 	{ PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
 	  .access = access_pmu_evtyper, .reset = NULL },
 	{ PMU_SYS_REG(SYS_PMXEVCNTR_EL0),

