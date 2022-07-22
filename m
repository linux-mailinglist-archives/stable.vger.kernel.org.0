Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D456857DDD6
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbiGVJOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbiGVJNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:13:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382D1A6FA2;
        Fri, 22 Jul 2022 02:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABFC661F4C;
        Fri, 22 Jul 2022 09:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4249C341CA;
        Fri, 22 Jul 2022 09:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481035;
        bh=kC8Yo+zlmSXkHVKbkmutWgRB5JaAAmyWQj1eufr2znI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnbsR9wNCeryGJ65kVqGVN7RNGW4SNDxhFs3LztUbF+tPKJPiUl2Xy1h7StIKEE/8
         aJdMhISfk5XpFKlxiBkk/RNqT/4joKj7yYsTT4YT62kfbMMgWsOPow+GvkVMUN25te
         O/dOp+Ptr+FMvwvkvrZyJFlpLf8xE6G9KrqjcJLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 54/70] x86/cpu/amd: Enumerate BTC_NO
Date:   Fri, 22 Jul 2022 11:07:49 +0200
Message-Id: <20220722090653.770944471@linuxfoundation.org>
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

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 26aae8ccbc1972233afd08fb3f368947c0314265 upstream.

BTC_NO indicates that hardware is not susceptible to Branch Type Confusion.

Zen3 CPUs don't suffer BTC.

Hypervisors are expected to synthesise BTC_NO when it is appropriate
given the migration pool, to prevent kernels using heuristics.

  [ bp: Massage. ]

Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: no X86_FEATURE_BRS]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/amd.c          |   21 +++++++++++++++------
 arch/x86/kernel/cpu/common.c       |    6 ++++--
 3 files changed, 20 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -321,6 +321,7 @@
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
 #define X86_FEATURE_CPPC		(13*32+27) /* Collaborative Processor Performance Control */
+#define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
 #define X86_FEATURE_DTHERM		(14*32+ 0) /* Digital Thermal Sensor */
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -890,12 +890,21 @@ static void init_amd_zn(struct cpuinfo_x
 	node_reclaim_distance = 32;
 #endif
 
-	/*
-	 * Fix erratum 1076: CPB feature bit not being set in CPUID.
-	 * Always set it, except when running under a hypervisor.
-	 */
-	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !cpu_has(c, X86_FEATURE_CPB))
-		set_cpu_cap(c, X86_FEATURE_CPB);
+	/* Fix up CPUID bits, but only if not virtualised. */
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR)) {
+
+		/* Erratum 1076: CPB feature bit not being set in CPUID. */
+		if (!cpu_has(c, X86_FEATURE_CPB))
+			set_cpu_cap(c, X86_FEATURE_CPB);
+
+		/*
+		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
+		 * Branch Type Confusion, but predate the allocation of the
+		 * BTC_NO bit.
+		 */
+		if (c->x86 == 0x19 && !cpu_has(c, X86_FEATURE_BTC_NO))
+			set_cpu_cap(c, X86_FEATURE_BTC_NO);
+	}
 }
 
 static void init_amd(struct cpuinfo_x86 *c)
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1385,8 +1385,10 @@ static void __init cpu_set_bug_bits(stru
 	    !arch_cap_mmio_immune(ia32_cap))
 		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
 
-	if ((cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA)))
-		setup_force_cpu_bug(X86_BUG_RETBLEED);
+	if (!cpu_has(c, X86_FEATURE_BTC_NO)) {
+		if (cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA))
+			setup_force_cpu_bug(X86_BUG_RETBLEED);
+	}
 
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;


