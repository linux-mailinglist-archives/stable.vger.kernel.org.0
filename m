Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E4EE32E9
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502114AbfJXMtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54054 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502113AbfJXMti (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id n7so1870155wmc.3
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aq3mBaPhAoWd11DOqdvb4flpLStm7Tu4u5a3YQIbEug=;
        b=t2cCeNFxGmFQ+Nla9BZBOkpA/LgB7vJMIC0PIVhmCKHEGTER31P+XCjbPW6MUVZZ2v
         n8orpF4Z0iUzzOOQ1K83EmqX0wOae7jayRfGDjugydA4xQetXmEfRK04Vo9yOVmYxiE6
         sN/u8I47rSoxMUxbo/qLfZmQUCB8/bBPCJ44eTbuUPctE2QZvCaWpOAAc10+qMkR0one
         HzI7NAvoTahQz0DC8ESW5tSRsSedE2b9cwgtRCRC0VQNbvKwtV34H+qbAmiMgvLTHu9g
         3SpDe4TxobEoRhmnYqyLGHOcoFD5t9xSDVcZVZe5k/ROF90GcRTJNh0fq3KkMECEwhK6
         wbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aq3mBaPhAoWd11DOqdvb4flpLStm7Tu4u5a3YQIbEug=;
        b=KAiv6cBJiQRfIQVqP2d1qykfwAFLoIZW0od/AmqJhJXKssp1SgBwmpXqq+bT5308wm
         XBuuRzff0JoqchM81GgQXcnWaNi3B3GjSJc7EXKlfdAk3nvOlgqZGtmYHfp4HMxH2kiz
         vEVXvO9p7Mfnh8pgJkwUtR4jhg7jTs5WZoJ/ex6zi8/nPblAHyBqwAfOwHOOnn0TJD44
         xlKG3HlmjHsbAZI4I0k5vebcSTbkstGsMKyanQfSNH1okCLCB7zfvjpj61NpaIgwYG1e
         cjM/CRYmMcPs15bBA3IAq7PwDon4TiiTER5zrF1F66G7NbkjleT1juHBbjEGhvKwWykQ
         PTqw==
X-Gm-Message-State: APjAAAXiEoKxF9+eU+gYZpjN9LvxCPBGS1MnBeh9WTNSkF3QVpW71hEm
        DW7laj27IT2BlQcMbY0Pwe4NjMEPmMWnNAHu
X-Google-Smtp-Source: APXvYqz1G1s0moFyTAUnf7i5rAdoP6W8RkoUHI83eiWwtIeXc5uFVMPJUcE4BUeYrJB8ac3zwqqYSw==
X-Received: by 2002:a1c:5f42:: with SMTP id t63mr4595233wmb.163.1571921376597;
        Thu, 24 Oct 2019 05:49:36 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:35 -0700 (PDT)
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
Subject: [PATCH for-stable-4.14 30/48] arm64: don't zero DIT on signal return
Date:   Thu, 24 Oct 2019 14:48:15 +0200
Message-Id: <20191024124833.4158-31-ard.biesheuvel@linaro.org>
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

[ Upstream commit 1265132127b63502d34e0f58c8bdef3a4dc927c2 ]

Currently valid_user_regs() treats SPSR_ELx.DIT as a RES0 bit, causing
it to be zeroed upon exception return, rather than preserved. Thus, code
relying on DIT will not function as expected, and may expose an
unexpected timing sidechannel.

Let's remove DIT from the set of RES0 bits, such that it is preserved.
At the same time, the related comment is updated to better describe the
situation, and to take into account the most recent documentation of
SPSR_ELx, in ARM DDI 0487C.a.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Fixes: 7206dc93a58fb764 ("arm64: Expose Arm v8.4 features")
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/ptrace.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 34d915b6974b..d8ff8f26db6d 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1402,15 +1402,19 @@ asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 }
 
 /*
- * Bits which are always architecturally RES0 per ARM DDI 0487A.h
+ * SPSR_ELx bits which are always architecturally RES0 per ARM DDI 0487C.a
+ * We also take into account DIT (bit 24), which is not yet documented, and
+ * treat PAN and UAO as RES0 bits, as they are meaningless at EL0, and may be
+ * allocated an EL0 meaning in future.
  * Userspace cannot use these until they have an architectural meaning.
+ * Note that this follows the SPSR_ELx format, not the AArch32 PSR format.
  * We also reserve IL for the kernel; SS is handled dynamically.
  */
 #define SPSR_EL1_AARCH64_RES0_BITS \
-	(GENMASK_ULL(63,32) | GENMASK_ULL(27, 22) | GENMASK_ULL(20, 10) | \
-	 GENMASK_ULL(5, 5))
+	(GENMASK_ULL(63,32) | GENMASK_ULL(27, 25) | GENMASK_ULL(23, 22) | \
+	 GENMASK_ULL(20, 10) | GENMASK_ULL(5, 5))
 #define SPSR_EL1_AARCH32_RES0_BITS \
-	(GENMASK_ULL(63,32) | GENMASK_ULL(24, 22) | GENMASK_ULL(20,20))
+	(GENMASK_ULL(63,32) | GENMASK_ULL(23, 22) | GENMASK_ULL(20,20))
 
 static int valid_compat_regs(struct user_pt_regs *regs)
 {
-- 
2.20.1

