Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCE5A18B7
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfH2LfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:09 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37503 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfH2LfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id bj8so1451884plb.4
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1IdhsUs/fdllTh2EJ+ScRqWrO1uX9GsPUvP6PugnTR0=;
        b=nxI85UwxnbVBJqSbq8Ywtoc623bVciPB583W6cIvsNcR9oBenNkMhgmn56N8dl7tHE
         HCJXonvD30tGaKZHMMV+hUfBy0X963d3yoXUwEU4wjSg1Z72lbwKhxPibPpL4vvKT/sr
         d9eU0YSkgUUaRy9GZaJXXWZccVQd7hOExhRb4tLvsZBKRmh5CCx4FM+iAh/eQCsKLWWp
         FIY3VPxy1ObVuPcERjVujhSRX3z9hbu98dIF01oxC51utQfIXqj2ZtYwJ+WWA85tkvl2
         4cF/61lyqS+8CzAr/GFd2AGhz0eitx64Llmj8Bs0pXoci4lMlRg6vnKzxGxcF7afafI0
         OAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1IdhsUs/fdllTh2EJ+ScRqWrO1uX9GsPUvP6PugnTR0=;
        b=nzc+bMDn9x0oy0k79dQnB2e+7k5RYgRK/wkhTjppKc/UwU/lqgkcb+SRezfJ22x7vr
         uw1hJjJncdBxOoj97r4to4wGntlFZZ6CilKoUQCMCDjJHhPAL3wII4JB3TRXeIeL8Ql+
         mZjObrwi0jFJOdco2X2mJsMOfFHZeEq1QLomf/g4rRl4D/dYkrVe5uYkHJ5bYTTocLqC
         +mfq1xn2RLkmZtnp1JtsVNA9O4pZ8/jS5Q4CLH8uwKq1S/FgrsAOO9zRP/GJEEUlwSa7
         8DYGqdO+WQwyNmDVO4RUkXQDXp91Ck5cnuAD9sip8pBiu3MUJ8E4d6BMx4bLPglR1lMT
         JyEg==
X-Gm-Message-State: APjAAAUrP6HevA4j9SCavWoHoL8tND4J0OG5XzBPjCqwoLORfRiVoFpj
        P62KphGSA6/8ExGs8Rlub1NsT8bx+es=
X-Google-Smtp-Source: APXvYqzj9QSx3MtgHt1qHIKICzNCPI0f7DNQySSHpINOygIRFz1OPV0EPaWQ+yDXuf1zgDx8qUKSew==
X-Received: by 2002:a17:902:f217:: with SMTP id gn23mr9333792plb.21.1567078508102;
        Thu, 29 Aug 2019 04:35:08 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id u18sm2794235pfl.29.2019.08.29.04.35.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:35:07 -0700 (PDT)
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
Subject: [PATCH ARM64 v4.4 V3 06/44] arm64: entry: Ensure branch through syscall table is bounded under speculation
Date:   Thu, 29 Aug 2019 17:03:51 +0530
Message-Id: <093a9777605bdd2ab2c33948a4e7a3fbb275de4d.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 6314d90e64936c584f300a52ef173603fb2461b5 upstream.

In a similar manner to array_index_mask_nospec, this patch introduces an
assembly macro (mask_nospec64) which can be used to bound a value under
speculation. This macro is then used to ensure that the indirect branch
through the syscall table is bounded under speculation, with out-of-range
addresses speculating as calls to sys_io_setup (0).

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ v4.4: use existing scno & sc_nr definitions ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/assembler.h | 11 +++++++++++
 arch/arm64/kernel/entry.S          |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 683c2875278f..2b30363a3a89 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -102,6 +102,17 @@
 	hint	#20
 	.endm
 
+/*
+ * Sanitise a 64-bit bounded index wrt speculation, returning zero if out
+ * of bounds.
+ */
+	.macro	mask_nospec64, idx, limit, tmp
+	sub	\tmp, \idx, \limit
+	bic	\tmp, \tmp, \idx
+	and	\idx, \idx, \tmp, asr #63
+	csdb
+	.endm
+
 #define USER(l, x...)				\
 9999:	x;					\
 	.section __ex_table,"a";		\
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 4c5013b09dcb..e6aec982dea9 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -697,6 +697,7 @@ el0_svc_naked:					// compat entry point
 	b.ne	__sys_trace
 	cmp     scno, sc_nr                     // check upper syscall limit
 	b.hs	ni_sys
+	mask_nospec64 scno, sc_nr, x19	// enforce bounds for syscall number
 	ldr	x16, [stbl, scno, lsl #3]	// address in the syscall table
 	blr	x16				// call sys_* routine
 	b	ret_fast_syscall
-- 
2.21.0.rc0.269.g1a574e7a288b

