Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F9F60E414
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiJZPGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbiJZPGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:06:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECD010AC2D
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:06:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BFDF61F58
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E14C433C1;
        Wed, 26 Oct 2022 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796791;
        bh=k6G87COw+uyFLg3dCCR8jPqhMldMmlqFDnxgTHHVleY=;
        h=Subject:To:Cc:From:Date:From;
        b=JuLdds6I14avNCXo3fi/x6VbKq4eyiutMpGc9iZpRu0fsKDlk8FBQIO+XQJOUU2gI
         eKrasjdCqujAYRiOOwzEvtqDmqVvDypOLimv2/xNKym7EH1BtWvW9D7DTNGsa063tD
         6YM0tNttAHtqvN0osg2D0yVykVgVGWXjDzsNPK0U=
Subject: FAILED: patch "[PATCH] x86/resctrl: Fix min_cbm_bits for AMD" failed to apply to 5.10-stable tree
To:     babu.moger@amd.com, bp@suse.de, eranian@google.com,
        fenghua.yu@intel.com, james.morse@arm.com, mingo@kernel.org,
        reinette.chatre@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:06:29 +0200
Message-ID: <1666796789102181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

67bf6493449b ("x86/resctrl: Fix min_cbm_bits for AMD")
2b8dd4ab65da ("x86/resctrl: Calculate the index from the configuration type")
2e7df368fc92 ("x86/resctrl: Apply offset correction when config is staged")
f07e9d025057 ("x86/resctrl: Add a helper to read a closid's configuration")
2e6678195d59 ("x86/resctrl: Rename update_domains() to resctrl_arch_update_domains()")
75408e43509e ("x86/resctrl: Allow different CODE/DATA configurations to be staged")
e8f7282552b9 ("x86/resctrl: Group staged configuration into a separate struct")
1c290682c0c9 ("x86/resctrl: Pass the schema to resctrl filesystem functions")
eb6f31876941 ("x86/resctrl: Add resctrl_arch_get_num_closid()")
3183e87c1b79 ("x86/resctrl: Store the effective num_closid in the schema")
331ebe4c4349 ("x86/resctrl: Walk the resctrl schema list instead of an arch list")
208ab16847c5 ("x86/resctrl: Label the resources with their configuration type")
f2594492308d ("x86/resctrl: Pass the schema in info dir's private pointer")
cdb9ebc91784 ("x86/resctrl: Add a separate schema list for resctrl")
792e0f6f789b ("x86/resctrl: Split struct rdt_domain")
63c8b1231929 ("x86/resctrl: Split struct rdt_resource")
fd2afa70eff0 ("x86/resctrl: Fix kernel-doc in internal.h")
8ba27ae36b41 ("Merge tag 'x86_cache_for_v5.11' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 67bf6493449b09590f9f71d7df29efb392b12d25 Mon Sep 17 00:00:00 2001
From: Babu Moger <babu.moger@amd.com>
Date: Tue, 27 Sep 2022 15:16:29 -0500
Subject: [PATCH] x86/resctrl: Fix min_cbm_bits for AMD

AMD systems support zero CBM (capacity bit mask) for cache allocation.
That is reflected in rdt_init_res_defs_amd() by:

  r->cache.arch_has_empty_bitmaps = true;

However given the unified code in cbm_validate(), checking for:

  val == 0 && !arch_has_empty_bitmaps

is not enough because of another check in cbm_validate():

  if ((zero_bit - first_bit) < r->cache.min_cbm_bits)

The default value of r->cache.min_cbm_bits = 1.

Leading to:

  $ cd /sys/fs/resctrl
  $ mkdir foo
  $ cd foo
  $ echo L3:0=0 > schemata
    -bash: echo: write error: Invalid argument
  $ cat /sys/fs/resctrl/info/last_cmd_status
    Need at least 1 bits in the mask

Initialize the min_cbm_bits to 0 for AMD. Also, remove the default
setting of min_cbm_bits and initialize it separately.

After the fix:

  $ cd /sys/fs/resctrl
  $ mkdir foo
  $ cd foo
  $ echo L3:0=0 > schemata
  $ cat /sys/fs/resctrl/info/last_cmd_status
    ok

Fixes: 316e7f901f5a ("x86/resctrl: Add struct rdt_cache::arch_has_{sparse, empty}_bitmaps")
Co-developed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: James Morse <james.morse@arm.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/lkml/20220517001234.3137157-1-eranian@google.com

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index de62b0b87ced..3266ea36667c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -66,9 +66,6 @@ struct rdt_hw_resource rdt_resources_all[] = {
 			.rid			= RDT_RESOURCE_L3,
 			.name			= "L3",
 			.cache_level		= 3,
-			.cache = {
-				.min_cbm_bits	= 1,
-			},
 			.domains		= domain_init(RDT_RESOURCE_L3),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -83,9 +80,6 @@ struct rdt_hw_resource rdt_resources_all[] = {
 			.rid			= RDT_RESOURCE_L2,
 			.name			= "L2",
 			.cache_level		= 2,
-			.cache = {
-				.min_cbm_bits	= 1,
-			},
 			.domains		= domain_init(RDT_RESOURCE_L2),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -836,6 +830,7 @@ static __init void rdt_init_res_defs_intel(void)
 			r->cache.arch_has_sparse_bitmaps = false;
 			r->cache.arch_has_empty_bitmaps = false;
 			r->cache.arch_has_per_cpu_cfg = false;
+			r->cache.min_cbm_bits = 1;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_THRTL_BASE;
 			hw_res->msr_update = mba_wrmsr_intel;
@@ -856,6 +851,7 @@ static __init void rdt_init_res_defs_amd(void)
 			r->cache.arch_has_sparse_bitmaps = true;
 			r->cache.arch_has_empty_bitmaps = true;
 			r->cache.arch_has_per_cpu_cfg = true;
+			r->cache.min_cbm_bits = 0;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_BW_BASE;
 			hw_res->msr_update = mba_wrmsr_amd;

