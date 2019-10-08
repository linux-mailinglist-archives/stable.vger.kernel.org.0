Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11087CFDD8
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfJHPkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51294 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfJHPkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so3708610wme.1
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aJGOLVfKZPZGTS15lL718TKBd/G+fSNNirhyvUJGpm8=;
        b=l2aVq144mzxKvDDYP57RsaNlrigk/Q2WA76VZfGwyCvgw8GKzbafZgH3b0V6LPq3M6
         oQDZ6hxkT3QX6l91ulPrtlgKV5c2QRV5BXT3e7gg8SVPHXY9xrV6d+90/6s4vaJ3jYYi
         T+pwwOs0EnE0rq7kE+g3TD4dxHzjDO/963hI9q9weq8fxHWW6yi1bdH+HOGLiXh6pd+8
         J0uMoay5HLXnb7etduO1dNs5OIQVeX1tu9bpmo7cQ+iUg/1rSz61ThYqT6StPxPZ07bd
         2gKpmkdu96Xe2ds8fM01TWoJiZtDuE3RrM3UKg/+/dcO4iwPzoFx34onlW+WTNR0C0wE
         XCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aJGOLVfKZPZGTS15lL718TKBd/G+fSNNirhyvUJGpm8=;
        b=HdP63KUoQf6yLcedBT66Lcf/esvjsMEdngrJcNIY/XcnoxUtmDpe9Y+hEwZnPo3gSh
         eNUYE9ji0aAetXEdRzuRIYQ+qh2a3Pc17Cobe0dNFO8/8GPjSG/JDx63WOqn0SH/uvjb
         Dh9A0NFmn7ioCGxukCM9gbjaYZZdpyaKF+tWeIgU7GCHRKdNDfuDtrTv+R6Ze44KjZxQ
         Ql5EqSKQKHZd49r+Tz6tiONEhu/EcN0Tb/tHL2q3iywT4ziv+SMbDZBqDp0SqWrU14xP
         hByQxySfneTKOC8Bk5D7lPcmD+/kYEYDg7RbLiaDNMGuSFnOExpkThCiNhLZveHCkAHW
         u14g==
X-Gm-Message-State: APjAAAVl7ybc8k6MxHYvJLBOM0Om1vJEoRkoYaLNHUiKBlVfmTPVo2yE
        pQtCVBefcydJ63uE8yhL840Q0g==
X-Google-Smtp-Source: APXvYqxy3RXGYr/IcrandtO0JayzzW0Qt9XQbDMwHo0KQINwYZ48x1SsCwsu/jJpNLguWNJgri2CXw==
X-Received: by 2002:a05:600c:cd:: with SMTP id u13mr4038224wmm.37.1570549219399;
        Tue, 08 Oct 2019 08:40:19 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 09/16] arm64: Always enable ssb vulnerability detection
Date:   Tue,  8 Oct 2019 17:39:23 +0200
Message-Id: <20191008153930.15386-10-ard.biesheuvel@linaro.org>
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
index 510f687d269a..dda6e5056810 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -525,11 +525,7 @@ static inline int arm64_get_ssbd_state(void)
 #endif
 }
 
-#ifdef CONFIG_ARM64_SSBD
 void arm64_set_ssbd_mitigation(bool state);
-#else
-static inline void arm64_set_ssbd_mitigation(bool state) {}
-#endif
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 3758ba538a43..10571a378f4c 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -239,7 +239,6 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 }
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
-#ifdef CONFIG_ARM64_SSBD
 DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 
 int ssbd_state __read_mostly = ARM64_SSBD_KERNEL;
@@ -312,6 +311,11 @@ void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 
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
@@ -431,7 +435,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 
 	return required;
 }
-#endif	/* CONFIG_ARM64_SSBD */
 
 #ifdef CONFIG_ARM64_ERRATUM_1463225
 DEFINE_PER_CPU(int, __in_cortex_a76_erratum_1463225_wa);
@@ -710,14 +713,12 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
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
-- 
2.20.1

