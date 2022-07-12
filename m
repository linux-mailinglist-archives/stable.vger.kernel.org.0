Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAA75724C4
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbiGLTDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiGLTCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:02:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD79ED31CE;
        Tue, 12 Jul 2022 11:49:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9FDE61257;
        Tue, 12 Jul 2022 18:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB99C3411C;
        Tue, 12 Jul 2022 18:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651788;
        bh=FvMTOIgEJ/F9Sx4tLyEeltEoAwGGywAYye6RJJqo0P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUcXwoIFNgxM0v7nJEK4MMo0ij/VzFyaA9qJZ00KeIFkFAH2bpv5WadtAzeGVxea4
         s0mFqLHh/0mXisY4weTKk7E9g4DRi/lhfl+KB8HM/xnLzGiF7cBTkimb1SPlq7NjHU
         ceA4ceCtdVlLN+j03YC5n4vlqXXFy4VAVx1InyfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 58/78] x86/cpu/amd: Add Spectral Chicken
Date:   Tue, 12 Jul 2022 20:39:28 +0200
Message-Id: <20220712183241.233309010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
@@ -515,6 +515,9 @@
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
@@ -886,6 +886,26 @@ static void init_amd_bd(struct cpuinfo_x
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
@@ -931,7 +951,8 @@ static void init_amd(struct cpuinfo_x86
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
 


