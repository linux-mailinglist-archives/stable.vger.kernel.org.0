Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8414E32D3
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfJXMtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33087 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbfJXMtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id s1so17173382wro.0
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FGLorEesDsfAmxFmFpT9rKaAuqHDIZiwQnvART+qIuc=;
        b=MXhIjmhcLgKtMpSxfoK4lgqDGGGPPMeIXzPvfIklgcEiN1VW0+wWD0Nmsc12sy4rvW
         GtH3Y/nSZQ0MYWQedpRU07eBaivkLHkgvLJnwQYGTdMzSSGiIsKUY/HBT/GVEnsRQ5Lv
         fxoknWwwuFN1jjkRIy2LIG7qEerbISYAfGyC4vvPs1wl4Y7qlA5Le5ap2vCjNl+g/g8Y
         5oeHwPyjBmeEyFB8EOZDaktDzha0+o2fFVr+H+LIb/Klr3/ndgpCnz2BGOM9y8XvbZo8
         8htrYg+UWhh+TjhxX82u8vZvWo60iRj3P/66ZOfywVcSjtHWW0POPWlBbr9prlP2R9UA
         U7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FGLorEesDsfAmxFmFpT9rKaAuqHDIZiwQnvART+qIuc=;
        b=sO9DVtkc4XzOr3i8dQxboSXvJx8640LiB64fdcM8/jwWWxs5MT8+vsBGwjOGSvlo7+
         4AalS0MiXOmAUEzLJLgsZN1gkyMCpIbnWOORlahTvlKv/B8lWGzOQXMg01jxLXr5+0gB
         Uc4HCiNJ9VwFX3FLr/tqOhXmAqptVImUqo/m/tuBrNVEkk0MViP/hFBV+LX3QVk9ZIw4
         xoKTuSxtVGq7zPqvdby6OvgNxmebucpBoKdZ5y+UNzCsrMq49Ep2ZwEvDCjj6Pj+lS61
         mtkEaFIDsKlLwFEgTvVgjymTDEr1DnMYGKYuz+EfNR+7XFJVQ1B6pixJixoyChaq+vh9
         SWfA==
X-Gm-Message-State: APjAAAUv+cOBvBj+SFv3/y/FN8noObdvtxvMKCWWboh1iX8ac+qfSftG
        RIg5V1mc45xMunFTxOy4/nsvL7TKDaNc6tzJ
X-Google-Smtp-Source: APXvYqyxDsf+oHw0Qw6bS8CMDyzYGGTpwJJiE4SWp99PkKNotE+FP0kEU5hY9UNQ6IWzMZvg/okmyg==
X-Received: by 2002:a5d:678e:: with SMTP id v14mr3573451wru.393.1571921341138;
        Thu, 24 Oct 2019 05:49:01 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:49:00 -0700 (PDT)
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
        Dave Martin <dave.martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH for-stable-4.14 09/48] arm64: Introduce sysreg_clear_set()
Date:   Thu, 24 Oct 2019 14:47:54 +0200
Message-Id: <20191024124833.4158-10-ard.biesheuvel@linaro.org>
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

[ Upstream commit 6ebdf4db8fa564a150f46d32178af0873eb5abbb ]

Currently we have a couple of helpers to manipulate bits in particular
sysregs:

 * config_sctlr_el1(u32 clear, u32 set)

 * change_cpacr(u64 val, u64 mask)

The parameters of these differ in naming convention, order, and size,
which is unfortunate. They also differ slightly in behaviour, as
change_cpacr() skips the sysreg write if the bits are unchanged, which
is a useful optimization when sysreg writes are expensive.

Before we gain yet another sysreg manipulation function, let's
unify these with a common helper, providing a consistent order for
clear/set operands, and the write skipping behaviour from
change_cpacr(). Code will be migrated to the new helper in subsequent
patches.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <dave.martin@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/sysreg.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index f0ce6ea6c6d8..5f391630d0f4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -584,6 +584,17 @@ asm(
 	asm volatile("msr_s " __stringify(r) ", %x0" : : "rZ" (__val));	\
 } while (0)
 
+/*
+ * Modify bits in a sysreg. Bits in the clear mask are zeroed, then bits in the
+ * set mask are set. Other bits are left as-is.
+ */
+#define sysreg_clear_set(sysreg, clear, set) do {			\
+	u64 __scs_val = read_sysreg(sysreg);				\
+	u64 __scs_new = (__scs_val & ~(u64)(clear)) | (set);		\
+	if (__scs_new != __scs_val)					\
+		write_sysreg(__scs_new, sysreg);			\
+} while (0)
+
 static inline void config_sctlr_el1(u32 clear, u32 set)
 {
 	u32 val;
-- 
2.20.1

