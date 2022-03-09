Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDB94D330F
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbiCIQMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234649AbiCIQK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:10:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D3EC0842;
        Wed,  9 Mar 2022 08:09:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCA37B8222A;
        Wed,  9 Mar 2022 16:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C786C340E8;
        Wed,  9 Mar 2022 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842151;
        bh=z7p40pY35hoI0dlU3jaT5G+091WhUUE7jq8tnccKr70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZFv58tF6D0J7Eke3uoynW/zaIiy9Cl3BcVjdTJBjwignim97dAEeUcCIL+ywpjLE
         ZgYtu4BfqAiJNH+JaFlAq49fETk4HzOVsEMKwjClVuPruDBxmhJ8ZwhjxhldkeqmnR
         T4piA2l7aOg8lO8U9cJKqsLv95t2qZrgdis5qDas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
        Will Deacon <will@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.16 16/37] arm64: cpufeature: add HWCAP for FEAT_RPRES
Date:   Wed,  9 Mar 2022 17:00:17 +0100
Message-Id: <20220309155859.560502544@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
References: <20220309155859.086952723@linuxfoundation.org>
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

commit 1175011a7d0030d49dc9c10bde36f08f26d0a8ee upstream.

Add a new HWCAP to detect the Increased precision of Reciprocal Estimate
and Reciprocal Square Root Estimate feature (FEAT_RPRES), introduced in Armv8.7.

Also expose this to userspace in the ID_AA64ISAR2_EL1 feature register.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211210165432.8106-4-joey.gouly@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/cpu-feature-registers.rst |    8 ++++++++
 Documentation/arm64/elf_hwcaps.rst            |    4 ++++
 arch/arm64/include/asm/hwcap.h                |    1 +
 arch/arm64/include/uapi/asm/hwcap.h           |    1 +
 arch/arm64/kernel/cpufeature.c                |    2 ++
 arch/arm64/kernel/cpuinfo.c                   |    1 +
 6 files changed, 17 insertions(+)

--- a/Documentation/arm64/cpu-feature-registers.rst
+++ b/Documentation/arm64/cpu-feature-registers.rst
@@ -283,6 +283,14 @@ infrastructure:
      | AFP                          | [47-44] |    y    |
      +------------------------------+---------+---------+
 
+  9) ID_AA64ISAR2_EL1 - Instruction set attribute register 2
+
+     +------------------------------+---------+---------+
+     | Name                         |  bits   | visible |
+     +------------------------------+---------+---------+
+     | RPRES                        | [7-4]   |    y    |
+     +------------------------------+---------+---------+
+
 
 Appendix I: Example
 -------------------
--- a/Documentation/arm64/elf_hwcaps.rst
+++ b/Documentation/arm64/elf_hwcaps.rst
@@ -255,6 +255,10 @@ HWCAP2_AFP
 
     Functionality implied by ID_AA64MFR1_EL1.AFP == 0b0001.
 
+HWCAP2_RPRES
+
+    Functionality implied by ID_AA64ISAR2_EL1.RPRES == 0b0001.
+
 4. Unused AT_HWCAP bits
 -----------------------
 
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -107,6 +107,7 @@
 #define KERNEL_HWCAP_MTE		__khwcap2_feature(MTE)
 #define KERNEL_HWCAP_ECV		__khwcap2_feature(ECV)
 #define KERNEL_HWCAP_AFP		__khwcap2_feature(AFP)
+#define KERNEL_HWCAP_RPRES		__khwcap2_feature(RPRES)
 
 /*
  * This yields a mask that user programs can use to figure out what
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -77,5 +77,6 @@
 #define HWCAP2_MTE		(1 << 18)
 #define HWCAP2_ECV		(1 << 19)
 #define HWCAP2_AFP		(1 << 20)
+#define HWCAP2_RPRES		(1 << 21)
 
 #endif /* _UAPI__ASM_HWCAP_H */
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -226,6 +226,7 @@ static const struct arm64_ftr_bits ftr_i
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR2_RPRES_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
@@ -2490,6 +2491,7 @@ static const struct arm64_cpu_capabiliti
 #endif /* CONFIG_ARM64_MTE */
 	HWCAP_CAP(SYS_ID_AA64MMFR0_EL1, ID_AA64MMFR0_ECV_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_ECV),
 	HWCAP_CAP(SYS_ID_AA64MMFR1_EL1, ID_AA64MMFR1_AFP_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_AFP),
+	HWCAP_CAP(SYS_ID_AA64ISAR2_EL1, ID_AA64ISAR2_RPRES_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, KERNEL_HWCAP_RPRES),
 	{},
 };
 
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -96,6 +96,7 @@ static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_MTE]		= "mte",
 	[KERNEL_HWCAP_ECV]		= "ecv",
 	[KERNEL_HWCAP_AFP]		= "afp",
+	[KERNEL_HWCAP_RPRES]		= "rpres",
 };
 
 #ifdef CONFIG_COMPAT


