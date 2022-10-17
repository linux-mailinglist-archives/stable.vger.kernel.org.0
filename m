Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A98601710
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiJQTLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiJQTLf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:11:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D403760EA;
        Mon, 17 Oct 2022 12:11:31 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:11:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666033889;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+K/LF3gOLZyxOasTOOEkznw74NPYB2E/kdEKukMJhj4=;
        b=pnEFNaz0P+ne6jaxuR8SXYE8+hgqgf8ezOPExaO0JIH2A59ckD1z9XLm+pAOX/B3Lfk/R7
        1b1aSh7s8+W4GBCPrXqdacpoDzTkG2s6X0Qc7VpD4ziE860XPj678IPblmAPUo8thbfe0M
        4LfCZ6CrcgWHUg8nloaRRWRL/eIQro8te0eATw4EBaqJ7KWj+5cbnTq+wIgV78AP18GPQO
        d4Sn58wYmodoJLARpa16E7Hw4tK8Ulxakyr/VHShGBuXrOL3KRhNIUETi+Oe4MzWYGnqDA
        QtBtdBpsWQdPIRyNIlWdNirChZpzKA9hQHbyis4tKPrB71ht6vOgx3PxzKD4/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666033889;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+K/LF3gOLZyxOasTOOEkznw74NPYB2E/kdEKukMJhj4=;
        b=SifvABbZANarB2xn4K3Je1RopU2jJR3qgsUrsh8UUYS059qAL+YTdPdMb6i+/bDvsXg5tt
        byxVpyOvKAuzjBCA==
From:   "tip-bot2 for Zhang Rui" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/topology: Fix multiple packages shown on a
 single-package system
Cc:     Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221014090147.1836-4-rui.zhang@intel.com>
References: <20221014090147.1836-4-rui.zhang@intel.com>
MIME-Version: 1.0
Message-ID: <166603388268.401.1191070273039259213.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     2b12a7a126d62bdbd81f4923c21bf6e9a7fbd069
Gitweb:        https://git.kernel.org/tip/2b12a7a126d62bdbd81f4923c21bf6e9a7fbd069
Author:        Zhang Rui <rui.zhang@intel.com>
AuthorDate:    Fri, 14 Oct 2022 17:01:46 +08:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Mon, 17 Oct 2022 11:58:52 -07:00

x86/topology: Fix multiple packages shown on a single-package system

CPUID.1F/B does not enumerate Package level explicitly, instead, all the
APIC-ID bits above the enumerated levels are assumed to be package ID
bits.

Current code gets package ID by shifting out all the APIC-ID bits that
Linux supports, rather than shifting out all the APIC-ID bits that
CPUID.1F enumerates. This introduces problems when CPUID.1F enumerates a
level that Linux does not support.

For example, on a single package AlderLake-N, there are 2 Ecore Modules
with 4 atom cores in each module.  Linux does not support the Module
level and interprets the Module ID bits as package ID and erroneously
reports a multi module system as a multi-package system.

Fix this by using APIC-ID bits above all the CPUID.1F enumerated levels
as package ID.

[ dhansen: spelling fix ]

Fixes: 7745f03eb395 ("x86/topology: Add CPUID.1F multi-die/package support")
Suggested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221014090147.1836-4-rui.zhang@intel.com
---
 arch/x86/kernel/cpu/topology.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 132a2de..f759281 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -96,6 +96,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	unsigned int ht_mask_width, core_plus_mask_width, die_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
 	unsigned int die_select_mask, die_level_siblings;
+	unsigned int pkg_mask_width;
 	bool die_level_present = false;
 	int leaf;
 
@@ -111,10 +112,10 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
 	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 	die_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
-	die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+	pkg_mask_width = die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 
 	sub_index = 1;
-	do {
+	while (true) {
 		cpuid_count(leaf, sub_index, &eax, &ebx, &ecx, &edx);
 
 		/*
@@ -132,8 +133,13 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 			die_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
 		}
 
+		if (LEAFB_SUBTYPE(ecx) != INVALID_TYPE)
+			pkg_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+		else
+			break;
+
 		sub_index++;
-	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
+	}
 
 	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
 	die_select_mask = (~(-1 << die_plus_mask_width)) >>
@@ -148,7 +154,7 @@ int detect_extended_topology(struct cpuinfo_x86 *c)
 	}
 
 	c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid,
-				die_plus_mask_width);
+				pkg_mask_width);
 	/*
 	 * Reinit the apicid, now that we have extended initial_apicid.
 	 */
