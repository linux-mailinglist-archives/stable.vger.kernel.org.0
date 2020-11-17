Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDE52B5FA0
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgKQM5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728676AbgKQM5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E519A2151B;
        Tue, 17 Nov 2020 12:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617854;
        bh=mn5e3Dlske3ZUDRWwFsai4wH+HucmlGe0HDn+//g7NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcHWADuzafgP/ALou5D2s19EJWvtkyxAmPtSYEqVgxIwiEfqXlVerE848t6DDCosR
         Aq/9M2keH9cm84e53BV32PN2h2TfSPtCTgvWU4nMbrtKNiZFZI1bYj68z4paFLLKl4
         89Wv9ubrEAhH3Uzl8YVCbknrQSpsaOk8Hnyp7HtY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 05/11] arm64: errata: Fix handling of 1418040 with late CPU onlining
Date:   Tue, 17 Nov 2020 07:57:19 -0500
Message-Id: <20201117125725.599833-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125725.599833-1-sashal@kernel.org>
References: <20201117125725.599833-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit f969f03888b9438fdb227b6460d99ede5737326d ]

In a surprising turn of events, it transpires that CPU capabilities
configured as ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE are never set as the
result of late-onlining. Therefore our handling of erratum 1418040 does
not get activated if it is not required by any of the boot CPUs, even
though we allow late-onlining of an affected CPU.

In order to get things working again, replace the cpus_have_const_cap()
invocation with an explicit check for the current CPU using
this_cpu_has_cap().

Cc: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201106114952.10032-1-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 2 ++
 arch/arm64/kernel/process.c         | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 10d3048dec7c2..ccae05da98a7f 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -262,6 +262,8 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
 /*
  * CPU feature detected at boot time based on feature of one or more CPUs.
  * All possible conflicts for a late CPU are ignored.
+ * NOTE: this means that a late CPU with the feature will *not* cause the
+ * capability to be advertised by cpus_have_*cap()!
  */
 #define ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE		\
 	(ARM64_CPUCAP_SCOPE_LOCAL_CPU		|	\
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 10190c4b16dc4..7d7cfa128b71b 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -511,14 +511,13 @@ static void erratum_1418040_thread_switch(struct task_struct *prev,
 	bool prev32, next32;
 	u64 val;
 
-	if (!(IS_ENABLED(CONFIG_ARM64_ERRATUM_1418040) &&
-	      cpus_have_const_cap(ARM64_WORKAROUND_1418040)))
+	if (!IS_ENABLED(CONFIG_ARM64_ERRATUM_1418040))
 		return;
 
 	prev32 = is_compat_thread(task_thread_info(prev));
 	next32 = is_compat_thread(task_thread_info(next));
 
-	if (prev32 == next32)
+	if (prev32 == next32 || !this_cpu_has_cap(ARM64_WORKAROUND_1418040))
 		return;
 
 	val = read_sysreg(cntkctl_el1);
-- 
2.27.0

