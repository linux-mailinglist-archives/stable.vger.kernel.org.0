Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAA46D3F85
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjDCIzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjDCIzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0118F358B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AA3760A49
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31A8C433EF;
        Mon,  3 Apr 2023 08:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680512115;
        bh=P8qqnD+PRDP+W0X1eQJ5PGLzCgZG6Tu93xyxNr/Ef1s=;
        h=Subject:To:Cc:From:Date:From;
        b=haHEDKsC6wHUlD75v2+Cz+3WE7lLVc44swW8A4w9uCwtkRJ7DUaHCp4fyoYfgEu0R
         yhMbjIb75T2gGz52nRVHovkrvJGHdtbMsEqgZn1xo+Sp7HX/kyirZIRoJpN5KC3IVm
         vYgtgQz9XrpX7mAq1MoDcGPqGI39shFuCNRH98no=
Subject: FAILED: patch "[PATCH] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU" failed to apply to 5.15-stable tree
To:     reijiw@google.com, maz@kernel.org, oliver.upton@linux.dev
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:55:10 +0200
Message-ID: <2023040310-snowbird-bacteria-e989@gregkh>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x f6da81f650fa47b61b847488f3938d43f90d093d
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040310-snowbird-bacteria-e989@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

f6da81f650fa ("KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU")
64d6820d64c0 ("KVM: arm64: PMU: Sanitise PMCR_EL0.LP on first vcpu run")
11af4c37165e ("KVM: arm64: PMU: Implement PMUv3p5 long counter support")
3d0dba5764b9 ("KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation")
c82d28cbf1d4 ("KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow")
bead02204e98 ("KVM: arm64: PMU: Align chained counter implementation with architecture pseudocode")
121a8fc088f1 ("arm64/sysreg: Use feature numbering for PMU and SPE revisions")
fcf37b38ff22 ("arm64/sysreg: Add _EL1 into ID_AA64DFR0_EL1 definition names")
c0357a73fa4a ("arm64/sysreg: Align field names in ID_AA64DFR0_EL1 with architecture")
8794b4f510f7 ("Merge branch kvm-arm64/per-vcpu-host-pmu-data into kvmarm-master/next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f6da81f650fa47b61b847488f3938d43f90d093d Mon Sep 17 00:00:00 2001
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 12 Mar 2023 20:32:34 -0700
Subject: [PATCH] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU

Presently, when a guest writes 1 to PMCR_EL0.{C,P}, which is WO/RAZ,
KVM saves the register value, including these bits.
When userspace reads the register using KVM_GET_ONE_REG, KVM returns
the saved register value as it is (the saved value might have these
bits set).  This could result in userspace setting these bits on the
destination during migration.  Consequently, KVM may end up resetting
the vPMU counter registers (PMCCNTR_EL0 and/or PMEVCNTR<n>_EL0) to
zero on the first KVM_RUN after migration.

Fix this by not saving those bits when a guest writes 1 to those bits.

Fixes: ab9468340d2b ("arm64: KVM: Add access handler for PMCR register")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Link: https://lore.kernel.org/r/20230313033234.1475987-1-reijiw@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..c243b10f3e15 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -538,7 +538,8 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_pmu_is_3p5(vcpu))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+	/* The reset bits don't indicate any state, and shouldn't be saved. */
+	__vcpu_sys_reg(vcpu, PMCR_EL0) = val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,

