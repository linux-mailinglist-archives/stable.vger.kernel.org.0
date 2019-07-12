Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D1266627
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 07:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbfGLF3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 01:29:17 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41516 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGLF3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 01:29:16 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so3786611pff.8
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 22:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1IdhsUs/fdllTh2EJ+ScRqWrO1uX9GsPUvP6PugnTR0=;
        b=NLbMjzAlqCBkT5p9dJVqb2Z5dGhi0jH/DelTojWG0Hk2jdOfuiefznDfWJuowL/Agl
         9aokXDeJ+NvIotQEG7M9THxjw+tb4VCdkLg0zn5oOVf7UqOFxPmQNucZL3G6T4d34qB7
         t4PnLhRDb1YvAtUJ64bQ3QYulrevKjRsE8L0fyxvWH95xDWSk9+Xh76mvSBfdlZUq6lQ
         XvmcFSoFmIX3B4BQMIZGp1/ew1VgB/sqXv79EloYkvfP3rnZvDNjRXbvP1Z+zMig52iB
         Dlq9x9DLYRFCXW8bKyADSSuKd2qCmMDKgLmgOmKouq+eU0jfATvKGuL0UJyP3z0HwRZu
         sM9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1IdhsUs/fdllTh2EJ+ScRqWrO1uX9GsPUvP6PugnTR0=;
        b=aVIOjgoCUVqCuOM+QhnEbFIfljTPoukFgFJBKDHRTDraR0EA8fG97XYLSre5a5/583
         +L9CIzRFZCL+gRYFNQAaU8cErjXVcMooJsCc0mT5zFWZAhnSKHSHLg4HRVIP7r6zLbi7
         cudPkw4dR6r+/cEjgbExdmMArihWcCUwBdhjVNjeZnKjHjO4nN45gh/uve6H+bDowcOx
         IdshdSQDKhXVwJF3up14s7Ob2R9N1wOzx/RMd8s/PC24cGdYcVSpkSSh1XExcx14eRMi
         Z+reOuCS+AYXpq0X3RHu5U+ThdZ+koY7xJDj9sJYwHlZp1RyjNfEyEY/i3CcZWdZ4WIi
         ToSw==
X-Gm-Message-State: APjAAAVGCC//rsxytspA044y0+zaN7C1F/BU20zab3/g3DpKN2vxpG7y
        rzQLO6wbh8U+Y/NXLUuJLVoK1Uus1/A=
X-Google-Smtp-Source: APXvYqzjpXn8aWTQ904egESJ2V6XD2ad/VtRF0h099mRxYUm95aM1xhFQFa257EFbfYb+xlgd/9LlQ==
X-Received: by 2002:a17:90a:a116:: with SMTP id s22mr9286580pjp.47.1562909355740;
        Thu, 11 Jul 2019 22:29:15 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id d23sm5914809pjv.18.2019.07.11.22.29.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 22:29:15 -0700 (PDT)
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
Subject: [PATCH v4.4 V2 06/43] arm64: entry: Ensure branch through syscall table is bounded under speculation
Date:   Fri, 12 Jul 2019 10:57:54 +0530
Message-Id: <a7530ecb5571c4f5e6b88547f61c77c68194cc0f.1562908075.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1562908074.git.viresh.kumar@linaro.org>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
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

