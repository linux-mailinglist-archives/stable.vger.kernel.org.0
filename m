Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAFCE32F9
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730529AbfJXMt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:56 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35029 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502116AbfJXMt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id l10so25518211wrb.2
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y4Rlg795Au/yaRTHdwCVF+2ximfHs4bQpe3jQQMTOrQ=;
        b=lCSToq/XoX0YkieBRQCIHjZie9a8+XDRhAhfrgYYMmdHl+gJvGkhT/jGnHmeH2xk7A
         dFpr28jQjcPs5v689yhM1xKQQl0RBBn+iQvt00zYpia5XFe6LpWjoRgEm6WkRUpeaiYs
         SzhXsZf2lry0UU7FxgtTO1jt+5uvW9lDAoaepMXO/8Hmzxq0BRHm4vYrsutdQHCV/3iT
         gVJQu3JqumLNcCQHG4u3iq7VnC/dMKeZ89ZsvEiPswimSCcCHDh9AjeiDUOgQl2wM9jo
         XJ4aa5DtGPEPB43qqIJnCWNDToYBvre6Fkng116qZDqTKwVpOn9dPrybVnRMzKCb4KuQ
         kNcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y4Rlg795Au/yaRTHdwCVF+2ximfHs4bQpe3jQQMTOrQ=;
        b=JhhXxS4+Z0MskqQzLq/p8x6dGLOMwJ0eXBMzxKousV94151gDYSG/8/Grpi/+Z3Env
         VonJ3VvqTxTWhJGomnDXqGxoJDq94b0QfVlfkrrD1KWAck9zX7ZRv2aXAHY279nXO1Dp
         nEb+ESZmxrT/qt1B/C8Q+nQHUdlxzC9jnVHoxcSuc94yo0MuU1HQ2Z6frTr1w9DCAbh3
         IiZDA8vJIbCE+8XsN7qZGZYRs9s+1pRU2lAU4Qzf6EukgVyUIJsG4wQl4vcKUYxkwv9p
         NfQylhtcqTsJAHK07hSmtLhpf+3ZxmY5ny9hZEjApJwJ/aLMNOtTtPJWhVS7CTq8ijz3
         glxA==
X-Gm-Message-State: APjAAAXIYgjtN7tmHwHLflGjl8nLGE73nZMzN8hgQeKM3FF2gO1ky0yE
        +RlyHokHNI66PcjhnV22u+gD9oKvI9FtjxYe
X-Google-Smtp-Source: APXvYqzQVXS7Nb575Yymxh/i8RepquHuLAq55iZLvO6LB27sFhnUWcI5GCPeMGCFtIgp4vNj3FDDxw==
X-Received: by 2002:adf:828c:: with SMTP id 12mr3712308wrc.40.1571921394365;
        Thu, 24 Oct 2019 05:49:54 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:53 -0700 (PDT)
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
Subject: [PATCH for-stable-4.14 42/48] arm64: Always enable spectre-v2 vulnerability detection
Date:   Thu, 24 Oct 2019 14:48:27 +0200
Message-Id: <20191024124833.4158-43-ard.biesheuvel@linaro.org>
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
index bf6d8aa9b45a..647c533cfd90 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -76,7 +76,6 @@ cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *__unused)
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
 
@@ -457,7 +456,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
 	CAP_MIDR_RANGE_LIST(midr_list)
 
-#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 /*
  * List of CPUs that do not need any Spectre-v2 mitigation at all.
  */
@@ -489,6 +487,12 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
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
@@ -500,7 +504,6 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 
 	return (need_wa > 0);
 }
-#endif
 
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
@@ -640,13 +643,11 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
-- 
2.20.1

