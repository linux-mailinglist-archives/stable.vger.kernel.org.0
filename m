Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76BA7E32F5
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502138AbfJXMtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51563 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502116AbfJXMtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id q70so2716250wme.1
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LdRSYE/B2zZyj4GYwLgIZRcrtQeuNwcpngkcjVdOikI=;
        b=Ql9+27VRyTrnXNGq8jNjCfmnlUQLE1SGtCcYfUc+QU9L2ZN/dPuxHx508szK/LMPmZ
         FVvdAJkW46efXqHWmnic0VaFc6wA55IvgkexkFYhN4NmOpn/tcBV7T/C4/sRXI0NZ7fx
         ZUanksWRd0IZ+UfFxLij2LsVLRwNeCMB72alYYAliZn8cE7SHIM1NjYR4RbiORbWGIT+
         8oD3gls9gx1TiHYXD5OUztmzmKBCej/VxHCcwwCmSLIg/z5V73rUJbzaF5ZZ4JBjtkMK
         GpeUS3H4730VHKTtCEItO89rAwCQdmRX9gIa8UltAJ2gTmfsOVLRDYVcbZIc1OylQDWP
         avDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LdRSYE/B2zZyj4GYwLgIZRcrtQeuNwcpngkcjVdOikI=;
        b=Os/R2C/72PFqMdjxqViRdAnClO9S+9rveRdvIIgFm8+cRuYXzpucRaWKEFlAkjzeD4
         DAdEWmQO+LJuD294fzoFxqK2C3kr/mdqg44QIyn8OR5oy56tdQywOHsmkPSk0KAExe15
         yhJgDaAAclLnIPnMO3cjWhXW91shAyQ4LFa9EXXyxYPul1kuxMa5+VawlTGgOPXRosdT
         4ZNXjeiMzbRTYVB7Wgdh76SAFPvq2t+lSGxz/Zp8DrMa6J2q9vyvrMRAIeV8zSlfyOz2
         NQpMMg19RWsiXJykIS6eTkDEQdEe/az+cTh9jFS//f3Q66BhrYIxbrqWc2DAgT2U2WsX
         4KUQ==
X-Gm-Message-State: APjAAAVm3tx5iDxFi9Gp4B59EjnENWIhpqKKfPCTVYHlkWV9niYbyOjV
        2XPkcRpvvWaABLfEGNxsl88/4Ljcr9ahopjF
X-Google-Smtp-Source: APXvYqwKdy2g5pH9kCoS53aCM5MaHm15q7xyz4URinDbk0mRfkHU/T8/0vXV3/Bbl2my2H4WKyLSIg==
X-Received: by 2002:a7b:cb03:: with SMTP id u3mr4732904wmj.126.1571921390049;
        Thu, 24 Oct 2019 05:49:50 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:49 -0700 (PDT)
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
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 39/48] arm64: Always enable ssb vulnerability detection
Date:   Thu, 24 Oct 2019 14:48:24 +0200
Message-Id: <20191024124833.4158-40-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit d42281b6e49510f078ace15a8ea10f71e6262581 ]

Ensure we are always able to detect whether or not the CPU is affected
by SSB, so that we can later advertise this to userspace.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
[will: Use IS_ENABLED instead of #ifdef]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h | 4 ----
 arch/arm64/kernel/cpu_errata.c      | 9 +++++----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 9776c19d03d4..166f81b7afee 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -493,11 +493,7 @@ static inline int arm64_get_ssbd_state(void)
 #endif
 }
 
-#ifdef CONFIG_ARM64_SSBD
 void arm64_set_ssbd_mitigation(bool state);
-#else
-static inline void arm64_set_ssbd_mitigation(bool state) {}
-#endif
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 8b0a141bd01d..86c4f4e51427 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -231,7 +231,6 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
-#ifdef CONFIG_ARM64_SSBD
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
 int ssbd_state __read_mostly = ARM64_SSBD_KERNEL;
@@ -304,6 +303,11 @@ void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 
 void arm64_set_ssbd_mitigation(bool state)
 {
+	if (!IS_ENABLED(CONFIG_ARM64_SSBD)) {
+		pr_info_once("SSBD disabled by kernel configuration\n");
+		return;
+	}
+
 	if (this_cpu_has_cap(ARM64_SSBS)) {
 		if (state)
 			asm volatile(SET_PSTATE_SSBS(0));
@@ -423,7 +427,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	return required;
 }
-#endif	/* CONFIG_ARM64_SSBD */
 
 #define CAP_MIDR_RANGE(model, v_min, r_min, v_max, r_max)	\
 	.matches = is_affected_midr_range,			\
@@ -627,14 +630,12 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.cpu_enable = enable_smccc_arch_workaround_1,
 	},
 #endif
-#ifdef CONFIG_ARM64_SSBD
 	{
 		.desc = "Speculative Store Bypass Disable",
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.capability = ARM64_SSBD,
 		.matches = has_ssbd_mitigation,
 	},
-#endif
 	{
 	}
 };
-- 
2.20.1

