Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF984D4A30
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245205AbiCJOeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344028AbiCJObh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46F4EBBA1;
        Thu, 10 Mar 2022 06:29:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8028DB82544;
        Thu, 10 Mar 2022 14:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C30C340E8;
        Thu, 10 Mar 2022 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922566;
        bh=pezTbvrAUyjM7VMeYCBywgxUbdV98O5aWCley147aIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlqiqu28XM2ALrcN/e3Q0mP1y9CNUTmlRxUUVJyDP8M8R0qEtMXEon3CHoxe03N03
         QIY7HbhsnqQXdSYLdRmfJ5PCDE/0gQ6XQAbdMm0jcjDuCMuYdbZ+eSbCn5qsmvnKxh
         x389uyTYp9CnnDHTs5PcyPNcs7M3zvAQJOUvX6uM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 20/58] arm64: cpufeature: add HWCAP for FEAT_AFP
Date:   Thu, 10 Mar 2022 15:19:09 +0100
Message-Id: <20220310140813.565349056@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
References: <20220310140812.983088611@linuxfoundation.org>
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

From: Joey Gouly <joey.gouly@arm.com>

commit 5c13f042e73200b50573ace63e1a6b94e2917616 upstream.

Add a new HWCAP to detect the Alternate Floating-point Behaviour
feature (FEAT_AFP), introduced in Armv8.7.

Also expose this to userspace in the ID_AA64MMFR1_EL1 feature register.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Will Deacon <will@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211210165432.8106-2-joey.gouly@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/cpu-feature-registers.rst |    9 +++++++++
 Documentation/arm64/elf_hwcaps.rst            |    4 ++++
 arch/arm64/include/asm/hwcap.h                |    1 +
 arch/arm64/include/asm/sysreg.h               |    1 +
 arch/arm64/include/uapi/asm/hwcap.h           |    1 +
 arch/arm64/kernel/cpufeature.c                |    2 ++
 arch/arm64/kernel/cpuinfo.c                   |    1 +
 7 files changed, 19 insertions(+)

--- a/Documentation/arm64/cpu-feature-registers.rst
+++ b/Documentation/arm64/cpu-feature-registers.rst
@@ -275,6 +275,15 @@ infrastructure:
      | SVEVer                       | [3-0]   |    y    |
      +------------------------------+---------+---------+
 
+  8) ID_AA64MMFR1_EL1 - Memory model feature register 1
+
+     +------------------------------+---------+---------+
+     | Name                         |  bits   | visible |
+     +------------------------------+---------+---------+
+     | AFP                          | [47-44] |    y    |
+     +------------------------------+---------+---------+
+
+
 Appendix I: Example
 -------------------
 
--- a/Documentation/arm64/elf_hwcaps.rst
+++ b/Documentation/arm64/elf_hwcaps.rst
@@ -251,6 +251,10 @@ HWCAP2_ECV
 
     Functionality implied by ID_AA64MMFR0_EL1.ECV == 0b0001.
 
+HWCAP2_AFP
+
+    Functionality implied by ID_AA64MFR1_EL1.AFP == 0b0001.
+
 4. Unused AT_HWCAP bits
 -----------------------
 
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -106,6 +106,7 @@
 #define KERNEL_HWCAP_BTI		__khwcap2_feature(BTI)
 #define KERNEL_HWCAP_MTE		__khwcap2_feature(MTE)
 #define KERNEL_HWCAP_ECV		__khwcap2_feature(ECV)
+#define KERNEL_HWCAP_AFP		__khwcap2_feature(AFP)
 
 /*
  * This yields a mask that user programs can use to figure out what
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -896,6 +896,7 @@
 #endif
 
 /* id_aa64mmfr1 */
+#define ID_AA64MMFR1_AFP_SHIFT		44
 #define ID_AA64MMFR1_ETS_SHIFT		36
 #define ID_AA64MMFR1_TWED_SHIFT		32
 #define ID_AA64MMFR1_XNX_SHIFT		28
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -76,5 +76,6 @@
 #define HWCAP2_BTI		(1 << 17)
 #define HWCAP2_MTE		(1 << 18)
 #define HWCAP2_ECV		(1 << 19)
+#define HWCAP2_AFP		(1 << 20)
 
 #endif /* _UAPI__ASM_HWCAP_H */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -329,6 +329,7 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_AFP_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_ETS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_TWED_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_XNX_SHIFT, 4, 0),
@@ -2465,6 +2466,7 @@ static const struct arm64_cpu_capabiliti
 	HWCAP_CAP(SYS_ID_AA64PFR1_EL1, ID_AA64PFR1_MTE_SHIFT, FTR_UNSIGNED, ID_AA64PFR1_MTE, CAP_HWCAP, KERNEL_HWCAP_MTE),
 #endif /* CONFIG_ARM64_MTE */
 	HWCAP_CAP(SYS_ID_AA64MMFR0_EL1, ID_AA64MMFR0_ECV_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_ECV),
+	HWCAP_CAP(SYS_ID_AA64MMFR1_EL1, ID_AA64MMFR1_AFP_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_AFP),
 	{},
 };
 
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -95,6 +95,7 @@ static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_BTI]		= "bti",
 	[KERNEL_HWCAP_MTE]		= "mte",
 	[KERNEL_HWCAP_ECV]		= "ecv",
+	[KERNEL_HWCAP_AFP]		= "afp",
 };
 
 #ifdef CONFIG_COMPAT


