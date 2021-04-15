Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9E5360D56
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhDOPBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234431AbhDOO6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:58:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D83F613D7;
        Thu, 15 Apr 2021 14:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498500;
        bh=dWdpBlt/F8Ey2+xsNIcXAu7JRQ3UrZYAdUFlHh9MDtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9W7HYo3IM3OePAbFzctQ8l2ep+3Cf2Gw32szGKeXSYmC8IudWLx0FPzZrufyaUHr
         pJzt5JlNsn4GH/oRO0dCUWi56gp+NiWnwHXH3ys6b4DSs7cjGDqGt+QOItCJy9h4nz
         ZhsNaYgpP+202Gv3/LqN6KE8STk6ieVQgab72BSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 60/68] KVM: arm64: Hide system instruction access to Trace registers
Date:   Thu, 15 Apr 2021 16:47:41 +0200
Message-Id: <20210415144416.440816817@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 1d676673d665fd2162e7e466dcfbe5373bfdb73e ]

Currently we advertise the ID_AA6DFR0_EL1.TRACEVER for the guest,
when the trace register accesses are trapped (CPTR_EL2.TTA == 1).
So, the guest will get an undefined instruction, if trusts the
ID registers and access one of the trace registers.
Lets be nice to the guest and hide the feature to avoid
unexpected behavior.

Even though this can be done at KVM sysreg emulation layer,
we do this by removing the TRACEVER from the sanitised feature
register field. This is fine as long as the ETM drivers
can handle the individual trace units separately, even
when there are differences among the CPUs.

Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210323120647.454211-2-suzuki.poulose@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 174aa12fb8b1..1481e18aa5ca 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -230,7 +230,6 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
 	 * of support.
 	 */
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_TRACEVER_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
 	ARM64_FTR_END,
 };
-- 
2.30.2



