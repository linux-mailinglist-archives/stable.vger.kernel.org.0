Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06008E6932
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfJ0Ven (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729659AbfJ0VKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:10:20 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F32920B7C;
        Sun, 27 Oct 2019 21:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210618;
        bh=tSqkmqnfXoX2DXObang/oy5lGOvr0Kq+arr3Bk2N6kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyX2DEOCCA+SqZ2oE9aA7WQNhJs9Z42WDet7Qez4AhpC5yebv6rtah3LAgzfNc6jt
         lYoIGh46LTJzpsAl19CaP9UKv1zMDLx7aZGds9iqrPrNxf3O4GXTh9IJCNz14AOhxM
         Qosb5DOneHWJTtYDwUpz9gnBvm11bJg+e61Nwc2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 078/119] arm64: Always enable spectre-v2 vulnerability detection
Date:   Sun, 27 Oct 2019 22:00:55 +0100
Message-Id: <20191027203344.153460145@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit 8c1e3d2bb44cbb998cb28ff9a18f105fee7f1eb3 ]

Ensure we are always able to detect whether or not the CPU is affected
by Spectre-v2, so that we can later advertise this to userspace.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -76,7 +76,6 @@ cpu_enable_trap_ctr_access(const struct
 	config_sctlr_el1(SCTLR_EL1_UCT, 0);
 }
 
-#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
@@ -217,11 +216,11 @@ static int detect_harden_bp_fw(void)
 	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
 		cb = qcom_link_stack_sanitization;
 
-	install_bp_hardening_cb(cb, smccc_start, smccc_end);
+	if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR))
+		install_bp_hardening_cb(cb, smccc_start, smccc_end);
 
 	return 1;
 }
-#endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
@@ -457,7 +456,6 @@ out_printmsg:
 	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
 	CAP_MIDR_RANGE_LIST(midr_list)
 
-#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 /*
  * List of CPUs that do not need any Spectre-v2 mitigation at all.
  */
@@ -489,6 +487,12 @@ check_branch_predictor(const struct arm6
 	if (!need_wa)
 		return false;
 
+	if (!IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR)) {
+		pr_warn_once("spectrev2 mitigation disabled by kernel configuration\n");
+		__hardenbp_enab = false;
+		return false;
+	}
+
 	/* forced off */
 	if (__nospectre_v2) {
 		pr_info_once("spectrev2 mitigation disabled by command line option\n");
@@ -500,7 +504,6 @@ check_branch_predictor(const struct arm6
 
 	return (need_wa > 0);
 }
-#endif
 
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
@@ -640,13 +643,11 @@ const struct arm64_cpu_capabilities arm6
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
 	},
 #endif
-#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = check_branch_predictor,
 	},
-#endif
 	{
 		.desc = "Speculative Store Bypass Disable",
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,


