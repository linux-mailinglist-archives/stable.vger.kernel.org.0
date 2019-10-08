Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56746CFDDB
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfJHPk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:26 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40807 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbfJHPk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:26 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so3610500wmj.5
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b980Hl78DxMdOTDWa2ywxLFA73lq8TP+ptHAnX2cLHA=;
        b=j1Q8gOGZWX7QaB9s7ddocqr1BtoUdBxNIAjtKQw7ZXf4UKEtQFazekJzePh7ajN8u5
         G91896HYqOqb/LdD0v4yUDRE1sxH0J0Cv6IDfwpb0uhnwVl7VYCx4O9VcPcz7GEBQWbN
         SFNyCqFejMTpqiA9Ld8nNGA8UA1TrqO1bCgsNx3TXp1YPmPbHt3YtooVZXodfytOXigx
         t0JeSzM5gLAzmYkH0Nu5vugApxhEHu7WN84OKH8mIMtPg5r2epaODTg5nRXznaZFlrkn
         gSwBwNA/LNGNWC4nghQyeH1DHUCBUdzJuhmI3wV5XzUlrMeRkqlGhbhtaC0iGnn+zTC5
         6DDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b980Hl78DxMdOTDWa2ywxLFA73lq8TP+ptHAnX2cLHA=;
        b=YfJrEprHsH03VooohwU2a4t3mnOJRyC3m3rx5FDW9mA07kEpcyXhb6HPnCBDFoIFcD
         LE9et0614rNVUMv2TxRdCvDJ737AjlrNeBwDMbEwI4X4BK4ZfIFXTHn2Ytlwdobs5vw+
         /rEkQ0xU9hNccmiTtmVXDSflwDacd8kzKlmbRFpv8JZmFG/HwcO/y5DQYGjt0MEjZ1N9
         0Ia71KTfSF1r5tuNzjhnB6A3TpUHXcAb2r3YsnHFUPt0OuTZ+6rUPkixqOfunELaduw0
         0lfz6ffJoetrPg+0PYhSc+MLAuunos+Zbwy3MvSKmePU1OpE5HBWL9vLfI66dB7XhQ6L
         oLug==
X-Gm-Message-State: APjAAAUrRdH4Swyj2eeWHiPlggP6/8rhbdxfXBHJrSEbAlhAhU3wLdLT
        pzhpv2dEZcbg93GyJtEwluC9Ug==
X-Google-Smtp-Source: APXvYqz4WQHhecRv6wwWxW5KE3SbodoqNVlR7VmmGzsAosNlNoMfbdslFUMpyIuBVBygb6tJOvxDtw==
X-Received: by 2002:a1c:a616:: with SMTP id p22mr4234707wme.3.1570549224904;
        Tue, 08 Oct 2019 08:40:24 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:23 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 12/16] arm64: Always enable spectre-v2 vulnerability detection
Date:   Tue,  8 Oct 2019 17:39:26 +0200
Message-Id: <20191008153930.15386-13-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
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
---
 arch/arm64/kernel/cpu_errata.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ffb1b8ff7d82..96b0319dd0d6 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -87,7 +87,6 @@ cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *__unused)
 
 atomic_t arm64_el2_vector_last_slot = ATOMIC_INIT(-1);
 
-#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
@@ -225,11 +224,11 @@ static int detect_harden_bp_fw(void)
 	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
 		cb = qcom_link_stack_sanitization;
 
-	install_bp_hardening_cb(cb, smccc_start, smccc_end);
+	if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR))
+		install_bp_hardening_cb(cb, smccc_start, smccc_end);
 
 	return 1;
 }
-#endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
@@ -513,7 +512,6 @@ multi_entry_cap_cpu_enable(const struct arm64_cpu_capabilities *entry)
 			caps->cpu_enable(caps);
 }
 
-#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 /*
  * List of CPUs that do not need any Spectre-v2 mitigation at all.
  */
@@ -545,6 +543,12 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
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
@@ -556,7 +560,6 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 
 	return (need_wa > 0);
 }
-#endif
 
 #ifdef CONFIG_HARDEN_EL2_VECTORS
 
@@ -715,13 +718,11 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
 #ifdef CONFIG_HARDEN_EL2_VECTORS
 	{
 		.desc = "EL2 vector hardening",
-- 
2.20.1

