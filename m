Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA9ACE32CA
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfJXMsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:48:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34780 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbfJXMsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:48:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so20801568wrr.1
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p51eitRlLtzH/9CX6bwrfFXZZ5Vd1ugmjJwaokdInqg=;
        b=UhDWiWjSb8OJAGxPpXXhw7bR85FmgQoFBpLKYAIFSROTNwXPQPbTyBSkiEKxV++7Om
         qzhpPJ0WlS9izi36a1gFo/NlkRPpH8nN+1PBqvbW2kw07bC2jkQLrKVCQLwk29mC0a5b
         ZN9A+yGrRvzLsWj2ZuhxqcoZqjaiUNpbHQEjjNCotCGuh3yvCx9YTNq7uX1bQREoSylI
         KCMZ2EIcGy71QZ5TqpZPsvLZucEM6vSIyiC7vJLFSjsX09ROGJgRM78+FTfv1j++uSQ7
         /x34oZZ79gVTYcGRIoH6OzYYhWm6GZwFa4cnrz/rmM85veRcyLFQ1qglT2VvGZCtMSG0
         l71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p51eitRlLtzH/9CX6bwrfFXZZ5Vd1ugmjJwaokdInqg=;
        b=hZx1foMfM1vUa5GnE99IZ0/ygY4cjf/bPh+8JZj1ZWoeB3jRgNGBZHQ44b7WItzKu3
         UXmTv5DCikRj9bXua0uNhaNxY8ILYRtPcJh+5X9Zp8B5tV4UNqANZhVZ4dJqGHEspKL8
         X/XqrxsSqI9kiPOO0BmmNL8TxY8a0kcUVC+n5sIhzNLWyBwa49zJ/E5DOVd210eEmkI8
         MeC6+965Wt78z1Od7x5JBhz7aufaRMMka+EIFnGFKLiD4jsCwS4tSuw5lBcPdVvWjvR/
         MwiF64Lozf+z9/t5LA1ze3MkqvesqbQ6RDf8ma1liznHt5JuTccqZPzMw3/yZ4ld8kyI
         Y6Iw==
X-Gm-Message-State: APjAAAWFPL4ijV7kBYg0XihkO5lOWI4ucUn4Ahc+xpfJ0hWziieqrqUp
        L+Z/PMcMuaWMz65MWJLRsfyNUEYgXC2+ZlFf
X-Google-Smtp-Source: APXvYqzvE0jenaHVBGsKxbbgNauj09SE0LO11xm1F6X8DFi9pkvSlwOMQUR/HgLM5kUvzgylz3/M9Q==
X-Received: by 2002:a5d:4f91:: with SMTP id d17mr3813152wru.184.1571921333080;
        Thu, 24 Oct 2019 05:48:53 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:48:52 -0700 (PDT)
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
        Dongjiu Geng <gengdongjiu@huawei.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH for-stable-4.14 04/48] arm64: v8.4: Support for new floating point multiplication instructions
Date:   Thu, 24 Oct 2019 14:47:49 +0200
Message-Id: <20191024124833.4158-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongjiu Geng <gengdongjiu@huawei.com>

[ Upstream commit 3b3b681097fae73b7f5dcdd42db6cfdf32943d4c ]

ARM v8.4 extensions add new neon instructions for performing a
multiplication of each FP16 element of one vector with the corresponding
FP16 element of a second vector, and to add or subtract this without an
intermediate rounding to the corresponding FP32 element in a third vector.

This patch detects this feature and let the userspace know about it via a
HWCAP bit and MRS emulation.

Cc: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ardb: fix up for missing SVE in context]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 Documentation/arm64/cpu-feature-registers.txt | 4 +++-
 arch/arm64/include/asm/sysreg.h               | 1 +
 arch/arm64/include/uapi/asm/hwcap.h           | 2 ++
 arch/arm64/kernel/cpufeature.c                | 2 ++
 arch/arm64/kernel/cpuinfo.c                   | 2 ++
 5 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/cpu-feature-registers.txt b/Documentation/arm64/cpu-feature-registers.txt
index 011ddfc1e570..ddd566fea3f2 100644
--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.txt
@@ -110,7 +110,9 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
-     | RES0                         | [63-48] |    n    |
+     | RES0                         | [63-52] |    n    |
+     |--------------------------------------------------|
+     | FHM                          | [51-48] |    y    |
      |--------------------------------------------------|
      | DP                           | [47-44] |    y    |
      |--------------------------------------------------|
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 883999ce0bc7..ee4b7935155b 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -375,6 +375,7 @@
 #define SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != ~0)
 
 /* id_aa64isar0 */
+#define ID_AA64ISAR0_FHM_SHIFT		48
 #define ID_AA64ISAR0_DP_SHIFT		44
 #define ID_AA64ISAR0_SM4_SHIFT		40
 #define ID_AA64ISAR0_SM3_SHIFT		36
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index f243c57d1670..f018c3deea3b 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -42,5 +42,7 @@
 #define HWCAP_SM4		(1 << 19)
 #define HWCAP_ASIMDDP		(1 << 20)
 #define HWCAP_SHA512		(1 << 21)
+#define HWCAP_SVE		(1 << 22)
+#define HWCAP_ASIMDFHM		(1 << 23)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 50d6c9e1a654..258921542b00 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -107,6 +107,7 @@ cpufeature_pan_not_uao(const struct arm64_cpu_capabilities *entry, int __unused)
  * sync with the documentation of the CPU feature register ABI.
  */
 static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_FHM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_DP_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_SM4_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR0_SM3_SHIFT, 4, 0),
@@ -1052,6 +1053,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SM3_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SM3),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_SM4_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SM4),
 	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_DP_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDDP),
+	HWCAP_CAP(SYS_ID_AA64ISAR0_EL1, ID_AA64ISAR0_FHM_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_ASIMDFHM),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_FP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_FP_SHIFT, FTR_SIGNED, 1, CAP_HWCAP, HWCAP_FPHP),
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_ASIMD_SHIFT, FTR_SIGNED, 0, CAP_HWCAP, HWCAP_ASIMD),
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 1ff1c5a67081..67afe69efb61 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -74,6 +74,8 @@ static const char *const hwcap_str[] = {
 	"sm4",
 	"asimddp",
 	"sha512",
+	"sve",
+	"asimdfhm",
 	NULL
 };
 
-- 
2.20.1

