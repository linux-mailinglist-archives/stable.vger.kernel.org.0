Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E254526E
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 05:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFNDMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 23:12:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39800 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfFNDMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 23:12:34 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so373869pls.6
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 20:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cnuqc1YlBQBZ4RWPKzaqy9DfMXgSoNZrvvTdeydR7XY=;
        b=bCx056PQTrtu4bcBdGQja4CHWdjoDe+5H+fLVBYU88hpCO0mdINyMFmiKguyS9D9RA
         ME26/gyKidKHOT6sc2fheDDmaUJ0eWshUQVYcqitEEOshB0SeFtS/fpdh0VOETgQSUrE
         furCIjr9M9DUKfdzkgNQVVHORPVTjYraCnjBkAm5yNTA8mes84LCT7IpFkgDSD4SpROE
         fMYNjTQ9OonP/wgTkKipTtd21c24O2/kCzcFzEdw5dKeswwnJYuIlKf8QLudP8C1WKyQ
         Oj5KaXiQ5v9trrdDY0ftykarsxdOhpRb4VZqVabajO83FiVDvAnSavu1yR+F0apB6hzm
         YW6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cnuqc1YlBQBZ4RWPKzaqy9DfMXgSoNZrvvTdeydR7XY=;
        b=Dpy+8claWpwjJkK14CsEoF+nOiE+/WPPxLn3Nn9zF85hKY8AqXy/SeVWoi93S+sLNW
         pzYHYkbpfIVAYtqJhAfEYigB4N0DFjSgTydpHCKvhcAu8XUS+2mvSr623bbflSlO+Uwx
         UstNcwsPzANRlt/YZHJm29mxtvxNYcqkYd9Y2yJevdyzifVqN5cBu0j5v31WA7bnwLN+
         32WLfCx0xqq4DJ8pfqDJ88OB5xYhzpNGN4wW8iCjbheEgf7RuOyk4lsiOFjY9o5fndQd
         gCZi/AU/uXu+8T+bwgjbAZZVHTGpgJbwB6UAShhgfpWYvtCBo5LZBSHpRyMU6j0uJ4j5
         oY1w==
X-Gm-Message-State: APjAAAXiI5JHINEznm5igtDGGiGjfJxJXsPPwrVeaZZS+pFyzhEpWGja
        DT4H6v0+s7W1m5apCKeqMmcFwg==
X-Google-Smtp-Source: APXvYqwWAvX5hAkv6sKgzGxrT1ixp/vTxnWhHkBaxn79v8H4S+J+iySVgfapTP4cZ7Tj264F6GLcSg==
X-Received: by 2002:a17:902:8203:: with SMTP id x3mr7315832pln.304.1560481953855;
        Thu, 13 Jun 2019 20:12:33 -0700 (PDT)
Received: from localhost ([122.172.66.84])
        by smtp.gmail.com with ESMTPSA id d9sm1097756pgj.34.2019.06.13.20.12.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 20:12:33 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Julien Thierry <Julien.Thierry@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH v4.4 15/45] arm64: Factor out TTBR0_EL1 post-update workaround into a specific asm macro
Date:   Fri, 14 Jun 2019 08:37:58 +0530
Message-Id: <75c8ebf74edaebb1a62190c9ae1f39c609963f06.1560480942.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1560480942.git.viresh.kumar@linaro.org>
References: <cover.1560480942.git.viresh.kumar@linaro.org>
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

