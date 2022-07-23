Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D2157EE82
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbiGWKMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbiGWKKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:10:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6D3D0660;
        Sat, 23 Jul 2022 03:03:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BFCB61263;
        Sat, 23 Jul 2022 10:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E4BC341C0;
        Sat, 23 Jul 2022 10:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570593;
        bh=N4ZoAMH1labCB/9pAJSInhlWqw/PW7AQbISNPRZAbYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkFjTiqcoKLm0S/NkJdE+ZOmuKsqsaJwLu/R7jWswvGEu6ovwlh4DQ8WgHlFlxdgT
         IPbQE1zMb1qXrnHivzSvfNfYVsS++K+e7GIADMs6lmqZ6Y31ujfmds78g4dHGnZCrl
         MgMfb1e95fN/IX49c8CNOq+9DHpFzrKmpGaQ04uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>, Ian Rogers <irogers@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 141/148] tools headers cpufeatures: Sync with the kernel sources
Date:   Sat, 23 Jul 2022 11:55:53 +0200
Message-Id: <20220723095303.842060788@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit f098addbdb44c8a565367f5162f3ab170ed9404a upstream.

To pick the changes from:

  f43b9876e857c739 ("x86/retbleed: Add fine grained Kconfig knobs")
  a149180fbcf336e9 ("x86: Add magic AMD return-thunk")
  15e67227c49a5783 ("x86: Undo return-thunk damage")
  369ae6ffc41a3c11 ("x86/retpoline: Cleanup some #ifdefery")
  4ad3278df6fe2b08 x86/speculation: Disable RRSBA behavior
  26aae8ccbc197223 x86/cpu/amd: Enumerate BTC_NO
  9756bba28470722d x86/speculation: Fill RSB on vmexit for IBRS
  3ebc170068885b6f x86/bugs: Add retbleed=ibpb
  2dbb887e875b1de3 x86/entry: Add kernel IBRS implementation
  6b80b59b35557065 x86/bugs: Report AMD retbleed vulnerability
  a149180fbcf336e9 x86: Add magic AMD return-thunk
  15e67227c49a5783 x86: Undo return-thunk damage
  a883d624aed463c8 x86/cpufeatures: Move RETPOLINE flags to word 11
  51802186158c74a0 x86/speculation/mmio: Enumerate Processor MMIO Stale Data bug

This only causes these perf files to be rebuilt:

  CC       /tmp/build/perf/bench/mem-memcpy-x86-64-asm.o
  CC       /tmp/build/perf/bench/mem-memset-x86-64-asm.o

And addresses this perf build warning:

  Warning: Kernel ABI header at 'tools/arch/x86/include/asm/cpufeatures.h' differs from latest version at 'arch/x86/include/asm/cpufeatures.h'
  diff -u tools/arch/x86/include/asm/cpufeatures.h arch/x86/include/asm/cpufeatures.h
  Warning: Kernel ABI header at 'tools/arch/x86/include/asm/disabled-features.h' differs from latest version at 'arch/x86/include/asm/disabled-features.h'
  diff -u tools/arch/x86/include/asm/disabled-features.h arch/x86/include/asm/disabled-features.h

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org
Link: https://lore.kernel.org/lkml/YtQM40VmiLTkPND2@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/arch/x86/include/asm/cpufeatures.h       |   12 ++++++++++--
 tools/arch/x86/include/asm/disabled-features.h |   21 ++++++++++++++++++++-
 2 files changed, 30 insertions(+), 3 deletions(-)

--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -203,8 +203,8 @@
 #define X86_FEATURE_PROC_FEEDBACK	( 7*32+ 9) /* AMD ProcFeedbackInterface */
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
-#define X86_FEATURE_RETPOLINE		( 7*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
-#define X86_FEATURE_RETPOLINE_LFENCE	( 7*32+13) /* "" Use LFENCEs for Spectre variant 2 */
+#define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
+#define X86_FEATURE_RSB_VMEXIT		( 7*32+13) /* "" Fill RSB on VM-Exit */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
@@ -290,6 +290,12 @@
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
+#define X86_FEATURE_ENTRY_IBPB		(11*32+10) /* "" Issue an IBPB on kernel entry */
+#define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
+#define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
+#define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
+#define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
@@ -308,6 +314,7 @@
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
+#define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
 #define X86_FEATURE_DTHERM		(14*32+ 0) /* Digital Thermal Sensor */
@@ -418,5 +425,6 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
+#define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/tools/arch/x86/include/asm/disabled-features.h
+++ b/tools/arch/x86/include/asm/disabled-features.h
@@ -56,6 +56,25 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_RETPOLINE
+# define DISABLE_RETPOLINE	0
+#else
+# define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
+				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)))
+#endif
+
+#ifdef CONFIG_RETHUNK
+# define DISABLE_RETHUNK	0
+#else
+# define DISABLE_RETHUNK	(1 << (X86_FEATURE_RETHUNK & 31))
+#endif
+
+#ifdef CONFIG_CPU_UNRET_ENTRY
+# define DISABLE_UNRET		0
+#else
+# define DISABLE_UNRET		(1 << (X86_FEATURE_UNRET & 31))
+#endif
+
 #ifdef CONFIG_IOMMU_SUPPORT
 # define DISABLE_ENQCMD	0
 #else
@@ -76,7 +95,7 @@
 #define DISABLED_MASK8	0
 #define DISABLED_MASK9	(DISABLE_SMAP)
 #define DISABLED_MASK10	0
-#define DISABLED_MASK11	0
+#define DISABLED_MASK11	(DISABLE_RETPOLINE|DISABLE_RETHUNK|DISABLE_UNRET)
 #define DISABLED_MASK12	0
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0


