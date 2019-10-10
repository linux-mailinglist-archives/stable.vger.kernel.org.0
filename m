Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD84D24A0
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbfJJIsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389651AbfJJIsa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:48:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B54632064A;
        Thu, 10 Oct 2019 08:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697310;
        bh=8/k19fIZ0kkjZNWVifZ4eztuH6N6F6LNK7/z2zqspQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iP8jm4F8iUj1sU2k2cOVgqnpqWlStKjmZBuX7ppedxWW1X+L/kry5KaSpGxln9uBM
         sD9ylUVby2ZOPqwJIOVJEs9foRtyFlqGZGD1l+CXI9mmbVWejz11carR8lUrXkvZv2
         WWw2m1/GmjNdJVFXj72ECgvBopwkdPqZL52D0bFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.19 096/114] arm64: Always enable ssb vulnerability detection
Date:   Thu, 10 Oct 2019 10:36:43 +0200
Message-Id: <20191010083613.231594675@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/cpufeature.h |    4 ----
 arch/arm64/kernel/cpu_errata.c      |    9 +++++----
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -525,11 +525,7 @@ static inline int arm64_get_ssbd_state(v
 #endif
 }
 
-#ifdef CONFIG_ARM64_SSBD
 void arm64_set_ssbd_mitigation(bool state);
-#else
-static inline void arm64_set_ssbd_mitigation(bool state) {}
-#endif
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -239,7 +239,6 @@ enable_smccc_arch_workaround_1(const str
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
-#ifdef CONFIG_ARM64_SSBD
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
 int ssbd_state __read_mostly = ARM64_SSBD_KERNEL;
@@ -312,6 +311,11 @@ void __init arm64_enable_wa2_handling(st
 
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
@@ -431,7 +435,6 @@ out_printmsg:
 
 	return required;
 }
-#endif	/* CONFIG_ARM64_SSBD */
 
 #ifdef CONFIG_ARM64_ERRATUM_1463225
 DEFINE_PER_CPU(int, __in_cortex_a76_erratum_1463225_wa);
@@ -710,14 +713,12 @@ const struct arm64_cpu_capabilities arm6
 		ERRATA_MIDR_RANGE_LIST(arm64_harden_el2_vectors),
 	},
 #endif
-#ifdef CONFIG_ARM64_SSBD
 	{
 		.desc = "Speculative Store Bypass Disable",
 		.capability = ARM64_SSBD,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = has_ssbd_mitigation,
 	},
-#endif
 #ifdef CONFIG_ARM64_ERRATUM_1463225
 	{
 		.desc = "ARM erratum 1463225",


