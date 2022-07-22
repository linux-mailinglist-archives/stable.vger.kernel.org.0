Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025AB57DD94
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbiGVJMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235087AbiGVJL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:11:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EC9A0B91;
        Fri, 22 Jul 2022 02:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F77B827C8;
        Fri, 22 Jul 2022 09:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DE3C341C7;
        Fri, 22 Jul 2022 09:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658480990;
        bh=2MIJbf8TXQQVuRBlejKSL9UpaG5j6tBin2fze29fTlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZ2+OVZ1jDwOXmJ4ecLIywCNGtTobmzXzLE/WghUfWxnS2wLZ8OXdiUDuuu32FgKM
         9plf8d/5Qhc0lIkbKsYJAe3v+G4WvdvEeIuZx7Bz95myQ64jiS4dbvwFRQ7qS/Ze6f
         NSiNp9uhfNQjbGgBpRa5HYM1JbT0HyfE/NF5a12k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 40/70] x86/cpu/amd: Add Spectral Chicken
Date:   Fri, 22 Jul 2022 11:07:35 +0200
Message-Id: <20220722090652.962971847@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
References: <20220722090650.665513668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit d7caac991feeef1b871ee6988fd2c9725df09039 upstream.

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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h |    3 +++
 arch/x86/kernel/cpu/amd.c        |   23 ++++++++++++++++++++++-
 arch/x86/kernel/cpu/cpu.h        |    2 ++
 arch/x86/kernel/cpu/hygon.c      |    6 ++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -553,6 +553,9 @@
 /* Fam 17h MSRs */
 #define MSR_F17H_IRPERF			0xc00000e9
 
+#define MSR_ZEN2_SPECTRAL_CHICKEN	0xc00110e3
+#define MSR_ZEN2_SPECTRAL_CHICKEN_BIT	BIT_ULL(1)
+
 /* Fam 16h MSRs */
 #define MSR_F16H_L2I_PERF_CTL		0xc0010230
 #define MSR_F16H_L2I_PERF_CTR		0xc0010231
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -862,6 +862,26 @@ static void init_amd_bd(struct cpuinfo_x
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
@@ -907,7 +927,8 @@ static void init_amd(struct cpuinfo_x86
 	case 0x12: init_amd_ln(c); break;
 	case 0x15: init_amd_bd(c); break;
 	case 0x16: init_amd_jg(c); break;
-	case 0x17: fallthrough;
+	case 0x17: init_spectral_chicken(c);
+		   fallthrough;
 	case 0x19: init_amd_zn(c); break;
 	}
 
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -61,6 +61,8 @@ static inline void tsx_init(void) { }
 static inline void tsx_ap_init(void) { }
 #endif /* CONFIG_CPU_SUP_INTEL */
 
+extern void init_spectral_chicken(struct cpuinfo_x86 *c);
+
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void get_cpu_address_sizes(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -302,6 +302,12 @@ static void init_hygon(struct cpuinfo_x8
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
 


