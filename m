Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40A64CF8C4
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbiCGKCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240531AbiCGKBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567BB1D33C;
        Mon,  7 Mar 2022 01:50:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD5DE60748;
        Mon,  7 Mar 2022 09:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15EEC340F3;
        Mon,  7 Mar 2022 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646605;
        bh=rXgZlLzPUuqsvP0dpF1zDMb8grHtpKHB7BONcrsLSUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdX2cywV5bFkuaKzm9O+JGxLsasLuTnlKR8GVJN9DP3IvvWTLwhYethj+qjrSFAfg
         EsRhQ+j/0tFFLsgflydNII7jcZkDwBfMuBRzv10uFr7zWHycDXjWt5JIVo6Jnye6fi
         A0gjn8Mb42sBqLmBvEP0r6ej2qwx1Aqj4hVAgy9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 035/186] KVM: arm64: Workaround Cortex-A510s single-step and PAC trap errata
Date:   Mon,  7 Mar 2022 10:17:53 +0100
Message-Id: <20220307091655.077054528@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

[ Upstream commit 1dd498e5e26ad71e3e9130daf72cfb6a693fee03 ]

Cortex-A510's erratum #2077057 causes SPSR_EL2 to be corrupted when
single-stepping authenticated ERET instructions. A single step is
expected, but a pointer authentication trap is taken instead. The
erratum causes SPSR_EL1 to be copied to SPSR_EL2, which could allow
EL1 to cause a return to EL2 with a guest controlled ELR_EL2.

Because the conditions require an ERET into active-not-pending state,
this is only a problem for the EL2 when EL2 is stepping EL1. In this case
the previous SPSR_EL2 value is preserved in struct kvm_vcpu, and can be
restored.

Cc: stable@vger.kernel.org # 53960faf2b73: arm64: Add Cortex-A510 CPU part definition
Cc: stable@vger.kernel.org
Signed-off-by: James Morse <james.morse@arm.com>
[maz: fixup cpucaps ordering]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127122052.1584324-5-james.morse@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst  |  2 ++
 arch/arm64/Kconfig                      | 16 ++++++++++++++++
 arch/arm64/kernel/cpu_errata.c          |  8 ++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 20 +++++++++++++++++++-
 arch/arm64/tools/cpucaps                |  5 +++--
 5 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 0ec7b7f1524b1..ea281dd755171 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -100,6 +100,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2051678        | ARM64_ERRATUM_2051678       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #2077057        | ARM64_ERRATUM_2077057       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2119858        | ARM64_ERRATUM_2119858       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A710     | #2054223        | ARM64_ERRATUM_2054223       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ae0e93871ee5f..651bf217465e9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -681,6 +681,22 @@ config ARM64_ERRATUM_2051678
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_2077057
+	bool "Cortex-A510: 2077057: workaround software-step corrupting SPSR_EL2"
+	help
+	  This option adds the workaround for ARM Cortex-A510 erratum 2077057.
+	  Affected Cortex-A510 may corrupt SPSR_EL2 when the a step exception is
+	  expected, but a Pointer Authentication trap is taken instead. The
+	  erratum causes SPSR_EL1 to be copied to SPSR_EL2, which could allow
+	  EL1 to cause a return to EL2 with a guest controlled ELR_EL2.
+
+	  This can only happen when EL2 is stepping EL1.
+
+	  When these conditions occur, the SPSR_EL2 value is unchanged from the
+	  previous guest entry, and can be restored from the in-memory copy.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_2119858
 	bool "Cortex-A710/X2: 2119858: workaround TRBE overwriting trace data in FILL mode"
 	default y
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 066098198c248..b217941713a8d 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -600,6 +600,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		CAP_MIDR_RANGE_LIST(trbe_write_out_of_range_cpus),
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_2077057
+	{
+		.desc = "ARM erratum 2077057",
+		.capability = ARM64_WORKAROUND_2077057,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2),
+	},
+#endif
 #ifdef CONFIG_ARM64_ERRATUM_2064142
 	{
 		.desc = "ARM erratum 2064142",
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index adb67f8c9d7d3..3ae9c0b944878 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -424,6 +424,24 @@ static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
+static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	/*
+	 * Check for the conditions of Cortex-A510's #2077057. When these occur
+	 * SPSR_EL2 can't be trusted, but isn't needed either as it is
+	 * unchanged from the value in vcpu_gp_regs(vcpu)->pstate.
+	 * Are we single-stepping the guest, and took a PAC exception from the
+	 * active-not-pending state?
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_2077057)		&&
+	    vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP			&&
+	    *vcpu_cpsr(vcpu) & DBG_SPSR_SS				&&
+	    ESR_ELx_EC(read_sysreg_el2(SYS_ESR)) == ESR_ELx_EC_PAC)
+		write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+
+	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -435,7 +453,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * Save PSTATE early so that we can evaluate the vcpu mode
 	 * early on.
 	 */
-	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
+	synchronize_vcpu_pstate(vcpu, exit_code);
 
 	/*
 	 * Check whether we want to repaint the state one way or
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index e7719e8f18def..9c65b1e25a965 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -55,9 +55,10 @@ WORKAROUND_1418040
 WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
-WORKAROUND_2064142
-WORKAROUND_2038923
 WORKAROUND_1902691
+WORKAROUND_2038923
+WORKAROUND_2064142
+WORKAROUND_2077057
 WORKAROUND_TRBE_OVERWRITE_FILL_MODE
 WORKAROUND_TSB_FLUSH_FAILURE
 WORKAROUND_TRBE_WRITE_OUT_OF_RANGE
-- 
2.34.1



