Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982DA60FE80
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbiJ0RFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbiJ0RFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:05:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668E0172501
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E9F2623F7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D5DC433C1;
        Thu, 27 Oct 2022 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890332;
        bh=WTGXMy8UxL+mjUGbEG9/qSzHStvoRQRmz8kkhWbVITw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBFTsWkULpFrOo6LBx2IINRDijHRbK0jK7A/eqNaqavYlvm+cH9+50X5ai5jjEUIi
         pZP+jluGRwfem5dic9eJGwHQyvcKsqxCi02+hQmmamO7KTxsO6h81Cd4v8IRZ2CH3z
         sVqkv46Sd8AHMHRIfI4jjSXcSvcgtwa4xoCeGytg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.10 23/79] arm64: errata: Remove AES hwcap for COMPAT tasks
Date:   Thu, 27 Oct 2022 18:55:33 +0200
Message-Id: <20221027165055.178261386@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 44b3834b2eed595af07021b1c64e6f9bc396398b upstream.

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
[florian: removed arch/arm64/tools/cpucaps and fixup cpufeature.c]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.rst |    4 ++++
 arch/arm64/Kconfig                     |   16 ++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |    3 ++-
 arch/arm64/kernel/cpu_errata.c         |   16 ++++++++++++++++
 arch/arm64/kernel/cpufeature.c         |   13 ++++++++++++-
 5 files changed, 50 insertions(+), 2 deletions(-)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -76,10 +76,14 @@ stable kernels.
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
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -481,6 +481,22 @@ config ARM64_ERRATUM_834220
 
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
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -68,7 +68,8 @@
 #define ARM64_WORKAROUND_1508412		58
 #define ARM64_SPECTRE_BHB			59
 #define ARM64_WORKAROUND_2457168		60
+#define ARM64_WORKAROUND_1742098		61
 
-#define ARM64_NCAPS				61
+#define ARM64_NCAPS				62
 
 #endif /* __ASM_CPUCAPS_H */
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -356,6 +356,14 @@ static const struct midr_range erratum_1
 };
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+static struct midr_range broken_aarch32_aes[] = {
+	MIDR_RANGE(MIDR_CORTEX_A57, 0, 1, 0xf, 0xf),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -555,6 +563,14 @@ const struct arm64_cpu_capabilities arm6
 		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+	{
+		.desc = "ARM erratum 1742098",
+		.capability = ARM64_WORKAROUND_1742098,
+		CAP_MIDR_RANGE_LIST(broken_aarch32_aes),
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+	},
+#endif
 	{
 	}
 };
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -76,6 +76,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
 #include <asm/fpsimd.h>
+#include <asm/hwcap.h>
 #include <asm/mmu_context.h>
 #include <asm/mte.h>
 #include <asm/processor.h>
@@ -1730,6 +1731,14 @@ static void cpu_enable_mte(struct arm64_
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
 /* Internal helper functions to match cpu capability type */
 static bool
 cpucap_late_cpu_optional(const struct arm64_cpu_capabilities *cap)
@@ -2735,8 +2744,10 @@ void __init setup_cpu_features(void)
 	setup_system_capabilities();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-	if (system_supports_32bit_el0())
+	if (system_supports_32bit_el0()) {
 		setup_elf_hwcaps(compat_elf_hwcaps);
+		elf_hwcap_fixup();
+	}
 
 	if (system_uses_ttbr0_pan())
 		pr_info("emulated: Privileged Access Never (PAN) using TTBR0_EL1 switching\n");


