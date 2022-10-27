Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C6060FEE1
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiJ0RJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbiJ0RJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B9B1A20A1
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:09:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC6DF62369
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEB8C433D6;
        Thu, 27 Oct 2022 17:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890553;
        bh=GN9EgPZzYfdQ/rJP2Bci/0J9wZKu5dCE1RDDoQ/J6no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9BWe91KQYx8xvqWr47MpwruLEJ+kRkx2HrwwH5vSzmPKgYOTCi/SM8Qk0Oynktm6
         PYEXBRf1AiA4OK2/pYfPWl5JQuHLpUzZtlInONHp8NXZf5dIxudFl2obrBI0w7aLLm
         RjB+dtY8jxDDhHbI7KH2devnoBw7d8u991P+T6Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 35/53] arm64: errata: Remove AES hwcap for COMPAT tasks
Date:   Thu, 27 Oct 2022 18:56:23 +0200
Message-Id: <20221027165051.139646777@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
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
[florian: resolved conflicts in arch/arm64/tools/cpucaps and cpu_errata.c]
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
@@ -70,8 +70,12 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220        |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A57      | #1742098        | ARM64_ERRATUM_1742098       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A72      | #853709         | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A72      | #1655431        | ARM64_ERRATUM_1742098       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -574,6 +574,22 @@ config ARM64_ERRATUM_1542419
 
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
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -56,7 +56,8 @@
 #define ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM	46
 #define ARM64_WORKAROUND_1542419		47
 #define ARM64_SPECTRE_BHB			48
+#define ARM64_WORKAROUND_1742098		49
 
-#define ARM64_NCAPS				49
+#define ARM64_NCAPS				50
 
 #endif /* __ASM_CPUCAPS_H */
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -817,6 +817,14 @@ static const struct arm64_cpu_capabiliti
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
@@ -998,6 +1006,14 @@ const struct arm64_cpu_capabilities arm6
 		.cpu_enable = cpu_enable_trap_ctr_access,
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
@@ -21,6 +21,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
 #include <asm/fpsimd.h>
+#include <asm/hwcap.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
 #include <asm/sysreg.h>
@@ -1280,6 +1281,14 @@ static bool can_use_gic_priorities(const
 }
 #endif
 
+static void elf_hwcap_fixup(void)
+{
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1742098))
+		compat_elf_hwcap2 &= ~COMPAT_HWCAP2_AES;
+#endif /* ARM64_ERRATUM_1742098 */
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -2103,8 +2112,10 @@ void __init setup_cpu_features(void)
 	mark_const_caps_ready();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-	if (system_supports_32bit_el0())
+	if (system_supports_32bit_el0()) {
 		setup_elf_hwcaps(compat_elf_hwcaps);
+		elf_hwcap_fixup();
+	}
 
 	if (system_uses_ttbr0_pan())
 		pr_info("emulated: Privileged Access Never (PAN) using TTBR0_EL1 switching\n");


