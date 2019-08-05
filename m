Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55651823BC
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbfHERNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbfHERNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 13:13:19 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A6B21738;
        Mon,  5 Aug 2019 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565025199;
        bh=EDcm5tjeBySHxvSdAgzlO1kAVBwqVBtIvK9ZyeKBzqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I51HwvXi4vPK8dJixxV1GpI8oLiRvjEcj7LdHIELRl4R1B1XJh2qotW8DH45JwYOH
         phhgJ04za5Sp/l1D68Mlr7e981RheHn7hoSwMeBXyw+zYD33Hbvsew38rcc8MwRI+4
         x9ZtPwbxeZNraIkc8IKyCqPp0UhQM7HBSN4QNM/0=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 2/2] arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}
Date:   Mon,  5 Aug 2019 18:13:08 +0100
Message-Id: <20190805171308.19249-3-will@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190805171308.19249-1-will@kernel.org>
References: <20190805171308.19249-1-will@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 147b9635e6347104b91f48ca9dca61eb0fbf2a54 upstream.

If CTR_EL0.{CWG,ERG} are 0b0000 then they must be interpreted to have
their architecturally maximum values, which defeats the use of
FTR_HIGHER_SAFE when sanitising CPU ID registers on heterogeneous
machines.

Introduce FTR_HIGHER_OR_ZERO_SAFE so that these fields effectively
saturate at zero.

Fixes: 3c739b571084 ("arm64: Keep track of CPU feature registers")
Cc: <stable@vger.kernel.org> # 4.4.y only
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 7 ++++---
 arch/arm64/kernel/cpufeature.c      | 8 ++++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ad83c245781c..0a66f8241f18 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -41,9 +41,10 @@
 
 /* CPU feature register tracking */
 enum ftr_type {
-	FTR_EXACT,	/* Use a predefined safe value */
-	FTR_LOWER_SAFE,	/* Smaller value is safe */
-	FTR_HIGHER_SAFE,/* Bigger value is safe */
+	FTR_EXACT,			/* Use a predefined safe value */
+	FTR_LOWER_SAFE,			/* Smaller value is safe */
+	FTR_HIGHER_SAFE,		/* Bigger value is safe */
+	FTR_HIGHER_OR_ZERO_SAFE,	/* Bigger value is safe, but 0 is biggest */
 };
 
 #define FTR_STRICT	true	/* SANITY check strict matching required */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index fff0bf2f889e..062484d34450 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -130,8 +130,8 @@ static struct arm64_ftr_bits ftr_ctr[] = {
 	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 30, 1, 0),
 	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 29, 1, 1),	/* DIC */
 	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 28, 1, 1),	/* IDC */
-	U_ARM64_FTR_BITS(FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
-	U_ARM64_FTR_BITS(FTR_STRICT, FTR_HIGHER_SAFE, 20, 4, 0),	/* ERG */
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, 24, 4, 0),	/* CWG */
+	U_ARM64_FTR_BITS(FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, 20, 4, 0),	/* ERG */
 	U_ARM64_FTR_BITS(FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 1),	/* DminLine */
 	/*
 	 * Linux can handle differing I-cache policies. Userspace JITs will
@@ -341,6 +341,10 @@ static s64 arm64_ftr_safe_value(struct arm64_ftr_bits *ftrp, s64 new, s64 cur)
 	case FTR_LOWER_SAFE:
 		ret = new < cur ? new : cur;
 		break;
+	case FTR_HIGHER_OR_ZERO_SAFE:
+		if (!cur || !new)
+			break;
+		/* Fallthrough */
 	case FTR_HIGHER_SAFE:
 		ret = new > cur ? new : cur;
 		break;
-- 
2.11.0

