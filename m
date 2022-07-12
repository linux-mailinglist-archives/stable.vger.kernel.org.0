Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9119D57242A
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbiGLS41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbiGLSz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:55:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE812DB2F4;
        Tue, 12 Jul 2022 11:46:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D42B81BAB;
        Tue, 12 Jul 2022 18:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F96C3411C;
        Tue, 12 Jul 2022 18:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651590;
        bh=27eIWJulyqSRKoMB+Qg9COgotQ0OI5jj3NKghFqH9oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/qjLTwCdaTYlw2q/3bCVBHYZFhiWEEfL0ytipwomuBgWnL8WtZNMhTcwbcBo33sS
         o8o83bugskX0hgxmuuSl+q/jV6zdrn5b9bOfaTLpBUbuhyBwW0KR0S+WvS/fJ1RZ+R
         avDy2AV96vGZijr8KIW5t1TNkjzshe3b+5S6zwXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 124/130] x86/cpu/amd: Enumerate BTC_NO
Date:   Tue, 12 Jul 2022 20:39:30 +0200
Message-Id: <20220712183252.194478286@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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
[cascardo: no X86_FEATURE_CPPC]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/kernel/cpu/amd.c          |   21 +++++++++++++++------
 arch/x86/kernel/cpu/common.c       |    6 ++++--
 3 files changed, 20 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -316,6 +316,7 @@
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
+#define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
 #define X86_FEATURE_DTHERM		(14*32+ 0) /* Digital Thermal Sensor */
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -942,12 +942,21 @@ static void init_amd_zn(struct cpuinfo_x
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
@@ -1246,8 +1246,10 @@ static void __init cpu_set_bug_bits(stru
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


