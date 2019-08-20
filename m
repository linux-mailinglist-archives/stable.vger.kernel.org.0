Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4B39611B
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbfHTNpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730292AbfHTNml (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:42:41 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C800222DA7;
        Tue, 20 Aug 2019 13:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308560;
        bh=wdaSxoTkah2zmmnyit3p019vdd45C7Dds6hWxuITWNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tX2WzZfb+f7dM4YcRI2hieISjAvpnzJJ7bjocdMgnDbnMhEKgNK7yFqBpnIRIvwy9
         k3ZqMWej1nb/IMPeJp9ObMZRX//Q3Vo4HsAQDYQtVysyPLyAng2jop5OPsFwBbeBGo
         hDckGi/c13iEC/6BQTuFRKSn3Vf0xqXN7OK0A51A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 21/27] arm64: cpufeature: Don't treat granule sizes as strict
Date:   Tue, 20 Aug 2019 09:42:07 -0400
Message-Id: <20190820134213.11279-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134213.11279-1-sashal@kernel.org>
References: <20190820134213.11279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 5717fe5ab38f9ccb32718bcb03bea68409c9cce4 ]

If a CPU doesn't support the page size for which the kernel is
configured, then we will complain and refuse to bring it online. For
secondary CPUs (and the boot CPU on a system booting with EFI), we will
also print an error identifying the mismatch.

Consequently, the only time that the cpufeature code can detect a
granule size mismatch is for a granule other than the one that is
currently being used. Although we would rather such systems didn't
exist, we've unfortunately lost that battle and Kevin reports that
on his amlogic S922X (odroid-n2 board) we end up warning and taining
with defconfig because 16k pages are not supported by all of the CPUs.

In such a situation, we don't actually care about the feature mismatch,
particularly now that KVM only exposes the sanitised view of the CPU
registers (commit 93390c0a1b20 - "arm64: KVM: Hide unsupported AArch64
CPU features from guests"). Treat the granule fields as non-strict and
let Kevin run without a tainted kernel.

Cc: Marc Zyngier <maz@kernel.org>
Reported-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[catalin.marinas@arm.com: changelog updated with KVM sanitised regs commit]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index bce06083685dc..94babc3d0ec2c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -165,9 +165,17 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr0[] = {
-	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN4_SHIFT, 4, ID_AA64MMFR0_TGRAN4_NI),
-	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN64_SHIFT, 4, ID_AA64MMFR0_TGRAN64_NI),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN16_SHIFT, 4, ID_AA64MMFR0_TGRAN16_NI),
+	/*
+	 * We already refuse to boot CPUs that don't support our configured
+	 * page size, so we can only detect mismatches for a page size other
+	 * than the one we're currently using. Unfortunately, SoCs like this
+	 * exist in the wild so, even though we don't like it, we'll have to go
+	 * along with it and treat them as non-strict.
+	 */
+	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN4_SHIFT, 4, ID_AA64MMFR0_TGRAN4_NI),
+	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN64_SHIFT, 4, ID_AA64MMFR0_TGRAN64_NI),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN16_SHIFT, 4, ID_AA64MMFR0_TGRAN16_NI),
+
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_BIGENDEL0_SHIFT, 4, 0),
 	/* Linux shouldn't care about secure memory */
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR0_SNSMEM_SHIFT, 4, 0),
-- 
2.20.1

