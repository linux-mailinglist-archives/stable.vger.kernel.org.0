Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55A1E32D1
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfJXMtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46692 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbfJXMtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id n15so15143788wrw.13
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W9cyx4ZcSl1HV7/CM+Hbtgyy3aRPrRUejWESh8u2Kic=;
        b=VT0sqCm4u8Z40XIYR4TZ6yZ8RBRzOlCkzwJrk7HOwW4qV+JPYefNpjjIM1fZ7VRxuc
         qZnEhxZjpWvghgOa5a4+7xPr6cW/gGyvs/XG8qZCIyV784crOf05Ng0pMAfrw3xJnRbs
         THCWGT3USGZOvcU/y8alEU7Igpk8kwXvmiy8RB/pHaTVqslr82fSs3bk9/pp82WrhCUI
         HL10myUiarLhEpHxD5msB+aoyN8fxuxwJ7bUyHxdBGebNe0PVZs/+37pxEo3uiI+xQJd
         Tk32yQvEyLfUc76NmzDEXIv7jBBUAjGKnMfKPpMSoJAPlBmHDn+LLQ2+9AGC0Gys8oE+
         q9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W9cyx4ZcSl1HV7/CM+Hbtgyy3aRPrRUejWESh8u2Kic=;
        b=TwzyrM94rXH4eSjlp8Ml19oXJ+DMD4lPYhb25jFt2IgckDWGTwX6M+wY3CQGlTQwkv
         BL3srq78iX3AHNiySTGUC18NbFk8gW3fnD/atZgQfeV0knlxsKPkKhOSqFcEkuhjbzVa
         vuvsVNj+vMFkNYbqYqiX/p4+6MLUZEfed8M1MGny+r/sE1eq4e3eURkVwouEJI3sBWnp
         PKUilrBv1zv2WPttBtURRGianTy9fzTjoZcHWlCNX5X/Qk9YTx68JFKxuYoPOp9poa+/
         RwOCz1RfAkH5JA1Y764QlKRH7cnUBiZevrnYnUaFacyIK5d1nWBy/0SkG5vFHSrqb2ic
         TQqA==
X-Gm-Message-State: APjAAAWAVf6zzhjKfSgjyBXGcaX0QOrOhtu1ScaAorv/8mFPv0GF/qGK
        kZzC3ibeRgAuKkIQ8vaJhUGmpJw8VM+4iUjz
X-Google-Smtp-Source: APXvYqzxJ3ZX6s2tSP+i/CjQCCBJ/Ud5bLR4OJCLWk0TFA/ivdz4ptUJCq3hMXtYZnbV183alFPHsw==
X-Received: by 2002:adf:fe81:: with SMTP id l1mr3608221wrr.165.1571921337977;
        Thu, 24 Oct 2019 05:48:57 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:48:56 -0700 (PDT)
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
        Dave Martin <dave.martin@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 07/48] arm64: move SCTLR_EL{1,2} assertions to <asm/sysreg.h>
Date:   Thu, 24 Oct 2019 14:47:52 +0200
Message-Id: <20191024124833.4158-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 1c312e84c2d71da4101754fa6118f703f7473e01 ]

Currently we assert that the SCTLR_EL{1,2}_{SET,CLEAR} bits are
self-consistent with an assertion in config_sctlr_el1(). This is a bit
unusual, since config_sctlr_el1() doesn't make use of these definitions,
and is far away from the definitions themselves.

We can use the CPP #error directive to have equivalent assertions in
<asm/sysreg.h>, next to the definitions of the set/clear bits, which is
a bit clearer and simpler.

At the same time, lets fill in the upper 32 bits for both registers in
their respective RES0 definitions. This could be a little nicer with
GENMASK_ULL(63, 32), but this currently lives in <linux/bitops.h>, which
cannot safely be included from assembly, as <asm/sysreg.h> can.

Note the when the preprocessor evaluates an expression for an #if
directive, all signed or unsigned values are treated as intmax_t or
uintmax_t respectively. To avoid ambiguity, we define explicitly define
the mask of all 64 bits.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/sysreg.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index eab67c2e2bb3..f0ce6ea6c6d8 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -315,7 +315,8 @@
 #define SCTLR_EL2_RES0	((1 << 6)  | (1 << 7)  | (1 << 8)  | (1 << 9)  | \
 			 (1 << 10) | (1 << 13) | (1 << 14) | (1 << 15) | \
 			 (1 << 17) | (1 << 20) | (1 << 21) | (1 << 24) | \
-			 (1 << 26) | (1 << 27) | (1 << 30) | (1 << 31))
+			 (1 << 26) | (1 << 27) | (1 << 30) | (1 << 31) | \
+			 (0xffffffffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL2		SCTLR_ELx_EE
@@ -331,9 +332,9 @@
 			 SCTLR_ELx_SA     | SCTLR_ELx_I    | SCTLR_ELx_WXN | \
 			 ENDIAN_CLEAR_EL2 | SCTLR_EL2_RES0)
 
-/* Check all the bits are accounted for */
-#define SCTLR_EL2_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL2_SET ^ SCTLR_EL2_CLEAR) != ~0)
-
+#if (SCTLR_EL2_SET ^ SCTLR_EL2_CLEAR) != 0xffffffffffffffff
+#error "Inconsistent SCTLR_EL2 set/clear bits"
+#endif
 
 /* SCTLR_EL1 specific flags. */
 #define SCTLR_EL1_UCI		(1 << 26)
@@ -352,7 +353,8 @@
 #define SCTLR_EL1_RES1	((1 << 11) | (1 << 20) | (1 << 22) | (1 << 28) | \
 			 (1 << 29))
 #define SCTLR_EL1_RES0  ((1 << 6)  | (1 << 10) | (1 << 13) | (1 << 17) | \
-			 (1 << 21) | (1 << 27) | (1 << 30) | (1 << 31))
+			 (1 << 21) | (1 << 27) | (1 << 30) | (1 << 31) | \
+			 (0xffffffffUL << 32))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL1		(SCTLR_EL1_E0E | SCTLR_ELx_EE)
@@ -371,8 +373,9 @@
 			 SCTLR_EL1_UMA | SCTLR_ELx_WXN     | ENDIAN_CLEAR_EL1 |\
 			 SCTLR_EL1_RES0)
 
-/* Check all the bits are accounted for */
-#define SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != ~0)
+#if (SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != 0xffffffffffffffff
+#error "Inconsistent SCTLR_EL1 set/clear bits"
+#endif
 
 /* id_aa64isar0 */
 #define ID_AA64ISAR0_TS_SHIFT		52
@@ -585,9 +588,6 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
 {
 	u32 val;
 
-	SCTLR_EL2_BUILD_BUG_ON_MISSING_BITS;
-	SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS;
-
 	val = read_sysreg(sctlr_el1);
 	val &= ~clear;
 	val |= set;
-- 
2.20.1

