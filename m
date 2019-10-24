Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5DBE32E0
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbfJXMtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54015 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502106AbfJXMtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:24 -0400
Received: by mail-wm1-f67.google.com with SMTP id n7so1869288wmc.3
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wubb1ptsFBR4ICvsyB8Sd/a3awDMFWJa2cfELdT8mrQ=;
        b=swN6qyo8WVfacyJYM2pvx9heguZ0jS9+KlhIPKGz5EFZhzRCoKkF7ytQera+0Pp1lH
         JsbjPaXak16OSuy8AF0Q4O32jZ5PdfLm5c7lxVd2cO0U9JZkLLei4B1/H+S5SV6zopIO
         NJPGJDONGlD4w+SOR3sPHnTHxx5DlGdPDee6FaR171uhCQEE563spiliz2msodP9iemb
         zZR8Zt5oe+UijhEIFvdij/2+C2IwxdhF0vQ0X/uE1Z6OfHgxYTjKc/UKWuEC+TyJtR9z
         NxcAkoWujFqJbGmczX9OP+0Tmk2cYcPYA4qSqL5EUL1+jl+dmCnHtDqzPTa0CPmsAhAi
         vohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wubb1ptsFBR4ICvsyB8Sd/a3awDMFWJa2cfELdT8mrQ=;
        b=Ryvm2km3tpt4ksq92yO8/cXi84aNH1cHAKvinXoHESiUU9azfGghgnNb9trF9dE4Hi
         +MNkJrG/QTPzmO+s4Q+Gw+VJb1V2+mwFTJgMYE0PhPP/VPUsZsCUAc7RFqaDJgsLB8UK
         fWn7pWetTWyy8/LR00X2G1fxKmu8ozA5xJwI86WQBei88cKoWwSz/8ZVDLerHdrSBDKX
         O5CeRpbglezLOPwqelEGIOcOzSp4fncW2Wfx6CDVB38a+csUEgQ6+738gl/4Zz3C3G+Z
         GODTgguRI2AzCtm6jxc+R+CkGlJ9f34XNcsz6WhW70ddO7ickPCcFuVArFPXKReEMQoC
         QFyQ==
X-Gm-Message-State: APjAAAV7xY0Ax484rdgCzShjYkIYpn7T02PBBuvbHb2HDkZV0P2ub9Bc
        IlVJPGpH1lC5vp2dqUyzuG62d1/pDIN4XBSa
X-Google-Smtp-Source: APXvYqxGfAP5rLPED9np9K50p6vhdZ3DfZ8aSeCRvIQjIlItmhb1kg6uvXQ8AMk57uATLW04jBVXhA==
X-Received: by 2002:a1c:6308:: with SMTP id x8mr4908868wmb.140.1571921361696;
        Thu, 24 Oct 2019 05:49:21 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:20 -0700 (PDT)
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
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@arm.com>
Subject: [PATCH for-stable-4.14 21/48] arm64: capabilities: Introduce weak features based on local CPU
Date:   Thu, 24 Oct 2019 14:48:06 +0200
Message-Id: <20191024124833.4158-22-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 5c137714dd8cae464dbd5f028c07af149e6d09fc ]

Now that we have the flexibility of defining system features based
on individual CPUs, introduce CPU feature type that can be detected
on a local SCOPE and ignores the conflict on late CPUs. This is
applicable for ARM64_HAS_NO_HW_PREFETCH, where it is fine for
the system to have CPUs without hardware prefetch turning up
later. We only suffer a performance penalty, nothing fatal.

Cc: Will Deacon <will.deacon@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/cpufeature.h | 8 ++++++++
 arch/arm64/kernel/cpufeature.c      | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index b19dd89bcce9..09825b667af0 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -235,6 +235,14 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
  */
 #define ARM64_CPUCAP_SYSTEM_FEATURE	\
 	(ARM64_CPUCAP_SCOPE_SYSTEM | ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU)
+/*
+ * CPU feature detected at boot time based on feature of one or more CPUs.
+ * All possible conflicts for a late CPU are ignored.
+ */
+#define ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE		\
+	(ARM64_CPUCAP_SCOPE_LOCAL_CPU		|	\
+	 ARM64_CPUCAP_OPTIONAL_FOR_LATE_CPU	|	\
+	 ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU)
 
 struct arm64_cpu_capabilities {
 	const char *desc;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f4d640dc7f8b..439cdca71024 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -959,7 +959,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Software prefetching using PRFM",
 		.capability = ARM64_HAS_NO_HW_PREFETCH,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
 		.matches = has_no_hw_prefetch,
 	},
 #ifdef CONFIG_ARM64_UAO
-- 
2.20.1

