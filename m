Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A827D15C4EC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgBMPvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:51:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728735AbgBMP0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:10 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5424218AC;
        Thu, 13 Feb 2020 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607569;
        bh=ekNF1XJ/qYgMN/nUl8sbw+VuaMbnXSJOcrNAXY7nZHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9v7fv18oVA2fC+hLp8hTKZHuHtH64QujlwKs5DrufvT26b4CobVvmEueOLUznu61
         fz/IcSYbyZDL7pzcpvN7Z2lFi15083ByHpyg+9zTOGhJHQdL3NPsBoYvz3VBIagUjp
         bN2ZViApimxR5aMb2X+pclRIJlDGiPxMElQp8t4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 4.14 162/173] arm64: cpufeature: Fix the type of no FP/SIMD capability
Date:   Thu, 13 Feb 2020 07:21:05 -0800
Message-Id: <20200213152012.031049106@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 449443c03d8cfdacf7313e17779a2594ebf87e6d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/cpufeature.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1103,7 +1103,7 @@ static const struct arm64_cpu_capabiliti
 	{
 		/* FP/SIMD is not implemented */
 		.capability = ARM64_HAS_NO_FPSIMD,
-		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.type = ARM64_CPUCAP_BOOT_RESTRICTED_CPU_LOCAL_FEATURE,
 		.min_field_value = 0,
 		.matches = has_no_fpsimd,
 	},


