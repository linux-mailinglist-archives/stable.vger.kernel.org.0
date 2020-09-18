Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481D227028A
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 18:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgIRQrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 12:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgIRQrr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 12:47:47 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A67B208C3;
        Fri, 18 Sep 2020 16:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600447663;
        bh=VXUNsN1XPreMcAXiT3v9T3RtLBfrasyzA2EQatmr8a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3R+RtrTeNyLvYRPfnQuSboPEdz0WtQwIdjkykDtrG8SEAtWywh55dPZB34c8Cyc5
         +gcXERCTQ1foIYqAc7nQUWQiR37QSEmEpa1g/EWCxMirjDhfkh8hL3FXV10L1PRJlT
         MEEbR8BgXPR+ssRtnJvNymBEdFQc36dNcIZrG0cg=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 02/19] arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs
Date:   Fri, 18 Sep 2020 17:47:12 +0100
Message-Id: <20200918164729.31994-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200918164729.31994-1-will@kernel.org>
References: <20200918164729.31994-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Commit 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lack
thereof") changed the way we deal with ARCH_WORKAROUND_1, by moving most
of the enabling code to the .matches() callback.

This has the unfortunate effect that the workaround gets only enabled on
the first affected CPU, and no other.

In order to address this, forcefully call the .matches() callback from a
.cpu_enable() callback, which brings us back to the original behaviour.

Fixes: 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lack thereof")
Cc: <stable@vger.kernel.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpu_errata.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 88966496806a..3fe64bf5a58d 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -599,6 +599,12 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	return (need_wa > 0);
 }
 
+static void
+cpu_enable_branch_predictor_hardening(const struct arm64_cpu_capabilities *cap)
+{
+	cap->matches(cap, SCOPE_LOCAL_CPU);
+}
+
 static const __maybe_unused struct midr_range tx2_family_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
 	MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
@@ -890,9 +896,11 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	},
 #endif
 	{
+		.desc = "Branch predictor hardening",
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = check_branch_predictor,
+		.cpu_enable = cpu_enable_branch_predictor_hardening,
 	},
 #ifdef CONFIG_RANDOMIZE_BASE
 	{
-- 
2.28.0.681.g6f77f65b4e-goog

