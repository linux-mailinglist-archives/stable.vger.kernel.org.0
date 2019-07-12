Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1999C66638
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfGLF37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39591 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfGLF37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id b7so4205763pls.6
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cnuqc1YlBQBZ4RWPKzaqy9DfMXgSoNZrvvTdeydR7XY=;
        b=yfJJZ5buvkmMxNQR8vV5XtYVAp78VJYpxY9LCA4BC0JX7qdiJGXiskkfSUdBKHgQNq
         vXk/0Y2e38/I+NRmjwK9hTspNKbFoLzWqjbMZfohY9NRYCWONWD5kiYrpywmqmgOQYDv
         1LX4/1UXNBHentpM174OM7D9rwYA9/poH1MBnQYP/wnomcRqcRWidXhXy3ycxIWj5zBC
         ujv/YYcgk+KwRO9p8TAVkUAvENH7TxlO0GeXwqJvw3P5TgpHNfEPrPPiLsIbu8vIkDSH
         j4YmH97tDcSmGb5iF2zvItrav5N2ypf9WfYTVoSGSNGoJWjxpIQBXdurDPDcEJ5XALFT
         h9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cnuqc1YlBQBZ4RWPKzaqy9DfMXgSoNZrvvTdeydR7XY=;
        b=t06VObL9BCwLzuMaUyFNIVLkej4oG12mmQqeME9AEtj0kSHtSyRD5znWaAsOM/5xT4
         FKfkCwtwqdUepAsFfzxNZKbr/0t4IsDpSpL8nfzd10uuanzE2FY2Dty0MiXT+EC1/UwZ
         +hCwus/NGlMm36yn+x8gS7NYIQ0+92WZzlAH410z8dCQpqGHcr0/jn90DXn15BPqXt2Y
         Zkm3PSm3QhiR5TTk9qZ8UN8a7sg0gYswzGJNtXdQD6A7ETYj44wqTLLYF3pTzGSTlW1e
         vcN/6kjm0RsqkPbDCfR+8EV/oQNfsdBAThTtBQHMM4K2F+zIAMb29O0EwTa2XDDMc61d
         a3kg==
X-Gm-Message-State: APjAAAUkFCMDKsVT9E3JTu2q5oeyQQQ+Z/ZwYqhXnTQbS1703iaFhnTO
        XqaTPvE2Q9m2Y9kCyHD8/UHFQJUbI7k=
X-Google-Smtp-Source: APXvYqwG8zVFxbIjXDZcH9hRfAsIwwLPqouNSchzDdRL3GGGnQYd9Wgl4RfzdqNu4PpfU5dU7rhlxw==
X-Received: by 2002:a17:902:145:: with SMTP id 63mr9439855plb.55.1562909398590;
        Thu, 11 Jul 2019 22:29:58 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id 81sm2308137pfa.86.2019.07.11.22.29.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:58 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 V2 22/43] arm64: Factor out TTBR0_EL1 post-update workaround into a specific asm macro
Date:   Fri, 12 Jul 2019 10:58:10 +0530
Message-Id: <d7674d901fb2fd7fc29fe94a6fac6230b4ad84f9.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

