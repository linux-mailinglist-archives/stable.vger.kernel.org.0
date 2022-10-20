Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991A0606BE0
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 01:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJTXBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 19:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiJTXBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 19:01:40 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6610121E12E;
        Thu, 20 Oct 2022 16:01:33 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id x13so951607qkg.11;
        Thu, 20 Oct 2022 16:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ensfMWjP6WDQQvRRZyf5ciotg8ml8PMtToS4DhSaUU=;
        b=dmGRX6vVV+LUdcby0lyL4Ov4ZrPiWJYKTgcGiCakAGsAUsS1IlE/lL5KoFNjV0810s
         TAZ9skdtjtgEXhD2f9QR7Sdggz8kUFvinUC9CGjE/boFh4Dt1fEvIYsuORkOkai+IKUX
         WU2LQUkzPjCT1s4TPdLxQQZHdhTRwYqpTARMEm20ywoKoqCQFusBObfIhBwkEh7/qr7A
         CSbBJ6LqncVXlXlbLLI9XGDu89gNBR8c7DUImQ8lkkmyBgnugnhQ0nmgrPYG3zw6PlcH
         E2YuqH4dLTbHcRnPiGMNwedL7Zj1tGeEEWzOYJjp81ZN4XclNzEe8TfXSiJbaa8fRCoK
         NCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ensfMWjP6WDQQvRRZyf5ciotg8ml8PMtToS4DhSaUU=;
        b=LrWIfAxBwcxzqRAzp7XUCk5qPcA80SiohPzWFWnHIEgPUppDKvBwgN/j2TDMCIpnCZ
         tnIluUxxl6m1a6TPuwzhNKpv1vKDxKkLMMuMBNBJV2JHtFmS+lvaaLxa86To+boWD5Oa
         eSbUhwXKx/mkWTvvTxhbwX5ouqgtXH3vHYxj0wxyPyt0XhFmg6AuL0pcLdq72CHzEKMg
         rm9pcQw/d6NkeAkO8hTz5bMzg3uNQ2W4vpN2OYtrMc202bSAb4wizcg1Saixt2oS1SbD
         qB5hqJCMj1Rc/cTGHbNhwBovwmeW+KgLXYo09vsNWRzwoIh9f+9ReY1mdsrey/iKw814
         FJ7w==
X-Gm-Message-State: ACrzQf3HbGey/1wsInLln1ETqZuYJcGV3ci6ZqGW8FKXzRtmRcOJj7ZG
        sUL41kiNea2MgBFLt6PT+Tje++aTsbp6EQ==
X-Google-Smtp-Source: AMsMyM7rE8qrD+77nnVja71GMyDJoTxA0zeNS/FIG/QWHw24Eb1uZugzPcIrRYOTBSzFLIXa23uhPw==
X-Received: by 2002:a05:620a:30a:b0:6e7:ea38:cead with SMTP id s10-20020a05620a030a00b006e7ea38ceadmr11516133qkm.702.1666306891129;
        Thu, 20 Oct 2022 16:01:31 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id de20-20020a05620a371400b006ef1a8f1b81sm669343qkb.5.2022.10.20.16.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 16:01:30 -0700 (PDT)
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
Subject: [PATCH stable 5.15] arm64: errata: Remove AES hwcap for COMPAT tasks
Date:   Thu, 20 Oct 2022 16:01:10 -0700
Message-Id: <20221020230110.1255660-6-f.fainelli@gmail.com>
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
---
 Documentation/arm64/silicon-errata.rst |  4 ++++
 arch/arm64/Kconfig                     | 16 ++++++++++++++++
 arch/arm64/kernel/cpu_errata.c         | 16 ++++++++++++++++
 arch/arm64/kernel/cpufeature.c         | 14 +++++++++++++-
 arch/arm64/tools/cpucaps               |  1 +
 5 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 663001f69773..83e6f8c05d07 100644
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
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 24cce3b9ff1a..b1aa3d7e9fbe 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -487,6 +487,22 @@ config ARM64_ERRATUM_834220
 
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
index 25c495f58f67..c1e5c55664cb 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -350,6 +350,14 @@ static const struct midr_range erratum_1463225[] = {
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
@@ -559,6 +567,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		/* Cortex-A510 r0p0-r1p1 */
 		CAP_MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1)
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
index 3e52a9e8b50b..13e3cb1acbdf 100644
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
@@ -1915,6 +1916,14 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
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
@@ -2942,8 +2951,10 @@ void __init setup_cpu_features(void)
 	setup_system_capabilities();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-	if (system_supports_32bit_el0())
+	if (system_supports_32bit_el0()) {
 		setup_elf_hwcaps(compat_elf_hwcaps);
+		elf_hwcap_fixup();
+	}
 
 	if (system_uses_ttbr0_pan())
 		pr_info("emulated: Privileged Access Never (PAN) using TTBR0_EL1 switching\n");
@@ -2995,6 +3006,7 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
 							 cpu_active_mask);
 	get_cpu_device(lucky_winner)->offline_disabled = true;
 	setup_elf_hwcaps(compat_elf_hwcaps);
+	elf_hwcap_fixup();
 	pr_info("Asymmetric 32-bit EL0 support detected on CPU %u; CPU hot-unplug disabled on CPU %u\n",
 		cpu, lucky_winner);
 	return 0;
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index cfaffd3c8289..6b1e70aee8cf 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -54,6 +54,7 @@ WORKAROUND_1418040
 WORKAROUND_1463225
 WORKAROUND_1508412
 WORKAROUND_1542419
+WORKAROUND_1742098
 WORKAROUND_2457168
 WORKAROUND_CAVIUM_23154
 WORKAROUND_CAVIUM_27456
-- 
2.25.1

