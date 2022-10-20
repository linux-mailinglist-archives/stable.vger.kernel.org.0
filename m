Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E944606BD9
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 01:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJTXBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 19:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJTXBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 19:01:25 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A52B224A99;
        Thu, 20 Oct 2022 16:01:23 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id s17so943644qkj.12;
        Thu, 20 Oct 2022 16:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7QZvPvCxEhu7aitvrhTnFQy1p76C1y/0hTZTgoD/Edc=;
        b=FyfMfjc5VRzTp+1xVF34JueDogQfjyG+DTCcd1Rh4jukrEW2+EFkqC2eBsr5pj+DFc
         11g7+ExAUjU21dqiSOJMusY646OfOaCtdrdbBJVvtQuks4+jaAcE6Ox1otBtKdl8hx6I
         1Eu3eMPto+Ry0sTzmng94F7e+T7eQciTKNnmmn9RkCv5ks9p1vdmTNZPbxvghkXaplQ8
         eWn6aPBPk1FhBrujl4Ua4hb2+Yvz1PGAWChF6zst6WN20dNj/AC5Nyav2JQraKDL+s/X
         NbLXtwEBg3KMqrBMTj1pAVllZ65fYTSi2pjXUVmxZV5iNnmHzqWugzNXGAIP1zKJUdPW
         GBjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7QZvPvCxEhu7aitvrhTnFQy1p76C1y/0hTZTgoD/Edc=;
        b=fL3ViV0lG7ylXTcZZ785KEBkDSKCNKh0fSMf4RRCOKKvBpp1iqXQMoflkdHpbXiNr2
         EfdYsobVYrqpMxLdFsOHkXr7TeMwQkgtz1n+01GY6yb89LOpCDvw32aulOEU44FE03kT
         E6fBHQvztUl2oigRf2Bh0SaiUBSzyo0h+zDkx2UJ5OlvbzmrnSSTFocetQLiqgoMDDHW
         zCuG5MufsMkvpS7PVl6Hf5t/IouciOsFwfx2NbI39hE7ZXKc5q69w5qsB+swgXVC6zgQ
         01TaY5G0koeHx0TgTuApBqWQELW51oK46BN/C04Jn8uBmLxl/CO6r9uNUdVYPV6aMs/8
         feew==
X-Gm-Message-State: ACrzQf1O64OWvXsMytxgLTW0mw9WAfYhqrdNFyoOFUyNgKEEyAkXVG6K
        maGvLC1X6uThaiZ10giL68ERACYXFMcuPQ==
X-Google-Smtp-Source: AMsMyM5sA5gIKRwX+iPEwbAGAE+qLn4RsbFmuBuZ3qgP6wq7BC5Ha7+NJroKmkvRNeCmMXowktluig==
X-Received: by 2002:a05:620a:244e:b0:6c6:f3b8:9c3 with SMTP id h14-20020a05620a244e00b006c6f3b809c3mr11467057qkn.218.1666306881711;
        Thu, 20 Oct 2022 16:01:21 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id de20-20020a05620a371400b006ef1a8f1b81sm669343qkb.5.2022.10.20.16.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 16:01:21 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ionela Voinescu <ionela.voinescu@arm.com>,
        Shreyas K K <quic_shrekk@quicinc.com>,
        Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT
        (AARCH64 ARCHITECTURE)),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 4.19] arm64: errata: Remove AES hwcap for COMPAT tasks
Date:   Thu, 20 Oct 2022 16:01:07 -0700
Message-Id: <20221020230110.1255660-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221020230110.1255660-1-f.fainelli@gmail.com>
References: <20221020230110.1255660-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 44b3834b2eed595af07021b1c64e6f9bc396398b upstream

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
Change-Id: I651a0db2e9d2f304d210ae979ae586e7dcc9744d
---
 Documentation/arm64/silicon-errata.txt |  2 ++
 arch/arm64/Kconfig                     | 16 ++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         | 17 +++++++++++++++++
 arch/arm64/kernel/cpufeature.c         | 13 ++++++++++++-
 5 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 667ea906266e..5329e3e00e04 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -55,7 +55,9 @@ stable kernels.
 | ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075        |
 | ARM            | Cortex-A57      | #852523         | N/A                         |
 | ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220        |
+| ARM            | Cortex-A57      | #1742098        | ARM64_ERRATUM_1742098       |
 | ARM            | Cortex-A72      | #853709         | N/A                         |
+| ARM            | Cortex-A72      | #1655431        | ARM64_ERRATUM_1742098       |
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
 | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a101f5d2fbed..e16f0d45b47a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -515,6 +515,22 @@ config ARM64_ERRATUM_1542419
 
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
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 64ae14371cae..61fd28522d74 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -55,7 +55,8 @@
 #define ARM64_SSBS				34
 #define ARM64_WORKAROUND_1542419		35
 #define ARM64_SPECTRE_BHB			36
+#define ARM64_WORKAROUND_1742098		37
 
-#define ARM64_NCAPS				37
+#define ARM64_NCAPS				38
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index d0b7dd60861b..5435550d1c9b 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -683,6 +683,15 @@ static const struct midr_range arm64_harden_el2_vectors[] = {
 
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+static struct midr_range broken_aarch32_aes[] = {
+	MIDR_RANGE(MIDR_CORTEX_A57, 0, 1, 0xf, 0xf),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+	{},
+};
+#endif
+
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
@@ -883,6 +892,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = has_neoverse_n1_erratum_1542419,
 		.cpu_enable = cpu_enable_trap_ctr_access,
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
index 03b0fdccaf05..d7e73a7963d1 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -31,6 +31,7 @@
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
 #include <asm/fpsimd.h>
+#include <asm/hwcap.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
 #include <asm/sysreg.h>
@@ -1154,6 +1155,14 @@ static void cpu_enable_ssbs(const struct arm64_cpu_capabilities *__unused)
 }
 #endif /* CONFIG_ARM64_SSBD */
 
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
@@ -1802,8 +1811,10 @@ void __init setup_cpu_features(void)
 	mark_const_caps_ready();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-	if (system_supports_32bit_el0())
+	if (system_supports_32bit_el0()) {
 		setup_elf_hwcaps(compat_elf_hwcaps);
+		elf_hwcap_fixup();
+	}
 
 	if (system_uses_ttbr0_pan())
 		pr_info("emulated: Privileged Access Never (PAN) using TTBR0_EL1 switching\n");
-- 
2.25.1

