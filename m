Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72669606BDD
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 01:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiJTXBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 19:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiJTXBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 19:01:30 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A4522E0E1;
        Thu, 20 Oct 2022 16:01:29 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id h24so612689qta.7;
        Thu, 20 Oct 2022 16:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BiuxE9yFwVm7NsrNnLedWjIlS8ny2oqTYXHD4Bv+exM=;
        b=Ol3pvAo+Z9M/GTX7McxnnnInVJ5NZ/B3zErQQFahbpOzCDuyJ0ia7moEtW0qHlmlLA
         HMJeN5ZblgptYm8KZoqs0OEpbDamfQ/FsZqWG07na4w/nQ4cAlQSjZyJ5sZQGznw89gO
         9ENTWiQNjE0mBPGzWADatg5GDRZh51lSqR7JIX02BJzJ17WJGkuKXMmJ2ngN6BHarovK
         tRFB6tDx+tsm8fry297o676P4BDZOekwOueuRtCEIZj61KHFlHzqIPysY/QEdxLGkDdE
         bNKo/2klMOcGN+ngVF6Z+PbJBagxZhxASBEoBQmMxBPxd3sjy7i5Ml/gByc0CRFY6Ugn
         h07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BiuxE9yFwVm7NsrNnLedWjIlS8ny2oqTYXHD4Bv+exM=;
        b=Uc7JzbxuQ0LwKxUe84FGHGIV5hmadmD1YSf8QKu2bDqR3xU9e2GqdixYkIRGO3p1vq
         AoAIQwNgCwUwsR/Nr1efPm9XHXjX3Z7RH6275iyTKV5Ad9p5KaI300fgIWp1vDmBcYlL
         rMP1JXhEvVYuoL3M8qIz8/UnQtroH4Na0LTe/yD0jV8D1XsMK1rff5ZTYWflpHT1laqT
         /QZhenVmtVc2TNZaUEHZLLPJTowUw/l8shr+LPrxnJgxdMcUYVk86BHt7om0hdvvtYsa
         ptoXuWjmuGkGPiqY4TBKVmcVHHu/RnIE5wQsRcTOk6x1LmsvQpwQdHpkL8Dh6QiN3esF
         nyQg==
X-Gm-Message-State: ACrzQf3S38jDp/+7CNhpM8KVrK5t9WNCOVvfmZ+ftqNUtSyN0U4o2qw5
        XFf0oOTY4Z7AP1x9fBdzQbQd9oQ8fDp3kg==
X-Google-Smtp-Source: AMsMyM4WUtJQl7m3vz0MJ7nWXSHplPCTKSQ+0jRf8xAfiHaVu3JfJ+9kEIabRYQK18AKGqi64NSvYA==
X-Received: by 2002:ac8:7e8c:0:b0:39c:de52:a628 with SMTP id w12-20020ac87e8c000000b0039cde52a628mr13278648qtj.587.1666306887884;
        Thu, 20 Oct 2022 16:01:27 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id de20-20020a05620a371400b006ef1a8f1b81sm669343qkb.5.2022.10.20.16.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 16:01:27 -0700 (PDT)
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
Subject: [PATCH stable 5.10] arm64: errata: Remove AES hwcap for COMPAT tasks
Date:   Thu, 20 Oct 2022 16:01:09 -0700
Message-Id: <20221020230110.1255660-5-f.fainelli@gmail.com>
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
[florian: removed arch/arm64/tools/cpucaps and fixup cpufeature.c]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/arm64/silicon-errata.rst |  4 ++++
 arch/arm64/Kconfig                     | 16 ++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         | 16 ++++++++++++++++
 arch/arm64/kernel/cpufeature.c         | 13 ++++++++++++-
 5 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 22a07c208fee..4f3206495217 100644
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
index af65ab83e63d..34bd4cba81e6 100644
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
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 53030d3c03a2..d2080a41f6e6 100644
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
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index aaacca6fd52f..5d6f19bc628c 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -356,6 +356,14 @@ static const struct midr_range erratum_1463225[] = {
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
@@ -554,6 +562,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
index e72c90b82656..f3767c144593 100644
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
@@ -1730,6 +1731,14 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
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
-- 
2.25.1

