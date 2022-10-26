Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBAC60E47B
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiJZP2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbiJZP2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:28:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7189C130D64
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A93161F93
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18229C433D6;
        Wed, 26 Oct 2022 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666798122;
        bh=7jcW7+6FgzJ+2xllqYYzB8jVeVD3L5lI0a8RjBmIeq0=;
        h=Subject:To:Cc:From:Date:From;
        b=q+occg51c8U+Dd1rSC187ICOQCmoMuV5Z70W8IwBsaS1qqOzin476eURQFtroi/Yl
         a4O6ll1ueoJRyBpjKmMiKsz3EzX3AGjcvWbMEj/oQ//YQnmOAkJB/0wIqeObE2l4mx
         9X3/b+WmcRy79aDZRPEdim6OrKy1fSzquqCVkP7s=
Subject: FAILED: patch "[PATCH] x86/topology: Fix multiple packages shown on a single-package" failed to apply to 5.4-stable tree
To:     rui.zhang@intel.com, dave.hansen@linux.intel.com,
        len.brown@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:28:39 +0200
Message-ID: <166679811928180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2b12a7a126d6 ("x86/topology: Fix multiple packages shown on a single-package system")
cb09a379724d ("x86/topology: Set cpu_die_id only if DIE_TYPE found")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2b12a7a126d62bdbd81f4923c21bf6e9a7fbd069 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Fri, 14 Oct 2022 17:01:46 +0800
Subject: [PATCH] x86/topology: Fix multiple packages shown on a single-package
 system

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

diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 132a2de44d2f..f7592814e5d5 100644
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

