Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0A5CA879
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390139AbfJCQ1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:27:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391233AbfJCQ1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:27:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF1F62054F;
        Thu,  3 Oct 2019 16:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120039;
        bh=pBcD5qYEl+7A2rAULfW6SfUahiHD8dGgMVyMJC12Zlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/k/3lQgUjK4+iNrNcJ+RvxZBeCwuJSyT9+h3LosHcC/P3GlhkQPNeIA8f+6G65lJ
         LiQm1HaNjQ/WKrztaguP7DDx6wKmbKXo91fonmu5XVrEXfSE3SAyw+CxBtbySMwuaT
         8qw5tPQbYgnt2NiWNVzUURlLx9RWHNMMTDV5YRtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 073/313] arm64/prefetch: fix a -Wtype-limits warning
Date:   Thu,  3 Oct 2019 17:50:51 +0200
Message-Id: <20191003154540.036062225@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



