Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2452C0A0C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733118AbgKWMnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733112AbgKWMnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2388C20732;
        Mon, 23 Nov 2020 12:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135421;
        bh=dcc9ZYODhGy88IwftRQKbI3ECgtQ+Xsb/S2yYHQYT2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2WcpdZaJPs87ncFIUWlMpf7uXGp+w0D7aJPX3nIdHDoWc4ZMv2EyRXM9iFn/Rry71
         9DGCKNdvFQVfDR7EpcAIXKLs1WAM/7ri8SwjoFX1xFiKABGgaIBzvdamBV3BTqWt2K
         h/UZHA9wTxAOG/BsFyALhgB5swBwKxvNXZotqwI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 063/252] arm64: errata: Fix handling of 1418040 with late CPU onlining
Date:   Mon, 23 Nov 2020 13:20:13 +0100
Message-Id: <20201123121838.634027747@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 89b4f0142c287..a986ecd0b0074 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -268,6 +268,8 @@ extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
 /*
  * CPU feature detected at boot time based on feature of one or more CPUs.
  * All possible conflicts for a late CPU are ignored.
+ * NOTE: this means that a late CPU with the feature will *not* cause the
+ * capability to be advertised by cpus_have_*cap()!
  */
 #define ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE		\
 	(ARM64_CPUCAP_SCOPE_LOCAL_CPU		|	\
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index f1804496b9350..2da5f3f9d345f 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -526,14 +526,13 @@ static void erratum_1418040_thread_switch(struct task_struct *prev,
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



