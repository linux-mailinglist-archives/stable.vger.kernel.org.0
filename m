Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FBEBA675
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404600AbfIVSuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392064AbfIVSut (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03CC421D7C;
        Sun, 22 Sep 2019 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178248;
        bh=pBcD5qYEl+7A2rAULfW6SfUahiHD8dGgMVyMJC12Zlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgaKl79uhxeFNgjdn7ECGB2JV//dnvE4d1JICaAl79svXtHRRP3XIxxaTC3EqPCkr
         /m93tLYzYPuM/y6sYapc3bCoB+9s03u0ITzeoDITIvSNdLUFmtUuC4+NR1pA6BWKgi
         mSmlMCzTa4RSBTx0TBfRrq79jkb1qWHH/1MZx/dY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 041/185] arm64/prefetch: fix a -Wtype-limits warning
Date:   Sun, 22 Sep 2019 14:46:59 -0400
Message-Id: <20190922184924.32534-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit b99286b088ea843b935dcfb29f187697359fe5cd ]

The commit d5370f754875 ("arm64: prefetch: add alternative pattern for
CPUs without a prefetcher") introduced MIDR_IS_CPU_MODEL_RANGE() to be
used in has_no_hw_prefetch() with rv_min=0 which generates a compilation
warning from GCC,

In file included from ./arch/arm64/include/asm/cache.h:8,
               from ./include/linux/cache.h:6,
               from ./include/linux/printk.h:9,
               from ./include/linux/kernel.h:15,
               from ./include/linux/cpumask.h:10,
               from arch/arm64/kernel/cpufeature.c:11:
arch/arm64/kernel/cpufeature.c: In function 'has_no_hw_prefetch':
./arch/arm64/include/asm/cputype.h:59:26: warning: comparison of
unsigned expression >= 0 is always true [-Wtype-limits]
_model == (model) && rv >= (rv_min) && rv <= (rv_max);  \
                        ^~
arch/arm64/kernel/cpufeature.c:889:9: note: in expansion of macro
'MIDR_IS_CPU_MODEL_RANGE'
return MIDR_IS_CPU_MODEL_RANGE(midr, MIDR_THUNDERX,
       ^~~~~~~~~~~~~~~~~~~~~~~

Fix it by converting MIDR_IS_CPU_MODEL_RANGE to a static inline
function.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 21 +++++++++++----------
 arch/arm64/kernel/cpufeature.c   |  2 +-
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index e7d46631cc42b..b1454d117cd2c 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -51,14 +51,6 @@
 #define MIDR_CPU_MODEL_MASK (MIDR_IMPLEMENTOR_MASK | MIDR_PARTNUM_MASK | \
 			     MIDR_ARCHITECTURE_MASK)
 
-#define MIDR_IS_CPU_MODEL_RANGE(midr, model, rv_min, rv_max)		\
-({									\
-	u32 _model = (midr) & MIDR_CPU_MODEL_MASK;			\
-	u32 rv = (midr) & (MIDR_REVISION_MASK | MIDR_VARIANT_MASK);	\
-									\
-	_model == (model) && rv >= (rv_min) && rv <= (rv_max);		\
- })
-
 #define ARM_CPU_IMP_ARM			0x41
 #define ARM_CPU_IMP_APM			0x50
 #define ARM_CPU_IMP_CAVIUM		0x43
@@ -159,10 +151,19 @@ struct midr_range {
 #define MIDR_REV(m, v, r) MIDR_RANGE(m, v, r, v, r)
 #define MIDR_ALL_VERSIONS(m) MIDR_RANGE(m, 0, 0, 0xf, 0xf)
 
+static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
+					   u32 rv_max)
+{
+	u32 _model = midr & MIDR_CPU_MODEL_MASK;
+	u32 rv = midr & (MIDR_REVISION_MASK | MIDR_VARIANT_MASK);
+
+	return _model == model && rv >= rv_min && rv <= rv_max;
+}
+
 static inline bool is_midr_in_range(u32 midr, struct midr_range const *range)
 {
-	return MIDR_IS_CPU_MODEL_RANGE(midr, range->model,
-				 range->rv_min, range->rv_max);
+	return midr_is_cpu_model_range(midr, range->model,
+				       range->rv_min, range->rv_max);
 }
 
 static inline bool
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 68faf535f40a3..d3fbb89a31e57 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -894,7 +894,7 @@ static bool has_no_hw_prefetch(const struct arm64_cpu_capabilities *entry, int _
 	u32 midr = read_cpuid_id();
 
 	/* Cavium ThunderX pass 1.x and 2.x */
-	return MIDR_IS_CPU_MODEL_RANGE(midr, MIDR_THUNDERX,
+	return midr_is_cpu_model_range(midr, MIDR_THUNDERX,
 		MIDR_CPU_VAR_REV(0, 0),
 		MIDR_CPU_VAR_REV(1, MIDR_REVISION_MASK));
 }
-- 
2.20.1

