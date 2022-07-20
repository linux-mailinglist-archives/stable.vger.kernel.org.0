Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2A657AC3F
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241795AbiGTBWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241798AbiGTBWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:22:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3E171734;
        Tue, 19 Jul 2022 18:16:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 914E6617EC;
        Wed, 20 Jul 2022 01:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986ECC341CB;
        Wed, 20 Jul 2022 01:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279814;
        bh=++U9REmFtKLSimJCn3EEeiYM7bT2zZAvYk8/WKE0Hno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfP5z8vcb4C2r8Y6MtAfyTeMfC1r0NX5PaTq13I+z379ogJVngrs2xYSQdbsxuZnk
         1OPVIRetLlP1lDqx9gjbyIaSyKF/tKlic+UjVbLq5g6G/ZeA6syDRgNm3tkcyerJq4
         Dbby2gqLqKpG55aGS0T5ePwQE6EEQNDQXS48dddBHXvRAWx41XKICM2hIPT4mDvka+
         NulHPJ8euV5cpO5dEAJJ11388z576v9WEC8XAG8bXKUjRs8473jNI5QyIfXc/nAwwq
         /jHheQwVAZkVrvhwgzvxRzv0aw76xn69BPyTbHz8do410GVolGX3FguPFt+nF3rDNG
         bPRNdTpJcnMRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, puwen@hygon.cn, pawan.kumar.gupta@linux.intel.com,
        adrian.hunter@intel.com, alexander.shishkin@linux.intel.com,
        chang.seok.bae@intel.com, sumeet.r.pawnikar@intel.com,
        ray.huang@amd.com, tony.luck@intel.com,
        ricardo.neri-calderon@linux.intel.com, mario.limonciello@amd.com,
        andrew.cooper3@citrix.com, kim.phillips@amd.com,
        jane.malalane@citrix.com
Subject: [PATCH AUTOSEL 5.10 08/25] x86/cpu/amd: Add Spectral Chicken
Date:   Tue, 19 Jul 2022 21:15:59 -0400
Message-Id: <20220720011616.1024753-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011616.1024753-1-sashal@kernel.org>
References: <20220720011616.1024753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d7caac991feeef1b871ee6988fd2c9725df09039 ]

Zen2 uarchs have an undocumented, unnamed, MSR that contains a chicken
bit for some speculation behaviour. It needs setting.

Note: very belatedly AMD released naming; it's now officially called
      MSR_AMD64_DE_CFG2 and MSR_AMD64_DE_CFG2_SUPPRESS_NOBR_PRED_BIT
      but shall remain the SPECTRAL CHICKEN.

Suggested-by: Andrew Cooper <Andrew.Cooper3@citrix.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/kernel/cpu/amd.c        | 23 ++++++++++++++++++++++-
 arch/x86/kernel/cpu/cpu.h        |  2 ++
 arch/x86/kernel/cpu/hygon.c      |  6 ++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 96973d197972..ded2f9b32aee 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -507,6 +507,9 @@
 /* Fam 17h MSRs */
 #define MSR_F17H_IRPERF			0xc00000e9
 
+#define MSR_ZEN2_SPECTRAL_CHICKEN	0xc00110e3
+#define MSR_ZEN2_SPECTRAL_CHICKEN_BIT	BIT_ULL(1)
+
 /* Fam 16h MSRs */
 #define MSR_F16H_L2I_PERF_CTL		0xc0010230
 #define MSR_F16H_L2I_PERF_CTR		0xc0010231
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index acea05eed27d..f1f52e67e361 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -914,6 +914,26 @@ static void init_amd_bd(struct cpuinfo_x86 *c)
 	clear_rdrand_cpuid_bit(c);
 }
 
+void init_spectral_chicken(struct cpuinfo_x86 *c)
+{
+	u64 value;
+
+	/*
+	 * On Zen2 we offer this chicken (bit) on the altar of Speculation.
+	 *
+	 * This suppresses speculation from the middle of a basic block, i.e. it
+	 * suppresses non-branch predictions.
+	 *
+	 * We use STIBP as a heuristic to filter out Zen2 from the rest of F17H
+	 */
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && cpu_has(c, X86_FEATURE_AMD_STIBP)) {
+		if (!rdmsrl_safe(MSR_ZEN2_SPECTRAL_CHICKEN, &value)) {
+			value |= MSR_ZEN2_SPECTRAL_CHICKEN_BIT;
+			wrmsrl_safe(MSR_ZEN2_SPECTRAL_CHICKEN, value);
+		}
+	}
+}
+
 static void init_amd_zn(struct cpuinfo_x86 *c)
 {
 	set_cpu_cap(c, X86_FEATURE_ZEN);
@@ -959,7 +979,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 	case 0x12: init_amd_ln(c); break;
 	case 0x15: init_amd_bd(c); break;
 	case 0x16: init_amd_jg(c); break;
-	case 0x17: fallthrough;
+	case 0x17: init_spectral_chicken(c);
+		   fallthrough;
 	case 0x19: init_amd_zn(c); break;
 	}
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 093f5fc860e3..91df90abc1d9 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -60,6 +60,8 @@ extern void tsx_disable(void);
 static inline void tsx_init(void) { }
 #endif /* CONFIG_CPU_SUP_INTEL */
 
+extern void init_spectral_chicken(struct cpuinfo_x86 *c);
+
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void get_cpu_address_sizes(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index b78c471ec344..774ca6bfda9f 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -318,6 +318,12 @@ static void init_hygon(struct cpuinfo_x86 *c)
 	/* get apicid instead of initial apic id from cpuid */
 	c->apicid = hard_smp_processor_id();
 
+	/*
+	 * XXX someone from Hygon needs to confirm this DTRT
+	 *
+	init_spectral_chicken(c);
+	 */
+
 	set_cpu_cap(c, X86_FEATURE_ZEN);
 	set_cpu_cap(c, X86_FEATURE_CPB);
 
-- 
2.35.1

