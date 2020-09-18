Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F32D270289
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 18:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgIRQrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 12:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgIRQrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 12:47:46 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A646208DB;
        Fri, 18 Sep 2020 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600447665;
        bh=VnFBFLM/bxUHYkVbv3AvobJFSpGK92kSpEjwef6cZHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eR9hlMHez9/i4zYJYljRvmue8ZJuWUcv0r3Sc5hsxbR8DGFxGBWFKnw2Hq+WcYSVx
         pri6ZZTdDDnU6m5dHu8i/RFZwqvoh4Ilp8igv+T9mmDlOSHdZLtqn6tyUOmhn6mYzN
         e4Ah+1LmYi/ZDCyZMPADDyeb08rn0Wy+cTvtKeuk=
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 03/19] arm64: Run ARCH_WORKAROUND_2 enabling code on all CPUs
Date:   Fri, 18 Sep 2020 17:47:13 +0100
Message-Id: <20200918164729.31994-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200918164729.31994-1-will@kernel.org>
References: <20200918164729.31994-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

Commit 606f8e7b27bf ("arm64: capabilities: Use linear array for
detection and verification") changed the way we deal with per-CPU errata
by only calling the .matches() callback until one CPU is found to be
affected. At this point, .matches() stop being called, and .cpu_enable()
will be called on all CPUs.

This breaks the ARCH_WORKAROUND_2 handling, as only a single CPU will be
mitigated.

In order to address this, forcefully call the .matches() callback from a
.cpu_enable() callback, which brings us back to the original behaviour.

Fixes: 606f8e7b27bf ("arm64: capabilities: Use linear array for detection and verification")
Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpu_errata.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 3fe64bf5a58d..abfef5f3b5fd 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -457,6 +457,12 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 	return required;
 }
 
+static void cpu_enable_ssbd_mitigation(const struct arm64_cpu_capabilities *cap)
+{
+	if (ssbd_state != ARM64_SSBD_FORCE_DISABLE)
+		cap->matches(cap, SCOPE_LOCAL_CPU);
+}
+
 /* known invulnerable cores */
 static const struct midr_range arm64_ssb_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A35),
@@ -914,6 +920,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_SSBD,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = has_ssbd_mitigation,
+		.cpu_enable = cpu_enable_ssbd_mitigation,
 		.midr_range_list = arm64_ssb_cpus,
 	},
 #ifdef CONFIG_ARM64_ERRATUM_1418040
-- 
2.28.0.681.g6f77f65b4e-goog

