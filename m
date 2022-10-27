Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED54610412
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 23:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiJ0VLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 17:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236597AbiJ0VLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 17:11:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45B063AF
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 14:08:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FBA5B8276A
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 21:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58393C433D6;
        Thu, 27 Oct 2022 21:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666904890;
        bh=r/jnRnyyGayrX4/gO/vaY6RwRYSLrVP13xE/7oWXg2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEG3910/jGaVLaSrbdP07Qw4kUhAMJEaWAq1z8Gr350BIiVOIaTXGrpBmt+YcGyyS
         3B9wYcRaXTJUJk1fBTMZec9PjxWc2jLTsXRBvG1CS1F6zhQmdpSEnqJnOsSWR+a5+o
         rmJiVVxvq2E15sLy8t7MhFGiaGBVXixHDah41jWcH9XdcmdWepYAY4zIprxNRNN8YM
         jwwgJESeikeychVvt2lrixyr31WH6G2DSMnn2P/xJTI9117YOsWkDzP1kZ65KOf7A4
         99Yu15rpHdyfE41vwQ2N2VTDRtgpUXa059J6FngvTcHcJO2tqmbOnnPW6yzZtbIZBd
         4gz9qfkvOJN4A==
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Vincent Donnefort <vdonnefort@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v1 2/2] KVM: arm64: Trap access to SMPRI_EL1 in VHE mode
Date:   Thu, 27 Oct 2022 22:04:40 +0100
Message-Id: <20221027210441.814061-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221027210441.814061-1-broonie@kernel.org>
References: <20221027210441.814061-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2298; i=broonie@kernel.org; h=from:subject; bh=r/jnRnyyGayrX4/gO/vaY6RwRYSLrVP13xE/7oWXg2w=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjWvJoIkOm0eR9ETtgNFbmhIxXFccQODfCupOrHmnD nDsbbeeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1ryaAAKCRAk1otyXVSH0MHWB/ 4sUrRIkzglGyAJJSo/Cc5fr3nNTCm3Mg44+BHNuZQIq2uqM7opQevyw9QGwwiffWD15paYCy0Ed8wx FwOmSq4GuW5vu9Y6iExHYu6q6Lcl2+ige+sdvVVb3kkRpxZTTFHGmJPvQaB0He2ADnc4Hb4uEP3Llg 4tzZOx4xlKC5hOzcm7VfOx2gYddR1Q+f8edhODwhrKoKC2Z3hA2huO/i4U4Sy3KluOLVf1zGV0blAG IJR19V8WhpH3mhgOIPx1GQUKkPaq2bYJCM5PqLSaWoZL15/yJ3LWJs2dYVyKxbuSD1lrBbPJMlmMBZ RYXB5QWTFl2Gh9mkxmN3y1X2HfqZ5L
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On systems with SME access to the SMPRI_EL1 priority management register is
controlled by the nSMPRI_EL1 fine grained trap. We manage this trap in nVHE
mode but do not do so when in VHE mode, add the required management.

On systems which do not implement priority mapping not enabling this trap
will allow the guest to discover if the host support SME since the register
will be RES0 rather than UNDEF. On systems implementing priority mapping
the register could be used as a side channel by guests.

Fixes: 861262ab8627 ("KVM: arm64: Handle SME host state when running guests")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/hyp/vhe/switch.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7acb87eaa092..cae581e8dd56 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -63,10 +63,20 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
-	if (cpus_have_final_cap(ARM64_SME))
+	if (cpus_have_final_cap(ARM64_SME)) {
 		write_sysreg(read_sysreg(sctlr_el2) & ~SCTLR_ELx_ENTP2,
 			     sctlr_el2);
 
+		/*
+		 * Disable access to SMPRI_EL1 - we don't need to control
+		 * nTPIDR2_EL0 in VHE mode.
+		 */
+		sysreg_clear_set_s(SYS_HFGRTR_EL2, HFGxTR_EL2_nSMPRI_EL1_MASK,
+				   0);
+		sysreg_clear_set_s(SYS_HFGWTR_EL2, HFGxTR_EL2_nSMPRI_EL1_MASK,
+				   0);
+	}
+
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
@@ -88,9 +98,19 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	 */
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
-	if (cpus_have_final_cap(ARM64_SME))
+	if (cpus_have_final_cap(ARM64_SME)) {
+		/*
+		 * Enable access to SMPRI_EL1 - we don't need to
+		 * control nTPIDR2_EL0 in VHE mode.
+		 */
+		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK);
+		sysreg_clear_set_s(SYS_HFGWTR_EL2, 0,
+				   HFGxTR_EL2_nSMPRI_EL1_MASK);
+
 		write_sysreg(read_sysreg(sctlr_el2) | SCTLR_ELx_ENTP2,
 			     sctlr_el2);
+	}
 
 	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 
-- 
2.30.2

