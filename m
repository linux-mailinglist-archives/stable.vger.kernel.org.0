Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBAB4EE84D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245457AbiDAGie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245448AbiDAGid (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:38:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F9318C0D5;
        Thu, 31 Mar 2022 23:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE278B81AF8;
        Fri,  1 Apr 2022 06:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204B3C2BBE4;
        Fri,  1 Apr 2022 06:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648795001;
        bh=GAvANzyYA+9K0Yc0MTlCfYFep6CxLTCmuC7AZmzCkd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewPTUyO2ygg2xewCapZCLG4AYxVFzKwSf0rxDjHZR8fVm+r4zHu2ObLQV4Jhw04BA
         JAEH3lcZhgHStPbJQLvxFJBdys3USNvJKeW7+Xk5jUt0dx78srn2rd/cgXDT6LV7B4
         i3L/jENjHKEyn2RxHpo6asLLEmcRaWCm82nBDs/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 01/27] arm64: arch_timer: Add workaround for ARM erratum 1188873
Date:   Fri,  1 Apr 2022 08:36:11 +0200
Message-Id: <20220401063624.274902998@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401063624.232282121@linuxfoundation.org>
References: <20220401063624.232282121@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit 95b861a4a6d94f64d5242605569218160ebacdbe upstream.

When running on Cortex-A76, a timer access from an AArch32 EL0
task may end up with a corrupted value or register. The workaround for
this is to trap these accesses at EL1/EL2 and execute them there.

This only affects versions r0p0, r1p0 and r2p0 of the CPU.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig                   |   12 ++++++++++++
 arch/arm64/include/asm/cpucaps.h     |    3 ++-
 arch/arm64/include/asm/cputype.h     |    2 ++
 arch/arm64/kernel/cpu_errata.c       |    8 ++++++++
 drivers/clocksource/arm_arch_timer.c |   15 +++++++++++++++
 5 files changed, 39 insertions(+), 1 deletion(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -458,6 +458,18 @@ config ARM64_ERRATUM_1024718
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_1188873
+	bool "Cortex-A76: MRC read following MRRC read of specific Generic Timer in AArch32 might give incorrect result"
+	default y
+	help
+	  This option adds work arounds for ARM Cortex-A76 erratum 1188873
+
+	  Affected Cortex-A76 cores (r0p0, r1p0, r2p0) could cause
+	  register corruption when accessing the timer registers from
+	  AArch32 userspace.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -45,7 +45,8 @@
 #define ARM64_SSBD				25
 #define ARM64_MISMATCHED_CACHE_TYPE		26
 #define ARM64_SSBS				27
+#define ARM64_WORKAROUND_1188873		28
 
-#define ARM64_NCAPS				28
+#define ARM64_NCAPS				29
 
 #endif /* __ASM_CPUCAPS_H */
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -87,6 +87,7 @@
 #define ARM_CPU_PART_CORTEX_A75		0xD0A
 #define ARM_CPU_PART_CORTEX_A35		0xD04
 #define ARM_CPU_PART_CORTEX_A55		0xD05
+#define ARM_CPU_PART_CORTEX_A76		0xD0B
 
 #define APM_CPU_PART_POTENZA		0x000
 
@@ -112,6 +113,7 @@
 #define MIDR_CORTEX_A75 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A75)
 #define MIDR_CORTEX_A35 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A35)
 #define MIDR_CORTEX_A55 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A55)
+#define MIDR_CORTEX_A76	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A76)
 #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
 #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
 #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -712,6 +712,14 @@ const struct arm64_cpu_capabilities arm6
 		.matches = has_ssbd_mitigation,
 		.midr_range_list = arm64_ssb_cpus,
 	},
+#ifdef CONFIG_ARM64_ERRATUM_1188873
+	{
+		/* Cortex-A76 r0p0 to r2p0 */
+		.desc = "ARM erratum 1188873",
+		.capability = ARM64_WORKAROUND_1188873,
+		ERRATA_MIDR_RANGE(MIDR_CORTEX_A76, 0, 0, 2, 0),
+	},
+#endif
 	{
 	}
 };
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -298,6 +298,13 @@ static u64 notrace arm64_858921_read_cnt
 }
 #endif
 
+#ifdef CONFIG_ARM64_ERRATUM_1188873
+static u64 notrace arm64_1188873_read_cntvct_el0(void)
+{
+	return read_sysreg(cntvct_el0);
+}
+#endif
+
 #ifdef CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND
 DEFINE_PER_CPU(const struct arch_timer_erratum_workaround *,
 	       timer_unstable_counter_workaround);
@@ -381,6 +388,14 @@ static const struct arch_timer_erratum_w
 		.read_cntvct_el0 = arm64_858921_read_cntvct_el0,
 	},
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_1188873
+	{
+		.match_type = ate_match_local_cap_id,
+		.id = (void *)ARM64_WORKAROUND_1188873,
+		.desc = "ARM erratum 1188873",
+		.read_cntvct_el0 = arm64_1188873_read_cntvct_el0,
+	},
+#endif
 };
 
 typedef bool (*ate_match_fn_t)(const struct arch_timer_erratum_workaround *,


