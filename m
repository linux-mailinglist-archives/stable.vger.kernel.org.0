Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D595A4D33B6
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiCIQLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiCIQJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0780B1470C4;
        Wed,  9 Mar 2022 08:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00480B82224;
        Wed,  9 Mar 2022 16:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AC6C36AE2;
        Wed,  9 Mar 2022 16:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842027;
        bh=QdtSi/Doybz5un3fgzCVDkxmY7jN+aTKxr9KnUbl8UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDlfLmGtL0/Af7Ve/qaPJ+WOkF4zkTtFHcJrZLL2fVdD3QeJp5pi9crXAIKlg4vLL
         iwlz1AFTb+wdzKh4VYKYYz3t3cZIei+kbu7u4OSp5Cq6N2a19OUjwOcSeO2JKr1ksd
         A8vud6fmXp98Cps2ld7jGuujtS2R5hsIvisklpTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 16/43] arm64: Add HWCAP for self-synchronising virtual counter
Date:   Wed,  9 Mar 2022 17:00:00 +0100
Message-Id: <20220309155900.208244845@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
References: <20220309155859.734715884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit fee29f008aa3f2aff01117f28b57b1145d92cb9b upstream.

Since userspace can make use of the CNTVSS_EL0 instruction, expose
it via a HWCAP.

Suggested-by: Will Deacon <will@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211017124225.3018098-18-maz@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/cpu-feature-registers.rst |   12 ++++++++++--
 Documentation/arm64/elf_hwcaps.rst            |    4 ++++
 arch/arm64/include/asm/hwcap.h                |    1 +
 arch/arm64/include/uapi/asm/hwcap.h           |    1 +
 arch/arm64/kernel/cpufeature.c                |    3 ++-
 arch/arm64/kernel/cpuinfo.c                   |    1 +
 6 files changed, 19 insertions(+), 3 deletions(-)

--- a/Documentation/arm64/cpu-feature-registers.rst
+++ b/Documentation/arm64/cpu-feature-registers.rst
@@ -235,7 +235,15 @@ infrastructure:
      | DPB                          | [3-0]   |    y    |
      +------------------------------+---------+---------+
 
-  6) ID_AA64MMFR2_EL1 - Memory model feature register 2
+  6) ID_AA64MMFR0_EL1 - Memory model feature register 0
+
+     +------------------------------+---------+---------+
+     | Name                         |  bits   | visible |
+     +------------------------------+---------+---------+
+     | ECV                          | [63-60] |    y    |
+     +------------------------------+---------+---------+
+
+  7) ID_AA64MMFR2_EL1 - Memory model feature register 2
 
      +------------------------------+---------+---------+
      | Name                         |  bits   | visible |
@@ -243,7 +251,7 @@ infrastructure:
      | AT                           | [35-32] |    y    |
      +------------------------------+---------+---------+
 
-  7) ID_AA64ZFR0_EL1 - SVE feature ID register 0
+  8) ID_AA64ZFR0_EL1 - SVE feature ID register 0
 
      +------------------------------+---------+---------+
      | Name                         |  bits   | visible |
--- a/Documentation/arm64/elf_hwcaps.rst
+++ b/Documentation/arm64/elf_hwcaps.rst
@@ -247,6 +247,10 @@ HWCAP2_MTE
     Functionality implied by ID_AA64PFR1_EL1.MTE == 0b0010, as described
     by Documentation/arm64/memory-tagging-extension.rst.
 
+HWCAP2_ECV
+
+    Functionality implied by ID_AA64MMFR0_EL1.ECV == 0b0001.
+
 4. Unused AT_HWCAP bits
 -----------------------
 
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -105,6 +105,7 @@
 #define KERNEL_HWCAP_RNG		__khwcap2_feature(RNG)
 #define KERNEL_HWCAP_BTI		__khwcap2_feature(BTI)
 #define KERNEL_HWCAP_MTE		__khwcap2_feature(MTE)
+#define KERNEL_HWCAP_ECV		__khwcap2_feature(ECV)
 
 /*
  * This yields a mask that user programs can use to figure out what
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -75,5 +75,6 @@
 #define HWCAP2_RNG		(1 << 16)
 #define HWCAP2_BTI		(1 << 17)
 #define HWCAP2_MTE		(1 << 18)
+#define HWCAP2_ECV		(1 << 19)
 
 #endif /* _UAPI__ASM_HWCAP_H */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -279,7 +279,7 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr0[] = {
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_ECV_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_ECV_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_FGT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_EXS_SHIFT, 4, 0),
 	/*
@@ -2455,6 +2455,7 @@ static const struct arm64_cpu_capabiliti
 #ifdef CONFIG_ARM64_MTE
 	HWCAP_CAP(SYS_ID_AA64PFR1_EL1, ID_AA64PFR1_MTE_SHIFT, FTR_UNSIGNED, ID_AA64PFR1_MTE, CAP_HWCAP, KERNEL_HWCAP_MTE),
 #endif /* CONFIG_ARM64_MTE */
+	HWCAP_CAP(SYS_ID_AA64MMFR0_EL1, ID_AA64MMFR0_ECV_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_ECV),
 	{},
 };
 
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -94,6 +94,7 @@ static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_RNG]		= "rng",
 	[KERNEL_HWCAP_BTI]		= "bti",
 	[KERNEL_HWCAP_MTE]		= "mte",
+	[KERNEL_HWCAP_ECV]		= "ecv",
 };
 
 #ifdef CONFIG_COMPAT


