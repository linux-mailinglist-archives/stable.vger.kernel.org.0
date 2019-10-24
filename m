Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5499E32C9
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfJXMsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:48:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39778 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbfJXMsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:48:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id r141so2472872wme.4
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+wdC7G7xcSAf6U40uHBNK5ddZXOwKGeSEOSGcQ5gt0=;
        b=FHTEGowvQb4EKp0yYWKe2p+vgP2N0wdDL7Ue8AXpe7qY3RsK0S2sjgHiYLZ37NP8Uq
         WnlJltmUH8qgeXqjyCOabuY8GR46r3q8CH3z8FLl8+U/c/idrEsWJnmWmhOnsrv0Nts2
         lcm3eDuNAWNuGtBnbmlQGL3M5ZLNaIsoaL9a09pbfO4/SLIqJI5S165JxCJQBi7tdt6H
         kYEOtDM8XCPxmLBMwv1drWfhSqID8OV8k8xghbeMBopioKXnT8s2WzGj7/Wc6JCH9Nz2
         bai8F5oVQhW3HzLrMOMHVoKpIS2Pq7I2YddsRHalrRG5chKx3nneiSBKPEEXOTTiS3yq
         Y1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+wdC7G7xcSAf6U40uHBNK5ddZXOwKGeSEOSGcQ5gt0=;
        b=JElG0mw5pQH8E6Rj5CZRxPzSudnWnqBeMn1RsyksYgqqfqF+Zv5NCMXyh7ktc4Bbgu
         RaATVMF/Ck0nO/9JmJfHxwNZNmbzB90GDBm+iHa8LIRs8sllx7cxA9TrU0w4YIGtm5Gr
         Z5kDvBNm4yUGF/MQKCCAUyawZfxBkAGdVieFMP1GvTAtiRkX6ZbF+ScviVRt3Sct2uZ4
         RSHr7NtagArZrWtrZThpoaQw1eTEUsYKmD8BO5xv+gvcshGJgq76FSdAxMLg0BEM5GB9
         oxmcURIWxdjIvJj7RPNyXrRUYKPuQ0PfA3OoLa1sEo8qi1P7oRwdGdJ68shau4sTV0oR
         KzZA==
X-Gm-Message-State: APjAAAXmWXMMYtyrlbAa6/pGVnG1Pbl5MFlL4y5n39riKQ1j3wzl2iM9
        WR0+a1hEFd7u9CcpzPHoG51Wt0rIpwHaDLw2
X-Google-Smtp-Source: APXvYqwTysAHms3hY7Su/j1Tp0DOn4pK1n4ROmeAK7Ml/HS3VMN8AL8ACbIAjA7BDUJ2z0Y6RioUjA==
X-Received: by 2002:a1c:20c9:: with SMTP id g192mr4451850wmg.74.1571921330045;
        Thu, 24 Oct 2019 05:48:50 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:48:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH for-stable-4.14 02/48] arm64: Expose support for optional ARMv8-A features
Date:   Thu, 24 Oct 2019 14:47:47 +0200
Message-Id: <20191024124833.4158-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit f5e035f8694c3bdddc66ea46ecda965ee6853718 ]

ARMv8-A adds a few optional features for ARMv8.2 and ARMv8.3.
Expose them to the userspace via HWCAPs and mrs emulation.

SHA2-512  - Instruction support for SHA512 Hash algorithm (e.g SHA512H,
	    SHA512H2, SHA512U0, SHA512SU1)
SHA3 	  - SHA3 crypto instructions (EOR3, RAX1, XAR, BCAX).
SM3	  - Instruction support for Chinese cryptography algorithm SM3
SM4 	  - Instruction support for Chinese cryptography algorithm SM4
DP	  - Dot Product instructions (UDOT, SDOT).

Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/arm64/cpu-feature-registers.txt | 12 +++++++++++-
 arch/arm64/include/asm/sysreg.h               |  4 ++++
 arch/arm64/include/uapi/asm/hwcap.h           |  5 +++++
 arch/arm64/kernel/cpufeature.c                |  9 +++++++++
 arch/arm64/kernel/cpuinfo.c                   |  5 +++++
 5 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/cpu-feature-registers.txt b/Documentation/arm64/cpu-feature-registers.txt
index dad411d635d8..011ddfc1e570 100644
--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.txt
@@ -110,10 +110,20 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
-     | RES0                         | [63-32] |    n    |
+     | RES0                         | [63-48] |    n    |
+     |--------------------------------------------------|
+     | DP                           | [47-44] |    y    |
+     |--------------------------------------------------|
+     | SM4                          | [43-40] |    y    |
+     |--------------------------------------------------|
+     | SM3                          | [39-36] |    y    |
+     |--------------------------------------------------|
+     | SHA3                         | [35-32] |    y    |
      |--------------------------------------------------|
      | RDM                          | [31-28] |    y    |
      |--------------------------------------------------|
+     | RES0                         | [27-24] |    n    |
+     |--------------------------------------------------|
      | ATOMICS                      | [23-20] |    y    |
      |--------------------------------------------------|
      | CRC32                        | [19-16] |    y    |
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index cd32a968ff5b..883999ce0bc7 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -375,6 +375,10 @@
 #define SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != ~0)
 
 /* id_aa64isar0 */
+#define ID_AA64ISAR0_DP_SHIFT		44
+#define ID_AA64ISAR0_SM4_SHIFT		40
+#define ID_AA64ISAR0_SM3_SHIFT		36
+#define ID_AA64ISAR0_SHA3_SHIFT		32
 #define ID_AA64ISAR0_RDM_SHIFT		28
 #define ID_AA64ISAR0_ATOMICS_SHIFT	20
 #define ID_AA64ISAR0_CRC32_SHIFT	16
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index b3fdeee739ea..f243c57d1670 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -37,5 +37,10 @@
 #define HWCAP_FCMA		(1 << 14)
 #define HWCAP_LRCPC		(1 << 15)
 #define HWCAP_DCPOP		(1 << 16)
+#define HWCAP_SHA3		(1 << 17)
+#define HWCAP_SM3		(1 << 18)
+#define HWCAP_SM4		(1 << 19)
+#define HWCAP_ASIMDDP		(1 << 20)
+#define HWCAP_SHA512		(1 << 21)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 57ec681a8f11..b7d00216b775 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -107,6 +107,10 @@ cpufeature_pan_not_uao(const struct arm64_cpu_capabilities *entry, int __unused)
  * sync with the documentation of the CPU feature register ABI.
  */
 static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_DP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_SM4_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_SM3_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_SHA3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, ID_AA64ISAR0_RDM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_ATOMICS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_CRC32_SHIFT, 4, 0),
@@ -1040,9 +1044,14 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_AES_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_AES),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA1_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SHA1),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA2_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SHA2),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA2_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_SHA512),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_CRC32_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_CRC32),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_ATOMICS_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_ATOMICS),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_RDM_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDRDM),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SHA3_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SHA3),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SM3_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SM3),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SM4_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SM4),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_DP_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDDP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_FP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 1, CAP_HWCAP, HWCAP_FPHP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_ASIMD_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_ASIMD),
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 311885962830..1ff1c5a67081 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -69,6 +69,11 @@ static const char *const hwcap_str[] = {
 	"fcma",
 	"lrcpc",
 	"dcpop",
+	"sha3",
+	"sm3",
+	"sm4",
+	"asimddp",
+	"sha512",
 	NULL
 };
 
-- 
2.20.1

