Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBEDD87C0A
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406861AbfHINqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406518AbfHINqE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2161D2171F;
        Fri,  9 Aug 2019 13:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358363;
        bh=KNH5LTo6U6LPt5LDid7xgLtnO528JweYiwo3EJ02Dd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Imetlo+7vokpctZdr/p6MJk0OIQN3p7m9TBcZLY6mrS2NRegJa2PYt+G2Y29hvhHj
         iSsWV0isF20eCkvfgpWkAdpo6BuY7pe3YZ2oFUrt20J1LHv88h71C4wF/CEs71T6p7
         7Vhe2CdI5XN0do1RSc58igHB5O/nv4dlvlUfxvQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 02/21] arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}
Date:   Fri,  9 Aug 2019 15:45:06 +0200
Message-Id: <20190809134241.664708388@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 7 ++++---
 arch/arm64/kernel/cpufeature.c      | 8 ++++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ad83c245781c3..0a66f8241f185 100644
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
index fff0bf2f889e1..062484d344509 100644
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
2.20.1



