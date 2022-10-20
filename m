Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54CA606BD5
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 01:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJTXB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 19:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJTXBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 19:01:23 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6973F224AAB;
        Thu, 20 Oct 2022 16:01:20 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id m6so979828qkm.4;
        Thu, 20 Oct 2022 16:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Ss68oeVjSNzOcsMllP0f5zYE+iB5TWToxse54ZAi/w=;
        b=EfFuBnlgIpNAEFzDLsFlYj6tLtnuvxxkCtyKQmgzjrLC/cZGnlqQBmkYLRyMR0KRju
         eXeJfqJZVkp9to/6y17nnxWXjJYK4g8iPhqZ36ZeCys+YPR3A+wRwq4+tusMRK13UiSx
         CoAe0n30+l2aFTWR+IHm5dgthBdxJ5fEH4IKv4x7F9WgO2NGxhLKB30tB4CJnY2AJgcv
         +dGoBdNf9o5tB2ZjeloiQXGA62qiaf6ZjwKnRNqg/wSB149bybIHpTa+ApBZ0v5jWktc
         eJ17DkIeCC0/sY+RCzEuUDU6OKByI/rZ+Q6wa3BPh1JDMvgQGyI8f1K0YM28XMLv9gYl
         vseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Ss68oeVjSNzOcsMllP0f5zYE+iB5TWToxse54ZAi/w=;
        b=ptxHuvNDoDF/Wmfb2K8bXLXcDNg9w1cPWb403UNIz8qyNFUyqkM/Y7FuQc0mjeZ0PB
         0RgAeHBYk8GiF0oyTjvS0i4qUtaIjgbBmcBAL/nE79o3iXFnA/JqWpb+uWesgY1TLIm+
         Xb5ZX8bG4W35Vx45K6Eo0rybYRK6rGrQsBhc4yioKF2krhqIkYmH8GxTfkgRuvhRe9sB
         lyM4Bgj3D5SgYjTXQQ/mHELkvBax7RzoZSUI7RdYcSG+KS1DtvDXrMYO0sXb8wfNKaSI
         VfWR9EitbCaokYsXOi2NwDAdbIzKw5d0Pc21xI2wJOVTtkGeFAVva6HYzGvm8gRCzMHA
         O+lA==
X-Gm-Message-State: ACrzQf3YMNBuPV5vNxPQP9+Lo6m6fTjYhqIvZF+m2G1pLGIy5E0CzRae
        KUCjer7I4yC52U3ZVwl2GHur32IeFhZHtg==
X-Google-Smtp-Source: AMsMyM5BJthfx33YlHWe1JhJmOeD3TWgMR+fNFcQARPii5CJDtrt8HKakcw69QSb10Htg14yF6hlIQ==
X-Received: by 2002:a37:4247:0:b0:6e7:6992:93c4 with SMTP id p68-20020a374247000000b006e7699293c4mr11269993qka.696.1666306879002;
        Thu, 20 Oct 2022 16:01:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id de20-20020a05620a371400b006ef1a8f1b81sm669343qkb.5.2022.10.20.16.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 16:01:18 -0700 (PDT)
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
Subject: [PATCH stable 4.14] arm64: errata: Remove AES hwcap for COMPAT tasks
Date:   Thu, 20 Oct 2022 16:01:06 -0700
Message-Id: <20221020230110.1255660-2-f.fainelli@gmail.com>
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
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/arm64/silicon-errata.txt |  2 ++
 arch/arm64/Kconfig                     | 16 ++++++++++++++++
 arch/arm64/include/asm/cpucaps.h       |  3 ++-
 arch/arm64/kernel/cpu_errata.c         | 16 ++++++++++++++++
 arch/arm64/kernel/cpufeature.c         | 13 ++++++++++++-
 5 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
index 42f5672e8917..b03e9efa0e3b 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.txt
@@ -53,7 +53,9 @@ stable kernels.
 | ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075        |
 | ARM            | Cortex-A57      | #852523         | N/A                         |
 | ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220        |
+| ARM            | Cortex-A57      | #1742098        | ARM64_ERRATUM_1742098       |
 | ARM            | Cortex-A72      | #853709         | N/A                         |
+| ARM            | Cortex-A72      | #1655431        | ARM64_ERRATUM_1742098       |
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
 | ARM            | Cortex-A76      | #1188873        | ARM64_ERRATUM_1188873       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7605d2f00d55..9256c3456949 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -472,6 +472,22 @@ config ARM64_ERRATUM_1188873
 
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
index 20ca422eb094..d9f7a068a524 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -47,7 +47,8 @@
 #define ARM64_SSBS				27
 #define ARM64_WORKAROUND_1188873		28
 #define ARM64_SPECTRE_BHB			29
+#define ARM64_WORKAROUND_1742098		30
 
-#define ARM64_NCAPS				30
+#define ARM64_NCAPS				31
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ed627d44746a..40d05139398c 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -576,6 +576,14 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	return (need_wa > 0);
 }
 
+#ifdef CONFIG_ARM64_ERRATUM_1742098
+static struct midr_range broken_aarch32_aes[] = {
+	MIDR_RANGE(MIDR_CORTEX_A57, 0, 1, 0xf, 0xf),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
@@ -741,6 +749,14 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.matches = is_spectre_bhb_affected,
 		.cpu_enable = spectre_bhb_enable_mitigation,
 	},
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
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b6922f33d306..ceac57bdf4ca 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -30,6 +30,7 @@
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
+#include <asm/hwcap.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
 #include <asm/sysreg.h>
@@ -1010,6 +1011,14 @@ static void cpu_enable_ssbs(const struct arm64_cpu_capabilities *__unused)
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
@@ -1588,8 +1597,10 @@ void __init setup_cpu_features(void)
 	mark_const_caps_ready();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
 
-	if (system_supports_32bit_el0())
+	if (system_supports_32bit_el0()) {
 		setup_elf_hwcaps(compat_elf_hwcaps);
+		elf_hwcap_fixup();
+	}
 
 	/* Advertise that we have computed the system capabilities */
 	set_sys_caps_initialised();
-- 
2.25.1

