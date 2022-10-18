Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DE3603296
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 20:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiJRSdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 14:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiJRSda (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 14:33:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF9592F4D;
        Tue, 18 Oct 2022 11:33:29 -0700 (PDT)
Date:   Tue, 18 Oct 2022 18:33:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666118007;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OihPMiKVELepnv0d7mM9CftjYYmlVBfAzDFr5gnTDT4=;
        b=s2hnfA258KFhfzqjYv4B9nitocayaZQveSUo2Pdtp7TkGe5l33DbPDbFVCRPdlL00IxMGv
        tHYmgHRZZtIGs12Zn1mszu764zCemum7I4sY9J2bZbGg0v8bwt5DKwakMCtZAcfE/AEAJM
        D9OjmLJzLyALeE0q0DxJDUUdbUWw74Cx4gX5GhQo3J/E3rJBIFrjFZgeJNy2GBZ9DCM/jj
        MlmJCh3rLr4VGz7ziVNBJA/4J7s11FZ5fYz1ftbUrsscj+T8k2jrqT0KHwWAIv/8ieDwcy
        vnwYwqSZPVbwWo7hwB/4L+G0ceSEk+8AIfSMlLz1B9MtMAaxuUP31OlyyhxLNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666118007;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OihPMiKVELepnv0d7mM9CftjYYmlVBfAzDFr5gnTDT4=;
        b=1mXBJ9ZDa++hoYHm2YnXjMugch/lkPmN32EwBQWVcaJjh0/8oh6GPX3bpQ+fBVfaXlUvfM
        zV5oy2SdQf+qjwBQ==
From:   "tip-bot2 for Babu Moger" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Fix min_cbm_bits for AMD
Cc:     Stephane Eranian <eranian@google.com>,
        Babu Moger <babu.moger@amd.com>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        James Morse <james.morse@arm.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220517001234.3137157-1-eranian@google.com>
References: <20220517001234.3137157-1-eranian@google.com>
MIME-Version: 1.0
Message-ID: <166611800590.401.16546341652646846860.tip-bot2@tip-bot2>
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

Commit-ID:     67bf6493449b09590f9f71d7df29efb392b12d25
Gitweb:        https://git.kernel.org/tip/67bf6493449b09590f9f71d7df29efb392b12d25
Author:        Babu Moger <babu.moger@amd.com>
AuthorDate:    Tue, 27 Sep 2022 15:16:29 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 18 Oct 2022 20:25:16 +02:00

x86/resctrl: Fix min_cbm_bits for AMD

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
---
 arch/x86/kernel/cpu/resctrl/core.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index de62b0b..3266ea3 100644
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
