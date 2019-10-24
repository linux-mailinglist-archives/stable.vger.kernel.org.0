Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FD2E32EE
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502122AbfJXMts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38284 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502116AbfJXMtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id v9so14662936wrq.5
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tb+2G3BeDJgB2eIO239FZl8nXcaM7a4ZOfXSyctRIPY=;
        b=Bk9jR/8+kgnLdiqugals26KDUjWtBfs8+MR23RXfQlG7U78i6Z7nDfTy3doLMfVk8x
         BQ+qyecwlGKfUiZjiWzyhpKV17kwlWjmY2O2/hc8vUAlhxlryI5VL6DicP23BeKzL6VF
         G+9cbpi8UZKmds5kKtXHTMru1jTxaZU3KXfnBqGKI1QQKGkA997bocpnESydfWHJgH8a
         Y3DWOl8Y03xMpdiwGrdAwJJlTxBFHVgGQKZtW4kC4J0TTeODZdhWlznEfmPbT/0ZvMyc
         6zkZTUSgenNV+mM8ybIv1yHIZJG33GWOAtjtZ8c1F9LxmyCIHDfegw3R+UwqGjzYIWJX
         06Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tb+2G3BeDJgB2eIO239FZl8nXcaM7a4ZOfXSyctRIPY=;
        b=Hh2OBSQJEkEjqn3Pf2vBjt2jR3gn7eiC7NGQmuiGy1v86wNsv4qfQAm01Fyu6WFsgK
         xTenLsPtQhDVlI1IKgR240V3vR7LN6kTM1w8w26Wv4DKPrCKgIs169G1rZSI41D7zXnv
         RZaB/mzSteC6Ye8IyAW139mu9+we1Qq0Pd3WziDWWng/zbVPsyIeKr9QVKFg34LtsNCd
         NMm5PVrg0p5ePxKiJzOc/lx+2ItPOhh+xkIYgZR2RRzm31rjVByxsmIJ6yJb1AoDKHTt
         mOg+Kk7WAWSQHLxgbdKF+3p5cLwhxWeZ2g5Vwp6AiOX9fDIAQWzfAUUa/mivaac57YO8
         B5vg==
X-Gm-Message-State: APjAAAXh8Q5WfvSNhxXcK3/0nSkKkPpjw3JjEQVoNsdnHQhACh6sbmRi
        M8ykz3m3KtZKEQMMYhRMqzAXmfQKWt1KRoVi
X-Google-Smtp-Source: APXvYqxfQpZoWpTDk+ZzeWTc1GVC2oLsuAnp/nh7OaT+B1GPW1UYJWK/r+epzfJOEg50FUziki7hNA==
X-Received: by 2002:a5d:6585:: with SMTP id q5mr4035447wru.74.1571921384212;
        Thu, 24 Oct 2019 05:49:44 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:43 -0700 (PDT)
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
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 35/48] arm64: fix SSBS sanitization
Date:   Thu, 24 Oct 2019 14:48:20 +0200
Message-Id: <20191024124833.4158-36-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit f54dada8274643e3ff4436df0ea124aeedc43cae ]

In valid_user_regs() we treat SSBS as a RES0 bit, and consequently it is
unexpectedly cleared when we restore a sigframe or fiddle with GPRs via
ptrace.

This patch fixes valid_user_regs() to account for this, updating the
function to refer to the latest ARM ARM (ARM DDI 0487D.a). For AArch32
tasks, SSBS appears in bit 23 of SPSR_EL1, matching its position in the
AArch32-native PSR format, and we don't need to translate it as we have
to for DIT.

There are no other bit assignments that we need to account for today.
As the recent documentation describes the DIT bit, we can drop our
comment regarding DIT.

While removing SSBS from the RES0 masks, existing inconsistent
whitespace is corrected.

Fixes: d71be2b6c0e19180 ("arm64: cpufeature: Detect SSBS and advertise to userspace")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/ptrace.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index d8ff8f26db6d..242527f29c41 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1402,19 +1402,20 @@ asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 }
 
 /*
- * SPSR_ELx bits which are always architecturally RES0 per ARM DDI 0487C.a
- * We also take into account DIT (bit 24), which is not yet documented, and
- * treat PAN and UAO as RES0 bits, as they are meaningless at EL0, and may be
- * allocated an EL0 meaning in future.
+ * SPSR_ELx bits which are always architecturally RES0 per ARM DDI 0487D.a.
+ * We permit userspace to set SSBS (AArch64 bit 12, AArch32 bit 23) which is
+ * not described in ARM DDI 0487D.a.
+ * We treat PAN and UAO as RES0 bits, as they are meaningless at EL0, and may
+ * be allocated an EL0 meaning in future.
  * Userspace cannot use these until they have an architectural meaning.
  * Note that this follows the SPSR_ELx format, not the AArch32 PSR format.
  * We also reserve IL for the kernel; SS is handled dynamically.
  */
 #define SPSR_EL1_AARCH64_RES0_BITS \
-	(GENMASK_ULL(63,32) | GENMASK_ULL(27, 25) | GENMASK_ULL(23, 22) | \
-	 GENMASK_ULL(20, 10) | GENMASK_ULL(5, 5))
+	(GENMASK_ULL(63, 32) | GENMASK_ULL(27, 25) | GENMASK_ULL(23, 22) | \
+	 GENMASK_ULL(20, 13) | GENMASK_ULL(11, 10) | GENMASK_ULL(5, 5))
 #define SPSR_EL1_AARCH32_RES0_BITS \
-	(GENMASK_ULL(63,32) | GENMASK_ULL(23, 22) | GENMASK_ULL(20,20))
+	(GENMASK_ULL(63, 32) | GENMASK_ULL(22, 22) | GENMASK_ULL(20, 20))
 
 static int valid_compat_regs(struct user_pt_regs *regs)
 {
-- 
2.20.1

