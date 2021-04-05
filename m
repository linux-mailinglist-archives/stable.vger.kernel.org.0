Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2F335448A
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242005AbhDEQFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238731AbhDEQFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B46A0613C3;
        Mon,  5 Apr 2021 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638717;
        bh=XRLwauBjsFty1c92SC3fTmJm4Yvrr7casJYIy7PUltw=;
        h=From:To:Cc:Subject:Date:From;
        b=B/bw4J89nBgTk6Up+60FOO3IcUmnubVhBdfOg13CLGG14QUB1YW81+VTYgg3Ue6Kd
         6WXgmF1JmasgV87/8giUDxQ6oG+lvcmHYj5VoxAnvBV4ek7yQrgPfQaNnMenFPPEvt
         GEnhaMlVpACANztTFexBF3WK6SQz9i4ahGSN5hk9DiNIIekSYdxLfUsKwW3E9UjufK
         rsCldxT+relV8iJ3kEr/CUmoQJ/epf8eWM0AFzWk8rg4D+W1zmeVCTr+MvrXMvWtNu
         ZldGnvYT/GSyOOE+QzMqS8eRUkLdB/FYJA/Px5IssecTQjNdt1e1JbM2tX/aOSNHEX
         kS8uoZ+J9lzFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 1/8] KVM: arm64: Hide system instruction access to Trace registers
Date:   Mon,  5 Apr 2021 12:05:08 -0400
Message-Id: <20210405160515.269020-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1719d21a171a..122d5e843ab6 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -258,7 +258,6 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
 	 * of support.
 	 */
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_TRACEVER_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
 	ARM64_FTR_END,
 };
-- 
2.30.2

