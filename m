Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27667354411
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242040AbhDEQE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241939AbhDEQEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FAD0613C0;
        Mon,  5 Apr 2021 16:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638650;
        bh=bldYsJMhq1A7UJmSqVLE6WnpzVR4p76hgx2zj/7yGA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDJBAfRQ0PbVNfebeLaOBqBqq5QzzPo+YRzyimA29Ip4RTkSou5mjdu3rOkExn9+a
         h/WAE5Y9xAAQ9cT2qFczH22FQORLl68SyvdILQifmUXHBUysm0B8MXKxgfQcmPoSZW
         xA19ogI2uI4yRga0pLJDXw4CYUrjjxIG+oX9pOX7PxlyjD4xS4Vtha5Hi4U9wWb0bR
         XqbZYC6pwNq4cWOT6PGcp159XT1wGKQ5ObUBNIi0213U7YNoHmk907IXFK1DSTsqo4
         7FXtJhsXkCQ65UzLD/YLVLe1MQP2YaL5HI9se7vtpjJ2XHXARo3bld1UUDcLRB+cDR
         qTTdYqBYIxIcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 03/22] KVM: arm64: Hide system instruction access to Trace registers
Date:   Mon,  5 Apr 2021 12:03:46 -0400
Message-Id: <20210405160406.268132-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160406.268132-1-sashal@kernel.org>
References: <20210405160406.268132-1-sashal@kernel.org>
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
index 33b6f56dcb21..22106062cb63 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -380,7 +380,6 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
 	 * of support.
 	 */
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_TRACEVER_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
 	ARM64_FTR_END,
 };
-- 
2.30.2

