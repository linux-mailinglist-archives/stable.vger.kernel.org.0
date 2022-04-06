Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE03F4F6952
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239902AbiDFSIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240353AbiDFSHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:07:48 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 65BB71081A5;
        Wed,  6 Apr 2022 09:46:02 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 205CF23A;
        Wed,  6 Apr 2022 09:46:02 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72DC83F73B;
        Wed,  6 Apr 2022 09:46:01 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 02/43] arm64: Remove useless UAO IPI and describe how this gets enabled
Date:   Wed,  6 Apr 2022 17:45:05 +0100
Message-Id: <20220406164546.1888528-2-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c8b06e3fddddaae1a87ed479edcb8b3d85caecc7 upstream.

Since its introduction, the UAO enable call was broken, and useless.
commit 2a6dcb2b5f3e ("arm64: cpufeature: Schedule enable() calls instead
of calling them via IPI"), fixed the framework so that these calls
are scheduled, so that they can modify PSTATE.

Now it is just useless. Remove it. UAO is enabled by the code patching
which causes get_user() and friends to use the 'ldtr' family of
instructions. This relies on the PSTATE.UAO bit being set to match
addr_limit, which we do in uao_thread_switch() called via __switch_to().

All that is needed to enable UAO is patch the code, and call schedule().
__apply_alternatives_multi_stop() calls stop_machine() when it modifies
the kernel text to enable the alternatives, (including the UAO code in
uao_thread_switch()). Once stop_machine() has finished __switch_to() is
called to reschedule the original task, this causes PSTATE.UAO to be set
appropriately. An explicit enable() call is not needed.

Reported-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/processor.h |  1 -
 arch/arm64/kernel/cpufeature.c     |  5 ++++-
 arch/arm64/mm/fault.c              | 14 --------------
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 9ee660013e5c..d27e472bbbf1 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -220,7 +220,6 @@ static inline void spin_lock_prefetch(const void *ptr)
 #endif
 
 int cpu_enable_pan(void *__unused);
-int cpu_enable_uao(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 4130a901ae0d..6601dd4005c3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -905,7 +905,10 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sys_reg = SYS_ID_AA64MMFR2_EL1,
 		.field_pos = ID_AA64MMFR2_UAO_SHIFT,
 		.min_field_value = 1,
-		.enable = cpu_enable_uao,
+		/*
+		 * We rely on stop_machine() calling uao_thread_switch() to set
+		 * UAO immediately after patching.
+		 */
 	},
 #endif /* CONFIG_ARM64_UAO */
 #ifdef CONFIG_ARM64_PAN
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index f3d3f2e97add..e973002530de 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -740,17 +740,3 @@ int cpu_enable_pan(void *__unused)
 	return 0;
 }
 #endif /* CONFIG_ARM64_PAN */
-
-#ifdef CONFIG_ARM64_UAO
-/*
- * Kernel threads have fs=KERNEL_DS by default, and don't need to call
- * set_fs(), devtmpfs in particular relies on this behaviour.
- * We need to enable the feature at runtime (instead of adding it to
- * PSR_MODE_EL1h) as the feature may not be implemented by the cpu.
- */
-int cpu_enable_uao(void *__unused)
-{
-	asm(SET_PSTATE_UAO(1));
-	return 0;
-}
-#endif /* CONFIG_ARM64_UAO */
-- 
2.30.2

