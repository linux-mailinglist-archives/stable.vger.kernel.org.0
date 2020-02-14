Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A836715E7E9
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404579AbgBNQRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:17:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404222AbgBNQRw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C134246F2;
        Fri, 14 Feb 2020 16:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697071;
        bh=nqicl7dqIy3ZKtvX7rb2CeZHceDTX4gLyk1l1O7gv4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsioD5xRTunomxkhRI9rl4zuYFuvHuHG4s/1NQ9/8yxGzTjM7WU34lTwlh5r4dVUj
         wYnryaUruZjONybK6TLh/cSpToq7O199Fm1VsMb3KTCsDZK6l5fRbogrOhs4p1ymwq
         ATzBgGdpia1A4RaU1BOCVQFnUzDpMzaJ97yl342g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 027/186] arm64: cpufeature: Fix the type of no FP/SIMD capability
Date:   Fri, 14 Feb 2020 11:14:36 -0500
Message-Id: <20200214161715.18113-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 449443c03d8cfdacf7313e17779a2594ebf87e6d ]

The NO_FPSIMD capability is defined with scope SYSTEM, which implies
that the "absence" of FP/SIMD on at least one CPU is detected only
after all the SMP CPUs are brought up. However, we use the status
of this capability for every context switch. So, let us change
the scope to LOCAL_CPU to allow the detection of this capability
as and when the first CPU without FP is brought up.

Also, the current type allows hotplugged CPU to be brought up without
FP/SIMD when all the current CPUs have FP/SIMD and we have the userspace
up. Fix both of these issues by changing the capability to
BOOT_RESTRICTED_LOCAL_CPU_FEATURE.

Fixes: 82e0191a1aa11abf ("arm64: Support systems without FP/ASIMD")
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 09c6499bc500e..c477fd34a9120 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1103,7 +1103,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		/* FP/SIMD is not implemented */
 		.capability = ARM64_HAS_NO_FPSIMD,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_BOOT_RESTRICTED_CPU_LOCAL_FEATURE,
 		.min_field_value = 0,
 		.matches = has_no_fpsimd,
 	},
-- 
2.20.1

