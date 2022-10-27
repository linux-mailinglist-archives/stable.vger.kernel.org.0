Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448D160FE0E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbiJ0RBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbiJ0RBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:01:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A03193469
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:01:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24002B8271A
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756CBC433C1;
        Thu, 27 Oct 2022 17:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890098;
        bh=ywL33qZItllB0cMnef9dhGze3pM9dYzaYuQO0eR+CS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXLlPnjkieV71yIMtPzRIn60+HU3GfngKinkMQ1QMp6v7YO3XQXxN6H4e61DEdV8X
         JSzjPIAcwDY5pLZ55NAvBEvn3+BJQj8+J8Qn3I1twIi5nKLku2QM1KkN5dMT9tqr9t
         vAViscXgEvAIR/BIBhcR3Ias/HCnibJS0DyZ8y4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stephane Eranian <eranian@google.com>,
        Babu Moger <babu.moger@amd.com>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        James Morse <james.morse@arm.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 5.15 21/79] x86/resctrl: Fix min_cbm_bits for AMD
Date:   Thu, 27 Oct 2022 18:55:19 +0200
Message-Id: <20221027165055.667051644@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Babu Moger <babu.moger@amd.com>

commit 67bf6493449b09590f9f71d7df29efb392b12d25 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/core.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -66,9 +66,6 @@ struct rdt_hw_resource rdt_resources_all
 			.rid			= RDT_RESOURCE_L3,
 			.name			= "L3",
 			.cache_level		= 3,
-			.cache = {
-				.min_cbm_bits	= 1,
-			},
 			.domains		= domain_init(RDT_RESOURCE_L3),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -83,9 +80,6 @@ struct rdt_hw_resource rdt_resources_all
 			.rid			= RDT_RESOURCE_L2,
 			.name			= "L2",
 			.cache_level		= 2,
-			.cache = {
-				.min_cbm_bits	= 1,
-			},
 			.domains		= domain_init(RDT_RESOURCE_L2),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -877,6 +871,7 @@ static __init void rdt_init_res_defs_int
 			r->cache.arch_has_sparse_bitmaps = false;
 			r->cache.arch_has_empty_bitmaps = false;
 			r->cache.arch_has_per_cpu_cfg = false;
+			r->cache.min_cbm_bits = 1;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_THRTL_BASE;
 			hw_res->msr_update = mba_wrmsr_intel;
@@ -897,6 +892,7 @@ static __init void rdt_init_res_defs_amd
 			r->cache.arch_has_sparse_bitmaps = true;
 			r->cache.arch_has_empty_bitmaps = true;
 			r->cache.arch_has_per_cpu_cfg = true;
+			r->cache.min_cbm_bits = 0;
 		} else if (r->rid == RDT_RESOURCE_MBA) {
 			hw_res->msr_base = MSR_IA32_MBA_BW_BASE;
 			hw_res->msr_update = mba_wrmsr_amd;


