Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB17A18D1
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfH2Lfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:55 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42120 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfH2Lfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id i30so1855161pfk.9
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cnuqc1YlBQBZ4RWPKzaqy9DfMXgSoNZrvvTdeydR7XY=;
        b=UW0U9Y3OlL4/ZWDPEju46rdxwml8mDN0UxCFmnIFo/YQkV2uhRP0t+uIqodnql6u2V
         1ckHackEhG9hAJ+7fxrL+E3+qKZ1cWunoBaOSO73zrDzNplJi9z8Uva5oNfJLgLi37xT
         w1vBojS/qypOb6b42DMHhTXnZCH6D7NC7PgH6boK0RGUIAmkXxGx6OPCTbSzoGvZdCHy
         4xFvdTRqcPkzaO75GxyUsD/H/jXqhlJFPj5hIh17jr35Usi/2RSdbWdanFaq1HF0MXFI
         orLuybSFG7NaslDzqzAhI+DcEn8FD/ieWNxys3Qms1s58zpH8eNREaBgGplq/JB1LaGs
         DNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cnuqc1YlBQBZ4RWPKzaqy9DfMXgSoNZrvvTdeydR7XY=;
        b=ujI2Hau//zRAE2QaqIbVCP4q+4n+mEqRv/nBGpo1BoEd40Z3hSHRiqAzyPc2rnhbz2
         28qV5zhKw+jtVWBA8GrWPNfhyz/vab+HzyvyqQRpuRljWLuJtM90NG94Z6jt2zb/piHU
         OTkAHBzUzUA4hya8+w0ZCAywI59oNmWX9nn0hRbd9d/k7vdV0FNSuG6YmKMGqM4MY4+f
         R+GSUsFat+sdHOUoqILmV1ibJtQkXiQfrND0XeuyYxkpGb6eYOCRSSCSMcwRA2I7ywWu
         dayx8Sw04IojC3ui5y9pzDUsa+eBrHrdc+j/x6aKqkb9gE9tUBYTukGwmE6jNVJfWhPF
         lH3w==
X-Gm-Message-State: APjAAAXQcvdNcEl8hHxv0BCHC5hmW0gQ/Q4qzGwNEPAbxo518att/4DC
        pkxVrLRNKyq8DcUgBk2SwY7x5Y7lyNY=
X-Google-Smtp-Source: APXvYqwwm+m6o5bMoS8vsjkvSeoR040ksprgpPha9EVwKi7nGz6noU/Qktg75x1VMEwAOzj0y+1NYw==
X-Received: by 2002:a63:7e1d:: with SMTP id z29mr7908601pgc.346.1567078554199;
        Thu, 29 Aug 2019 04:35:54 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id k25sm5873691pgt.53.2019.08.29.04.35.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:53 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 23/44] arm64: Factor out TTBR0_EL1 post-update workaround into a specific asm macro
Date:   Thu, 29 Aug 2019 17:04:08 +0530
Message-Id: <ed1d80904a0599cdca26d63eb63e89e55bcbf5f4.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit f33bcf03e6079668da6bf4eec4a7dcf9289131d0 upstream.

This patch takes the errata workaround code out of cpu_do_switch_mm into
a dedicated post_ttbr0_update_workaround macro which will be reused in a
subsequent patch.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: Included cpufeature.h and adapted to use alternative_if_not ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 18 ++++++++++++++++++
 arch/arm64/mm/proc.S               | 11 +----------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 2b30363a3a89..8ab46508e836 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -23,6 +23,7 @@
 #ifndef __ASM_ASSEMBLER_H
 #define __ASM_ASSEMBLER_H
 
+#include <asm/cpufeature.h>
 #include <asm/cputype.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
@@ -282,4 +283,21 @@ lr	.req	x30		// link register
 .Ldone\@:
 	.endm
 
+/*
+ * Errata workaround post TTBR0_EL1 update.
+ */
+	.macro	post_ttbr0_update_workaround
+#ifdef CONFIG_CAVIUM_ERRATUM_27456
+alternative_if_not ARM64_WORKAROUND_CAVIUM_27456
+       ret
+       nop
+       nop
+       nop
+alternative_else
+       ic      iallu
+       dsb     nsh
+       isb
+#endif
+	.endm
+
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index f09636738007..4eb1084e203a 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -139,17 +139,8 @@ ENTRY(cpu_do_switch_mm)
 	bfi	x0, x1, #48, #16		// set the ASID
 	msr	ttbr0_el1, x0			// set TTBR0
 	isb
-alternative_if_not ARM64_WORKAROUND_CAVIUM_27456
+	post_ttbr0_update_workaround
 	ret
-	nop
-	nop
-	nop
-alternative_else
-	ic	iallu
-	dsb	nsh
-	isb
-	ret
-alternative_endif
 ENDPROC(cpu_do_switch_mm)
 
 	.section ".text.init", #alloc, #execinstr
-- 
2.21.0.rc0.269.g1a574e7a288b

