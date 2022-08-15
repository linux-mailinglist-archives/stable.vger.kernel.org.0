Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59042593C26
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346511AbiHOUWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347077AbiHOUV5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:21:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE6298D24;
        Mon, 15 Aug 2022 12:01:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC89B810A1;
        Mon, 15 Aug 2022 19:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC971C433C1;
        Mon, 15 Aug 2022 19:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590064;
        bh=xExqZ2cjy5zyFW10bCJOCsLa1DT07p+HNJ7TEKasfsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy2F37Kmgp6gDi/WpMfXTKK9lf2uOUF+4Zq+aZbJ/c/s5SxfcRUvmqqws09+g6Jig
         zCYb4v6CBHwkNyc3Qgk1RR1UljLpuIdH0bzH4M988Rrm7kA1J5AT1hqEUtsoYPVJ7O
         1YzHfwxG07g9qKlUXRmJ/l6eFiy+Rxr1+Kp9MLjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0140/1095] arm64: errata: Remove AES hwcap for COMPAT tasks
Date:   Mon, 15 Aug 2022 19:52:19 +0200
Message-Id: <20220815180435.366390465@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: James Morse <james.morse@arm.com>

[ Upstream commit 44b3834b2eed595af07021b1c64e6f9bc396398b ]

Cortex-A57 and Cortex-A72 have an erratum where an interrupt that
occurs between a pair of AES instructions in aarch32 mode may corrupt
the ELR. The task will subsequently produce the wrong AES result.

The AES instructions are part of the cryptographic extensions, which are
optional. User-space software will detect the support for these
instructions from the hwcaps. If the platform doesn't support these
instructions a software implementation should be used.

Remove the hwcap bits on affected parts to indicate user-space should
not use the AES instructions.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Link: https://lore.kernel.org/r/20220714161523.279570-3-james.morse@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  4 ++++
 arch/arm64/Kconfig                     | 16 ++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         | 16 ++++++++++++++++
 arch/arm64/kernel/cpufeature.c         | 14 +++++++++++++-
 arch/arm64/tools/cpucaps               |  1 +
 5 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index d27db84d585e..0b4235b1f8c4 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -82,10 +82,14 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #1319537        | ARM64_ERRATUM_1319367       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A57      | #1742098        | ARM64_ERRATUM_1742098       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A72      | #853709         | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A72      | #1319367        | ARM64_ERRATUM_1319367       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A72      | #1655431        | ARM64_ERRATUM_1742098       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1188873,1418040| ARM64_ERRATUM_1418040       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 20ea89d9ac2f..b2d5a1e8eda3 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -500,6 +500,22 @@ config ARM64_ERRATUM_834220
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1742098
+	bool "Cortex-A57/A72: 1742098: ELR recorded incorrectly on interrupt taken between cryptographic instructions in a sequence"
+	depends on COMPAT
+	default y
+	help
+	  This option removes the AES hwcap for aarch32 user-space to
+	  workaround erratum 1742098 on Cortex-A57 and Cortex-A72.
+
+	  Affected parts may corrupt the AES state if an interrupt is
+	  taken between a pair of AES instructions. These instructions
+	  are only present if the cryptography extensions are present.
+	  All software should have a fallback implementation for CPUs
+	  that don't implement the cryptography extensions.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_845719
 	bool "Cortex-A53: 845719: a load might read incorrect data"
 	depends on COMPAT
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a0f3d0aaa3c5..27baa41c46ca 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -395,6 +395,14 @@ static struct midr_range trbe_write_out_of_range_cpus[] = {
 };
 #endif /* CONFIG_ARM64_WORKAROUND_TRBE_WRITE_OUT_OF_RANGE */
 
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+static struct midr_range broken_aarch32_aes[] = {
+	MIDR_RANGE(MIDR_CORTEX_A57, 0, 1, 0xf, 0xf),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+	{},
+};
+#endif /* CONFIG_ARM64_WORKAROUND_TRBE_WRITE_OUT_OF_RANGE */
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -657,6 +665,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		/* Cortex-A510 r0p0 - r0p1 */
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 1)
 	},
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+	{
+		.desc = "ARM erratum 1742098",
+		.capability = ARM64_WORKAROUND_1742098,
+		CAP_MIDR_RANGE_LIST(broken_aarch32_aes),
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+	},
 #endif
 	{
 	}
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2cb9cc9e0eff..5357ba7ea3c7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -79,6 +79,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
 #include <asm/fpsimd.h>
+#include <asm/hwcap.h>
 #include <asm/insn.h>
 #include <asm/kvm_host.h>
 #include <asm/mmu_context.h>
@@ -1921,6 +1922,14 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 }
 #endif /* CONFIG_ARM64_MTE */
 
+static void elf_hwcap_fixup(void)
+{
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1742098))
+		compat_elf_hwcap2 &= ~COMPAT_HWCAP2_AES;
+#endif /* ARM64_ERRATUM_1742098 */
+}
+
 #ifdef CONFIG_KVM
 static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
 {
@@ -3033,8 +3042,10 @@ void __init setup_cpu_features(void)
 	setup_system_capabilities();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-	if (system_supports_32bit_el0())
+	if (system_supports_32bit_el0()) {
 		setup_elf_hwcaps(compat_elf_hwcaps);
+		elf_hwcap_fixup();
+	}
 
 	if (system_uses_ttbr0_pan())
 		pr_info("emulated: Privileged Access Never (PAN) using TTBR0_EL1 switching\n");
@@ -3086,6 +3097,7 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
 							 cpu_active_mask);
 	get_cpu_device(lucky_winner)->offline_disabled = true;
 	setup_elf_hwcaps(compat_elf_hwcaps);
+	elf_hwcap_fixup();
 	pr_info("Asymmetric 32-bit EL0 support detected on CPU %u; CPU hot-unplug disabled on CPU %u\n",
 		cpu, lucky_winner);
 	return 0;
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 3ed418f70e3b..8cd6088f8875 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -58,6 +58,7 @@ WORKAROUND_1418040
 WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
+WORKAROUND_1742098
 WORKAROUND_1902691
 WORKAROUND_2038923
 WORKAROUND_2064142
-- 
2.35.1



