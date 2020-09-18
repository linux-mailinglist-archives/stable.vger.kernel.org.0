Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B550270288
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 18:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIRQrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 12:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgIRQrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 12:47:42 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A261220848;
        Fri, 18 Sep 2020 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600447661;
        bh=w7vFsvPBq3nzYv8w4nyIwlksGEBrob9M68Pl7nTluJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0orgizZCadlf2Q7YJ34LL8hP4XfP7C/b4PsTMpeXNBINNhLMdkNu0BDVwoLmlGBb
         NRp+AVrFShsG3c/SZAnljMqqR/qs4HNIQLGZhwpuEhqGs4Omcs2DAkifdvN+mOJjkS
         bjsimz48AnhLZpnKmoJuPrqInU1NMtD4Uu8ghSpQ=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 01/19] arm64: Make use of ARCH_WORKAROUND_1 even when KVM is not enabled
Date:   Fri, 18 Sep 2020 17:47:11 +0100
Message-Id: <20200918164729.31994-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200918164729.31994-1-will@kernel.org>
References: <20200918164729.31994-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

We seem to be pretending that we don't have any firmware mitigation
when KVM is not compiled in, which is not quite expected.

Bring back the mitigation in this case.

Fixes: 4db61fef16a1 ("arm64: kvm: Modernize __smccc_workaround_1_smc_start annotations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpu_errata.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index c332d49780dc..88966496806a 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -234,14 +234,17 @@ static int detect_harden_bp_fw(void)
 		smccc_end = NULL;
 		break;
 
-#if IS_ENABLED(CONFIG_KVM)
 	case SMCCC_CONDUIT_SMC:
 		cb = call_smc_arch_workaround_1;
+#if IS_ENABLED(CONFIG_KVM)
 		smccc_start = __smccc_workaround_1_smc;
 		smccc_end = __smccc_workaround_1_smc +
 			__SMCCC_WORKAROUND_1_SMC_SZ;
-		break;
+#else
+		smccc_start = NULL;
+		smccc_end = NULL;
 #endif
+		break;
 
 	default:
 		return -1;
-- 
2.28.0.681.g6f77f65b4e-goog

